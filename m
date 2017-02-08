From: Shaohua Li <shli@kernel.org>
Subject: Re: [PATCH 1/5] MD: attach data to each bio
Date: Tue, 7 Feb 2017 21:24:30 -0800
Message-ID: <20170208052430.wwqbqi7xkpvxoj52@kernel.org>
References: <cover.1486485935.git.shli@fb.com>
 <79515b1372fa1a1813c00ef0d7e0613a4512183d.1486485935.git.shli@fb.com>
 <589ADFEC.1070902@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <589ADFEC.1070902@suse.com>
Sender: linux-raid-owner@vger.kernel.org
To: Guoqing Jiang <gqjiang@suse.com>
Cc: Shaohua Li <shli@fb.com>, linux-raid@vger.kernel.org, khlebnikov@yandex-team.ru, hch@lst.de, neilb@suse.com
List-Id: linux-raid.ids

On Wed, Feb 08, 2017 at 05:07:56PM +0800, Guoqing Jiang wrote:
> 
> 
> On 02/08/2017 12:55 AM, Shaohua Li wrote:
> > Currently MD is rebusing some bio fields. To remove the hack, we attach
> > extra data to each bio. Each personablity can attach extra data to the
> > bios, so we don't need to rebuse bio fields.
> 
> rebuse? Maybe it should be reuse, or abuse.

oops, this is a typo, should be abuse 
> [snip]
> 
> > +static inline void *md_get_per_bio_data(struct bio *bio)
> > +{
> > +	return ((struct md_per_bio_data *)bio->bi_private) + 1;
> > +}
> > +
> > +extern void md_bio_attach_data(struct mddev *mddev, struct bio *bio);
> 
> Why not make raid1_bio_ref_ptr and raid10_bio_ref_ptr as macro
> like raid5_get_bio_data? Or add inline before the two funcs since
> both of them are called frequently.

I'll add 'inline'. Actually it doesn't really matter. The compiler will inline
simple functions automatically. In this case, I'm sure compiler will do the
inline. On the other hand, 'inline' doesn't guarantee compiler will do inline
unless you use __attribute__((always_inline)).

Thanks,
Shaohua
