Return-Path: <SRS0=zRnh=DQ=vger.kernel.org=linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 598ECC433DF
	for <linux-raid@archiver.kernel.org>; Fri,  9 Oct 2020 15:04:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 15AC022260
	for <linux-raid@archiver.kernel.org>; Fri,  9 Oct 2020 15:04:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20150623.gappssmtp.com header.i=@kernel-dk.20150623.gappssmtp.com header.b="VIPVoPIX"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389116AbgJIPE2 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 9 Oct 2020 11:04:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388819AbgJIPE2 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 9 Oct 2020 11:04:28 -0400
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA2FCC0613D2
        for <linux-raid@vger.kernel.org>; Fri,  9 Oct 2020 08:04:27 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id 132so519857pfz.5
        for <linux-raid@vger.kernel.org>; Fri, 09 Oct 2020 08:04:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=KznlefVevs21HJZ4TJb42jsUz0Alwqlt1Nmkall3nGk=;
        b=VIPVoPIXQCx/iqLQgKDERsptfeLej950RPsDHB5Fq4UggNsLyJDurR+dwbUNiUNYJC
         EdIEyi9dSC02w2fIaaduzhs1fw61WA22i1KhyD3prv94wazBSe5ylEeBxVL9/zMRnMtG
         MY1nDKNTcKC3cKdrQhTgJJbJ88wN77NWtTdq9VotWooFgXKTx0REm5tT5qGtggn4Fy10
         Z04KNqE5y8XmfZIlLEXp1tsgkC3y2P0sVDYwU5qTo/z+b0+NqOZhponNvJrR6QWUpwdb
         PJrWEfQEK6It0f669HEZpllva8ghaJNwEtSg5pNX3Ve15rhe81scKzWY5l9wKMLa4mHO
         RoMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=KznlefVevs21HJZ4TJb42jsUz0Alwqlt1Nmkall3nGk=;
        b=SirMWThmQy3ohr9CauxZ2A0LIJojZpcEe5jZRFV+tjm7wtvDbcCZH3TI8uBBk85kZk
         wC5bc3s+D8CwBtaeH7rEO84HIWxhr3KEMUlx6GN+hQq4q/3mb1tnsdoYGD2W02pmvG4G
         BR2OpESB5EtBcbcHDb1eszZhmtI4QxA2DQQEhD20goPqniqCecC4KO6U+rrMG0/x1uj+
         hrtybINAebbT6QjJ9+rliqTUFLy5AkCumIaj6cAOg/OH/W7+6exLAirVbDMADCjSLSFJ
         WI8HiByFBPQr5gcWNVARnmnYT/n1P0TAWBjMTO3N2DELcYo8e0bjhTCqZH/xx8wy0RFB
         cBJA==
X-Gm-Message-State: AOAM530PsYYyvkuYexHuY2K4p5IQiD5su5Y1e5mRmU0+I1u2QBmR/7eu
        i6eSZiGTnHNGUaJtmw5mtQVzOw==
X-Google-Smtp-Source: ABdhPJzIYM2onYgzyIbdlAPfXbvNS1/UwCTmbST/eYnMFouuzU3JpWlTa7tO1hnKZ2aQt+rMcYsBzw==
X-Received: by 2002:a62:7a53:0:b029:152:5482:8935 with SMTP id v80-20020a627a530000b029015254828935mr12981456pfc.31.1602255867356;
        Fri, 09 Oct 2020 08:04:27 -0700 (PDT)
Received: from [192.168.1.134] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id 32sm11393895pgu.17.2020.10.09.08.04.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 09 Oct 2020 08:04:26 -0700 (PDT)
Subject: Re: [GIT PULL] md-next 20201008
To:     Song Liu <songliubraving@fb.com>,
        linux-raid <linux-raid@vger.kernel.org>
Cc:     Guoqing Jiang <guoqing.jiang@cloud.ionos.com>,
        Zhao Heming <heming.zhao@suse.com>,
        Jason Yan <yanaijie@huawei.com>
References: <0AE63FFF-6DBF-4AD1-B93E-F5466E1AF5D9@fb.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <606c79ec-12c4-3de5-f50a-dd1441106da3@kernel.dk>
Date:   Fri, 9 Oct 2020 09:04:24 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <0AE63FFF-6DBF-4AD1-B93E-F5466E1AF5D9@fb.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 10/8/20 11:49 PM, Song Liu wrote:
> Hi Jens, 
> 
> Please consider pulling the following changes on top of your for-5.10/drivers 
> branch. 
> 
> The main changes are:
> 1. Bug fixes in bitmap code, from Zhao Heming.
> 2. Fix a work queue check, from Guoqing Jiang.
> 3. Fix raid5 oops with reshape, from Song Liu.
> 4. Clean up unused code, from Jason Yan.

Pulled, thanks.

-- 
Jens Axboe

