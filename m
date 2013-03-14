From: "Timothy D. Lenz" <tlenz@vorgon.com>
Subject: Putting grub back on new mirror disk
Date: Wed, 13 Mar 2013 19:29:51 -0700
Message-ID: <5141361F.7010505@vorgon.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Have a computer with 4 500Gb seagate drives setup in 2 mirror pairs. The 
first pair, sda/sdb have 3 partitions, Boot/os/programs, Swap, 
data/storage for vdr.

I've had to replace drives several times. These seagates are junk, but 
warranty is up this year and then, if I manage to get some money, I'd 
like to replace them with a pair of WD 1Tb reds.

This time it was sda that went bad. Got it replaced, got the partitions 
back in the arrays and no sign of errors during rebuilds. but when I 
tried to put grub back on, I got some kind of error. Thought I did it 
the same way I've done it before, the way I was told in #grub.

---------------------------------------------------------------------
vorg@x64VDR:~$ su
Password:
x64VDR:/home/vorg# grub-install /dev/sda && grub-install /dev/sdb
/usr/sbin/grub-probe: error: no such disk.
Auto-detection of a filesystem of /dev/md0 failed.
Please report this together with the output of "/usr/sbin/grub-probe 
--device-map=/boot/grub/device.map --target=fs -v /boot/grub" to 
<bug-grub@gnu.org>
x64VDR:/home/vorg# exit
exit
vorg@x64VDR:~$
---------------------------------------------------------------------
