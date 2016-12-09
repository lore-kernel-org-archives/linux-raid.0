From: Coly Li <colyli@suse.de>
Subject: Re: raid0 vs. mkfs
Date: Fri, 9 Dec 2016 15:34:41 +0800
Message-ID: <14867138-b0ea-fb58-dae6-70f30a3ddcc8@suse.de>
References: <56c83c4e-d451-07e5-88e2-40b085d8681c@scylladb.com>
 <87oa108a1x.fsf@notabene.neil.brown.name>
 <286a5fc1-eda3-0421-a88e-b03c09403259@scylladb.com>
 <87inr880au.fsf@notabene.neil.brown.name>
 <df73ebc4-9b78-09b5-022b-089c30dea17c@scylladb.com>
 <87d1he7zv9.fsf@notabene.neil.brown.name>
 <33bb250a-4dfd-0acc-9958-30fdac10918c@scylladb.com>
 <ccf447df-e7b5-0a08-7753-67ee4ad574ef@suse.de>
 <20161207165933.isq64dbkxye772nz@kernel.org>
 <c384d070-457c-cfee-e35f-53b9195ace10@suse.de>
 <20161208191906.ealqsudmgopn7wa3@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20161208191906.ealqsudmgopn7wa3@kernel.org>
Sender: linux-block-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: Avi Kivity <avi@scylladb.com>, NeilBrown <neilb@suse.com>, linux-raid@vger.kernel.org, linux-block@vger.kernel.org
List-Id: linux-raid.ids

On 2016/12/9 上午3:19, Shaohua Li wrote:
> On Fri, Dec 09, 2016 at 12:44:57AM +0800, Coly Li wrote:
>> On 2016/12/8 上午12:59, Shaohua Li wrote:
>>> On Wed, Dec 07, 2016 at 07:50:33PM +0800, Coly Li wrote:
>> [snip]
>>> Thanks for doing this, Coly! For raid0, this totally makes sense. The raid0
>>> zones make things a little complicated though. I just had a brief look of your
>>> proposed patch, which looks really complicated. I'd suggest something like
>>> this:
>>> 1. split the bio according to zone boundary.
>>> 2. handle the splitted bio. since the bio is within zone range, calculating
>>> the start and end sector for each rdev should be easy.
>>>
>>
>> Hi Shaohua,
>>
>> Thanks for your suggestion! I try to modify the code by your suggestion,
>> it is even more hard to make the code that way ...
>>
>> Because even split bios for each zone, all the corner cases still exist
>> and should be taken care in every zoon. The code will be more complicated.
> 
> Not sure why it makes the code more complicated. Probably I'm wrong, but Just
> want to make sure we are in the same page: split the bio according to zone
> boundary, then handle the splitted bio separately. Calculating end/start point
> of each rdev for the new bio within a zone should be simple. we then clone a
> bio for each rdev and dispatch. So for example:
> Disk 0: D0 D2 D4 D6 D7
> Disk 1: D1 D3 D5
> zone 0 is from D0 - D5, zone 1 is from D6 - D7
> If bio is from D1 to D7, we split it to 2 bios, one is D1 - D5, the other D6 - D7.
> For D1 - D5, we dispatch 2 bios. D1 - D5 for disk 1, D2 - D4 for disk 0
> For D6 - D7, we just dispatch to disk 0.
> What kind of corner case makes this more complicated?
>  

Let me explain the corner cases.

When upper layer code issues a DISCARD bio, the bio->bi_iter.bi_sector
may not be chunk size aligned, and bio->bi_iter.bi_size may not be
(chunk_sects*nb_dev) sectors aligned. In raid0, we can't simply round
up/down them into chunk size aligned number, otherwise data
lost/corruption will happen.

Therefore for each DISCARD bio that raid0_make_request() receive, the
beginning and ending parts of this bio should be treat very carefully.
All the corner cases *come from here*, they are not about number of
zones or rdevs, it is about whether bio->bi_iter.bi_sector and
bio->bi_iter.bi_size are chunk size aligned or not.

- beginning of the bio
  If bio->bi_iter.bi_sector is not chunk size aligned, current raid0
code will split the beginning part into split bio which only contains
sectors from bio->bi_iter.sector to next chunk size aligned offset, and
issue this bio by generic_make_request(). But in
discard_large_discard_bio() we can't issue the split bio now, we have to
record lenth of this split bio into a per-device structure, and issue a
split bio after all the sectors of the DISCARD bio are calculated. So I
use recs[first_rdev_idx].bi_sector to rcoard bi_iter.bi_sector of the
split bio, recs[first_rdev_idx].sectors to record length of this split
bio, and recs[first_rdev_idx].rdev to record address of the real device
where the split bio will be sent to.

  After the first non-chunk-size aligned part handled, we need to look
into the next rdev for next chunk of DISCARD bio. Now the sector offset
is chunk size aligned, but there are still two condition:
  1) If the first_rdev is not the last read device in current zone, then
