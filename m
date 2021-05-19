Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4AD5C433ED
	for <linux-raid@archiver.kernel.org>; Wed, 19 May 2021 07:47:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 83AE660FDC
	for <linux-raid@archiver.kernel.org>; Wed, 19 May 2021 07:47:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234712AbhESHs2 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 19 May 2021 03:48:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229776AbhESHs2 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 19 May 2021 03:48:28 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAE3DC06175F
        for <linux-raid@vger.kernel.org>; Wed, 19 May 2021 00:47:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=A8ZQiKiJaM77dxWbdgIMR6eNkfgJoFh0T9LwR1CBaK4=; b=MNp5xKwpDw+VGqOS3S35UJiLGd
        3qIypsaBxdlPy2XGnm2TazbvBDE0md7HT9s33xYyzs84rjJteZAUYNH6K+ODrZMAJJrUIaDJVmYkQ
        1d1Ip4jBp2/b9NHN2fLNBllKPOu5sGUur5fYFNHQqk7HIvLjRQjynXAItzOTsixYbohCvEjfP3KsF
        9q3b1pMt5EgucoqRdXZtR3D7PI5qMRtzXepO5iXpuRn57u77WNzCQGCH1WZjolcAGUzPuWx9Aapbo
        FJRMYs6RRO86GmEQYNoVD2s9pXlpSQ0C8tQHri2hSVpFJQSv3o9ZurRLC+Ibmihb9NVTTn4XULSum
        9+4N7Kww==;
Received: from hch by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1ljGu0-00Ejmk-RK; Wed, 19 May 2021 07:46:27 +0000
Date:   Wed, 19 May 2021 08:46:00 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Artur Paszkiewicz <artur.paszkiewicz@intel.com>
Cc:     Guoqing Jiang <jgq516@gmail.com>, song@kernel.org,
        linux-raid@vger.kernel.org, Guoqing Jiang <jiangguoqing@kylinos.cn>
Subject: Re: [PATCH 2/5] md: the latest try for improve io stats accounting
Message-ID: <YKTCOHp0rKmKcW2K@infradead.org>
References: <20210518053225.641506-1-jiangguoqing@kylinos.cn>
 <20210518053225.641506-3-jiangguoqing@kylinos.cn>
 <2887bc44-dd0b-0b24-ee97-b0a95f0c4936@intel.com>
 <2bfe7f2b-5b5b-634d-3996-3c4ed77e74ff@gmail.com>
 <d788bc1f-3fd9-a293-2f2a-6047fdd45625@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d788bc1f-3fd9-a293-2f2a-6047fdd45625@intel.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Wed, May 19, 2021 at 09:26:21AM +0200, Artur Paszkiewicz wrote:
> On 19.05.2021 03:30, Guoqing Jiang wrote:
> > Hmm, raid0 allocates split bio from mddev->bio_set, but raid5 is
> > different, it splits bio from r5conf->bio_split. So either let raid5 also
> > splits bio from mddev->bio_set, or add an additional checking for
> > raid5. Thoughts?
> 
> It looks like raid5 has a different bio set for that because it uses
> mddev->bio_set for something else - allocating a bio for rdev. So I 
> think it can be changed to split from mddev->bio_set and have a private
> bio set for the rdev bio allocation.

Just wondering: what about moving the allocation of the clone into the
personalities entirely?
