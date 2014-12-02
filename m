From: Anshuman Aggarwal <anshuman.aggarwal@gmail.com>
Subject: Re: Split RAID: Proposal for archival RAID using incremental batch checksum
Date: Tue, 2 Dec 2014 17:26:58 +0530
Message-ID: <CAK-d5dajGYxda_UFK_fBET14+KDr68km0uEKfrQVqs5oShWGfg@mail.gmail.com>
References: <CAK-d5dbdF160hoa1==jWxEQZRpwQ7Sa76=9MREmp2V6Y24U8Kw@mail.gmail.com>
 <20141029200501.1f01269d@notabene.brown> <CAK-d5dah-NyQzVNBScYoVSo2cpGA8F3vuK_Zh1YzQn5Mr+_-oQ@mail.gmail.com>
 <CAK-d5dYm7tEY855w1CdkvPz22ukkg1DwGz_mQ_9-JRV0M=O6Rw@mail.gmail.com>
 <20141103165217.3bfd3d3e@notabene.brown> <CAK-d5daq+-PbX1s81h01x7GdVDCijyzzPaeRAOCctEXTNideCw@mail.gmail.com>
 <20141125095052.51f8eadc@notabene.brown> <CAK-d5dZnWpmyPfWTGB74wHojeywdiXDnT6Fs0yqYqn7bJpSL-Q@mail.gmail.com>
 <CAK-d5dY4QEDupxjkon_+6z0Z7ggPKv=PLF60zTkeSBsbd4+mPQ@mail.gmail.com>
 <CAK-d5dZMjbhAqgs9GOvswG6crZtrV2uSidRzt_hBJAH=m5rGKw@mail.gmail.com> <20141202084611.45f56d6a@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20141202084611.45f56d6a@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Mdadm <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

It works! (Atleast on a sample 5 MB device with 5 x 1MB partitions :-)
will find more space on my drives and do a larger test but don't see
why it shouldn't work)
Here are the following caveats (and questions):
- Neil, like you pointed out, the power of 2 chunk size will probably
need a code change (in the kernel or only in the userspace tool?)
    - Any performance or other reasons why a terabyte size chunk may
not be feasible?
- Implications of safe_mode_delay
    - Would the metadata be updated on the block device be written to
and the parity device as well?
    - If the drive  fails which is the same as the drive being written
to, would that lack of metadata updates to the other devices affect
reconstruction?
- Adding new devices (is it possible to move the parity to the disk
being added? How does device addition work for RAID4 ...is it added as
a zero-ed out device with parity disk remaining the same)


