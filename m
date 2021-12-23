Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2320C433F5
	for <linux-raid@archiver.kernel.org>; Thu, 23 Dec 2021 08:36:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347225AbhLWIgu (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 23 Dec 2021 03:36:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229785AbhLWIgt (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 23 Dec 2021 03:36:49 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEB5CC061401
        for <linux-raid@vger.kernel.org>; Thu, 23 Dec 2021 00:36:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=lTHHw8atq4TsJ5ry3sWuOs+E7gq2hPgb15TtZdm8vjo=; b=i0Ys4ZVt1FIZQR6KeOcBgRHvnY
        PEcoNQJlFD8O8mpq8FM9U6EQWJC12aE/pHJD4kqSF0oTUHBblB1ByrFHloxuSMaKeTg4iS2fEBCLE
        ymjzOfR7Myg8+GcZR/+RG2uD7Gp4sp0yDfH6Za/PMDCvrIGtlH/wdnOZzq/AohlqpjZ/cHQUhSMrk
        EGFFK//jO5rEtKN3uc+xJgGFmOZSRcJgoXQpk4nVmzu8ih1O1EKeKNfR4ugsmvZ/9M7WKsiAWUbWQ
        3kE/fKoHOOIP0PuyYrE8fbmA9hN9Wa2274I0+T9Dg7Vjto8NAoguq7D0jJvPfm/M4z58pbljhZFPQ
        g/Q4mARg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1n0Jah-00CIG7-C6; Thu, 23 Dec 2021 08:36:47 +0000
Date:   Thu, 23 Dec 2021 00:36:47 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     Vishal Verma <vverma@digitalocean.com>
Cc:     song@kernel.org, linux-raid@vger.kernel.org, axboe@kernel.dk,
        rgoldwyn@suse.de
Subject: Re: [PATCH v6 1/4] md: add support for REQ_NOWAIT
Message-ID: <YcQ1H6fvY6lEELxW@infradead.org>
References: <f5b0b47f-cf0b-f74a-b8b6-80aeaa9b400d@digitalocean.com>
 <20211221200622.29795-1-vverma@digitalocean.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211221200622.29795-1-vverma@digitalocean.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Please post the new series in a new thread.
