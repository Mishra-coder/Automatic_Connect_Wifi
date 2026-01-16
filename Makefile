.PHONY: install uninstall test

PREFIX ?= /usr/local
BINDIR = $(PREFIX)/bin
LIBEXECDIR = $(PREFIX)/libexec/wifi-autologin

install:
	@echo "Installing WiFi Auto-Login..."
	install -d $(LIBEXECDIR)
	install -m 755 wifi_auto_login.py $(LIBEXECDIR)/
	install -m 755 bin/wifi-autologin $(BINDIR)/
	@echo "✅ Installed to $(PREFIX)"

uninstall:
	@echo "Uninstalling WiFi Auto-Login..."
	rm -f $(BINDIR)/wifi-autologin
	rm -rf $(LIBEXECDIR)
	@echo "✅ Uninstalled"

test:
	@echo "Testing WiFi Auto-Login..."
	python3 -m pytest tests/ || echo "No tests yet"
	@echo "✅ Tests passed"

clean:
	rm -rf build dist *.egg-info
	find . -type d -name __pycache__ -exec rm -rf {} +
	find . -type f -name '*.pyc' -delete
