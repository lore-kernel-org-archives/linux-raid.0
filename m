From: Samuel Tardieu <sam@rfc1149.net>
Subject: Debian/raid1/mdadm/devices not created at boot time
Date: 15 Dec 2004 10:38:04 +0100
Message-ID: <87r7lrnbpf.fsf@beeblebrox.rfc1149.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi.

I have migrated my Debian -unstable system to raid1 handled by madm as
directed in http://xtronics.com/reference/SATA-RAID-debian-for%202.6.html.
I use Linux 2.6.9, / is on md2, /boot on md0 and swap on md1. I use
mdadm 1.7.0 (the one shipped with Debian).

At boot time, the kernel correctly boots from md2 but init fails to
mount md0 as /boot and setup the swap space on md1 as those devices do
not exist.

If I create them by hand with "cd /dev && ./MAKEDEV md" when I get a
root shell for maintenance and start them using "mdadm -A -s", I can
continue the boot process manually.

The partition types are set to 0xfd, /proc/mdstat reports:
Personalities : [raid1] 
md0 : active raid1 sda1[0] sdb1[1]
      192640 blocks [2/2] [UU]
      
md1 : active raid1 sda5[0] sdb5[1]
      1951744 blocks [2/2] [UU]
      
md2 : active raid1 sda6[0] sdb6[1]
      37110016 blocks [2/2] [UU]
      
unused devices: <none>

As far as I can tell, the "mdadm-raid" script which does "mdadm -A -s"
is present as /etc/rcS.d/S25mdadm-raid which is a right place as it
will be run before mounting other file systems. However, the absence
of /dev/md0 and /dev/md1 prevent the raid arrays from being started.

What can I do to ensure that /dev/md0 and /dev/md1 exist when the
script is run?

  Sam
-- 
Samuel Tardieu -- sam@rfc1149.net -- http://www.rfc1149.net/sam

