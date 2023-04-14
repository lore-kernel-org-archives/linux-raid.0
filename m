Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76AD8C77B72
	for <linux-raid@archiver.kernel.org>; Fri, 14 Apr 2023 12:34:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230502AbjDNMeD (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 14 Apr 2023 08:34:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230096AbjDNMeC (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 14 Apr 2023 08:34:02 -0400
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EFB7A5CD
        for <linux-raid@vger.kernel.org>; Fri, 14 Apr 2023 05:34:01 -0700 (PDT)
Received: by mail-pg1-x530.google.com with SMTP id 41be03b00d2f7-517ca8972c5so140317a12.0
        for <linux-raid@vger.kernel.org>; Fri, 14 Apr 2023 05:34:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1681475641; x=1684067641;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=eL3CkWX6Ob8rrFWYzDmtMgjCJs0hDGDSQQ9fc/Yd6N0=;
        b=XsGjFR0e4M9sZ4rM8oyBGJWSuhlnLlE+q8wlyAbK3yq6M4FaIAuwPtIVEzGSlx6Miw
         jE6rYjtV54r2v9qkMhZHOJ+CCXaBm4o+G0UklUpzbm56UVBLe/nX7Rc90Tw3PLkj+eqi
         JgloSbMcPiQuhP2JrkUcLlaVcIgwZgXlz99rvYvc/wKUatXoC9dKVrtIhy74IVXEriQY
         1egV4EhMBpm+8DllHLZfpfLdgaQBArV2ooqskV/+s5IvVqSXPhhR7zPPbq43tAaQI2jg
         UikzocDCHlTzo/hwANyaX2qG+BPF7CjAXxBYEqaeSQaX3OISqVQJ6vJcX0e1U2hHJeo9
         gifA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681475641; x=1684067641;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=eL3CkWX6Ob8rrFWYzDmtMgjCJs0hDGDSQQ9fc/Yd6N0=;
        b=aplTk+7w5o+K5CxehlVm+rOybIMHDH9qpDf5Qy3r7bIaIxVFUCDKVZGlV14b/qHzjj
         1ZnhQ/OyAUpAxzgywaBxPOwcJnzJnh1aTy6/4XUJ9wu4nCHe3FDwB0K+FLoPBMKSRvnD
         jKsFWunX3+0+0IgjAQJGZ271tMF7fFVFVzzTJAm2HRt/QKEPTM6bKeFBdfPpbyRmO03m
         xV1f5afCWjiaubQ5W96tt3uZDY8mHBNLNp3QTPTdsNzMw2bqwrSHnNGsQAV/hF7banr+
         lTNhLC9j1oF3x6uxT+hDPPhAQlEivzWPESv2e2qQxp2Y1pz1rN9dSFv2DkRAj2/akr+K
         +3Fw==
X-Gm-Message-State: AAQBX9dKyIfbi05XAxoBgP1X1eBPPy4nx850zIlf93RABhHImXN1iNmD
        tUExZKVDLL2d5r9/OM0iRnDRNg==
X-Google-Smtp-Source: AKy350Y6ATq810rbCXts8LGUIVkHhPPCJGkIswz53VLrelhMnbMaxTrQ9TL6U6a3fJ3MnEPfeyaNkw==
X-Received: by 2002:a05:6a20:8f0a:b0:c0:2875:9e8c with SMTP id b10-20020a056a208f0a00b000c028759e8cmr2544454pzk.1.1681475641059;
        Fri, 14 Apr 2023 05:34:01 -0700 (PDT)
Received: from [192.168.4.201] (cpe-72-132-29-68.dc.res.rr.com. [72.132.29.68])
        by smtp.gmail.com with ESMTPSA id o38-20020a635a26000000b004ff6b744248sm2768540pgb.48.2023.04.14.05.34.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 14 Apr 2023 05:34:00 -0700 (PDT)
Message-ID: <62639123-6206-8794-0969-13accce830d0@kernel.dk>
Date:   Fri, 14 Apr 2023 06:33:59 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [GIT PULL] md-next 20230414
Content-Language: en-US
To:     Song Liu <songliubraving@meta.com>,
        linux-raid <linux-raid@vger.kernel.org>
Cc:     Tom Rix <trix@redhat.com>, Yu Kuai <yukuai3@huawei.com>,
        Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>,
        Jon Derrick <jonathan.derrick@linux.dev>,
        Jiangshan Yi <yijiangshan@kylinos.cn>,
        =?UTF-8?Q?Thomas_Wei=c3=9fschuh?= <linux@weissschuh.net>,
        Li Nan <linan122@huawei.com>
References: <63276F1C-0855-49EB-A04C-411A57159C02@fb.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <63276F1C-0855-49EB-A04C-411A57159C02@fb.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 4/14/23 2:36 AM, Song Liu wrote:
> Hi Jens, 
> 
> Please consider pulling the following changes for md-next on top of your
> for-6.4/block branch. The major changes are:
> 
>   - md/bitmap: Optimal last page size, by Jon Derrick
>   - Various raid10 fixes, by Yu Kuai and Li Nan
>   - md: add error_handlers for raid0 and linear, by Mariusz Tkaczyk

Pulled, thanks.

-- 
Jens Axboe


