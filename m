From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: Reason for md raid 01 blksize limited to 4 KiB?
Date: Mon, 21 May 2012 18:14:51 -0500
Message-ID: <4FBACC6B.8010203@hardwarefreak.com>
References: <4FBA0047.5050208@profitbricks.com>
Reply-To: stan@hardwarefreak.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4FBA0047.5050208@profitbricks.com>
Sender: linux-raid-owner@vger.kernel.org
To: Sebastian Riemer <sebastian.riemer@profitbricks.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 5/21/2012 3:43 AM, Sebastian Riemer wrote:
> Hi list,
> 
> I'm wondering why stacking raid1 above raid0 limits the block sizes in
> the blkio queue to 4 KiB both read and write.

Likely because the developers only considered RAID 1 for being used in a
2, 3, maybe even 4 disk array, using local disks.  With "standard"
storage configurations, nobody in his/her right mind would consider
mirroring two RAID 0 arrays--they'd go the opposite route, either RAID
1+0 or RAID 10.  You have a unique use case.

And related to this, you may want to read my thread of earlier today
about thread/CPU core scalability WRT RAID 1.  Even if you massage the
blkio problem away, you may then run into a CPU ceiling trying to push
that much data through a single RAID 1 thread.

> The max_sectors_kb is at 512. So it's not a matter of limits.
> 
> Could someone explain, please? Or could someone pinpoint me to the
> related location in the source code?

> We've thought of using this for replication via InfiniBand/SRP. 4 KiB
> chunks are completely inefficient with SRP. We wanted to do this with
> DRBD first, but this is also extremely inefficient, because of chunk
> sizes in the blkio queue.

Infiniband max message size is 4K, for a 1:1 ratio with md RAID 1 blocks
pushed down the stack.  Thus I'm failing to see the efficiency problem.
 Is this a packet stuffing issue?

Are you using SRP or iSER?

> I can reproduce the small 4 KiB chunks also in a file copy benchmark
> with raid 01 on ram disks.

This is probably related to the Linux page size which is limited to 4K
on x86.  On IA64 you can go up to 16M pages.  What limit are you seeing
for the RAID 0 array blkio chunks?

-- 
Stan

