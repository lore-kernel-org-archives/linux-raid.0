From: Norman Schmidt <Norman.Schmidt@chemie.uni-erlangen.de>
Subject: Bootable software raid and SuSE 9.1
Date: Wed, 7 Jul 2004 22:37:01 +0200 (CEST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.58.0407072225080.16359@pcmail.chemie.uni-erlangen.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello out there!

Since I have a broken leg :-[ I have lots of time to play around wirh 
"subject". With Debian, everything works really well now.

But: I use a kernel with compiled-in software raid. SuSe does everything 
with an initrd.

At the moment, I am experimenting with an unpatched SuSE 9.1 release 
installation (there were issues with a faulty mkinitrd-patch...).
I am trying to get the system to boot from a /dev/md6 (which is 
/dev/hda6,/dev/hdc6) and I want to be the partition types 83, not fd.
I tried to use the way I use in debian (boot=/dev/md6, raid-extra-boot 
..., append md=6,/... in lilo.conf), but it refuses to assemble the raid.

To be more precise, I get output concerning software raid from the kernel 
at two places in the boot process:

First, it tries to assemble the raid array /dev/md6 from /dev/hda6 and 
/dev/hdc6, but fails, since personality 3 is not (yet) registered. I 
guess this must be some kind of code in the kernel concerning software 
raid which works without any registered modules (at least, it is hit, but 
does not work).

Later on, the module raid1 is loaded, and then a "raidautorun" is called, 
which tries to assemble a /dev/md0 (which does not exist, but seems to be 
hardcoded inside the SuSE linuxrc which is inside the initrd.

Am I abot right abot the mechanisms and the reason for their failure?
Can anyone suggest any solution?

Help would be appreciated.

Thanks a lot, Norman.
