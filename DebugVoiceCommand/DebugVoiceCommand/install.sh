#!/bin/sh

#  install.sh
#  DebugVoiceCommand
#
#  Created by Sachin on 15/10/15.
#  Copyright © 2015 Sachin. All rights reserved.


#!/bin/sh

DOWNLOAD_URI=https://github.com/
PLUGINS_DIR="${HOME}/Library/Application Support/Developer/Shared/Xcode/Plug-ins"

mkdir -p "${PLUGINS_DIR}"
curl -L $DOWNLOAD_URI | tar xvz -C "${PLUGINS_DIR}"

echo "Regards,Sachin Thakur.  Thanks for intalling successfully!!!   Please restart your Xcode."
