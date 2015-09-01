From: "David C. Rankin" <drankinatty@suddenlinkmail.com>
Subject: Re-add of raid1 drive resulted in strange loss of data on Archlinux?
Date: Tue, 01 Sep 2015 00:00:09 -0500
Message-ID: <55E530D9.5090006@suddenlinkmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: mdraid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

All,

   Here is one I cannot explain. This is a follow-on from the thread "How best 
to re-sync raid1 array? zero superblock on removed disk and let it rebuild?" 
posted 8/28.

   By way of brief background, after moving disks to a highpoint raid controller 
to get around an on-board controller failure, all arrays were OK. On a 
subsequent reboot it was as if not attempt was made to activate sda7 and the 
root partition was operating in degraded mode on sdb7 alone. The consensus was 
to fail, remove then --add the device and allow it to re-sync. All worked perfectly.

   The problem: After brining sda7 back into the array, several routine updates 
were done and the system was rebooted. The system found grub, began to boot, 
then crashed "file not found /usr/lib/libkmod.so" -- Huh? (this is with mdadm 
3.3.2-2)

   Boot the fallback image - same result. Huh? - again. Checking files in 
/usr/lib - sure enough there were a number of libraries that were '0' byte 
files. (libkmod.so being one of them) Attempting to locate the packages they 
belonged to also failed as the package manager had lost all reference to what 
package owned the missing files?

   Attempts to query the package manager database to simply list the files 
associated with packages updated while operating in degraded mode showed the 
packages queried to have no associated file. Big Huh?? For example, for those 
familiar with Archlinux pacman package manager:

   # pacman -Ql unixodbc
   #

would list the package as providing no files. This was completely bewildering. 
It was like all updates during degraded mode were lost leaving the disks after 
re-sync not knowing where or what files were associated with which packages, and 
showing all libraries updated in degraded mode as "empty"? (0 bytes).

   I have no clue how this can happen. But thinking through the situation, the 
only thing that made any sense would be if when re-adding sda7 to the md1 array, 
the sync worked the wrong way, updating the good sdb7 to the state of the 
re-added sda7 instead of vice-versa??? Is this even possible?

   When sda7 was re-added to the system, it was fully allowed to sync before any 
additional updates or reboots, so whatever took place that caused the issue, 
took place during the re-add. After re-sync, I did scrub the array with ' echo 
check > /sys/block/md1/md/sync_action', but I can't see how that would have 
cause the loss? Further, when booting to the install media, and during all 
subsequent reboots, md1 came up correctly with both sda7 and sdb7 active in the 
array. So I'm stumped...

   Have there ever been other similar reports? If so, can anyone suggest how 
this could have happened? I would really like to avoid a repeat. (thankfully 
forcing re-install of all packages updated during degraded mode fixed the most 
of the missing files and libraries) There were some 440 libraries that were 0-bytes.

   What say the experts? Any idea how something like this can occur? Any 
suggestions as to what to check to attempt to confirm/rule-out what happened?

   Thanks for any help you can provide. (all up and running well again)

Personalities : [raid1]
md1 : active raid1 sda7[2] sdb7[1]
       52396032 blocks super 1.2 [2/2] [UU]

md3 : active raid1 sda6[0] sdb6[1]
       1047552 blocks super 1.2 [2/2] [UU]

md0 : active raid1 sdb5[1] sda5[0]
       204608 blocks super 1.2 [2/2] [UU]

md2 : active raid1 sdb8[1] sda8[0]
       922944192 blocks super 1.2 [2/2] [UU]
       bitmap: 0/7 pages [0KB], 65536KB chunk

unused devices: <none>


-- 
David C. Rankin, J.D.,P.E.
