Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52BEFC4743D
	for <linux-raid@archiver.kernel.org>; Sun,  6 Jun 2021 03:44:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2874C6136D
	for <linux-raid@archiver.kernel.org>; Sun,  6 Jun 2021 03:44:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230150AbhFFDqj (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sat, 5 Jun 2021 23:46:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230025AbhFFDqi (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sat, 5 Jun 2021 23:46:38 -0400
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E97CC061766;
        Sat,  5 Jun 2021 20:44:39 -0700 (PDT)
Received: by mail-pf1-x433.google.com with SMTP id h12so7696082pfe.2;
        Sat, 05 Jun 2021 20:44:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=ZxKW6Kso2SfakvBiwIckrr9b6qm3D0xOhDoptqxb6Gw=;
        b=EjSbUMNztiptdx1vkVGsYUF6C6lr71zuWoX4foiLJWs2On1ISCeiousZEwz3CQ2GJe
         hgr4IvsV/KudVMkeu76Mm7r3M+50O31YVYjkS0FDqwZx63VZPzsMDhq2IfLETvSEwl15
         HbMEgw+0t415+PJfKZlBEMA6mHq1ZDxRBffMOZyAbab72GH9aUUAmZPzhiZvN5DgHJ3W
         zyAlo66OtW1T7rdRXbWD1sZLcgjPC2RZPjURploFk7NI2JdCg3InGocEPtceCBjBjkKA
         UEPTNtreUEjFqW3Cz2kHp17+dDSMBMIBMGkLT3IAHeGMqtYnbY7+RnZ2BDJhILeVkLsO
         0UaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=ZxKW6Kso2SfakvBiwIckrr9b6qm3D0xOhDoptqxb6Gw=;
        b=oCVEXINUvIM6XNl06XonCk1Wurx7BqY9ztPObtvU6HAoTSwPHFnzxlxaWrDQ6n6pPu
         Ji8vyHMAp2bICsG4SSs+SjDbNQQQhDUWjsR9dUyStU4ArBTFc7D8C0zhPP98vqkGoLO2
         TgwavreP5tNbnwMamD2Jot2gH/hZxSRF4DZiCO+pm224X5KXw+3nXsfTubBjAGkkwF8g
         zXktI9zf9EgXtd36gUGmj4fzPg8HZoaXJlnz1PkjN2YCAGyKVt0LUcAUBZg4i1YYUJCg
         8Bc6RMXCeCmd1oxyosdF5Gw2mu7uQdNJToBgiJ6IyXXF+t2z5Xz4ZEGt84w/SJMjf602
         5Ocw==
X-Gm-Message-State: AOAM531decHKmfcJ0+MQo2uNKm5z9f2EMppKLB25Qvybsb2zPPYyrm2H
        OF1B53VK7EKT3ygEvyx2pUCeGk+oPlk=
X-Google-Smtp-Source: ABdhPJwHEVgYhUCoGT+9QqPNLR4/iWnj5lpDryLsqRAuWdjfrM8pVkyVb3U+wlwsZ/tiHKLXTozW9A==
X-Received: by 2002:a63:b243:: with SMTP id t3mr12147216pgo.253.1622951076325;
        Sat, 05 Jun 2021 20:44:36 -0700 (PDT)
Received: from [10.7.1.1] ([133.130.111.179])
        by smtp.gmail.com with ESMTPSA id d3sm8300882pjk.16.2021.06.05.20.44.33
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 05 Jun 2021 20:44:35 -0700 (PDT)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.120.23.2.6\))
Subject: Re: [Bug Report] Discard bios cannot be correctly merged in blk-mq
From:   Wang Shanker <shankerwangmiao@gmail.com>
In-Reply-To: <6c407281-ee90-f577-d6db-d36211b1fdc0@youngman.org.uk>
Date:   Sun, 6 Jun 2021 11:44:30 +0800
Cc:     linux-block@vger.kernel.org, linux-raid@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <4456B47B-5E33-4F56-B0F9-9A95400539AB@gmail.com>
References: <85F98DA6-FB28-4C1F-A47D-C410A7C22A3D@gmail.com>
 <6c407281-ee90-f577-d6db-d36211b1fdc0@youngman.org.uk>
To:     antlists <antlists@youngman.org.uk>
X-Mailer: Apple Mail (2.3608.120.23.2.6)
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org


> 2021=E5=B9=B406=E6=9C=8806=E6=97=A5 06:38=EF=BC=8Cantlists =
<antlists@youngman.org.uk> =E5=86=99=E9=81=93=EF=BC=9A
>=20
> On 05/06/2021 21:54, Wang Shanker wrote:
>> You may wonder the importance of merging discard operations. In the
>> implementation of RAID456, bios are committed in 4k trunks (they call
>> them as stripes in the code and the size is determined by =
DEFAULT_STRIPE_SIZE).
>> The proper merging of the bios is of vital importance for a =
reasonable
>> operating performance of RAID456 devices.
>=20
> Note that I have seen reports (I'm not sure where or how true they =
are), that even when requests are sent as 512k or whatever, certain =
upper layers break them into 4k's, presumably expecting lower layers to =
merge them again.

Yes, that's true for RAID456. RAID456 is issuing 4k size requests to =
lower backing
device, no matter how large the request received is. That's won't be a =
problem
because for normal read and write operations, those 4k size requests can =
be
nicely merged into larger ones. Otherwise, we would be flooded with =
reports=20
complaining about unacceptable performance of raid456.

> You might have better luck looking for and suppressing the breaking up =
of large chunks.

I'm quite aware that it is raid456 that is breaking the requests. It =
might be
better if we can avoid this in raid456. I believe it can be very =
difficult due to the
design of raid456 code. However, the question now is the merging is =
successful for
normal read/write operations, but failed for discard operations. Where =
lies the=20
difference? I did some testing in a qemu vm and added some debug =
printing in the
control flow. By what I have discovered, I'm quite confident that the =
discard
requests are not processed the right way when merging them.

Cheers,

Miao Wang=
