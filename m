From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: Odd (slow) RAID performance
Date: Tue, 19 Dec 2006 23:05:41 -0500
Message-ID: <4588B695.4000203@tmr.com>
References: <456F4872.2090900@tmr.com>  <20061201092211.4ACDB12EDE@bluewhale.planbit.co.uk>  <45710EDC.9050805@tmr.com>  <e9c3a7c20612041733h5999ac0erc7ab4a7174882683@mail.gmail.com>  <17784.65477.993729.508985@cse.unsw.edu.au>  <17785.5135.749830.180388@cse.unsw.edu.au> <457EEA8D.1080103@tmr.com> <5d96567b0612121048p69bdc606vb74f3766fd85b1f5@mail.gmail.com> <457F2456.8030609@tmr.com> <Pine.LNX.4.64.0612131227560.26047@coffee.psychology.mcmaster.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0612131227560.26047@coffee.psychology.mcmaster.ca>
Sender: linux-raid-owner@vger.kernel.org
To: Mark Hahn <hahn@physics.mcmaster.ca>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Mark Hahn wrote:
>>>> which is right at the edge of what I need. I want to read the doc on
>>>> stripe_cache_size before going huge, if that's K 10MB is a LOT of 
>>>> cache
>>>> when 256 works perfectly in RAID-0.
>
> but they are basically unrelated.  in r5/6, the stripe cache is 
> absolutely
> critical in caching parity chunks.  in r0, never functions this way, 
> though
> it may help some workloads a bit (IOs which aren't naturally aligned 
> to the underlying disk layout.)
>
>>>> Any additional input appreciated, I would expect the speed to be 
>>>> (Ndisk
>>>> - 1)*SingleDiskSpeed without a huge buffer, so the fact that it isn't
>
> as others have reported, you can actually approach that with "naturally"
> aligned and sized writes.
I don't know what would be natural, I have three drives, 256 chunk size 
and was originally testing with 1MB writes. I have a hard time seeing a 
case where there would be a need to read-alter-rewrite, each chunk 
should be writable as data1, data2, and parity, without readback. I was 
writing directly to the array, so the data should start on a chunk 
boundary. Until I went very large on stripe-cache-size performance was 
almost exactly 100% the write speed of a single drive. There is no 
obvious way to explain that other than writing one drive at a time. And 
shrinking write size by factors of two resulted in decreasing 
performance down to about 13% of the speed of a single drive. Such 
performance just isn't useful, and going to RAID-10 eliminated the 
problem, indicating that the RAID-5 implementation is the cause.
>
>> I'm doing the tests writing 2GB of data to the raw array, in 1MB 
>> writes. The array is RAID-5 with 256 chunk size. I wouldn't really 
>> expect any reads,
>
> but how many disks?  if your 1M writes are to 4 data disks, you stand 
> a chance of streaming (assuming your writes are naturally aligned, or 
> else you'll be somewhat dependent on the stripe cache.)
> in other words, your whole-stripe size is ndisks*chunksize, and for 
> 256K chunks and, say, 14 disks, that's pretty monstrous...
Three drives, so they could be totally isolated from other i/o.
>
> I think that's a factor often overlooked - large chunk sizes, especially
> with r5/6 AND lots of disks, mean you probably won't ever do "blind" 
> updates, and thus need the r/m/w cycle.  in that case, if the stripe 
> cache
> is not big/smart enough, you'll be limited by reads.
I didn't have lots of disks, and when the data and parity are all being 
updated in full chunk increments, there's no reason for a read, since 
the data won't be needed. I agree that it's probably being read, but 
needlessly.
>
> I'd like to experiment with this, to see how much benefit you really 
> get from using larger chunk sizes.  I'm guessing that past 32K
> or so, normal *ata systems don't speedup much.  fabrics with higher 
> latency or command/arbitration overhead would want larger chunks.
>
>> tried was 2K blocks, so I can try other sizes. I have a hard time 
>> picturing why smaller sizes would be better, but that's what testing 
>> is for.
>
> larger writes (from user-space) generally help, probably up to MB's.
> smaller chunks help by making it more likley to do blind parity updates;
> a larger stripe cache can help that too.
I tried 256B to 1MB sizes, 1MB was best, or more correctly least 
unacceptable.
>
> I think I recall an earlier thread regarding how the stripe cache is used
> somewhat naively - that all IO goes through it.  the most important 
> blocks would be parity and "ends" of a write that partially update an 
> underlying chunk.  (conversely, don't bother caching anything which 
> can be blindly written to disk.) 
I fear that last parenthetical isn't being observed.

If it weren't for RAID-1 and RAID-10 being fast I wouldn't complain 
about RAID-5.

-- 
bill davidsen <davidsen@tmr.com>
  CTO TMR Associates, Inc
  Doing interesting things with small computers since 1979

