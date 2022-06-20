Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E734C43334
	for <linux-raid@archiver.kernel.org>; Mon, 20 Jun 2022 14:50:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242623AbiFTOuQ (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 20 Jun 2022 10:50:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241673AbiFTOuB (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 20 Jun 2022 10:50:01 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 866B03C70F
        for <linux-raid@vger.kernel.org>; Mon, 20 Jun 2022 07:09:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1655734145; x=1687270145;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=2E1jFShTPElRyqt5lnNz1+Wcgmkaa7FKjKCGKO16aL8=;
  b=bw2ND4yZh2a+EXI+7fy8ZDAoXjfQPosjlhBZMBu4JAZUsrXoy+Iallpe
   NOahbup8bt/1TTpCW6eP4i1hV1LBObYQeFWuHhBwQVxu82oyU0yDhVaaY
   bHxKXiiUDsemIVxCZSsS1YP8ed9Ia/tI7O1zN/tUm3vd183cpdNFd95u0
   3ExUKnEEGw/HT1WnYFcxYBkG3maRKgcKWqCogduaLTFQEN0lLxuvd8zuS
   WvVoF0DsD06SKsMuME/DlvA6QnLBPjPodDtW2sLCBYRZHXkYbbhpJQtzE
   7ZeX4FU2Xn6CLu1trbvEw5KUrzxhzrtECcVaqdZdnUU3o/Uk9IvG5XSAJ
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10380"; a="262938894"
X-IronPort-AV: E=Sophos;i="5.92,306,1650956400"; 
   d="scan'208";a="262938894"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jun 2022 07:08:46 -0700
X-IronPort-AV: E=Sophos;i="5.92,306,1650956400"; 
   d="scan'208";a="591194890"
Received: from mtkaczyk-mobl.ger.corp.intel.com (HELO localhost) ([10.237.142.65])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jun 2022 07:08:42 -0700
Date:   Mon, 20 Jun 2022 16:08:38 +0200
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
Subject: Re: [PATCH mdadm v1 01/14] Makefile: Don't build static build with
 everything
Message-ID: <20220620160838.00000d73@linux.intel.com>
In-Reply-To: <20220609211130.5108-2-logang@deltatee.com>
References: <20220609211130.5108-1-logang@deltatee.com>
        <20220609211130.5108-2-logang@deltatee.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi Logan,
Thanks for this patchset. I really appreciate effort you did here.

On Thu,  9 Jun 2022 15:11:17 -0600
Logan Gunthorpe <logang@deltatee.com> wrote:

> Running the test require building everything, but it seems to be
> difficult to build the static version of mdadm now seeing there
> is no readily available static udev library.
> 
> There's no need to build it, so just remove it.

I think that you want to remove it totally, right?

What with following targets:
everything-test
install-static
mdadm.static
clear

BTW. mdadm can be compiled without libudev dependency by setting DNO_LIBUDEV

I'm fine with removing it but please did it globally. Please also remove
mkinitramfs file.

Thanks,
Mariusz

> 
> Signed-off-by: Logan Gunthorpe <logang@deltatee.com>
> ---
>  Makefile | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/Makefile b/Makefile
> index bf126033b841..f2f671cefe66 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -182,7 +182,7 @@ check_rundir:
>  		echo "***** or set CHECK_RUN_DIR=0"; exit 1; \
>  	fi
>  
> -everything: all mdadm.static swap_super test_stripe raid6check \
> +everything: all swap_super test_stripe raid6check \
>  	mdadm.Os mdadm.O2 man
>  everything-test: all mdadm.static swap_super test_stripe \
>  	mdadm.Os mdadm.O2 man

