Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 256FBC2D0E4
	for <linux-raid@archiver.kernel.org>; Tue, 17 Nov 2020 15:51:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CC02220867
	for <linux-raid@archiver.kernel.org>; Tue, 17 Nov 2020 15:51:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="R8eCqNz3"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726642AbgKQPvB (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 17 Nov 2020 10:51:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726302AbgKQPvA (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 17 Nov 2020 10:51:00 -0500
Received: from mail-qk1-x735.google.com (mail-qk1-x735.google.com [IPv6:2607:f8b0:4864:20::735])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97E2AC0613CF
        for <linux-raid@vger.kernel.org>; Tue, 17 Nov 2020 07:51:00 -0800 (PST)
Received: by mail-qk1-x735.google.com with SMTP id v143so20816627qkb.2
        for <linux-raid@vger.kernel.org>; Tue, 17 Nov 2020 07:51:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:references:to:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=GKpWKO/8UsSBTsjnb+7x1CGzDYkMw06XSrcG+nh3gZk=;
        b=R8eCqNz3guNsldym3FVkPJuJtZ5deZ3PtgC0u7fXCMkAwMuA0hxspWGQ6aNrQCT8Gv
         YtQSBfdnLJfHWtsQ8iNWjvcTmuwrzhC4JIosb4kp+seqeiYdgXUt9C9NDPvAD+YadvBL
         WBn02WXsMKJZjs3v7wjDxz+GeDFjNLse92ShTEXoC2KTMy9IlfBSjeEKaFvbDQrpwZMB
         2Jwvh7Ewx2yR/PRu+rOM1JNGyy1ILTv/bzjNsVAuUnnwni/gxCL7XZNkFsU2XRqn6GVo
         fvceK2Vj08jOJ8OaeQwdnMTX/4sE5v0f+T+/Hea0IMpgNiZ9arUlABeRBPeiixtv8pxF
         4e9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:references:to:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=GKpWKO/8UsSBTsjnb+7x1CGzDYkMw06XSrcG+nh3gZk=;
        b=oVEZ92AF1f+BAkHS4Cn92jZg/vs38nk0KA0PppGfgDCTsUFDrXikRA4Gsggvz30MU/
         JMu2a0/ZPbfEw4BO5bJHcIJAB4E7kgLmP1Nd+Z2yNRzGXWQVBxDegZWH45O6utJdauP2
         GFn2xL6/MZvdrzpufTzBtuX5PBZ3teFyrsSm1nhOszYhkVf+8KzwvQ9ciaDcaOvywOSN
         d9AWHwYflyJs2LlNvt03RjA+CI9Mk/rP8Kvz8r45cB9gHdG2HnIdAglnWzd39uxET3fQ
         baK2jcCkCIJObUTCbs8I8PZ+g6Pqs/ZcG5vQRLIStaRRH1yK+nuBLBR8mxyfkHaoXfVR
         A35A==
X-Gm-Message-State: AOAM530+P3ChnM+W6KPMj2PNfN6u4Gw4FxLYTns8ZyPi3gHFrvo5bDls
        /7qjMfdsnX0KXsWCBvprc9WDK8X/01P+0w==
X-Google-Smtp-Source: ABdhPJw+Varu8ROW48SEftCcd76Kok61jqcC02f7npnATAhBeXVbFfiGz3YTVktWwaQLC4yFyaJ7yg==
X-Received: by 2002:a37:ba82:: with SMTP id k124mr156621qkf.25.1605628259455;
        Tue, 17 Nov 2020 07:50:59 -0800 (PST)
Received: from biodora.local ([104.238.233.190])
        by smtp.gmail.com with ESMTPSA id a85sm14611440qkg.3.2020.11.17.07.50.58
        for <linux-raid@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 17 Nov 2020 07:50:59 -0800 (PST)
Subject: Re: Events Counter - How it increments
References: <819ff80e-10d0-8cc6-b34c-418fdea7b57a@gmail.com>
To:     linux-raid@vger.kernel.org
From:   =?UTF-8?Q?Jorge_F=c3=a1bregas?= <jorge.fabregas@gmail.com>
Message-ID: <7b06b78f-c0de-94cc-54de-bf66cfe80b8e@gmail.com>
Date:   Tue, 17 Nov 2020 11:50:58 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.3.1
MIME-Version: 1.0
In-Reply-To: <819ff80e-10d0-8cc6-b34c-418fdea7b57a@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 11/10/20 10:24 AM, Jorge Fábregas wrote:
> How does the "Events" counter (as shown with mdadm --examine) gets
> incremented? On what sort of events?

Anyone?  :)

Thank you.

-- 
Jorge
