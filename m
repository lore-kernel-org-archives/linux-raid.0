From: Sebastian Riemer <sebastian.riemer@profitbricks.com>
Subject: Reason for md raid 01 blksize limited to 4 KiB?
Date: Mon, 21 May 2012 10:43:51 +0200
Message-ID: <4FBA0047.5050208@profitbricks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi list,

I'm wondering why stacking raid1 above raid0 limits the block sizes in
the blkio queue to 4 KiB both read and write.

The max_sectors_kb is at 512. So it's not a matter of limits.

Could someone explain, please? Or could someone pinpoint me to the
related location in the source code?

We've thought of using this for replication via InfiniBand/SRP. 4 KiB
chunks are completely inefficient with SRP. We wanted to do this with
DRBD first, but this is also extremely inefficient, because of chunk
sizes in the blkio queue.

I can reproduce the small 4 KiB chunks also in a file copy benchmark
with raid 01 on ram disks.

Cheers,
Sebastian
