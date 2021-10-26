#!/usr/bin/env bash

# Enable debugging
#set -x

# Print the user we're currently running as
echo "Running as user: $(whoami)"

# FactoryGame includes a 64-bit version of steamclient.so, so we need to tell the OS where it exists
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/steamcmd/fg/linux64

# Define the install/update function
install_or_update()
{
	# Install FactoryGame from install.txt
	echo "Installing/updating FactoryGame.. (this might take a while, be patient)"
	/steamcmd/steamcmd.sh +runscript /app/install.txt

	# Terminate if exit code wasn't zero
	if [ $? -ne 0 ]; then
		echo "Exiting, steamcmd install or update failed!"
		exit 1
	fi
}

# Check which branch to use
if [ ! -z ${FG_BRANCH+x} ]; then
	echo "Using branch arguments: $FG_BRANCH"

	# Add "-beta" if necessary
	INSTALL_BRANCH="${FG_BRANCH}"
	if [ ! "$FG_BRANCH" == "public" ]; then
		INSTALL_BRANCH="-beta ${FG_BRANCH}"
	fi
	sed -i "s/app_update 1690800.*validate/app_update 1690800 $INSTALL_BRANCH validate/g" /app/install.txt
else
	sed -i "s/app_update 1690800.*validate/app_update 1690800 validate/g" /app/install.txt
fi

# Install/update steamcmd
echo "Installing/updating steamcmd.."
curl -s http://media.steampowered.com/installer/steamcmd_linux.tar.gz | bsdtar -xvf- -C /steamcmd

# Disable auto-update if start mode is 2
if [ "$FG_START_MODE" = "2" ]; then
	# Check that FactoryGame exists in the first place
	if [ ! -f "/steamcmd/fg/FactoryServer.sh" ]; then
		install_or_update
	else
		echo "FactoryGame seems to be installed, skipping automatic update.."
	fi
else
	install_or_update
fi

# Start mode 1 means we only want to update
if [ "$FG_START_MODE" = "1" ]; then
	echo "Exiting, start mode is 1.."
	exit
fi

# Set the working directory
cd /steamcmd/fg

# Run the server
/steamcmd/fg/FactoryServer.sh ${FG_SERVER_STARTUP_ARGUMENTS}