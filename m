From: Ming Lei <tom.leiming@gmail.com>
Subject: Re: [PATCH 00/17] md: cleanup on direct access to bvec table
Date: Fri, 17 Feb 2017 09:25:27 +0800
Message-ID: <CACVXFVPRuikOn=zJ5fboGMyQs3rMxaUK4f-Lk0s-+HpPy+ov8w@mail.gmail.com>
References: <1487245547-24384-1-git-send-email-tom.leiming@gmail.com> <20170216221642.sobqndndd7fbjoo7@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20170216221642.sobqndndd7fbjoo7@kernel.org>
Sender: linux-block-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: Jens Axboe <axboe@fb.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, "open list:SOFTWARE RAID (Multiple Disks) SUPPORT" <linux-raid@vger.kernel.org>, linux-block <linux-block@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>, NeilBrown <neilb@suse.com>
List-Id: linux-raid.ids

Hi Shaohua,

On Fri, Feb 17, 2017 at 6:16 AM, Shaohua Li <shli@kernel.org> wrote:
> On Thu, Feb 16, 2017 at 07:45:30PM +0800, Ming Lei wrote:
>> In MD's resync I/O path, there are lots of direct access to bio's
>> bvec table. This patchset kills most of them, and the conversion
>> is quite straightforward.
>
> I don't like this approach. The MD uses a hacky way to manage pages allocated,
> this is the root of the problem. The patches add another hack way to do the

Yes, I agree, and bio_iov_iter_get_pages() uses this kind of hacky way too
actually.

> management. I'd like to see explict management of the pages, for example, add
> data structure in r1bio to manage the pages, then we can use existing API for
> all the stuffes we need.

Yeah, that is definitely clean, but we have to pay the following cost:

- allocate at least N * (128 + 4) bytes per each r1_bio/r10_bio
- N is pool_info.raid_disks for raid1, and conf->copies for raid10

If we are happy to introduce the cost, I can take this way in V1.


Thanks,
Ming Lei
