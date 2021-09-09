Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A90BC433F5
	for <linux-raid@archiver.kernel.org>; Thu,  9 Sep 2021 06:14:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0563E61158
	for <linux-raid@archiver.kernel.org>; Thu,  9 Sep 2021 06:14:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352075AbhIIGPe (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 9 Sep 2021 02:15:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:44944 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232357AbhIIGPc (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Thu, 9 Sep 2021 02:15:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BD33361176
        for <linux-raid@vger.kernel.org>; Thu,  9 Sep 2021 06:14:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631168063;
        bh=kfibSuV0sjJbhAx0kVB+fjPrq7yoBLwm6E+H5aSU9jA=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=U6ZGeRboJLolLMlwsuAhMoHIRgB4rG5inJV+Rbyjkg3vgWeFvLg9A4VLigl8WckCH
         kzJuyWVWE3PdrGY+TTfajrqDsGfFp2n6XTerfXCQLDdtlSkORDhMYC089zxsuRMzJg
         ZwM3guKTAT1EzvrOx9x95PDD9JCLr/nj7C2Oq/HWQzWWsl+wRnddsjnFCwtPqzA4cF
         KAIkRiKhbwP4M2uxrcyJds+GJtpNJbMG+eVct0KUfE9Qh0uEgepHcvzS0g0z1B0CIS
         8cECTiuypm2zyzEa3e+V3j2hlvqLnA1h/EkAqq6ol/7FcapoLjDg3yM5YcaWuZ9x2X
         U6lxrNIGUJVjQ==
Received: by mail-lj1-f175.google.com with SMTP id f2so1256882ljn.1
        for <linux-raid@vger.kernel.org>; Wed, 08 Sep 2021 23:14:23 -0700 (PDT)
X-Gm-Message-State: AOAM532LBBcSW8Vk4AcrBVTdVkGZYgAo3JOjUHDqZNaBnpf26uzqEprs
        QC2BadEru7xAT65g7aZ/FQ2hHPGD5xxtevuAKkk=
X-Google-Smtp-Source: ABdhPJw2STYdPuRYRspO0NB/CTGskRGq/02+Q9O3tsFt8b99tycOxWdT0yzlsgHBBv10B1Lr6U/34fCRCl/F3qTIvDY=
X-Received: by 2002:a2e:b80c:: with SMTP id u12mr924887ljo.436.1631168062104;
 Wed, 08 Sep 2021 23:14:22 -0700 (PDT)
MIME-Version: 1.0
References: <20210901113833.1334886-1-hch@lst.de>
In-Reply-To: <20210901113833.1334886-1-hch@lst.de>
From:   Song Liu <song@kernel.org>
Date:   Wed, 8 Sep 2021 23:14:11 -0700
X-Gmail-Original-Message-ID: <CAPhsuW4DPag3p3CzV6poimFBPgdCs8mfQoMg8RnCdY4ti20trw@mail.gmail.com>
Message-ID: <CAPhsuW4DPag3p3CzV6poimFBPgdCs8mfQoMg8RnCdY4ti20trw@mail.gmail.com>
Subject: Re: fix a lock order reversal in md_alloc
To:     Christoph Hellwig <hch@lst.de>
Cc:     Luis Chamberlain <mcgrof@kernel.org>,
        linux-raid <linux-raid@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Wed, Sep 1, 2021 at 4:39 AM Christoph Hellwig <hch@lst.de> wrote:
>
> Hi Song,
>
> the first patch in this series fixed the reported lock order reversal
> in md_alloc.  The rest sort out the error handling in that function,
> starting with the patch from Luis to handle add_disk errors, which
> would otherwise conflict with the first patch.
>
> Note that I have had a hard time verifying this all works fine as the
> testsuite in mdadm already keeps failing a lot for me with the baseline
> kernel. Some of thos reproducibly and others randomly.  Is there a
> good document somehow describing what to expect from the mdadm test
> suite?
>
> Diffstat:
>  drivers/md/md.c |   56 +++++++++++++++++++++++++++++---------------------------
>  1 file changed, 29 insertions(+), 27 deletions(-)

Applied to md-fixes. Thanks!

Song
