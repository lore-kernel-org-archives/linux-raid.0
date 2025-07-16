Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B687289805;
	Wed, 16 Jul 2025 08:50:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752655830; cv=none; b=Kx2qgAGMStD2RAOep6NyJh+q9fDUl+EDtyKLkSnDcScGDaF8LasLvhKoLiAHIFweBNi39tvlZSma7yzpZhMULjgdfmBxBMLBNH/6582YhuX4/RIW1YtM/eQKFb0Ufueu5nCwabeENuYoolekXAJgMjqx1hsrDrJbsDVz2HVGN78=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752655830; c=relaxed/simple;
	bh=HD6fEAmUuVmTp9sPjh3zDmW2Hp1aaXZVBD1CNuo20Ys=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=f8WZ4vx5PtU3pwWueKI31xvpr2QCF5eLRWa+pL/abdS1UYDeHtnd88QMSrI5USoikqN6Cw8BIdyiERqhao47k5NhGDjJYbPFv5EtqUfZgxRCcDMdcrXnqhAcO7CCfJq8DmnwdVaE43Xmhp1IMk76GQs6gaw1cjuQnCZIQSKNvGY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JZYWFgi0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JZYWFgi0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 703FDC4CEF0;
	Wed, 16 Jul 2025 08:50:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1752655829;
	bh=HD6fEAmUuVmTp9sPjh3zDmW2Hp1aaXZVBD1CNuo20Ys=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=JZYWFgi0CMZPcAxHE7yDct1+IlAaN5ZFCTv5k520mkIL/SjM3vWm5MuLGDh32QekC
	 EsC9j+CZvENPBRI0x5j9OPiNuS735zFp5z/+xbAY9rF0bRhyWMQ3gnTBAEyheNNA33
	 l7HEbSus8byxxnx1E7O8uYnN9xtpFJkn+hVqKV0x+Gse8LHaAv2WdNRsHyjj4iVBIe
	 mKsh/Au0yqKjMO6ZkmRkBu3j9cr/vSwqsiWaFiVcqbGH+MxPSr9oPOt7mHuVZk7Ki/
	 Pca2Wv6DWQhheVqhgs1oRObhi1rQpsdhRKNk5USlA3hovL+GvaeRDlCwPnB2qaoDRd
	 1nK6LNq07ucKw==
Date: Wed, 16 Jul 2025 16:50:22 +0800
From: Coly Li <colyli@kernel.org>
To: Yu Kuai <yukuai1@huaweicloud.com>
Cc: linux-raid@vger.kernel.org, linux-block@vger.kernel.org, 
	Xiao Ni <xni@redhat.com>, Hannes Reinecke <hare@suse.de>, Martin Wilck <mwilck@suse.com>, 
	Christoph Hellwig <hch@lst.de>, Keith Busch <kbusch@kernel.org>, 
	"yukuai (C)" <yukuai3@huawei.com>
Subject: Re: [RFC PATCH] md: split bio by io_opt size in md_submit_bio()
Message-ID: <5fgrmteq5ltqi4o6bvsohcc33u3jiblyqmqv7b3g7cwawofjdl@xk4nvl3w7ndr>
References: <20250715180241.29731-1-colyli@kernel.org>
 <f158675c-7bbe-45d4-413b-3e984589d08f@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <f158675c-7bbe-45d4-413b-3e984589d08f@huaweicloud.com>

