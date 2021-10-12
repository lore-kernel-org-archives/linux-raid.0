Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E25E5C433F5
	for <linux-raid@archiver.kernel.org>; Tue, 12 Oct 2021 16:38:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CB32961076
	for <linux-raid@archiver.kernel.org>; Tue, 12 Oct 2021 16:38:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231165AbhJLQlA (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 12 Oct 2021 12:41:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229996AbhJLQlA (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 12 Oct 2021 12:41:00 -0400
Received: from mail-io1-xd36.google.com (mail-io1-xd36.google.com [IPv6:2607:f8b0:4864:20::d36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81EAAC061570
        for <linux-raid@vger.kernel.org>; Tue, 12 Oct 2021 09:38:58 -0700 (PDT)
Received: by mail-io1-xd36.google.com with SMTP id x1so20438000iof.7
        for <linux-raid@vger.kernel.org>; Tue, 12 Oct 2021 09:38:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=g3d5dsgWYcBXML/0bHVZZrvz1WHP+pDIURxzZdmspTM=;
        b=g3K1LNNQEgfXwc/6Q/yusbiPV/AEPubUNbvcp3J15SdofOuSl1Kt5h2pId8pqKA650
         71xbqhivcY2iMGUhoRUNoq3lVXEVy5InOY/yyTStP2hQWBP35gCDdD19DDP/3hShdANW
         QBL0O0PpfvB55S456XbzMiBa0mgpwp5KJhg1WGOapKIWJNeaZgx0z3QBZbIBW+itqaci
         baGdXLS6TwnC1tVjeVuFYGyxEm2cZDm/oF+kUJdlLBWQzOCs9YBTnaghk1EsREwLbCGz
         LhSAUhGH2ONwiVKkqy2ShgxlEhunSoJhdTiMUhtECwWgHhG/kLUQ5qYrUikc8qEn8zdN
         JpqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=g3d5dsgWYcBXML/0bHVZZrvz1WHP+pDIURxzZdmspTM=;
        b=05Ud1ahZuPAUMn6gB8jqLqMNYsds2cdTzQ9bPRKDZf22iBPhtnupq0D93Ix/THjNM1
         M174C55geICpibm7tHOOvjIPB/II5wBKSEwmKdna7AXTfgV39gjsw7BQs6MVy34UkBSH
         LQ2ZMlBetobkae0VHpSJfONlt7k8RKeY9nRUH4+XJVRk3RZ3+umg57R/EGGCjf2xWwrD
         kDembiK+XIAKP2KfUjqXsK+cogXSk+wZ7+UlQSEl0HkrPeJognKAMWjeytxQn0WehEpT
         fGqSdD4PpLMxFmm9RDhymEiXbTs+mXCFiRg2ZHduax+Fsie8G8dR8u/RHYfwMqyJH6TO
         wxfg==
X-Gm-Message-State: AOAM533h6BiaJWfV9WZVtL126nEYLpcLfnld34fKF/El2C+Fd5D3FPRW
        G5SJ0SR0nVwhw5AFuh98NAhBXQwrhZ7ZUw==
X-Google-Smtp-Source: ABdhPJzRDcBP/NpOJjgtoVLFC+Icb9/F4t4yjHuzq49esqn5GPkI21QeOaaXZUa38kz7ZoTJPKO1Fg==
X-Received: by 2002:a05:6638:344c:: with SMTP id q12mr13675040jav.16.1634056737112;
        Tue, 12 Oct 2021 09:38:57 -0700 (PDT)
Received: from [192.168.1.30] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id i125sm953849iof.7.2021.10.12.09.38.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 12 Oct 2021 09:38:56 -0700 (PDT)
Subject: Re: [GIT PULL] md-next 20211008
To:     Song Liu <songliubraving@fb.com>,
        linux-raid <linux-raid@vger.kernel.org>
Cc:     Christoph Hellwig <hch@lst.de>, Guoqing Jiang <jgq516@gmail.com>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Li Feng <fengli@smartx.com>
References: <3ACD8384-A1C0-47B1-BF6E-CFB9600370D1@fb.com>
 <6AF487F1-2217-4E5A-9327-61FC2871C640@fb.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <d7ea4a78-58b4-508d-365d-158499b7a4c4@kernel.dk>
Date:   Tue, 12 Oct 2021 10:38:55 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <6AF487F1-2217-4E5A-9327-61FC2871C640@fb.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 10/12/21 2:22 AM, Song Liu wrote:
> Hi Jens,
> 
>> On Oct 8, 2021, at 4:57 PM, Song Liu <songliubraving@fb.com> wrote:
>>
>> Hi Jens, 
>>
>> Please consider pulling the following changes for md-next on top of your
>> for-5.16/drivers branch. The major changes are:
>>
>> 1. add_disk() error handling, by Luis Chamberlain;
>> 2. locking/unwind improvement in md_alloc, by Christoph Hellwig;
>> 3. fail_fast sysfs entry, by Li Feng;
>> 4. various clean-ups and small fixes, by Guoqing Jiang.
> 
> Please hold on with this. We may not need the new sysfs entry. I will 
> get it sorted out soon. 

OK

-- 
Jens Axboe

