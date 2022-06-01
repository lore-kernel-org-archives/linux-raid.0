Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D42FEC433F5
	for <linux-raid@archiver.kernel.org>; Wed,  1 Jun 2022 10:52:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350594AbiFAKwm (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 1 Jun 2022 06:52:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351062AbiFAKwj (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 1 Jun 2022 06:52:39 -0400
Received: from cdw.me.uk (cdw.me.uk [91.203.57.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 9CC2D53E03
        for <linux-raid@vger.kernel.org>; Wed,  1 Jun 2022 03:52:29 -0700 (PDT)
Received: from chris by delta.arachsys.com with local (Exim 4.80)
        (envelope-from <chris@arachsys.com>)
        id 1nwLxZ-0003ek-CG; Wed, 01 Jun 2022 11:52:17 +0100
Date:   Wed, 1 Jun 2022 11:52:17 +0100
From:   Chris Webb <chris@arachsys.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     Song Liu <song@kernel.org>, linux-raid@vger.kernel.org
Subject: Re: [PATCH] md: Explicitly create command-line configured devices
Message-ID: <YpdE4TZRY728hDNw@arachsys.com>
References: <YpXy4CLSwLf7arGp@arachsys.com>
 <YpYzhpZZwc1jY4D0@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YpYzhpZZwc1jY4D0@infradead.org>
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Christoph Hellwig <hch@infradead.org> writes:

> On Tue, May 31, 2022 at 11:50:08AM +0100, Chris Webb wrote:
> > +extern int md_alloc(dev_t dev, char *name);
> 
> No need for the extern here.
>
> Otherwise looks good:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>

Thanks! I'll resend with the redundant extern dropped.

Best wishes,

Chris.
