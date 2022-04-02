Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58541C433EF
	for <linux-raid@archiver.kernel.org>; Sat,  2 Apr 2022 12:48:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354767AbiDBMuN (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sat, 2 Apr 2022 08:50:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354763AbiDBMuM (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sat, 2 Apr 2022 08:50:12 -0400
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E617181
        for <linux-raid@vger.kernel.org>; Sat,  2 Apr 2022 05:48:20 -0700 (PDT)
Received: by mail-ej1-x62e.google.com with SMTP id bg10so11079610ejb.4
        for <linux-raid@vger.kernel.org>; Sat, 02 Apr 2022 05:48:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to;
        bh=OuoNvybHWqOHL4346sL01VTY/xuio+MYXq6DvIel06g=;
        b=VMjv2UvpSrlwa/Ds4cwCzSBDMsyq2ufLd7LFg2MgIHXp68ogVLDoxfEfvWRZtnhXsp
         lSdMyCzPAheQ7PhHII3i9s+8pMAHORVqa0VOHHzE2Pibm9tG+zK6nJ23zC4lxnKNC3z3
         boImjpdieoKbrs8jtwK006bFog0ytqlmjD8sItwmfEPgA/GxAHmoO+huz3kEx2sLqr8P
         0x4FYbkOf3Y+5D2U991uohAE1Niw7gow5LAzrRwSaVtQT8zbs6LpnuDLVg95TGO4zuBd
         sXRUcZOo78VDHJm7E50QSGKuooob/Nqo/feSm+yRGLHEKMRt1+XE8Ha8lVGhHlSvqC4N
         IdDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=OuoNvybHWqOHL4346sL01VTY/xuio+MYXq6DvIel06g=;
        b=XAyw/emZHlpZFW/NjWYJbEE9mdHBUbFGOeHHMSAUNflZQ7whYsS+CKrwpQeslep9al
         uWvUvILlNU3HtQLmdIJ1slfyJmJt8NmXshr+IIuDeoHLesmpd69aodNLQQ9BczL5IxjN
         DJRC0ttbGzBTcpN2M7SPe1UjLJhpjyo5x4Lth11TLEYJVsWRwMtke0gI/4yd7vLFQNea
         rp2ybFRPfQRHPpdrPylanyr71qQ7JFDa9ATjB/sw9HhoinhIyu6nwIiqbHruIioHB8yS
         J/ApV4zlyEwl2IcOkf5cEbbNL1Q6kUIm5Ee/uNVtbIUTeZrny1JRZJSXYrIBsnrPsf0V
         iR3Q==
X-Gm-Message-State: AOAM531wzneUzanoFfRhhczJk/UkksHUuAE9HveNa0vxvEL9tfxFQV+V
        vSWKYMTo3hxqgaisFl4MIRT3UfBLFLc2H7aEwbI8tygC
X-Google-Smtp-Source: ABdhPJwYCkkXOCc2ZxwsbJIfyKBCwbiRYmcHPm8Bs7nt8C5pbKaBE5rqD6b8Z+RiGdntHjkSudMWjpSsBatlGUtzJDE=
X-Received: by 2002:a17:907:6e89:b0:6df:d819:dc9c with SMTP id
 sh9-20020a1709076e8900b006dfd819dc9cmr3983185ejc.158.1648903698708; Sat, 02
 Apr 2022 05:48:18 -0700 (PDT)
MIME-Version: 1.0
References: <20220318030855.GV3131742@merlins.org> <CAC6SzHKFga59KpzhRhE-sz3K5z+=LUXfyxSB14KaOj7DCxCj-Q@mail.gmail.com>
 <20220328020512.GP4113@merlins.org> <CAJCQCtQyqG_zWhRVXjnc3Prc+J-7hK1hyp28mwyuKWWPJ8Uo5A@mail.gmail.com>
 <CAC6SzHL9Vy2Tz_rVFRphTuAjwPNXg59WAuY8JCXXQ94W09y4sw@mail.gmail.com> <20220330023333.durdl4ydb3pz4yab@bitfolk.com>
In-Reply-To: <20220330023333.durdl4ydb3pz4yab@bitfolk.com>
From:   d tbsky <tbskyd@gmail.com>
Date:   Sat, 2 Apr 2022 20:48:07 +0800
Message-ID: <CAC6SzHLUOP0zyKGLHjcfxcgqy3XSCo2fHLTgZfhU_dNajnSFnA@mail.gmail.com>
Subject: Re: new drive is 4 sectors shorter, can it be used for swraid5 array?
To:     list Linux RAID <linux-raid@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Andy Smith <andy@strugglers.net>
> There is a standard called IDEMA LBA1-03:
>
>     http://www.idema.org/wp-content/downloads/2169.pdf
>
> This says that a certain "marketing capacity" (i.e. when the drive
> product description says "2TB" or whatever) will equal an exact
> number of 512 or 4096 byte sectors.

  thanks a lot for the information!  now I understand what happened to
my disk drives :)
