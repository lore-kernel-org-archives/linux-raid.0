Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6FCBC433F5
	for <linux-raid@archiver.kernel.org>; Fri, 10 Dec 2021 02:17:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234314AbhLJCUw (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 9 Dec 2021 21:20:52 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:20586 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231620AbhLJCUv (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 9 Dec 2021 21:20:51 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1639102637;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=E+4efD1Z0dzZVosd9r/Ci6gd+zJYMhDI7V9TJDliWtI=;
        b=DusasbTnw0q3jOXp3w7izaGuiwQvZ19zEa6HA9ybz8EZNzZBbjHyt+HYGxdKpspdYTtjVm
        ON4q3xaFlCGJf9cJ6l0l+q2zsE7IavpFG94fThD6WoxFV+yjSV4fsMVYFjT8SPC9ElCMpf
        pabx3Kkmn+r6CwkmTSM4YfXBugV1Opk=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-159-5W01T1feOF2AaSx_xC-Z9Q-1; Thu, 09 Dec 2021 21:17:16 -0500
X-MC-Unique: 5W01T1feOF2AaSx_xC-Z9Q-1
Received: by mail-ed1-f71.google.com with SMTP id q17-20020aa7da91000000b003e7c0641b9cso6913930eds.12
        for <linux-raid@vger.kernel.org>; Thu, 09 Dec 2021 18:17:15 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=E+4efD1Z0dzZVosd9r/Ci6gd+zJYMhDI7V9TJDliWtI=;
        b=uPD1uN+iLsaSyamWBxmVhKctVNeHRfUSe2KtZ7tuix6blQM08nwGbkaaiTiwu1Uj6T
         Ru/m9gKY9zujRHZ3oU6ic2+TEKwGyF9mv1ao3LkDBKxTvZj9tCabsnibNkMkPjmr/oBJ
         iwpX1HKSIunzmEumnXXv/AmiMd5plosp3zFw7pcI4hOur2s3smi0Grn5Sfa9kqjslntU
         J7pC6e5YH8Ubkm9fj9Z7mx9AztbAgfnCVy4oOaXwIzC+yzoBGkVbgX8XVjxyRqbtbu5k
         4NnbIyoeBdpKsUJ31vy/80ZtG4F4CswAl3x+7KEHsLZ3VRGw4YwAUctR7/t8ylcFC93K
         U5Fw==
X-Gm-Message-State: AOAM530ugd0oYinCCDtvvOxkjHXMUklRA8knJdbvxE1bFVg5su2lg+JD
        QacUfiEDsRXPC7+aKG1dNlixqWQjmdv9WPFPIDmI8qEDiSHV+w7KHO9uJe6g/5SGtGojM10G09u
        0xhndVkrSgrGKUF83cdrjb+ffEktWd+RZe95T+g==
X-Received: by 2002:a17:906:9bf9:: with SMTP id de57mr20874575ejc.439.1639102634740;
        Thu, 09 Dec 2021 18:17:14 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyC1hdfQfBjju22JWbDY2MiEIjbzNZ4vJLtLVuJbH29iiugLBgsHSZUSDXSJw4g/lLwYQotFKiHXT2HvMyvs70=
X-Received: by 2002:a17:906:9bf9:: with SMTP id de57mr20874554ejc.439.1639102634599;
 Thu, 09 Dec 2021 18:17:14 -0800 (PST)
MIME-Version: 1.0
References: <1639029324-4026-1-git-send-email-xni@redhat.com>
 <1639029324-4026-2-git-send-email-xni@redhat.com> <CAPhsuW48S-L9QTH6q_7+Nq0+MmOfswPu5epMq=bkGokxBRE2ew@mail.gmail.com>
 <CALTww29Q57wDf4eWn31ChaU4dW7A=DehdtVkL-8oyzfxnwZY6w@mail.gmail.com> <c77770d1-3496-9fb9-9035-0c4d259572db@linux.dev>
In-Reply-To: <c77770d1-3496-9fb9-9035-0c4d259572db@linux.dev>
From:   Xiao Ni <xni@redhat.com>
Date:   Fri, 10 Dec 2021 10:17:04 +0800
Message-ID: <CALTww2_O_p-hAaRnaZdC08hSU+ziSjnkVPA9er-Om=+Ded-opg@mail.gmail.com>
Subject: Re: [PATCH 1/2] md/raid0: Free r0conf memory when register integrity failed
To:     Guoqing Jiang <guoqing.jiang@linux.dev>
Cc:     Song Liu <song@kernel.org>, Nigel Croxon <ncroxon@redhat.com>,
        linux-raid <linux-raid@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Fri, Dec 10, 2021 at 10:07 AM Guoqing Jiang <guoqing.jiang@linux.dev> wrote:
>
> Maybe something like this, just FYI.
>
> diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
> index 62c8b6adac70..c24bec49b36f 100644
> --- a/drivers/md/raid0.c
> +++ b/drivers/md/raid0.c
> @@ -377,6 +377,12 @@ static int raid0_run(struct mddev *mddev)
>                          return ret;
>                  mddev->private = conf;
>          }
> +
> +       if (acct_bioset_init(mddev)) {
> +               pr_err("md/raid0:%s: alloc acct bioset failed.\n",
> mdname(mddev));
> +               return -ENOMEM;
> +       }
> +
>          conf = mddev->private;
>          if (mddev->queue) {
>                  struct md_rdev *rdev;
> @@ -413,6 +419,11 @@ static int raid0_run(struct mddev *mddev)
>          dump_zones(mddev);
>
>          ret = md_integrity_register(mddev);
> +       if (ret) {
> +               raid0_free(mddev, mddev->private);
> +               mddev->private = NULL;
> +               acct_bioset_exit(mddev);
> +       }
>
>          return ret;
>   }
>
> Thanks,
> Guoqing
>

This should not work. The way to fix the original problem is that we
need to clean acct bio set of old
level raid in pers->free and create acct bio set for new level raid in
pers->run. So it doesn't need to
change any codes in level_store. So it needs to put
acct_bioset_init/acct_bioset_exit in pers->run/free.

Regards
Xiao

