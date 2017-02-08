From: Guoqing Jiang <gqjiang@suse.com>
Subject: Re: [PATCH 1/5] MD: attach data to each bio
Date: Wed, 8 Feb 2017 17:07:56 +0800
Message-ID: <589ADFEC.1070902@suse.com>
References: <cover.1486485935.git.shli@fb.com>
 <79515b1372fa1a1813c00ef0d7e0613a4512183d.1486485935.git.shli@fb.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <79515b1372fa1a1813c00ef0d7e0613a4512183d.1486485935.git.shli@fb.com>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@fb.com>, linux-raid@vger.kernel.org
Cc: khlebnikov@yandex-team.ru, hch@lst.de, neilb@suse.com
List-Id: linux-raid.ids



On 02/08/2017 12:55 AM, Shaohua Li wrote:
> Currently MD is rebusing some bio fields. To remove the hack, we attach
> extra data to each bio. Each personablity can attach extra data to the
> bios, so we don't need to rebuse bio fields.

rebuse? Maybe it should be reuse, or abuse.

[snip]

> +static inline void *md_get_per_bio_data(struct bio *bio)
> +{
> +	return ((struct md_per_bio_data *)bio->bi_private) + 1;
> +}
> +
> +extern void md_bio_attach_data(struct mddev *mddev, struct bio *bio);

Why not make raid1_bio_ref_ptr and raid10_bio_ref_ptr as macro
like raid5_get_bio_data? Or add inline before the two funcs since
both of them are called frequently.

Thanks,
Guoqing