on the next real device, its per-device bio will start on a round down
chunk offset of recs[first_rdev_idx].bi_sector. If
recs[first_rdev_idx].bi_sector is chunk size aligned, the next real
device's per-device bio will start at the same chunk offset.

  2) If first_rdev is the last real device in current zone, then next
rdev to handle is the number 0 real device among
conf->strip_zone[zone_idx].nb_dev real devices. In this case, the
bi_iter.bi_setor of the per-device bio of this real device, is the chunk
offset next to chunk which recs[first_rdev_idx].bi_sector hits on
recs[first_rdev_idx].rdev.

- ending part of the bio
  If length of the DISCARD bio is not (chunk_sects * nb_dev) sectors
aligned, after we handled one or more (chunk_sects*nb_dev)) aligned
sectors, the rested sectors are less then chunk_sects*nb_dev, but these
sectors may still fit in some rested_chunks and rested_sectors. We also
need to handle them carefully.
  If rested_chunks is not 0, because chunks are linearly allocated on
each real device in current zone, we need to add chunk_sects to
recs[rdev_idx].sectors, where rdev_idx starts from 0 to
strip_zone[zone_idx].nb_dev - 1. When we move to next real device
(rdev_idx ++), we need to reduce one chunk from rested_chunk
(rested_chunk --). If rested_chunk reaches 0, we start to handle
rested_sectors.
  rested_sectors will be added to the next real device, we just simply
add rested_sectors to recs[rdev_idx].sectors. There is a corner case
that after the calculation of DISCARD bio, rested_chunks is 0, and
rested_sectors is not 0. In this case, we only need to add
rested_sectors to number 0 real device of the zone, which is recs[0].

A DISCARD bio is probably to only cover one raid0 zone, but all the
above corner cases have to be taken care. Therefore submitting split
bios for each zone, does not make the code simpler.

To handle the details correctly is really boring, if I can explain to
you face to face, that will be much easier.


>>> This will create slightly more bio to each rdev (not too many, since there
>>> aren't too many zones in practice) and block layer should easily merge these
>>> bios without much overhead. The benefit is a much simpler implementation.
>>>
>>>> I compose a prototype patch, the code is not simple, indeed it is quite
>>>> complicated IMHO.
>>>>
>>>> I do a little research, some NVMe SSDs support whole device size
>>>> DISCARD, also I observe mkfs.xfs sends out a raid0 device size DISCARD
>>>> bio to block layer. But raid0_make_request() only receives 512KB size
>>>> DISCARD bio, block/blk-lib.c:__blkdev_issue_discard() splits the
>>>> original large bio into 512KB small bios, the limitation is from
>>>> q->limits.discard_granularity.
>>>
>>> please adjust the max discard sectors for the queue. The original setting is
>>> chunk size.
>>
>> This is a powerful suggestion, I change the max_discard_sectors to raid0
>> size, and fix some bugs, now the patch looks working well. The
>> performance number is not bad.
>>
>> On 4x3TB NVMe raid0, format it with mkfs.xfs. Current upstream kernel
>> spends 306 seconds, the patched kernel spends 15 seconds. I see average
>> request size increases from 1 chunk (1024 sectors) to 2048 chunks
>> (2097152 sectors).
>>
>> I don't know why the bios are still be split before raid0_make_request()
>> receives them, after I set q->limits.max_discard_sectors to
>> mddev->array_sectors. Can anybody give me a hint ?
> 
> That probably is from disk_stack_limits. try set the max_discard_sectors after it.
> 

I know why the bio is still split, (1<<32)/512 = 8388608, in
__blkdev_issue_discard(), req_sects is decided by:
	/* Make sure bi_size doesn't overflow */
	req_sects = min_t(sector_t, nr_sects, UINT_MAX >> 9);
I try to simply modify bi_size from unsigned int to unsigned long, and
change the above limit to ULONG_MAX>>9, kernel panics. It seems change
bi_sector from unsigned int to unsigned long is not simple.

If we don't change bi_iter.bi_size to unsigned long, this is the best
effort now.


>> Here I attach the RFC v2 patch, if anybody wants to try it, please do it
>> and response the result :-)
>>
>> I will take time to write a very detailed commit log and code comments
>> to make this patch more easier to be understood. Ugly code, that's what
>> I have to pay to gain better performance ....
> 
> Can't say I like it :). Hard to read and the memory allocation is ugly. Please
> check if there is simpler solution first before writting detailed commit log.

I don't like it neither ....
I can imagine how hard to read it, because even explain it in text is
difficult... A lot of details to take care, and the calculation should
be exactly match in the end.

I tried to avoid to allocate memory for recs[], but without a data
structure to record the per-devcie bio attribution, I cannot find a
better way to write the code. There is only one thing makes me to be 1%+
comfortable is, which is bio_split() also allocates memory ^_^

Coly

