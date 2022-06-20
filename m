Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B991FC433EF
	for <linux-raid@archiver.kernel.org>; Mon, 20 Jun 2022 14:56:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239722AbiFTO4b (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 20 Jun 2022 10:56:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238798AbiFTOz7 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 20 Jun 2022 10:55:59 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD36724968
        for <linux-raid@vger.kernel.org>; Mon, 20 Jun 2022 07:15:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1655734503; x=1687270503;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=DToSFFi7zwlG9rMiH4MHe6HoecuKVOLjvWeEtmpRRwo=;
  b=L6nHE2MrEagZRCwLSCfWKvkJ919F3+2fCkLSmlhG6yeZZ1CSdMN9dFwx
   3WN088cNr48vueBsYBtz4ITVDqRMwwq3Ma41NRUojOCqjbPstQdZpac2A
   vg3wJmBfkD9+NUpo5o8lPw+snKcj9UrhVyFZ15bekDTBEqOhkf3ig+vtH
   ZPtsNEpNDLN5hQ30gFaPWdpxDJqfd2OsgkNAIJ+qGcSDl0N1RkTxE9nWK
   CWvBH0oEL5WX2TDXLZ01RYQkD/Wi0IEGFKyK1E646gQ+rUtl5AgP13AAw
   lNkTFS/LWISDeMeILTdKumoJcPwK9Hb+xn7Wkmx9fb2az1hqPndyQ76jr
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10380"; a="279955935"
X-IronPort-AV: E=Sophos;i="5.92,306,1650956400"; 
   d="scan'208";a="279955935"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jun 2022 07:15:03 -0700
X-IronPort-AV: E=Sophos;i="5.92,306,1650956400"; 
   d="scan'208";a="591197020"
Received: from mtkaczyk-mobl.ger.corp.intel.com (HELO localhost) ([10.237.142.65])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jun 2022 07:15:00 -0700
Date:   Mon, 20 Jun 2022 16:14:57 +0200
From:   Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To:     Logan Gunthorpe <logang@deltatee.com>
Cc:     linux-raid@vger.kernel.org, Jes Sorensen <jsorensen@fb.com>,
        Song Liu <song@kernel.org>,
        Christoph Hellwig <hch@infradead.org>,
        Donald Buczek <buczek@molgen.mpg.de>,
        Guoqing Jiang <guoqing.jiang@linux.dev>,
        Xiao Ni <xni@redhat.com>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Coly Li <colyli@suse.de>, Bruce Dubbs <bruce.dubbs@gmail.com>,
        Stephen Bates <sbates@raithlin.com>,
        Martin Oliveira <Martin.Oliveira@eideticom.com>,
        David Sloan <David.Sloan@eideticom.com>
Subject: Re: [PATCH mdadm v1 02/14] DDF: Cleanup
 validate_geometry_ddf_container()
Message-ID: <20220620161457.000004d1@linux.intel.com>
In-Reply-To: <20220609211130.5108-3-logang@deltatee.com>
References: <20220609211130.5108-1-logang@deltatee.com>
        <20220609211130.5108-3-logang@deltatee.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Thu,  9 Jun 2022 15:11:18 -0600
Logan Gunthorpe <logang@deltatee.com> wrote:

> Move the function up so that the function declaration is not necessary
> and remove the unused arguments to the function.
> 
> No functional changes are intended but will help with a bug fix in the
> next patch.
> 
> Signed-off-by: Logan Gunthorpe <logang@deltatee.com>
> ---

Acked-by: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
