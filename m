From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH 13/17] md: raid1: use bio_segments_all()
Date: Thu, 16 Feb 2017 13:35:58 +0100
Message-ID: <4a700de4-8540-d5d8-8c58-3465c0a7a55a@suse.de>
References: <1487245547-24384-1-git-send-email-tom.leiming@gmail.com>
 <1487245547-24384-14-git-send-email-tom.leiming@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <1487245547-24384-14-git-send-email-tom.leiming@gmail.com>
Sender: linux-block-owner@vger.kernel.org
To: Ming Lei <tom.leiming@gmail.com>, Shaohua Li <shli@kernel.org>, Jens Axboe <axboe@fb.com>, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, linux-block@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, NeilBrown <neilb@suse.com>
List-Id: linux-raid.ids

On 02/16/2017 12:45 PM, Ming Lei wrote:
> @@ -998,7 +998,8 @@ static void alloc_behind_pages(struct bio *bio, struct r1bio *r1_bio)
>  {
>  	int i;
>  	struct bio_vec *bvec;
> -	struct bio_vec *bvecs = kzalloc(bio->bi_vcnt * sizeof(struct bio_vec),
> +	unsigned vcnt = bio_segments_all(bio);
> +	struct bio_vec *bvecs = kzalloc(vcnt * sizeof(struct bio_vec),
>  					GFP_NOIO);

Maybe use kcalloc() instead of kzalloc() with a multiplication.

Byte,
	Johannes
-- 
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
