From: Ming Lei <tom.leiming@gmail.com>
Subject: Re: [PATCH 4/4] md: fast clone bio in bio_clone_mddev()
Date: Mon, 6 Feb 2017 18:43:32 +0800
Message-ID: <CACVXFVNhB5i_5VJ4596ktLRnEM03GhqhZD-x+E_QwK1kZydTJg@mail.gmail.com>
References: <1486275733-7268-1-git-send-email-tom.leiming@gmail.com>
 <1486275733-7268-5-git-send-email-tom.leiming@gmail.com> <20170206085433.GB6411@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170206085433.GB6411@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Shaohua Li <shli@kernel.org>, Jens Axboe <axboe@fb.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, "open list:SOFTWARE RAID (Multiple Disks) SUPPORT" <linux-raid@vger.kernel.org>, linux-block <linux-block@vger.kernel.org>, NeilBrown <neilb@suse.com>
List-Id: linux-raid.ids

On Mon, Feb 6, 2017 at 4:54 PM, Christoph Hellwig <hch@infradead.org> wrote:
> On Sun, Feb 05, 2017 at 02:22:13PM +0800, Ming Lei wrote:
>> Firstly bio_clone_mddev() is used in raid normal I/O and isn't
>> in resync I/O path.
>>
>> Secondly all the direct access to bvec table in raid happens on
>> resync I/O except for write behind of raid1, in which we still
>> use bio_clone() for allocating new bvec table.
>>
>> So this patch replaces bio_clone() with bio_clone_fast()
>> in bio_clone_mddev().
>
> Having the _fast in the name would be really useful for the
> reader.  And as far as I can tell in the callers mddev is never
> NULL and neither is ->bio_set, so replacing bio_clone_mddev with

In theory, ->bio_set still might be NULL in case of failed memory allocation,
please see md_run().

> raw calls to bio_clone_fast would be my preference.



Thanks,
Ming Lei
