Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55681EB64D7
	for <linux-raid@archiver.kernel.org>; Fri, 23 Jun 2023 14:12:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231293AbjFWOMY (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 23 Jun 2023 10:12:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232017AbjFWOMI (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 23 Jun 2023 10:12:08 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CE3A26A0
        for <linux-raid@vger.kernel.org>; Fri, 23 Jun 2023 07:12:04 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id d9443c01a7336-1b5585e84b4so1058405ad.0
        for <linux-raid@vger.kernel.org>; Fri, 23 Jun 2023 07:12:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1687529524; x=1690121524;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=kQ16zW8a2XjPKQSOPm6n59pndpMnRfxHuCxky969JX4=;
        b=Rddnv5bvxr1vXC09/UVAuwcCFLQbEAG2wOs4ZW3OtbDfU85E75YqpGlckrcLxT2uLx
         aGn1YFAB7g6RothTHuL04pcEOQLw8XuaeTr09orMxDHyURSGJQ9UsK+PUeHF5RB+tmkn
         hv/WRoXgbXqBXPcHA/QLplC5+dHMnw8nef+YW/wZKe1SoO/zf8x+8/4uTdo3+ZrPa02a
         9EC/yHlR8hfLHN3mjidgY931qcXdDkpd9Q47wyrTUccGXijDlrYEGm5a5aYxkyUeRRZ3
         yHzuNX1SzW0c37vqs1QEDOTfTzM9H5At1u1ESXbgza6glo6OBjEfIBMKool0HlooIqx7
         fNeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687529524; x=1690121524;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=kQ16zW8a2XjPKQSOPm6n59pndpMnRfxHuCxky969JX4=;
        b=GdXh6ZW2cph7lagc7xD93XHOxKSCtI/Xhszf+gWR2kiZlqI4ADPID5bp4lkRgoTiDJ
         yiplqpn94xI5xrWYbJmp+hLPocaY1rIBob1YDwuhRve4cdUL43S/YjAM9v+H3CEvFqc7
         LDUnyddaG1l0sr0SCjZjZteRbOyjVVCGwGPo6nhsGTMDQSMQ5mq5UsRJ5g+K/rbe+McX
         T76vQmFTfncexPqzWvVEzYTo38d2JdoUM2lIYgFPW/Oh1UGYpN4gxQEDbkqHdhh9uUXo
         dbSjDpzAY0Y43QAzInwnxIn9Isa5hxDUJOGtQWYKQ6HSc9hVHUBHvhzvUPUmvSD4jxuH
         nIuw==
X-Gm-Message-State: AC+VfDxet9pxs3JJAFS3FtlV0sGCj3xYxDLu3y58aZ/y4dEQNt0yuEtY
        gnS1ZadezfnsOccRRusuo/3SHw==
X-Google-Smtp-Source: ACHHUZ7eJIIlYwqwVjySu0dpKb5srKHgS61UdJMSD2Iu+RLE4lICx2TOd728Ann3PfjBhvC0dHo0/w==
X-Received: by 2002:a17:902:ecc6:b0:1ae:1364:6086 with SMTP id a6-20020a170902ecc600b001ae13646086mr26174779plh.2.1687529523788;
        Fri, 23 Jun 2023 07:12:03 -0700 (PDT)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id x4-20020a170902ec8400b001b682336f66sm6953347plg.55.2023.06.23.07.12.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 23 Jun 2023 07:12:03 -0700 (PDT)
Message-ID: <83240030-681c-9ff5-6e2c-600e83b0cc71@kernel.dk>
Date:   Fri, 23 Jun 2023 08:12:02 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Subject: Re: [GIT PULL] md-next 20230622
Content-Language: en-US
To:     Song Liu <songliubraving@meta.com>,
        linux-raid <linux-raid@vger.kernel.org>
Cc:     Christoph Hellwig <hch@lst.de>, Li Nan <linan122@huawei.com>,
        Yu Kuai <yukuai3@huawei.com>
References: <BCD9738E-472D-4AA7-B4F9-CCF36B5DA0E1@fb.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <BCD9738E-472D-4AA7-B4F9-CCF36B5DA0E1@fb.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 6/22/23 11:48?PM, Song Liu wrote:
> Hi Jens, 
> 
> Please consider pulling the following changes for md-next on top of your
> for-6.5/block branch. The major changes are:
> 
> 1. Deprecate bitmap file support, by Christoph Hellwig;
> 2. Fix deadlock with md sync thread, by Yu Kuai;
> 3. Refactor md io accounting, by Yu Kuai.

This is quite a lot on the day that I prepare pull requests for the
merge window... I've said this many times before, but just to state this
in completeness, maybe it'll benefit others too:

1) Major changes for the next release should be sent to me _at least_ 1
   week prior to the merge window opening. That way it gets some decent
   soak time in linux-next before heading upstream.

2) Minor fixes, either for major pulls that already went into my next
   branch or just fixes in general, can be sent anytime and I'll shove
   them into the appropriate branch.

When bigger stuff gets sent this late, then I have two choices: reject
them and tell you to send it in for the next version, or setup a new
branch just for this so I can send it to Linus in a later pull in the
merge window. Neither of those two options are great - the first one
delays you by a release, the second one creates more churn and hassle
for me.

-- 
Jens Axboe

