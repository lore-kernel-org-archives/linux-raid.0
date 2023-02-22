Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 257DCC61DA4
	for <linux-raid@archiver.kernel.org>; Wed, 22 Feb 2023 23:53:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232357AbjBVXxa (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 22 Feb 2023 18:53:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230356AbjBVXx2 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 22 Feb 2023 18:53:28 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 341691E9F5
        for <linux-raid@vger.kernel.org>; Wed, 22 Feb 2023 15:53:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=CL/wnOT7R8PLV+HtDgOX5RThWHIdXyQNI+6AgejnOa0=; b=a210NSyoH5Y7pg6jvnU5T7ASoR
        qbtXhwke/yJbgo+P0Y+1chmsZuxyRIKsiNQ6irbpYXciW7ybUxqQ7WPUi1gW0VTJl+dhx84xcs23Q
        4btyPqSz9mwcyRtJyVHc6PAwQKQ65m8ZZ2YOlzX5nNsCsxd2r98QThV0Te7nJSz0Jop7yTQsaex6i
        Y9MGnpECa9hbUGTAWI8ExYhuxXyNJXlMnhb7zL3weJXxbq98cBm2HbVTzhJSUrARxldj0Caxu9kJU
        hXbW4AWpf7s9x/rqfJ/qmClqfy+iZf3jM8NQx0BBRoG/kpKWSlqBDKhKyd9Qm29mTQPvHPNI+R8QP
        IxjyaNLQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1pUyvL-00EU3Y-Hw; Wed, 22 Feb 2023 23:53:23 +0000
Date:   Wed, 22 Feb 2023 15:53:23 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     Reindl Harald <h.reindl@thelounge.net>
Cc:     Christoph Hellwig <hch@infradead.org>,
        Jonathan Derrick <jonathan.derrick@linux.dev>,
        Song Liu <song@kernel.org>, linux-raid@vger.kernel.org,
        Xiao Ni <xni@redhat.com>, Paul Menzel <pmenzel@molgen.mpg.de>,
        Sushma Kalakota <sushma.kalakota@intel.com>
Subject: Re: [PATCH v3 3/3] md: Use optimal I/O size for last bitmap page
Message-ID: <Y/aq87mfSNlgLy+I@infradead.org>
References: <20230222215828.225-1-jonathan.derrick@linux.dev>
 <20230222215828.225-4-jonathan.derrick@linux.dev>
 <Y/aoYGITuKUHBkoC@infradead.org>
 <cf7d2f0e-a49b-66a9-a2ad-4726f98e1704@thelounge.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cf7d2f0e-a49b-66a9-a2ad-4726f98e1704@thelounge.net>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Thu, Feb 23, 2023 at 12:48:58AM +0100, Reindl Harald wrote:
> > > +	if (io_size != opt_size &&
> > > +	    start + opt_size / SECTOR_SIZE <= boundary)
> > > +		return opt_size;
> > > +	else if (start + io_size / SECTOR_SIZE <= boundary)
> > 
> > No need for an else after a return.
> > 
> > Otherwise looks good:
> > 
> > Reviewed-by: Christoph Hellwig <hch@lst.de>
> 
> the "return" is within the if-condition and has nothing to do with the else
> - with {} it would be clearly visible

That doesn't change the fact that it's not actually needed.
