From: Andras Tantos <andras@tantosonline.com>
Subject: Re: How to recover after md crash during reshape? - SOLVED/SUMMARY
Date: Tue, 3 Nov 2015 15:42:34 -0800
Message-ID: <5639466A.9050109@tantosonline.com>
References: <04cdcd6bd69b3aa1f8f24465f8485c90@tantosonline.com>
 <5626464D.9000502@turmel.org>
 <3baf849321d819483c5d20c005a31844@tantosonline.com>
 <562660EE.9020504@turmel.org>
 <72dc24dd30c19517d19887d794fd341b@tantosonline.com>
 <562D5F91.5040300@turmel.org> <5630F862.5040308@tantosonline.com>
 <5630FB05.5070902@turmel.org> <56325086.4060104@tantosonline.com>
 <5633B2F0.9010902@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5633B2F0.9010902@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>
Cc: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Thank you all who helped me solve my problem, especially Phil Turmel, 
who I am in dept for the rest of my live. Right now my family photos - 
and my marriage - are safe.

For people, who might be interested in the future, here's a quick 
summary of the events and the recovery:

Trouble:
==========

Was going to extend RAID6 array from 7 disks to 10. Array reshape 
crashed early in the process. After reboot, the array wouldn't 
re-assemble with error message:

     mdadm: WARNING /dev/sda and /dev/sda1 appear to have very similar
     superblocks.
           If they are really different, please --zero the superblock on one
           If they are the same or overlap, please remove one from the
           DEVICE list in mdadm.conf.

What I SHOULD have done here is to remove SDA from the DEVICE list in 
mdadm.conf followed by mdadm --grow --continue /dev/md1 --backup-file .....
What I did is to zero the superblock of SDA1.

The same message appeard for the other two new HDDs in the array as 
well. By the time I zeroed the super blocks of all three new disks the 
array assembled but didn't start because it was missing three drives.

Recovery:
===========
1. Look at the partitions listed in /proc/mdstat for the array.
2. For each of the constituents of the array, do mdadm -E <disk name 
from the array>
3. Note all the parameters, especially these: 'Chunk Size', 'Raid 
Level', 'Version'
4. Make sure all remaining disks show the same event count ('Events') 
and they have correct checksum and all the above parameters match.
5. Note the order of the disks in the array. You can find that in this line:

            Number   Major   Minor   RaidDevice State
      this     6       8       98        6      active sync

6. If all matches, stop the array:
     mdadm --stop /dev/md1

7. Re-create your array as follows:
     mdadm --create --assume-clean --verbose \
         --metadata=1.0 --raid-devices=7 --chunk=64 --level=6 \
         /dev/md1 <list of devices in the exact order from note 5 above>

     Replace number of devices, chunk size and raid level from note 3 
above. For me, I had do specify metadata version 0.9, which was my 
original metadata version (as reported by the 'Version' parameter in 
point 3 above). YMMV.

8. If all goes well, the array will now re-assemble with the original 7 
disks. The data on the array is corrupted up to the point where the 
reshape stopped, so...
9. fsck -n /dev/md1 to assess the damage. If doesn't look terrible, fix 
the errors: fsck -y /dev/md1.
10. Mount the array rejoice in the data that's recovered.

Final notes:
===============
I still don't know the root cause of the crash. What I did notice is 
that this particular (Core2 duo) system seems to become unstable with 
more than 9 HDDs. It doesn't seem to be a power supply issue as it has 
trouble even if about half of the drives are supplied from a second PSU.

Version 0.9 metadata has some problems, causing the misleading message 
in the first place. Upgrading to version 1.0 metadata is a good idea.

If you use desktop or green drives in your array, fix the short kernel 
timeout on SATA devices (30s). Issue this on every boot:
     for x in /sys/block/*/device/timeout ; do echo 180 > $x ; done
If you don't do that, the first unrecoverable read error will degrade 
your array instead of simply relocating the failing sector on the hard 
drive.

To find and fix unrecoverable read errors on your array, regularly issue:
     echo check >/sys/block/md0/md/sync_action
This is a looooong operation on a large RAID6 array, but makes sure that 
bad sectors don't accumulate in seldom-accessed corners and destroy your 
array at the worst possible time.

Andras

