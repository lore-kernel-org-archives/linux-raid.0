From: David Redman <djhr@bluetone.com>
Subject: RAID1/5, SMP 2.4.18-27.7-xsmp, EXT3 and file system corruption
Date: Sat, 26 Apr 2003 23:23:29 -0700
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <3EAB7761.5000803@bluetone.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

First off, I am not subscribed to the list and I also sent this to 
linux-kernel, so I appologise inadvance if some of you get this twice.
Please reply directly to me: djhr@bluetone.com or to
david.redman@sun.com.

So onto the problem: I've been seeing data corruption on my RAID
metadrives for some time (months); over reboots they almost never come
up clean, and a umount and fsck -f always ends up finding damage.
These are large EXT3 FSs - 120GB.

This is one of the failing configs:
	/dev/md0 4x40GB IBM drives RAID5
	/dev/md1 2x120GB IBM drives RAID1
I have also tried:
	/dev/md0 4x40 RAID5
	/dev/md1 /dev/md0 + 1x120 RAID1
and I see corruption on both metadisks in both configurations.

The arrays get consistently damaged; I get duplicate blocks, corrupted
inodes, and directory holes.
An example from dmesg:
	Apr 25 04:19:35 nasbox kernel: EXT3-fs error (device md(9,2)):
	ext3_readdir: dir dectory #7603330 contains a hole at offset
	12288
This is from the RAID5 array..

My machine is nothing special Dual P3@700Mhz 384Mb DRAM, P6DBE
super-micro motherboard. the IDE controllers running the discs are all
PROMISE IDE PDC20262 controllers, the drives are all using UltraDMA
cables and all drives are the master on thier own controllers (Ie 3
cards, each with 2 drives). Root/swap is on the motherboard IDE. My
kernel is a stock Redhat7.3; A home-brew also gets corrupted FSs.

Anyone else seen this kind of corruption? I've searched google and
noticed a few other postings, but I thought I'd ask here.

Since I broke the mirror and just mounted a single drive (ie no
/dev/md1, just using a raw drive /dev/hde1) I have not noticed any
corruption on the filesystem, the other drive /dev/md0 (RAID5) is still
getting corrupted.

I have also tried running a mirror on the single 120GB drive in degraded
mode (ie one disk missing) and it also gets corruption. At this point I
have to assume that my problem is /dev/md related, and because I dont
see anyone else complaining I am assuming it is somehow tied to SMP.

I'm going to boot a non-SMP kernel and see if that changes the behavior;
problem is it takes a horribly long time to fsck the arrays when/if they
go bad.. sigh.

Thanks for any input;

dave.



