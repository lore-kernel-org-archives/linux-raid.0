From: Jonathan Brassow <jbrassow@redhat.com>
Subject: Re: Scrubbing "check" not working for RAID10 in 3.10-rc1+
Date: Mon, 15 Jul 2013 10:40:49 -0500
Message-ID: <1373902849.31715.4.camel@f16>
References: <1372141160.2016.0.camel@f16>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-0nzkr3TQd5bJYSBwn4nH"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1372141160.2016.0.camel@f16>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--=-0nzkr3TQd5bJYSBwn4nH
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit

Neil,

You will need to change 'devices' to suite your needs.  I can run this
test with RAID 1/4/5/6 and it works, but it fails with RAID10 since
10-rc1.

thanks,
 brassow

example output:
[~]# ./md.sh 1
mdadm: /dev/sda1 appears to be part of a raid array:
    level=raid5 devices=4 ctime=Sat Jul 13 14:52:49 2013
mdadm: Note: this array has metadata at the start and
    may not be suitable as a boot device.  If you plan to
    store '/boot' on this device please ensure that
    your boot-loader understands md/v1.x metadata, or use
    --metadata=0.90
mdadm: /dev/sdb1 appears to be part of a raid array:
    level=raid5 devices=4 ctime=Sat Jul 13 14:52:49 2013
mdadm: /dev/sdc1 appears to be part of a raid array:
    level=raid5 devices=4 ctime=Sat Jul 13 14:52:49 2013
mdadm: /dev/sdd1 appears to be part of a raid array:
    level=raid5 devices=4 ctime=Sat Jul 13 14:52:49 2013
mdadm: largest drive (/dev/sda1) exceeds size (102400K) by more than 1%
Continue creating array? y
mdadm: Defaulting to version 1.2 metadata
mdadm: array /dev/md0 started.
        Waiting for resync to complete
        Waiting for resync to complete
        Waiting for resync to complete
        Waiting for resync to complete
RAID1 mismatch count after creation     : 0
mdadm: stopped /dev/md0
Writing garbage to one of the MD devices...
mdadm: /dev/md0 has been started with 4 drives.
RAID1 mismatch count after reactivation : 0
        Waiting for check to complete
        Waiting for check to complete
        Waiting for check to complete
RAID1 mismatch count after data-check   : 61440
mdadm: stopped /dev/md0


[~]# ./md.sh 10
mdadm: /dev/sda1 appears to be part of a raid array:
    level=raid1 devices=4 ctime=Mon Jul 15 10:30:44 2013
mdadm: /dev/sdb1 appears to be part of a raid array:
    level=raid1 devices=4 ctime=Mon Jul 15 10:30:44 2013
mdadm: /dev/sdc1 appears to be part of a raid array:
    level=raid1 devices=4 ctime=Mon Jul 15 10:30:44 2013
mdadm: /dev/sdd1 appears to be part of a raid array:
    level=raid1 devices=4 ctime=Mon Jul 15 10:30:44 2013
mdadm: largest drive (/dev/sda1) exceeds size (102400K) by more than 1%
Continue creating array? y
mdadm: Defaulting to version 1.2 metadata
mdadm: array /dev/md0 started.
        Waiting for resync to complete
        Waiting for resync to complete
        Waiting for resync to complete
RAID10 mismatch count after creation     : 0
mdadm: stopped /dev/md0
Writing garbage to one of the MD devices...
mdadm: /dev/md0 has been started with 4 drives.
RAID10 mismatch count after reactivation : 0
        Waiting for check to complete
        Waiting for check to complete
        Waiting for check to complete
RAID10 mismatch count after data-check   : 0
mdadm: stopped /dev/md0
***** mismatch_cnt should not be zero !!!!!!


--=-0nzkr3TQd5bJYSBwn4nH
Content-Type: application/x-shellscript; name="md.sh"
Content-Disposition: attachment; filename="md.sh"
Content-Transfer-Encoding: 7bit

#!/bin/bash

#
# Devices used in test
#
devices=(/dev/sda1 /dev/sdb1 /dev/sdc1 /dev/sdd1)

# Device that will be overwritten with garbage
index=0

# Pull in all MD RAID modules and dm-raid
modprobe dm-raid

# RAID level must be specified
if [ -z $1 ]; then
	echo "$0 <raid-level>"
	exit 1
fi

# Select a device to be overwritten with garbage (default = 0)
if [ ! -z $2 ]; then
	index=$2
fi

# Create MD array
if ! mdadm --create /dev/md0 --level=$1 --raid-devices=4 --size=100M ${devices[*]}; then
	echo "Failed to create"
	exit 1
fi

# Wait for initial sync
while [ `cat /sys/block/md0/md/sync_action` != "idle" ]; do
	echo "	Waiting for `cat /sys/block/md0/md/sync_action` to complete"
	sleep 1
done

mdadm --misc -D /dev/md0 | grep state

echo -n "RAID$1 mismatch count after creation     : "
cat /sys/block/md0/md/mismatch_cnt

mdadm --stop /dev/md0

echo "Writing garbage to one of the MD devices..."
dd if=/dev/urandom of=${devices[$index]} bs=1M count=10 seek=50 >& /dev/null

mdadm --assemble /dev/md0 ${devices[*]}
mdadm --misc -D /dev/md0 | grep state

while [ `cat /sys/block/md0/md/sync_action` != "idle" ]; do
	echo "	Waiting for `cat /sys/block/md0/md/sync_action` to complete"
	sleep 1
done

echo -n "RAID$1 mismatch count after reactivation : "
cat /sys/block/md0/md/mismatch_cnt
echo "check" > /sys/block/md0/md/sync_action

while [ `cat /sys/block/md0/md/sync_action` != "idle" ]; do
	echo "	Waiting for `cat /sys/block/md0/md/sync_action` to complete"
	sleep 1
done

echo -n "RAID$1 mismatch count after data-check   : "
cat /sys/block/md0/md/mismatch_cnt

if [ `cat /sys/block/md0/md/mismatch_cnt` -eq 0 ]; then
	mdadm --stop /dev/md0
	echo "***** mismatch_cnt should not be zero !!!!!!"
	exit 1
fi

mdadm --stop /dev/md0

--=-0nzkr3TQd5bJYSBwn4nH--

