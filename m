Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84745C43334
	for <linux-raid@archiver.kernel.org>; Mon, 20 Jun 2022 15:02:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241698AbiFTPCH (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 20 Jun 2022 11:02:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240896AbiFTPBl (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 20 Jun 2022 11:01:41 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C25A120181
        for <linux-raid@vger.kernel.org>; Mon, 20 Jun 2022 07:29:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1655735380; x=1687271380;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Wy0kvrcQ6paTAOwBBylUwVwY8Qfdwyd2TRr/y2phzCw=;
  b=nnIHgBBraxoIN4dI5M3X86CrfiVNWUOKCLK9uF27OOwhh8rsAGHclDOZ
   39Yl/ybu2HvWS5OaHJSZF21olrBqPlg1bXi7aiOu27A3B9dEuNt3HAKWs
   vZzOvE5Tz2Toxfpwn7Q2wMXDyfpqBSaoj0NmCyRL2sshKhsmnYKR9z4ED
   WA3Yp3yaPLYELTLw7/CIMEz3np4OpAezdnXbXZD3QoO6yPb2Fu2mFIsgr
   b++7HLPoAVFz6/jaf78XkJRj1a3IYzP+nWt78HO8O1Xxct/5vTs8Ttqwk
   PrXnVCeMDCOb57H6rchZ/Wmnyn+09MmKu30w3WBpnUNnw7CW0q6wSq6tM
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10380"; a="341591061"
X-IronPort-AV: E=Sophos;i="5.92,306,1650956400"; 
   d="scan'208";a="341591061"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jun 2022 07:29:40 -0700
X-IronPort-AV: E=Sophos;i="5.92,306,1650956400"; 
   d="scan'208";a="591201227"
Received: from mtkaczyk-mobl.ger.corp.intel.com (HELO localhost) ([10.237.142.65])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jun 2022 07:29:36 -0700
Date:   Mon, 20 Jun 2022 16:29:33 +0200
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
Subject: Re: [PATCH mdadm v1 05/14] monitor: Avoid segfault when calling
 NULL get_bad_blocks
Message-ID: <20220620162933.000047f0@linux.intel.com>
In-Reply-To: <20220609211130.5108-6-logang@deltatee.com>
References: <20220609211130.5108-1-logang@deltatee.com>
        <20220609211130.5108-6-logang@deltatee.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Thu,  9 Jun 2022 15:11:21 -0600
Logan Gunthorpe <logang@deltatee.com> wrote:

> Not all struct superswitch implement a get_bad_blocks() function,
> yet mdmon seems to call it without checking for NULL and thus
> occasionally segfaults in the test 10ddf-geometry.
> 
> Fix this by checking for NULL before calling it.
> 
> Signed-off-by: Logan Gunthorpe <logang@deltatee.com>
> ---

Acked-by: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