On 2 December 2014 at 03:16, NeilBrown <neilb@suse.de> wrote:
> On Mon, 1 Dec 2014 22:04:42 +0530 Anshuman Aggarwal
> <anshuman.aggarwal@gmail.com> wrote:
>
>> On 1 December 2014 at 21:30, Anshuman Aggarwal
>> <anshuman.aggarwal@gmail.com> wrote:
>> > On 26 November 2014 at 11:54, Anshuman Aggarwal
>> > <anshuman.aggarwal@gmail.com> wrote:
>> >> On 25 November 2014 at 04:20, NeilBrown <neilb@suse.de> wrote:
>> >>> On Mon, 24 Nov 2014 12:59:47 +0530 Anshuman Aggarwal
>> >>> <anshuman.aggarwal@gmail.com> wrote:
>> >>>
>> >>>> On 3 November 2014 at 11:22, NeilBrown <neilb@suse.de> wrote:
>> >>>> > On Thu, 30 Oct 2014 20:30:40 +0530 Anshuman Aggarwal
>> >>>> > <anshuman.aggarwal@gmail.com> wrote:
>> >>>> >
>> >>>> >> Would chunksize==disksize work? Wouldn't that lead to the entire
>> >>>> >> parity be invalidated for any write to any of the disks (assuming md
>> >>>> >> operates at a chunk level)...also please see my reply below
>> >>>> >
>> >>>> > Operating at a chunk level would be a very poor design choice.  md/raid5
>> >>>> > operates in units of 1 page (4K).
>> >>>>
>> >>>> It appears that my requirement may be met by a partitionable md raid 4
>> >>>> array where the partitions are all on individual underlying block
>> >>>> devices not striped across the block devices. Is that currently
>> >>>> possible with md raid? I dont' see how but such an enhancement could
>> >>>> do all that I had outlined earlier
>> >>>>
>> >>>> Is this possible to implement using RAID4 and MD already?
>> >>>
>> >>> Nearly.  RAID4 currently requires the chunk size to be a power of 2.
>> >>> Rounding down the size of your drives to match that could waste nearly half
>> >>> the space.  However it should work as a proof-of-concept.
>> >>>
>> >>> RAID0 supports non-power-of-2 chunk sizes.  Doing the same thing for
>> >>> RAID4/5/6 would be quite possible.
>> >>>
>> >>>>   can the
>> >>>> partitions be made to write to individual block devices such that
>> >>>> parity updates don't require reading all devices?
>> >>>
>> >>> md/raid4 will currently tries to minimize total IO requests when performing
>> >>> an update, but prefer spreading the IO over more devices if the total number
>> >>> of requests is the same.
>> >>>
>> >>> So for a 4-drive RAID4, Updating a single block can be done by:
>> >>>   read old data block, read parity, write data, write parity - 4 IO requests
>> >>> or
>> >>>   read other 2 data blocks, write data, write parity - 4 IO requests.
>> >>>
>> >>> In this case it will prefer the second, which is not what you want.
>> >>> With 5-drive RAID4, the second option will require 5 IO requests, so the first
>> >>> will be chosen.
>> >>> It is quite trivial to flip this default for testing
>> >>>
>> >>> -       if (rmw < rcw && rmw > 0) {
>> >>> +       if (rmw <= rcw && rmw > 0) {
>> >>>
>> >>>
>> >>> If you had 5 drives, you could experiment with no code changes.
>> >>> Make the chunk size the largest power of 2 that fits in the device, and then
>> >>> partition to align the partitions on those boundaries.
>> >>
>> >> If the chunk size is almost the same as the device size, I assume the
>> >> entire chunk is not invalidated for parity on writing to a single
>> >> block? i.e. if only 1 block is updated only that blocks parity will be
>> >> read and written and not for the whole chunk? If thats' the case, what
>> >> purpose does a chunk serve in md raid ? If that's not the case, it
>> >> wouldn't work because a single block updation would lead to parity
>> >> being written for the entire chunk, which is the size of the device
>> >>
>> >> I do have more than 5 drives though they are in use currently. I will
>> >> create a small testing partition on each device of the same size and
>> >> run the test on that after ensuring that the drives do go to sleep.
>> >>
>> >>>
>> >>> NeilBrown
>> >>>
>> >
>> > Wouldn't the meta data writes wake up all the disks in the cluster
>> > anyways (defeating the purpose)? This idea will require metadata to
>> > not be written out to each device (is that even possible or on the
>> > cards?)
>> >
>> > I am about to try out your suggestion with the chunk sizes anyways but
>> > thought about the metadata being a major stumbling block.
>> >
>>
>> And it seems to be confirmed that the metadata write is waking up the
>> other drives. On any write to a particular drive the metadata update
>> is accessing all the others.
>>
>> Am I correct in assuming that all metadata is currently written as
>> part of the block device itself and that the external metadata  is
>> still embedded in each of the block devices (only the format of the
>> metadata is defined externally?) I guess to implement this we would
>> need to store metadata elsewhere which may be a major development
>> work. Still that may be a flexibility desired in md raid for other
>> reasons...
>>
>> Neil, your thoughts.
>
> This is exactly why I suggested testing with existing code and seeing how far
> you can get.  Thanks.
>
> For a full solution we probably do need some code changes here, but for
> further testing you could:
> 1/ make sure there is no bitmap (mdadm --grow --bitmap=none)
> 2/ set the safe_mode_delay to 0
>      echo 0 > /sys/block/mdXXX/md/safe_mode_delay
>
> when it won't try to update the metadata until you stop the array, or a
> device fails.
>
> Longer term: it would probably be good to only update the bitmap on the
> devices that are being written to - and to merge all bitmaps when assembling
> the array.  Also when there is a bitmap, the safe_mode functionality should
> probably be disabled.
>
> NeilBrown
>
