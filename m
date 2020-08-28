Return-Path: <SRS0=wQ6l=CG=vger.kernel.org=linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EAC0AC433E6
	for <linux-raid@archiver.kernel.org>; Fri, 28 Aug 2020 13:52:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AF2DD20825
	for <linux-raid@archiver.kernel.org>; Fri, 28 Aug 2020 13:52:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20150623.gappssmtp.com header.i=@kernel-dk.20150623.gappssmtp.com header.b="rcjowm9L"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726929AbgH1Nwb (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 28 Aug 2020 09:52:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726839AbgH1NwX (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 28 Aug 2020 09:52:23 -0400
Received: from mail-il1-x12d.google.com (mail-il1-x12d.google.com [IPv6:2607:f8b0:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1ACCC061264
        for <linux-raid@vger.kernel.org>; Fri, 28 Aug 2020 06:52:22 -0700 (PDT)
Received: by mail-il1-x12d.google.com with SMTP id f75so888851ilh.3
        for <linux-raid@vger.kernel.org>; Fri, 28 Aug 2020 06:52:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=STezlWtfv78aOANvbVIbzeB45cZvks2tJ9nOABzqPHg=;
        b=rcjowm9LCSWAbBMewo220f2njpaPGI+bxyBhU2oJfHssMeaowI/bFrw7qoMzAq+b64
         PN6aDHLfWWCPSf5jK+dBrlS/xyNBHajV7kKWnmUN4TB4ScK8kZDyaY9Yjq2WqFNfRTX3
         I0xbfXeZis0aUwKnxmhWWwdq4Jp2Lx4+lm3bjuwnD1LqBRBWSAZxmaCT5+6J9ciVe+RK
         0VN2VTh2uD43gYhkkXZMpqOM18DW0B3nk9gD+LbZKegtGyr0I5f525JciIks5It/dv+0
         /zFQFIu6Yh4NKI00pkDaqHDdjYTCFrAc799+Ur/G7iTDnGM5xy8jXnnYJGxPhCnnrQMe
         EvZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=STezlWtfv78aOANvbVIbzeB45cZvks2tJ9nOABzqPHg=;
        b=tGZ5iLsNLTZGxO9jrZjuj7ce6Y+e+tiw1X2zNLQiCNXJZ+CxCDC511CiVl9F5Mzn3A
         WqSaRV27+CkshZXTGw8ISxLEHEiyuayXuW3cLlBZljEjvOwVsJJegN9xN4w5aO0H7OM2
         Of5Ax50+UOI4jvT2AlqUESkoICLlKaD2haUIf9HG7mK1DhUBFhsO4ZJSAjO8ebTxgsX+
         3usYxkYHp3aSxnOLy/oYf8Ff4baUiuNiSPpVJVqXqdEDBAuahOYkdULkHEYii2wcoVrM
         PHcB4vcq0NXcMX8oAvI2WGD6a75nXdcSdir+jw5h48nDjhWIN45u0Sn93ilz3zhK0cO2
         b/Iw==
X-Gm-Message-State: AOAM531acwZdTACyzo37TPGx4jfYJcQjh+JPd+j6NxpgEs0I0qxLSmOt
        ycZcrpkxTovEM7+wPxDn1af1Rg==
X-Google-Smtp-Source: ABdhPJw/8zg2i5wFBTYaU/yGK2PDCJWgLBMMV5RUwkVokEarFZoJbiidcRRBql99IGniap4hHHki/A==
X-Received: by 2002:a92:d843:: with SMTP id h3mr1579626ilq.197.1598622742262;
        Fri, 28 Aug 2020 06:52:22 -0700 (PDT)
Received: from [192.168.1.58] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id p21sm581049ioj.10.2020.08.28.06.52.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 28 Aug 2020 06:52:21 -0700 (PDT)
Subject: Re: [GIT PULL] md-fixes 20200828
To:     Song Liu <songliubraving@fb.com>,
        linux-raid <linux-raid@vger.kernel.org>
Cc:     Yufen Yu <yuyufen@huawei.com>
References: <D8061404-18E3-401D-8FBB-749F4C6DDAA4@fb.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <53ad1adf-c79b-1751-c2b2-79b73409ff7e@kernel.dk>
Date:   Fri, 28 Aug 2020 07:52:21 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <D8061404-18E3-401D-8FBB-749F4C6DDAA4@fb.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-raid-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 8/27/20 11:48 PM, Song Liu wrote:
> Hi Jens, 
> 
> Please consider pulling the following fix on top of your block-5.9 branch. 

Pulled, thanks.

-- 
Jens Axboe

