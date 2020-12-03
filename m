Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BCB78C433FE
	for <linux-raid@archiver.kernel.org>; Thu,  3 Dec 2020 20:09:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6ED80207B8
	for <linux-raid@archiver.kernel.org>; Thu,  3 Dec 2020 20:09:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729608AbgLCUJB (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 3 Dec 2020 15:09:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725885AbgLCUJA (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 3 Dec 2020 15:09:00 -0500
Received: from mail-qv1-xf42.google.com (mail-qv1-xf42.google.com [IPv6:2607:f8b0:4864:20::f42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 721E2C061A4F;
        Thu,  3 Dec 2020 12:08:14 -0800 (PST)
Received: by mail-qv1-xf42.google.com with SMTP id n9so1628143qvp.5;
        Thu, 03 Dec 2020 12:08:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=E84Y9Y3bd1KIA8HHEQMxy31r/xw7wqJxEtjP5gzLCWs=;
        b=o0Zqiom/gQllfUU+pJFLXX2Ce1RWHWCKYOJll80tUARIQ/LU/P4YRa+nYFAA0I2b3M
         stBVnVr9h9iCIG+11IgAWrIztEos2BAGqJdDPnaCfo36n0nw8Qj2OPang7WU/J07FfZJ
         6f14DVf9rVH+N0RmQFWZOgapOLb12GsSw9Fg5S4asS9QgZRaRtlg6CWJn7BI70PBg/MM
         t180PWa2ieeIFxxq692lFtTHeE3NvelWXJC7jcxGt5ifpgeMUrUalYb6hB7tUj1GY9lU
         tgcsqI+cGtX6nMV/npa5kojOXhefPTRYUQ+hswagrYlGbbWF8oFve5wsLottnIZUocv+
         E5Og==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=E84Y9Y3bd1KIA8HHEQMxy31r/xw7wqJxEtjP5gzLCWs=;
        b=MKT9Ixd//IDsiFoM8cp1gnbOE1Oi+xPec2CAtsDv/f2xbpUyf1Jr/iBdhxgEjlpDTa
         KlO5IwGl50eAeCcmdV1XWktBk0JJbgsNb6/+ZAEzIW61fhO/vn8JsaTPD3PZWTJW3wdA
         7+eDAJoviKsNzcnFo5fK1P1MP802Gct6tNBKw4eYWZlzFiuEwbdlA2qa+b/4IxW4q5Yp
         hLTET0e/8kKWChKVHgWu6C331EGMiw4YEPO86fmnHJmwSqeGrakBnCqmtJ6KLHry8aI7
         zjIzsc/sFxq+2ZZxBdOA04WjIUyHAlaifShVj9iMFbTJui9wi+56p1RtEZ918u354LIT
         Ao1A==
X-Gm-Message-State: AOAM531uAX5iKRNrz9NUMSxRrd9ZpjRHZpe2fMBAo0kmFuTn1YWMkZXi
        QJATbqycEnQ950v/psrOGfd2Fyb0fyGbGA==
X-Google-Smtp-Source: ABdhPJz2hKm+lDGvYgkLs4zZstumCaJyp1ncEaTsz5fZ/q5sogUAJL5+G1fZy7sdgZxiWwMHQjG2vg==
X-Received: by 2002:a0c:9121:: with SMTP id q30mr841418qvq.17.1607026093641;
        Thu, 03 Dec 2020 12:08:13 -0800 (PST)
Received: from localhost ([2620:10d:c091:480::1:6aeb])
        by smtp.gmail.com with ESMTPSA id b14sm2407880qti.97.2020.12.03.12.08.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Dec 2020 12:08:12 -0800 (PST)
Sender: Tejun Heo <htejun@gmail.com>
Date:   Thu, 3 Dec 2020 15:07:45 -0500
From:   Tejun Heo <tj@kernel.org>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Jens Axboe <axboe@kernel.dk>, dm-devel@redhat.com,
        linux-block@vger.kernel.org, linux-raid@vger.kernel.org,
        linux-s390@vger.kernel.org, Damien Le Moal <damien.lemoal@wdc.com>,
        Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 4/5] block: remove the request_queue argument to the
 block_bio_remap tracepoint
Message-ID: <X8lFkSc2nZtbfibs@mtj.duckdns.org>
References: <20201203162139.2110977-1-hch@lst.de>
 <20201203162139.2110977-5-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201203162139.2110977-5-hch@lst.de>
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Thu, Dec 03, 2020 at 05:21:38PM +0100, Christoph Hellwig wrote:
> The request_queue can trivially be derived from the bio.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Damien Le Moal <damien.lemoal@wdc.com>
> Reviewed-by: Hannes Reinecke <hare@suse.de>

Acked-by: Tejun Heo <tj@kernel.org>

-- 
tejun
