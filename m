Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D04FC388F7
	for <linux-raid@archiver.kernel.org>; Mon,  9 Nov 2020 18:07:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 334CE206F1
	for <linux-raid@archiver.kernel.org>; Mon,  9 Nov 2020 18:07:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="0GCnp2j3"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730237AbgKISHK (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 9 Nov 2020 13:07:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:49642 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730096AbgKISHK (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Mon, 9 Nov 2020 13:07:10 -0500
Received: from mail-lf1-f43.google.com (mail-lf1-f43.google.com [209.85.167.43])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A4CEA206F1
        for <linux-raid@vger.kernel.org>; Mon,  9 Nov 2020 18:07:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604945230;
        bh=PL6XpFpFC6/ePZqKxKifm+PVszStAQ18rQIwSi0DCrc=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=0GCnp2j3pFGcDQeqJk4HGo9I3dpNYoc7QbZqY+t7wxCicP0N6tYC5l81H+opnuGSl
         qvKrm3QZKSEe/QMn9WA6S9vOvnkzbM8Hh6nCd2pVhFvBcuNcW5BJKkf6O0yWcYlKMg
         PpHemI3YFZBpPAuPYFheZTRlA8uFnZJ+pIe9EJl0=
Received: by mail-lf1-f43.google.com with SMTP id s30so13733530lfc.4
        for <linux-raid@vger.kernel.org>; Mon, 09 Nov 2020 10:07:09 -0800 (PST)
X-Gm-Message-State: AOAM533OICHwosrEuVKD7K0FA5LOr75DIShCxQ/A+V7rdm/JDuL8PKoi
        hXCnLCyxxquIq2mOsWL7nKDwbvzrgF89BhSMDVg=
X-Google-Smtp-Source: ABdhPJyozf52gRRjh35/tVWKbs0ycARqBIUK5Jiaq7nXFTGaMyR54/8Z7QGbefKKHG9AqKuTNBOCZDQhoV2o3mHLG1Y=
X-Received: by 2002:a19:22d8:: with SMTP id i207mr5908342lfi.55.1604945227852;
 Mon, 09 Nov 2020 10:07:07 -0800 (PST)
MIME-Version: 1.0
References: <1604847181-22086-1-git-send-email-heming.zhao@suse.com>
 <1604847181-22086-3-git-send-email-heming.zhao@suse.com> <6dee90a2-4074-c3fd-a4ec-5e006a236b7a@suse.com>
In-Reply-To: <6dee90a2-4074-c3fd-a4ec-5e006a236b7a@suse.com>
From:   Song Liu <song@kernel.org>
Date:   Mon, 9 Nov 2020 10:06:56 -0800
X-Gmail-Original-Message-ID: <CAPhsuW5b1LCNNZAarCE7xTHkYe4u4psQ3cxP5KWA0hLRr0n+VA@mail.gmail.com>
Message-ID: <CAPhsuW5b1LCNNZAarCE7xTHkYe4u4psQ3cxP5KWA0hLRr0n+VA@mail.gmail.com>
Subject: Re: [PATCH 2/2] md/cluster: fix deadlock when doing reshape job
To:     "heming.zhao@suse.com" <heming.zhao@suse.com>
Cc:     linux-raid <linux-raid@vger.kernel.org>,
        Guoqing Jiang <guoqing.jiang@cloud.ionos.com>,
        lidong.zhong@suse.com, Xiao Ni <xni@redhat.com>,
        NeilBrown <neilb@suse.de>, Coly Li <colyli@suse.de>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Sun, Nov 8, 2020 at 6:02 PM heming.zhao@suse.com
<heming.zhao@suse.com> wrote:
>
> Please note, I gave two solutions for this bug in cover-letter.
> This patch uses solution 2. For detail, please check cover-letter.
>
> Thank you.
>

[...]

> >
> > How to fix:
> >
> > There are two sides to fix (or break the dead loop):
> > 1. on sending msg side, modify lock_comm, change it to return
> >     success/failed.
> >     This will make mdadm cmd return error when lock_comm is timeout.
> > 2. on receiving msg side, process_metadata_update need to add error
> >     handling.
> >     currently, other msg types won't trigger error or error doesn't need
> >     to return sender. So only process_metadata_update need to modify.
> >
> > Ether of 1 & 2 can fix the hunging issue, but I prefer fix on both side.
> >

Similar comments on how to make the commit log easy to understand.
Besides that, please split the change into two commits, for fix #1 and #2
respectively.

Thanks,
Song
