Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A80BEB64DB
	for <linux-raid@archiver.kernel.org>; Fri, 16 Jun 2023 07:03:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244537AbjFPHDc (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 16 Jun 2023 03:03:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244162AbjFPHCw (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 16 Jun 2023 03:02:52 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 750034223;
        Fri, 16 Jun 2023 00:01:21 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id EF5A967373; Fri, 16 Jun 2023 09:01:14 +0200 (CEST)
Date:   Fri, 16 Jun 2023 09:01:14 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Song Liu <song@kernel.org>
Cc:     kernel test robot <lkp@intel.com>, Christoph Hellwig <hch@lst.de>,
        llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
        linux-raid@vger.kernel.org, linux-block@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 06/11] md-bitmap: refactor md_bitmap_init_from_disk
Message-ID: <20230616070114.GB29500@lst.de>
References: <20230615064840.629492-7-hch@lst.de> <202306160552.smw0qbmb-lkp@intel.com> <CAPhsuW5T4ULiYmCDoLwiaQRKP1OsMDhAez_hrzge_WkXxiWsNQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPhsuW5T4ULiYmCDoLwiaQRKP1OsMDhAez_hrzge_WkXxiWsNQ@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Thu, Jun 15, 2023 at 11:53:49PM -0700, Song Liu wrote:
> I fixed this one, and applied the set to md-next.

Thanks!
