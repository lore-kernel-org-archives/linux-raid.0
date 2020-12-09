Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0CF72C4361B
	for <linux-raid@archiver.kernel.org>; Wed,  9 Dec 2020 22:38:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D132C23B51
	for <linux-raid@archiver.kernel.org>; Wed,  9 Dec 2020 22:38:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389026AbgLIWiH (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 9 Dec 2020 17:38:07 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:44717 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2389016AbgLIWh5 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 9 Dec 2020 17:37:57 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607553391;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=cSrpEENT4BnIOutizsuJT3GtR1FFCTPvbLdR2uZhziE=;
        b=X9k3SUCuk/SgPtrKZZ31Iu/xNDA8HyDmEZDPdWFjMmgVIo05lD9FFEewzeZvXyt9Le9cyR
        aYvFh2QWW4jO59HMs4rRiUelV8Or5Iy2w/Vl4pPgiAt3ymytcCbOCkOJSirhr/K5znmP7F
        SbYyyxKDkTYxF90joVsZJfptm/932UM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-176-hfsCSptnNgifgsVVCKkZLA-1; Wed, 09 Dec 2020 17:36:26 -0500
X-MC-Unique: hfsCSptnNgifgsVVCKkZLA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 430AE8712DA;
        Wed,  9 Dec 2020 22:36:16 +0000 (UTC)
Received: from localhost (unknown [10.18.25.174])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id DA11D5D9CA;
        Wed,  9 Dec 2020 22:36:15 +0000 (UTC)
Date:   Wed, 9 Dec 2020 17:36:15 -0500
From:   Mike Snitzer <snitzer@redhat.com>
To:     Song Liu <songliubraving@fb.com>, axboe@kernel.dk
Cc:     linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com,
        Matthew Ruffell <matthew.ruffell@canonical.com>,
        Xiao Ni <xni@redhat.com>
Subject: Re: Revert "dm raid: remove unnecessary discard limits for raid10"
Message-ID: <20201209223615.GA2752@redhat.com>
References: <20201209215814.2623617-1-songliubraving@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201209215814.2623617-1-songliubraving@fb.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Wed, Dec 09 2020 at  4:58pm -0500,
Song Liu <songliubraving@fb.com> wrote:

> This reverts commit f0e90b6c663a7e3b4736cb318c6c7c589f152c28.
> 
> Matthew Ruffell reported data corruption in raid10 due to the changes
> in discard handling [1]. Revert these changes before we find a proper fix.
> 
> [1] https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1907262/
> Cc: Matthew Ruffell <matthew.ruffell@canonical.com>
> Cc: Xiao Ni <xni@redhat.com>
> Cc: Mike Snitzer <snitzer@redhat.com>
> Signed-off-by: Song Liu <songliubraving@fb.com>

If you're reverting all the MD code that enabled this DM change, then
obviously the DM change must be reverted too.  But please do _not_
separate the DM revert from the MD reverts.

Please include this in a v2 pull request to Jens.

Mike

> ---
>  drivers/md/dm-raid.c | 11 +++++++++++
>  1 file changed, 11 insertions(+)
> 
> diff --git a/drivers/md/dm-raid.c b/drivers/md/dm-raid.c
> index 9c1f7c4de65b3..dc8568ab96f24 100644
> --- a/drivers/md/dm-raid.c
> +++ b/drivers/md/dm-raid.c
> @@ -3728,6 +3728,17 @@ static void raid_io_hints(struct dm_target *ti, struct queue_limits *limits)
>  
>  	blk_limits_io_min(limits, chunk_size_bytes);
>  	blk_limits_io_opt(limits, chunk_size_bytes * mddev_data_stripes(rs));
> +
> +	/*
> +	 * RAID10 personality requires bio splitting,
> +	 * RAID0/1/4/5/6 don't and process large discard bios properly.
> +	 */
> +	if (rs_is_raid10(rs)) {
> +		limits->discard_granularity = max(chunk_size_bytes,
> +						  limits->discard_granularity);
> +		limits->max_discard_sectors = min_not_zero(rs->md.chunk_sectors,
> +							   limits->max_discard_sectors);
> +	}
>  }
>  
>  static void raid_postsuspend(struct dm_target *ti)
> -- 
> 2.24.1
> 

