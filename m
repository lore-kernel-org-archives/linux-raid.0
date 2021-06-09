Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38C07C47095
	for <linux-raid@archiver.kernel.org>; Wed,  9 Jun 2021 05:29:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 17683611BD
	for <linux-raid@archiver.kernel.org>; Wed,  9 Jun 2021 05:29:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236094AbhFIFbU (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 9 Jun 2021 01:31:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:49014 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231443AbhFIFbT (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Wed, 9 Jun 2021 01:31:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8E32C611BD
        for <linux-raid@vger.kernel.org>; Wed,  9 Jun 2021 05:29:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623216565;
        bh=svBHG4mjX/4zuX8O9FzKegZl/O1KW8dQQCH6m3dcifU=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=dRJihe3z7eybGQHTgoVY7F8O8LqSp4nDLvBL8+OM4r9hZQM70gGSIXpM4NrpKqI1P
         4XCpScPmaFE04FZfZ+9VtWAx8045Yj5X4uJE+s05AIYtOgBdch8V7ofRa9KEXlGh0r
         rhAw/FbPMZ0knJE0KG7yTvSYiT2/6HF7IUnRF443Nj0LEaeNW420l5oaVbwit5eCNB
         FF02G6eYzB9rX6239Kpc3xKesqxlxgQjijTWCg4bDUQc/pT2UkLWDWAWTtToULrpLi
         T1QYWjP9X4yPU4vHyB0+lecoLh2abxA4oqmB1wwPDPQp9MVgDGRe+5Hn3FWaaaZdcL
         YlYvL2J6+YlcA==
Received: by mail-lj1-f176.google.com with SMTP id 131so30099514ljj.3
        for <linux-raid@vger.kernel.org>; Tue, 08 Jun 2021 22:29:25 -0700 (PDT)
X-Gm-Message-State: AOAM530Am1hsTwpghgncXyvuJICg0ks81PwqOlpPfX2jC3d1zF36m+Ol
        LtK2so5J0xP11ixH5oE8xvUphzqqBhxvSF1zvY8=
X-Google-Smtp-Source: ABdhPJwTJ+P8y8f3MjvI9xpRXXHq7nLaevCUYgePk+fVcNsSzFWDoJOg7qv9/s2S3OEtfMa+D1S7ypm2rkRSdKnxHIY=
X-Received: by 2002:a2e:3a03:: with SMTP id h3mr14585423lja.357.1623216563811;
 Tue, 08 Jun 2021 22:29:23 -0700 (PDT)
MIME-Version: 1.0
References: <20210605152917.21806-1-lidong.zhong@suse.com>
In-Reply-To: <20210605152917.21806-1-lidong.zhong@suse.com>
From:   Song Liu <song@kernel.org>
Date:   Tue, 8 Jun 2021 22:29:12 -0700
X-Gmail-Original-Message-ID: <CAPhsuW7jGANVSYEWQVUkYu2W7ctKiUKJ3KxNEpjMz+P1bePZXw@mail.gmail.com>
Message-ID: <CAPhsuW7jGANVSYEWQVUkYu2W7ctKiUKJ3KxNEpjMz+P1bePZXw@mail.gmail.com>
Subject: Re: [RESEND] md: adding a new flag MD_DELETING
To:     Lidong Zhong <lidong.zhong@suse.com>
Cc:     linux-raid <linux-raid@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi Lidong,

On Sat, Jun 5, 2021 at 8:29 AM Lidong Zhong <lidong.zhong@suse.com> wrote:
>
> The mddev data structure is freed in mddev_delayed_delete(), which is
> schedualed after the array is deconfigured completely when stopping. So
> there is a race window between md_open() and do_md_stop(), which leads
> to /dev/mdX can still be opened by userspace even it's not accessible
> any more. As a result, a DeviceDisappeared event will not be able to be
> monitored by mdadm in monitor mode. This patch tries to fix it by adding
> this new flag MD_DELETING.
>
> Signed-off-by: Lidong Zhong <lidong.zhong@suse.com>

The patch still contains a lot of bad format strings. How did you send
it? I guess
it is not from git-send-email?

Thanks,
Song
