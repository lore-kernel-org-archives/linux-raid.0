Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D93C0C433F5
	for <linux-raid@archiver.kernel.org>; Fri,  8 Oct 2021 23:35:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BF55760F5E
	for <linux-raid@archiver.kernel.org>; Fri,  8 Oct 2021 23:35:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243836AbhJHXhy (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 8 Oct 2021 19:37:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:33368 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243852AbhJHXhu (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Fri, 8 Oct 2021 19:37:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A3DCA60F5E;
        Fri,  8 Oct 2021 23:35:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633736154;
        bh=ygdbHNfiFjdQlGKHwLNaHKd7gBrfLHesNIj68BQojSg=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=O6I8oUldcj4isurmMPyN8hYLGr14A7VVP2i06wxFwSkBhslSsAK6p6rTsgXxusJ5r
         WvBVIBIUp5S/RfQ1Lb3fFh/bGCj8xxkVgMmqRZMivWu8Wg7t6IOPrHOq8b7gnDFuQt
         +UaEfOEImQUSJx/Sf1kXgJyGZ/anRPiEYXLN8lUiM48rc+Ix/EEDVEofuvR5BcGHkx
         y5+CFxQ4m6EWkYY4u6yfydZj41Kl5KwwERfaumnX0U2WPYnOXq/Z7eKKfp+rnUt5vl
         AjiBJ4LYt7MO71RC34K8Jbn1EFWiqwqHxmsIaP8p3hSt6/LQqI6yYmf0IL9zacWLdt
         7RVkfBCbyX/Iw==
Received: by mail-lf1-f41.google.com with SMTP id u18so45111865lfd.12;
        Fri, 08 Oct 2021 16:35:54 -0700 (PDT)
X-Gm-Message-State: AOAM533yKkZOrNITVoaV+PKulcnzoBeS1szcQsHYntEWmBVBirWhMEU7
        zFL911nU8siR8/bQAw7pD+wb9YmnNZ83RKvWr1k=
X-Google-Smtp-Source: ABdhPJzYC1Vs2cAOtnPPFw8iytYViNi7adRVvHdjWr6xtZWM3+E7+sZ6iBzYy8VWRlHblplmZj0FX3r9hCIB+DlkjhI=
X-Received: by 2002:ac2:5182:: with SMTP id u2mr12805756lfi.676.1633736152894;
 Fri, 08 Oct 2021 16:35:52 -0700 (PDT)
MIME-Version: 1.0
References: <20211008032231.1143467-1-fengli@smartx.com>
In-Reply-To: <20211008032231.1143467-1-fengli@smartx.com>
From:   Song Liu <song@kernel.org>
Date:   Fri, 8 Oct 2021 16:35:41 -0700
X-Gmail-Original-Message-ID: <CAPhsuW5+bdQwsyjBP=QDGRbtnF021291D_XrhNtV+v-geVouVg@mail.gmail.com>
Message-ID: <CAPhsuW5+bdQwsyjBP=QDGRbtnF021291D_XrhNtV+v-geVouVg@mail.gmail.com>
Subject: Re: [PATCH RESEND] md: allow to set the fail_fast on RAID1/RAID10
To:     Li Feng <fengli@smartx.com>
Cc:     "open list:SOFTWARE RAID (Multiple Disks) SUPPORT" 
        <linux-raid@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Thu, Oct 7, 2021 at 8:22 PM Li Feng <fengli@smartx.com> wrote:
>
> When the running RAID1/RAID10 need to be set with the fail_fast flag,
> we have to remove each device from RAID and re-add it again with the
> --fail_fast flag.
>
> Export the fail_fast flag to the userspace to support the read and
> write.
>
> Signed-off-by: Li Feng <fengli@smartx.com>

Thanks for the patch! I applied it to md-next, with some changes in the
commit log.

Thanks,
Song
