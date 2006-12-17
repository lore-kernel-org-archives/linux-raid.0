From: Michael Tokarev <mjt@tls.msk.ru>
Subject: Re: RAID1 root and swap and initrd
Date: Sun, 17 Dec 2006 03:03:56 +0300
Message-ID: <4584896C.7090009@tls.msk.ru>
References: <20061215175630.GA11400@aym.net2.nerim.net> <Pine.LNX.4.64.0612151909210.27298@lion.drogon.net> <20061216210517.GB11400@aym.net2.nerim.net> <45846A43.8070207@tls.msk.ru> <20061216230116.GC11400@aym.net2.nerim.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20061216230116.GC11400@aym.net2.nerim.net>
Sender: linux-raid-owner@vger.kernel.org
To: Andre Majorel <aym-xunil@teaser.fr>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Andre Majorel wrote:
[]
>> So just move it to sda1 (or sda2, sda3) from sda5
> 
> Problem is, the disks are entirely used by an extended partition.
> There's nowhere to move sd?5 to.

You're using raid, so you've at least two disk drives.

remove one component off all your raid devices (second disk),
repartition the disk, re-add the components back - this will copy
data over to the second diks.  Next repeat the same procedure with
the first disk.

Or something like that -- probably only single partition (on both
disks) needs to be recreated this way.

> I think it's possible to turn the first logical partition into a
> primary partition by modifying the partition table on the MBR but
> I'm not sure I'm up for that.

It's possible to move sda5 to sda1, but not easy - because at the
start of extended partition there's a (relatively large) space for
the "logical partitions", you can't just "relabel" your partitions,
you have to actually move data.

/mjt
