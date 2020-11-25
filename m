Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47F3AC2D0E4
	for <linux-raid@archiver.kernel.org>; Wed, 25 Nov 2020 02:47:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DB2DD206D5
	for <linux-raid@archiver.kernel.org>; Wed, 25 Nov 2020 02:47:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="rTNHklQr"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726969AbgKYCrQ (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 24 Nov 2020 21:47:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726330AbgKYCrQ (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 24 Nov 2020 21:47:16 -0500
Received: from mail-oo1-xc2d.google.com (mail-oo1-xc2d.google.com [IPv6:2607:f8b0:4864:20::c2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 430CEC0613D4
        for <linux-raid@vger.kernel.org>; Tue, 24 Nov 2020 18:47:16 -0800 (PST)
Received: by mail-oo1-xc2d.google.com with SMTP id s11so143010oov.13
        for <linux-raid@vger.kernel.org>; Tue, 24 Nov 2020 18:47:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-transfer-encoding:content-language;
        bh=4uOPWLD8TXR9VQ7lg7VQCrqNr95+yZjOL6Tk3ZgZ6f8=;
        b=rTNHklQrRBqiAHzMdlf/G5PA26eolES8BfxSerdeCJFNq9QpPzTWjYA0Dw+1F4oWvG
         TuAwj+eH7DQ8ZXmcE0+uNVygLB/F6kKlEsEDsvjMO2U3Ol96yib8vVPwd+Ur4VZV6MPO
         PJuGzcN59eWB1spbwlXHlUMybLgyuC3JfW91KbXCHF3M52kyE8aC4Dbgw6JI3+78ejNJ
         Mf/KVh10uUHC6V4PuunBlyhOiKRJWr38QDFsqDj9pHhBWV/8/woONLvLErDjBPJes6yX
         MHI0G/fomqpASK0pYRA7tVaUeTfFlpjZBETw9ZecCr1QirPpLiYSX5NYXEY9gY1jkt79
         N7+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=4uOPWLD8TXR9VQ7lg7VQCrqNr95+yZjOL6Tk3ZgZ6f8=;
        b=BaKhJ0LWPSErq7p3ACpYNzbEUGm+VtZsb40PLO/qbZGFekK/c/iwbZVtv+0Xf9KXD/
         net+xagk/OC1nJo6IFrJw11ncd1xpVE25nEkw03cKH8KTc+KjJV7iABEBSbRx+/WYdjF
         9xYNn6FCqQ1P1/NLqPC8QgNeDdKOa0kO61fd3Qh0LrY5401hYgQCGDvYB76kvriW23dF
         nyHpW0CuLUBYScjgvtXdnKVuELASvsoKx7Pcrvegd3+J+sD/hOBaYjrfS5n86lBdoeyN
         Z46zBW/ugAxFbSjv1DFQYq0pflWJq6S789Ezyfy8APvabDv2XAaXHO6KlNAlWwUqYgLs
         K0pA==
X-Gm-Message-State: AOAM533Qi1ETbYp4mQ6W6TjVBScKoLCD3eiVSVO3riD1Pe2HZIZJkQiG
        l/kRj7U/JGtfU/we2wjfoDN/RKZibOY=
X-Google-Smtp-Source: ABdhPJwpfaGGC1709ICNB2rCAy4Ogtxw7TPQb1PjkR+9idzmIilX7VK3+JOoQbknDi1bo6GzqDx3Ug==
X-Received: by 2002:a4a:e5ce:: with SMTP id r14mr1202439oov.11.1606272435386;
        Tue, 24 Nov 2020 18:47:15 -0800 (PST)
Received: from [192.168.3.75] ([47.187.193.82])
        by smtp.googlemail.com with ESMTPSA id m109sm514867otc.30.2020.11.24.18.47.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 24 Nov 2020 18:47:14 -0800 (PST)
Subject: Re: Considering new SATA PCIe card
To:     Alex <mysqlstudent@gmail.com>,
        Linux RAID <linux-raid@vger.kernel.org>
References: <CAB1R3sgQm2_-Bhbzned4y056XP5hM9oz1OnTZSfHH9+L5sdpFQ@mail.gmail.com>
From:   Ram Ramesh <rramesh2400@gmail.com>
Message-ID: <c629eb5c-ee37-a7fc-6ffb-8035945e5f16@gmail.com>
Date:   Tue, 24 Nov 2020 20:47:14 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <CAB1R3sgQm2_-Bhbzned4y056XP5hM9oz1OnTZSfHH9+L5sdpFQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 11/24/20 8:20 PM, Alex wrote:
> Hi, I have a fedora33 server with an E31240 @ 3.30GHz processor with
> 32GB that I'm using as a backup server with 4x4TB 7200 SATA disks in
> RAID5 and 2x480GB SSDs in RAID1 for root. The motherboard has two
> SATA-6 ports on it and the others are SATA3.
>
> Would there really be any benefit to purchasing a new controller such
> as this for it instead of the onboard for the 4x4TB disks?
> https://www.amazon.com/gp/product/B07ST9CPND/
>
> The server is relatively responsive, but I was just wondering if I
> could keep it running for a few more years with a faster SATA
> controller.
>
> I'm also curious if the SATA cables have improved over time, or are
> the same cables I purchased five years ago just as good today?
If plan to use addon cards, please consider LSI SAS9211-8i cards. Well 
supported and reliable.

Ramesh

