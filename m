Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1ED53C433F5
	for <linux-raid@archiver.kernel.org>; Wed, 10 Nov 2021 17:03:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EF7CC61186
	for <linux-raid@archiver.kernel.org>; Wed, 10 Nov 2021 17:02:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230385AbhKJRFq (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 10 Nov 2021 12:05:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:50142 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230333AbhKJRFp (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Wed, 10 Nov 2021 12:05:45 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4AF2961211
        for <linux-raid@vger.kernel.org>; Wed, 10 Nov 2021 17:02:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636563778;
        bh=EC1C+shN7ygf5w21VNq7E7g2gRVM5hZ4pOikrPXetB0=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=uTW9t4bxQ404qbQ7/6L9ITNtYNuJEQZ10sjxDHG8pGmTSfmt615UPAFAB1Rz7u6mt
         8QzNTq0unKXMlCbNrWcFFPmj1WJFuyiks0ZXZOo1bRTQtp3k8my3X/OCXdAfmm1Z47
         OCEg21uYrkEdeK5S/NQw////Vqtty4JzfqN18Y+OMayLKGTN356ydJ1Lx5HrZOuARe
         nJse9f7hDQFDLWucQlvRcXQcvxazfgQu+xGZjbUvKw2po4c8Zy5lO9Ck+QzsjtxYGS
         qiMJlo7vADSfmowkHLkyfw24V2bj+Nt/04P2O7r5fOoSGrK10yzmY5pI53Gn8CPA5f
         PrUYlrMFMtlIw==
Received: by mail-yb1-f174.google.com with SMTP id y68so2866641ybe.1
        for <linux-raid@vger.kernel.org>; Wed, 10 Nov 2021 09:02:58 -0800 (PST)
X-Gm-Message-State: AOAM532ZabCVBn5cI7y4aMbfrlpOQrM/EaqQbrQhQh7CvFr0fiU9RHZx
        XTvHfImdtB+cgNhUAZAzA8bFkCZaB0DJhaJ2dxQ=
X-Google-Smtp-Source: ABdhPJwDWbACtF2E5v1y/RK7nTEPa2noV5gEmmupRaFxqnYyNf0h5u9CnGTgzMaC+joOo+/nVrEKzswDftlf/WNIeqA=
X-Received: by 2002:a25:348b:: with SMTP id b133mr660511yba.251.1636563777504;
 Wed, 10 Nov 2021 09:02:57 -0800 (PST)
MIME-Version: 1.0
References: <CAPhsuW5rGPP_6CZWC+W93dRHS6b3HJ7Yz4KR=r7ghhuZov2vfQ@mail.gmail.com>
 <20211104045149.9599-1-vverma@digitalocean.com> <CAPhsuW6mSmxPOmU9=Gq-z_gV4V09+SFqrpKx33LzR=6Rg1fGZw@mail.gmail.com>
 <97bff08e-ecb7-37d7-c113-7f33bfca02d9@digitalocean.com> <4d0dd51b-9176-99df-2002-77ecf48c6d20@digitalocean.com>
In-Reply-To: <4d0dd51b-9176-99df-2002-77ecf48c6d20@digitalocean.com>
From:   Song Liu <song@kernel.org>
Date:   Wed, 10 Nov 2021 09:02:46 -0800
X-Gmail-Original-Message-ID: <CAPhsuW56xhYA3Si65Hvvp-1HU3KTrjU8RN_aKWXw2A5C0YsVPA@mail.gmail.com>
Message-ID: <CAPhsuW56xhYA3Si65Hvvp-1HU3KTrjU8RN_aKWXw2A5C0YsVPA@mail.gmail.com>
Subject: Re: [PATCH v3 2/2] md: raid1 add nowait support
To:     Vishal Verma <vverma@digitalocean.com>
Cc:     linux-raid <linux-raid@vger.kernel.org>, rgoldwyn@suse.de,
        Jens Axboe <axboe@kernel.dk>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Tue, Nov 9, 2021 at 12:59 PM Vishal Verma <vverma@digitalocean.com> wrote:
>
> Hi Song,
>
> I did modify raid456 and raid10 with nowait support, but unfortunately
> have been running into kernel task hung and panics while doing write IO
> and having hard time trying to debug.
>
> Shall I post the patches in to get the feedback or go with an
> alternative route to have a flag to only enable nowait for raid1 for now?
>

There is still sufficient time before 5.17, so I would recommend we do all
personalities together. You can always post patches as RFC for feedback.

Thanks,
Song
