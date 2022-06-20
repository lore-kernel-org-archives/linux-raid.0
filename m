Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6CB1CCA47C
	for <linux-raid@archiver.kernel.org>; Mon, 20 Jun 2022 15:01:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241345AbiFTPBq (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 20 Jun 2022 11:01:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241489AbiFTPBa (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 20 Jun 2022 11:01:30 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDC921EEED
        for <linux-raid@vger.kernel.org>; Mon, 20 Jun 2022 07:28:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1655735301; x=1687271301;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=LtuxXdnzKOLTnPcDUMP3qS/DPdz9p01D7Od70DS+PYs=;
  b=RNZ+XMBurZNhR6gmp0LozGU3mXaxMesp/3gugbcKFzl+E0CzN/34GEQT
   wfi9rAx7gSv5sC2c+qsXPq+ByXXJoVumPbKU34k6alJP++38tIlH+sGQU
   dB28vsQ6GhbY71hGZVipMWQNbAl7HrYiTLgarYMqscZ12ajkbNcVja1q3
   qdHDDpmkfOuZOuptcupI/y60kfs4hsop/MLLQrM8nO9SsNT8SQZcMXf3r
   qvXprq92ZwGQy9T/vO31GrIBA/NXCNp009QUYJC3PyLA2M2EJJegp1eN5
   aGUt7kArlLf08P0OSG+pj1cIKVcaVcKnA49enbDMxp63SnWXuoKXnfqJx
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10380"; a="279958663"
X-IronPort-AV: E=Sophos;i="5.92,306,1650956400"; 
   d="scan'208";a="279958663"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jun 2022 07:28:05 -0700
X-IronPort-AV: E=Sophos;i="5.92,306,1650956400"; 
   d="scan'208";a="591200937"
Received: from mtkaczyk-mobl.ger.corp.intel.com (HELO localhost) ([10.237.142.65])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jun 2022 07:28:01 -0700
Date:   Mon, 20 Jun 2022 16:27:57 +0200
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
        David Sloan <David.Sloan@eideticom.com>,
        Alex Wu <alexwu@synology.com>,
        BingJing Chang <bingjingc@synology.com>,
        Danny Shih <dannyshih@synology.com>,
        ChangSyun Peng <allenpeng@synology.com>
Subject: Re: [PATCH mdadm v1 04/14] mdadm/Grow: Fix use after close bug by
 closing after fork
Message-ID: <20220620162757.00007d17@linux.intel.com>
In-Reply-To: <20220609211130.5108-5-logang@deltatee.com>
References: <20220609211130.5108-1-logang@deltatee.com>
        <20220609211130.5108-5-logang@deltatee.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Thu,  9 Jun 2022 15:11:20 -0600
Logan Gunthorpe <logang@deltatee.com> wrote:
> ---
>  Grow.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/Grow.c b/Grow.c
> index 8a242b0f8725..ba5dc1aead64 100644
> --- a/Grow.c
> +++ b/Grow.c
> @@ -3506,7 +3506,6 @@ started:
>  			return 0;
>  		}
>  
> -	close(fd);
>  	/* Now we just need to kick off the reshape and watch, while
>  	 * handling backups of the data...
>  	 * This is all done by a forked background process.
> @@ -3527,6 +3526,9 @@ started:
>  		break;
>  	}
>  
> +	/* Close unused file descriptor in the forked process */
> +	close(fd);
> +
>  	/* If another array on the same devices is busy, the
>  	 * reshape will wait for them.  This would mean that
>  	 * the first section that we suspend will stay suspended

Please use close_fd() helper to invalidate fd too.
