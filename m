Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0DCE5C433E0
	for <linux-raid@archiver.kernel.org>; Wed,  3 Feb 2021 15:52:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B337C64E3D
	for <linux-raid@archiver.kernel.org>; Wed,  3 Feb 2021 15:52:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234632AbhBCPwD (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 3 Feb 2021 10:52:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233895AbhBCPvl (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 3 Feb 2021 10:51:41 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63513C0613D6
        for <linux-raid@vger.kernel.org>; Wed,  3 Feb 2021 07:51:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=EJzjNGr6SL5OvdI6pqHV3/+CU/btHu6fZqvMExp7LRM=; b=cSAtbJdJ4Vkc9P/MmzozfJToEx
        ddJcYVT2W0Zfe2npzuygWPgK28TflDOOQkTIIbmrgmVRhgMHTlJawOTkqTrUBBZPNweXcK6YmO69p
        cRWUaNqs3qy4LWk8wgZwQGVBn7afbW1KJjYenr5Pun1XOOGIgitNDaX12lqI40HmOMdaI5W7mANes
        Ml9vrnJhSWXaMQu8mcF6SwPI82aMNC0Q57CygxqHWgS6CCLmUcqAZD3ugxfQ8vptovbpmpKUe72VS
        5fwWBZgoyuAhHWczA9aE4RQc0f0Z4Qs/NBE9sR5JHVjrgvHeELT2iCyoZTg+CWMGwsBExl2lq8YcW
        yNKCq+uA==;
Received: from hch by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1l7KQd-00H7r0-Vo; Wed, 03 Feb 2021 15:50:53 +0000
Date:   Wed, 3 Feb 2021 15:50:51 +0000
From:   Christoph Hellwig <hch@infradead.org>
To:     Xiao Ni <xni@redhat.com>
Cc:     songliubraving@fb.com, linux-raid@vger.kernel.org,
        matthew.ruffell@canonical.com, colyli@suse.de,
        guoqing.jiang@cloud.ionos.com, ncroxon@redhat.com
Subject: Re: [PATCH 4/5] md/raid10: improve raid10 discard request
Message-ID: <20210203155051.GD4078626@infradead.org>
References: <1612359931-24209-1-git-send-email-xni@redhat.com>
 <1612359931-24209-5-git-send-email-xni@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1612359931-24209-5-git-send-email-xni@redhat.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Wed, Feb 03, 2021 at 09:45:30PM +0800, Xiao Ni wrote:
> +static struct bio *raid10_split_bio(struct r10conf *conf,
> +			struct bio *bio, sector_t sectors, bool want_first)
> +{
> +	struct bio *split;
> +
> +	split = bio_split(bio, sectors,	GFP_NOIO, &conf->bio_split);
> +	bio_chain(split, bio);
> +	allow_barrier(conf);
> +	if (want_first) {
> +		submit_bio_noacct(bio);
> +		bio = split;
> +	} else
> +		submit_bio_noacct(split);
> +	wait_barrier(conf);
> +
> +	return bio;

I'm not sure this helper makes much sense given that the two different
cases could just be open coded into the two callers.

> +		/* raid10_remove_disk uses smp_mb to make sure rdev is set to
> +		 * replacement before setting replacement to NULL. It can read
> +		 * rdev first without barrier protect even replacment is NULL
> +		 */

Not the normal kernel comment style.

> +/* There are some limitations to handle discard bio
> + * 1st, the discard size is bigger than stripe_size*2.
> + * 2st, if the discard bio spans reshape progress, we use the old way to
> + * handle discard bio
> + */

Same here.

> +static int raid10_handle_discard(struct mddev *mddev, struct bio *bio)
> +{
> +	struct r10conf *conf = mddev->private;
> +	struct geom *geo = &conf->geo;
> +	struct r10bio *r10_bio;
> +
> +	int disk;
> +	sector_t chunk;
> +	unsigned int stripe_size;
> +	unsigned int stripe_data_disks;
> +	sector_t split_size;
> +
> +	sector_t bio_start, bio_end;

Empty lines between variabe declarations also are kinda strange.

> +	stripe_data_disks = geo->near_copies ?
> +				geo->raid_disks / geo->near_copies +
> +				geo->raid_disks % geo->near_copies :
> +				geo->raid_disks;

Normal style would be an if/else here.

> +
> +	bio_start = bio->bi_iter.bi_sector;
> +	bio_end = bio_end_sector(bio);
> +
> +	/* Maybe one discard bio is smaller than strip size or across one stripe
> +	 * and discard region is larger than one stripe size. For far offset layout,

While there are occasional exceptions to the 80 char line rule, a block
comment should never qualify.

> +	 * if the discard region is not aligned with stripe size, there is hole
> +	 * when we submit discard bio to member disk. For simplicity, we only
> +	 * handle discard bio which discard region is bigger than stripe_size*2
> +	 */
> +	if (bio_sectors(bio) < stripe_size*2)

missing whitespaces around the *.
