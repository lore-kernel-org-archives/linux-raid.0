Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2E38C636D7
	for <linux-raid@archiver.kernel.org>; Tue, 21 Feb 2023 14:39:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234459AbjBUOjl (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 21 Feb 2023 09:39:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234069AbjBUOjk (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 21 Feb 2023 09:39:40 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CE7426CC4
        for <linux-raid@vger.kernel.org>; Tue, 21 Feb 2023 06:39:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=GWn3F0Pmj7x9LoFlYiF4eGyQOPMZAnNI75Rw2QbmCtQ=; b=wbMqQ1ZKOqnXEsx5ViP/XqvDUh
        7dP1hcMlSttOy2jUM9IZSe6HpPmttq9/BkfcsGH+aAjFPHgW4+lPngN/N/DogPMnckv7tTX9nPoSi
        Mgs2Zpzs1a8+l1pbNdHpL4BalnvNLB8nsPS2pCeJAw2XOGd+Vd7JPymFYYX/HofdVYTpGtfe5KZOp
        +vb1PTSKu1glOtesIGt3Txo9QsST6BWyAPV4W26z94ofosrqq/BPPMKrxC9/cX7jsYviUiGuIPdhe
        Db3FEcRZc7XwqdVPPC9k1RpOWLWL0/hdsLtMgD5d5HRux2GT4FhnKc5Vxzl9xzaRxTiMgtpotkzqa
        2hQWacYg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1pUTnp-008WOo-0Y; Tue, 21 Feb 2023 14:39:33 +0000
Date:   Tue, 21 Feb 2023 06:39:32 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     Jonathan Derrick <jonathan.derrick@linux.dev>
Cc:     Xiao Ni <xni@redhat.com>, Song Liu <song@kernel.org>,
        linux-raid@vger.kernel.org, Paul Menzel <pmenzel@molgen.mpg.de>,
        Sushma Kalakota <sushma.kalakota@intel.com>
Subject: Re: [PATCH v2] md: Use optimal I/O size for last bitmap page
Message-ID: <Y/TXpGDtWVlfwPF4@infradead.org>
References: <20230217183139.106-1-jonathan.derrick@linux.dev>
 <CALTww2-3t-Tyjh1yAZhM+6Rwgh7t2=EFk1hOpvnTuiN91yyfDg@mail.gmail.com>
 <fd88c91e-f501-005d-3eb2-98a019d3db9e@linux.dev>
 <CALTww28rr6FdO=-E7G=MM7hT5QszpTc6hQH9grQ+aiuUixtY5A@mail.gmail.com>
 <df22867d-8349-6bf7-c597-432222277bcc@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <df22867d-8349-6bf7-c597-432222277bcc@linux.dev>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Tue, Feb 21, 2023 at 12:34:51AM -0700, Jonathan Derrick wrote:
> You can force it with something like this:

Also scsi_debug lets you set the optimal I/O size using the
opt_blks parameter.
