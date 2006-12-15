From: thunder7@xs4all.nl
Subject: Re: RAID1 root and swap and initrd
Date: Fri, 15 Dec 2006 19:30:04 +0100
Message-ID: <20061215183004.GA15690@amd64.of.nowhere>
References: <20061215175630.GA11400@aym.net2.nerim.net>
Reply-To: Jurriaan <thunder7@xs4all.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20061215175630.GA11400@aym.net2.nerim.net>
Sender: linux-raid-owner@vger.kernel.org
To: Andre Majorel <aym-xunil@teaser.fr>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

From: Andre Majorel <aym-xunil@teaser.fr>
Date: Fri, Dec 15, 2006 at 06:56:30PM +0100
> Pardon the probably silly question but...
> 
> Can you use RAID1 devices for your root and swap with a "straight"
> kernel ? (i.e. without the need for initrd/initramfs.)
> 
> If that matters, the boot manager would be LILO and each MD device
> would be assembled from "parallel" logical partitions.

Yes, I do that. Make the partitions type 0xfd and the kernel
automagically assembles any raid-partitions it needs.

Here are some parts of my dmesg:

Linux version 2.6.19-rc5-mm1 (jurriaan@middle) (gcc version 4.1.2 20061028 (prerelease) (Debian 4.1.1-19)) #5 SMP Mon Nov 13 15:55:41 CET 2006
Command line: root=/dev/md2 video=nvidiafb:1600x1200-32@85 atkbd.softrepeat=1
md: considering hdc7 ...
md:  adding hdc7 ...
md: hdc6 has different UUID to hdc7
md: hdc5 has different UUID to hdc7
md:  adding hda7 ...
md: hda6 has different UUID to hdc7
md: hda5 has different UUID to hdc7
md: created md2
md: bind<hda7>
md: bind<hdc7>
md: running: <hdc7><hda7>
raid1: raid set md2 active with 2 out of 2 mirrors
md2: bitmap initialized from disk: read 8/8 pages, set 89 bits, status: 0
created bitmap (123 pages) for device md2
EXT3-fs: mounted filesystem with ordered data mode.
VFS: Mounted root (ext3 filesystem) readonly.

Kind regards,
Jurriaan
-- 
"No," Jewel said faintly, "I know who you are."
She laughed, the laughter thawing the chill of her expression.
"And who is that, exactly?"
"Allasakar's kin."
	Michelle West - The Shining Court
Debian (Unstable) GNU/Linux 2.6.19-rc5-mm1 2x4826 bogomips load load 0.21
the Jack Vance Integral Edition: http://www.integralarchive.org
