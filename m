From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: ATARAID userspace configuration tool
Date: Tue, 10 Feb 2004 13:44:41 -0500
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <40292699.7070200@pobox.com>
References: <Pine.LNX.4.40.0402101743020.28534-100000@jehova.dsm.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.40.0402101743020.28534-100000@jehova.dsm.dk>
To: Thomas Horsten <thomas@horsten.com>
Cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Thomas Horsten wrote:
> That's true of course, one example would be to remove the RAID superblock
> with dd. The problem is if this is done by mistake, it could be
> catastrophic. It might be enough to remove the wrong partitions (with
> BLKPG_DEL_PARTITION, thanks to Matt Domsch for pointing me in the right
> direction), it will at least prevent mkfs /dev/hda1 etc, which would have
> unforeseeable consequences.


There are 1001 things that could have unforseen consequences, when root 
is doing something ;-)

This is getting into the area of standard Linux kernel policy (or lack 
thereof):  let root shoot himself in the foot, if he wishes.

I would certainly -want- to be able to dd -from- my underlying disks, 
even if an ataraid or md device is sitting on top, for example.

	Jeff



