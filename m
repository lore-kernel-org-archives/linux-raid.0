Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27308C433B4
	for <linux-raid@archiver.kernel.org>; Tue, 18 May 2021 13:38:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 02EE261074
	for <linux-raid@archiver.kernel.org>; Tue, 18 May 2021 13:38:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245161AbhERNje (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 18 May 2021 09:39:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239112AbhERNjd (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 18 May 2021 09:39:33 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4677C061573
        for <linux-raid@vger.kernel.org>; Tue, 18 May 2021 06:38:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=kJq3fDuW0vhs14dgZbWDfYblotf8raqjEHhw4X3znYU=; b=ZN+tR4DBCPXns6Zjx14Hm0e/oM
        szE5ZtIxGjENY0my+zS+pr1bpQF8pndgEpjlQRAOVTcuk/WVR6whjUIEr/WJKlqmQcqvWMd76fh62
        gvByA6Iu08QbooXgSExrr+/MsAyNo0h9dOyn7Z0+g19hYi3zI7B8VTEgoPXrMByZrFVsS24aLe+/h
        brAnH3I17N8iWlbLNgW3bNx8MWmTFnO1hvZ2NKwJedLhSrTxzZ5DpJs6Q1Rba+aya+uv3pl/U9PDF
        fFGTN+8PpKshsFCfpRKIcG5q7cCeJtxr6wWaDVneMGixkONN0zz9JOlZXm+Hkx1gG+JL4mgSjT0XV
        Uk/+CySA==;
Received: from hch by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1lizux-00E1Nd-Q6; Tue, 18 May 2021 13:37:57 +0000
Date:   Tue, 18 May 2021 14:37:51 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Guoqing Jiang <jgq516@gmail.com>
Cc:     song@kernel.org, linux-raid@vger.kernel.org,
        artur.paszkiewicz@intel.com,
        Guoqing Jiang <jiangguoqing@kylinos.cn>
Subject: Re: [PATCH 3/5] md-multipath: enable io accounting
Message-ID: <YKPDLwAU5WJOkLKu@infradead.org>
References: <20210518053225.641506-1-jiangguoqing@kylinos.cn>
 <20210518053225.641506-4-jiangguoqing@kylinos.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210518053225.641506-4-jiangguoqing@kylinos.cn>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Is anyone actually still using MD multipathing?  I wonder if we just
need to deprecate and eventually remove this code..
