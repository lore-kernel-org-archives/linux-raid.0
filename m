Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35594C433FE
	for <linux-raid@archiver.kernel.org>; Wed,  2 Feb 2022 18:24:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346617AbiBBSYm (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 2 Feb 2022 13:24:42 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:51508 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346642AbiBBSYl (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 2 Feb 2022 13:24:41 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 03F04B83245
        for <linux-raid@vger.kernel.org>; Wed,  2 Feb 2022 18:24:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9578C004E1
        for <linux-raid@vger.kernel.org>; Wed,  2 Feb 2022 18:24:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643826279;
        bh=Lvs//ECPk5ahcwC5b6f99s5Jq2jIN8fw5zBlMH3jrpo=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=uGkhY9gCRH3BTSGNDmpkPPTLwe0Ig0w8vqVjdoIUa3eHBIUBeDjm5uhZSsXMdDpjC
         HPH3C8jlEmmx1903uT5Jjz94nKnt+qJNfAVHFsNOIvuVVsYeT7JT07A7lsyEoQa89R
         7ZEsuD6XLbDnQNm5f8fZps3TUVQhGx83s2TS3JAtzAmIutOWU5cNd5cJzbu4PmqyD/
         bFoFhiCjkDql/JR3yQGSixUtVpV7mtogae20gsP4MQ4rAowh3Q0hU9PWm4gpa767HK
         VeYwjHK3tmsEWolvGcbvkQQek2AjO58eLs3SQyv+xiPsElPqkNK1uIoATz9uzM8Sy2
         p6JVMXehOVc8A==
Received: by mail-yb1-f177.google.com with SMTP id r65so1138890ybc.11
        for <linux-raid@vger.kernel.org>; Wed, 02 Feb 2022 10:24:39 -0800 (PST)
X-Gm-Message-State: AOAM531uA3FOtJBDC9b7/k4yLAZ4sEa2wpNQDgLY7eR5v8GLP86fLxwb
        LZKfShlgqt85WqELOKtYyz3lSxFgXP1o9P91JH8=
X-Google-Smtp-Source: ABdhPJzRwObOFQN3ToP0rdCkxhHwbaA5Dmn0zwV0d5JK3Jx9jk2oxRZV3DCzYOpEhRBXusy6Dx2uxSogytUetGg+vdA=
X-Received: by 2002:a5b:a03:: with SMTP id k3mr43926592ybq.219.1643826278831;
 Wed, 02 Feb 2022 10:24:38 -0800 (PST)
MIME-Version: 1.0
References: <a673c90f-d9eb-c6d5-b675-e6c2e1c04e5f@totally.rip>
 <CAPhsuW5H1uROu868FhS5MNXuP=nS_=6b8zUrFv4jBjPEA=joPQ@mail.gmail.com>
 <858fc88b-40fe-5bb4-e9be-e8b5f66ff562@totally.rip> <CAPhsuW5yfv_ahTwuGCNwgGwyFMpzBOSLwpQH=_PB+MH1zVx_fw@mail.gmail.com>
 <9077941e-d1c6-0bfd-b0ec-5698d40fc677@totally.rip>
In-Reply-To: <9077941e-d1c6-0bfd-b0ec-5698d40fc677@totally.rip>
From:   Song Liu <song@kernel.org>
Date:   Wed, 2 Feb 2022 10:24:27 -0800
X-Gmail-Original-Message-ID: <CAPhsuW67j8PxFLn2rip18AhZu5TynozGoQdMEU0stwWhYj0E6w@mail.gmail.com>
Message-ID: <CAPhsuW67j8PxFLn2rip18AhZu5TynozGoQdMEU0stwWhYj0E6w@mail.gmail.com>
Subject: Re: NULL pointer dereference in blk_queue_flag_set
To:     jkhsjdhjs <jkhsjdhjs@totally.rip>
Cc:     linux-raid <linux-raid@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Wed, Feb 2, 2022 at 9:55 AM jkhsjdhjs <jkhsjdhjs@totally.rip> wrote:
>
> Yes, I'd like that. Since I have never done that before I looked it up
> and it seems to me that you'll just add Reported-by and Tested-by to the
> commit message. In this case please use Reported-by: Leon M=C3=B6ller
> <jkhsjdhjs@totally.rip> and similar for the Tested-by line. Thanks!
>

Pushed the fix to md-fixes. Thanks again!

Song
