Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C4BDC05027
	for <linux-raid@archiver.kernel.org>; Wed,  1 Feb 2023 07:25:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231857AbjBAHZq (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 1 Feb 2023 02:25:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231478AbjBAHZp (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 1 Feb 2023 02:25:45 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF27A34010
        for <linux-raid@vger.kernel.org>; Tue, 31 Jan 2023 23:25:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 95CD1B820AA
        for <linux-raid@vger.kernel.org>; Wed,  1 Feb 2023 07:25:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B32CC433D2
        for <linux-raid@vger.kernel.org>; Wed,  1 Feb 2023 07:25:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675236342;
        bh=gfkJtar/+P/CwVZlbyu8CrwDVfRagTeJEeuLlaQgqkM=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=VWpS1kQHy3Ax2aeDES2bs0guRZ/sZpR4XAW8sqqPMcH5+2Z/ZkC1wEyd9APQ6Wsde
         apJshFqMnVYso2COY5gNzl86Rqmbws0ng/swr7h5o/k+tQNRSxRpXfU3vQP0ngcu2e
         HEJtmO+rYpuZYtmh+OIM8q7pdLJe5DRi8DYLI8e2A4uAzSHydCBFrHuGPAOeNSTJp7
         L/IfWy2Ie9YoH+pVxJkJmPgbY4MC5YZKXyJCEEevqYMTchLiVuy6BLODImnKQ8kz2R
         KUHwXsv6hfPBGc+chgGQRR5fRIFns/fCd4vjqEgMBVz3MI2d78MG6SKJIjUhnKEe6W
         q9KDDaS23X58w==
Received: by mail-lf1-f42.google.com with SMTP id cf42so27937914lfb.1
        for <linux-raid@vger.kernel.org>; Tue, 31 Jan 2023 23:25:42 -0800 (PST)
X-Gm-Message-State: AO0yUKW43LLOtISbbc3Pao2DXbawlkNTY2PhNxqQYTSrrwoBSul7t4JG
        bgbZeeEYoYg1jgkUhlJAF+sz9pvwW1SLsfcnru4=
X-Google-Smtp-Source: AK7set+oF3Pae3IVmH3CY3j2aLCxdY7Vc4XvJwzGPLHZ9dSwe+AC5jQKDfE3cAchCRHrAZ6m4hgy1pyeh8konloSmz8=
X-Received: by 2002:ac2:5441:0:b0:4d8:7740:47d2 with SMTP id
 d1-20020ac25441000000b004d8774047d2mr168332lfn.87.1675236340355; Tue, 31 Jan
 2023 23:25:40 -0800 (PST)
MIME-Version: 1.0
References: <20230121014810.97838-1-xni@redhat.com>
In-Reply-To: <20230121014810.97838-1-xni@redhat.com>
From:   Song Liu <song@kernel.org>
Date:   Tue, 31 Jan 2023 23:25:28 -0800
X-Gmail-Original-Message-ID: <CAPhsuW7zW8U3gbHmMQo-U8qJav0cK8wf0nkSXRwPUKMXxO0_Bw@mail.gmail.com>
Message-ID: <CAPhsuW7zW8U3gbHmMQo-U8qJav0cK8wf0nkSXRwPUKMXxO0_Bw@mail.gmail.com>
Subject: Re: [PATCH 1/1] md: Free writes_pending in md_stop
To:     Xiao Ni <xni@redhat.com>
Cc:     linux-raid@vger.kernel.org, ming.lei@redhat.com,
        ncroxon@redhat.com, heinzm@redhat.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Fri, Jan 20, 2023 at 5:48 PM Xiao Ni <xni@redhat.com> wrote:
>
> dm raid calls md_stop to stop the raid device. It needs to
> free the writes_pending here.
>
> Signed-off-by: Xiao Ni <xni@redhat.com>

Applied to md-next.

Thanks,
Song

> ---
>  drivers/md/md.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 100c1327e90b..0e9f870e348a 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -6267,6 +6267,7 @@ void md_stop(struct mddev *mddev)
>          */
>         __md_stop_writes(mddev);
>         __md_stop(mddev);
> +       percpu_ref_exit(&mddev->writes_pending);
>         percpu_ref_exit(&mddev->active_io);
>         bioset_exit(&mddev->bio_set);
>         bioset_exit(&mddev->sync_set);
> --
> 2.32.0 (Apple Git-132)
>
