From: David Brown <david.brown@hesbynett.no>
Subject: Re: Questions about bitrot and RAID 5/6
Date: Wed, 22 Jan 2014 11:40:30 +0100
Message-ID: <52DFA01E.8000301@hesbynett.no>
References: <20140121171943.GC6553@blisses.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20140121171943.GC6553@blisses.org>
Sender: linux-raid-owner@vger.kernel.org
To: Mason Loring Bliss <mason@blisses.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 21/01/14 18:19, Mason Loring Bliss wrote:
> On Tue, Jan 21, 2014 at 08:46:17AM +1100, NeilBrown wrote:
> 
>> ars technica recently had an article about "Bitrot and atomics COWs: Inside
>> "next-gen" filesystems."
> [...]
>> That is where I stopped reading because that is *not* how bitrot happens.
> 
> I'm not finding the specific things I've read to this effect, and some of it
> was on ephemeral media (IRC), but one of the justifications I've seen for the
> ZFS/BTRFS approach is that some drives might not consistently report errors.
> I think it's likely the case that one is in somewhat bad trouble in that
> situation, but paranoia isn't strictly a bad thing.
> 
> 
>> i.e. that clever stuff done by btrfs is already done by the drive!
> 
> The Ars Technica article shook my faith in this a little, and I'm
> appreciating the balanced view. (And, I'm spinning up smartd anywhere where
> it's not now running.)
> 
> 
> 
> On Mon, Jan 20, 2014 at 10:55:06PM +0000, Peter Grandi wrote:
> 
>> This seems to me a stupid idea that comes up occasionally on this list, and
>> the answer is always the same: the redundancy in RAID is designed for
>> *reconstruction* of data, not for integrity *checking* of data,
> 
> And yet, one person's stupid is another person's glaringly obvious. The RAID
> layer is the only one where you can have redundant data available from
> distinct devices. If it's desired, fault-tolerance ought to exist at every
> level.
> 
> 
>> and RAID assumes that the underlying storage system reports *every* error,
>> that is there are never undetected errors from the lower layer.
> 
> I wouldn't want to force extra processing and storage onto everyone, but it
> seems like something that doesn't muddy the design or complicate things at
> all. It seems like a perfect option for the paranoid - think of ordered data
> mode in EXT4. You don't have to turn it on if you don't want it.
> 

If the raid system reads in the whole stripe, and finds that the
parities don't match, what should it do?  Before considering what checks
can be done, you need to think through what could cause those checks to
fail - and what should be done about it.  If the stripe's parities don't
match, then something /very/ bad has happened - either a disk has a read
error that it is not reporting, or you've got hardware problems with
memory, buses, etc., or the software has a serious bug.  In any case,
you have to question the accuracy of anything you read off the array -
you certainly have no way of knowing which disk is causing the trouble.
 Probably the best you could do is report the whole stripe read as
failed, and hope that the filesystem can recover.

> 
> 
> On Tue, Jan 21, 2014 at 10:18:14AM +0100, David Brown wrote:
> 
>> I've read your blog on this topic, and I fully agree that checksumming or
>> read-time verification should not be part of the raid layer.
> 
> Can you provide a link, please?
> 

<http://neil.brown.name/blog/20110227114201>
<http://neil.brown.name/blog/20100211050355>


> 
>> The ideal place is whatever is generating the data generates the checksum,
>> and whatever is reading the data checks it - then /any/ error in the
>> storage path will be detected.
> 
> Detected, but not corrected. Again, fault tolerance means that the system
> works around errors. 

That's true - but the same applies to checking raid stripes for
consistency.  You can only detect an error, not correct it.  To be able
to correct the error, you need to put the checking mechanism below the
layer of the redundancy.  This is what btrfs does - the checksum is on
the file block or extent, and that block or extent is stored redundantly
(for raid1, dup, etc.) as is its checksum.  You cannot do the
/correcting/ above the redundancy layer unless you are talking about
hamming codes or other forward error correction, which would be
massively invasive for performance.

So if you want to /correct/ errors at the raid level, you need
checksumming (or other detection mechanisms) just below the raid layer -
and that is the block layer, typically the disk layer.  But the disk
layer already has such a mechanism - it is the ECC system built into the
disk.  Another checksum on the block layer is just a duplication of the
work already done by the disk - at best, you are checking the
connections and buffers along the way.  These are, as with everything
else, a potential source of error - but they are definitely a low-risk
point.

> As has been pointed out, there are potential sources of
> error at every level. It's not at all unreasonable for each layer to take
> advantage of available information to ensure correct operation.
> 

It is certainly not unreasonable to consider it - but you always have to
balance the probability of something going wrong, the consequences of
such errors, and the costs of correcting them.

The types of error that btrfs checksumming can detect (and correct,
given redundant copies) are extremely rare - the huge majority of
unrecoverable disk read errors are detected and reported by the drive.
But it turns out that this checksumming is relatively inexpensive when
it is done as part of the filesystem, and the checksums have other
potential benefits (such as for deduplication, smarter rsyncs, etc.).
So it is worth doing here.

Why would you then want to spend additional effort for a less useful,
more expensive checking at the raid level that covers fewer possible
errors?  I know I can't give a proper analysis without relevant
statistics, but my gut feeling is that the cost/benefit ratio is very
much against trying to correct failures - or even do stripe checking -
at the raid level.


> Hell, in a past life when I was working on embedded medical devices, I wrote
> code to store critical variables in reprodicibly-mutated form so that on
> accessing them I could verify that the hardware wasn't faulty and that
> nothing was randomly spraying memory. Certainly it cost a tiny bit of extra
> processing. The goal wasn't fault tolerance there, it was detection, but the
> point is that we didn't have to trust the substrate, so we did what we could
> to use it without trust.

Yes, and that is why there is ECC in the disks, and ECC memory.  High
reliability systems, where the cost is justified, use ECC techniques at
many other levels too - some processors even have whole cores redundant
and fault tolerant.  But you have to suit your redundancy, checks, and
corrections to your threat model and your cost model.  And while I agree
that /checking/ at the raid level is not too expensive, /correcting/
would be much more demanding.

> 
> 
>> Putting the checksums in the filesystem, as btrfs does, is the next best
>> thing - it is the highest layer where this is practical.
> 
> Again, depending on the goal. It's practical error detection, but doesn't add
> to the reliability of the overall system at all if there's no source of
> redundant data for a quorum.
> 

Yes, without redundancy then the btrfs checksum is error detection, but
not correction.


