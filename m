Return-Path: <SRS0=ezIp=CY=vger.kernel.org=linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23ED8C43461
	for <linux-raid@archiver.kernel.org>; Tue, 15 Sep 2020 06:29:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D4A352076C
	for <linux-raid@archiver.kernel.org>; Tue, 15 Sep 2020 06:29:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1600151371;
	bh=RLga8LF5iD4S85hmCJW8U6QK9bfSDuWw0boHGw0pI1o=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=GbRtwDA/k4GvR76lqnXmD9/hAzuuFGpp3oU8Z/Y08TUfmAc/2jJnNIV8GiWCnpOE0
	 OR6wou1Qxn+wZBLwa9C6K9mB7bYUCj+w/uLBKJ1U4W508ekmOMx6HRpMr9dMvOpUvi
	 X22/RQicQ3Sj4dgPxOm336hzPdGgxWIHn83uuljM=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726048AbgIOG3b (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 15 Sep 2020 02:29:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:44576 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726031AbgIOG33 (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Tue, 15 Sep 2020 02:29:29 -0400
Received: from mail-lf1-f47.google.com (mail-lf1-f47.google.com [209.85.167.47])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AE90C20770
        for <linux-raid@vger.kernel.org>; Tue, 15 Sep 2020 06:29:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600151369;
        bh=RLga8LF5iD4S85hmCJW8U6QK9bfSDuWw0boHGw0pI1o=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=apwbZsKRnrFAC8iiLqn//tNmpTagzR/BcuXkS5eO+fdyTZSdmAy5A9+Y/6cF4oMNq
         Ad8NtnTVRwrjHPWJEz2pETWAy6pI/V7R/8b+N/v66bU05QuNcj0oEq8zRmGlW5zNx3
         ppRR7OP4yX4qTB3L1bC/EViPm2h2yw4BQgB2p6pg=
Received: by mail-lf1-f47.google.com with SMTP id m5so1853006lfp.7
        for <linux-raid@vger.kernel.org>; Mon, 14 Sep 2020 23:29:28 -0700 (PDT)
X-Gm-Message-State: AOAM532QI+beMpLo30d++O/jcXZBdrSO3Zs8G8h693SaPXGiB1eccKu9
        yAvEr4LjcX/KW0e9bcZBbQ+bPkRvS5LqZNtl5Yc=
X-Google-Smtp-Source: ABdhPJx3Ug3HelxtonztfeSidloGY5BZbSTuDhZBvIJcb6nSKfqk1zP5hX53DzIik7aCkZEuJTnMG7Mx/ynW5XqZzGQ=
X-Received: by 2002:a19:cc09:: with SMTP id c9mr4970575lfg.482.1600151367014;
 Mon, 14 Sep 2020 23:29:27 -0700 (PDT)
MIME-Version: 1.0
References: <1599048023-9957-1-git-send-email-xni@redhat.com>
In-Reply-To: <1599048023-9957-1-git-send-email-xni@redhat.com>
From:   Song Liu <song@kernel.org>
Date:   Mon, 14 Sep 2020 23:29:16 -0700
X-Gmail-Original-Message-ID: <CAPhsuW4QOVmd9xhtQ4WqKd7Lw9Vh-0GBWKtO+OoannDiE5fCrw@mail.gmail.com>
Message-ID: <CAPhsuW4QOVmd9xhtQ4WqKd7Lw9Vh-0GBWKtO+OoannDiE5fCrw@mail.gmail.com>
Subject: Re: [PATCH V6 0/3] md/raid10: Improve handling raid10 discard request
To:     Xiao Ni <xni@redhat.com>
Cc:     linux-raid <linux-raid@vger.kernel.org>,
        Heinz Mauelshagen <heinzm@redhat.com>,
        Nigel Croxon <ncroxon@redhat.com>,
        Guoqing Jiang <guoqing.jiang@cloud.ionos.com>,
        Coly Li <colyli@suse.de>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-raid-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Wed, Sep 2, 2020 at 5:00 AM Xiao Ni <xni@redhat.com> wrote:
>
> Hi all
>
> Now mkfs on raid10 which is combined with ssd/nvme disks takes a long time.
> This patch set tries to resolve this problem.
>
> v1:
> Coly helps to review these patches and give some suggestions:
> One bug is found. If discard bio is across one stripe but bio size is
> bigger than one stripe size. After spliting, the bio will be NULL.
> In this version, it checks whether discard bio size is bigger than
> (2*stripe_size).
> In raid10_end_discard_request, it's better to check R10BIO_Uptodate
> is set or not. It can avoid write memory to improve performance.
> Add more comments for calculating addresses.
>
> v2:
> Fix error by checkpatch.pl
> Fix one bug for offset layout. v1 calculates wrongly split size
> Add more comments to explain how the discard range of each component disk
> is decided.
>
> v3:
> add support for far layout
> Change the patch name
>
> v4:
> Pull codes that wait for blocked device into a seprate function
> It can't use (stripe_size-1) as a mask to calculate. (stripe_size-1) may
> not be power of 2.
> It doesn't need to use a full copy of geo.
> Fix warning by checkpatch.pl
>
> v5:
> In 32bit platform, it doesn't support 64bit devide by 32bit value.
> Reported-by: kernel test robot <lkp@intel.com>
>
> v6:
> Move the codes that calculate discard start/size into specific raid type.
> Remove discard support for reshape

Sorry for the delay.

I apply the set to md-next. Please keep testing and try to fix discard with
reshape. I will also run tests.

Thanks,
Song
