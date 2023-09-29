Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DBAA3E743EC
	for <linux-raid@archiver.kernel.org>; Fri, 29 Sep 2023 06:02:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232655AbjI2GCn (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 29 Sep 2023 02:02:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229577AbjI2GCn (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 29 Sep 2023 02:02:43 -0400
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2AB4D199
        for <linux-raid@vger.kernel.org>; Thu, 28 Sep 2023 23:02:41 -0700 (PDT)
Received: by mail-wm1-x334.google.com with SMTP id 5b1f17b1804b1-4053e6e8ca7so34814585e9.1
        for <linux-raid@vger.kernel.org>; Thu, 28 Sep 2023 23:02:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1695967359; x=1696572159; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=KxZmEUUe9YtcjVEWObiWLIGuw8ms4q1D0t8u+5UFBK8=;
        b=DeJZPvGA9EvlkTxBQ1t2jx5BPda6QhN6NL8aPKkIDsPYgLNJGEnebxcBvDVLk1IEFV
         K1KXNqXGO8MwnoKR3mxZG85sago1qey+sp7eq/gAUb+QOioJFFjLwQO4VlAMGPF8mGr6
         Ze8Qtwj0EgA497FvTt6aC3f9szQ7xbJRq5W8iFPJVfOT2soPmehXgKXxfiNKJMl3cCkj
         uMhbiy20fHJ+zZgBq2lFHtpqOCa3pPR1vTh6CHIR/LR19TjcOAkVYC5h4cqzYUrEUoS8
         F4WZ0nEUZeVVAKcfOXFydKJQqGXFpkk3qAn0OvRdoANzGmJrAArVmnEn29jELlUId4Dj
         KvTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695967359; x=1696572159;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=KxZmEUUe9YtcjVEWObiWLIGuw8ms4q1D0t8u+5UFBK8=;
        b=lf/lFU2JnwhNUVn8QuhgCjeL1zYJqBkWTsXlUrOREWnQU3xqhGd+2CAqBnQpa29sp/
         ntaVXHm3A6P6YDvzmlv2u/Yst6toICDH3R523Zn6xl4FvGcLcN3iSIgXyxXgVAqZo1qp
         e9T7MbLUDb2SYn6KxHWKUpeLdpsl3vTaQgW08cfEEovwQ8MjmF5bZ7vNNJgIZt8Rbz+o
         oXfNHCzzBWlbPIt8XcOCN29paAE1ukjmLun5/OOYiyhWy6EY9dzLmBIvcEwzQ0y1CVtM
         A5vHFMNxNJgiHOUx1ZXvY85pSXzaRYuMduosGWa568mVzz/yxlEF6o64/bVXik7/nL0h
         LVZQ==
X-Gm-Message-State: AOJu0YzueqobBehnHR0lofsY6c0Qo0bYg2YLMh977xwrFkHpd2XJiFSN
        USvJQ2mHbAxDFReSkoaSXxkzUQ==
X-Google-Smtp-Source: AGHT+IF0yg4bNmDkxkSJUVJ/cI+B7DTwD8GImmMMfrsS+HgYGchWPTtwM3sRU2RbqjIjBiFoK0E5QA==
X-Received: by 2002:a05:600c:1d08:b0:405:358c:ba75 with SMTP id l8-20020a05600c1d0800b00405358cba75mr3018990wms.0.1695967359371;
        Thu, 28 Sep 2023 23:02:39 -0700 (PDT)
Received: from [192.168.50.224] (ucpctl-mut-vip.hotspot.hub-one.net. [94.199.126.32])
        by smtp.gmail.com with ESMTPSA id x16-20020a05600c2a5000b003fee6e170f9sm686775wme.45.2023.09.28.23.02.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 28 Sep 2023 23:02:38 -0700 (PDT)
Message-ID: <f945f9bb-68bc-41b5-977c-64a1f2d0e016@kernel.dk>
Date:   Fri, 29 Sep 2023 00:02:37 -0600
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [GIT PULL] md-next 2023-09-28
Content-Language: en-US
To:     Song Liu <songliubraving@meta.com>,
        linux-raid <linux-raid@vger.kernel.org>
Cc:     Kees Cook <keescook@chromium.org>,
        Justin Stitt <justinstitt@google.com>,
        Yu Kuai <yukuai3@huawei.com>, Yu Kuai <yukuai1@huaweicloud.com>
References: <956CEF49-A326-4F68-BCB3-350C4BF3BAA8@fb.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <956CEF49-A326-4F68-BCB3-350C4BF3BAA8@fb.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 9/28/23 2:58 PM, Song Liu wrote:
> Hi Jens, 
> 
> Please consider pulling the following changes for md-next on top of your
> for-6.7/block branch. 
> 
> Major changes in these patches are:
> 
> 1. Make rdev add/remove independent from daemon thread, by Yu Kuai;
> 2. Refactor code around quiesce() and mddev_suspend(), by Yu Kuai.

Changes looks fine to me, but this patch:

https://git.kernel.org/pub/scm/linux/kernel/git/song/md.git/commit/?h=md-next&id=b71fe4ac7531d67e6fc8c287cbcb2b176aa93833

is referencing a commit that doesn't exist:

"After commit 4d27e927344a ("md: don't quiesce in mddev_suspend()"),"

which I think should be:

b39f35ebe86d ("md: don't quiesce in mddev_suspend()")

where is this other sha from?

-- 
Jens Axboe

