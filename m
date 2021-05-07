Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D48FC433B4
	for <linux-raid@archiver.kernel.org>; Fri,  7 May 2021 01:47:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DBD506105A
	for <linux-raid@archiver.kernel.org>; Fri,  7 May 2021 01:47:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234033AbhEGBsv (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 6 May 2021 21:48:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229801AbhEGBsu (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 6 May 2021 21:48:50 -0400
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E80FC061574
        for <linux-raid@vger.kernel.org>; Thu,  6 May 2021 18:47:50 -0700 (PDT)
Received: by mail-ej1-x62f.google.com with SMTP id n2so11130369ejy.7
        for <linux-raid@vger.kernel.org>; Thu, 06 May 2021 18:47:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=pmYrAsIOLQAsK5ozLCfrPpbNM47cX6FRLfGE9LfeImc=;
        b=BMgAse6CTKLfYAr8uddy2nOY+G13cSebVSsTmtuo+E/jHAotquDLQm8kuZmVSsZsXV
         XGLHlPZCoTDJxSo7FmA8kZD6BpV1EHINTUY2Oa8Aadlp25xJ5d+owj1G1w72gYBeWswj
         nxgqB9MlBNFKrZz/Nb7FKG2738Int3tgoSFxm3wZFfAPRdgqj0vMJeVV3GjPbQ2stcb7
         pDbt2sn6dOPlbX9B4heS1IHl18p3GUfVNGOPBJNC4CWv4lmyjBEjE8YMP790qYogoOzz
         wEK4T32u2uoX+mZi0uaYEKVfHkFwqdtzDQDmPSN5BHKJ94Q8wQTCvIhDsHHJACeydGl3
         67xQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=pmYrAsIOLQAsK5ozLCfrPpbNM47cX6FRLfGE9LfeImc=;
        b=TLR3ZHHOhlK6O414PsGCca1fvUliCrD1E9umPKHVyPcdlc1htE8hkiezOgAIQth+RY
         5bFaktniex+MnqeNZ7LtR5HvPptSX5lhxcpjdS+iAUTiTW2aRqzSVVUgjDaS51YpbmGZ
         VSdv/HV7Brrdb0mi1JAr0Nk5JvMQotbl2qMsvUZhXtml1MceEKgLsKMqJ+Wo5E18l+jv
         px/VhzCs4+kT+npPIYroo7/Q4osW+yLugxC1lC+lZnpIVwIakXt7G2MYaVqFtsJBoA+8
         JnSXKN2VkeT7rQ9QMI2OvD6dbOgrIVugHvfG5YDjNdeouCETPIBCiG2o0Jsyj3hW3Kz7
         wafA==
X-Gm-Message-State: AOAM532u9JOXhW7JsIzxIj7Qo/XvMO4Rzi6q/Z04dvSIhXtJEnv7XkKk
        BRv3SX4UkJQg6kNmu6/uv8k/9uCTLxMQaWh7Z8I=
X-Google-Smtp-Source: ABdhPJyEtzDLU2B8Hyxk2OwbYzccibSCaJcTvtikQ75OAFgVBIlXdEVh+jU+Xk2NKHf1IvtJt8ujbaPO+xFFhQVWRnU=
X-Received: by 2002:a17:906:35d2:: with SMTP id p18mr7329120ejb.339.1620352069127;
 Thu, 06 May 2021 18:47:49 -0700 (PDT)
MIME-Version: 1.0
References: <CAC6SzHJLG=0_URJUsgQshpk-QLh6b8SBJDrfxiNg4wikQw4uyw@mail.gmail.com>
 <8626adeb-696c-7778-2d5e-0718ed6aefdb@redhat.com> <CAC6SzHK1A=4wsbLRaYy9RTFZhda6EZs+2FjuKxahoos_zAd0iw@mail.gmail.com>
 <871rakovki.fsf@vps.thesusis.net>
In-Reply-To: <871rakovki.fsf@vps.thesusis.net>
From:   d tbsky <tbskyd@gmail.com>
Date:   Fri, 7 May 2021 09:47:39 +0800
Message-ID: <CAC6SzHKKPCk4fOx7b2CxMWorPghRPMH3GD2v7vcC_YLKbDn7KA@mail.gmail.com>
Subject: Re: raid10 redundancy
To:     Phillip Susi <phill@thesusis.net>
Cc:     Xiao Ni <xni@redhat.com>,
        list Linux RAID <linux-raid@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Phillip Susi <phill@thesusis.net>
> No, it only depends on the number of copies.  They layout just effects
> the performance.

I thought someone test the performance of two ssd, raid-1 outperforms
all the layout. so maybe under ssd it's not important?

> No; 2 copies means you can lose one disk and still have the other copy.
> Where those copies are stored doesn't matter for redundancy, only performance.

 I am trying to figure out how to lose two disks without losing two
copies. in history there are time bombs in ssd (like hp ssd made by
samsung) caused by buggy firmware.
if I put the orders correct, it will be safe even the same twin ssd
died together.
