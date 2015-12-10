From: Dallas Clement <dallas.a.clement@gmail.com>
Subject: Re: best base / worst case RAID 5,6 write speeds
Date: Thu, 10 Dec 2015 15:14:13 -0600
Message-ID: <CAE9DZUTHZ0+VkAQ8ixvH9m=6XXXShDwJp6_8SeEXovW+hF6OdQ@mail.gmail.com>
References: <CAE9DZUR=uSzYfdqFkVFdyXx+iKb1SeXxo5eX7M_nTw-fnWBwNA@mail.gmail.com>
	<5669DB3B.30101@turmel.org>
	<CAE9DZUSNkLxaKH8MtggW+5_uo38CHRTcscvh7Kk-VTb_zWPQ4g@mail.gmail.com>
	<5669E091.1010108@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5669E091.1010108@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>
Cc: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Thu, Dec 10, 2015 at 2:29 PM, Phil Turmel <philip@turmel.org> wrote:
> On 12/10/2015 03:09 PM, Dallas Clement wrote:
>> On Thu, Dec 10, 2015 at 2:06 PM, Phil Turmel <philip@turmel.org> wrote:
>
>>> Where'd you get the worst case formulas?
>>
>> Google search I'm afraid.  I think the assumption for RAID 5,6 worst
>> case is having to read and write the parity + data every cycle.
>
> Well, it'd be a lot worse than half, then.  To use the shortcut in raid5
> to write one block, you have to read it first, read the parity, compute
> the change in parity, then write the block with the new parity.  That's
> two reads and two writes for a single upper level write.  For raid6, add
> read and write of the Q syndrome, assuming you have a kernel new enough
> to do the raid6 shortcut at all.  Three reads and three writes for a
> single upper level write.  In both cases, add rotational latency to
> reposition for writing over sectors just read.
>
> Those RMW operations generally happen to small random writes, which
> makes the assertion for sequential writes odd.  Unless you delay writes
> or misalign or inhibit merging, RMW won't trigger except possibly at the
> beginning or end of a stream.
>
> That's why I questioned O_SYNC when you were using a filesystem: it
> prevents merging, and forces seeking to do small metadata writes.
> Basically turning a sequential workload into a random one.
>
> Phil

> Those RMW operations generally happen to small random writes, which
> makes the assertion for sequential writes odd.

Exactly.  I'm not expecting RMWs to be happening for large sequential
writes.  But yet my RAID 5, 6 sequential write performance is still
very poor.  As mentioned earlier, I'm getting around 95 MB/s on the
inner side of these disks.  With 12 of them, my RAID 6 write speed
should be (12 - 2) * 95 = 950 MB/s.  I'm getting about 300 MB/s less
than that for this scenario.  I have the disks split up among three
different controllers.  There should be plenty of bandwidth.  Several
days ago I ran fio on each of the 12 disks concurrently.  I was able
to see the disks at or near 100% utilization and wMB/s around 160-170
MB/s.  That's why I started focusing on RAID as being the potential
bottleneck.

> That's why I questioned O_SYNC when you were using a filesystem: it
> prevents merging, and forces seeking to do small metadata writes.
> Basically turning a sequential workload into a random one.

Yes, that certainly makes sense.  Not using O_SYNC anymore.  Just O_DIRECT.
