Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CCF5EC43381
	for <linux-raid@archiver.kernel.org>; Wed, 20 Jan 2021 16:08:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ABE89233E2
	for <linux-raid@archiver.kernel.org>; Wed, 20 Jan 2021 16:08:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391118AbhATQC1 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 20 Jan 2021 11:02:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391108AbhATP7q (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 20 Jan 2021 10:59:46 -0500
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23391C061575
        for <linux-raid@vger.kernel.org>; Wed, 20 Jan 2021 07:59:04 -0800 (PST)
Received: by mail-pl1-x62e.google.com with SMTP id t6so12746276plq.1
        for <linux-raid@vger.kernel.org>; Wed, 20 Jan 2021 07:59:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=CWG0XpFdz7PfMsKQVfU1ciFrFlXoj+Go2KxgJyCAtaY=;
        b=ff7q81VmOjgjPQ4lBETKhneHm+rao1t4HK6Z4xyRPlRX+Hi6+0ttAbq5Jrcqi3T4TI
         qHIox8PKrqG2DgSdGpfDWrl9QMbq3k54O5zs4S7oQnbPfGpG+a2Vwkbexrg9Rgzojwv4
         FCFggtXcbjhQLpuaW6XDf2vDKLMu+9/A7Q2EVRGIAp1KzE1vW1I+8zqWO8zx2+oEBXJ4
         LfLuL5H4nUuR5kXmhA2zmxuLK61pcBeBu/6csuiIDaLSheJYxO04bL4D+5/h1QWX/ufy
         bt35ue9RxgZiKlPH6XsIGmjvlrhdqHYif7vv+6i3ZoQQumAIRQSj9xIK5+OtI4VEpO26
         8Vog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=CWG0XpFdz7PfMsKQVfU1ciFrFlXoj+Go2KxgJyCAtaY=;
        b=mN9dCTq7uHEM+AZdsPtCcQdiBSUQOZrWtMKw6TYepMiPBpmwNESw3Git1D6eiV69cu
         V254H6cp7WMsJ3MhHtVq+8b7CAN3UA6gSAw1g8lI8WPYyRpYglpAEIbC/uAfkX2TjiIo
         DPWWh8OwihQcfCX7TDJ+UZVgajARCp3MXvORnANAwsxcfvMEB3hip4PY6XkYHp3Vhobv
         focbg2ecoTVFH8pJVezv+z+y/ocl6vZLmreFJibebK+lpdMR18QRiUZAXoSLcrUzYyfl
         Z5V8IaGKBY98UXrO6NFzbWWlU2OzXFK1Qrxtq1+fdc9IPXUDlaTvPFfPxtWwlC4sl6at
         jeZw==
X-Gm-Message-State: AOAM530QNAWGlPvtkzv2lr9li5eYr0lOiGF+/Hw4qWCuWLTgMSAEIesA
        zIUzu1TkY3hWszYj/CU/yCa/uV1ccSO35w==
X-Google-Smtp-Source: ABdhPJxu5jIhhNjaK1hh6yO2llz17qlMDuCPNYuNW2GIs8roHeWo5kHJtqStw0AsonG/aeSxJP/FPw==
X-Received: by 2002:a17:902:820a:b029:da:f380:8629 with SMTP id x10-20020a170902820ab02900daf3808629mr10578893pln.54.1611158343584;
        Wed, 20 Jan 2021 07:59:03 -0800 (PST)
Received: from [192.168.4.41] (cpe-72-132-29-68.dc.res.rr.com. [72.132.29.68])
        by smtp.gmail.com with ESMTPSA id f36sm3132060pjk.52.2021.01.20.07.59.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 20 Jan 2021 07:59:03 -0800 (PST)
Subject: Re: [GIT PULL] md-fixes 20210119
To:     Song Liu <songliubraving@fb.com>,
        linux-raid <linux-raid@vger.kernel.org>
Cc:     Xiao Ni <xni@redhat.com>
References: <745AFA65-3D87-4D24-9B16-D1DE59CB3AC6@fb.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <1b5ab25e-7ab0-ef51-ca3d-b2e25d916533@kernel.dk>
Date:   Wed, 20 Jan 2021 08:59:02 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <745AFA65-3D87-4D24-9B16-D1DE59CB3AC6@fb.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 1/20/21 12:28 AM, Song Liu wrote:
> Hi Jens, 
> 
> Please pull the following changes for md-fixes on top of your for-5.11/drivers 
> branch. 

Don't submit current release patches against the old branch for the merge
window, you need to be using block-5.11 at this point...

-- 
Jens Axboe

