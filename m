Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE142C77B75
	for <linux-raid@archiver.kernel.org>; Wed, 10 May 2023 01:57:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230096AbjEJB5x (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 9 May 2023 21:57:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229527AbjEJB5w (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 9 May 2023 21:57:52 -0400
Received: from mail-qt1-x82c.google.com (mail-qt1-x82c.google.com [IPv6:2607:f8b0:4864:20::82c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F0A4E74
        for <linux-raid@vger.kernel.org>; Tue,  9 May 2023 18:57:51 -0700 (PDT)
Received: by mail-qt1-x82c.google.com with SMTP id d75a77b69052e-3f38b7ca98aso28364511cf.1
        for <linux-raid@vger.kernel.org>; Tue, 09 May 2023 18:57:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683683870; x=1686275870;
        h=content-language:content-transfer-encoding:in-reply-to:mime-version
         :user-agent:date:message-id:references:to:from:subject:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Q47s25L6cuXvQ7pjma9Xa2EJzqJdw2u5vJUSN+FOzQ4=;
        b=oeSHjCjVoWb2XxKU+GYaBoqPpF07lEXGVbRLU17J1D+UGW3giWXJD8488UY9FZZT1s
         jA7++AjuWz1NEY7rjCpvehiqJEiNkEiONQvaA8gFetc/Fd07oNtKLL7pEJvqmBosrbLa
         wKC5pFFYZ3/hL++SDY9UjDHEaWwJ0Ah5cZ5/OEwdeMjaphRk2WTp9y87TARdkKkCDfOh
         SfqhL+himOYokFbgF2Kfp0qr8lJ+4USq8PDl6S3bXp+dqynoCUpUnhy4hkJkuZsmTmTO
         Lfs6aFCcojMYEOW7KgRnFehwa7wkVgdlPxY4ISPFLF9IjNdA6lXu3u8cuiQRRjzC8TOZ
         FElQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683683870; x=1686275870;
        h=content-language:content-transfer-encoding:in-reply-to:mime-version
         :user-agent:date:message-id:references:to:from:subject
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Q47s25L6cuXvQ7pjma9Xa2EJzqJdw2u5vJUSN+FOzQ4=;
        b=jyo1gk1OcmB3WRn8/kio1jn9oBxFdQwZf2ZGpEHNTbq/6VBjqZ7q9KS2SxjrRuGeMD
         0LNeuhxl6gpsGIfsLiOHt/o/Lzn+8ygfbkzUoBJYziBn4OLPvmkHDVZdU1Wk9ByDoK0n
         oHlWKJ0IZy/hxTC2xamDkJfpn72nr9d7u0ko5r9vg1A1SFTcRHvD4VzHn+yrplxvGKEL
         xNTKdiH8aSyHwFQNuiFeJ+Q5zBTcckR6kuisS1RkmwKqRysPxwjpluev3EfiCVp4e+X+
         hjQOEWQk8o3HYcSTD3YmKn9FoWuSyXLuvfR/4nQaLx8rau+scjWE0gX5oPxmcO8rsehF
         QPuQ==
X-Gm-Message-State: AC+VfDyyy/iARFuUJDTOT2EFanbCOSMMvBdjCkQUIqW8R5oneNeJpauS
        /g2r6TiUsp5440LUEtP+kMIl/BC+YpQ=
X-Google-Smtp-Source: ACHHUZ7W9JDQ2MlptKzNZF+LGPVTqSYLRoAUpCnZZXqb7JOWV3uK/DuycsHIthf86aNPsz2z1EnW7g==
X-Received: by 2002:ac8:59c1:0:b0:3f1:f599:c259 with SMTP id f1-20020ac859c1000000b003f1f599c259mr23077111qtf.24.1683683869864;
        Tue, 09 May 2023 18:57:49 -0700 (PDT)
Received: from [192.168.125.2] (quantum.benjammin.net. [173.161.90.37])
        by smtp.gmail.com with ESMTPSA id b8-20020ac812c8000000b003f17f39af49sm992464qtj.18.2023.05.09.18.57.49
        for <linux-raid@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 09 May 2023 18:57:49 -0700 (PDT)
Subject: Re: how to set md device to specific group at boot
From:   Benjammin2068 <benjammin2068@gmail.com>
To:     Linux-RAID <linux-raid@vger.kernel.org>
References: <cb1e4326-f5bd-c3c1-f262-d0106c19cb88@gmail.com>
Message-ID: <455d9008-b04a-6645-edae-633bc4c01c18@gmail.com>
Date:   Tue, 9 May 2023 20:57:48 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <cb1e4326-f5bd-c3c1-f262-d0106c19cb88@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 5/9/23 8:25 PM, Benjammin2068 wrote:

> Hey all,
>
> I can't seem to find the answer (looking all around via google)...
>
> I have a couple of RAID drives (/dev/md123, /dev/md124) I set up a long time ago (storage arrays) by hand... And have worked fine.
>
> Tthey mount as root:root but I need them as root:disk
>
> I can't seem to find where to change that.
>
> Little help?
>
> Thanks,
>
>

Not sure if this is the best solution - but fixed it in /etc/mdadm.conf --- durp. I hate editing that file. It gives me the willies.

The arrays I made weren't explicitly listed -- AUTO was assembling them.

So -- still not sure if there's a better way but this did it for now.


Sorry for the bother.


  --Ben

p.s. did I mention how I editing mdadm.conf gives me the willies? :D

