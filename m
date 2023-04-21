Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F092C7618E
	for <linux-raid@archiver.kernel.org>; Fri, 21 Apr 2023 06:58:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230338AbjDUG6F (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 21 Apr 2023 02:58:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230236AbjDUG6D (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 21 Apr 2023 02:58:03 -0400
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C102A7DA2
        for <linux-raid@vger.kernel.org>; Thu, 20 Apr 2023 23:57:56 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id d2e1a72fcca58-63b73203e0aso12292132b3a.1
        for <linux-raid@vger.kernel.org>; Thu, 20 Apr 2023 23:57:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1682060276; x=1684652276;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=iCQQOrDHvv7muofgTvhggno9gmpvYe5WVwBD+zXre78=;
        b=hbF+Bk8ojjiZO6o2ok3vxf1WbShiuo5T081GBEE0UAfUBksGieFJSgkGacjYqBeK8w
         zt8XcYoWlevrCYjZed9y77ALfx/FxTMIwIwFlhupB/WwZM1Z1umn0C+QVKNQOjZ4t1v4
         rUbAMrVRBbyd04gOqF9r0veBQA2+tqYWKmYcY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682060276; x=1684652276;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iCQQOrDHvv7muofgTvhggno9gmpvYe5WVwBD+zXre78=;
        b=SYtsMWotFiMmx5weo+jLfP8ADLY+dlzNKoNv2WDYTnTHsho/ZZJs/VneIkdrwX0xJH
         DzkosUABwQM5IZBL4TWGhVqT5PpvanCqLzhUR/ys30p+0IRGhRAEG132ZjXX3ksblJoy
         0bQjJaGKZeG8q7xjJERfiWCTpRFqdK0yS9dyA1ZKW2Gtcu+RP61QD0h4qaFBSuTtl5qo
         ZpN1xm/d9nRoHHZFUZyJ1zGs5ouIN/vtqw/fvkL8Fgr45ie4X+Dy+7t8b4v7nhow3sAg
         eHNpf4BuFK80TDlR0u5HLyh42h545/bc2Cvb1JGKMclU1ChdNqk7HuBTs8zs/SEG9g2U
         jBhg==
X-Gm-Message-State: AAQBX9fsuIMuPmaxvxRMcy4RHWxQtBMtTDrWa2jEc2fyFsSPbRmYEbc7
        DkWI5g6vQbbaJuZUQt+AXJzmPg==
X-Google-Smtp-Source: AKy350ZEEP/PrU7kYgyyZkKivdaMPHUVf5WGz+Wiu1WQ8mlkUVfjfkCNB7ZnxyH4DOCp4JsT1PbWNg==
X-Received: by 2002:aa7:8554:0:b0:63d:40bb:a88b with SMTP id y20-20020aa78554000000b0063d40bba88bmr8194787pfn.14.1682060275718;
        Thu, 20 Apr 2023 23:57:55 -0700 (PDT)
Received: from google.com (KD124209188001.ppp-bb.dion.ne.jp. [124.209.188.1])
        by smtp.gmail.com with ESMTPSA id 136-20020a63008e000000b0051806da5cd6sm2038374pga.60.2023.04.20.23.57.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Apr 2023 23:57:54 -0700 (PDT)
Date:   Fri, 21 Apr 2023 15:57:47 +0900
From:   Sergey Senozhatsky <senozhatsky@chromium.org>
To:     Johannes Thumshirn <jth@kernel.org>
Cc:     axboe@kernel.dk, johannes.thumshirn@wdc.com, agruenba@redhat.com,
        cluster-devel@redhat.com, damien.lemoal@wdc.com,
        dm-devel@redhat.com, dsterba@suse.com, hare@suse.de, hch@lst.de,
        jfs-discussion@lists.sourceforge.net, kch@nvidia.com,
        linux-block@vger.kernel.org, linux-btrfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
        linux-raid@vger.kernel.org, ming.lei@redhat.com,
        rpeterso@redhat.com, shaggy@kernel.org, snitzer@kernel.org,
        song@kernel.org, willy@infradead.org,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Minchan Kim <minchan@kernel.org>
Subject: Re: [PATCH v4 13/22] zram: use __bio_add_page for adding single page
 to bio
Message-ID: <20230421065747.GB1496740@google.com>
References: <20230420100501.32981-1-jth@kernel.org>
 <20230420100501.32981-14-jth@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230420100501.32981-14-jth@kernel.org>
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

+ Minchan

On (23/04/20 12:04), Johannes Thumshirn wrote:
> 
> From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
> 
> The zram writeback code uses bio_add_page() to add a page to a newly
> created bio. bio_add_page() can fail, but the return value is never
> checked.
> 
> Use __bio_add_page() as adding a single page to a newly created bio is
> guaranteed to succeed.
> 
> This brings us a step closer to marking bio_add_page() as __must_check.
> 
> Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
> Reviewed-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>

Reviewed-by: Sergey Senozhatsky <senozhatsky@chromium.org>
