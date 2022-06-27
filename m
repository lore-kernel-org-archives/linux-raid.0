Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9162C433EF
	for <linux-raid@archiver.kernel.org>; Mon, 27 Jun 2022 01:32:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229463AbiF0BcX (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sun, 26 Jun 2022 21:32:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230417AbiF0BcV (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sun, 26 Jun 2022 21:32:21 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 056222673
        for <linux-raid@vger.kernel.org>; Sun, 26 Jun 2022 18:32:19 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id h9-20020a17090a648900b001ecb8596e43so7921486pjj.5
        for <linux-raid@vger.kernel.org>; Sun, 26 Jun 2022 18:32:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=shenkin.org; s=google;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:in-reply-to:content-transfer-encoding;
        bh=lSVoygjPyJCq1/yD8pxbveOyeG7blqc8Z+eKyLeN5EU=;
        b=SINN0pOZ3331Wv2lDb/xlnzpPJ01HFjJQF89IIKwmPXnUOI5jZEqB97NLRu6kW2iq1
         EGteM6vhYL1wKMA8IUw+1Xh1kHXNfvhXM7CmJzUHeT3Lh8GfAh9JjOwuUwo4WNYTAQhi
         IMEjhRZ9aY6cn21d6ybrlFt2yMVCHoPcOjD9I=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=lSVoygjPyJCq1/yD8pxbveOyeG7blqc8Z+eKyLeN5EU=;
        b=QAj/Zl4l1n1M6KAmDt+SXWLT2WSw+jm73dbaidFNj5BGaAddA+NnOvSrKzgi2A8SNB
         GgFhoj1OAysu61RkWbZlGgS2TPMDUfZcFwHcm8ARDzowjaftnagQ2oU3y8EzpxE9xRnl
         7klQuhbjQU57QdGUf0vhw2868ytH+YjCQGqEXAoJswLJAi06+FVDPtTB1lG55I8vFgab
         Wu0NuevQEdvQxCXho5tr4Bz2D2WlT3bwQGAn1f1IaWWT7T3x9ATehqvTcfOA/whuFnhR
         nt3JhjddWCChW/TAmKi0VvIeLNa+fRurtGa4PlzR32W23l1geng2UrHflAl4qtBRg9Dm
         v9tw==
X-Gm-Message-State: AJIora97pxSAAyFy+pQ80Y99L+f4lTrvjlMVJM6Rx1SQX/JDYRViVnkr
        nuapLvdWozDrfQ1Vl+shyZzzvfw7o0XZdtvz
X-Google-Smtp-Source: AGRyM1uual3VC+rfPGoP7pc8+cc/XpyiisB+1Y4gs04XEkz9wB3MCp70ZtGS8mhBbLMK0QL2tNTCew==
X-Received: by 2002:a17:903:3296:b0:16a:23ec:75f8 with SMTP id jh22-20020a170903329600b0016a23ec75f8mr12032591plb.121.1656293538332;
        Sun, 26 Jun 2022 18:32:18 -0700 (PDT)
Received: from [192.168.1.243] ([47.215.181.107])
        by smtp.googlemail.com with ESMTPSA id p31-20020a056a000a1f00b0051bdb735647sm5793574pfh.159.2022.06.26.18.32.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 26 Jun 2022 18:32:17 -0700 (PDT)
Message-ID: <b1c6b0c2-ff7b-59e0-580c-81d57b8f8ddb@shenkin.org>
Date:   Sun, 26 Jun 2022 18:32:26 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: Upgrading motherboard + CPU
Content-Language: en-US
To:     Pascal Hambourg <pascal@plouf.fr.eu.org>,
        Wols Lists <antlists@youngman.org.uk>,
        Stephan <linux@psjt.org>, Linux-RAID <linux-raid@vger.kernel.org>
References: <CAPpdf59G6UjOe-80oqgwPmMY14t0_E=D20cbUwDwtOT8=AFcLQ@mail.gmail.com>
 <81c50899-7edb-e629-3bbc-16cfa8f17e34@youngman.org.uk>
 <b777865e-b265-1e83-dae0-f89654e86332@plouf.fr.eu.org>
 <5cbd9dd1-73fc-ce11-4a9d-8752f7bea979@youngman.org.uk>
 <1de4bf1f-242b-7d02-23dc-a6d05893db81@plouf.fr.eu.org>
 <20220624232049.502a541e@nvm>
 <dab2fe0a-c49e-5da7-5df3-4d01c86a65a7@shenkin.org>
 <20220624234453.43cf4c74@nvm>
 <22102e4b-4738-672d-0d00-bbeccb54fe84@shenkin.org>
 <d85093a4-be3e-d4f2-eca0-e20882584bab@youngman.org.uk>
 <b664e4ce-6ebe-86c6-78d9-d5606c0f6555@shenkin.org>
 <5cb8d159-be2a-aa6c-888a-fcb9ed4555c1@youngman.org.uk>
 <20220625030833.3398d8a4@nvm>
 <ae2288f4-ad06-65af-d30c-4aef6d478f27@plouf.fr.eu.org>
 <s6nh748amrs.fsf@blaulicht.dmz.brux>
 <1b6c6601-22a0-af2a-81a9-34599b1b0fa7@youngman.org.uk>
 <f971e15d-9cd4-e6de-c174-f3c6bd338bb6@plouf.fr.eu.org>
From:   Alexander Shenkin <al@shenkin.org>
In-Reply-To: <f971e15d-9cd4-e6de-c174-f3c6bd338bb6@plouf.fr.eu.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org


Ok all.  I've put in the new mobo + CPU, and the BIOS isn't finding any 
bootable devices.  Suggestions for next steps?  Thanks in advance...
