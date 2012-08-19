From: David Brown <david.brown@hesbynett.no>
Subject: Re: O_DIRECT to md raid 6 is slow
Date: Sun, 19 Aug 2012 16:01:42 +0200
Message-ID: <5030F1C6.90205@hesbynett.no>
References: <CALCETrWCu=UPATPdqWP=Gpvswv-RDwaxfr1W1jxYtUMZsqKgSQ@mail.gmail.com> <502B8D1F.7030706@anonymous.org.uk> <CALCETrX=mi92qwOAjt_7Qu-ho_Hdg_5SHX-_8nXYRer4JnzD0w@mail.gmail.com> <201208152307.q7FN7hMR008630@xs8.xs4all.nl> <502CD3F8.70001@hardwarefreak.com> <502D6B0A.6090508@xs4all.net> <502DF357.8090205@hardwarefreak.com> <502E2817.8040306@xs4all.net> <502F237D.6060806@hardwarefreak.com> <502F698C.9010507@msgid.tls.msk.ru> <50305AB9.5080302@hardwarefreak.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <50305AB9.5080302@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: stan@hardwarefreak.com
Cc: Michael Tokarev <mjt@tls.msk.ru>, Miquel van Smoorenburg <mikevs@xs4all.net>, Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

I'm sort of jumping in to this thread, so my apologies if I repeat 
things other people have said already.

On 19/08/12 05:17, Stan Hoeppner wrote:
> On 8/18/2012 5:08 AM, Michael Tokarev wrote:
>> On 18.08.2012 09:09, Stan Hoeppner wrote:
>> []
>>>>>> Output from iostat over the period in which the 4K write was done. Look
>>>>>> at kB read and kB written:
>>>>>>
>>>>>> Device:            tps    kB_read/s    kB_wrtn/s    kB_read    kB_wrtn
>>>>>> sdb1              0.60         0.00         1.60          0          8
>>>>>> sdc1              0.60         0.80         0.80          4          4
>>>>>> sdd1              0.60         0.00         1.60          0          8
>>>>>>
>>>>>> As you can see, a single 4K read, and a few writes. You see a few blocks
>>>>>> more written that you'd expect because the superblock is updated too.
>>>>>
>>>>> I'm no dd expert, but this looks like you're simply writing a 4KB block
>>>>> to a new stripe, using an offset, but not to an existing stripe, as the
>>>>> array is in a virgin state.  So it doesn't appear this test is going to
>>>>> trigger RMW.  Don't you need now need to do another write in the same
>>>>> stripe to to trigger RMW?  Maybe I'm just reading this wrong.
>>
>> What is a "new stripe" and "existing stripe" ?  For md raid, all stripes
>> are equally existing as long as they fall within device boundaries, and
>> the rest are non-existing (outside of the device).  Unlike for an SSD for
>> example, there's no distinction between places already written and "fresh",
>> unwritten areas - all are treated exactly the same way.
>>
>>>> That shouldn't matter, but that is easily checked ofcourse, by writing
>>>> some random random data first, then doing the dd 4K write also with
>>>> random data somewhere in the same area:
>>>>
>>>> # dd if=/dev/urandom bs=1M count=3 of=/dev/md0
>>>> 3+0 records in
>>>> 3+0 records out
>>>> 3145728 bytes (3.1 MB) copied, 0.794494 s, 4.0 MB/s
>>>>
>>>> Now the first 6 chunks are filled with random data, let write 4K
>>>> somewhere in there:
>>>>
>>>> # dd if=/dev/urandom bs=4k count=1 seek=25 of=/dev/md0
>>>> 1+0 records in
>>>> 1+0 records out
>>>> 4096 bytes (4.1 kB) copied, 0.10149 s, 40.4 kB/s
>>>>
>>>> Output from iostat over the period in which the 4K write was done:
>>>>
>>>> Device:            tps    kB_read/s    kB_wrtn/s    kB_read    kB_wrtn
>>>> sdb1              0.60         0.00         1.60          0          8
>>>> sdc1              0.60         0.80         0.80          4          4
>>>> sdd1              0.60         0.00         1.60          0          8
>>>
>>> According to your iostat output, the IO is identical for both tests.  So
>>> either you triggered an RMW in the first test, or you haven't triggered
>>> an RMW with either test.  Your fist test shouldn't have triggered RMW.
>>> The second one should have.
>>
>> Both tests did exactly the same, since in both cases the I/O requests
>> were the same, and md treats all (written and yet unwritten) areas the
>> same.
>
> Interesting.  So md always performs RMW unless writing a full stripe.
> This is worse behavior than I'd assumed, as RMW will occur nearly all of
> the time with most workloads.  I'd assumed writes to "virgin" stripes
> wouldn't trigger RMW.
>

You need a RMW to make sure the stripe is consistent - "virgin" or not - 
unless you are re-writing the whole stripe.

AFAIK, there is scope for a few performance optimisations in raid6.  One 
is that for small writes which only need to change one block, raid5 uses 
a "short-cut" RMW cycle (read the old data block, read the old parity 
block, calculate the new parity block, write the new data and parity 
blocks).  A similar short-cut could be implemented in raid6, though it 
is not clear how much a difference it would really make.

Also, once the bitmap of non-sync regions is implemented (as far as I 
know, it is still on the roadmap), it should be easy to implement a 
short-cut for RMW for non-sync regions by simply replacing the reads 
with zeros.  Of course, that only makes a difference for new arrays - 
once it has been in use for a while, it will all be in sync.


