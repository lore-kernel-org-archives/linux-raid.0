Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61D1AC19425
	for <linux-raid@archiver.kernel.org>; Thu,  3 Dec 2020 20:07:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D8D5222211
	for <linux-raid@archiver.kernel.org>; Thu,  3 Dec 2020 20:07:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727997AbgLCUHZ (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 3 Dec 2020 15:07:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725885AbgLCUHZ (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 3 Dec 2020 15:07:25 -0500
Received: from mail-qv1-xf42.google.com (mail-qv1-xf42.google.com [IPv6:2607:f8b0:4864:20::f42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73E60C061A4E;
        Thu,  3 Dec 2020 12:06:44 -0800 (PST)
Received: by mail-qv1-xf42.google.com with SMTP id q7so1605747qvt.12;
        Thu, 03 Dec 2020 12:06:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=TeMeD5rdK34kbYGDr2vSjgHIjgXKs5834n/PsXhZAI0=;
        b=e8+89f28u1oqhEC9S0njZ3DlrGyTZSg6QtZ7kms8/5VXho1IL63qZaWvPdmKEZZIex
         y+y4qPjDfBOH5aG9rVyY8Wb42bc+1UoN2XVcZARJaz1Nt+BwmWcTkAuqCVeqUnu7UDdP
         bgZJ5/G2z1YUi6Sxosy+FZYtOlaImL5lI2d65gOuWnZVd7OMisMLDFmq4TzhcPC50otI
         YTWeCa8ozHF99Tj++/aPTEenjjoPk0oA1mDT+Wf82UNYNbNCrp8ROets2I8/AZrLTnF1
         TjhjmmMbGHjWX1nCYrdvc37hu1gnRWvMqiyBFeGc0DPeJdqAXojyqVuXOkR7lUyeghj2
         zgBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=TeMeD5rdK34kbYGDr2vSjgHIjgXKs5834n/PsXhZAI0=;
        b=M8S7teLKwf1ojYkHBKJyfswyglbV2QNssszf0m0WfMcmwyxvjDOhtmbIHEmUFF0qJo
         KcbaiaNePwxqB96iOHM68g/WHF+4BFuQSM41cWEVwHgBtESOFTZK9ZkFLaJ2koiWX65K
         RMa55Qmp0VY3PhRPKpipcotKtTxi2UVDfqIc0fGTwGlCGrYf8L2h48Gsp28hUuUt/8QZ
         C7dgIHPTpHo2vmhTJjajoyoI1XlLalEM1zUTOuWZ9/NO12mJD3FoxeaAxVh/m2aTzo7f
         D+vQqHpSeD2CgNY4VZKkmTjwVVKMO71vBcYTv1FL3BFeqim5Xcpob/VbeJi/kU7F+6gF
         T6LA==
X-Gm-Message-State: AOAM533VUPBVl4hzVd+BeG0YboWqEjqovt8cAn4vkeWFDfvmYbYwaT6U
        dvBu5ht7DViYzDgjonA+5cY=
X-Google-Smtp-Source: ABdhPJzdhBAvFjybZDFPWDvdm5XjZfh9aZCIfGATPe6fEcgPcDTiUY/TMes6fNsYkOvFlBs3V9wsBw==
X-Received: by 2002:a05:6214:17c1:: with SMTP id cu1mr749690qvb.32.1607026003661;
        Thu, 03 Dec 2020 12:06:43 -0800 (PST)
Received: from localhost ([2620:10d:c091:480::1:6aeb])
        by smtp.gmail.com with ESMTPSA id v4sm2556106qth.16.2020.12.03.12.06.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Dec 2020 12:06:42 -0800 (PST)
Sender: Tejun Heo <htejun@gmail.com>
Date:   Thu, 3 Dec 2020 15:06:15 -0500
From:   Tejun Heo <tj@kernel.org>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Jens Axboe <axboe@kernel.dk>, dm-devel@redhat.com,
        linux-block@vger.kernel.org, linux-raid@vger.kernel.org,
        linux-s390@vger.kernel.org, Damien Le Moal <damien.lemoal@wdc.com>,
        Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 3/5] block: remove the request_queue argument to the
 block_split tracepoint
Message-ID: <X8lFN2rjkPZ0OF+e@mtj.duckdns.org>
References: <20201203162139.2110977-1-hch@lst.de>
 <20201203162139.2110977-4-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201203162139.2110977-4-hch@lst.de>
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Thu, Dec 03, 2020 at 05:21:37PM +0100, Christoph Hellwig wrote:
> The request_queue can trivially be derived from the bio.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Damien Le Moal <damien.lemoal@wdc.com>
> Reviewed-by: Hannes Reinecke <hare@suse.de>

Acked-by: Tejun Heo <tj@kernel.org>

-- 
tejun
