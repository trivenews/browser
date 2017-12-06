.PHONY: bundle dev release

bundle:
	rm -rf bundle
	mkdir bundle
	pub build
	cp -r build bundle/
	cp -r images bundle/
	cp background.js bundle/
	cp main.css bundle/
	cp manifest.json bundle/

dev: bundle
	sed -i 's/"Trive (Local)"/"Trive (Dev)"/' bundle/manifest.json
	rm -f trive-dev.zip
	cd bundle && zip ../trive-dev.zip -r *

release: bundle
	sed -i 's/"Trive (Local)"/"Trive"/' bundle/manifest.json
	rm -f trive-release.zip
	cd bundle && zip ../trive-release.zip -r *
