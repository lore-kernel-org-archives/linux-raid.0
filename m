Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B179BC61DA4
	for <linux-raid@archiver.kernel.org>; Thu,  2 Feb 2023 13:53:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229710AbjBBNxs (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 2 Feb 2023 08:53:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229441AbjBBNxr (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 2 Feb 2023 08:53:47 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 247A8E388
        for <linux-raid@vger.kernel.org>; Thu,  2 Feb 2023 05:53:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675345979;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=xutJJ6WtJCm4xrafrnDe3sQ1Bs2kpGdOmKl8Y0jJjxA=;
        b=ImWA1ka04Tun5J+TrgZpJwiDyGw+VoV5C5rrUpzPsg47uMUlMo7sfmz9LQEs0lo5fXrD55
        PdFsr6JAyRmLeeF1mYqsLLljAlgoIktZiCfrQrEmJUstgHduIc0CTtAI0BPTiYEGfI/bWF
        o/0np1HwFusYGUDu4ffYJWEkJq1CmtM=
Received: from mail-pf1-f197.google.com (mail-pf1-f197.google.com
 [209.85.210.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-437-N9fcDqoEP1mfB2QeDApM1w-1; Thu, 02 Feb 2023 08:52:57 -0500
X-MC-Unique: N9fcDqoEP1mfB2QeDApM1w-1
Received: by mail-pf1-f197.google.com with SMTP id i15-20020aa787cf000000b00593addd14a5so1013759pfo.15
        for <linux-raid@vger.kernel.org>; Thu, 02 Feb 2023 05:52:57 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=xutJJ6WtJCm4xrafrnDe3sQ1Bs2kpGdOmKl8Y0jJjxA=;
        b=CIcOR5EDPFtUc+U0RbIXyPTcBP6/CnRgUriN7EkIylhgCfKmdS8QaNUuTZbYcySf1c
         CFgX1oyswThOrGtETM9cZ4TQUx4+YZlMCl4EdD+ARYepiksK8UCGfYL821xctFRQt2+F
         S9pdAb2v/DqcK1+Yhl0tZijQWPz9sVj0ocHTGtPRjgaTU4IkATPIWAolbVaT1BBOQZC2
         x85IBxoDmzZ2Gmb/2Ysr32fal1b81+fV0vYQrPQqpMvE1qVJt1XINiIdnHZUxlOiuwXf
         YbkvT2CGqoD9tm6G9dyfHiKBx9U1A2Wni7CVOI90HzuU5MjYuN92ay91hXVolbpZWQFi
         UzWQ==
X-Gm-Message-State: AO0yUKX5x5ae83s2idPkPunU788o11DrYuVnCV+g5kyjWRbAePxVmjxm
        OYo4NUYuTTzXIiK9G2tdIQ4Z65w6pb4FWuNlaq8N50BH0Con+gBEpog0ZQiG/14cCbkW+a3rdnk
        K1bLZTym/1Uz1Q5JyRzTdf/QWTKNab8z1S7hBtA==
X-Received: by 2002:a17:902:ea03:b0:196:6b0d:752b with SMTP id s3-20020a170902ea0300b001966b0d752bmr1510022plg.19.1675345976648;
        Thu, 02 Feb 2023 05:52:56 -0800 (PST)
X-Google-Smtp-Source: AK7set/EoSNk4hBdp41MHLD3YgFJjY4XzC07NXwJ3Xk3tM6A0ZA9PV1rh4JLHH35hgaWq2lULNS2xtGkNy43hE5HvGQ=
X-Received: by 2002:a17:902:ea03:b0:196:6b0d:752b with SMTP id
 s3-20020a170902ea0300b001966b0d752bmr1510016plg.19.1675345976332; Thu, 02 Feb
 2023 05:52:56 -0800 (PST)
MIME-Version: 1.0
References: <20230201124640.3749-1-xni@redhat.com> <CAPhsuW7MCSVREMp48CoO-qE-HfMonxhJn-+HfRUxvHfBXL0Nug@mail.gmail.com>
 <CALTww2_cLaULw4+QwwkjhhmBwjcP9GBTxNOR=WsZXAnPJaUakg@mail.gmail.com>
 <CALTww2-Df5LZODnur7Mq9e+Q1bv_aDr_P+q3Y4Ded2tUnsNFTQ@mail.gmail.com> <CAPhsuW59msX0RaLKnkVT03epWhpUN2Z_8U_zx9cpRAK+Qfn0wA@mail.gmail.com>
In-Reply-To: <CAPhsuW59msX0RaLKnkVT03epWhpUN2Z_8U_zx9cpRAK+Qfn0wA@mail.gmail.com>
From:   Xiao Ni <xni@redhat.com>
Date:   Thu, 2 Feb 2023 21:52:45 +0800
Message-ID: <CALTww2-t6XKcTSndHfQ=SPQQEKMQQOdhDX-97ezU-t3KvmE0qA@mail.gmail.com>
Subject: Re: [PATCH V3 1/1] md/raid0: Add mddev->io_acct_cnt for raid0_quiesce
To:     Song Liu <song@kernel.org>
Cc:     linux-raid@vger.kernel.org, ming.lei@redhat.com,
        ncroxon@redhat.com, heinzm@redhat.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Thu, Feb 2, 2023 at 2:58 PM Song Liu <song@kernel.org> wrote:
>
> On Wed, Feb 1, 2023 at 4:41 PM Xiao Ni <xni@redhat.com> wrote:
> >
> > On Thu, Feb 2, 2023 at 8:23 AM Xiao Ni <xni@redhat.com> wrote:
> > >
> > > On Thu, Feb 2, 2023 at 2:00 AM Song Liu <song@kernel.org> wrote:
> > > >
> > > > On Wed, Feb 1, 2023 at 4:46 AM Xiao Ni <xni@redhat.com> wrote:
> > > > >
> > > > > It has added io_acct_set for raid0/raid5 io accounting and it needs to
> > > > > alloc md_io_acct in the i/o path. They are free when the bios come back
> > > > > from member disks. Now we don't have a method to monitor if those bios
> > > > > are all come back. In the takeover process, it needs to free the raid0
> > > > > memory resource including the memory pool for md_io_acct. But maybe some
> > > > > bios are still not returned. When those bios are returned, it can cause
> > > > > panic bcause of introducing NULL pointer or invalid address. Something
> > > > > like this:
> > > >
> > > > Can we use mddev->active_io for this? If not, please explain the reason
> > > > in the comments (in the code).
> > >
> > > Hi Song
> > >
> > > At first, we thought this way. Now ->acitve_io is used to wait all
> > > submit processes to exit.
> > > If we use ->active_io to count acct_bio, it means we change the usage
> > > of ->active_io.
> > > In mddev_suspend, first it waits for all submit processes to finish,
> > > then it calls ->quiesce
> > > to wait all inflight io to come back. For raid0, it's ok to use
> > > ->acitve_io to count acct_bio.
> > > But for raid5, not sure if it's ok. What's your opinion?
> >
> > Hi Song
> >
> > I've sent V4. If you think ->active_io is a better way to count acct_io,
> > I'll re-write the patch to use ->active_io
>
> I haven't thought about all the details. But we should try very hard to
> avoid adding another percpu_ref. So let's try to use active_io to count
> acct_io.
>
> Thanks,
> Song
>

Ok, I'll try to send a version using active_io.

Regards
Xiao

