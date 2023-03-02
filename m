Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E20F3C6FA8E
	for <linux-raid@archiver.kernel.org>; Thu,  2 Mar 2023 09:06:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229890AbjCBJGP (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 2 Mar 2023 04:06:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229831AbjCBJGN (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 2 Mar 2023 04:06:13 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AF303CE1A
        for <linux-raid@vger.kernel.org>; Thu,  2 Mar 2023 01:05:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1677747921;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Mw0pUZ9sDjEHQUmwnqIdXyuQtiMbJo9Clo2s3e0AQHc=;
        b=eFK3jJLFfkZ5KeOYm+cm5UHEU/4xtxCXRmZfWPSJUAq/QiTa7XwT04JRH6vJqT5zVbKb1t
        M1Umx/5MZOQ6I4KYnekzS2mtHDI0sv+7XFMcQdWXMHN2lwGy0vnE9rcTObEc3zDBu+YyU3
        FXbT1JJn8l/r76mMU+ATKFPabb/4cC0=
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com
 [209.85.216.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-453-KhVefKVENa6FOYYKtkOKhw-1; Thu, 02 Mar 2023 04:05:17 -0500
X-MC-Unique: KhVefKVENa6FOYYKtkOKhw-1
Received: by mail-pj1-f72.google.com with SMTP id i6-20020a17090a650600b002372da4819eso5830424pjj.0
        for <linux-raid@vger.kernel.org>; Thu, 02 Mar 2023 01:05:17 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Mw0pUZ9sDjEHQUmwnqIdXyuQtiMbJo9Clo2s3e0AQHc=;
        b=P4JekGpXN8fPFYC8r0s1Lpu5wIRs8yyjfT35kkWyXPniKgSGOgpV5R3RPTkSEHPatg
         c0t2Xb9t/7/Fqhw9dvGoV33qgS5yy0lIB8TNVYWYRJtSYmlY4Re9oWN8d631Zo6k7J8B
         ffhnkRluOFDxZKa9P2aynDrfiqE95XOpb7ayEqMRVg4rxbzj99533Cgo+RWo0u76Uurq
         qWZ+f+4kI7ua+tkmgCi1RheENa157xoJXdFsLNQnZmH6k+ZUyfzKvAVDG5mqFfKONCVj
         n+5x++cBm4p/8e7GHcmhvXqQGchkR6THi2+IrLoCAp7DzL1ipsZyMAs/C2G2H0KyBuau
         y+Kg==
X-Gm-Message-State: AO0yUKWl9Y+BnbgRFUvwXS8+oLMVEGh+zCzuW/7OUS4PlJuEM602hcrB
        4q4ntfAvLytdbBDhr5NCELYgC/+xeN+rhlssCwMj7kvXULE14vn7YQHNuKMNypEnSbYD8flHHon
        gjVhmrIliKy2fQihu+edHsktXt+qvOBoyLMLljkUzQvtwCPx/
X-Received: by 2002:a17:90a:748b:b0:231:1dab:f8e with SMTP id p11-20020a17090a748b00b002311dab0f8emr3652666pjk.9.1677747916675;
        Thu, 02 Mar 2023 01:05:16 -0800 (PST)
X-Google-Smtp-Source: AK7set/a98r6yL1St5v0m74Iu3Pqvm7UKe8u/gYtRfAtIMZ5+XXRwwBSMcJjdhsIOq+m3QDJJwIs6t0OPRhBFQMyJa0=
X-Received: by 2002:a17:90a:748b:b0:231:1dab:f8e with SMTP id
 p11-20020a17090a748b00b002311dab0f8emr3652654pjk.9.1677747916364; Thu, 02 Mar
 2023 01:05:16 -0800 (PST)
MIME-Version: 1.0
References: <20230224183323.638-1-jonathan.derrick@linux.dev>
 <20230224183323.638-4-jonathan.derrick@linux.dev> <CALTww2_P6TaV7C5i2k5sUeHOpnqTxjFB-ZA98Y2re+17J5d7Kw@mail.gmail.com>
 <2f2ba1cb-a053-7494-ce42-4670b66baacf@linux.dev> <CALTww2-ie0Y+0JMQAASKwDhAwcmD-aOuf=_J_GD95ATUi7w-3Q@mail.gmail.com>
 <b109f953-fd46-6037-c976-f1690cb4ff8b@linux.dev>
In-Reply-To: <b109f953-fd46-6037-c976-f1690cb4ff8b@linux.dev>
From:   Xiao Ni <xni@redhat.com>
Date:   Thu, 2 Mar 2023 17:05:05 +0800
Message-ID: <CALTww2_dN+B74qPc3X=JofOmAd78rVv6wRWiifSUdU97_Ghqqg@mail.gmail.com>
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

On Thu, Mar 2, 2023 at 1:57=E2=80=AFAM Jonathan Derrick
<jonathan.derrick@linux.dev> wrote:
>
>
>
> On 3/1/2023 5:36 AM, Xiao Ni wrote:
> > On Wed, Mar 1, 2023 at 7:10=E2=80=AFAM Jonathan Derrick
> > <jonathan.derrick@linux.dev> wrote:
> >>
> >> Hi Xiao
> >>
> >> On 2/26/2023 6:56 PM, Xiao Ni wrote:
> >>> Hi Jonathan
> >>>
> >>> I did a test in my environment, but I didn't see such a big
> >>> performance difference.
> >>>
> >>> The first environment:
> >>> All nvme devices have 512 logical size, 512 phy size, and 0 optimal s=
ize. Then
> >>> I used your way to rebuild the kernel
> >>> /sys/block/nvme0n1/queue/physical_block_size 512
> >>> /sys/block/nvme0n1/queue/optimal_io_size 4096
> >>> cat /sys/block/nvme0n1/queue/logical_block_size 512
> >>>
> >>> without the patch set
> >>> write: IOPS=3D68.0k, BW=3D266MiB/s (279MB/s)(15.6GiB/60001msec); 0 zo=
ne resets
> >>> with the patch set
> >>> write: IOPS=3D69.1k, BW=3D270MiB/s (283MB/s)(15.8GiB/60001msec); 0 zo=
ne resets
> >>>
> >>> The second environment:
> >>> The nvme devices' opt size are 4096. So I don't need to rebuild the k=
ernel.
> >>> /sys/block/nvme0n1/queue/logical_block_size
> >>> /sys/block/nvme0n1/queue/physical_block_size
> >>> /sys/block/nvme0n1/queue/optimal_io_size
> >>>
> >>> without the patch set
> >>> write: IOPS=3D51.6k, BW=3D202MiB/s (212MB/s)(11.8GiB/60001msec); 0 zo=
ne resets
> >>> with the patch set
> >>> write: IOPS=3D53.5k, BW=3D209MiB/s (219MB/s)(12.2GiB/60001msec); 0 zo=
ne resets
> >>>
> >> Sounds like your devices may not have latency issues at sub-optimal si=
zes.
> >> Can you provide biosnoop traces with and without patches?
> >>
> >> Still, 'works fine for me' is generally not a reason to reject the pat=
ches.
> >
> > Yes, I can. I tried to install the biosnoop in fedora38 but it failed.
> > These are the rpm packages I've installed:
> > bcc-tools-0.25.0-1.fc38.x86_64
> > bcc-0.25.0-1.fc38.x86_64
> > python3-bcc-0.25.0-1.fc38.noarch
> >
> > Are there other packages that I need to install?
> >
> I've had issues with the packaged versions as well
>
> Best to install from source:
> https://github.com/iovisor/bcc/
> https://github.com/iovisor/bcc/blob/master/INSTALL.md#fedora---source
>
Hi Jonathan

I did a test without modifying phys_size and opt_size. And I picked up a pa=
rt
of the result:

0.172142    md0_raid10     2094    nvme1n1   W 1225496264 4096      0.01
0.172145    md0_raid10     2094    nvme0n1   W 1225496264 4096      0.01
0.172161    md0_raid10     2094    nvme3n1   W 16         4096      0.01
0.172164    md0_raid10     2094    nvme2n1   W 16         4096      0.01
0.172166    md0_raid10     2094    nvme1n1   W 16         4096      0.01
0.172168    md0_raid10     2094    nvme0n1   W 16         4096      0.01
0.172178    md0_raid10     2094    nvme3n1   W 633254624  4096      0.01
0.172180    md0_raid10     2094    nvme2n1   W 633254624  4096      0.01
0.172196    md0_raid10     2094    nvme3n1   W 16         4096      0.01
0.172199    md0_raid10     2094    nvme2n1   W 16         4096      0.01
0.172201    md0_raid10     2094    nvme1n1   W 16         4096      0.01
0.172203    md0_raid10     2094    nvme0n1   W 16         4096      0.01
0.172213    md0_raid10     2094    nvme3n1   W 1060251672 4096      0.01
0.172215    md0_raid10     2094    nvme2n1   W 1060251672 4096      0.01

The last column always shows 0.01. Is that the reason I can't see the
performance
improvement? What do you think if I use ssd or hdds?

Best Regards
Xiao

