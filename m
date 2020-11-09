Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 177CAC388F7
	for <linux-raid@archiver.kernel.org>; Mon,  9 Nov 2020 17:43:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AA8AF20656
	for <linux-raid@archiver.kernel.org>; Mon,  9 Nov 2020 17:43:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="xMst/gE+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731430AbgKIRnV (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 9 Nov 2020 12:43:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:43366 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730115AbgKIRnV (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Mon, 9 Nov 2020 12:43:21 -0500
Received: from mail-lj1-f176.google.com (mail-lj1-f176.google.com [209.85.208.176])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4B41F20665
        for <linux-raid@vger.kernel.org>; Mon,  9 Nov 2020 17:43:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604943800;
        bh=jxIPFGQS/l4T9W5KjNhxaTV1ftTEn2eviBW+aGZxsv4=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=xMst/gE+68YjZmxo8NZPCRN7hnL7wIV/pCvkegIl+YSPw/PA6ihuxmVH62+EHaVV/
         vMyIOmNF0RCx9dOwd4Yi/PVX08TN0Yq8hrqntARx/9NyYtTnQczHvkQAZVlukeUTYH
         9m6ETFDuoY8ufkLnfFrnngwdePk+BZLhMTVHelNI=
Received: by mail-lj1-f176.google.com with SMTP id y16so11414606ljk.1
        for <linux-raid@vger.kernel.org>; Mon, 09 Nov 2020 09:43:20 -0800 (PST)
X-Gm-Message-State: AOAM531N+0fe3zcDDoEFJkTHRJYHUZwmgBhPaXNHmWHQwl5VR2jc0cj/
        nwiDa95iJbcTBdGoV5eZPHc6WaVMKwdLS7WQ5IY=
X-Google-Smtp-Source: ABdhPJwzJdhHPq57o2VuTTY26PjXVw7UOoOLLqRvXRFatIEPhIFJvvFgRW/v6BYh7eCPOObcVQK+bIM4kBHA9f8FAUs=
X-Received: by 2002:a2e:874a:: with SMTP id q10mr7165226ljj.446.1604943798503;
 Mon, 09 Nov 2020 09:43:18 -0800 (PST)
MIME-Version: 1.0
References: <1604847181-22086-1-git-send-email-heming.zhao@suse.com>
In-Reply-To: <1604847181-22086-1-git-send-email-heming.zhao@suse.com>
From:   Song Liu <song@kernel.org>
Date:   Mon, 9 Nov 2020 09:43:07 -0800
X-Gmail-Original-Message-ID: <CAPhsuW7HUE0btCjyxVGh-SuGY2AS1DBOsCOKywgkt=vNEicqjQ@mail.gmail.com>
Message-ID: <CAPhsuW7HUE0btCjyxVGh-SuGY2AS1DBOsCOKywgkt=vNEicqjQ@mail.gmail.com>
Subject: Re: [PATCH 0/2] md-cluster bugs fix
To:     Zhao Heming <heming.zhao@suse.com>,
        Guoqing Jiang <guoqing.jiang@cloud.ionos.com>
Cc:     linux-raid <linux-raid@vger.kernel.org>, lidong.zhong@suse.com,
        Xiao Ni <xni@redhat.com>, NeilBrown <neilb@suse.de>,
        Coly Li <colyli@suse.de>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi Guoqing,
On Sun, Nov 8, 2020 at 6:53 AM Zhao Heming <heming.zhao@suse.com> wrote:
>
[...]

Could you please help review the set? It looks good to me. But it will
be great to have
your review.

Thanks,
Song

>   - update sb (see commit 0ba959774)
>   - mdadm --remove (issue 2)
>   we should break the deadlock in key code (wait_event => wait_event_timeout).
>
> -------
> v1:
> - create patch
>
> -------
> Zhao Heming (2):
>   md/cluster: reshape should returns error when remote doing resyncing
>     job
>   md/cluster: fix deadlock when doing reshape job
>
>  drivers/md/md-cluster.c | 42 ++++++++++++++++++++++++++---------------
>  drivers/md/md.c         |  8 ++++++--
>  2 files changed, 33 insertions(+), 17 deletions(-)
>
> --
> 2.27.0
>
