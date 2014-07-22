From: Ron Leach <ronleach@tesco.net>
Subject: Booting after Debian upgrade: /dev/md5 does not exist
Date: Tue, 22 Jul 2014 09:09:29 +0100
Message-ID: <53CE1C39.3070000@tesco.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

List, good morning,

After updating a 2 x 2TB RAID1 server from Debian Lenny to Debian 
Squeeze today (first stage of 2-stage process to upgrade to current 
Debian stable, Wheezy), boot sequence stops with a warning that 
/dev/md5 does not exist. (7 partitions; /dev/md5 is mounted on /home; 
md0 to md4 exist and mount ok, and so does md6; mdstat shows them 
synchronised.)

There's background.  Some time ago, we had a drive failure and tried a 
repair by inserting a new disc and 'dd'-ing the existing disc in order 
to replicate the partition structures.  That was the wrong thing to 
do, mdadm became very active and tried to repair itself during the dd 
operation, so I cancelled the dd, quickly.  Removed that disc, ran in 
crippled-mode copying all the data off the system and took the machine 
offline.  (Data is safe, and running on a new, separate, RAID 1 
server.)  In the meantime, mdadm had recovered itself from the dd-ing 
problems but in so doing had named the original /dev/md5 partition 
/dev/md126 (there was a thread about similar md numbers a few months 
ago).  It seemed happy, even though mdadm.conf still referred to 
/dev/md5, while fstab referred to /dev/md126; I never understood how, 
or why, but it ran.  Finally repaired the RAID1 by inserting another 
new disc, using gdisk, this time, to replicate the partitions, and 
repairing each md(x) one at a time, adding sdb(n) as appropriate.  The 
RAID1 was now operating, prior to the Debian upgrade.

Applying the upgrade to Squeeze, the new mdadm says that /dev/md5 does 
not exist.  I changed the fstab entry to refer to /dev/md5, to match 
/etc/mdadm.conf, but booting still stops.  I can continue the boot, 
but without /home, nevertheless I can do maintenance and package 
installations etc.

Is there another data file somewhere I need to repair so that mdadm 
sees /dev/md5 and starts that array?

Here's mdadm.conf

D5s2:/# cat /etc/mdadm/mdadm.conf
# mdadm.conf
#
# Please refer to mdadm.conf(5) for information about this file.
#

# by default, scan all partitions (/proc/partitions) for MD superblocks.
# alternatively, specify devices to scan, using wildcards if desired.
DEVICE partitions

# auto-create devices with Debian standard permissions
CREATE owner=root group=disk mode=0660 auto=yes

# automatically tag new arrays as belonging to the local system
HOMEHOST <system>

# instruct the monitoring daemon where to send mail alerts
MAILADDR root@systemdesk

# definitions of existing MD arrays
ARRAY /dev/md0 level=raid1 num-devices=2 
UUID=eb3b45e8:e1d73b1a:63042e90:fced6612
ARRAY /dev/md1 level=raid1 num-devices=2 
UUID=93a0b403:18aa4e20:f77b0142:25a55090
ARRAY /dev/md2 level=raid1 num-devices=2 
UUID=99104b71:9dd6cf88:e1a05948:57032dd7
ARRAY /dev/md3 level=raid1 num-devices=2 
UUID=5dbd5605:1d61cbaa:ac5c64ee:5356e8a9
ARRAY /dev/md4 level=raid1 num-devices=2 
UUID=725cfde4:114fef9a:4ed1ccad:18d72d44
ARRAY /dev/md5 level=raid1 num-devices=2 
UUID=5bad4c7c:780696f4:fbaacbb9:204d67b9
ARRAY /dev/md6 level=raid1 num-devices=2 
UUID=94171c8e:c47d18a8:c073121c:f9f222fe

# This file was auto-generated on Fri, 29 Jan 2010 16:06:38 +0000
# by mkconf $Id$
D5s2:/#

Another thought is that perhaps the uuid entry for /dev/md5 isn't 
correct, especially since the file is dated 2010 which was years 
before the disc problems.  I'm fairly sure that nothing has removed 
/dev/md5 or its underlying /dev/sda7 and /dev/sdb7, and it will 
contain all /home 's data, so I didn't want to initialise the array. 
I wondered whether there was some way I could define /dev/md5 using 
'sda/sdb' notation, if, perhaps, the uuid info is incorrect.

I'm assuming the filesystem isn't an issue; this machine is using XFS 
on all partitions.

Open to any suggestions, and I agree that locking dd away somewhere 
out of reach of the dangerously under-informed would be a good idea, 
for a start.

regards, Ron
