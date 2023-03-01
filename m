Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7099DC64ED6
	for <linux-raid@archiver.kernel.org>; Wed,  1 Mar 2023 12:37:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229537AbjCAMha (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 1 Mar 2023 07:37:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229486AbjCAMh3 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 1 Mar 2023 07:37:29 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 131E53BD96
        for <linux-raid@vger.kernel.org>; Wed,  1 Mar 2023 04:36:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1677674201;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cG2pa4UrXoO5ALV8j3GLD61cOT9QBopnZ8l+TAWLZTE=;
        b=RtBZjGta2JeFr8dQ9WossBNG30pZg8+DHJB1ItvPfi/Ov9hPZF/IXQGEJx550tAAyqxmBj
        FrzJYZ4QP/bwFs8DAngLuQURKrzuTsSY51kNW1XDa5wI1149kdoV+hVJXxFPCFkvD1VDgH
        +GZUb2rwkKPIK5mZmQWC8XZcmdXBJ/M=
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com
 [209.85.214.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-358-Ab5aJ4e8OSKKVzz_Kq_KGA-1; Wed, 01 Mar 2023 07:36:40 -0500
X-MC-Unique: Ab5aJ4e8OSKKVzz_Kq_KGA-1
Received: by mail-pl1-f199.google.com with SMTP id x10-20020a170902ea8a00b0019cdb7d7f91so6883504plb.4
        for <linux-raid@vger.kernel.org>; Wed, 01 Mar 2023 04:36:39 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cG2pa4UrXoO5ALV8j3GLD61cOT9QBopnZ8l+TAWLZTE=;
        b=1JWvVa7UOSILB84304sj/lps0s5gFeAuOGi0OABdAmQGbV2jefDXDZlPpeaePNf+RK
         jtiPl5TzJ6adrD1kOnK1FeAREON8Hsjw0k36Ih5bU+5g8dbncPipZmFPTHmzYkr1ucON
         Xhs9lXl8ghT6Rtf4STRMw020bWe9CimeZ6FaMJNPpYMwUzcJTOxSspgCvfgSbeqN5O9c
         0hMB8RORg0D1pDZRacOcsE/aakZkieXhk8056duWHmpNjKJmNTRiIchh4P9/Ymr/wKIF
         M5H7H8BNUV/0CT9U62mjTn1E9F99W8Kv7xPwV2o6LraocUG7MbcCn/kW/JRvRBba/DnX
         0Zvg==
X-Gm-Message-State: AO0yUKUwAYNDaDDyW6Z5PcQmLiFPXIjacey5Hn32u0vMvrQZfZL10V3P
        CZla2oV6u4ujGO6xTaT5zTgAgCmwsMQxIzIsbpZBP4SGSZVMkqpTIUGq2jKGJ/Yfe8DCf1Txch9
        BzaEJuwmW9Ato3fXGc3glfgpUyJxY5Y8kyyrjTQ==
X-Received: by 2002:a62:824c:0:b0:606:a48f:c211 with SMTP id w73-20020a62824c000000b00606a48fc211mr1218434pfd.1.1677674199035;
        Wed, 01 Mar 2023 04:36:39 -0800 (PST)
X-Google-Smtp-Source: AK7set+tN3APfkTreuZkVbUdk0UMqmZk/KT2A6RxKjx0l0Vx3jhPHm7qRhxAsvLLNBmqYxGl4kh2QcqUvtuMGOm4P5c=
X-Received: by 2002:a62:824c:0:b0:606:a48f:c211 with SMTP id
 w73-20020a62824c000000b00606a48fc211mr1218429pfd.1.1677674198697; Wed, 01 Mar
 2023 04:36:38 -0800 (PST)
MIME-Version: 1.0
References: <20230224183323.638-1-jonathan.derrick@linux.dev>
 <20230224183323.638-4-jonathan.derrick@linux.dev> <CALTww2_P6TaV7C5i2k5sUeHOpnqTxjFB-ZA98Y2re+17J5d7Kw@mail.gmail.com>
 <2f2ba1cb-a053-7494-ce42-4670b66baacf@linux.dev>
In-Reply-To: <2f2ba1cb-a053-7494-ce42-4670b66baacf@linux.dev>
From:   Xiao Ni <xni@redhat.com>
Date:   Wed, 1 Mar 2023 20:36:27 +0800
Message-ID: <CALTww2-ie0Y+0JMQAASKwDhAwcmD-aOuf=_J_GD95ATUi7w-3Q@mail.gmail.com>
Subject: Re: [PATCH v5 3/3] md: Use optimal I/O size for last bitmap page
To:     Jonathan Derrick <jonathan.derrick@linux.dev>
Cc:     Song Liu <song@kernel.org>, linux-raid@vger.kernel.org,
        Reindl Harald <h.reindl@thelounge.net>,
        Christoph Hellwig <hch@lst.de>,
        Christoph Hellwig <hch@infradead.org>,
        Paul Menzel <pmenzel@molgen.mpg.de>,
        Sushma Kalakota <sushma.kalakota@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Wed, Mar 1, 2023 at 7:10=E2=80=AFAM Jonathan Derrick
<jonathan.derrick@linux.dev> wrote:
>
> Hi Xiao
>
> On 2/26/2023 6:56 PM, Xiao Ni wrote:
> > Hi Jonathan
> >
> > I did a test in my environment, but I didn't see such a big
> > performance difference.
> >
> > The first environment:
> > All nvme devices have 512 logical size, 512 phy size, and 0 optimal siz=
e. Then
> > I used your way to rebuild the kernel
> > /sys/block/nvme0n1/queue/physical_block_size 512
> > /sys/block/nvme0n1/queue/optimal_io_size 4096
> > cat /sys/block/nvme0n1/queue/logical_block_size 512
> >
> > without the patch set
> > write: IOPS=3D68.0k, BW=3D266MiB/s (279MB/s)(15.6GiB/60001msec); 0 zone=
 resets
> > with the patch set
> > write: IOPS=3D69.1k, BW=3D270MiB/s (283MB/s)(15.8GiB/60001msec); 0 zone=
 resets
> >
> > The second environment:
> > The nvme devices' opt size are 4096. So I don't need to rebuild the ker=
nel.
> > /sys/block/nvme0n1/queue/logical_block_size
> > /sys/block/nvme0n1/queue/physical_block_size
> > /sys/block/nvme0n1/queue/optimal_io_size
> >
> > without the patch set
> > write: IOPS=3D51.6k, BW=3D202MiB/s (212MB/s)(11.8GiB/60001msec); 0 zone=
 resets
> > with the patch set
> > write: IOPS=3D53.5k, BW=3D209MiB/s (219MB/s)(12.2GiB/60001msec); 0 zone=
 resets
> >
> Sounds like your devices may not have latency issues at sub-optimal sizes=
.
> Can you provide biosnoop traces with and without patches?
>
> Still, 'works fine for me' is generally not a reason to reject the patche=
s.

Yes, I can. I tried to install the biosnoop in fedora38 but it failed.
These are the rpm packages I've installed:
bcc-tools-0.25.0-1.fc38.x86_64
bcc-0.25.0-1.fc38.x86_64
python3-bcc-0.25.0-1.fc38.noarch

Are there other packages that I need to install?

Regards
Xiao

