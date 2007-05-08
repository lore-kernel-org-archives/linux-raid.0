From: David Greaves <david@dgreaves.com>
Subject: Re: Swapping out for larger disks
Date: Tue, 08 May 2007 12:35:47 +0100
Message-ID: <46406093.2080205@dgreaves.com>
References: <464055F5.2090108@wasp.net.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <464055F5.2090108@wasp.net.au>
Sender: linux-raid-owner@vger.kernel.org
To: Brad Campbell <brad@wasp.net.au>
Cc: RAID Linux <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Brad Campbell wrote:
> G'day all,
> 
> I've got 3 arrays here. A 3 drive raid-5, a 10 drive raid-5 and a 15
> drive raid-6. They are all currently 250GB SATA drives.
> 
> I'm contemplating an upgrade to 500GB drives on one or more of the
> arrays and wondering the best way to do the physical swap.
> 
> The slow and steady way would be to degrade the array, remove a disk,
> add the new disk, lather, rinse, repeat. After which I could use mdadm
> --grow. There is the concern of a degraded array here though (and one of
> the reasons I'm looking to swap is some of the disks have about 30,000
> hours on the clock and are growing the odd defect).


Assuming hotswap and for maximum uptime/minimal exposure to risk... a while back
there was a discussion of a fiddly way that involved adding a disk, making a
mirror, removing the old disk, breaking the mirror. ( See archive for details)

> 
> I was more wondering about the feasibility of using dd to copy the drive
> contents to the larger drives (then I could do 5 at a time) and working
> it from there.
Err, if you can dd the drives, why can't you create a new array and use xfsdump
or equivalent? Is downtime due to copying that bad?

David

