Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18723C433EF
	for <linux-raid@archiver.kernel.org>; Fri, 10 Jun 2022 09:15:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348680AbiFJJPQ (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 10 Jun 2022 05:15:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347897AbiFJJOx (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 10 Jun 2022 05:14:53 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3333C1E0AC2
        for <linux-raid@vger.kernel.org>; Fri, 10 Jun 2022 02:14:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1654852472; x=1686388472;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=8nzpVLCOBlMPu1xfUyEVkZV42YfaB1nG7Fy1NXBlM1o=;
  b=dNDVqe4ELB8r4FtwHwCeOUsJTQaBoen0w5VQ+YzObS0Ay1mhRC5Q4BfF
   VzcI/UBy+ieWI42nRNOSDn69lhA/XaIZDeg9W/e5GN1LhZy7DRIAgYmZo
   grzgrUfjSCPfXFx9CG9S79R1thPjSqu/KmMmVa55PfaPk17yQlElbGLNU
   r9/gpiyf4WqWOvqw4lDHyGqNLGHaCrCA6kZAipHfL5FpJD5NDWUD+8C+7
   hyn+H2szEJlGL9P0I2QX1FKdTU2e3fpNuyfKcxMMdo9cAox4LBQPWytiy
   e8UtmaYOonKIwuFkXPJ0eeL4KThqQO2zrscN+k1LL06gkrOx/kuHQsimK
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10373"; a="257402654"
X-IronPort-AV: E=Sophos;i="5.91,288,1647327600"; 
   d="scan'208";a="257402654"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jun 2022 02:14:31 -0700
X-IronPort-AV: E=Sophos;i="5.91,288,1647327600"; 
   d="scan'208";a="638035017"
Received: from mtkaczyk-mobl.ger.corp.intel.com (HELO localhost) ([10.252.57.21])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jun 2022 02:14:29 -0700
Date:   Fri, 10 Jun 2022 11:14:26 +0200
From:   Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To:     Wu Guanghao <wuguanghao3@huawei.com>
Cc:     <jes@trained-monkey.org>, <linux-raid@vger.kernel.org>,
        Paul Menzel <pmenzel@molgen.mpg.de>, <linfeilong@huawei.com>,
        <lixiaokeng@huawei.com>
Subject: Re: [PATCH 3/5 v2] load_imsm_mpb: fix double free
Message-ID: <20220610111426.00003a45@linux.intel.com>
In-Reply-To: <3a17cad1-928b-2f44-88e6-df457102cfb2@huawei.com>
References: <fd86d427-2d3e-b337-6de8-d70dcbbd6ce1@huawei.com>
        <3a17cad1-928b-2f44-88e6-df457102cfb2@huawei.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Thu, 9 Jun 2022 11:07:56 +0800
Wu Guanghao <wuguanghao3@huawei.com> wrote:

> When free(super->buf) but not set super->buf = NULL, will be double free.
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
>  super-intel.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/super-intel.c b/super-intel.c
> index ba3bd41f..ee9e112e 100644
> --- a/super-intel.c
> +++ b/super-intel.c
> @@ -4453,6 +4453,7 @@ static int load_imsm_mpb(int fd, struct intel_super
> *super, char *devname) MIGR_REC_BUF_SECTORS*MAX_SECTOR_SIZE) != 0) {
>                 pr_err("could not allocate migr_rec buffer\n");
>                 free(super->buf);
> +               super->buf = NULL;
>                 return 2;
>         }
>         super->clean_migration_record_by_mdmon = 0;
> --
> 2.27.0

Reviewed-by: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
