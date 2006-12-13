From: Mark Hahn <hahn@physics.mcmaster.ca>
Subject: Re: Odd (slow) RAID performance
Date: Wed, 13 Dec 2006 12:44:25 -0500 (EST)
Message-ID: <Pine.LNX.4.64.0612131227560.26047@coffee.psychology.mcmaster.ca>
References: <456F4872.2090900@tmr.com>  <20061201092211.4ACDB12EDE@bluewhale.planbit.co.uk>
  <45710EDC.9050805@tmr.com>  <e9c3a7c20612041733h5999ac0erc7ab4a7174882683@mail.gmail.com>
  <17784.65477.993729.508985@cse.unsw.edu.au>  <17785.5135.749830.180388@cse.unsw.edu.au>
 <457EEA8D.1080103@tmr.com> <5d96567b0612121048p69bdc606vb74f3766fd85b1f5@mail.gmail.com>
 <457F2456.8030609@tmr.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <457F2456.8030609@tmr.com>
Sender: linux-raid-owner@vger.kernel.org
To: Bill Davidsen <davidsen@tmr.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

>>> which is right at the edge of what I need. I want to read the doc on
>>> stripe_cache_size before going huge, if that's K 10MB is a LOT of cache
>>> when 256 works perfectly in RAID-0.

but they are basically unrelated.  in r5/6, the stripe cache is absolutely
critical in caching parity chunks.  in r0, never functions this way, though
it may help some workloads a bit (IOs which aren't naturally aligned to 
the underlying disk layout.)

>>> Any additional input appreciated, I would expect the speed to be (Ndisk
>>> - 1)*SingleDiskSpeed without a huge buffer, so the fact that it isn't

as others have reported, you can actually approach that with "naturally"
aligned and sized writes.

> I'm doing the tests writing 2GB of data to the raw array, in 1MB writes. The 
> array is RAID-5 with 256 chunk size. I wouldn't really expect any reads,

but how many disks?  if your 1M writes are to 4 data disks, you 
stand a chance of streaming (assuming your writes are naturally 
aligned, or else you'll be somewhat dependent on the stripe cache.)
in other words, your whole-stripe size is ndisks*chunksize, and for 
256K chunks and, say, 14 disks, that's pretty monstrous...

I think that's a factor often overlooked - large chunk sizes, especially
with r5/6 AND lots of disks, mean you probably won't ever do "blind" 
updates, and thus need the r/m/w cycle.  in that case, if the stripe cache
is not big/smart enough, you'll be limited by reads.

I'd like to experiment with this, to see how much benefit you 
really get from using larger chunk sizes.  I'm guessing that past 32K
or so, normal *ata systems don't speedup much.  fabrics with higher 
latency or command/arbitration overhead would want larger chunks.

> tried was 2K blocks, so I can try other sizes. I have a hard time picturing 
> why smaller sizes would be better, but that's what testing is for.

larger writes (from user-space) generally help, probably up to MB's.
smaller chunks help by making it more likley to do blind parity updates;
a larger stripe cache can help that too.

I think I recall an earlier thread regarding how the stripe cache is used
somewhat naively - that all IO goes through it.  the most important 
blocks would be parity and "ends" of a write that partially update an 
underlying chunk.  (conversely, don't bother caching anything which 
can be blindly written to disk.)

regards, mark hahn.
