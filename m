Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB4EEC433DB
	for <linux-raid@archiver.kernel.org>; Wed, 20 Jan 2021 16:38:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 76F5823358
	for <linux-raid@archiver.kernel.org>; Wed, 20 Jan 2021 16:38:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391260AbhATQh5 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 20 Jan 2021 11:37:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728439AbhATQd2 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 20 Jan 2021 11:33:28 -0500
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9298C061757
        for <linux-raid@vger.kernel.org>; Wed, 20 Jan 2021 08:32:43 -0800 (PST)
Received: by mail-pj1-x102e.google.com with SMTP id x20so2517499pjh.3
        for <linux-raid@vger.kernel.org>; Wed, 20 Jan 2021 08:32:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=tA0yGYdEDNQO0h7po7+iQDqn1rvtKrhvUf77EOSGq24=;
        b=xTNgj3xqGLEiSznyFZuqBuDP1lTlw7a4EWTOjlv+Jwp4NxfacdHLVdMkbwe2wW0gcV
         86sQUoXjGhMgCAdIvyclHLWp9YWFE0VqplVbso5SPMvmyZx14n9Omz16AFuTx6sJ3PQp
         1Ei94KCGT9BMTjSz8clKVf7tzr4xFTUu1kwFbFy9umTnQcPLZC0V71b2V3utIkwDu5Hi
         azSK/tYHm4izgyTGI6Ph7dOX9sbOdOXlLGWesDN3AQC79uHM7qiovkBQCXcDdYqaGanF
         Fqg4P7yukH0apGA7Me7Fe87CPy4g7KIHlrkdHSNoChZ3JPGeC8JjC0bV9RK7dFbhEuTY
         SlkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=tA0yGYdEDNQO0h7po7+iQDqn1rvtKrhvUf77EOSGq24=;
        b=jEsOeQLqw9FMsJyiqd1kVADDPfgnz69VK/L4rjTAHVrEXxLTytRr3bU2VNivP2T1oY
         x6kgRL/QktNu2i55rZkw9bsTlhsSYs3/ApD9C0FY6DeOp6kEJMXRsrlTQahYiRetHJNn
         H/8N6UPqsCVvrDH6537W1mdNksZj4V2BPCw0sESwGEf3EQ7l7CZtwKbM8ATqqbj+5fUl
         m9lpsfzbj23M2T3udmkRf9MhVSCAsNKw96jDZdU+khmTAIJlJj4Uh+BNSUV0jnK5ismP
         bsrY2+cUd+tSnEl0XUAQtcWxhpD3mB+Ati/OKHZKmfhYVf5EUSuLex9PVaY36lNbwKVI
         2LTg==
X-Gm-Message-State: AOAM5325pObVHjf4YFa0XwGzmKtyXZwp5AWItT3kHyXmI6OZ6HCnZvWi
        6bSbDz9DLzr9bYPFgwLrg+6X+A==
X-Google-Smtp-Source: ABdhPJw6urYvcsNQB8f9Yt+6Yh2tDUcO4YDI4XUbub+RSWj5IDQhZg8u/bmWeFPmaWwMUPJBz3xDew==
X-Received: by 2002:a17:90a:d913:: with SMTP id c19mr2244445pjv.19.1611160363252;
        Wed, 20 Jan 2021 08:32:43 -0800 (PST)
Received: from [192.168.4.41] (cpe-72-132-29-68.dc.res.rr.com. [72.132.29.68])
        by smtp.gmail.com with ESMTPSA id c5sm3178887pgt.73.2021.01.20.08.32.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 20 Jan 2021 08:32:42 -0800 (PST)
Subject: Re: [GIT PULL] md-fixes 20210119
To:     Song Liu <songliubraving@fb.com>
Cc:     linux-raid <linux-raid@vger.kernel.org>, Xiao Ni <xni@redhat.com>
References: <745AFA65-3D87-4D24-9B16-D1DE59CB3AC6@fb.com>
 <1b5ab25e-7ab0-ef51-ca3d-b2e25d916533@kernel.dk>
 <B68A8E6B-D79F-4AAA-AB7A-E52F6213B343@fb.com>
 <D76D387E-E353-4049-994A-2A3B4E99A1EC@fb.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <55ded707-2911-2097-ccd9-57eaff7b2b22@kernel.dk>
Date:   Wed, 20 Jan 2021 09:32:41 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <D76D387E-E353-4049-994A-2A3B4E99A1EC@fb.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 1/20/21 9:29 AM, Song Liu wrote:
> https://git.kernel.org/pub/scm/linux/kernel/git/song/md.git md-fixes

Pulled, thanks.

-- 
Jens Axboe

