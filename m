Return-Path: <SRS0=g69Z=EM=vger.kernel.org=linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3866EC388F7
	for <linux-raid@archiver.kernel.org>; Fri,  6 Nov 2020 00:59:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D472E20B80
	for <linux-raid@archiver.kernel.org>; Fri,  6 Nov 2020 00:59:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1604624357;
	bh=7ZEnEByVc0R517QJnXpcoY8tP3coLZ3Q0yNiPZUgtgg=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=nAghOa2BeWfRWfBKZ3kIzy7IKlv8eFREd+IeSKUjsWSayELoPoIiqBE8AxylEGap5
	 vzeD1YwDdAkPGJYAkB3Ecs7S8jnRTINL357s+b8Wef81AkOqSvrS1qno/DFpWNggjT
	 Q0zM5Viwc8ztqAtJtT81dguHKGSV6SSnZcjnis3E=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732684AbgKFA7Q (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 5 Nov 2020 19:59:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:37866 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729162AbgKFA7Q (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Thu, 5 Nov 2020 19:59:16 -0500
Received: from mail-lj1-f172.google.com (mail-lj1-f172.google.com [209.85.208.172])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 874D020B80;
        Fri,  6 Nov 2020 00:59:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604624355;
        bh=7ZEnEByVc0R517QJnXpcoY8tP3coLZ3Q0yNiPZUgtgg=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=LNpnrV7M/iN+V4ujDAzN/T3tay3OStPr/YwN3bQLZEZRpTgr0YhvNN4iBgBUJLUf3
         Eyu6tRaITH92HSP28KFJe9mve+CEskk+7qXQLpjeDebpDpVOQUSpkbvXaaONO39bxV
         IJUM6BAFBL4N5Ww5w31SVrYbaTEzjrMQ+XrSEDIA=
Received: by mail-lj1-f172.google.com with SMTP id v18so1721207ljc.3;
        Thu, 05 Nov 2020 16:59:15 -0800 (PST)
X-Gm-Message-State: AOAM5326MOuS1QQqb4Zj2wC8GUOUq9Lx7YsQGQNBHszlCCCOOEjJS3Mn
        SXKGJl4UrcRGfajUsf4yyjWZIMcSDtiAMLstp0U=
X-Google-Smtp-Source: ABdhPJyXOcSc3bNtfvoEDL2fsq2W1tQrSuxExDjK8UvdpyheAJjMXI2e+jMAtLr0Lt7iM9E9hRacrnZUBqM91DJOAeg=
X-Received: by 2002:a2e:50d:: with SMTP id 13mr1899629ljf.41.1604624353730;
 Thu, 05 Nov 2020 16:59:13 -0800 (PST)
MIME-Version: 1.0
References: <20201103100018.683694-1-hch@lst.de> <20201103100018.683694-6-hch@lst.de>
In-Reply-To: <20201103100018.683694-6-hch@lst.de>
From:   Song Liu <song@kernel.org>
Date:   Thu, 5 Nov 2020 16:59:02 -0800
X-Gmail-Original-Message-ID: <CAPhsuW65Au-wJJo96KF0J3drdriCqHZ9Oa3=bfjfspV3tKByrg@mail.gmail.com>
Message-ID: <CAPhsuW65Au-wJJo96KF0J3drdriCqHZ9Oa3=bfjfspV3tKByrg@mail.gmail.com>
Subject: Re: [PATCH 05/10] md: implement ->set_read_only to hook into BLKROSET processing
To:     Christoph Hellwig <hch@lst.de>
Cc:     Jens Axboe <axboe@kernel.dk>, Ilya Dryomov <idryomov@gmail.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Richard Weinberger <richard@nod.at>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Stefan Haberland <sth@linux.ibm.com>,
        Jan Hoeppner <hoeppner@linux.ibm.com>,
        linux-block@vger.kernel.org, ceph-devel@vger.kernel.org,
        linux-bcache@vger.kernel.org,
        linux-raid <linux-raid@vger.kernel.org>,
        linux-mtd@lists.infradead.org, linux-s390@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Tue, Nov 3, 2020 at 2:13 AM Christoph Hellwig <hch@lst.de> wrote:
>
> Implement the ->set_read_only method instead of parsing the actual
> ioctl command.
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>

LGTM!

Acked-by: Song Liu <song@kernel.org>
