From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 2/5] testb: implement block device operations
Date: Tue, 8 Aug 2017 14:34:16 -0600
Message-ID: <c8e6bbbd-d938-abb7-1e15-b17ce92d91ba@kernel.dk>
References: <cover.1501945859.git.shli@fb.com>
 <971572972425927f702b33da37be14a9ab646a94.1501945859.git.shli@fb.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <971572972425927f702b33da37be14a9ab646a94.1501945859.git.shli@fb.com>
Content-Language: en-US
Sender: linux-block-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>, linux-block@vger.kernel.org, linux-raid@vger.kernel.org
Cc: kernel-team@fb.com, Kyungchan Koh <kyungchan.koh@gmail.com>, Kyungchan Koh <kkc6196@fb.com>
List-Id: linux-raid.ids

On 08/05/2017 09:51 AM, Shaohua Li wrote:
> +static struct testb_page *testb_insert_page(struct testb *testb,
> +	sector_t sector, unsigned long *lock_flag)
> +{
> +	u64 idx;
> +	struct testb_page *t_page;
> +
> +	assert_spin_locked(&testb->t_dev->lock);
> +
> +	t_page = testb_lookup_page(testb, sector, true);
> +	if (t_page)
> +		return t_page;
> +
> +	spin_unlock_irqrestore(&testb->t_dev->lock, *lock_flag);

Passing in lock flags through several functions is kind of iffy. It also
used to break on some architectures, though I don't think that's the
case anymore. The problem is that it usually ends up being a code
locking, instead of a data structure locking. The latter is much
cleaner.

> +static int copy_from_testb(struct testb *testb, struct page *dest,
> +	unsigned int off, sector_t sector, size_t n, unsigned long *lock_flag)

This also gets the lock flags passed in, but doesn't use it.

-- 
Jens Axboe
