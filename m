From: David Brown <david.brown@hesbynett.no>
Subject: Re: XFS on top RAID10 with odd drives count and 2 near copies
Date: Sat, 18 Feb 2012 14:59:35 +0100
Message-ID: <4F3FAEC7.9000505@hesbynett.no>
References: <CAGqmV7o7AQFY1K-1JLDk02Cv6GpAUQFjiSdM2Wbdbu6Zh_t0Wg@mail.gmail.com>	<4F35E925.6000003@hardwarefreak.com>	<CAGqmV7rBa39U-RWkzH-cTci1pNrrY1sfS=DkyK1wHE80bMt6qA@mail.gmail.com>	<4F38FD5D.1010201@hardwarefreak.com>	<CAGqmV7o6SNGV_A=iP2-uJXAJpPwh83GuqTZ-BzuY6vceMJJPVg@mail.gmail.com>	<20120213230228.GA5822@www5.open-std.org>	<4F39D9B2.3050305@hardwarefreak.com>	<20120214113832.GA6157@www5.open-std.org>	<4F3AEDEF.2000608@hardwarefreak.com>	<20120215083058.GA8821@cthulhu.home.robinhill.me.uk>	<4F3BB385.4000608@hardwarefreak.com>	<4F3BD1F6.8080309@westcontrol.com>	<4F3E5325.3060001@hardwarefreak.com>	<4F3E6ADB.2040005@westcontrol.com> <20286.43753.55416.715662@tree.ty.sabi.co.UK>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20286.43753.55416.715662@tree.ty.sabi.co.UK>
Sender: linux-raid-owner@vger.kernel.org
To: Peter Grandi <pg@lxra2.for.sabi.co.UK>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 17/02/12 20:30, Peter Grandi wrote:
> [ ... ]
>
>> To my mind, stripe width applies to reads and writes.  For
>> reads, it is the number of spindles that are used in parallel
>> while reading larger blocks of data.  For writes, it is in
>> addition the width of a parity stripe for raid5 or raid6.
>
> In the XFS case that's completely wrong, and irrelevant: in the
> XFS case it is the number of sectors/blocks that IO has to be
> _aligned_ to avoid read-modify-write, if there is the risk for
> that.
>
> The stripe width per se matters less than aligned writes as to
> avoiding read-modify-write impact: if one does IO in stripe
> width units but they are not aligned, performance will be
> terrible as double read-modify-write will not be prevented.
>
> What is the stripe width does not matter to applications like a
> filesystem other than for read-modify-write avoidance because
> how many sectors/blocks are/can be read in parallel depends
> primarily on application access patterns, and secondarily on how
> good is the IO subsystem scheduling.
>
>> [ ... ] Some filesystems care a /little/ about stripe width in
>> that they align certain structures to stripe boundaries to
>> make accesses more efficient.
>
> That in the case where read-modify-write cannot happen, if
> read-modify write can happen, unaligned or non-full-width writes
> are very costly, and not just for arrays; it happens in RAM too,
> and for 4KiB physical sector drives simulating 512B logical
> sectors.

I see your point here - when using a raid that requires 
read-modify-write (such as raid5 or raid6), then having the filesystem 
optimise writes by aligning them to RMW stripes is critical to avoiding 
poor write performance.  I'll remember that for future cases with XFS 
over raid5 or raid6.

In this case (raid10), RMW is not relevant.  So the effect of stripes is 
to allow single reads (or writes) to make use of as many spindles as 
possible in parallel.  Since this is a read-heavy application, the speed 
of reads is important - thus stripe widths /are/ important for performance.

As far as I understand you, XFS doesn't care about the stripe width for 
reading, so it doesn't matter whether you give it the correct width when 
creating the filesystem.  But that's a different matter from saying the 
/actual/ stripe width is relevant or not for read performance - it is 
just XFS's idea of the stripe width that is irrelevant for reading, 
while the real-world underlying stripe width on the raid array /is/ 
relevant.

mvh.,

David
