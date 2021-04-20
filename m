Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4751C433B4
	for <linux-raid@archiver.kernel.org>; Tue, 20 Apr 2021 23:15:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 612896141F
	for <linux-raid@archiver.kernel.org>; Tue, 20 Apr 2021 23:15:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234353AbhDTXQI (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 20 Apr 2021 19:16:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:39482 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233964AbhDTXQI (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Tue, 20 Apr 2021 19:16:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F33036141C
        for <linux-raid@vger.kernel.org>; Tue, 20 Apr 2021 23:15:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618960536;
        bh=+XdPOaO3QWj8rOMLM7SQVcMNnNwgeNQdVgxaB5Y6mYQ=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=UI3tVfSNusOxKxYvufcdPOwwMeLL/EmXm31uBBwvcETtkwQ8XD1951mNKn0Cx4ub2
         rMevfK+iGg3gFzQqnhF2btk26uu9q/V3yVV58ZQxUqXnEPBVvVyrueIHtXHhv/m0ze
         syjKLSXqsGndVdqrx29g5+XnFbxhVKW9E96leJdTLt5u0fPaVZMQ6SCWRmd/iC2SNh
         uV2YJnxJbi1xS0bAZavvTs3/gaf9sm3slkNnM1pQEkd06UUhnwKit7ervadv+EjiuS
         B0Z6rntKFpreU76X+00IoRKQn7DPaDXnhEirb3s7wuueVNDXfWqGoKli3qL/WR2rV7
         6ZMAk7lN/8riQ==
Received: by mail-lj1-f169.google.com with SMTP id u4so45535889ljo.6
        for <linux-raid@vger.kernel.org>; Tue, 20 Apr 2021 16:15:35 -0700 (PDT)
X-Gm-Message-State: AOAM531rmPE4SNblu9C1Zifm4Ly/29GQEqjEHPFICDRZscyvyLZyJs6J
        tNvyLNexqOeMrqYvuxFFPf6wdAicSCPNyc8WIpI=
X-Google-Smtp-Source: ABdhPJyyZ+MfcCuC/CBJOWv2ZhHcXwv0RsvsUnnXz1Exx5BOjZywXF1XEFqh8bU9BdYzGTN/cBa5/FWoXW+yE83fe/o=
X-Received: by 2002:a05:651c:2006:: with SMTP id s6mr6019595ljo.177.1618960534199;
 Tue, 20 Apr 2021 16:15:34 -0700 (PDT)
MIME-Version: 1.0
References: <1617867855-17481-1-git-send-email-heming.zhao@suse.com>
In-Reply-To: <1617867855-17481-1-git-send-email-heming.zhao@suse.com>
From:   Song Liu <song@kernel.org>
Date:   Tue, 20 Apr 2021 16:15:23 -0700
X-Gmail-Original-Message-ID: <CAPhsuW7QnNbAcjVOWzZMJPHiJ+EVcSyxBN9+MogkPHndXvaSBQ@mail.gmail.com>
Message-ID: <CAPhsuW7QnNbAcjVOWzZMJPHiJ+EVcSyxBN9+MogkPHndXvaSBQ@mail.gmail.com>
Subject: Re: [PATCH v2] md-cluster: fix use-after-free issue when removing rdev
To:     Heming Zhao <heming.zhao@suse.com>
Cc:     linux-raid <linux-raid@vger.kernel.org>, ghe@suse.com,
        lidong.zhong@suse.com, Xiao Ni <xni@redhat.com>,
        Coly Li <colyli@suse.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Thu, Apr 8, 2021 at 12:44 AM Heming Zhao <heming.zhao@suse.com> wrote:
>
[...]

>
> v2:
> - modify commit comments
>   - add env info for test script
>   - add 'Fixes' filed
> v1:
> - create patch
> ---
> Fixes: dbb64f8635f5d ("md-cluster: Fix adding of new disk with new
> reload code")
> Fixes: 659b254fa7392 ("md-cluster: remove a disk asynchronously from
> cluster environment")
> Reviewed-by: Gang He <ghe@suse.com>
> Signed-off-by: Heming Zhao <heming.zhao@suse.com>

Sorry for the delay. Applied to md-next.

Btw: I think you meant to push change list (v2, v1, ..) after the signed-off-by
section? With this patch as-is, the signed-off-by section was dropped during
git-am.

Thanks,
Song
