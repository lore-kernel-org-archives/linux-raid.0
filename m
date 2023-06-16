Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04E81EB64DB
	for <linux-raid@archiver.kernel.org>; Fri, 16 Jun 2023 07:03:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244376AbjFPHDM (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 16 Jun 2023 03:03:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244352AbjFPHCe (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 16 Jun 2023 03:02:34 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1EBC30D1;
        Fri, 16 Jun 2023 00:01:04 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id E46536732D; Fri, 16 Jun 2023 09:01:00 +0200 (CEST)
Date:   Fri, 16 Jun 2023 09:01:00 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
Cc:     Christoph Hellwig <hch@lst.de>, Song Liu <song@kernel.org>,
        linux-raid@vger.kernel.org, linux-block@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: deprecate md bitmap file support
Message-ID: <20230616070100.GA29500@lst.de>
References: <20230615064840.629492-1-hch@lst.de> <20230615100557.00003d8e@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230615100557.00003d8e@linux.intel.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Thu, Jun 15, 2023 at 10:05:57AM +0200, Mariusz Tkaczyk wrote:
> Hi Christoph,
> I think that it is worthy to make mdadm aware of that. For example, by requiring
> "--force" to make the volume with bitmap file now.

Sounds reasonable to me.  I'll look into it.
