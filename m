Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47D85C433DB
	for <linux-raid@archiver.kernel.org>; Wed,  3 Feb 2021 15:49:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 01BB064F5D
	for <linux-raid@archiver.kernel.org>; Wed,  3 Feb 2021 15:49:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234557AbhBCPtA (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 3 Feb 2021 10:49:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234508AbhBCPpl (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 3 Feb 2021 10:45:41 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAFC8C0613ED
        for <linux-raid@vger.kernel.org>; Wed,  3 Feb 2021 07:44:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=YbwWtV7H2Xk+ro6qffzEO5s26UmenoqfJbeKDAcpcX0=; b=rzQdX3iBEzjfzTS+J7bxnTLLGV
        dxwprkaGnPRD1AFRE30tGv0AqCqOgaKe2tjXZYkHMZWiQkUNFtuzhAAL8mhieZZnMSBJi1Q+7uxBF
        DlJiQ8hZBc0y1s3PpPSNyizg3euy5IUuIGfX967vP/KR2+br7EDrlUfxq5HuTVCHpVUTTWgIGtPKb
        1dW+TFyWVQpqZXOk1w41/SQsUYRqn1zD9c5ua91VHWVDvf/FZqqzX7slKiwQM4TN67U2gXoqERGsD
        kXvng0R/B1ozCBzjQO81fYfAFgErzUbHHnmmP80eHsmg+e8p5GY2RCER6SqSAnF/zR6jOtWwWUL3+
        xAZLoFhA==;
Received: from hch by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1l7KKr-00H7I4-LN; Wed, 03 Feb 2021 15:44:53 +0000
Date:   Wed, 3 Feb 2021 15:44:53 +0000
From:   Christoph Hellwig <hch@infradead.org>
To:     Xiao Ni <xni@redhat.com>
Cc:     songliubraving@fb.com, linux-raid@vger.kernel.org,
        matthew.ruffell@canonical.com, colyli@suse.de,
        guoqing.jiang@cloud.ionos.com, ncroxon@redhat.com
Subject: Re: [PATCH 2/5] md/raid10: extend r10bio devs to raid disks
Message-ID: <20210203154453.GB4078626@infradead.org>
References: <1612359931-24209-1-git-send-email-xni@redhat.com>
 <1612359931-24209-3-git-send-email-xni@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1612359931-24209-3-git-send-email-xni@redhat.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Wed, Feb 03, 2021 at 09:45:28PM +0800, Xiao Ni wrote:
> Now it allocs r10bio->devs[conf->copies]. Discard bio needs to submit
> to all member disks and it needs to use r10bio. So extend to
> r10bio->devs[geo.raid_disks].
> 
> Reviewed-by: Coly Li <colyli@suse.de>
> Signed-off-by: Xiao Ni <xni@redhat.com>
> ---
>  drivers/md/raid10.c | 9 ++++-----
>  1 file changed, 4 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
> index be8f14a..891b249 100644
> --- a/drivers/md/raid10.c
> +++ b/drivers/md/raid10.c
> @@ -91,7 +91,7 @@ static inline struct r10bio *get_resync_r10bio(struct bio *bio)
>  static void * r10bio_pool_alloc(gfp_t gfp_flags, void *data)
>  {
>  	struct r10conf *conf = data;
> -	int size = offsetof(struct r10bio, devs[conf->copies]);
> +	int size = offsetof(struct r10bio, devs[conf->geo.raid_disks]);
>  
>  	/* allocate a r10bio with room for raid_disks entries in the
>  	 * bios array */
> @@ -238,7 +238,7 @@ static void put_all_bios(struct r10conf *conf, struct r10bio *r10_bio)
>  {
>  	int i;
>  
> -	for (i = 0; i < conf->copies; i++) {
> +	for (i = 0; i < conf->geo.raid_disks; i++) {
>  		struct bio **bio = & r10_bio->devs[i].bio;
>  		if (!BIO_SPECIAL(*bio))
>  			bio_put(*bio);
> @@ -327,7 +327,7 @@ static int find_bio_disk(struct r10conf *conf, struct r10bio *r10_bio,
>  	int slot;
>  	int repl = 0;
>  
> -	for (slot = 0; slot < conf->copies; slot++) {
> +	for (slot = 0; slot < conf->geo.raid_disks; slot++) {
>  		if (r10_bio->devs[slot].bio == bio)
>  			break;
>  		if (r10_bio->devs[slot].repl_bio == bio) {
> @@ -336,7 +336,6 @@ static int find_bio_disk(struct r10conf *conf, struct r10bio *r10_bio,
>  		}
>  	}
>  
> -	BUG_ON(slot == conf->copies);
>  	update_head_pos(slot, r10_bio);
>  
>  	if (slotp)
> @@ -1492,7 +1491,7 @@ static void __make_request(struct mddev *mddev, struct bio *bio, int sectors)
>  	r10_bio->sector = bio->bi_iter.bi_sector;
>  	r10_bio->state = 0;
>  	r10_bio->read_slot = -1;
> -	memset(r10_bio->devs, 0, sizeof(r10_bio->devs[0]) * conf->copies);
> +	memset(r10_bio->devs, 0, sizeof(r10_bio->devs[0]) * conf->geo.raid_disks);

Please avoid the overly long line.
