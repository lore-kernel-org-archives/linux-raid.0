Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2741FC433F5
	for <linux-raid@archiver.kernel.org>; Sat,  4 Sep 2021 01:48:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F1A6C60F58
	for <linux-raid@archiver.kernel.org>; Sat,  4 Sep 2021 01:48:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351242AbhIDBtm (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 3 Sep 2021 21:49:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351023AbhIDBtm (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 3 Sep 2021 21:49:42 -0400
Received: from bombadil.infradead.org (unknown [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6BFEC061575
        for <linux-raid@vger.kernel.org>; Fri,  3 Sep 2021 18:48:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=XsVhvMCRn7dn+g9EAgEtk70EfBPNgOM0zW5Cku8atCY=; b=HYXhuN0YlTHal9OatFPBfm6fY4
        keXYMejW3YssSaFe1vbR1dmUZ11cfkywd3NkZMbbrV52azj0aHe8EdqskvYxXNCC+UtLAZSyL+t+e
        TtKPdRr1KBJcgw9azZluNlx6QETn9M9UQYsNHvyajLBGm2SUK2+IPMNMAbfS03sItMIeHWqe3EKdy
        EoRvXZTapqLBK/Qwb8Gr0eP+37ZA9toMGfm89NOFZaKQKgHU5YKr9wOdf6pKvX8Grq3fbSyw7XXh8
        h0oIs8o28Fa8PrHCjJZ3rK/b7ET0Hp6aawOWzcl65y1GPhXzfK9BhFYdvuZnQ95Qf+rKEU3PpVUvR
        Ob82xD+g==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mMKnQ-00DMd1-B0; Sat, 04 Sep 2021 01:48:40 +0000
Date:   Fri, 3 Sep 2021 18:48:40 -0700
From:   Luis Chamberlain <mcgrof@kernel.org>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Song Liu <song@kernel.org>, linux-raid@vger.kernel.org
Subject: Re: fix a lock order reversal in md_alloc
Message-ID: <YTLQeOzz+PdC5M10@bombadil.infradead.org>
References: <20210901113833.1334886-1-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210901113833.1334886-1-hch@lst.de>
Sender: Luis Chamberlain <mcgrof@infradead.org>
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

I'll drop my stand alone patch then, or can queue these in with my set
if they are determined already to be fine. Let me know.

 Luis
