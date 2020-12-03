Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA269C433FE
	for <linux-raid@archiver.kernel.org>; Thu,  3 Dec 2020 19:46:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8B496221F4
	for <linux-raid@archiver.kernel.org>; Thu,  3 Dec 2020 19:46:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726681AbgLCTqR (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 3 Dec 2020 14:46:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725987AbgLCTqR (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 3 Dec 2020 14:46:17 -0500
Received: from mail-qv1-xf41.google.com (mail-qv1-xf41.google.com [IPv6:2607:f8b0:4864:20::f41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5048DC061A4E;
        Thu,  3 Dec 2020 11:45:31 -0800 (PST)
Received: by mail-qv1-xf41.google.com with SMTP id 62so1568186qva.11;
        Thu, 03 Dec 2020 11:45:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ehh149i/IiSP0EMQTmZOg7uX3bioxkynO8akD/sHgj8=;
        b=CmLPn6KmoU33TvoLljS2Ptl8gE/IBx2ifRyDnnmlIwRxpmI7u1T6lTVKjq1utJfD9E
         6hPkw1jh4Ej84puF3aKMpM85/NWTbOeNvr6EUu3jxlEY1LczoxoKnLRCxmy8JxPyqqZU
         IwmtnN4H2xP2GyYViKR6FqMGeTB+pgnZlTbY/KFbpVe6e0TbkTpZBiENWy4uqUueKFbK
         Kn3+wP17yizUe0J+ei6+zURASDsnjOtdQpXw01AVypmnWNEXLOL91RekN0AKEzwkCo5M
         CiOJV34WipxPejam62iA3SowjGKd3VwiXItbYG/9xJUkyxvBKOLJxPH/anS9DGLWYk8O
         ATCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=ehh149i/IiSP0EMQTmZOg7uX3bioxkynO8akD/sHgj8=;
        b=q5avyALLJt4j/mNrr4SvIhiAUQbIAgnLzpQcRSyF4wKcN9xHyEHQp5d880CHjYx8lo
         JKl0xgPcpLz+wq4PDANg41bna4b5/OKau1cU4raZ5acBVNz1L4NaNV490ZvyXgiCcyNh
         /KIlu8zLjWPJPqFMQqtHzQPeJA+yiAwHu4PmnUSuGxyQwpzhNvTCilOv6kBnFfduaoi9
         zeqQRQFFlkGpOlGKvr0qkuWZHvOHdprftDJmhO5Tvcv53/a5p3uAGxn/VJ+4xy0dRuES
         bS0vfdbk2U6GRTr6LyHBFQLTVJM/njxtipSkXJ8kwdU7/Ddb/3luGDI7dtakwtfZcNzb
         1qTQ==
X-Gm-Message-State: AOAM532N2yxKhndICqp8pVVKg6c4RpuMWQcCawnmVhHYzaMkOLU+uy8E
        AwMZJLcwEUC42qFapahx5kI=
X-Google-Smtp-Source: ABdhPJyqNbQdpf8vfSyIW2twgYfE2j/5PIsFbMCutpC4UJ5dQcGXqBdFTLKHA+kJQ681qsA75i7wBg==
X-Received: by 2002:a0c:aed4:: with SMTP id n20mr645079qvd.16.1607024730368;
        Thu, 03 Dec 2020 11:45:30 -0800 (PST)
Received: from localhost ([2620:10d:c091:480::1:6aeb])
        by smtp.gmail.com with ESMTPSA id z81sm2152679qkb.116.2020.12.03.11.45.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Dec 2020 11:45:29 -0800 (PST)
Sender: Tejun Heo <htejun@gmail.com>
Date:   Thu, 3 Dec 2020 14:45:02 -0500
From:   Tejun Heo <tj@kernel.org>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Jens Axboe <axboe@kernel.dk>, dm-devel@redhat.com,
        linux-block@vger.kernel.org, linux-raid@vger.kernel.org,
        linux-s390@vger.kernel.org, Damien Le Moal <damien.lemoal@wdc.com>,
        Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 1/5] block: remove the unused block_sleeprq tracepoint
Message-ID: <X8lAPgNyC8Aldfrn@mtj.duckdns.org>
References: <20201203162139.2110977-1-hch@lst.de>
 <20201203162139.2110977-2-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201203162139.2110977-2-hch@lst.de>
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Thu, Dec 03, 2020 at 05:21:35PM +0100, Christoph Hellwig wrote:
> The block_sleeprq tracepoint was only used by the legacy request code.
> Remove it now that the legacy request code is gone.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Damien Le Moal <damien.lemoal@wdc.com>
> Reviewed-by: Hannes Reinecke <hare@suse.de>

Acked-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun
