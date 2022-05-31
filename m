Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB84AC433EF
	for <linux-raid@archiver.kernel.org>; Tue, 31 May 2022 08:11:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244736AbiEaILm (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 31 May 2022 04:11:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242430AbiEaILk (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 31 May 2022 04:11:40 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38377B68
        for <linux-raid@vger.kernel.org>; Tue, 31 May 2022 01:11:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1653984699; x=1685520699;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=RsmfPQdbgUCSMuB8Mvg8QJDaliAPo/PGaeGLBjBqMPs=;
  b=YJyXHwXL0CKtNb4+IGwe6r5Ohh5YtoshQWH53/JTU50IkyR6m3qfN6Zp
   gQqYgatmi8KBlNk92XVUAhPkG+h6p+UniBHvhf/GVituz83LQFYjcW2aP
   3xH2LS/oVnbtpbc4jplbecbMtmT3GJa7ILhGTPcIiZPlKms/lN026l+jQ
   fLczNaF0MggmVsxA2RrOueTAXxWId9IQ8KZhJKn1h07rnxfquwI3ipQf9
   eqLKa+t5Xr/Vm1KnsYHgBplV7YSE2v5TeHN/t1nsMoPrOzMW4lpctAFSo
   3+jPOA86A3UdlCXd9Tg4b8DGhyNzul7RVGzRXorycg7RopKvxeChQTumg
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10363"; a="361557695"
X-IronPort-AV: E=Sophos;i="5.91,264,1647327600"; 
   d="scan'208";a="361557695"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 May 2022 01:11:38 -0700
X-IronPort-AV: E=Sophos;i="5.91,264,1647327600"; 
   d="scan'208";a="605551122"
Received: from mtkaczyk-mobl.ger.corp.intel.com (HELO localhost) ([10.252.57.59])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 May 2022 01:11:37 -0700
Date:   Tue, 31 May 2022 10:11:32 +0200
From:   Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To:     Wu Guanghao <wuguanghao3@huawei.com>
Cc:     <jes@trained-monkey.org>, <linux-raid@vger.kernel.org>,
        <linfeilong@huawei.com>, <lixiaokeng@huawei.com>
Subject: Re: [PATCH 5/5] get_vd_num_of_subarray: fix memleak
Message-ID: <20220531101132.00002141@linux.intel.com>
In-Reply-To: <f1bee99f-a9b0-0e58-36fb-e5eee110dcc9@huawei.com>
References: <00992179-9572-ceb4-eb49-492c42e67695@huawei.com>
        <f1bee99f-a9b0-0e58-36fb-e5eee110dcc9@huawei.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Tue, 31 May 2022 14:51:13 +0800
Wu Guanghao <wuguanghao3@huawei.com> wrote:

> sra = sysfs_read() should be free before return in
> get_vd_num_of_subarray()
> 
> Signed-off-by: Wu Guanghao <wuguanghao3@huawei.com>
> ---
>  super-ddf.c | 9 +++++++--
>  1 file changed, 7 insertions(+), 2 deletions(-)
> 
> diff --git a/super-ddf.c b/super-ddf.c
> index 8cda23a7..827e4ae7 100644
> --- a/super-ddf.c
> +++ b/super-ddf.c
> @@ -1599,15 +1599,20 @@ static unsigned int get_vd_num_of_subarray(struct
> supertype *st) sra = sysfs_read(-1, st->devnm, GET_VERSION);
>  	if (!sra || sra->array.major_version != -1 ||
>  	    sra->array.minor_version != -2 ||
> -	    !is_subarray(sra->text_version))
> +	    !is_subarray(sra->text_version)) {
> +		if (sra)
> +			sysfs_free(sra);
>  		return DDF_NOTFOUND;
> +	}
> 
>  	sub = strchr(sra->text_version + 1, '/');
>  	if (sub != NULL)
>  		vcnum = strtoul(sub + 1, &end, 10);
>  	if (sub == NULL || *sub == '\0' || *end != '\0' ||
> -	    vcnum >= be16_to_cpu(ddf->active->max_vd_entries))
> +	    vcnum >= be16_to_cpu(ddf->active->max_vd_entries)) {
> +		sysfs_free(sra);
>  		return DDF_NOTFOUND;
> +	}
> 
>  	return vcnum;
>  }

Acked-by:mariusz.tkaczyk@linux.intel.com
