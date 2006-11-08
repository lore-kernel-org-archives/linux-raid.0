From: David <lists@edeca.net>
Subject: Re: Checksums wrong on one disk of mirror
Date: Wed, 08 Nov 2006 15:55:13 +0000
Message-ID: <20061108155513.pfc7p91ugccc8sow@my.pengus.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
	DelSp=Yes	format=flowed
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Quoting David <lists@edeca.net>:
> Or is the correct way
> to remove the "bad" superblock drive from the array, mount the md,
> remove the file then resync the array?

Common sense says this is correct.

> If it is possible to do either of the above, how do I stop the
> recovery?  It now starts automatically at live CD boot, repeating from
> 15.7% over and over.  My knowledge of the tools is bad but I tried the
> following:
>
> # mdadm /dev/md0 --remove /dev/sda1
> and
> # mdadm -f /dev/md0 --remove /dev/sda1 (no idea if the -f even makes
> sense there)

Looking at http://smartmontools.sourceforge.net/BadBlockHowTo.txt I  
tried to figure out what file was in the bad blocks but it turned out  
there wasn't one, it was just unused space.

My fix, for completeness, was this:

Force failure of the corrupt half of the mirror, using
# mdadm --manage /dev/md0 --fail /dev/sda

Mount the other one and fill free space with zeros
# mount /dev/md0 /mnt/test
# dd if=/dev/zero of=/mnt/test/bigfile
# sync

smartctl now showed that the pending sector had been reallocated, so I  
removed the bigfile and hot added the other drive
# mdadm --manage /dev/md0 --add /dev/sda

The recovery went fine this time and both partitions were shown as  
correct and active.  I had to fsck another md before it would boot  
correctly but the machine is now back up and working correctly.

Thanks for your help previously, it helped me along the right lines to  
start fixing this one.

David