On Wed, Jul 16, 2025 at 02:58:13PM +0800, Yu Kuai wrote:
> Hi,
> 
> 在 2025/07/16 2:02, colyli@kernel.org 写道:
> > From: Coly Li <colyli@kernel.org>
> > 
> > Currently in md_submit_bio() the incoming request bio is split by
> > bio_split_to_limits() which makes sure the bio won't exceed
> > max_hw_sectors of a specific raid level before senting into its
> > .make_request method.
> > 
> > For raid level 4/5/6 such split method might be problematic and hurt
> > large read/write perforamnce. Because limits.max_hw_sectors are not
> > always aligned to limits.io_opt size, the split bio won't be full
> > stripes covered on all data disks, and will introduce extra read-in I/O.
> > Even the bio's bi_sector is aligned to limits.io_opt size and large
> > enough, the resulted split bio is not size-friendly to corresponding
> > raid456 level.
> > 
> > This patch introduces bio_split_by_io_opt() to solve the above issue,
> > 1, If the incoming bio is not limits.io_opt aligned, split the non-
> >     aligned head part. Then the next one will be aligned.
> > 2, If the imcoming bio is limits.io_opt aligned, and split is necessary,
> >     then try to split a by multiple of limits.io_opt but not exceed
> >     limits.max_hw_sectors.
> > 
> > Then for large bio, the sligned split part will be full-stripes covered
> > to all data disks, no extra read-in I/Os when rmw_level is 0. And for
> > rmw_level > 0 condistions, the limits.io_opt aligned bios are welcomed
> > for performace as well.
> > 
> > This RFC patch only tests on 8 disks raid5 array with 64KiB chunk size.
> > By this patch, 64KiB chunk size for a 8 disks raid5 array, sequential
> > write performance increases from 900MiB/s to 1.1GiB/s by fio bs=10M.
> > If fio bs=488K (exact limits.io_opt size) the peak sequential write
> > throughput can reach 1.51GiB/s.
> > 
> > (Resend to include Christoph and Keith in CC list.)
> > 
> > Signed-off-by: Coly Li <colyli@kernel.org>
> > Cc: Yu Kuai <yukuai3@huawei.com>
> > Cc: Xiao Ni <xni@redhat.com>
> > Cc: Hannes Reinecke <hare@suse.de>
> > Cc: Martin Wilck <mwilck@suse.com>
> > Cc: Christoph Hellwig <hch@lst.de>
> > Cc: Keith Busch <kbusch@kernel.org>
> > ---
> >   drivers/md/md.c | 63 ++++++++++++++++++++++++++++++++++++++++++++++++-
> >   1 file changed, 62 insertions(+), 1 deletion(-)
> > 
> > diff --git a/drivers/md/md.c b/drivers/md/md.c
> > index 0f03b21e66e4..363cff633af3 100644
> > --- a/drivers/md/md.c
> > +++ b/drivers/md/md.c
> > @@ -426,6 +426,67 @@ bool md_handle_request(struct mddev *mddev, struct bio *bio)
> >   }
> >   EXPORT_SYMBOL(md_handle_request);
> > +static struct bio *bio_split_by_io_opt(struct bio *bio)
> > +{
> > +	sector_t io_opt_sectors, sectors, n;
> > +	struct queue_limits lim;
> > +	struct mddev *mddev;
> > +	struct bio *split;
> > +	int level;
> > +
> > +	mddev = bio->bi_bdev->bd_disk->private_data;
> > +	level = mddev->level;
> > +	if (level == 1 || level == 10 || level == 0 || level == LEVEL_LINEAR)
> > +		return bio_split_to_limits(bio);
> 
> There is another patch that provide a helper raid_is_456()
> https://lore.kernel.org/all/20250707165202.11073-3-yukuai@kernel.org/
> 
> You might want to use it here.

Copied, I will use raid_is_456() after it gets merged.

> > +
> > +	lim = mddev->gendisk->queue->limits;
> > +	io_opt_sectors = min3(bio_sectors(bio), lim.io_opt >> SECTOR_SHIFT,
> > +			      lim.max_hw_sectors);
> 
> You might want to use max_sectors here, to honor user setting.
> 
> And max_hw_sectors is just for normal read and write, for other IO like
> discard, atomic write, write zero, the limit is different.
> 

Yeah, this is a reason why I want your comments :-) Originally I want to
change bio_split_to_limits(), but the raid5 logic cannot be accessed
there. If I write a clone of bio_split_to_limits(), it seems too heavy
and unncessary.

How about only handle read/write bio here, and let bio_split_to_limits()
to do the rested, like,

	level = mddev->level;
	if (level == 1 || level == 10 || level == 0 || level == LEVEL_LINEAR ||
	    (bio_op(bio) != REQ_OP_READ && bio_op(bio) != REQ_OP_WRITE))
		return bio_split_to_limits(bio);


