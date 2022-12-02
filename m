Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B2498C4332F
	for <linux-raid@archiver.kernel.org>; Fri,  2 Dec 2022 19:37:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234514AbiLBThX (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 2 Dec 2022 14:37:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234366AbiLBThW (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 2 Dec 2022 14:37:22 -0500
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 152ACF37E3
        for <linux-raid@vger.kernel.org>; Fri,  2 Dec 2022 11:37:22 -0800 (PST)
Received: by mail-pj1-x102e.google.com with SMTP id e7-20020a17090a77c700b00216928a3917so9212594pjs.4
        for <linux-raid@vger.kernel.org>; Fri, 02 Dec 2022 11:37:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=pP8hyRh2n8zlrUNC2XCregTPGoSFtllFOriIkil0QNs=;
        b=eCEJqWNMgMIyf550yg5yMyv7JU+9JdpIbCen+A643ehjcFJk35j8hTthTMyHSEcK/0
         lhZap+zXjex1+kNp4fqNU1x6eeXX+ytzGPNAB1aXmTqnPU5e+R2ZaNoN8gaQ8y13xgHR
         PAYIk+tyRA9RmyEyhcAVenSty9AJnEqn3oW8vmbmKz7ngqBQzbgEgnLjcEcGzWCI8p8W
         U4V/jAKSAB/p7ZzL+F8K7p5htHHC18PZBFQ2SehnWTkmQ3bMrjzw+qBwhA42iBipYTKy
         5gUzHkEFADorQezDdzQo/Bts8J8nPdDC+ibopdxsvOjRzdKfLnJC31LIzrZTZMvRAlOw
         cVjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=pP8hyRh2n8zlrUNC2XCregTPGoSFtllFOriIkil0QNs=;
        b=pfnGuZXi//zvMp9m07DnkX5mBzJC4xqgBZfdcaGPZ2pCgxWSFEXPyK6CruRazxThRB
         lu+To/uwdW5HSBCV/eGcdt/EAWrVbpUmhQ9E7foH8swFtR0YdMxWu3YRl8WHOOSLHDLo
         cQYFlH3adaMlOJHQMEkx13E7beuCPV174cyidCDCNJMiNhQGnaV9hSCmAxKsbsfg2w1W
         GY9OMrUc1N0h0YvAlsoccuPlmiX25Hi4+GCJLcBxwZ8Jvpamb/kcgTYxR1rLjkSoLPaB
         HJkyAB7DP51GGSpDGkLegRETXShkUkiNGbRrhpbZvBCQ1ZB12eD890bWrdJzLqfZrKy4
         6m1w==
X-Gm-Message-State: ANoB5pnfjSIIh+Q8XjtsROeFHcB0npFjQTQudaVJlUJjrMJ6jjUkevSA
        acPg2cmCLyovsvMX3TYNH8OjgQ==
X-Google-Smtp-Source: AA0mqf5XAt48bkrggK2vvGj+XyGbc6JK9S+Oxl3qyVeUmVJLY4iFq+FTOw79pZIC6pq0M1SXa8jjCw==
X-Received: by 2002:a17:90b:4b89:b0:213:d2c:1923 with SMTP id lr9-20020a17090b4b8900b002130d2c1923mr19768377pjb.234.1670009841488;
        Fri, 02 Dec 2022 11:37:21 -0800 (PST)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id m8-20020a170902db0800b001895f7c8a71sm5985679plx.97.2022.12.02.11.37.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 02 Dec 2022 11:37:21 -0800 (PST)
Message-ID: <f97630cc-0376-43dd-bbea-1077a4e025da@kernel.dk>
Date:   Fri, 2 Dec 2022 12:37:20 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [GIT PULL] md-next 20221202
Content-Language: en-US
To:     Song Liu <songliubraving@meta.com>,
        linux-raid <linux-raid@vger.kernel.org>
Cc:     Christoph Hellwig <hch@lst.de>
References: <050A7AA8-4E70-47A6-A6E1-0E9E78D57604@fb.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <050A7AA8-4E70-47A6-A6E1-0E9E78D57604@fb.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 12/2/22 12:27 PM, Song Liu wrote:
> Hi Jens, 
> 
> Please consider pulling the following changes for md-next on top of your
> for-6.2/block branch. 
> 
> This contains code cleanup by Christoph. 

Pulled, thanks.

-- 
Jens Axboe


