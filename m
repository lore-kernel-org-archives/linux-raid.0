Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 821D2C433F5
	for <linux-raid@archiver.kernel.org>; Wed, 15 Sep 2021 14:11:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 690F461164
	for <linux-raid@archiver.kernel.org>; Wed, 15 Sep 2021 14:11:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237723AbhIOOMb (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 15 Sep 2021 10:12:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234729AbhIOOMa (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 15 Sep 2021 10:12:30 -0400
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77AFCC061575
        for <linux-raid@vger.kernel.org>; Wed, 15 Sep 2021 07:11:11 -0700 (PDT)
Received: by mail-ej1-x633.google.com with SMTP id kt8so6348056ejb.13
        for <linux-raid@vger.kernel.org>; Wed, 15 Sep 2021 07:11:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=R178KnP01yZ3w5fkn4jA7MEi6hbi/jGhfiTSu+3bznE=;
        b=dVwsnocn1oARAiLObv7Bh8jNxWoHwsjrIdzojDAGgS7vil5kTA31jxJESvQWfX4tAn
         6Po/xsQjWKlP/y37+Wxaovj4/qWOsdWPdwQmTcpPamSekLsYTe+JGyWEuGU5aFYu0260
         DnDulEj6UDjdpMGgVoLiQVpgf7nbopI6P5WEzCe/xu78VrWSpib65nDKJfEXnw1aucTv
         6nUP9OALtFNgI0bGAEsEznuI3wYBMmF5hgXNytpntHgK3jaS4YLvmlRYDGxUaT7TwrxX
         zDHmfsTGLLeyjcJmjXcsOoujmP/wmbsrzJS03E62OJvNTV/ossdy/+oOAs4b9T7Chox8
         U6lw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=R178KnP01yZ3w5fkn4jA7MEi6hbi/jGhfiTSu+3bznE=;
        b=NAjmwZyqFXqlrTZfe9FwMpzTXFc6cBSMU7HnE5etICoRKlh/x6MfkzrWBzShlgDF5l
         N+Oj1+Y5bs5WIZchjJJOehcykFEkF8WJYWOd1uFxxsg4wecW4Hrwc0noe4ZhRP78oqPv
         cAh/fG2dCV6TUry4CA+2iVOixT1jM0xYFTnvrzJUgVX8PGPfV8pyffJp1ZvRqsYVVJzL
         aUzBVcQbdGMMIABM5fiRIONP/mmHIqqieUOvvSIR9Lj/euu3y9zRH0pbDTEgDIjdIyAe
         3Kcb8o6PucF6KToG45/Iqm1ojj1HlbHYYllLKlBXZqT2447WTSmZgSFoAsmPfLOjj+na
         r6uQ==
X-Gm-Message-State: AOAM531uN+bFi92DP96zwdgrnQYSw7Cm8gSzZJ9o2537keF7MvvxK9fy
        FbzrvsNK7icg2StEqPg9a0w58lARr3Y=
X-Google-Smtp-Source: ABdhPJzmV64XMnVnPdAYUAMoIlhJY4YqZqbHhDyelMV89csM9T+d022pQFiZnsLqZ33mCa3R1A7Pcw==
X-Received: by 2002:a17:907:7601:: with SMTP id jx1mr192615ejc.69.1631715070063;
        Wed, 15 Sep 2021 07:11:10 -0700 (PDT)
Received: from localhost (94-36-77-208.adsl-ull.clienti.tiscali.it. [94.36.77.208])
        by smtp.gmail.com with ESMTPSA id s4sm53160eja.23.2021.09.15.07.11.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Sep 2021 07:11:09 -0700 (PDT)
Date:   Wed, 15 Sep 2021 16:11:08 +0200
From:   Gennaro Oliva <gennaro.oliva@gmail.com>
To:     Anthony Youngman <antmbox@youngman.org.uk>
Cc:     linux-raid@vger.kernel.org
Subject: Re: Raid 5 where 2 disks out of 4 were unplugged
Message-ID: <YUH+/KIg+Jm/ueOG@guru>
References: <YSdcUa6ZYsdPEtFB@ischia>
 <8a9c66df-b271-dcac-4ca3-86c2de083bfd@youngman.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8a9c66df-b271-dcac-4ca3-86c2de083bfd@youngman.org.uk>
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi Anthony and Phil,

On Sat, Aug 28, 2021 at 07:02:03PM +0100, Anthony Youngman wrote:
> Do NOT "rebuild the superblock" whatever you mean by that. What I think you
> need to do is force-assemble the array. You might lose a bit of data - the
> first thing you will need to do after a forced assembly is to check the file
> system ...

I attached the disk on a recent linux system and I was able to force
assemble the raid again. Thank you for your valuable help.
Best regards,
-- 
Gennaro Oliva
