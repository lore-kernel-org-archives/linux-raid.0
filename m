From: Mike Hardy <mhardy@h3c.com>
Subject: raid5 test array creator (was Re: the dreaded double disk failure)
Date: Sat, 15 Jan 2005 14:52:39 -0800
Message-ID: <41E99EB7.5090302@h3c.com>
References: <200501130835.j0D8Z5902816@www.watkins-home.com> <41E89530.4000707@h3c.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------070404000106070808080101"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <41E89530.4000707@h3c.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This is a multi-part message in MIME format.
--------------070404000106070808080101
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit


Mike Hardy wrote:

> What I'm thinking of doing is writing a small (or, as small as possible, 
> anyway) perl program that can take a few command line arguments (like 
> the array construction information) and know how to read the data blocks 
> on the array, and calculate parity, as a baseline. If perl offends you, 
> sorry, I'm quicker at it than C by a long-shot, and I don't really care 
> about speed here, just speed of development.

Here's the shell script I'm using as a test harness. It creates a 
loopback raid5 system, fills it up with random data, and then takes the 
md5sum. It has a few modes of operation (to initialize or not as it 
starts or stops the array).

-Mike

--------------070404000106070808080101
Content-Type: application/x-sh;
 name="raid5_test_array.sh"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="raid5_test_array.sh"

#!/bin/bash

# There are 4 ways to call this script
#
# 1) "start clean"
#    - makes new disk files
#    - binds them to loop devices
#    - creates a new raid device
#    - makes a file system on the device
#    - mounts the file system
#    - copies random data to the device
#    - takes the md5sum of the data
# 2) "stop clean"
#    - unmounts the file system
#    - stops the raid device
#    - unbinds the loop devices
#    - removes the disk files
# 3) "start"
#    - starts the raid device
#    - mounts the filesystem
#    - takes the md5sum of the data
# 4) "stop"
#    - unmounts the file system
#    - stops the raid device


# These things are variable
export TESTDIR=/tmp/raid_test_drives;
export COMPONENTS_COUNT=8;
export COMPONENT_SIZE=5M;
export ARRAY_NAME=/dev/md0;

# Make sure we got an argument
if [ "$1" == "" ]; then
    echo "You must use either 'stop' or 'start' as an argument";
    exit;
fi

# See if we are stopping
if [ "$1" == "stop" ]; then
    echo "Stopping...";
    export STARTING=0;

else
    echo "Starting...";
    export STARTING=1;
fi

# See if we are supposed to do things cleanly
if [ "$2" == "clean" ]; then
    echo "    Cleaning on shutdown...";
    export CLEANING=1;
else
    export CLEANING=0;
fi


# If we're stopping, we need to stop the array first
if [ $STARTING == 0 ]; then

    echo "    Unmounting array...";
    umount "$TESTDIR/array";
    rmdir "$TESTDIR/array";

    echo "    Stopping kernel md device...";

    # Stop the raid array so we can deconstruct the components
    /sbin/mdadm --manage --stop $ARRAY_NAME;

else

    # Start building the component list
    export COMPONENT_LIST="";
fi



# For each component that's supposed to be in the array
for ((DRIVE=0; $DRIVE < $COMPONENTS_COUNT; DRIVE = $DRIVE+1)); do

    COMPONENT="$TESTDIR/disk$DRIVE";

    if [ $STARTING == 1 ]; then

	if [ $CLEANING == 1 ]; then
	    echo "    Creating disk component file $COMPONENT.img...";
	    echo "dd if=/dev/zero of=$COMPONENT.img bs=$COMPONENT_SIZE count=1";
	    dd if=/dev/zero of="$COMPONENT.img" bs="$COMPONENT_SIZE" count=1;

	    echo "    Creating loop device for disk component $COMPONENT.img...";
	    echo "losetup /dev/loop$DRIVE $COMPONENT.img";
	    losetup "/dev/loop$DRIVE" "$COMPONENT.img";
	fi

	export COMPONENT_LIST="$COMPONENT_LIST /dev/loop$DRIVE";
	
    else
	
	if [ $CLEANING == 1 ]; then
	    echo "    Removing loop device for disk component $COMPONENT.img ...";
	    echo "losetup -d /dev/loop$DRIVE";
	    losetup -d "/dev/loop$DRIVE";

	    echo "    Removing disk compoment $COMPONENT.img ...";
	    rm -f "$COMPONENT.img";
	fi

    fi

done


# If we're starting, create the kernel array, make a file system, and put data in it
if [ $STARTING == 1 ]; then

    if [ $CLEANING == 1 ]; then
	echo "    Creating kernel-level array...";
	/sbin/mdadm --create -l5 -n$COMPONENTS_COUNT $ARRAY_NAME $COMPONENT_LIST;

	echo "    Making file system...";
	/sbin/mke2fs -j -m1 $ARRAY_NAME;
    else
	echo "    Starting kernel-level array...";
	/sbin/mdadm --assemble $ARRAY_NAME $COMPONENT_LIST;
    fi

    echo "    Mounting file system...";
    mkdir "$TESTDIR/array"
    mount -t ext3 $ARRAY_NAME "$TESTDIR/array"

    if [ $CLEANING == 1 ]; then
	echo "    Copying random data to the array..."
	dd if=/dev/urandom of=$TESTDIR/array/testdata.dat
    fi

    echo "    Calculating checksum of random data..."
    md5sum $TESTDIR/array/testdata.dat > $TESTDIR/`date +%s`.md5sum

fi


echo "done.";

--------------070404000106070808080101--
