#!/usr/bin/env python3

import keyring
import requests
import subprocess
import time
import logging
from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
from selenium.webdriver.chrome.service import Service
from selenium.webdriver.chrome.options import Options
from webdriver_manager.chrome import ChromeDriverManager
import os

SERVICE_NAME = "WiFi-AutoLogin-Newton"
PORTAL_URL = "http://portal-as.rujjienetworks.com"
CHECK_INTERVAL = 10
LOG_FILE = os.path.expanduser("~/Library/Logs/wifi-auto-login.log")

logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(levelname)s - %(message)s',
    handlers=[
        logging.FileHandler(LOG_FILE),
        logging.StreamHandler()
    ]
)

def is_wifi_connected():
    try:
        for interface in ['en0', 'en1']:
            result = subprocess.run(
                ['networksetup', '-getairportnetwork', interface],
                capture_output=True,
                text=True,
                timeout=5
            )
            if result.returncode == 0 and 'not associated' not in result.stdout.lower():
                return True
        return False
    except Exception as e:
        logging.error(f"WiFi check failed: {str(e)}")
        try:
            result = subprocess.run(
                ['ping', '-c', '1', '-W', '1', '8.8.8.8'],
                capture_output=True,
                timeout=2
            )
            return result.returncode == 0
        except:
            return False

def get_wifi_ssid():
    try:
        for interface in ['en0', 'en1']:
            result = subprocess.run(
                ['networksetup', '-getairportnetwork', interface],
                capture_output=True,
                text=True,
                timeout=5
            )
            if result.returncode == 0:
                output = result.stdout.strip()
                if 'Current Wi-Fi Network:' in output:
                    ssid = output.split('Current Wi-Fi Network:')[1].strip()
                    if ssid and 'not associated' not in ssid.lower():
                        return ssid
        return None
    except Exception as e:
        logging.error(f"Couldn't get WiFi name: {str(e)}")
        return None

def needs_portal_login():
    try:
        response = requests.get(
            'http://www.apple.com/library/test/success.html',
            timeout=5,
            allow_redirects=False
        )
        
        if response.status_code != 200 or 'Success' not in response.text:
            logging.info("Portal detected")
            return True
            
        if 'rujjienetworks' in response.url or response.status_code in [301, 302, 307]:
            logging.info("Got redirected to portal")
            return True
            
        return False
        
    except requests.exceptions.RequestException as e:
        logging.info(f"Network check failed: {str(e)}")
        return True

def get_credentials():
    try:
        username = keyring.get_password(SERVICE_NAME, "default_username")
        if not username:
            logging.error("No username found. Run 'wifi-autologin setup' first.")
            return None, None
        
        password = keyring.get_password(SERVICE_NAME, username)
        if not password:
            logging.error("No password found. Run 'wifi-autologin setup' first.")
            return None, None
        
        return username, password
        
    except Exception as e:
        logging.error(f"Failed to get credentials: {str(e)}")
        return None, None

def perform_login():
    logging.info("Attempting auto-login...")
    
    username, password = get_credentials()
    if not username or not password:
        logging.error("No credentials found")
        return False
    
    chrome_options = Options()
    chrome_options.add_argument("--headless")
    chrome_options.add_argument("--no-sandbox")
    chrome_options.add_argument("--disable-dev-shm-usage")
    chrome_options.add_argument("--disable-gpu")
    chrome_options.add_argument("--window-size=1920,1080")
    
    driver = None
    
    try:
        logging.info("Initializing browser...")
        driver = webdriver.Chrome(
            service=Service(ChromeDriverManager().install()),
            options=chrome_options
        )
        
        logging.info(f"Navigating to {PORTAL_URL}...")
        driver.get(PORTAL_URL)
        time.sleep(2)
        
        logging.info("Filling credentials...")
        username_field = WebDriverWait(driver, 10).until(
            EC.presence_of_element_located((By.NAME, "username"))
        )
        username_field.clear()
        username_field.send_keys(username)
        
        password_field = driver.find_element(By.NAME, "password")
        password_field.clear()
        password_field.send_keys(password)
        
        logging.info("Submitting...")
        login_button = driver.find_element(By.CSS_SELECTOR, "button[type='submit']")
        login_button.click()
        
        time.sleep(5)
        
        current_url = driver.current_url
        logging.info(f"Login completed. URL: {current_url}")
        
        if "portal-as" not in current_url:
            logging.info("Login successful!")
            return True
        else:
            logging.info(" Form submitted!")
            return True
        
    except Exception as e:
        logging.error(f"Login failed: {str(e)}")
        return False
        
    finally:
        if driver:
            driver.quit()

def main():
    logging.info("=" * 60)
    logging.info("WiFi Auto-Login Started")
    logging.info("=" * 60)
    logging.info(f"Log: {LOG_FILE}")
    
    last_ssid = None
    last_login_check = 0
    
    while True:
        try:
            if not is_wifi_connected():
                logging.debug("No WiFi")
                time.sleep(CHECK_INTERVAL)
                continue
            
            current_ssid = get_wifi_ssid()
            
            if current_ssid and current_ssid != last_ssid:
                logging.info(f"WiFi: {current_ssid}")
                last_ssid = current_ssid
            
            current_time = time.time()
            if current_time - last_login_check > 30:
                last_login_check = current_time
                
                if needs_portal_login():
                    logging.info("Portal login required")
                    success = perform_login()
                    
                    if success:
                        logging.info("Logged in!")
                    else:
                        logging.error("Failed")
                else:
                    logging.debug("Internet OK")
            
            time.sleep(CHECK_INTERVAL)
            
        except KeyboardInterrupt:
            logging.info("Stopped by user")
            break
            
        except Exception as e:
            logging.error(f"Error: {str(e)}")
            time.sleep(CHECK_INTERVAL)

if __name__ == "__main__":
    main()
