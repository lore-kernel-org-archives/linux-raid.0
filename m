Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3797C4332F
	for <linux-raid@archiver.kernel.org>; Thu, 23 Sep 2021 10:39:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CE810610A0
	for <linux-raid@archiver.kernel.org>; Thu, 23 Sep 2021 10:39:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240401AbhIWKlK (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 23 Sep 2021 06:41:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:47746 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240314AbhIWKlJ (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Thu, 23 Sep 2021 06:41:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8548560F48;
        Thu, 23 Sep 2021 10:39:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632393578;
        bh=DVLsxmZnDQpxwky0YVgRFmmG4BlD+wPHnOnJ5BITyiU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=oz+8Z57v9plrxP6d9ZOec6xQ+m/LJomlpaRyNRMRvYqoGUWeS4vI/y9vmvoXVfJsd
         jh0Awx5txUcm71s8gxxmIULO0G9hMtKyArGpB9pWz7WcJXonibXhMDhtly811ekLZS
         yIOV8lVkGFvZZVPAhc0J8TPQChSbkbAz/EjPsCKk=
Date:   Thu, 23 Sep 2021 12:39:35 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     NeilBrown <neilb@suse.de>
Cc:     Coly Li <colyli@suse.de>, linux-kernel@vger.kernel.org,
        linux-block@vger.kernel.org, linux-raid@vger.kernel.org,
        nvdimm@lists.linux.dev, antlists@youngman.org.uk,
        Dan Williams <dan.j.williams@intel.com>,
        Hannes Reinecke <hare@suse.de>, Jens Axboe <axboe@kernel.dk>,
        Richard Fan <richard.fan@suse.com>,
        Vishal L Verma <vishal.l.verma@intel.com>, rafael@kernel.org
Subject: Re: Too large badblocks sysfs file (was: [PATCH v3 0/7] badblocks
 improvement for multiple bad block ranges)
Message-ID: <YUxZZ/UHyRTt83pW@kroah.com>
References: <20210913163643.10233-1-colyli@suse.de>
 <a0f7b021-4816-6785-a9a4-507464b55895@suse.de>
 <163239176137.2580.11220971146920860651@noble.neil.brown.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <163239176137.2580.11220971146920860651@noble.neil.brown.name>
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Thu, Sep 23, 2021 at 08:09:21PM +1000, NeilBrown wrote:
> On Thu, 23 Sep 2021, Coly Li wrote:
> > Hi all the kernel gurus, and folks in mailing lists,
> > 
> > This is a question about exporting 4KB+ text information via sysfs 
> > interface. I need advice on how to handle the problem.
> 
> Why do you think there is a problem?
> As documented in Documentation/admin-guide/md.rst, the truncation at 1
> page is expected and by design.

Ah, shouldn't that info also be in Documentation/ABI/ so that others can
easily find it?

thanks,

greg k-h
