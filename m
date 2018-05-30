From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 00/13] convert block layer to bioset_init()/mempool_init()
Date: Wed, 30 May 2018 16:24:03 -0600
Message-ID: <234774e0-38d8-77ea-ca40-88da8b3c5ec6@kernel.dk>
References: <20180520222558.7053-1-kent.overstreet@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180520222558.7053-1-kent.overstreet@gmail.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Kent Overstreet <kent.overstreet@gmail.com>, linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, hch@infradead.org, colyli@suse.de, snitzer@redhat.com, darrick.wong@oracle.com, clm@fb.com, bacik@fb.com, linux-xfs@vger.kernel.org, drbd-dev@lists.linbit.com, linux-btrfs@vger.kernel.org, linux-raid@vger.kernel.org, neilb@suse.com
List-Id: linux-raid.ids

On 5/20/18 4:25 PM, Kent Overstreet wrote:
> Jens - this series does the rest of the conversions that Christoph wanted, and
> drops bioset_create().
> 
> Only lightly tested, but the changes are pretty mechanical. Based on your
> for-next tree.
> 
> It's also in the for-jens branch at https://evilpiepirate.org/git/bcachefs.git
> 
> Kent Overstreet (12):
>   block: convert bounce, q->bio_split to bioset_init()/mempool_init()
>   drbd: convert to bioset_init()/mempool_init()
>   pktcdvd: convert to bioset_init()/mempool_init()
>   lightnvm: convert to bioset_init()/mempool_init()
>   bcache: convert to bioset_init()/mempool_init()
>   md: convert to bioset_init()/mempool_init()
>   dm: convert to bioset_init()/mempool_init()
>   target: convert to bioset_init()/mempool_init()
>   fs: convert block_dev.c to bioset_init()
>   btrfs: convert to bioset_init()/mempool_init()
>   xfs: convert to bioset_init()/mempool_init()
>   block: Drop bioset_create()

With the reviews, I've queued this up for 4.18.

-- 
Jens Axboe
