From: David Brown <david@westcontrol.com>
Subject: Re: Data scribbling for raid6 is wrong?
Date: Thu, 15 Dec 2011 10:33:24 +0100
Message-ID: <jccev9$ldt$1@dough.gmane.org>
References: <CAAV8rnKoga_DM1qh28ZGEsJMZAKPYDZcVFfLBSH9kPNHysf7LQ@mail.gmail.com> <20111215152723.1d2bcca0@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20111215152723.1d2bcca0@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 15/12/2011 05:27, NeilBrown wrote:
> On Thu, 15 Dec 2011 11:15:42 +0800 Tao Guo<glorioustao@gmail.com>  wrote:
>
>> Hi all,
>>
>> Today I checked the raid6's scribbling code, and I think there may be
>> some improvements to handle bad sectors:
>
> I think the common term is "scrubbing" rather than "scribbling".
>
>>
>> If we have one bad sector(with corrupted data) in the data block,
>> scribbling thread will find parity mismatch and will try to
>> recompute&rewrite P&Q, but that will cause final data loss.
>> Since we have P&  Q,  actually we can try to use them and find out the
>> wrong data block then fix it.
>>
>> But the algorithm to find the bad data block seems not
>> straightforward... Does anyone know if there is any paper discussed
>> this issue before?
>>
>> Update: I just found there is one talk about this in FAST08:
>> http://www.usenix.org/events/fast08/tech/krioukov.html.
>> But that approach will add checksums.etc. For bare-bones raid6, does
>> any guru have any better ideas?
>
> http://neil.brown.name/blog/20100211050355
>

I've read this before, but I've had another think about it in the case 
of RAID6.

I agree that there is little point in a complex repair algorithm in most 
cases - without additional knowledge of the ordering of the writes in a 
stripe, you don't know which blocks are new data, and which are old 
data.  So even if you have a 5-way mirror and 4 of them agree, it could 
still be the fifth block that is the new data.  As you say in your blog, 
the only correct thing to do is a simple repair to get consistency, and 
let the filesystem figure out if the data is usable or not.

The only situation when a smart repair could make sense is for a RAID6 
array, when the array is off-line (as you say, you never want to risk 
changing data that the filesystem may already have read - thus any 
change to the data blocks in the stripe must be done off-line).  If a 
RAID6 stripe is read, and found to be inconsistent, it is possible to 
try to find a consistent subset.  The algorithm to do so is quite 
straightforward, if a little slow (I'll explain it if anyone is 
interested).  And if such a consistent sub-stripe is found, then you can 
be very confident that this means the data is correct (the chances of it 
not being correct are truly minuscule, not just "small"), and the single 
block is inconsistent.

The question then is what could lead to a stripe with one inconsistent 
block.  Perhaps only the one block had been written before power 
failure, or perhaps only the one block was still to be written before 
the crash.  Or perhaps in the case of a single block partial write to 
the stripe, the data block had been written but neither of the parity 
blocks had been updated.  Or perhaps that one block has had some sort of 
error (read or write) that was not flagged by the disk controller.  It 
is therefore often a better choice, or at least no worse, to choose this 
block to change when making the stripe consistent, rather than picking 
on the P and Q blocks.

When doing online scrubbing, priority has to go to giving the filesystem 
consistent data - this means using the "simple" approach of 
re-generating P and Q.  That is also by far the faster method, which is 
a useful bonus when online and working.

So if we assume that "smart" recovery of RAID6 during offline resyncs is 
technically better on average than "simple" recovery, the question then 
becomes one of whether it is worth implementing.  To answer that, we 
have to look at the situations where it would be useful, the complexity 
of the code, and the benefits of having it.

As explained in the blog entry, there are a few cases that can lead to 
inconsistent stripes.  These are either serious hardware errors or 
serious administrator errors, neither of which benefit much from any 
sort of automatic recovery, or crashes or power fails in the middle of a 
stripe write.  Assuming that people that pay for the reliability of 
RAID6 in extra disk costs also often buy an UPS and pick stable kernels 
and distributions, such events are going to be very rare.

The code won't be too complex - but it still means extra code and extra 
work in testing.

We already know that the filesystem will have to cope with bad stripes 
anyway - a journalled filesystem will know that the stripe is 
questionable after a crash, and will ensure that the metadata is 
consistent.  But smart recovery increases the chance that file data is 
also saved.  Of course, it gives no guarantees - sometimes it will 
roll-back a single-block change, sometimes it will complete the stripe 
write.

Ultimately, which I think such "smart" recovery would give slightly 
better data recovery on average, it's worst case behaviour is not any 
worse than the "simple" recovery, and it would very rarely be triggered 
in practice.  There are many other features on the raid developers' 
"things to do" lists that will be of much more benefit than implementing 
this.



Of course, there is another resync/repair strategy that is even simpler 
than the "simple" one used today, and even faster.  If a stripe is found 
to be inconsistent, we could simply zero out the whole stripe.  It would 
be no worse than the worst case situation with any other algorithm.  It 
is also arguably better to give the filesystem no data rather than 
possibly bad data.





