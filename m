Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD2DDC07E94
	for <linux-raid@archiver.kernel.org>; Fri,  4 Jun 2021 07:44:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8D091613BF
	for <linux-raid@archiver.kernel.org>; Fri,  4 Jun 2021 07:44:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229962AbhFDHqK (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 4 Jun 2021 03:46:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229958AbhFDHqK (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 4 Jun 2021 03:46:10 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 672DCC06174A
        for <linux-raid@vger.kernel.org>; Fri,  4 Jun 2021 00:44:10 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id z3-20020a17090a3983b029016bc232e40bso1976000pjb.4
        for <linux-raid@vger.kernel.org>; Fri, 04 Jun 2021 00:44:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=fWI/3JObYUNnU/UVR5GuSRXP3Mz+84//Tu7iVPjnqfE=;
        b=olvbH6CjRZUQZ3aWMwHv2iDggVf0BJYjqi4cBMF5E3WIRRcofG+p5DrXDP2NcHVt1b
         1DcwS5zsyDwGu3aB6DUWBB6Ig3g794Th6Hcc+uRL9xbv3nSbfhSRQrCL/BDwSpMbw228
         ZkZgSJR4j9q+vRmL5vI2usdlWL6gwpsspSyxoe0xo2xgH57/k2r8lyjNXM4U11fE7Dkp
         pkJ0UTuP/bg9pbT7zKWgSj3x82Bb9ucLaQCXVspm1qUgm/iETY5L+2DSAv3xbvjAr5CQ
         mwHgpOcswOSm+3NFppRiNRP9n6TH2kg8XMrHl1lN+WId9x/o1c2iwkyF29kZS6ryBAmR
         CA2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=fWI/3JObYUNnU/UVR5GuSRXP3Mz+84//Tu7iVPjnqfE=;
        b=g1yDWkMMINls9l1PIa1U9rwEKAXOVHLPeoGiJ9rBGCRkDy8XbbIqgZaDd2ZEdbBSL9
         kmQjydL2Xniwv7V72GQ6WAMIOf6dBS/37Zv00a0m27ylPWHP4Lq5FeBKWuJ0cKLHrjLL
         ril/X0o/4TUEmDk94RxHTyjm2d1kH0gkwxaLwZEVzzRXC2T3WjzVwU9CdEgssK4KuRMz
         guAUetA5reffbl0+0n4bJL5g3iLITOltLR+jg2emyTJm6a33g2jVoEBowUUYhuREjXC4
         HOwAi4mgAT29gHG11nSVArMvDYBV/VweB4TlRxaHoom6fLMtN9oJ8xuGZvUVboCJs4uh
         7umQ==
X-Gm-Message-State: AOAM532aRGih1zoy0yaz4PL1a7j/gQdMA7jOVpN1p3oKceAUNjrOENPc
        As8rrzLLKUD2YE+w55j1MFFJHyxj4PI=
X-Google-Smtp-Source: ABdhPJxcGlcYOS+3+suDgnoVRCb6KlsH11ZV1xeHDYEYJQqe4CilAU8hSg+fUi0P5qFaOzRj1k6+nQ==
X-Received: by 2002:a17:90b:1bc3:: with SMTP id oa3mr15234959pjb.63.1622792649124;
        Fri, 04 Jun 2021 00:44:09 -0700 (PDT)
Received: from [10.6.1.93] ([196.245.9.44])
        by smtp.gmail.com with ESMTPSA id d24sm3891251pjv.49.2021.06.04.00.44.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 04 Jun 2021 00:44:08 -0700 (PDT)
Subject: Re: [PATCH] md/raid5: reduce lock contention in read_one_chunk()
To:     gal.ofri@storing.io, linux-raid@vger.kernel.org
Cc:     Song Liu <song@kernel.org>, Neil Brown <neilb@suse.de>
References: <20210603135425.152570-1-gal.ofri@storing.io>
From:   Guoqing Jiang <jgq516@gmail.com>
Message-ID: <2a5d0251-bfa5-4ea5-084d-23bbe52104ac@gmail.com>
Date:   Fri, 4 Jun 2021 15:43:48 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210603135425.152570-1-gal.ofri@storing.io>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



On 6/3/21 9:54 PM, gal.ofri@storing.io wrote:
> Each setup with raid6 (6+2) with group_thread_cnt=8, 1024 io threads on a
> 96 cpu-cores (48 per socket) system.

Just curious '8'  is chose for  group_thread_cnt. IIUC, group means one 
numa node, and better to
set it  to match the number of cores in one numa node in case better 
performance is expected.

Thanks,
Guoqing
