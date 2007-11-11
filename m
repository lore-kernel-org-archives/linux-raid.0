From: David Greaves <david@dgreaves.com>
Subject: Re: Raid5 assemble after dual sata port failure
Date: Sun, 11 Nov 2007 17:09:26 +0000
Message-ID: <47373746.9090701@dgreaves.com>
References: <47321FDF.8060207@synplicity.com> <4732E5F0.7080805@dgreaves.com> <4734CFE5.8070305@synplicity.com> <4734FB4A.4070401@synplicity.com> <473576F9.6040602@dgreaves.com> <4735FC7E.7030601@synplicity.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4735FC7E.7030601@synplicity.com>
Sender: linux-raid-owner@vger.kernel.org
To: Chris Eddington <chrise@synplicity.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Chris Eddington wrote:
> Hi,
> 
> Thanks for the pointer on xfs_repair -n , it actually tells me something
> (some listed below) but I'm not sure what it means but there seems to be
> a lot of data loss.  One complication is I see an error message in ata6,
> so I moved the disks around thinking it was a flaky sata port, but I see
> the error again on ata4 so it seems to follow the disk.  But it happens
> exactly at the same time during xfs_repair sequence, so I don't think it
> is a flaky disk.
Does dmesg have any info/sata errors?

xfs_repair will have problems if the disk is bad. You may want to image the disk
(possibly onto the 'spare'?) if it is bad.

>  I'll go to the xfs mailing list on this.
Very good idea :)

> Is there a way to be sure the disk order is right? 
The order looks right to me.
xfs_repair wouldn't recognise it as well as it does if the order was wrong.

> not way out of wack since I'm seeing so much from xfs_repair.  Also
> since I've been moving the disks around, I want to be sure I have the
> right order.

Bear in mind that -n stops the repair fixing a problem. Then as the 'repair'
proceeds it becomes very confused by problems that should have been fixed.

This is evident in the superblock issue (which also probably explains the failed
mount).


> 
> Is there a way to try restoring using the other disk?
No the event count was very out of date.


