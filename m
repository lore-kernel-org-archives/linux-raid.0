From: =?UTF-8?B?TWFydGluIE1PS1JFSsWg?= <mmokrejs@ribosome.natur.cuni.cz>
Subject: IDE/RAID/AHCI setting in BIOS influcencing mdraid?
Date: Wed, 11 Nov 2009 00:15:33 +0100
Message-ID: <4AF9F415.9050809@ribosome.natur.cuni.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid list <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi,
  after poking around the internet I cannot answer myself several questions.
Please somebody feel free to update the http://linux-raid.osdl.org/ pages
and the mdadm manpage to explain the differences. ;-)

  1. Does the BIOS values, especially AHCI vs. RAID force for example the
ICH9R chip into different mode seen by linux kernel? Looks like that ...
I have two machines and see there is a difference reported. Could that
cause machine instability if the disks would be configured through mdadm
to be in RAID? Some kind of conflict?

  I see "impl RAID mode" vs. "SATA mode" in dmesg outputs on my machines:
host1: ahci 0000:00:1f.2: AHCI 0001.0200 32 slots 6 ports 3 Gbps 0x3f impl RAID mode
host2: ahci 0000:02:00.0: AHCI 0001.0000 32 slots 2 ports 3 Gbps 0x3 impl SATA mode


  2. Selecting RAID mode in BIOS writes some Intel Storage Matrix label
somewhere into the disk, right? I think I read in mdadm manpage or similar about
"imsm" superblock format or something like that ... supported by mdraid. I cannot
find it anymore. Does it mean that one could force mdadm to create the superblock
recognized by the ICH9R BIOS and in theory MS Win drivers from Intel?


  3. I have now 0.90 superblocks on two raid1 disc partitions /dev/sd[a-b]1.
What happens if I go to BIOS of ICH9R and "remove the drives from the raid1" array?
Does that clear the "imsm?" superblock? Will that kill the 0.90 mdadm superblock
and destroy my linux mdraid?


  4. There is hardly a documentation available comparing and explaining
the difference between dmraid and mdraid. My understanding is that dmraid
is used in linux/win dual-boot machines and is older implementation. Does
use of the "imsm" superblock format under mdadm give the same possibility?
BTW, arguably the best documentation is in lkml archives around here ...:-)

From: Neil Brown (neilb@cse.unsw.edu.au)
Date: Tue Nov 19 2002 - 23:09:18 EST
Subject: RFC - new raid superblock layout for md driver

The thread is at http://lkml.indiana.edu/hypermail/linux/kernel/0211.2/1108.html


   5. There is --zero-superblock option to mdadm(1) but the manpage does not bother
to state how can one create one. Googling around I found that actually --create
does not kill the current data if one supplies mdadm with the list of devices.
I would have to Google again to give you the link, sorry. ;-) This one is at least
somehow similar, probably the first where I saw a trick with the devicename "missing".
Something new to me. ;-)
http://ubuntu-ky.ubuntuforums.org/showthread.php?p=8286434


   6. mdadm -D /dev/mdX shows:   "Persistence : Superblock is persistent".
  What I did not create the array with persistent block? How to create one
additionally? I think the answer is in the previous point nr. 5. ;-)
Yes, would be nice if somebody placed into the manpage (your Wiki) a kernel
command-line (for those who screwed their superblocks or want to stay on a safe side
if they manage so ...) example like this one from http://en.gentoo-wiki.com/wiki/Software_RAID_Install:

Title gentoo-2.6.24-r3
root (hd0,0)
kernel /gentoo.2624r3 root=/dev/md5 md=5,/dev/sda5,/dev/sdb5


Thank you for any clarifications.
Martin
