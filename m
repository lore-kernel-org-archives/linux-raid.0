Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB713C63777
	for <linux-raid@archiver.kernel.org>; Mon, 30 Nov 2020 22:54:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 579CE20725
	for <linux-raid@archiver.kernel.org>; Mon, 30 Nov 2020 22:54:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20150623.gappssmtp.com header.i=@kernel-dk.20150623.gappssmtp.com header.b="O5WVzfee"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388030AbgK3Wx7 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 30 Nov 2020 17:53:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727319AbgK3Wx7 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 30 Nov 2020 17:53:59 -0500
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDEF7C0613CF
        for <linux-raid@vger.kernel.org>; Mon, 30 Nov 2020 14:53:18 -0800 (PST)
Received: by mail-pg1-x530.google.com with SMTP id s63so10999831pgc.8
        for <linux-raid@vger.kernel.org>; Mon, 30 Nov 2020 14:53:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=j+Vo/lcQ3lySGUrj7w/eBvisPtunzLpSZsr1Rw/U5bQ=;
        b=O5WVzfee2Y0Ljy8kEb7HKVZiS2E8Z4qYqdQDOmZlK1tYZ3TKND+Ywu3VM6XGzO62aX
         ts/5C72FjnEcMyn/zpCoIt2aDNeyKALEOb7ZSkfqwXv86mofm3m7zok2Fi7DmCJ6vIEs
         R39MHVTh0kAlo8z3sTMhgpBuf0zMfdJ34fKLdlaDPz1J97v81awt/LOzvNYMsaVs09jh
         t+CsHusfBR6MDPBjlrWsE6WiKIYDZt61S4R2KQ6JfjiRf0G4volFvIfPpz09Q5mNVNUU
         XGRy9vZuxK9jwur7kKYqmwQdskuVht0P5jF2X1tWs1wQLcxnUOm9oHDv627MredYUYdN
         URjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=j+Vo/lcQ3lySGUrj7w/eBvisPtunzLpSZsr1Rw/U5bQ=;
        b=Hw3hJbQzer7ztJQfDu1MmrxjyNkSKZoa5ajtXyRGquQb0tdPWsp7WMXg6QqWpietmX
         4DeiEiCA0nTY+lIJLjEc9VzcQvZxcqR4BXVq/jPXYXeKco5WJnK/Bt/+oV96Iwaz+tBi
         moToUfu+AAbJTNXKesh/ybed+7m+xGIemHJ3Ki92AaDEhY6FwP3RIg5jJzfOajH2V6NP
         1hllmbTrF9JFdWuTKuK66b47T0NEji9DPIDgflaBx5jGZIuzv+pczu7qTju4ogMJRgMJ
         zMnR92BDb4Kjcuvh8AsMqTSRVCAZmEGcrafb5Oiw13jGrZ8WSn49GxJJJ4JYvgT7egqr
         MAtw==
X-Gm-Message-State: AOAM532eXTLOAdbovHTirfcqZ+6/0TiKrUHvzlGr2nIyGzOqXTp8o/W7
        WFaM+tp6QtGSgwmzyMFZfVLJDQ==
X-Google-Smtp-Source: ABdhPJzM8xgC8p132Df+HejgWjWO4UpgCoQ2lUCdS0W0CSh3rpEjYT6rPgrR9Kq8hihBgJgh3wKIKg==
X-Received: by 2002:a63:6c81:: with SMTP id h123mr18920615pgc.401.1606776798201;
        Mon, 30 Nov 2020 14:53:18 -0800 (PST)
Received: from [192.168.1.134] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id r66sm18166629pfc.114.2020.11.30.14.53.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 30 Nov 2020 14:53:17 -0800 (PST)
Subject: Re: [GIT PULL] md-next 20201130
To:     Song Liu <songliubraving@fb.com>,
        linux-raid <linux-raid@vger.kernel.org>
Cc:     Zhao Heming <heming.zhao@suse.com>,
        Pankaj Gupta <pankaj.gupta@cloud.ionos.com>,
        Kevin Vigor <kvigor@gmail.com>,
        "Dae R. Jeong" <dae.r.jeong@kaist.ac.kr>
References: <84FD2F29-B2F8-4026-A93D-5E28F28A3B4B@fb.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <5719b897-a662-db59-16f2-d21ae2e5a83f@kernel.dk>
Date:   Mon, 30 Nov 2020 15:53:16 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <84FD2F29-B2F8-4026-A93D-5E28F28A3B4B@fb.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 11/30/20 11:15 AM, Song Liu wrote:
> Summary: 
>   1. Fix race condition in md_ioctl(), by Dae R. Jeong;
>   2. Initialize read_slot properly for raid10, by Kevin Vigor;
>   3. Code cleanup, by Pankaj Gupta;
>   4. md-cluster resync/reshape fix, by Zhao Heming. 

Pulled, thanks.

-- 
Jens Axboe

