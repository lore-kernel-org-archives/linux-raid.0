Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86AFCC4708F
	for <linux-raid@archiver.kernel.org>; Tue,  1 Jun 2021 04:26:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 579F56135D
	for <linux-raid@archiver.kernel.org>; Tue,  1 Jun 2021 04:26:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229538AbhFAE14 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 1 Jun 2021 00:27:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:47600 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229460AbhFAE1z (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Tue, 1 Jun 2021 00:27:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EB77761364;
        Tue,  1 Jun 2021 04:26:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622521575;
        bh=kTDEMAz8rWtpn+7lWF3Whs8md2THwo5SZdP7apN9baI=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=Ntbxp9svHdTM/+vkRMNO1Ifufw+nC6KT2vbejPmaYv4sK0gHPCAIPrfh+xmgZZVhW
         rSJ504qOwnSAauX21Uk5ockuwsy7BtvdMoLqhlG3tdrv7xCJ8IPYNnP+UIeZDfgiFv
         pP9M4YoVWBKd9ASmW2cReOVybcVc8lktAaI0eVmkxZ4/Dip8ClFSn2HykUp/uVQwWn
         f3WQ+0DL4geSZNy1BbkfqTOo/uSJALz1kkLTEi6CjMO4KL3VfB8E6sCta33eJFC6JG
         2X8JHv4XyWixuTI7HuYTqL4RwFPRZz3WL+0OGvCehg6DTyZoTBiwS5t5P6yRiD1zy+
         EapetQDN1R7jQ==
Received: by mail-lf1-f44.google.com with SMTP id j10so19628170lfb.12;
        Mon, 31 May 2021 21:26:14 -0700 (PDT)
X-Gm-Message-State: AOAM533aiJXUtwBMPxSV8s+Ma3GEN0S56q1NB4ZU+flctVXotvIcUwpD
        Z7WTlcyxLbo0GZaUjUoo/CkUco1Bi+AucQ1Atws=
X-Google-Smtp-Source: ABdhPJxQmFqZTlDz8efVkUpysTeHIFNuEbhCx8qRhY/eO9YtADuRBg9FDoB7xHiTOTdDk984qIclxI7E+mKOmBkIqvQ=
X-Received: by 2002:a19:5208:: with SMTP id m8mr17363336lfb.372.1622521573292;
 Mon, 31 May 2021 21:26:13 -0700 (PDT)
MIME-Version: 1.0
References: <20210529103049.5022-1-rikard.falkeborn@gmail.com>
In-Reply-To: <20210529103049.5022-1-rikard.falkeborn@gmail.com>
From:   Song Liu <song@kernel.org>
Date:   Mon, 31 May 2021 21:26:02 -0700
X-Gmail-Original-Message-ID: <CAPhsuW48VzzhEv7MH9eKTR0cGU6S4T-bG1NUA9FoQko0OuGDcw@mail.gmail.com>
Message-ID: <CAPhsuW48VzzhEv7MH9eKTR0cGU6S4T-bG1NUA9FoQko0OuGDcw@mail.gmail.com>
Subject: Re: [PATCH] md: Constify attribute_group structs
To:     Rikard Falkeborn <rikard.falkeborn@gmail.com>
Cc:     linux-raid <linux-raid@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Sat, May 29, 2021 at 3:30 AM Rikard Falkeborn
<rikard.falkeborn@gmail.com> wrote:
>
> The attribute_group structs are never modified, they're only passed to
> sysfs_create_group() and sysfs_remove_group(). Make them const to allow
> the compiler to put them in read-only memory.
>
> Signed-off-by: Rikard Falkeborn <rikard.falkeborn@gmail.com>

Applied to md-next. Thanks!
Song
