Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F1E0C433EF
	for <linux-raid@archiver.kernel.org>; Fri,  4 Mar 2022 20:01:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229919AbiCDUB6 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 4 Mar 2022 15:01:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229890AbiCDUBu (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 4 Mar 2022 15:01:50 -0500
Received: from mail-oo1-xc2a.google.com (mail-oo1-xc2a.google.com [IPv6:2607:f8b0:4864:20::c2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E99A9286730
        for <linux-raid@vger.kernel.org>; Fri,  4 Mar 2022 11:56:20 -0800 (PST)
Received: by mail-oo1-xc2a.google.com with SMTP id h16-20020a4a6f10000000b00320507b9ccfso10628957ooc.7
        for <linux-raid@vger.kernel.org>; Fri, 04 Mar 2022 11:56:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=cD1ZoJibPx8a6ZYW0ir6GwlMwbk0v99dWXm7GlqXJtc=;
        b=yzTBVOHnh2/lw1WEi4Ftyjn9MmKcO9GR999iIl8QDIZ8f473bfhyN+JaqsqzCf6i8+
         KfnqV8aXwP3PhTehm3xjxJL0WmXoo80zbuwPhuaD00i9czLxTl8fFoQmI6ceYGlJB3JU
         uuI51gvQCE0Q916NvdJ4VvdTe8ukIxYdkEG2gUrn7dr94mWE+WPc6+k6Xiz64DyxZFyQ
         20ui0jlVJi8XEJpnblrxChpqSRsV9XHvbxv8F7PpND2WsXtGXeL4CJtb4oszPVY8TSaR
         4nJdXt7Q1nL3y0Iy+yZTxfMtychsLFmirQVMdDLaNAuJMadAednHVU0vTGCUWqK2H2BX
         NMcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=cD1ZoJibPx8a6ZYW0ir6GwlMwbk0v99dWXm7GlqXJtc=;
        b=lMM9ur+S+7jdnEgzo+w25zgeGOB1sfaP7qY6Z0yzxDf5xufsU1aUHvQ8VnVMLu+umR
         5lTlCYsgLnU43W5T0VtEI0u0kZSeSLpx2hd11DfzOZgXxWoFdD0uQB7Oqfo8vvzKZCJJ
         vJoIEmcr2ZfIF1gtp4Qrg0hlnzjN4tye+ohVsCIP1ZClhPHTh3E22JOWPflKcceI5+Sv
         HAmW93z7yPSCHcdm8mvW6wMw2TK8XraGkDi4xaqlM6BjxZIyONGFLpud9b9ubv3mGjhg
         RbaQ3+32RTUHC0d6Xu7a4QYQioqYf8VxrfUjsQs6FPYv7P5gzufgjW1Yvrw8iD42zt5a
         qsVg==
X-Gm-Message-State: AOAM532VKyrpCAUYyqZhhQfsMgCv7+5FslnNB9fEKR4hwyRNTTCvouUT
        YNCXLFq82TprKw2wSQFsWOW7f8F43Qjefw==
X-Google-Smtp-Source: ABdhPJxaPNpPdHGtkzBqxR/AbybSNjglxB1qWnG9jsxe0tCA2gjxU9n2s98hohxcBA0drNnu+IBOcw==
X-Received: by 2002:a17:90b:3802:b0:1be:f687:7875 with SMTP id mq2-20020a17090b380200b001bef6877875mr161792pjb.109.1646421866217;
        Fri, 04 Mar 2022 11:24:26 -0800 (PST)
Received: from [192.168.1.100] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id q9-20020a056a00088900b004e03b051040sm6813168pfj.112.2022.03.04.11.24.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 04 Mar 2022 11:24:25 -0800 (PST)
Message-ID: <62cc1a9e-6259-d409-1bcb-11c760b0c691@kernel.dk>
Date:   Fri, 4 Mar 2022 12:24:24 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.1
Subject: Re: [PATCH 2/2] block: remove the per-bio/request write hint
Content-Language: en-US
To:     Christoph Hellwig <hch@lst.de>
Cc:     sagi@grimberg.me, kbusch@kernel.org, song@kernel.org,
        linux-block@vger.kernel.org, linux-raid@vger.kernel.org,
        linux-nvme@lists.infradead.org, linux-fsdevel@vger.kernel.org
References: <20220304175556.407719-1-hch@lst.de>
 <20220304175556.407719-2-hch@lst.de>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20220304175556.407719-2-hch@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 3/4/22 10:55 AM, Christoph Hellwig wrote:
> With the NVMe support for this gone, there are no consumers of these hints
> left, so remove them.

Looks good to me, didn't find any missed spots.

-- 
Jens Axboe

