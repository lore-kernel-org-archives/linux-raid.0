Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98E61C433EF
	for <linux-raid@archiver.kernel.org>; Tue,  8 Mar 2022 10:32:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244338AbiCHKdI (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 8 Mar 2022 05:33:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345917AbiCHKdD (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 8 Mar 2022 05:33:03 -0500
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4843A42ED1
        for <linux-raid@vger.kernel.org>; Tue,  8 Mar 2022 02:32:07 -0800 (PST)
Received: by mail-wr1-x435.google.com with SMTP id u1so27694557wrg.11
        for <linux-raid@vger.kernel.org>; Tue, 08 Mar 2022 02:32:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:subject:from:to:date:in-reply-to:references
         :content-transfer-encoding:user-agent:mime-version;
        bh=zh6Pe7yldPTJvhdEIOSaod9RJQ07MzdfDiCyvh+c7Qo=;
        b=lPmt2C5f4emvoOZ2q1W5D9vMZvdQB0QsdO0Y1yCMo+0DUPmOyiV1BmvtJ9m0gElsZ2
         iuEFeHazNOhQnvz65b4q66MJgtAp9UGFpsmXLfugS28VdIthMRiaKJNkaRKeU20Yn9yU
         VCeBIRphabViaP6LDjrfdG7LOOH3RoKXLRtIvVrtPgyqoDXFG83urGtxDLSL9qlo9dCm
         upFyIPSFXQKCeg2i/XGGhD4GhvlpK7enci1SOVRjG0AGFzknTbMpsCiYPkAyrj2139qP
         i9sceE2O3FjoAV1fFpxrcgikKFx/H/awqAtOVJ6DKCH+YE2ByEjwkdkwdLTAEUTx2G5M
         CVhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:date:in-reply-to
         :references:content-transfer-encoding:user-agent:mime-version;
        bh=zh6Pe7yldPTJvhdEIOSaod9RJQ07MzdfDiCyvh+c7Qo=;
        b=PMtjmBrof08emD/gS41Gw+OSqQGRhTZtr78XnCA3eeep5DhZuqz3HGFq1jn8zqoNcT
         NVSG4ZZrg8GB3tPKKv+Ydoix8lXIBlVeXSFCTGB9fkOk6x/rGyJEv64KTh8Al5wMBQld
         BWj7clVLcggYO8cse50Z/ZnMCbNhzfBN0Fg/EfL9fDFErpzi2ps+gzsqZSH0x1hmo5dJ
         MC1TKSB7kiwJHwMhuUmTK4HD20Niadg/FPKaysDi3mIkT+pU4vYFfwmGC5EdFeRLNnt7
         bb1fa/mSr/5LZjrBI+IZPPGOlcWyYgV5PhIXDftl2NZOzf2pu3XO3Y9Rp1Qc1Jl3OWZN
         3p0Q==
X-Gm-Message-State: AOAM532SvrRH8XHIghSjhLGlunXgzZLyL+YywUiIzD1/izET7UqC+kVI
        kPBXGlKbIrYY6Vww4MV511q7/1CNx6Q=
X-Google-Smtp-Source: ABdhPJwcoAzGT1VATSLcXixsrD9BS5/hqq/s7aqvxAn2dHDtA6HZZHu8x2h5w5rnmW4ao1Io5FQjdA==
X-Received: by 2002:adf:e751:0:b0:1f0:2139:2489 with SMTP id c17-20020adfe751000000b001f021392489mr11548860wrn.319.1646735525862;
        Tue, 08 Mar 2022 02:32:05 -0800 (PST)
Received: from www.Debian-Testing-WilsonJTR4 ([213.31.80.52])
        by smtp.gmail.com with ESMTPSA id e1-20020a05600c4e4100b00389cb5ab3bcsm359112wmq.32.2022.03.08.02.32.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Mar 2022 02:32:05 -0800 (PST)
Message-ID: <5e9a3d4df47bee95c705838222b4587a4090e450.camel@gmail.com>
Subject: Re: Raid6 check performance regression 5.15 -> 5.16
From:   Wilson Jonathan <i400sjon@gmail.com>
To:     Larkin Lowrey <llowrey@nuclearwinter.com>,
        linux-raid <linux-raid@vger.kernel.org>
Date:   Tue, 08 Mar 2022 10:32:04 +0000
In-Reply-To: <0eb91a43-a153-6e29-14b6-65f97b9f3d99@nuclearwinter.com>
References: <0eb91a43-a153-6e29-14b6-65f97b9f3d99@nuclearwinter.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.43.2-2 
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Mon, 2022-03-07 at 13:15 -0500, Larkin Lowrey wrote:
> I am seeing a 'check' speed regression between kernels 5.15 and 5.16.
> One host with a 20 drive array went from 170MB/s to 11MB/s. Another
> host=20
> with a 15 drive array went from 180MB/s to 43MB/s. In both cases the=20
> arrays are almost completely idle. I can flip between the two kernels
> with no other changes and observe the performance changes.
>=20
> Is this a known issue?
>=20
> --Larkin

I killed it in the end. The computer went from "slow" and "delayed"...
to taking an annoyingly long time to do anything.

It also gave me a chance to test using the other kernel. Booting to
5.15.0-3-amd64 and starting the "check" shows circa 400mins to complete
which is what it normally takes.

re-booting to 5.16.0-3-amd64 and starting the check shows circa
1000mins to complete.

I noticed on marc.info that Song had posted a request (hadn't filtered
to mail). This is the output of that for two of the arrays:

/dev/md8:
           Version : 1.2
     Creation Time : Fri Feb 14 08:38:30 2020
        Raid Level : raid6
        Array Size : 15073892352 (14.04 TiB 15.44 TB)
     Used Dev Size : 3768473088 (3.51 TiB 3.86 TB)
      Raid Devices : 6
     Total Devices : 6
       Persistence : Superblock is persistent

     Intent Bitmap : Internal

       Update Time : Tue Mar  8 10:28:00 2022
             State : clean=20
    Active Devices : 6
   Working Devices : 6
    Failed Devices : 0
     Spare Devices : 0

            Layout : left-symmetric
        Chunk Size : 512K

Consistency Policy : bitmap

              Name : debianz97:8
              UUID : 51cfc705:98c0ef75:d2b5c558:363f2fd0
            Events : 159898

    Number   Major   Minor   RaidDevice State
       0       8       88        0      active sync   /dev/sdf8
       1       8       40        1      active sync   /dev/sdc8
       2       8       72        2      active sync   /dev/sde8
       3       8       56        3      active sync   /dev/sdd8
       4       8       24        4      active sync   /dev/sdb8
       5       8        8        5      active sync   /dev/sda8


/dev/md4:
           Version : 1.2
     Creation Time : Wed Feb  5 11:11:16 2020
        Raid Level : raid10
        Array Size : 71236608 (67.94 GiB 72.95 GB)
     Used Dev Size : 71236608 (67.94 GiB 72.95 GB)
      Raid Devices : 2
     Total Devices : 3
       Persistence : Superblock is persistent

       Update Time : Tue Mar  8 10:17:08 2022
             State : clean=20
    Active Devices : 2
   Working Devices : 3
    Failed Devices : 0
     Spare Devices : 1

            Layout : far=3D2
        Chunk Size : 512K

Consistency Policy : resync

              Name : BusterTR4:R10Swap
              UUID : 3f2d098b:4b0df7a4:dfa23b05:0af8f480
            Events : 144

    Number   Major   Minor   RaidDevice State
       0     259       14        0      active sync   /dev/nvme1n1p4
       1     259       10        1      active sync   /dev/nvme2n1p4

       2     259        5        -      spare   /dev/nvme0n1p4






