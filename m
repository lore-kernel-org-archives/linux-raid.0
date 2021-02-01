Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 271E2C433DB
	for <linux-raid@archiver.kernel.org>; Mon,  1 Feb 2021 16:36:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D304C60235
	for <linux-raid@archiver.kernel.org>; Mon,  1 Feb 2021 16:36:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230110AbhBAQgd (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 1 Feb 2021 11:36:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230029AbhBAQgc (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 1 Feb 2021 11:36:32 -0500
Received: from mail-il1-x132.google.com (mail-il1-x132.google.com [IPv6:2607:f8b0:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0554DC06174A
        for <linux-raid@vger.kernel.org>; Mon,  1 Feb 2021 08:35:52 -0800 (PST)
Received: by mail-il1-x132.google.com with SMTP id g7so15097984iln.2
        for <linux-raid@vger.kernel.org>; Mon, 01 Feb 2021 08:35:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=YWqjAePF4OfyzcbyIzyEt7DCN5MRBy3o4f4bV/BiE3E=;
        b=N57DVgNf1Yry1LCNgAsfa85Uzq68J+FAGRb0Qlh8i9oMolQmtTA3FpkaveRij6FMIE
         Q4ijp1mspGlXou9XN2tINbfRwnRoniZNtx9o6+cuP0Coc8/WJfd2K4X67YiAsxRgM8o7
         2t1FAjTzXCJT+PSmPvg8+KUgLi2Bn0nroFiwQ1YhB5HrinKjUvHA2XxLkXlwNkHcpFzn
         sJJUE3Rsp07aRXF38kAB458BZpKs+wIbuHzNmeFZ2Z72U0Dq5rAfZ4YaPjLJr86JofVa
         FDqqkzVWQbs+atvY5/lAEQiBof5CmFQSl4N1rubZwnEg7NEAeVZKq9GOTlJpdT7dvQHt
         VtgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=YWqjAePF4OfyzcbyIzyEt7DCN5MRBy3o4f4bV/BiE3E=;
        b=MnGjUss4nFbJd0YABwUOMz0ppXgOCzw2OyAFWG/BWH2OiZfHUnb6vGXOShCUV9Vanb
         mkTlDoalv8TlDiI/VnqNZXzyPDj+fPcDE8JXVGn/tZaU0kzAGPEzpSa54ar5ym7u0C05
         l40SFA0o2O7QJ1hqcF6w6rYbxEsPhF6/JMgaYbs44O9n6slTWyDjSYgwT7jtOadbA/e4
         iAcbXXC8GCtpsoyPa+da/n0rcExwOWkuWoXVpCoNX60fsktCBzcsJ+tJw2hphtAu/mjA
         dFDRMohTsaiHLB6JONkNkjveDaP0LGz0Ourdjy8w1+mzMA3fZmxCoB59L1yGyH/JlbQ1
         tzag==
X-Gm-Message-State: AOAM5323oVd8O7I5nw9f2QXEqgI3gq9FA2SJ+S6t7mEScOe3B20hyZ16
        uwy/TA80JA2TVaKpNxfsvgwM2Quf2YbVHnuS
X-Google-Smtp-Source: ABdhPJw+31gafLVQMvq3GjDgr4O5bj4kpCZQcxct239/5/8vdNIZF534gWhm0QTEmyTKfRGR5jM5OQ==
X-Received: by 2002:a92:cda1:: with SMTP id g1mr13515870ild.267.1612197351122;
        Mon, 01 Feb 2021 08:35:51 -0800 (PST)
Received: from [192.168.1.30] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id v14sm9654190ilm.18.2021.02.01.08.35.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 01 Feb 2021 08:35:50 -0800 (PST)
Subject: Re: md read-only fixes
To:     Christoph Hellwig <hch@lst.de>, song@kernel.org
Cc:     guoqing.jiang@cloud.ionos.com, linux-block@vger.kernel.org,
        linux-raid@vger.kernel.org
References: <20210201131721.750412-1-hch@lst.de>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <656b8eb7-b2a1-b6ac-5620-29cb59fe5def@kernel.dk>
Date:   Mon, 1 Feb 2021 09:35:49 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210201131721.750412-1-hch@lst.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 2/1/21 6:17 AM, Christoph Hellwig wrote:
> Hi all,
> 
> patch 1 fixes a regression in md in for-5.12/block, and patch 2
> fixes a little inconsistency in the same area.

Applied, thanks.

-- 
Jens Axboe

