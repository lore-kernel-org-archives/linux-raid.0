Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52672EB64DA
	for <linux-raid@archiver.kernel.org>; Wed, 12 Jul 2023 16:50:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233260AbjGLQu0 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 12 Jul 2023 12:50:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232457AbjGLQuZ (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 12 Jul 2023 12:50:25 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C6DE10C7;
        Wed, 12 Jul 2023 09:50:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=8saf6uV1XIVQipbIWGpCaD1a2vCHrR1UEMmL0zruzHc=; b=EMwk0Z3VA/RmH/RXU65HyyFpSK
        759eq9vUP+uXU6TDEJpCv+lj2WeXVLfAvX0a9hZ+MoP02iybbXgyLOij1IcwD6Ox+jFNqkD+sRJ/i
        KTeYlrxWqS0iDcwup1ydbgu7xi8Ajhz6t6tXq14yoqL0UOiA1vvpGi9bbIhtnaogN8LK6HQbe52YS
        jhhsuGmKjSbcT6hYGXXXAdZUrs6ZgMutW/V3IB9U9Br99CYqragVWLFNKyRznt4As9lhxQo45S1bZ
        Pgzcp4KsOouLXhnO1eoAjmXXXxSOEps0UP5IKvrGpuEmUWyGlhics0+n3dPziV00Wxf008KtMdpRT
        nbCMl1bA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
        id 1qJd2h-000eJe-1B;
        Wed, 12 Jul 2023 16:50:19 +0000
Date:   Wed, 12 Jul 2023 09:50:19 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Zhang Shurong <zhang_shurong@foxmail.com>
Cc:     song@kernel.org, linux-raid@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] md: fix potential OOB in multipath_remove_disk()
Message-ID: <ZK7Zy2U86znezl+a@infradead.org>
References: <tencent_E2C71605D88087940237AA9A44CC8D436D06@qq.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <tencent_E2C71605D88087940237AA9A44CC8D436D06@qq.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Thu, Jul 13, 2023 at 12:46:05AM +0800, Zhang Shurong wrote:
> If rddev->raid_disk is greater than mddev->raid_disks, there will be
> an out-of-bounds in multipath_remove_disk. We have already found
> similar reports as follows:
> 
> 1) commit d17f744e883b ("md-raid10: fix KASAN warning")
> 2) commit 1ebc2cec0b7d ("dm raid: fix KASAN warning in raid5_remove_disk")
> 
> Fix this bug by checking whether the "number" variable is
> valid.

I think it might just be time to finally dropped the deprecated md
multipath code instead..