>> In this test, there IS RMW cycle which is clearly shown.  I'm not sure
>> why md wrote 8Kb to sdb and sdd, and why it wrote the "extra" 4kb to
>> sdc.  Maybe it is the metadata/superblock update.  But it clearly read
>> data from sdc and wrote new data to all drives.  Assuming that all drives
>> received a 4kb write of metadata and excluding these, we'll have 4
>> kb written to sdb, 4kb read from sdc and 4kb written to sdd.  Which is
>> a clear RMW - suppose our new 4kb went to sdb, sdc is a second data disk
>> for this place and sdd is the parity.  It all works nicely.
>
> Makes sense.  It's doing RMW in both tests.  It would work much more
> nicely if a RMW wasn't required on partial writes to virgin stripes.  I
> guess this isn't possible?
>
>> Overall, in order to update parity for a small write, there's no need to
>> read and rewrite whole stripe, only the small read+write is sufficient.
>
> I find it interesting that parity for an entire stripe can be
> recalculated using only the changed chunk and the existing parity value
> as input to the calculation.  I would think the calculation would need
> all chunks as input to generate the new parity value.  Then again I was
> never a great mathematician.
>

I don't consider myself a "great mathematician", but I /do/ understand 
how the parities are generated, and I can assure you that you can 
calculate the new parities using the old data, the old parities (2 
blocks for raid6), and the new data.  It is already done this way for 
raid5.  For a simple example, consider changing D1 in a 4+1 raid5 array:

 From before, we have:
Pold = D0old ^ D1old ^ D2old ^ D3old

What we want is:
Pnew = D0old ^ D1new ^ D2old ^ D3old

Since the xor is its own inverse, we have :

D0old ^ D2old ^ D3old = Pold ^ D1old

So :

Pnew = Pold ^ D1new ^ D1old

And there is no need to read D0old, D2old or D3old.

Theoretically, this could be done for any RMW writes, to reduce the 
number of reads - in practice in md raid it is only done in raid5 for 
single block writes.  Implementing it for more blocks would complicate 
the code for very little benefit in practice.

Currently, there is no such short-cut for raid6 - all modifies are done 
as RMW.  It is certainly possible to do it - and if anyone wants the 
details of the maths then I am happy to explain it.  But it is quite a 
bit more complicated than in the raid5 case, and you would need three 
reads (old data, and two old parities).


>> There are, however, 2 variants of RMW possible, and one can be choosen
>> over another based on number of drives, amount of data being written
>> and amount of data available in the cache.  It can either read the
>> "missing" data blocks to calculate new parity (based on new blocks
>> and the read "missing" ones), or it can read parity block only,
>> substract data being replaced from there (xor is nice for that),
>> add new data and write new parity back.  When you have array with
>> large amount of drives and you write only small amount, the second
>> approach (reading old data (which might even be in cache already!),
>> reading the parity block, substracting old data and adding new to
>> there, and writing new data + new parity) will be much more often
>> than reading from all other components.  I guess.
>
> If that's the way it actually works, it's obviously better than having
> to read all the chunks.
>
>> So.. large chunk size is actually good, as it allows large I/Os
>> in one go.  There's a tradeoff ofcourse: the less the chunk size
>> is, the more chances we have to write full stripe without RMW at
>
> Which is the way I've always approached striping with parity--smaller
> chunks are better so we avoid RMW more often.
>
>> all, but at the same time, I/O size becomes very small too, which
>> is inefficient from the drive point of view.
>
> Most spinning drives these days have 16-64MB of cache and fast onboard
> IO ASICs, thus quantity vs size of IOs shouldn't make much difference
> unless you're constantly hammering your arrays.  If that's the case
> you're very likely not using parity RAID anyway.
>
>> So there's a balance,
>> but I guess on a realistic-sized raid5 array (with good number of
>> drives, like 5), I/O size will likely be less than 256Kb (with
>> 64Kb minimum realistic chunk size and 4 data drives), so expecting
>> full-stripe writes is not wise (unless it is streaming some large
>> data, in which case 512Kb chunk size (resulting in 2Mb stripes)
>> will do just as well).
>>
>> Also, large chunks may have negative impact on alignment requiriments
>> (ie, it might be more difficult to fullfil the requiriment), but
>> this is different story.
>
> Yes, as in the case of XFS journal alignment, where the maximum stripe
> unit (chunk) size is 256KB and the recommended size is 32KB.  This is a
> 100% metadata workload, making full stripe writes difficult even with a
> small stripe unit (chunk).  Large chunks simply make it much worse.  And
> every modern filesystem uses a journal...
>
>> Overall, I think 512Kb is quite a good chunk size, even for a raid5
>> array.
>
> I emphatically disagree.  For the vast majority of workloads, with a
> 512KB chunk RAID5/6, nearly every write will trigger RMW, and RMW is
> what kills parity array performance.  And RMW is *far* more costly than
> sending smaller vs larger IOs to the drives.
>
> I recommend against using parity RAID in all cases where the write
> workload is nontrivial, or the workload is random write heavy (most
> workloads).  But if someone must use RAID5/6 for reason X, I recommend
> the smallest chunk size they can get away with to increase the odds for
> full stripe writes, decreasing the odds of RMW, and increasing overall
> performance.
>

