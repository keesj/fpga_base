#!/bin/bash
set -e
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.38.0/install.sh | bash
. ~/.nvm/nvm.sh
nvm install node npm
(
git clone --recurse-submodules https://github.com/sehugg/8bitworkshop.git
cd 8bitworkshop
npm install
npm run build
)
