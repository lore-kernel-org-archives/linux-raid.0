From: Sebastian Riemer <sebastian.riemer@profitbricks.com>
Subject: Assemble-Resize-Stop loop doesn't work correctly
Date: Tue, 09 Oct 2012 17:57:59 +0200
Message-ID: <50744987.8010903@profitbricks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Linux RAID <linux-raid@vger.kernel.org>, Sebastian Riemer <sebastian.riemer@profitbricks.com>
List-Id: linux-raid.ids

Hi Neil,

I've tested with the following script grow with "--assume-clean" in a
loop. The first grow succeeds - following grows fail - mdadm 3.2.5,
kernel 3.4.10.


#!/bin/bash

FIRST="/dev/sda"
SECON="/dev/sdd"
MDDEV="/dev/md0"
SIZE=1

mdadm --zero-superblock $FIRST
mdadm --zero-superblock $SECON
echo y | mdadm -C $MDDEV -e 1.2 \
--assume-clean -z "${SIZE}G" --force -l 1 -n 2 $FIRST $SECON
sleep 3
mdadm -S $MDDEV
for ((i=0; i<4; i++)); do
  mdadm -A $MDDEV $FIRST $SECON
  let "SIZE++"
  mdadm -G $MDDEV -z ${SIZE}G --assume-clean
  cat /proc/mdstat
#  mdadm -D $MDDEV > /dev/null
  mdadm -S $MDDEV
done


Output looks like this:

mdadm: /dev/md0 has been started with 2 drives.
mdadm: component size of /dev/md0 has been set to 2097152K
Personalities : [raid1]
md0 : active raid1 sda[0] sdd[1]
      2097152 blocks super 1.2 [2/2] [UU]
     
unused devices: <none>
mdadm: stopped /dev/md0
mdadm: /dev/md0 has been started with 2 drives.
mdadm: /dev/md0 is performing resync/recovery and cannot be reshaped
Personalities : [raid1]
md0 : active raid1 sda[0] sdd[1]
      2097152 blocks super 1.2 [2/2] [UU]
      [==========>..........]  resync = 50.0% (1050624/2097152)
finish=8.4min speed=2048K/sec


Now the output with "Detail"-Mode after resize:

mdadm: /dev/md0 has been started with 2 drives.
mdadm: component size of /dev/md0 has been set to 2097152K
Personalities : [raid1]
md0 : active raid1 sda[0] sdd[1]
      2097152 blocks super 1.2 [2/2] [UU]
     
unused devices: <none>
mdadm: stopped /dev/md0
mdadm: /dev/md0 has been started with 2 drives.
mdadm: component size of /dev/md0 has been set to 3145728K
Personalities : [raid1]
md0 : active raid1 sda[0] sdd[1]
      3145728 blocks super 1.2 [2/2] [UU]


This one works. Is this wanted behaviour?

Cheers,
Sebastian
