Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B17CC61DA4
	for <linux-raid@archiver.kernel.org>; Tue, 31 Jan 2023 02:47:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229962AbjAaCrv (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 30 Jan 2023 21:47:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229542AbjAaCru (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 30 Jan 2023 21:47:50 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4395360A5
        for <linux-raid@vger.kernel.org>; Mon, 30 Jan 2023 18:47:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675133222;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=zxWfQDSHL/kRz32iUAN2iDnNeEoKIMTtHDC/6FzDfGc=;
        b=WaV9yeurUBJ0dwERwBFiw6TsCFOJvxgdjOyW91hAmfDD8dwKyQ/HTLV+uL3Hj8tBTioqNJ
        QNLlz3WjxJMRlVF3Vw6FDk4YbIvIh7ZvGSQkmqpNQkVVlx7KUDBo5U0LgDc53hERvgkK0f
        dQHKP4ctpQIvP+jetZpaEfG5XaYlOyw=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-592-FUJP9gfvN5i0VEH3phBJTg-1; Mon, 30 Jan 2023 21:47:01 -0500
X-MC-Unique: FUJP9gfvN5i0VEH3phBJTg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 22AED101A521;
        Tue, 31 Jan 2023 02:47:01 +0000 (UTC)
Received: from T590 (ovpn-8-21.pek2.redhat.com [10.72.8.21])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 3631B140EBF6;
        Tue, 31 Jan 2023 02:46:56 +0000 (UTC)
Date:   Tue, 31 Jan 2023 10:46:51 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Xiao Ni <xni@redhat.com>
Cc:     song@kernel.org, linux-raid@vger.kernel.org, ncroxon@redhat.com,
        heinzm@redhat.com, ming.lei@redhat.com
Subject: Re: [PATCH 2/2] md: Change active_io to percpu
Message-ID: <Y9iBG7GhXhJMAJP5@T590>
References: <20230121013937.97576-1-xni@redhat.com>
 <20230121013937.97576-3-xni@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230121013937.97576-3-xni@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Sat, Jan 21, 2023 at 09:39:37AM +0800, Xiao Ni wrote:
> Now the type of active_io is atomic. It's used to count how many ios are
> in the submitting process and it's added and decreased very time. But it
> only needs to check if it's zero when suspending the raid. So we can
> switch atomic to percpu to improve the performance.
> 
> After switching active_io to percpu type, we use the state of active_io
> to judge if the raid device is suspended. And we don't need to wake up
> ->sb_wait in md_handle_request anymore. It's done in the callback function
> which is registered when initing active_io. The argument mddev->suspended
> is only used to count how many users are trying to set raid to suspend
> state.
> 
> Signed-off-by: Xiao Ni <xni@redhat.com>
> ---
>  drivers/md/md.c | 40 ++++++++++++++++++++++++----------------
>  drivers/md/md.h |  2 +-
>  2 files changed, 25 insertions(+), 17 deletions(-)
> 
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index d3627aad981a..04c067cf2f53 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -382,10 +382,7 @@ static DEFINE_SPINLOCK(all_mddevs_lock);
>  
>  static bool is_md_suspended(struct mddev *mddev)
>  {
> -	if (mddev->suspended)
> -		return true;
> -	else
> -		return false;
> +	return percpu_ref_is_dying(&mddev->active_io);
>  }
>  /* Rather than calling directly into the personality make_request function,
>   * IO requests come here first so that we can check if the device is
> @@ -412,7 +409,6 @@ static bool is_suspended(struct mddev *mddev, struct bio *bio)
>  void md_handle_request(struct mddev *mddev, struct bio *bio)
>  {
>  check_suspended:
> -	rcu_read_lock();
>  	if (is_suspended(mddev, bio)) {
>  		DEFINE_WAIT(__wait);
>  		/* Bail out if REQ_NOWAIT is set for the bio */
> @@ -432,17 +428,15 @@ void md_handle_request(struct mddev *mddev, struct bio *bio)
>  		}
>  		finish_wait(&mddev->sb_wait, &__wait);
>  	}

Hi Xiao,

All rcu_read_unlock/rcu_read_lock should be removed from the above
branch, and that could cause the ktest robot warning.

Thanks,
Ming

