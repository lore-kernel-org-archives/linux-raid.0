Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6DA61C43460
	for <linux-raid@archiver.kernel.org>; Mon, 10 May 2021 06:00:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2ED9861432
	for <linux-raid@archiver.kernel.org>; Mon, 10 May 2021 06:00:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230039AbhEJGBq (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 10 May 2021 02:01:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230009AbhEJGBp (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 10 May 2021 02:01:45 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD347C061573;
        Sun,  9 May 2021 23:00:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=s5VgDRE3fntx+hoST52zTcYHXWHwJgCurEHpr1TYTlQ=; b=jBgYS/NDAOaMoAlc7Ob9bSlOQ/
        iXZ6ae+hLxfyQDJTI0yOegHx4Qgda5Kvz7hlmXDQuV9TB/LOtT8Be9rRrPYE+EY9+VzqmsvdivTIu
        GYhTuEaav8q72Cwq7vZjN6BE+4bXSxCSPdMEY+Za0LRQBoKhfoGtbWk92PBu/PhSZzaQLPPtt8I8+
        QvDRc4yYNKJIxG5uEhxq9DAyzKoN3LiECPSaFiXR7it2+MgdrfAeXNfAaW3MVrCggXHx2JeI0Nv7F
        EyKuQBoGStIdirijICyNRA8cj3pjBCXktkiCutCAZxIEbnFyDClOTNnBXQ/VCxS3l5a1YHzfcdKts
        UeEkyLoA==;
Received: from hch by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1lfyxc-005kui-ME; Mon, 10 May 2021 06:00:14 +0000
Date:   Mon, 10 May 2021 07:00:08 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Guoqing Jiang <jgq516@gmail.com>
Cc:     song@kernel.org, linux-raid@vger.kernel.org,
        linux-block@vger.kernel.org, pawel.wiejacha@rtbhouse.com,
        Guoqing Jiang <jiangguoqing@kylinos.cn>
Subject: Re: [PATCH] md: don't account io stat for split bio
Message-ID: <YJjL6AQ+mMgzmIqM@infradead.org>
References: <20210508034815.123565-1-jgq516@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210508034815.123565-1-jgq516@gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Sat, May 08, 2021 at 11:48:15AM +0800, Guoqing Jiang wrote:
> It looks like stack overflow happened for split bio, to fix this,
> let's keep split bio untouched in md_submit_bio.
> 
> As a side effect, we need to export bio_chain_endio.

Err, no.  The right answer is to not change ->bi_end_io of bios that
you do not own instead of using a horrible hack to skip accounting for
bios that have no more or less reason to be accounted than others bios.
