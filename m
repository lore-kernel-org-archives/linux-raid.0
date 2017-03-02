From: Ming Lei <tom.leiming@gmail.com>
Subject: Re: [PATCH v2 09/13] md: raid1: use bio_segments_all()
Date: Thu, 2 Mar 2017 10:34:25 +0800
Message-ID: <CACVXFVOLLJ1Og7ezOsDTbuBsJg+qxJdqmf0MO+VDwDZiSoFn1g@mail.gmail.com>
References: <1488296503-4987-1-git-send-email-tom.leiming@gmail.com>
 <1488296503-4987-10-git-send-email-tom.leiming@gmail.com> <20170228234212.3wjwxsegg4v57nxu@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20170228234212.3wjwxsegg4v57nxu@kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: Jens Axboe <axboe@fb.com>, "open list:SOFTWARE RAID (Multiple Disks) SUPPORT" <linux-raid@vger.kernel.org>, linux-block <linux-block@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>
List-Id: linux-raid.ids

Hi Shaohua,

On Wed, Mar 1, 2017 at 7:42 AM, Shaohua Li <shli@kernel.org> wrote:
> On Tue, Feb 28, 2017 at 11:41:39PM +0800, Ming Lei wrote:
>> Use this helper, instead of direct access to .bi_vcnt.
>
> what We really need to do for the behind IO is:
> - allocate memory and copy bio data to the memory
> - let behind bio do IO against the memory
>
> The behind bio doesn't need to have the exactly same bio_vec setting. If we
> just track the new memory, we don't need use the bio_segments_all and access
> bio_vec too.

But we need to figure out how many vecs(each vec store one page) to be
allocated for the cloned/behind bio, and that is the only value of
bio_segments_all() here. Or you have idea to avoid that?

Thanks,
Ming
