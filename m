From: Joshua Baker-LePain <jlb17@duke.edu>
Subject: Re: SATA RAID5 kernel hang on 2.6.11-1.14_FC3
Date: Thu, 12 May 2005 05:27:17 -0400 (EDT)
Message-ID: <Pine.LNX.4.58.0505120525480.6834@chaos.egr.duke.edu>
References: <20050512053716.97460.qmail@web30504.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20050512053716.97460.qmail@web30504.mail.mud.yahoo.com>
Sender: linux-raid-owner@vger.kernel.org
To: Tim Harvey <tim_harvey@yahoo.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, 11 May 2005 at 10:37pm, Tim Harvey wrote

> Greetings,
> 
> I'm attempting to run a RAID5 array with the following configuration:
> 
> ASUS TUSI-M Motherboard, Celeron 1GHz, 256MB SDRAM
> Promise SATAII-150-TX4 4-port RAID controller
> 4 x Seagate ST300 300GB SATA NQC drives
> Linux FC3 system with 2.6.11-1.14_FC3
> 
*snip*
> do_IRQ: stack overflow: 312
*snip*
>  [<cfac1805>] xfs_buf_get_flags+0xc4/0x108 [xfs]
>  [<cfac209c>] pagebuf_iostart+0x53/0x8c [xfs]
>  [<cfac1898>] xfs_buf_read_flags+0x4f/0x6c [xfs]
>  [<cfab42ff>] xfs_trans_read_buf+0x1b9/0x31b [xfs]
> ...

It looks like you were using XFS as your filesystem?  XFS has had some 
issues with 4K stacks, although I thought they were lessened in more 
recent kernels.  You may want to ask over on the XFS list.

-- 
Joshua Baker-LePain
Department of Biomedical Engineering
Duke University
