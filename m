Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 706D6C433B4
	for <linux-raid@archiver.kernel.org>; Mon,  5 Apr 2021 17:11:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 38D91613B4
	for <linux-raid@archiver.kernel.org>; Mon,  5 Apr 2021 17:11:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235641AbhDERLt (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 5 Apr 2021 13:11:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:49372 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230125AbhDERLs (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Mon, 5 Apr 2021 13:11:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BB8BC6128D
        for <linux-raid@vger.kernel.org>; Mon,  5 Apr 2021 17:11:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617642702;
        bh=rCL6ZLcb5FVpOpC1/CehkT8/E5BkVQIK7T6p6TkeK+Y=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=daScfmmEy+10sCAjpSTdoZEbxwjiOmQYIjwVYZyjTvlPzQXv8gdUwogVKmt8jJq8d
         d6XSip4wvjl8wVI+pQ2oaUoL3QoqY4BHn7etTgHzgCCzZ3JNmiqkhX4EUhnVHDdMTC
         luBKkEpQ+qu/3BXQ+FtTsll6k2EKLEkMvCXio/lXZ8q7s8xGkuseSZ5Psy5vmRtfoc
         UhtB0oY+ICFJK+i3Lxxz6hROU23yA/AelgLX+L6Qw2//c+cICThQpu6i+2M7w6z6Zl
         FIHlsUJ8fFA3WP7U9roq3EynWqD3mUkNPlYRB4nxC4KbkpqrX+9y55ISgbKLpV6oKH
         /EhXShSP+ZEug==
Received: by mail-lf1-f45.google.com with SMTP id r8so907005lfp.10
        for <linux-raid@vger.kernel.org>; Mon, 05 Apr 2021 10:11:41 -0700 (PDT)
X-Gm-Message-State: AOAM532TLzokgEjK96alkjchwaK9z6UcMysamN+3bNHbE+q1bLQsqJex
        iSuJbDwDxq09I9wTvCGpmbg+hiRYU3+6tNY5ejo=
X-Google-Smtp-Source: ABdhPJzSG/hvDeYfHKRUNKjVHJ8pI7Nn5pxNy9DQXFt3Il5EZaH5l+64xnAT/e3o7DjI3ZPKsjygaJu1d4unH/dzl4s=
X-Received: by 2002:a05:6512:3582:: with SMTP id m2mr18297218lfr.10.1617642700154;
 Mon, 05 Apr 2021 10:11:40 -0700 (PDT)
MIME-Version: 1.0
References: <20210403161529.659555-1-hch@lst.de>
In-Reply-To: <20210403161529.659555-1-hch@lst.de>
From:   Song Liu <song@kernel.org>
Date:   Mon, 5 Apr 2021 10:11:29 -0700
X-Gmail-Original-Message-ID: <CAPhsuW67cH+ryCgHLEWzRHHtqaKN5hg8iP1qJEyUsv5SfeiKLg@mail.gmail.com>
Message-ID: <CAPhsuW67cH+ryCgHLEWzRHHtqaKN5hg8iP1qJEyUsv5SfeiKLg@mail.gmail.com>
Subject: Re: split mddev_find and don't create new instance in ->open
To:     Christoph Hellwig <hch@lst.de>
Cc:     Zhao Heming <heming.zhao@suse.com>, lidong.zhong@suse.com,
        linux-raid <linux-raid@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Sat, Apr 3, 2021 at 9:15 AM Christoph Hellwig <hch@lst.de> wrote:
>
>
> Hi Song,
>
> this series split mddev_find so that no new instances get created
> in ->open.  This was originally part of a larger cleanup, but it
> turns out to actually fix a bug found by Zhao.

Applied this set and Heming's patch to md-next.

Thanks Christoph and Heming!
Song
