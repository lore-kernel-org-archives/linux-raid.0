Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B969C04FDF
	for <linux-raid@archiver.kernel.org>; Mon, 24 Jul 2023 10:13:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230096AbjGXKNo (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 24 Jul 2023 06:13:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233439AbjGXKNV (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 24 Jul 2023 06:13:21 -0400
Received: from mail-oi1-x22a.google.com (mail-oi1-x22a.google.com [IPv6:2607:f8b0:4864:20::22a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4DD12708
        for <linux-raid@vger.kernel.org>; Mon, 24 Jul 2023 03:05:43 -0700 (PDT)
Received: by mail-oi1-x22a.google.com with SMTP id 5614622812f47-3a3ee866e00so390809b6e.0
        for <linux-raid@vger.kernel.org>; Mon, 24 Jul 2023 03:05:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1690193136; x=1690797936;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=am2eIoStEhYj6reS+R983QZxh6h3W0xYr71gNNToCQ8=;
        b=gEtgl7u5oPw5Q7cQdrd73xQVfN55yN4jteofr/JvG43Hu+rkwtqBBWdATX3LPcvJ1Z
         lFSVf44/difzx9aJ65HihvsaFeNGw7KT7HDLNmV4d3w7qfTnI1v4CICgCIedXB4Y+WJb
         n4skdN7hPd94hj/5tdvPchz1s3FKFMmpYinPJ1vjNgaaxXd1dw9+8mreQJsT6RWGO3qJ
         isgNE08UYfFpa8Mchsqvszc/4PKu2sqsyo3jA/0amezjMM4oiY0VYdaucCmtostM7djq
         OyDz8WV2kS8KNPR6bxxpKPiJHb/tA5WWyDrmuTX2WpiiWxxCyF80oPxumy3HCMVKxCvt
         0meg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690193136; x=1690797936;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=am2eIoStEhYj6reS+R983QZxh6h3W0xYr71gNNToCQ8=;
        b=LGjkoocknljBWwEpe6uoZ5fdI+QQzvTOg8scF2LgdeTZUlFEFE63qFSedg9QvkhAaQ
         4wHjL1cht+HgYWpTT3LAsZZk7GxpEZ0AY6rbffFiWHqQrK6tpalPTsFfBQgZGBVnfhgM
         GG4EA6uYdJel+Hilyb5MwZVWV0MM5lF5MZHq/4qbPcxsphXIMmaWlxPHuXMlamJs/BpO
         gTy8CHsae5LzrmJvlDIjfx8bkDDf9F0VH8AR19asIbggsdFwMpISEowmHZf0aRpH0nY2
         5xsP/OVH76LF3gbNBqaQeab7UUJrQELRcecDtNHHq5Fms4OA9yemxWg6Q7OzES6YdUcA
         hxIQ==
X-Gm-Message-State: ABy/qLZtTvQYDrSg+wovSt0BJzYaXYVpOOe1hyRDL/YK8BtqF73o7WBl
        J/E30o8/IXNb0NtB6TeRUSw36jIKzegQ8dx+t+0=
X-Google-Smtp-Source: APBJJlEtnCzvJ6I1rkWEELadVXHfZtUE/plpWIuGp/MFKpOvTS509ssN84iHDxA1POdeL3+D21rKQg==
X-Received: by 2002:a05:6a20:8e04:b0:137:3941:17b3 with SMTP id y4-20020a056a208e0400b00137394117b3mr14532126pzj.6.1690192601020;
        Mon, 24 Jul 2023 02:56:41 -0700 (PDT)
Received: from [10.70.252.135] ([203.208.167.147])
        by smtp.gmail.com with ESMTPSA id y1-20020aa78541000000b00682aac1e2b8sm7356787pfn.60.2023.07.24.02.56.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 Jul 2023 02:56:40 -0700 (PDT)
Message-ID: <7b4eb3fa-1ebd-de07-1a16-9533b069a66e@bytedance.com>
Date:   Mon, 24 Jul 2023 17:56:27 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.12.0
Subject: Re: [PATCH v2 05/47] binder: dynamically allocate the android-binder
 shrinker
Content-Language: en-US
To:     akpm@linux-foundation.org, david@fromorbit.com, tkhai@ya.ru,
        vbabka@suse.cz, roman.gushchin@linux.dev, djwong@kernel.org,
        brauner@kernel.org, paulmck@kernel.org, tytso@mit.edu,
        steven.price@arm.com, cel@kernel.org, senozhatsky@chromium.org,
        yujie.liu@intel.com, gregkh@linuxfoundation.org,
        muchun.song@linux.dev
Cc:     linux-kernel@vger.kernel.org, linux-mm@kvack.org, x86@kernel.org,
        kvm@vger.kernel.org, xen-devel@lists.xenproject.org,
        linux-erofs@lists.ozlabs.org,
        linux-f2fs-devel@lists.sourceforge.net, cluster-devel@redhat.com,
        linux-nfs@vger.kernel.org, linux-mtd@lists.infradead.org,
        rcu@vger.kernel.org, netdev@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linux-arm-msm@vger.kernel.org,
        dm-devel@redhat.com, linux-raid@vger.kernel.org,
        linux-bcache@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-xfs@vger.kernel.org, linux-btrfs@vger.kernel.org
References: <20230724094354.90817-1-zhengqi.arch@bytedance.com>
 <20230724094354.90817-6-zhengqi.arch@bytedance.com>
From:   Qi Zheng <zhengqi.arch@bytedance.com>
In-Reply-To: <20230724094354.90817-6-zhengqi.arch@bytedance.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org


This patch depends on the patch: 
https://lore.kernel.org/lkml/20230625154937.64316-1-qi.zheng@linux.dev/

