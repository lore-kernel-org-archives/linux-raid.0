From: Shaohua Li <shli@kernel.org>
Subject: Re: [patch 0/7] Add TRIM support for raid linear/0/1/10
Date: Wed, 14 Mar 2012 10:47:31 +0800
Message-ID: <4F6006C3.4010204@kernel.org>
References: <20120312030412.375458948@fusionio.com> <20120314132422.3aeb6d49@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20120314132422.3aeb6d49@notabene.brown>
Sender: linux-kernel-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "axboe@kernel.dk" <axboe@kernel.dk>
List-Id: linux-raid.ids

On 3/14/12 10:24 AM, NeilBrown wrote:
>  On Mon, 12 Mar 2012 11:04:12 +0800 Shaohua Li <shli@fusionio.com> wrote:
>
> > The patches add TRIM support for raid linear/0/1/10. I'll add TRIM 
support for
> > raid 4/5/6 later. The implementation is pretty straightforward and
> > self-explained.
> >
> > Thanks,
> > Shaohua
>
>  Thanks.
>  They look mostly OK.
>
>  In raid0.c, I think you'll need to change
>
>  /* Sanity check -- queue functions should prevent this happening */
>  if (bio->bi_vcnt != 1 ||
>  bio->bi_idx != 0)
>  goto bad_map;
>
>  to also allow for 'bi_vcnt == 0' like you did in bio_split.
>
>  Also I wonder about handling failure in RAID1.
>  I think the code will currently treat it like a write error, and
>  maybe record a bad block (then fail the device is writing the badblock
>  record fails). Is that what were want?
Mainly to simplify the code. And I thought a normal discard should not fail.
If it fails, something is wrong, marked it as badblock maybe not bad.

>  And of course resync/recovery will mess up the discarded sector 
information,
>  so this isn't a complete solution for RAID1. But it is a reasonable start.
Yes, this is a mess. Looks impossible without ondisk format change at
first glance.

Thanks,
Shaohua
