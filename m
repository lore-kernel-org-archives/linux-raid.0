From: Ming Lei <tom.leiming@gmail.com>
Subject: Re: [md PATCH 10/14] md/raid1: stop using bi_phys_segment
Date: Tue, 21 Feb 2017 15:41:08 +0800
Message-ID: <CACVXFVPf6qoaEWcv_s4n=2V9E=Jqfv3QE+ZpXVALdiiWTjh63Q@mail.gmail.com>
References: <148721992248.7521.17160361058957519076.stgit@noble>
 <148721994272.7521.4656357457037580183.stgit@noble> <CACVXFVMZqivgG39HBAjPKE+CJ3=nXZ3fD0XfujeUbe+_3J9HLg@mail.gmail.com>
 <87bmtws90u.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87bmtws90u.fsf@notabene.neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>
Cc: Shaohua Li <shli@kernel.org>, "open list:SOFTWARE RAID (Multiple Disks) SUPPORT" <linux-raid@vger.kernel.org>, Christoph Hellwig <hch@lst.de>
List-Id: linux-raid.ids

On Tue, Feb 21, 2017 at 8:05 AM, NeilBrown <neilb@suse.com> wrote:
> On Mon, Feb 20 2017, Ming Lei wrote:
>
>> On Thu, Feb 16, 2017 at 12:39 PM, NeilBrown <neilb@suse.com> wrote:
>>>
>>> +static void inc_pending(struct r1conf *conf, sector_t start_next_window,
>>> +                       sector_t bi_sector)
>>> +{
>>> +       /* The current request requires multiple r1_bio, so
>>> +        * we need to increment the pending count, and the corresponding
>>> +        * window count.
>>> +        */
>>> +       spin_lock(&conf->resync_lock);
>>> +       conf->nr_pending++;
>>
>> Just be curious, in current code 'nr_pending' is increased in wait_barrier(),
>> and looks this patch introduces inc_pending() to do that on each r10_bio, but
>> not see any change in wait_barrier(), so that means there might be issue in
>> current implementation about operating on this counter?
>
> Did you read the more detailed description in the previous raid10.c
> patch?
> This patch follows the same logic as that patch.

OK, I see the point now:

- for the 1st r1_bio, conf->nr_pending is increased in wait_barrier()
- for the others, conf->nr_pending is increased in inc_pending().

Also I have another question:

- before this patch, both number of requests in windows
are increased only for WRITE I/O(see wait_barrier()), and decreased
for both READ/WRITE in complete path(see allow_barrier())

- after this patch, except for the 1st r1_bio, number of requests in
windows are increased for both WRITE/READ I/O, and decreased
for both READ/WRITE too.

Could you explain a bit about this change?

Thanks,
Ming Lei
