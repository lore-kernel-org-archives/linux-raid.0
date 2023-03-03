Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1BDBBC6FA8E
	for <linux-raid@archiver.kernel.org>; Fri,  3 Mar 2023 01:56:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229538AbjCCB4l (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 2 Mar 2023 20:56:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229453AbjCCB4k (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 2 Mar 2023 20:56:40 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A3DEC64C
        for <linux-raid@vger.kernel.org>; Thu,  2 Mar 2023 17:55:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1677808544;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=feXk126w3cOzJ3erpwPyZouPQvPN1ll4MKvmydA5vo0=;
        b=EC8m+cfv5NjbgTDbd1wm0kJB1fl/ArkBNWXcFEYQzi+RQwU82i3jNzTtVFylH4seywkJc+
        hVxCIXRffjgML7/zw5UgbC8wbIY/b4lrdu3hPaPC1mGjjq/FvDYUpIboJaR6OiwQdx+lhN
        PHn2Nm1Yok0LhnG0SkbcuTtc70a+XY8=
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com
 [209.85.214.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-28-w_hr99oDNrWmAIQWrhqFAg-1; Thu, 02 Mar 2023 20:55:43 -0500
X-MC-Unique: w_hr99oDNrWmAIQWrhqFAg-1
Received: by mail-pl1-f198.google.com with SMTP id l10-20020a17090270ca00b0019caa6e6bd1so600267plt.2
        for <linux-raid@vger.kernel.org>; Thu, 02 Mar 2023 17:55:43 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677808542;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=feXk126w3cOzJ3erpwPyZouPQvPN1ll4MKvmydA5vo0=;
        b=af3jHB3KNv3RKoF/bJmMKRM66/N44YEw5NMrhQamKsL9dL4Xn5GgmdQj3uhu+wAxMn
         1Srz/kifurQXtg9N44Q9IkpdLpluBENYSMY0iBBWudqEKTzlTxeU1UGUm+gV0XSOyc7T
         GiN3mdGEykQw2j4jqZ3wogv9uPK8KbxQ7JlCCxx6Uhogyds24OeAWZZpFC8ytgTyaY6s
         o+kA1LN4F/gElxfrKfzMsARMlzS7amep44GD8yZeqrayjeJntmvcRgzyf5wS1byLGZdp
         CITN3uImZgJrD4VKRGL4bxFYLbswr25ReS0y2wahkF7lHjhrb67c7daXR4y/tZQ4x4pU
         D4mg==
X-Gm-Message-State: AO0yUKX6xaadyJ09INlKfeCvOjPYP0s7D1g30PP0aZuCdJqZv1njENQE
        +DhfD2sJ8Jjwjlie6AHa1b0fMKI8iizIjUwtCSJ4Vzu33rl9KDqQlvfOSvuZCA78HV6sTlqOOgV
        bVE5bIT/udUi3xJIWJV7CwBSvGHRT/N2J2TLNyg==
X-Received: by 2002:a17:903:428b:b0:19a:8751:4dfc with SMTP id ju11-20020a170903428b00b0019a87514dfcmr127121plb.1.1677808542035;
        Thu, 02 Mar 2023 17:55:42 -0800 (PST)
X-Google-Smtp-Source: AK7set9cypB5SyYDXK7XOxiuv19kTWSxg1q0sjKu7oH4vGVwqahn2arkmI2uHzf22KO/5hLGwtcT4UDNxVBXeCsoJUI=
X-Received: by 2002:a17:903:428b:b0:19a:8751:4dfc with SMTP id
 ju11-20020a170903428b00b0019a87514dfcmr127113plb.1.1677808541761; Thu, 02 Mar
 2023 17:55:41 -0800 (PST)
MIME-Version: 1.0
References: <20230224183323.638-1-jonathan.derrick@linux.dev>
 <20230224183323.638-4-jonathan.derrick@linux.dev> <CALTww2_P6TaV7C5i2k5sUeHOpnqTxjFB-ZA98Y2re+17J5d7Kw@mail.gmail.com>
 <2f2ba1cb-a053-7494-ce42-4670b66baacf@linux.dev> <CALTww2-ie0Y+0JMQAASKwDhAwcmD-aOuf=_J_GD95ATUi7w-3Q@mail.gmail.com>
 <b109f953-fd46-6037-c976-f1690cb4ff8b@linux.dev> <CALTww2_dN+B74qPc3X=JofOmAd78rVv6wRWiifSUdU97_Ghqqg@mail.gmail.com>
 <1a010a9c-cbe6-0756-647f-3a9affde2f17@linux.dev>
In-Reply-To: <1a010a9c-cbe6-0756-647f-3a9affde2f17@linux.dev>
From:   Xiao Ni <xni@redhat.com>
Date:   Fri, 3 Mar 2023 09:55:30 +0800
Message-ID: <CALTww29Y=FWe2C4-+1WhQF2uKr1MCjhviBs1m4X2Z-gw4WUo=g@mail.gmail.com>
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

On Fri, Mar 3, 2023 at 1:18=E2=80=AFAM Jonathan Derrick
<jonathan.derrick@linux.dev> wrote:
>
>
>
> On 3/2/2023 2:05 AM, Xiao Ni wrote:
> > On Thu, Mar 2, 2023 at 1:57=E2=80=AFAM Jonathan Derrick
> > <jonathan.derrick@linux.dev> wrote:
> >>
> >>
> >>
> >> On 3/1/2023 5:36 AM, Xiao Ni wrote:
> >>> On Wed, Mar 1, 2023 at 7:10=E2=80=AFAM Jonathan Derrick
> >>> <jonathan.derrick@linux.dev> wrote:
> >>>>
> >>>> Hi Xiao
> >>>>
> >>>> On 2/26/2023 6:56 PM, Xiao Ni wrote:
> >>>>> Hi Jonathan
> >>>>>
> >>>>> I did a test in my environment, but I didn't see such a big
> >>>>> performance difference.
> >>>>>
> >>>>> The first environment:
> >>>>> All nvme devices have 512 logical size, 512 phy size, and 0 optimal=
 size. Then
> >>>>> I used your way to rebuild the kernel
> >>>>> /sys/block/nvme0n1/queue/physical_block_size 512
> >>>>> /sys/block/nvme0n1/queue/optimal_io_size 4096
> >>>>> cat /sys/block/nvme0n1/queue/logical_block_size 512
> >>>>>
> >>>>> without the patch set
> >>>>> write: IOPS=3D68.0k, BW=3D266MiB/s (279MB/s)(15.6GiB/60001msec); 0 =
zone resets
> >>>>> with the patch set
> >>>>> write: IOPS=3D69.1k, BW=3D270MiB/s (283MB/s)(15.8GiB/60001msec); 0 =
zone resets
> >>>>>
> >>>>> The second environment:
> >>>>> The nvme devices' opt size are 4096. So I don't need to rebuild the=
 kernel.
> >>>>> /sys/block/nvme0n1/queue/logical_block_size
> >>>>> /sys/block/nvme0n1/queue/physical_block_size
> >>>>> /sys/block/nvme0n1/queue/optimal_io_size
> >>>>>
> >>>>> without the patch set
> >>>>> write: IOPS=3D51.6k, BW=3D202MiB/s (212MB/s)(11.8GiB/60001msec); 0 =
zone resets
> >>>>> with the patch set
> >>>>> write: IOPS=3D53.5k, BW=3D209MiB/s (219MB/s)(12.2GiB/60001msec); 0 =
zone resets
> >>>>>
> >>>> Sounds like your devices may not have latency issues at sub-optimal =
sizes.
> >>>> Can you provide biosnoop traces with and without patches?
> >>>>
> >>>> Still, 'works fine for me' is generally not a reason to reject the p=
atches.
> >>>
> >>> Yes, I can. I tried to install the biosnoop in fedora38 but it failed=
.
> >>> These are the rpm packages I've installed:
> >>> bcc-tools-0.25.0-1.fc38.x86_64
> >>> bcc-0.25.0-1.fc38.x86_64
> >>> python3-bcc-0.25.0-1.fc38.noarch
> >>>
> >>> Are there other packages that I need to install?
> >>>
> >> I've had issues with the packaged versions as well
> >>
> >> Best to install from source:
> >> https://github.com/iovisor/bcc/
> >> https://github.com/iovisor/bcc/blob/master/INSTALL.md#fedora---source
> >>
> > Hi Jonathan
> >
> > I did a test without modifying phys_size and opt_size. And I picked up =
a part
> > of the result:
> >
> > 0.172142    md0_raid10     2094    nvme1n1   W 1225496264 4096      0.0=
1
> > 0.172145    md0_raid10     2094    nvme0n1   W 1225496264 4096      0.0=
1
> > 0.172161    md0_raid10     2094    nvme3n1   W 16         4096      0.0=
1
> > 0.172164    md0_raid10     2094    nvme2n1   W 16         4096      0.0=
1
> > 0.172166    md0_raid10     2094    nvme1n1   W 16         4096      0.0=
1
> > 0.172168    md0_raid10     2094    nvme0n1   W 16         4096      0.0=
1
> > 0.172178    md0_raid10     2094    nvme3n1   W 633254624  4096      0.0=
1
> > 0.172180    md0_raid10     2094    nvme2n1   W 633254624  4096      0.0=
1
> > 0.172196    md0_raid10     2094    nvme3n1   W 16         4096      0.0=
1
> > 0.172199    md0_raid10     2094    nvme2n1   W 16         4096      0.0=
1
> > 0.172201    md0_raid10     2094    nvme1n1   W 16         4096      0.0=
1
> > 0.172203    md0_raid10     2094    nvme0n1   W 16         4096      0.0=
1
> > 0.172213    md0_raid10     2094    nvme3n1   W 1060251672 4096      0.0=
1
> > 0.172215    md0_raid10     2094    nvme2n1   W 1060251672 4096      0.0=
1
> >
> > The last column always shows 0.01. Is that the reason I can't see the
> > performance
> > improvement? What do you think if I use ssd or hdds?
> Try reducing your mdadm's --bitmap-chunk first. In above logs, only LBA 1=
6 is
> being used, and that's the first bitmap page (and seemingly also the last=
). You
> want to configure it such that you have more bitmap pages. Reducing the
> --bitmap-chunk parameter should create more bitmap pages, and you may run=
 into
> the scenario predicted by the patch.
>

Finally, I can see the performance improvement. It's cool. Thanks for this.

The raid with 64MB bitmap size
write: IOPS=3D58.4k, BW=3D228MiB/s (239MB/s)(13.4GiB/60001msec); 0 zone
resets (without patch)
write: IOPS=3D69.3k, BW=3D271MiB/s (284MB/s)(252MiB/931msec); 0 zone
resets (with patch)

The raid with 8MB bitmap size
write: IOPS=3D11.6k, BW=3D45.4MiB/s (47.6MB/s)(2724MiB/60002msec); 0 zone
resets (without patch)
write: IOPS=3D43.7k, BW=3D171MiB/s (179MB/s)(10.0GiB/60001msec); 0 zone
resets (with patch)

Best Regards
Xiao

