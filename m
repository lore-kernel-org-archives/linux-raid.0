Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A05BC433F5
	for <linux-raid@archiver.kernel.org>; Tue, 31 May 2022 07:55:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244630AbiEaHzD (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 31 May 2022 03:55:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242444AbiEaHzB (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 31 May 2022 03:55:01 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 485F1F5B4
        for <linux-raid@vger.kernel.org>; Tue, 31 May 2022 00:55:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1653983700; x=1685519700;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=mADCojoQMwBFiK+EdQP4/fj7KTO3kZ9aH63dpZY9ej0=;
  b=a7q/zbSb46Oc/M3kuDG4h7qbU2/jAu/jKSWe0z10ycwGpocKSb8LpmPx
   Bixo66cbRLsvNkwuY+8mW4v/2hNOWdGsUdpLj2tquivxyEkKXYOEsUCQy
   dzSUvpHT+Q0BVMGqz1wESOApipU3zTOAeTM3EgmiTALeieUBrsMH/ybSd
   +CCP+aarzOkCLzoax2IAqXHCEKscNdw1IhsmuQpOhHnx+kJh0592ezUOO
   bokUyKqLITXekClxt+NGQytHJtmz27vgnmGjDpd3ZvY7RYeEzRlGiKRU2
   MyTdxkgwXwv1bcAthD1EtPZBQM0TuTCBe+pAogzHKtXpBvU1XMMhaSQwc
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10363"; a="262806522"
X-IronPort-AV: E=Sophos;i="5.91,264,1647327600"; 
   d="scan'208";a="262806522"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 May 2022 00:54:59 -0700
X-IronPort-AV: E=Sophos;i="5.91,264,1647327600"; 
   d="scan'208";a="605541870"
Received: from mtkaczyk-mobl.ger.corp.intel.com (HELO localhost) ([10.252.57.59])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 May 2022 00:54:58 -0700
Date:   Tue, 31 May 2022 09:54:53 +0200
From:   Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To:     Wu Guanghao <wuguanghao3@huawei.com>
Cc:     <jes@trained-monkey.org>, <linux-raid@vger.kernel.org>,
        <linfeilong@huawei.com>, <lixiaokeng@huawei.com>
Subject: Re: [PATCH 3/5] load_imsm_mpb: fix double free
Message-ID: <20220531095453.00001a7a@linux.intel.com>
In-Reply-To: <4ded262a-9313-d328-a3e1-fca56210bf62@huawei.com>
References: <00992179-9572-ceb4-eb49-492c42e67695@huawei.com>
        <4ded262a-9313-d328-a3e1-fca56210bf62@huawei.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Tue, 31 May 2022 14:50:19 +0800
Wu Guanghao <wuguanghao3@huawei.com> wrote:

> When free(super->buf) but not set super->buf = NULL, will be double free
> 
> get_super_block
> 	err = load_and_parse_mpb
> 		load_imsm_mpb(.., s, ..)
> 			if (posix_memalign(&super->buf, MAX_SECTOR_SIZE,
> super->len) != 0) // true, super->buf != NULL if
> (posix_memalign(&super->migr_rec_buf, MAX_SECTOR_SIZE,); // false
> free(super->buf); //but super->buf not set NULL return 2;
> 
> 	if err ! = 0
> 		if (s)
> 			free_imsm(s)
> 				 __free_imsm(s)
> 					if (s)
> 						free(s->buf); //double free
> 
> Signed-off-by: Wu Guanghao <wuguanghao3@huawei.com>
> ---
>  super-intel.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/super-intel.c b/super-intel.c
> index ba3bd41f..ef21ffba 100644
> --- a/super-intel.c
> +++ b/super-intel.c
> @@ -4452,7 +4452,6 @@ static int load_imsm_mpb(int fd, struct intel_super
> *super, char *devname) if (posix_memalign(&super->migr_rec_buf,
> MAX_SECTOR_SIZE, MIGR_REC_BUF_SECTORS*MAX_SECTOR_SIZE) != 0) {
>  		pr_err("could not allocate migr_rec buffer\n");
> -		free(super->buf);
>  		return 2;
>  	}
>  	super->clean_migration_record_by_mdmon = 0;

On error, we should possibly clean-up ourselves so I would expect from 
load_imsm_mpb() to free super->buf in case when error occurs and set it
to NULL, especially that __free_imsm handles it.

Thanks,
Mariusz
