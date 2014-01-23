From: Chris Murphy <lists@colorremedies.com>
Subject: Re: Questions about bitrot and RAID 5/6
Date: Thu, 23 Jan 2014 10:28:28 -0700
Message-ID: <DE020E0C-E6EC-48E9-8D7B-09F5A65A2DF5@colorremedies.com>
References: <20140121171943.GC6553@blisses.org> <52DFA01E.8000301@hesbynett.no> <78DCA4D1-9386-4BE7-894C-47EF4772C431@colorremedies.com> <52E0D060.3020508@hesbynett.no>
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <52E0D060.3020508@hesbynett.no>
Sender: linux-raid-owner@vger.kernel.org
To: "linux-raid@vger.kernel.org List" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


On Jan 23, 2014, at 1:18 AM, David Brown <david.brown@hesbynett.no> wrote:
> 
> That's true - but (as pointed out in Neil's blog) there can be other
> reasons why one block is "wrong" compared to the others.  Supposing you
> need to change a single block in a raid 6 stripe.  That means you will
> change that block and both parity blocks.  If the disk system happens to
> write out the data disk, but there is a crash before the parities are
> written, then you will get a stripe that is consistent if you "erase"
> the new data block - when in fact it is the parity blocks that are wrong.

Sure but I think that's an idealized scenario of a bad scenario in that if there's a crash it's entirely likely that we end up with one or more torn writes to a chunk, rather than completely correctly written data chunk, and parities that aren't written at all. Chances are we do in fact end up with corruption in this case, and there's simply not enough information to unwind it. The state of the data chunk is questionable, and the state of P+Q are questionable. There's really not a lot to do here, although it seems better to have the parities recomputed from the data chunks *such as they are* rather than permit parity reconstruction to effectively rollback just one chunk. 

> Another reason for avoiding "correcting" data blocks is that it can
> confuse the filesystem layer if it has previously read in that block
> (and the raid layer cannot know for sure that it has not done so), and
> then the raid layer were to "correct" it without the filesystem's knowledge.

In this hypothetical implementation, I'm suggesting that data chunks have P' and Q' computed, and compared to on-disk P and Q, for all reads. So there wouldn't be a condition as you suggest. If whatever was previously read in was "OK" but then somehow a bit flips on the next read, is detect, and corrected, it's exactly what you'd want to have happen.


> So automatic "correction" here would be hard, expensive (erasure needs a
> lot more computation than generating or checking parities), and will
> sometimes make problems worse.  

I could see a particularly reliable implementation (ECC memory, good quality components including the right drives, all correctly configured, and on UPS) where this would statistically do more good than bad. And for all I know there are proprietary hardware raid6 implementations that do this. But it's still not really fixing the problem we want fixed, so it's understandable the effort goes elsewhere.


> 
>> 
>> I think in the case of a single, non-overlapping corruption in a data
>> chunk, that RS parity can be used to localize the error. If that's
>> true, then it can be treated as a "read error" and the normal
>> reconstruction for that chunk applies.
> 
> It /could/ be done - but as noted above it might not help (even though
> statistically speaking it's a good guess), and it would involve very
> significant calculations on every read.  At best, it would mean that
> every read involves reading a whole stripe (crippling small read
> performance) and parity calculations - making reads as slow as writes.
> This is a very big cost for detecting an error that is /incredibly/
> rare.

It mostly means that the default chunk size needs to be reduced, a long standing argument, to avoid this very problem. Those who need big chunk sizes for large streaming (media) writes, get less of a penalty for a too small chunk size in this hypothetical implementation than the general purpose case would. 

Btrfs computes crc32c for every extent read and compares with what's stored in metadata, and its reads are not meaningfully faster with the nodatasum option. And granted that's not apples to apples, because it's only computing a checksum for the extent read, not the equivalent of a whole stripe. So it's always efficient. Also I don't know to what degree the Q computation is hardware accelerated, whereas Btrfs crc32c checksum is hardware accelerated (SSE 4.2) for some time now.


>  (The link posted earlier in this thread suggested 1000 incidents
> in 41 PB of data.  At that rate, I know that it is far more likely that
> my company building will burn down, losing everything, than that I will
> ever see such an error in the company servers.  And I've got a backup.)

It's a fair point. I've recently run across some claims on a separate forum with hardware raid5 arrays containing all enterprise drives, with regularly scrubs, yet with such excessive implosions that some integrators have moved to raid6 and completely discount the use of raid5. The use case is video production. This sounds suspiciously like microcode or raid firmware bugs to me. I just don't see how ~6-8 enterprise drives in a raid5 translates into significantly higher array collapses that then essentially vanish when it's raid6.


Chris Murphy

