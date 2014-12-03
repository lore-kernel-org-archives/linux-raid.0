From: Klaus Thorn <klaus@programmfabrik.de>
Subject: Re: stray raid10 with 9 hdd with -n3 layout
Date: Wed, 3 Dec 2014 13:08:02 +0000 (UTC)
Message-ID: <loom.20141203T134830-830@post.gmane.org>
References: <1564432307.211407311660054.JavaMail.root@shiva> <2137843278.261407311736686.JavaMail.root@shiva>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

 <luvar <at> plaintext.sk> writes:

> They probably need to be warmed up before they provide access to all hdd. 

BIOS or EFI or Hardware Controller may have an option to delay boot process
for a few seconds.

> And than I have nine disks which should assemble single raid with raid10,
n3 layout. I have done mdadm

>  1. why does my array assemble automatically?

This is the default. You may be able to prevent this with kernel arguments
or manipulation of the initial ramdisk.
To give you a starting point for research: "raid=noautodetect".

>  2. is there possibility to assemble array in a such way, that array will
"elect" which data is on more disks
> and rewrite last disk if needed?

The default (and to my knowledge the only algorithm available in Linux
software raid) is to choose the disk with the highest event count. The event
counter is part of the meta data saved in each member of a raid.

>  3. is there possibility to assemble array in cooperation with filesystem?
That filesystem will have
> chance to choose blocks from all three disks and choose correct one from
his point of view?

not that I heard of. You could check other filesystems with built-in raid,
though: btrfs and zfs.

>  4. what should I do to have my data OK?

delay assembly, I guess.


