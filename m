Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73C31C433FE
	for <linux-raid@archiver.kernel.org>; Thu,  3 Dec 2020 20:06:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2A83C20769
	for <linux-raid@archiver.kernel.org>; Thu,  3 Dec 2020 20:06:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726667AbgLCUGf (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 3 Dec 2020 15:06:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726004AbgLCUGf (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 3 Dec 2020 15:06:35 -0500
Received: from mail-qk1-x743.google.com (mail-qk1-x743.google.com [IPv6:2607:f8b0:4864:20::743])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13170C061A4E;
        Thu,  3 Dec 2020 12:05:55 -0800 (PST)
Received: by mail-qk1-x743.google.com with SMTP id y197so3340858qkb.7;
        Thu, 03 Dec 2020 12:05:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=+Xwp3VhRjy4dts4CXxk8hmlpAha093L76/jTyD6EHAk=;
        b=VVZss6G0H5rzOsyklzgDeIvUBvH/CjAZa6EWRWnBwu9hGT9DUAZaZpxrj13Ca6PyhP
         gsrRr4lO/XNku5+Hfg+TQENKRlmEeNmIpITCLtJ/MCE2L4iC9qhG6KJOAitS9WGdBU6d
         D/nfg7d3PIhdaba38cKU1rPRoo7Tgj50Fh6YNl+l6rgqAuvzGPYlu+lmzhCTqbgAGtxe
         YQNiZ4Tpr4VFmOTCmHFEc1lmXdvHhhjLz2DcvPunjNMYW8Yc2egiKW0WazOD9YdUsFTU
         F1Z43Xx2cqo4DuzN0D3CFMCacFQJoyFDlxxqBuHw8vLVDZdR/qC3BZlJDFuq6TJbEVvh
         H9nA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=+Xwp3VhRjy4dts4CXxk8hmlpAha093L76/jTyD6EHAk=;
        b=Yq4QOkWJ5+Z4mpp1P4DlZTNp+6kZ63166L6KAfQV2+e5w2IVdK4f4DqsnEDpmnaJXH
         GpBJjceKeTSEtcZ+HYhXlKFuN6aBbhmIWP+/PeVhCWqsbTkVSplBV+RdMCCDjaW+ExRt
         TxrG5+RlupwVZna0begzX2657tWdLiukqMBpYgL/15RbJPLMGIh0keSzsJIeirfjPdiA
         /EGL8/xVbuqdnTq2EgC8wt4K2amHfZSLPOTwswx13XYlnkjxuWl6+FctnPdAMpNi/XdW
         pZyBRgFCYmQqap4TSp1gF+X+L+4kBdqu373WEeVxv/2jeLu9/NvGhGR6RRWOjcI/yHhD
         0yXg==
X-Gm-Message-State: AOAM531si9JZUr4ZXTLHvUB89ch9HU8+ubqM5g3gORiWR5rCJoiO7IHl
        JWBiZBncSmIEIhY97gBkrdBpCvvDoGt4LA==
X-Google-Smtp-Source: ABdhPJyKWN8EbN+Fnpp9ND+gTwSHvi7g7TVFpx7X/cBJ+f7FEf6dro8hCIRKfyjys3wu1ToCKUnFxw==
X-Received: by 2002:a05:620a:6c7:: with SMTP id 7mr4693278qky.411.1607025954158;
        Thu, 03 Dec 2020 12:05:54 -0800 (PST)
Received: from localhost ([2620:10d:c091:480::1:6aeb])
        by smtp.gmail.com with ESMTPSA id o21sm2801606qko.9.2020.12.03.12.05.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Dec 2020 12:05:53 -0800 (PST)
Sender: Tejun Heo <htejun@gmail.com>
Date:   Thu, 3 Dec 2020 15:05:25 -0500
From:   Tejun Heo <tj@kernel.org>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Jens Axboe <axboe@kernel.dk>, dm-devel@redhat.com,
        linux-block@vger.kernel.org, linux-raid@vger.kernel.org,
        linux-s390@vger.kernel.org, Damien Le Moal <damien.lemoal@wdc.com>,
        Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 2/5] block: simplify and extend the block_bio_merge
 tracepoint class
Message-ID: <X8lFBVLizDnCrteh@mtj.duckdns.org>
References: <20201203162139.2110977-1-hch@lst.de>
 <20201203162139.2110977-3-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201203162139.2110977-3-hch@lst.de>
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Thu, Dec 03, 2020 at 05:21:36PM +0100, Christoph Hellwig wrote:
> The block_bio_merge tracepoint class can be reused for most bio-based
> tracepoints.  For that it just needs to lose the superfluous q and rq
> parameters.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Damien Le Moal <damien.lemoal@wdc.com>
> Reviewed-by: Hannes Reinecke <hare@suse.de>

Acked-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun
