From: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Subject: Re: [BUG 4.4.26] bio->bi_bdev == NULL in raid6 return_io()
Date: Mon, 21 Nov 2016 18:32:48 +0300
Message-ID: <ca280e21-3745-2e15-b3df-e1b7c6b83792@yandex-team.ru>
References: <251e243a-ebcd-ae83-0850-a2143d2423ca@yandex-team.ru>
 <20161107194627.hsdk7zqoxznxdixl@kernel.org>
 <CALYGNiMSEH-tnfzYMKuYe4KRaY6+s8KeKgUUSZRK5fQiwv3y_g@mail.gmail.com>
 <c7f3d4e3-0ef6-a6d8-7c8b-bbdb903af7a9@yandex-team.ru>
 <87r365eidd.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <87r365eidd.fsf@notabene.neil.brown.name>
Sender: linux-kernel-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>, Konstantin Khlebnikov <koct9i@gmail.com>, Shaohua Li <shli@kernel.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, linux-raid@vger.kernel.org, linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>
List-Id: linux-raid.ids

On 21.11.2016 04:23, NeilBrown wrote:
> On Sun, Nov 20 2016, Konstantin Khlebnikov wrote:
>
>> On 07.11.2016 23:34, Konstantin Khlebnikov wrote:
>>> On Mon, Nov 7, 2016 at 10:46 PM, Shaohua Li <shli@kernel.org> wrote:
>>>> On Sat, Nov 05, 2016 at 01:48:45PM +0300, Konstantin Khlebnikov wrote:
>>>>> return_io() resolves request_queue even if trace point isn't active:
>>>>>
>>>>> static inline struct request_queue *bdev_get_queue(struct block_device *bdev)
>>>>> {
>>>>>       return bdev->bd_disk->queue;    /* this is never NULL */
>>>>> }
>>>>>
>>>>> static void return_io(struct bio_list *return_bi)
>>>>> {
>>>>>       struct bio *bi;
>>>>>       while ((bi = bio_list_pop(return_bi)) != NULL) {
>>>>>               bi->bi_iter.bi_size = 0;
>>>>>               trace_block_bio_complete(bdev_get_queue(bi->bi_bdev),
>>>>>                                        bi, 0);
>>>>>               bio_endio(bi);
>>>>>       }
>>>>> }
>>>>
>>>> I can't see how this could happen. What kind of tests/environment are these running?
>>>
>>> That was a random piece of production somewhere.
>>> Cording to time all crashes happened soon after reboot.
>>> There're several raids, probably some of them were still under resync.
>>>
>>> For now we have only few machines with this kernel. But I'm sure that
>>> I'll get much more soon =)
>>
>> I've added this debug patch for catching overflow of active stripes in bio
>>
>> --- a/drivers/md/raid5.c
>> +++ b/drivers/md/raid5.c
>> @@ -164,6 +164,7 @@ static inline void raid5_inc_bi_active_stripes(struct bio *bio)
>>   {
>>          atomic_t *segments = (atomic_t *)&bio->bi_phys_segments;
>>          atomic_inc(segments);
>> +       BUG_ON(!(atomic_read(segments) & 0xffff));
>>   }
>>
>> And got this. Counter in %edx = 0x00010000
>>
>> So, looks like one bio (discard?) can cover more than 65535 stripes
>
> 65535 stripes - 256M.  I guess that is possible.  Christoph has
> suggested that now would be a good time to stop using bi_phys_segments
> like this.

Is it possible to fix this by limiting max_hw_sectors and
max_hw_discard_sectors for raid queue?

This should be much easier to backport into stable kernels.

I've found that setup also have dm/lvm on the top of md raid so
hat might be more complicated problem.
Because I cannot see how bio could be big enough to overflow that counter.
That was raid6 with 10 disks and 256k chunk. max_hw_discard_sectors and
max_hw_sectors cannot be bigger than UINT_MAX. Thus in this case bio
cannot cover more than 16384 data chunks, 20480 chunks including checksums.
Please fix me if I'm wrong.

>
> I have some patches which should fix this.  I'll post them shortly.  I'd
> appreciate it if you would test and confirm that they work (and don't
> break anything else)

Ok, I'll try to check that patchset.

-- 
Konstantin
