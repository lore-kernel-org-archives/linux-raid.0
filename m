From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v1 01/14] block: introduce bio_segments_all()
Date: Sat, 25 Feb 2017 10:22:16 -0800
Message-ID: <20170225182216.GB26447@infradead.org>
References: <1487950971-1131-1-git-send-email-tom.leiming@gmail.com>
 <1487950971-1131-2-git-send-email-tom.leiming@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1487950971-1131-2-git-send-email-tom.leiming@gmail.com>
Sender: linux-block-owner@vger.kernel.org
To: Ming Lei <tom.leiming@gmail.com>
Cc: Shaohua Li <shli@kernel.org>, Jens Axboe <axboe@fb.com>, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, linux-block@vger.kernel.org, Christoph Hellwig <hch@infradead.org>
List-Id: linux-raid.ids

> +static inline unsigned bio_segments_all(struct bio *bio)
> +{
> +	WARN_ON_ONCE(bio_flagged(bio, BIO_CLONED));
> +
> +	return bio->bi_vcnt;
> +}

I don't think this helpers really adds any benefit.
