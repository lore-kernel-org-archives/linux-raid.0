From: Max Waterman <davidmaxwaterman@fastmail.co.uk>
Subject: raidreconfig advice
Date: Sat, 12 Mar 2005 17:21:32 +0800
Message-ID: <4232B49C.6080306@fastmail.co.uk>
Reply-To: mwaterman@jingmei.org
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

OK, I am going to try to expand the capacity of my raid5 array and I 
want to make sure I've got it right.

So, first thing to check is that they are identical drives. I figure 
fdisk is enough :

foreach disk ( `cat /proc/diskstats | perl -ne '{ /((hd|sd)[a-z])\s+/; 
print "$1\n" if ( $1 ) }'` )
foreach? /sbin/fdisk -l /dev/$disk
foreach? end

Disk /dev/hda: snip...

Disk /dev/hdg: 200.0 GB, 200049647616 bytes
255 heads, 63 sectors/track, 24321 cylinders
Units = cylinders of 16065 * 512 = 8225280 bytes

Disk /dev/hdg doesn't contain a valid partition table

Disk /dev/hdi: 200.0 GB, 200049647616 bytes
255 heads, 63 sectors/track, 24321 cylinders
Units = cylinders of 16065 * 512 = 8225280 bytes

Disk /dev/hdi doesn't contain a valid partition table

Disk /dev/hdk: 200.0 GB, 200049647616 bytes
255 heads, 63 sectors/track, 24321 cylinders
Units = cylinders of 16065 * 512 = 8225280 bytes

Disk /dev/hdk doesn't contain a valid partition table

Disk /dev/sda: 200.0 GB, 200049647616 bytes
255 heads, 63 sectors/track, 24321 cylinders
Units = cylinders of 16065 * 512 = 8225280 bytes

Disk /dev/sda doesn't contain a valid partition table

Disk /dev/sdb: 200.0 GB, 200049647616 bytes
255 heads, 63 sectors/track, 24321 cylinders
Units = cylinders of 16065 * 512 = 8225280 bytes

Disk /dev/sdb doesn't contain a valid partition table

Disk /dev/sdc: 200.0 GB, 200049647616 bytes
255 heads, 63 sectors/track, 24321 cylinders
Units = cylinders of 16065 * 512 = 8225280 bytes

Disk /dev/sdc doesn't contain a valid partition table

Disk /dev/sdd: 200.0 GB, 200049647616 bytes
255 heads, 63 sectors/track, 24321 cylinders
Units = cylinders of 16065 * 512 = 8225280 bytes

Disk /dev/sdd doesn't contain a valid partition table
[mwaterman@localhost /proc]$

My current RAID5 is on hd[gik] (hdm is RMAd), plus /dev/sdd as a spare.

I have sd[ab] as a RAID0 containing a backup.

This leaves me with sdc which I can try to add. If that goes OK, I'll 
trash the backup and add sd[ab] too.

1) Do the disks look identical (they're all WD2000, but some are PATA 
and some SATA).

2) Where do I get raidreconfig from? Google wasn't much help.

3) Are there any instructions for raidreconfig? I understand is uses 
some non-mdadm config files as from/to input.

4) I use xfs. Has anyone used xfs_growfs?

Thanks.

Max.
