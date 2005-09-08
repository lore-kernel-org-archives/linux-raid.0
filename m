From: Ken Walker <ken.walker@manchester.ac.uk>
Subject: RE: my first raid disaster on reboot :o( update
Date: Thu, 8 Sep 2005 12:38:31 +0100
Message-ID: <60F5F1E2B94AD4119F0B00B0D0215FFF01A69F99@bsc.tt.umist.ac.uk>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I'm getting confused again.


I installed Debian 3.1 onto two SCSI drives set up as raid1.

I also set-up the four ide drives, during installation and set them as

/dev/md7 using /dev/hda,/dev/hdc
/dev/md8 using /dev/hab,/dev/hdd

both ext3

they started, and sync'd

on reboot, md7 and md8 didn't auto start.

so i created them again with

mdadm -C /dev/md7 -l1 -n2 /dev/hda /dev/hdc

this stared rebuilding.

then i did the same for md8

mdadm -C /dev/md8 -l1 -n2 /dev/hdb /dev/hdd

then i did 

mkfs.ext3 /dev/md7
mkfs.ext3 /dev/md8

I checked with Fdisk that they were all set as FD.

then i did

(i made a copy of the original mdadm.conf first.)

mdadm --detail -- scan > mdadm.conf


And on reboot only md0 would mount.


So i copied the original mdadm.conf back and rebooted, and all the raids
apart from md7 and md8 started.

I noticed at the top of the original mdadm.conf i had the following

DEVICE partitions

so i did

mdadm --detail -- scan > mdadm.conf

again, with md7 and md8 running and rebooted.

adding 

DEVICE partitions

back to the top

The system booted up but again without md7 or md8, it did its corrupt
superblock or ext2 file system complaints.


But I'm getting confused, 

because, on

http://www.linuxdevcenter.com/pub/a/linux/2002/12/05/RAID.html


which is where i got the 

mdadm --detail -- scan > mdadm.conf

from, 

the example he gives

DEVICE	/dev/sdb1 /dev/sdc1
ARRAY 	/dev/md0 level=raid0 num-devices=2
UUID=410a299e:4cdd535e:169d3df4:48b7144a

is the other way round in my mdadm.conf file, i have

ARRAY 	/dev/md0 level=raid0 num-devices=2
UUID=410a299e:4cdd535e:169d3df4:48b7144a
DEVICE	/dev/sdb1 /dev/sdc1

Which way round should it be?


I have also read that a mdadm.conf file isn't really needed, but can be
helpful, if i hide me mdadm.conf file will the system boot with md7 and md8.

I do have those two raids in my fstab file at the end as

/dev/md7	/Cad100	ext3	defaults  0 2
/dev/md8	/Cad200	ext3	defaults  0 2


Can anybody help :o(

Ken

-----Original Message-----
From: Ken Walker [mailto:ken.walker@manchester.ac.uk]
Sent: 06 September 2005 2:26 pm
To: linux-raid@vger.kernel.org
Subject: my first raid disaster on reboot :o(


I've got debian 3.1, kernel 2.6 installed on a machine with two 9.1g SCSI
and 4 160g IDE's.

The SCSI is split up into /  /usr  /var  /swap  /tmp  and /home, each set as
a raid1.

The IDE's are set up as raid1 on the ide channels, such that hda is mirrored
with hdc and hdb is mirrored with hdd.

I had to move the system today so powered down with shutdown -h now.

On reboot i just get / mounted ( i think ) and everything else says mdx
corrupt superblock or such and not a valid ext2 fs.

all the mirrors were set us as ext3 and when it was up and running
/proc/mdstat said all was well.

/etc/fstab has all the raids present.


I'm kinda stuck as to where to start.


Could anybody point me in the right direction please.

many thanks

Ken
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
