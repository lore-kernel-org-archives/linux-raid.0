Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F496C433E0
	for <linux-raid@archiver.kernel.org>; Wed,  3 Feb 2021 15:47:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BD97E64D9E
	for <linux-raid@archiver.kernel.org>; Wed,  3 Feb 2021 15:47:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234669AbhBCPrv (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 3 Feb 2021 10:47:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234560AbhBCPrf (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 3 Feb 2021 10:47:35 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F976C0613D6
        for <linux-raid@vger.kernel.org>; Wed,  3 Feb 2021 07:46:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=XIQ+IMgyf2D1CPprEnSpqa/hveSNRXX9cRrci9Tbtlc=; b=r3gb5WG4kWe1yJ5a48qVy3QKU1
        fzdj20FvnNRX9aasZ3k+mdQnOM+35phcP6qsb87h8ovGzDl9AzXFTdsDQsurZh51IGMC55K0aSwyz
        xTHHWv9B0eZc1tHJUO+VBKPXTxFLYPNLt99t9uTKVWNTT7UgZ0b/n8HXO0hnBHVtsrEFM414L7pPF
        YLaNZ7WAhRGDznv3uxQM7mky9TD9PIi7YNOlVm2Rh46e2g0UShA4KUZrnoSpd0rekcCTYjAGH1Dub
        X2P6f806Y7eIMT8dqvCq8hXlAS2L3ikS+yF7ze54tzURXwibnJ7aGvYgPr4n6d/iUTDYdxDcXWhG4
        t/qh825Q==;
Received: from hch by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1l7KMi-00H7Uh-Oo; Wed, 03 Feb 2021 15:46:49 +0000
Date:   Wed, 3 Feb 2021 15:46:48 +0000
From:   Christoph Hellwig <hch@infradead.org>
To:     Xiao Ni <xni@redhat.com>
Cc:     songliubraving@fb.com, linux-raid@vger.kernel.org,
        matthew.ruffell@canonical.com, colyli@suse.de,
        guoqing.jiang@cloud.ionos.com, ncroxon@redhat.com
Subject: Re: [PATCH 3/5] md/raid10: pull codes that wait for blocked dev into
 one function
Message-ID: <20210203154648.GC4078626@infradead.org>
References: <1612359931-24209-1-git-send-email-xni@redhat.com>
 <1612359931-24209-4-git-send-email-xni@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1612359931-24209-4-git-send-email-xni@redhat.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

s/codes/the code/

> +			/* Discard request doesn't care the write result
> +			 * so it doesn't need to wait blocked disk here.
> +			 */

The normal kernel comment style would be:

			/*
			 * Discard request doesn't care the write result so it
			 * doesn't need to wait for the blocked disk here.
			 */
