Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13A99C433EF
	for <linux-raid@archiver.kernel.org>; Sun, 27 Mar 2022 08:40:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230431AbiC0Imb (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sun, 27 Mar 2022 04:42:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230229AbiC0Im3 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sun, 27 Mar 2022 04:42:29 -0400
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACA572528F
        for <linux-raid@vger.kernel.org>; Sun, 27 Mar 2022 01:40:50 -0700 (PDT)
Received: by mail-ej1-x62f.google.com with SMTP id yy13so22996959ejb.2
        for <linux-raid@vger.kernel.org>; Sun, 27 Mar 2022 01:40:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=azkHNQx4Fv8/7St7nw5pFIJ2T4r/Wb6L0/DmIGnlte8=;
        b=TZKtmv7o0Xqe4mGJeYy6TI4q3fWWHODPKUoRS58+dfTimji5xqr+DuLYLpVduyAhP7
         NCJLnivySIc0KGHXEn96ndeLcC1xedV5q+v06VIL484l7yu10BynLiS2jajelHFoCnWQ
         sd/po4YIMsh/dVhKc7J/HGGDQYNSxfbJMq2SENbrUAtotbugE7DSEtLjFw4yO+yMW/vy
         FTqZgMv/2y3FoaRIIqScNTF7Qtd7YnzfGLHQSCSAwfGo80zPJFIRhBbOS50Jddl0tEei
         n6F1JujjOVG7nd+SUjhIqy4EHAGzMLyL2Vk+0Ky7wWmeDk2iynH5QB3k7NuXz2rCzfuc
         tVVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=azkHNQx4Fv8/7St7nw5pFIJ2T4r/Wb6L0/DmIGnlte8=;
        b=qIKqCPQ/uf35xOS+mSL8JDstBMBswSF55Dz2vn5VevTLfpvO73IF78FDQid51XUgS0
         1deiJQfPiFrSgsmsGuSOb+V/6+4fXPlgF8CtsLJrPyHBDymn2Z5q/fYPHDxrVB1BftJZ
         8kcGjJ4B8CqLZbjfhFp5XItaXxROUm1VyZaX7cB5Bb0HEX6rvV0a+d6bNLFa2XzlJoA9
         gS+k52oA2Zy8pytS9ap8MFdSzG63fGMSYIJsMvUYuFgqZDPJkvqExnugMjkCIJIa78Ni
         Jkic80OKuzQcqKcTQGicIeV78nUMutbNnKP0iowdGZYW7LInftdj/9F4lOkmrFT9l7fr
         w79Q==
X-Gm-Message-State: AOAM533Xyv4GR9jNiqFfwMxPw96SvAXC2jnenPj/2CtFx9HZoh4R6uZ3
        vxKXUnbKMr3ZHvtn4bdNarvd4LszriI6u7M69MyDjS5W
X-Google-Smtp-Source: ABdhPJwSndqKBZd5c4XyiQZxu6VMcTUBroBvLSm1pTZgsSKkGBl2CSkPXshDQv2YNkWXMDSgMHtz2GN6b8Cae8Uh7bU=
X-Received: by 2002:a17:906:58cb:b0:6df:f696:9b32 with SMTP id
 e11-20020a17090658cb00b006dff6969b32mr21376114ejs.384.1648370449199; Sun, 27
 Mar 2022 01:40:49 -0700 (PDT)
MIME-Version: 1.0
References: <20220318030855.GV3131742@merlins.org>
In-Reply-To: <20220318030855.GV3131742@merlins.org>
From:   d tbsky <tbskyd@gmail.com>
Date:   Sun, 27 Mar 2022 16:40:38 +0800
Message-ID: <CAC6SzHKFga59KpzhRhE-sz3K5z+=LUXfyxSB14KaOj7DCxCj-Q@mail.gmail.com>
Subject: Re: new drive is 4 sectors shorter, can it be used for swraid5 array?
To:     Marc MERLIN <marc@merlins.org>
Cc:     list Linux RAID <linux-raid@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Marc MERLIN <marc@merlins.org>
> New drive is 4 sectors shorter, so I assume I can't use it as a replacement in my md5
> array because it's 4 sectors too short, or does swraid5 not need the last few sectors
> of a drive?

    4 sectors shorter are common for external hard drives (sold from
seagate,toshiba,etc). if you attach the drive to internal sata port or
normal usb enclosure(not sold from disk vendors),you will get back
normal disk size. so maybe you want to check what connect to your
disk.
