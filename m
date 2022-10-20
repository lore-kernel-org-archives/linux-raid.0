Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C15F9C43217
	for <linux-raid@archiver.kernel.org>; Thu, 20 Oct 2022 19:04:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229923AbiJTTEg (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 20 Oct 2022 15:04:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229588AbiJTTEa (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 20 Oct 2022 15:04:30 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 074471DDDB
        for <linux-raid@vger.kernel.org>; Thu, 20 Oct 2022 12:04:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AF1F3B828D8
        for <linux-raid@vger.kernel.org>; Thu, 20 Oct 2022 19:04:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B312C43143
        for <linux-raid@vger.kernel.org>; Thu, 20 Oct 2022 19:04:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666292667;
        bh=cnF6mXi+LaR5NJ7UOJ/SLdY3pJ9Pb6kvZlP6oeMXsJI=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=GKzufJK/7BXjJXnaC4XltgajjN6sUij/gMH9LeDZUdk3pq12uhHY+zitHHIyYqK6L
         Httmqvsgxffcyf7iiQnNGJD6g6hKH4zzK94gezX/d2C9ltmiw/7REBi0uedOFsPlre
         FRy2OH8RM9cAIigl/l9vP2Ju4yfv6RFJXB63UyrSbiRUkRiEa5dwndGNNhg6o+dNBx
         sxisGoE5by9y2w5XRMe9z9qYTn9+8N7L52wsaY3/QCsFfZLNhd0cuMW2ou+BhyuNAY
         FuO4YQxrkI+/361mNqKAZaTIs1ZlZA7IjVBmrXA4xOYEZGO3G8aq8XjUe9Z/lelaAb
         WjJVaUd+V0WqA==
Received: by mail-ej1-f44.google.com with SMTP id k2so1844876ejr.2
        for <linux-raid@vger.kernel.org>; Thu, 20 Oct 2022 12:04:27 -0700 (PDT)
X-Gm-Message-State: ACrzQf2QXFMIZuOCTXGegRsE1w4L0J+OahIzmjOGNa93lIv37NhUF4vd
        Yts1LM8CYo3hHgNnjErUV2MuZ4nSofRguA14yEg=
X-Google-Smtp-Source: AMsMyM46Lp+eXawvnoN5mdwA413VBgzLHgpjpj0i+axekoVVBxO3j6inalPqmVZDduSZ7+9tnuqZMVLeYFiAs0YY5UI=
X-Received: by 2002:a17:907:7e87:b0:78e:1a4:130 with SMTP id
 qb7-20020a1709077e8700b0078e01a40130mr12675440ejc.101.1666292665614; Thu, 20
 Oct 2022 12:04:25 -0700 (PDT)
MIME-Version: 1.0
References: <20220920023938.3273598-1-yebin10@huawei.com>
In-Reply-To: <20220920023938.3273598-1-yebin10@huawei.com>
From:   Song Liu <song@kernel.org>
Date:   Thu, 20 Oct 2022 12:04:13 -0700
X-Gmail-Original-Message-ID: <CAPhsuW6-Q18OEcYr08T4mRzH2L876Ny0PrziDKBHc8i1M+Dnwg@mail.gmail.com>
Message-ID: <CAPhsuW6-Q18OEcYr08T4mRzH2L876Ny0PrziDKBHc8i1M+Dnwg@mail.gmail.com>
Subject: Re: [PATCH -next 0/3] do some cleanup for md_ioctl
To:     Ye Bin <yebin10@huawei.com>
Cc:     linux-raid@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Mon, Sep 19, 2022 at 7:28 PM Ye Bin <yebin10@huawei.com> wrote:
>
> Ye Bin (3):
>   md: refactor md ioctl cmd check
>   md: factor out __md_set_array_info()
>   md: introduce md_ro_state to make code easy to understand

Applied patch 2 and 3 to md-next, with some changes in the commit logs.
For future patches, please follow the guidance in
Documentation/process/submitting-patches.rst for the commit log.

Thanks,
Song

>
>  drivers/md/md.c | 249 +++++++++++++++++++++++++-----------------------
>  1 file changed, 131 insertions(+), 118 deletions(-)
>
> --
> 2.31.1
>
