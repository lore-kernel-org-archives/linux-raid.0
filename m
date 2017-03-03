From: Ming Lei <tom.leiming@gmail.com>
Subject: Re: [PATCH v2 09/13] md: raid1: use bio_segments_all()
Date: Fri, 3 Mar 2017 14:22:30 +0800
Message-ID: <CACVXFVNRhekBMAnVN9co-jdkP=+5S+28CyFr9Z_nsJVmdxPxSg@mail.gmail.com>
References: <1488296503-4987-1-git-send-email-tom.leiming@gmail.com>
 <1488296503-4987-10-git-send-email-tom.leiming@gmail.com> <20170228234212.3wjwxsegg4v57nxu@kernel.org>
 <CACVXFVOLLJ1Og7ezOsDTbuBsJg+qxJdqmf0MO+VDwDZiSoFn1g@mail.gmail.com>
 <20170302075202.ipnx64sodjzxisqs@kernel.org> <CACVXFVP1gNEsUFdh1eKW9d01azis2+GMNO_kZjN8_ZQEbe8BxQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CACVXFVP1gNEsUFdh1eKW9d01azis2+GMNO_kZjN8_ZQEbe8BxQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: Jens Axboe <axboe@fb.com>, "open list:SOFTWARE RAID (Multiple Disks) SUPPORT" <linux-raid@vger.kernel.org>, linux-block <linux-block@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>
List-Id: linux-raid.ids

On Fri, Mar 3, 2017 at 10:20 AM, Ming Lei <tom.leiming@gmail.com> wrote:
> On Thu, Mar 2, 2017 at 3:52 PM, Shaohua Li <shli@kernel.org> wrote:
>> On Thu, Mar 02, 2017 at 10:34:25AM +0800, Ming Lei wrote:
>>> Hi Shaohua,
>>>
>>> On Wed, Mar 1, 2017 at 7:42 AM, Shaohua Li <shli@kernel.org> wrote:
>>> > On Tue, Feb 28, 2017 at 11:41:39PM +0800, Ming Lei wrote:
>>> >> Use this helper, instead of direct access to .bi_vcnt.
>>> >
>>> > what We really need to do for the behind IO is:
>>> > - allocate memory and copy bio data to the memory
>>> > - let behind bio do IO against the memory
>>> >
>>> > The behind bio doesn't need to have the exactly same bio_vec setting. If we
>>> > just track the new memory, we don't need use the bio_segments_all and access
>>> > bio_vec too.
>>>
>>> But we need to figure out how many vecs(each vec store one page) to be
>>> allocated for the cloned/behind bio, and that is the only value of
>>> bio_segments_all() here. Or you have idea to avoid that?
>>
>> As I said, the behind bio doesn't need to have the exactly same bio_vec
>> setting. We just allocate memory and copy original bio data to the memory,
>> then do IO against the new memory. The behind bio
>> segments == (bio->bi_iter.bi_size + PAGE_SIZE - 1) >> PAGE_SHIFT
>
> The equation isn't always correct, especially when bvec includes just
> part of page, and it is quite often in case of mkfs, in which one bvec often
> includes 512byte buffer.

Think it further, your idea could be workable and more clean, but the change
can be a bit big, looks we need to switch handling write behind into
the following way:

1) replace bio_clone_bioset_partial() with bio_allocate(nr_vecs), and 'nr_vecs'
is computed with your equation;

2) allocate 'nr_vecs' pages once and share them among all created bio in 1)

3) for each created bio, add each page into the bio via bio_add_page()

4) only for the 1st created bio, call bio_copy_data() to copy data from
master bio.

Let me know if you are OK with the above implementaion.


Thanks,
Ming Lei
