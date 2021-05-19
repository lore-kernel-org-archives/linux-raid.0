Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 105F4C433B4
	for <linux-raid@archiver.kernel.org>; Wed, 19 May 2021 01:30:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E2B6B61361
	for <linux-raid@archiver.kernel.org>; Wed, 19 May 2021 01:30:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232837AbhESBbo (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 18 May 2021 21:31:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231689AbhESBbl (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 18 May 2021 21:31:41 -0400
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9791AC06175F
        for <linux-raid@vger.kernel.org>; Tue, 18 May 2021 18:30:21 -0700 (PDT)
Received: by mail-pg1-x529.google.com with SMTP id i5so8326120pgm.0
        for <linux-raid@vger.kernel.org>; Tue, 18 May 2021 18:30:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=O1Fe4jUMBR17cFbpJzXKmAkc4xFFFbxb2OAuzPtoREs=;
        b=nw/iHE1L5973OT6PAgWXH3USDfhj3+ft9mRcY5R9wemsPbiCZS83dXs+knUG5sxS+5
         rpsJY1hwe2H3KPcnRIPu9Nqc+IY852+ZUDwcvPbINI1MxvYHaqes+bG+pbqP6Qwsrnfw
         pq9Frz5p02zmx0s0/YBtKEvHNludJijyAgZypBpXv+t2+RvAxEBQAu0b8vILZZ3A1pix
         yQd9L4IWlGMsSRB8U/ZwrTOSzd0B3Qd1rAMp087HQJW41JUnyCMZRZikMsgrZC8SWLP0
         cJOTR+GcO6+ucXsDv4qMivH5Karl4ZbiLMvkvTlo6rK6ybmwGREZl8WPpjd2sCOdRCxS
         p4Mw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=O1Fe4jUMBR17cFbpJzXKmAkc4xFFFbxb2OAuzPtoREs=;
        b=PbhRBeZ2esz5LARIxIKbfbW4op/C58dJRSXC1dAd7keisBiSOFA1rUbcxVgls2E3DE
         Sg2W9GP0DYNnbxWSQ9tUdBl+j4iLpmYaBlIJSr/uRssPjFVBTAf4eDL+dJpGziYXQnRM
         iLDi4Ufi9TgxqD08ibq8fhZ9EiaqxpUpu3Qa4iJDKJs4W1JFwzqtIZzO+H+EX/aOd+WP
         3tJ4BRvY9EsMPv3TjapezMpux0lqrj77kFtVKEz/Am5qE9rewmiNzcT2DO22X5wb0xZo
         J8NATHY4xWs34KSj+5kSZKzeSp9ctN8JFbe6q2nGeLt3IAx4SrMaY2Hy9QS69O1FM1v3
         RjYw==
X-Gm-Message-State: AOAM531GEOmz5veZgo9l25faBP994i/P9nwirP679dw/nKX8ba0ASnRh
        pahrFVID9c9zKoDGO98QJY0=
X-Google-Smtp-Source: ABdhPJz250zGuRYjE3AWsdmWCBpl11K7JlpgQ9vdj+POtszd9xqMfLVd2ipPAA1w62Bc8BmrRLTvlQ==
X-Received: by 2002:aa7:868e:0:b029:2ca:ea6a:71a1 with SMTP id d14-20020aa7868e0000b02902caea6a71a1mr8177973pfo.32.1621387821134;
        Tue, 18 May 2021 18:30:21 -0700 (PDT)
Received: from [10.6.3.223] ([89.187.161.155])
        by smtp.gmail.com with ESMTPSA id w8sm14459381pgf.81.2021.05.18.18.30.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 18 May 2021 18:30:20 -0700 (PDT)
Subject: Re: [PATCH 2/5] md: the latest try for improve io stats accounting
To:     Artur Paszkiewicz <artur.paszkiewicz@intel.com>, song@kernel.org
Cc:     linux-raid@vger.kernel.org, Guoqing Jiang <jiangguoqing@kylinos.cn>
References: <20210518053225.641506-1-jiangguoqing@kylinos.cn>
 <20210518053225.641506-3-jiangguoqing@kylinos.cn>
 <2887bc44-dd0b-0b24-ee97-b0a95f0c4936@intel.com>
From:   Guoqing Jiang <jgq516@gmail.com>
Message-ID: <2bfe7f2b-5b5b-634d-3996-3c4ed77e74ff@gmail.com>
Date:   Wed, 19 May 2021 09:30:03 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <2887bc44-dd0b-0b24-ee97-b0a95f0c4936@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



On 5/18/21 6:12 PM, Artur Paszkiewicz wrote:
> On 18.05.2021 07:32, Guoqing Jiang wrote:
>> +     /*
>> +      * We don't clone bio for multipath, raid1 and raid10 since we can reuse
>> +      * their clone infrastructure.
>> +      */
>> +     if (blk_queue_io_stat(bio->bi_bdev->bd_disk->queue) &&
>> +         (bio->bi_pool != &mddev->md_io_bs) &&
>> +         (mddev->level != 1) && (mddev->level != 10) &&
>> +         (mddev->level != LEVEL_MULTIPATH)) {
> Maybe add a flag to struct md_personality and check it here? Something
> that will be set only for the personalities which clone the bio
> themselves.

Good point.

> Doesn't this need to check the bio->bi_pool also against mddev->bio_set
> to skip the bios split by md? Similarly to the check against
> bio_chain_endio which you did before.

Hmm, raid0 allocates split bio from mddev->bio_set, but raid5 is
different, it splits bio from r5conf->bio_split. So either let raid5 also
splits bio from mddev->bio_set, or add an additional checking for
raid5. Thoughts?

Thanks,
Guoqing
