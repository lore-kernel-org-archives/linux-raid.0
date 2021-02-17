Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=0.2 required=3.0 tests=BAYES_20,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17B42C433DB
	for <linux-raid@archiver.kernel.org>; Wed, 17 Feb 2021 03:28:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9EAAB64DE9
	for <linux-raid@archiver.kernel.org>; Wed, 17 Feb 2021 03:28:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230454AbhBQD2x (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 16 Feb 2021 22:28:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229683AbhBQD2v (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 16 Feb 2021 22:28:51 -0500
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C74CC061574
        for <linux-raid@vger.kernel.org>; Tue, 16 Feb 2021 19:28:11 -0800 (PST)
Received: by mail-ej1-x630.google.com with SMTP id hs11so19971667ejc.1
        for <linux-raid@vger.kernel.org>; Tue, 16 Feb 2021 19:28:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=ulx7mag4pWCbQbEEfeFLXNtxwhinAxLhMdm1QPuO0fo=;
        b=t2QzwofKw96zh/im1cXhQltuewUdlR4pPQybhuF5E/dkt+c89ChqW3KxDnuC1bULMe
         OlcYavuezMao0CRJJQMZQD/fZpzHWBiJHa04EDxsn9KqQqYbMvQGllmAenSTl74oNS6z
         aqSx3NmsB1vXFZTDnmXTDHWVuOh8Dg8KGIc+6SSR5lBAzQY7atdnNJKSKdeyk8sMBok4
         x9DvGM90s4DcwEnbiJLp6vwEu3yhRVKrGwW75w71aFFrcH3nu0EppZ8aRQGNu+GCwgqf
         63kLyWh9iUZjf1BUaqiKzJbGeRdiCY9adyAf9yE97CJN1EQiCJklw6SWfRZ6fuVZHahZ
         4JiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=ulx7mag4pWCbQbEEfeFLXNtxwhinAxLhMdm1QPuO0fo=;
        b=mNDdEDKPDwE/RI+R0JuYXXukRdUBzSH1GBD8SinbUuHBnqfW61+vgQT0cIn6+ZDVVc
         2DcDkqg4IybYsOndPKI4Mj91e0MWkYaOPRTRYaYz7HKVnhglSbXJBr4hDu+pOFWN37ZA
         btunt/mqkSHTquMCMELZQQ5XsVNli3GDVS7HnzL8YpRK4Vz+adFxVIxm8V6CSnxISrro
         J3iUMiJZ3HFQU6r01vamGrCJcuq9X+q/x0FsJ/+Ia5A65N7K9Ulyk5NwMohDWh1uJn7j
         GHkH8eTPgPWDeWe1WqSl1Ke4FIXow0QzKLIQMMsb2aq7lHASjzwC+9FK8OFW2nsTYgdI
         mwLw==
X-Gm-Message-State: AOAM532DDE/gEuH71l6DtEDugJ3aRU7H49njYK422uwljMjjfDSExlj2
        VoKeMy5c0AS/jiUFMhrZmI4C44fCEDfUANuAVV7MTcwwEHc=
X-Google-Smtp-Source: ABdhPJzRx0yo1LYmYm5eGGQzyWCYc4ISgyIZ68PkS4NZZhz004R1D6zw0MUTc8cuNOycNDHNXP3PhhtWNBfhdzRl8D8=
X-Received: by 2002:a17:906:4b0f:: with SMTP id y15mr21896930eju.369.1613532489656;
 Tue, 16 Feb 2021 19:28:09 -0800 (PST)
MIME-Version: 1.0
From:   d tbsky <tbskyd@gmail.com>
Date:   Wed, 17 Feb 2021 11:27:58 +0800
Message-ID: <CAC6SzHLHq9yX+dtcYwYyhfoTufFYohg_ZMmaSv6-HVt4e-m-hA@mail.gmail.com>
Subject: use ssd as write-journal or lvm-cache?
To:     linux-raid@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi:
   I was to use ssd to cache my mdadm-raid5 + lvm storage. but I
wonder if I should use them as lvm-cache or mdadm write journal.
lvm-cache has benefits that it can do also read-cache. but I wonder if
full-stripe write is the key point I need. I prefer to use the ssd as
mdadm write journal. is there other reason I should use lvm-cache
instead of  mdadm write-journal?

ps: my ssd is intel dc grade, so I think enable write-back mode of
cache is not problem.
