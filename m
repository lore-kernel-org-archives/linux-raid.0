Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E4BBC433F5
	for <linux-raid@archiver.kernel.org>; Mon, 25 Apr 2022 16:12:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243251AbiDYQPa (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 25 Apr 2022 12:15:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242499AbiDYQP3 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 25 Apr 2022 12:15:29 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 8E13E119ECB
        for <linux-raid@vger.kernel.org>; Mon, 25 Apr 2022 09:12:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1650903144;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=OsPBef0jj6VUn+wTV1avT2qCvK+uErk9g3dM4Rxp5gI=;
        b=g4vEflGtXkMNpuASGB1m9ak/loLhz0jycvvCjUunIm/fH8Kqk3+ihoCDikYHMZ58/hEx92
        wc+upJ/p05Zyvnix/n6r5sfc9rlphWJoDUt6CBGEjWLIimPjeWssT5nmlW2cWTQPVICalN
        +PBEUiP2Yxcp+UScxDdbNhQvEmq4wlE=
Received: from mail-ot1-f72.google.com (mail-ot1-f72.google.com
 [209.85.210.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-237-u_37gboLOKGcXyBmHu_9UA-1; Mon, 25 Apr 2022 12:12:23 -0400
X-MC-Unique: u_37gboLOKGcXyBmHu_9UA-1
Received: by mail-ot1-f72.google.com with SMTP id l20-20020a056830269400b00605523dff90so6407628otu.22
        for <linux-raid@vger.kernel.org>; Mon, 25 Apr 2022 09:12:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=OsPBef0jj6VUn+wTV1avT2qCvK+uErk9g3dM4Rxp5gI=;
        b=lJe+3Lz9ZONvwLpJRVwFaeMJSMI05Ughk2QThSUyAjf+wxcsCd/+Nl4JgLqjJgsH/2
         G/tGMXNC2oB+uR8ZVuLy3J0dq968qlR66XdpNk7axy2VasfvkLHpuBk4plRI3qkasgrz
         3PbZNQLR5fCz/qAWwCo8l622VTX6vBeAG1EQCL9TcEnv9C6OXMscpWFIcGNFaQ5yhoak
         9p0ziVFpRYm8zpkPvTarRP9P5uzPy4Ltv/VUc4BnwHq3UeqvhCV8VwEzU98Lu1PTKo0Z
         5w6dSHvajHKWQIBMGD83wo3IafWTRWGpr2dI5YVMH/R5xijJ+yh3IbaZWxWuX+ejtUC+
         Z5XQ==
X-Gm-Message-State: AOAM531j2pDqS4vtVWLli9lYsBRphzLuC+5e9EFeDrnIbhCzRkEn5N2n
        N9dRAlRogtgzh7a7wunxylGAbeBNGGftPlhLHjz2tZrw+mqlg49DjPYeK2TuPXdL7A5y3gQzieY
        FzQOszJWZ06FbAFLnanuUiYvWkv7FfNf2t4+YXA==
X-Received: by 2002:a05:6870:a2d0:b0:d9:ae66:b8e2 with SMTP id w16-20020a056870a2d000b000d9ae66b8e2mr11329631oak.7.1650903140887;
        Mon, 25 Apr 2022 09:12:20 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwQwHS4bz708d6FJC+VSTjdUk3UvGFB8BVNrRh7nHOEPPA1NpxgPFiCtZuZzxOLPjazb4naNn5qPP7kZcH5Wr4=
X-Received: by 2002:a05:6870:a2d0:b0:d9:ae66:b8e2 with SMTP id
 w16-20020a056870a2d000b000d9ae66b8e2mr11329602oak.7.1650903140350; Mon, 25
 Apr 2022 09:12:20 -0700 (PDT)
MIME-Version: 1.0
References: <20220420195425.34911-1-logang@deltatee.com> <CALTww28fwNpm0O_jc7-2Xr0JSX9i6F1kgoUQ8m_k6ZgPa1XxXw@mail.gmail.com>
 <c14c0103-9cbd-7d0f-486b-344dd33725ab@deltatee.com> <4094aed9-d22d-d14f-07a7-5abe599beeab@linux.dev>
 <8d8fbf24-51b5-a076-b7ad-fcbb7d5c275e@deltatee.com>
In-Reply-To: <8d8fbf24-51b5-a076-b7ad-fcbb7d5c275e@deltatee.com>
From:   Xiao Ni <xni@redhat.com>
Date:   Tue, 26 Apr 2022 00:12:09 +0800
Message-ID: <CALTww28SuvhzCL6p4L9y9ZH5Mmgss-tTm_QzbEo60hZOXAUS0A@mail.gmail.com>
Subject: Re: [PATCH v2 00/12] Improve Raid5 Lock Contention
To:     Logan Gunthorpe <logang@deltatee.com>
Cc:     Guoqing Jiang <guoqing.jiang@linux.dev>,
        open list <linux-kernel@vger.kernel.org>,
        linux-raid <linux-raid@vger.kernel.org>,
        Song Liu <song@kernel.org>,
        Christoph Hellwig <hch@infradead.org>,
        Stephen Bates <sbates@raithlin.com>,
        Martin Oliveira <Martin.Oliveira@eideticom.com>,
        David Sloan <David.Sloan@eideticom.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Mon, Apr 25, 2022 at 11:39 PM Logan Gunthorpe <logang@deltatee.com> wrot=
e:
>
>
>
> On 2022-04-24 02:00, Guoqing Jiang wrote:
> >
> >
> > On 4/22/22 12:02 AM, Logan Gunthorpe wrote:
> >>
> >> On 2022-04-21 02:45, Xiao Ni wrote:
> >>> Could you share the commands to get the test result (lock contention
> >>> and performance)?
> >> Sure. The performance we were focused on was large block writes. So we
> >> setup raid5 instances with varying number of disks and ran the followi=
ng
> >> fio script directly on the drive.
> >>
> >> [simple]
> >> filename=3D/dev/md0
> >> ioengine=3Dlibaio
> >> rw=3Dwrite
> >> direct=3D1
> >> size=3D8G
> >> blocksize=3D2m
> >> iodepth=3D16
> >> runtime=3D30s
> >> time_based=3D1
> >> offset_increment=3D8G
> >> numjobs=3D12
> >> =EF=BF=BC
> >> (We also played around with tuning this but didn't find substantial
> >> changes once the bottleneck was hit)
> >
> > Nice, I suppose other IO patterns keep the same performance as before.
> >
> >> We tuned md with parameters like:
> >>
> >> echo 4 > /sys/block/md0/md/group_thread_cnt
> >> echo 8192 > /sys/block/md0/md/stripe_cache_size
> >>
> >> For lock contention stats, we just used lockstat[1]; roughly like:
> >>
> >> echo 1 > /proc/sys/kernel/lock_stat
> >> fio test.fio
> >> echo 0 > /proc/sys/kernel/lock_stat
> >> cat /proc/lock_stat
> >>
> >> And compared the before and after.
> >
> > Thanks for your effort, besides the performance test, please try to run
> > mdadm test suites to avoid regression.
>
> Yeah, is there any documentation for that? I tried to look into it but
> couldn't figure out how it's run.
>
> I do know that lkp-tests has run it on this series as I did get an error
> from it. But while I'm pretty sure that error has been resolved, I was
> never able to figure out how to run them locally.
>

Hi Logan

You can clone the mdadm repo at
git://git.kernel.org/pub/scm/utils/mdadm/mdadm.git
Then you can find there is a script test under the directory. It's not
under the tests directory.
The test cases are under tests directory.

Regards
Xiao

