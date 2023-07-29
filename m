Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ADBC5C0015E
	for <linux-raid@archiver.kernel.org>; Sat, 29 Jul 2023 13:18:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229883AbjG2NSp (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sat, 29 Jul 2023 09:18:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229459AbjG2NSp (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sat, 29 Jul 2023 09:18:45 -0400
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9E9E268B
        for <linux-raid@vger.kernel.org>; Sat, 29 Jul 2023 06:18:43 -0700 (PDT)
Received: by mail-pf1-x42e.google.com with SMTP id d2e1a72fcca58-686f6231bdeso726792b3a.1
        for <linux-raid@vger.kernel.org>; Sat, 29 Jul 2023 06:18:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1690636723; x=1691241523;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=jYvXWRfAamDgVzNn4TLG1T/lmPQtKSJi7NryMa5wkA4=;
        b=Lbmwt/Mtp/857HmeSzw9neT9VJPuQkTkh0v2KJ8QYxSswNETdLuqzpCzkGSuMHEuB0
         XHMyqrVjE88KjMas0KdeCeehrp3++dlTPJJ0MORocOVK3X4GzTUeqfSvV4dI4pJlvgp0
         G+Vwlp7UmiQ5xXXdy5eWK20EviS7+nN3tZwBoEvIAxWlw5NuSX04d/GaRlVImuJbobdf
         gRFdCO3USceeEZQyzvtIPT4WiOWkjDx4hJhTphvTFTBAxl8l5KrnZ0noIZbmD2gtMQyf
         8QGMCcGw3NWajTCuVi+J2nGn+ul+nzt0Xk+hcZ7V7S2jnXH2tqfoLTgSFZRPhvVZ1juQ
         vryw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690636723; x=1691241523;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jYvXWRfAamDgVzNn4TLG1T/lmPQtKSJi7NryMa5wkA4=;
        b=ke1q8fEnn52l8gMbJxKtNAZ3dC2nuekpeKhwtvn/uum5SrzmudOBJGrx0iDxCt8Eqp
         1SQvS8gLgxBhzukZ5QFvrKkKgZcaq2XClKCFWq4Ul0QjTKq5A9e5DzcaMuEgqCyKZk7a
         7iWc1XHb8mSIFYAwMyPhZ7VnqVdQZVgn4aga+xcWG8PMAVnrK/iM/2ZDzmeG0FQMThLL
         BQS+dHLmL+rfTgjGBi07U3bhhFH4rorMiJXG4knKueyDhqcwHncbP1BuUThGgDc4QZf3
         N5R4RL0Ff9lRW6T4kajk8s2IfbLqvnpjTmcrw+4O6zH4rJeuaoOj8cHP5zO8K/wpzIPT
         rOfQ==
X-Gm-Message-State: ABy/qLYwuI6h1fcGOusmSi8lT9PPU4L/pU29bH54bIrdrF+zCDNDo0I4
        4ILHb3W4BUFs9R5jhCRyKx/DHMl+Lw6uvpkMz2c=
X-Google-Smtp-Source: APBJJlGlFkWZDLkha4GPM3eQ4hmQcpk8kLnjW08IdBmUzqOhvNk4LEGqUOGduFWokWZRVyKy6y5mPg==
X-Received: by 2002:a05:6a20:4424:b0:12d:77e:ba3 with SMTP id ce36-20020a056a20442400b0012d077e0ba3mr3328675pzb.0.1690636723305;
        Sat, 29 Jul 2023 06:18:43 -0700 (PDT)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id l15-20020a63700f000000b00563a565e5fbsm5120543pgc.9.2023.07.29.06.18.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 29 Jul 2023 06:18:42 -0700 (PDT)
Message-ID: <11946707-c588-7b88-c33a-2bc9a0518a6e@kernel.dk>
Date:   Sat, 29 Jul 2023 07:18:41 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [GIT PULL] md-next 20230729
Content-Language: en-US
To:     Song Liu <songliubraving@meta.com>,
        linux-raid <linux-raid@vger.kernel.org>
Cc:     Christoph Hellwig <hch@lst.de>, Yu Kuai <yukuai3@huawei.com>,
        Li Nan <linan122@huawei.com>, Jack Wang <jinpu.wang@ionos.com>,
        Song Liu <song@kernel.org>
References: <BE8FC4BF-3602-44D8-B211-D8953D0CE136@fb.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <BE8FC4BF-3602-44D8-B211-D8953D0CE136@fb.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 7/29/23 4:15 AM, Song Liu wrote:
> Hi Jens, 
> 
> Please consider pulling the following changes for md-next on top of your
> for-6.6/block branch. The major changes are:
> 
> 1. Deprecate bitmap file support, by Christoph Hellwig;
> 2. Fix deadlock with md sync thread, by Yu Kuai;
> 3. Refactor md io accounting, by Yu Kuai;
> 4. Various non-urgent fixes by Li Nan, Yu Kuai, and Jack Wang. 

Pulled, thanks.

-- 
Jens Axboe


