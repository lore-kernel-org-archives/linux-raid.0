Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51F90C4361B
	for <linux-raid@archiver.kernel.org>; Thu,  3 Dec 2020 15:39:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 088F720784
	for <linux-raid@archiver.kernel.org>; Thu,  3 Dec 2020 15:39:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731028AbgLCPji (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 3 Dec 2020 10:39:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731020AbgLCPjg (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 3 Dec 2020 10:39:36 -0500
Received: from mail-qv1-xf2f.google.com (mail-qv1-xf2f.google.com [IPv6:2607:f8b0:4864:20::f2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 708B1C061A4E;
        Thu,  3 Dec 2020 07:38:56 -0800 (PST)
Received: by mail-qv1-xf2f.google.com with SMTP id x13so1116138qvk.8;
        Thu, 03 Dec 2020 07:38:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=8iYfZK7k4LKkXHjhIpzgbWtlDMSLNvryIb4qP/617/A=;
        b=tpufTalSbO0eNIfTsDIaVnM9GvN1vOpIyW5c/FifFknghjMD702zlT7JqxfLMFSp+0
         7Kqm6Y5m0AYzDyoQonaunJfaHgLbzESQp/ST8nqIkGC6tERhtem1UHM4UBIKz+HjSvgN
         hpgcDQtxbfvYuzWwOjxqSxOncUMnf9i3DWbT7mHk7nfLkNcnCpJQi7TuuOtChXfYGuwd
         Hqn5DA/BenvcqWl0+HELqOOZ4LcMOZxJtCqd7ceUpu6wmKqK58L5GYe0GMrPc4u3jkwr
         daM8pct9z5AQ8HepKdKB/zmNIA0eSHqop8euUyiz3gqYQhqL2RWO341yAU42nWywa2UD
         95lw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=8iYfZK7k4LKkXHjhIpzgbWtlDMSLNvryIb4qP/617/A=;
        b=XiY8R0aF2e0xGVI4KKPgXmzwNYE6ws4IIRejIEllCvUnoQAvU5V2phd/D211KP8+GL
         twKkyd98bhW40pzkzRcymLu8pI4fS37kM4DBmlsw9+ioFy5msFqpcpuyEdnVUStEEEO5
         UqQNqFERvMvAv/XcI40XSHoOtn91IYnRJ4fyAWzT7whFN13yG3yNHSxCSvLEpQU5qLPG
         DE+dRmB0ViL+EUZGOwNpl/Jynlr3eEKBxs4QyEI6Bl9awoMScmFeUSeOxDSTlWA6WFtM
         55j5FcZgxnucFXO2Up++AjBadKkFjWbpbZAWKbh1ovfrS2HFaErku4tjZ9fysCj/MSV6
         jxfA==
X-Gm-Message-State: AOAM530L1Zyj5QTnNEvQ7eh6ZqwHm7YjfQLMW95sx6VPbC9gGtNyMVBc
        jeGr1ogsMF9DnfCDPua0+gY=
X-Google-Smtp-Source: ABdhPJx09aEGriwr3pY6WH0RuczKuf2fJnXuG/xMIJwR9iDX4IW9IWBXN98EBXBwIGOF+0zIbLpqjA==
X-Received: by 2002:a0c:db8c:: with SMTP id m12mr3854958qvk.11.1607009935544;
        Thu, 03 Dec 2020 07:38:55 -0800 (PST)
Received: from localhost (dhcp-6c-ae-f6-dc-d8-61.cpe.echoes.net. [72.28.8.195])
        by smtp.gmail.com with ESMTPSA id a85sm1723149qkg.3.2020.12.03.07.38.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Dec 2020 07:38:54 -0800 (PST)
Sender: Tejun Heo <htejun@gmail.com>
Date:   Thu, 3 Dec 2020 10:38:26 -0500
From:   Tejun Heo <tj@kernel.org>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Jens Axboe <axboe@kernel.dk>, dm-devel@redhat.com,
        linux-block@vger.kernel.org, linux-raid@vger.kernel.org,
        linux-s390@vger.kernel.org
Subject: Re: block tracepoint cleanups
Message-ID: <X8kGcgHvk8L22Nc+@mtj.duckdns.org>
References: <20201130175854.982460-1-hch@lst.de>
 <20201203082559.GA15521@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201203082559.GA15521@lst.de>
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Thu, Dec 03, 2020 at 09:25:59AM +0100, Christoph Hellwig wrote:
> Whom can I trick into reviewing this fairly simple series now that
> the one dependig on it got fully reviewed?

Care to resend? I'd be happy to take a look later today.

Thanks.

-- 
tejun