> > +
> > +	/* No need to split */
> > +	if (bio_sectors(bio) == io_opt_sectors)
> > +		return bio;
> > +
> 
> If the bio happend to accross two io_opt, do you think it's better to
> split it here? For example:
> 

I assume raid5 code will handle this, the pages of this bio will belong
to different stripe pages belong to different chunks. So no need to
split here. For such condition, it is same handling process as calling
bio_split_to_limits().

> io_opt is 64k(chunk size) * 7 = 448k, issue an IO start from 444k with
> len = 8k. raid5 will have to use 2 stripes to handle such IO.
>

Yes, I assume although this bio is not split, raid5 will have different
cloned bio to map different stripe pages in __add_stripe_bio().

And because they belong to difference chunks, extra read-in for XOR (when
rmw_level == 0) cannot be avoided.
 
> > +	n = bio->bi_iter.bi_sector;
> > +	sectors = do_div(n, io_opt_sectors);
> > +	/* Aligned to io_opt size and no need to split for radi456 */
> > +	if (!sectors && (bio_sectors(bio) <=  lim.max_hw_sectors))
> > +		return bio;
> 
> I'm confused here, do_div doesn't mean aligned, should bio_offset() be
> taken into consideration? For example, issue an IO start from 4k with
> len = 448 * 2 k, if I read the code correctly, the result is:
> 
> 4 + 896 -> 4 + 896 (not split if within max_sectors)
> 
> What we really expect is:
> 
> 4 + 896 -> 4 + 444, 448 + 448, 892 + 4

Yes you are right. And I do this on purpose, becasue the size of bio
is small (less then max_hw_sectors). Even split the bio as you exampled,
the full-stripes-write in middle doesn't help performance because the
extra read-in will happen for head and tail part when rmw_level == 0.

For small bio (size < io_opt x 2 in this case), there is almost no
performance difference. The performance loss of incorrect bio split will
show up when the bio is large enough and many split bios in middle are
not full-stripes covered.

For bio size < max_hw_sectors, just let raid5 handle it as what it does.
> > +
> > +	if (sectors) {
> > +		/**
> > +		 * Not aligned to io_opt, split
> > +		 * non-aligned head part.
> > +		 */
> > +		sectors = io_opt_sectors - sectors;
> > +	} else {
> > +		/**
> > +		 * Aligned to io_opt, split to the largest multiple
> > +		 * of io_opt within max_hw_sectors, to make full
> > +		 * stripe write/read for underlying raid456 levels.
> > +		 */
> > +		n = lim.max_hw_sectors;
> > +		do_div(n, io_opt_sectors);
> > +		sectors = n * io_opt_sectors;
> 
> roundown() ?

Yes, of course :-)


> > +	}
> > +
> > +	/* Almost won't happen */
> > +	if (unlikely(sectors >= bio_sectors(bio))) {
> > +		pr_warn("%s raid level %d: sectors %llu >= bio_sectors %u, not split\n",
> > +			__func__, level, sectors, bio_sectors(bio));
> > +		return bio;
> > +	}
> > +
> > +	split = bio_split(bio, sectors, GFP_NOIO,
> > +			  &bio->bi_bdev->bd_disk->bio_split);
> > +	if (!split)
> > +		return bio;
> > +	split->bi_opf |= REQ_NOMERGE;
> > +	bio_chain(split, bio);
> > +	submit_bio_noacct(bio);
> > +	return split;
> > +}
> > +
> >   static void md_submit_bio(struct bio *bio)
> >   {
> >   	const int rw = bio_data_dir(bio);
> > @@ -441,7 +502,7 @@ static void md_submit_bio(struct bio *bio)
> >   		return;
> >   	}
> > -	bio = bio_split_to_limits(bio);
> > +	bio = bio_split_by_io_opt(bio);
> >   	if (!bio)
> >   		return;
> > 
>

Thanks for the review.

Coly Li 
