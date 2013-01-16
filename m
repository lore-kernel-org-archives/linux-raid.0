From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: recommended way to add ssd cache to mdraid array
Date: Wed, 16 Jan 2013 15:29:08 -0600
Message-ID: <50F71BA4.40900@hardwarefreak.com>
References: <201212212357.19292.thomas@fjellstrom.ca> <201301142052.06390.thomas@fjellstrom.ca> <50F5157A.2080308@hardwarefreak.com> <201301152231.43704.thomas@fjellstrom.ca> <50F66BDB.3000203@anonymous.org.uk>
Reply-To: stan@hardwarefreak.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <50F66BDB.3000203@anonymous.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: John Robinson <john.robinson@anonymous.org.uk>
Cc: thomas@fjellstrom.ca, Tommy Apel Hansen <tommyapeldk@gmail.com>, Chris Murphy <lists@colorremedies.com>, linux-raid Raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 1/16/2013 2:59 AM, John Robinson wrote:

> At the same time, if in the real world you're doing streaming writes of
> dozens of MB/s, I would expect that write caching would turn a good
> proportion of the writes into full-stripe writes.

The filesystem dictates whether a write is stripe aligned or not, or
fills a full stripe.  If the filesystem performs multiple partial stripe
writes no type nor manner of write caching is going to turn them into a
single stripe aligned write.  That's not possible.

On that note, a great many people on this list mistakenly configure,
optimize, and test their arrays for a magical chunk/stripe size,
apparently oblivious to the fact that most writes with most workloads
are not going to be full stripe writes, or stripe aligned whatsoever:

1.  Journal writes can be aligned, but usually don't fill a full stripe
2.  Metadata writes to the directory tress are often unaligned
3.  File appends or modify-in-place ops are never aligned

The only instance in which one will always get full stripe writes is
when creating and writing a new file whose size is a multiple of the
full stripe width.  I.e. one must be performing allocation to fill full
stripes.  Most workloads don't do this.

This is the reason why RAID6 performs so horribly with mixed read/write
workloads.  Using Thomas' example, while he was doing a streaming read
of a media file and simultaneously doing non-aligned writes from a P2P
or other application, md is performing a RMW operation during each
write, adding substantially to the seek burden on the drives.  RAID5/6
use rotating parity, so he also has an extra seek on each of two drives
occurring, competing with the read seeks of his streaming app.  Consumer
7.2K drives aren't designed to handle this type of random seek load with
good performance.

If using RAID10 or RAID0 over RAID1, there is no RMW penalty for partial
stripe width writes, and no extra seek burden for the parity writes, as
described above for RAID5/6.  Thus it doesn't cause the playback stutter
as the disks can service the read and write requests without running out
of head seek bandwidth as parity arrays do due to RMW and parity block
writes.

In summary, with Thomas' old disk system, he would have most likely
avoided the playback stutter simply by using a non-parity RAID level.

I'm constantly amazed by the fact that so many people here using parity
RAID don't understand the performance impact of these basic parity RAID
IO behaviors, and how striping actually works, and the fact that most
often they're not writing full stripes, and thus not benefiting from
their spindle count.

-- 
Stan

