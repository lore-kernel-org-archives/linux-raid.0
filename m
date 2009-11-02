From: Ben DJ <bendj095124367913213465@gmail.com>
Subject: system update killed /boot RAID-1 array auto-assembly/mount. why?
Date: Mon, 2 Nov 2009 12:24:53 -0800
Message-ID: <babafd2f0911021224w6adf8453we7ba4f166102044f@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

I've installed OpenSuse 11.2 RC2 to

  /boot on  4-disk RAID-1, super=1.0
  /root  & (etc) on 4-disk RAID-10,f2 chunk=256, super=1.1

It's been running fine.

After a recent system upgrade via 'zypper dup', which completed
without any apparent error, reboot failed.  /boot @ /dev/md0 was not
mounting, and the RAID-1 wasn't even assembling.

A full day of reading, and trying various repair-the-array solutions
couldn't get me back.

Although I was able to manually mount the array, and it fsck'ed ok, I
couldn't get the array to auto-assemble.

Finally, I deleted the array, repartitioned the drive, reinstalled
kernel, grub and mdadm, and I'm back in business.  At the moment, the
RAID-10 array is resyncing (not sure why):

cat /proc/mdstat
 Personalities : [raid10] [raid0] [raid1] [raid6] [raid5] [raid4] [linear]
 md0 : active raid1 sda1[0] sdd1[3] sdc1[2] sdb1[1]
       160604 blocks super 1.0 [4/4] [UUUU]

 md1 : active raid10 sda2[0] sdd2[3] sdc2[2] sdb2[1]
       1953198080 blocks super 1.1 256K chunks 2 far-copies [4/4] [UUUU]
       [====>................]  resync = 23.8% (465007616/1953198080)
finish=214.8min speed=115452K/sec

 unused devices: <none>


_Something_ happened at that system upgrade.  My mistake for not
paying closer attention to what was going on.  My goal is to not let
that happen again.

Knowing that I'm not providing any helpful detail -- I don't have it
atm -- can anyone speculate as to what might have happened @ the sys
update to cause this?  If possible, I'd like to start with some clue
as to what I'm watching out for.

Thanks,

BenDJ
