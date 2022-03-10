Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1DEEC433FE
	for <linux-raid@archiver.kernel.org>; Thu, 10 Mar 2022 22:15:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344357AbiCJWQm (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 10 Mar 2022 17:16:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344037AbiCJWQk (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 10 Mar 2022 17:16:40 -0500
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20F03197B78
        for <linux-raid@vger.kernel.org>; Thu, 10 Mar 2022 14:15:39 -0800 (PST)
Received: by mail-pg1-x52b.google.com with SMTP id q19so5869275pgm.6
        for <linux-raid@vger.kernel.org>; Thu, 10 Mar 2022 14:15:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=hnTFWnQJmvbm9LEtFQvI4GpVPQj/z6Hgu7d/5cJgwGU=;
        b=GRACj0SFaphKhV/+h7K0CBcgmjtW+WehxP7ZAow2XGAC4beO1q+M8D3BP4sziJ809O
         B/ttj3qNZ3hy9g10Auo2s91jwW/ms8f1uu0YPnSlDdbAO9TquV0X64CgPAybQ3cNGU44
         udwqkTPbIM28s2aAXSBTNNdbwSrF3TLDb1Pf6MprMyyq1fLT6N59YVVEZY0aNkTwE59q
         96IaDZqx7uctsRTwmrp6Q9315N+QOxiVgidlwmMDhU4vH289ShcbKdHW9ca0ywaAxmRk
         smev9fdVuuWYL033r64YsZrL7+IDC5jP9n5QPbYUI0P3LA471jThNwsAlY55FIdqnpxQ
         g9jg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=hnTFWnQJmvbm9LEtFQvI4GpVPQj/z6Hgu7d/5cJgwGU=;
        b=zncfjMtUujFotpkZm9cxwevdtXkKpWp5LXBOQ69mI4AS+c1eIplOJ+Wa2hhcoXtPpz
         K3bfaRsz4TF9DilJUQR8jPmUJMl5lESuCHJYqZdL5eIM3PjvSVOuuaddPnFJpLnDIMUZ
         Uj99HgvNUj98hd6nlZJHS7/V8CsiqTZhcMEwIBzk9FqSQQ6HUFoMg0ChQVF+nOfAjj9s
         4T8m+zW8bZ2jk8L5ggjXllyx3NkomRUYHlZ+zC2BWlNPU2ULUe7qADobuR4kDglZ9sHO
         O6mgE7gHXCFnTUsDGmDHNkGuxBY9kf3oG4ZGXdfyDaIt/m2AUhn6j1FGigo5o4opFMn4
         cjww==
X-Gm-Message-State: AOAM533FkhEOKIcl6DIlfkyIgr6KDQHvou9/PU+UTP9wSKcMocrGX+O8
        U30O/d8JB/UH83iFypPOO0TWrRzpHCluoVJ+
X-Google-Smtp-Source: ABdhPJw+pGFGO9T4EDDKaf9lZx4+G5dZFq0/F63AxN+xCER7XgP8Tywk2IfhNk0rJJLPup9XCcORyA==
X-Received: by 2002:a62:5251:0:b0:4f6:ff68:50c2 with SMTP id g78-20020a625251000000b004f6ff6850c2mr6890521pfb.63.1646950538572;
        Thu, 10 Mar 2022 14:15:38 -0800 (PST)
Received: from ?IPV6:2600:380:7676:ce7b:11ac:aee8:fe09:2807? ([2600:380:7676:ce7b:11ac:aee8:fe09:2807])
        by smtp.gmail.com with ESMTPSA id d4-20020aa78e44000000b004f6aaa184c9sm7740910pfr.71.2022.03.10.14.15.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Mar 2022 14:15:38 -0800 (PST)
Message-ID: <9516f407-bb91-093b-739d-c32bda1b5d8d@kernel.dk>
Date:   Thu, 10 Mar 2022 15:15:35 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.1
Subject: Re: [PATCH] block: check more requests for multiple_queues in
 blk_attempt_plug_merge
Content-Language: en-US
To:     Song Liu <song@kernel.org>, linux-block@vger.kernel.org,
        linux-raid@vger.kernel.org
Cc:     stable@vger.kernel.org, Larkin Lowrey <llowrey@nuclearwinter.com>,
        Wilson Jonathan <i400sjon@gmail.com>,
        Roger Heflin <rogerheflin@gmail.com>
References: <20220309064209.4169303-1-song@kernel.org>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20220309064209.4169303-1-song@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 3/8/22 11:42 PM, Song Liu wrote:
> RAID arrays check/repair operations benefit a lot from merging requests.
> If we only check the previous entry for merge attempt, many merge will be
> missed. As a result, significant regression is observed for RAID check
> and repair.
> 
> Fix this by checking more than just the previous entry when
> plug->multiple_queues == true.
> 
> This improves the check/repair speed of a 20-HDD raid6 from 19 MB/s to
> 103 MB/s.

Do the underlying disks not have an IO scheduler attached? Curious why
the merges aren't being done there, would be trivial when the list is
flushed out. Because if the perf difference is that big, then other
workloads would be suffering they are that sensitive to being within a
plug worth of IO.

Between your two approaches, I do greatly prefer the first one though.

-- 
Jens Axboe

