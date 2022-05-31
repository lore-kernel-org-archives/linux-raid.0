Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5AD47C433EF
	for <linux-raid@archiver.kernel.org>; Tue, 31 May 2022 08:05:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244716AbiEaIFQ (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 31 May 2022 04:05:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244760AbiEaIFG (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 31 May 2022 04:05:06 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1136E91543
        for <linux-raid@vger.kernel.org>; Tue, 31 May 2022 01:05:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1653984306; x=1685520306;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Oarjt87jNqwijFTDQQtXNaAtu5FpR0TEhCStjS7h818=;
  b=i5n2X6QCMjuqNu1NGekokoBz76lql5OlCAoF/4pjKM+jS70Ch8Euil0s
   ROXSkjaqQ60NJ/LEFYurexpel14usvNZnXygaiU8pg4noaWNb1oZwAuQX
   uWXkvDrOuN9SDHDVeP6MBpMP1gMwWgblk4OdLlcCbSpv0Y6a/TEiNFVgk
   z7v2dFUcursTFO711YCxvMbnU7p43V+ZCODeyfD62qeIVBrRGEnzoICtO
   3Vi4MPvLmZg2xT6LiSkny54iYkX/EfdY7c+SmC55Tk66FP65IGoDVwMhl
   N9LeHZaQeideZp8Oc3RZNGXELD/jqWChLwNaWXQzwY1eHQ5keRWiIGAMq
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10363"; a="255661134"
X-IronPort-AV: E=Sophos;i="5.91,264,1647327600"; 
   d="scan'208";a="255661134"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 May 2022 01:04:18 -0700
X-IronPort-AV: E=Sophos;i="5.91,264,1647327600"; 
   d="scan'208";a="605546565"
Received: from mtkaczyk-mobl.ger.corp.intel.com (HELO localhost) ([10.252.57.59])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 May 2022 01:04:17 -0700
Date:   Tue, 31 May 2022 10:04:12 +0200
From:   Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To:     Wu Guanghao <wuguanghao3@huawei.com>
Cc:     <jes@trained-monkey.org>, <linux-raid@vger.kernel.org>,
        <linfeilong@huawei.com>, <lixiaokeng@huawei.com>
Subject: Re: [PATCH 4/5] find_disk_attached_hba: fix memleak
Message-ID: <20220531100412.0000440a@linux.intel.com>
In-Reply-To: <12e34ddf-6e60-ab5f-020d-bd004fbbef06@huawei.com>
References: <00992179-9572-ceb4-eb49-492c42e67695@huawei.com>
        <12e34ddf-6e60-ab5f-020d-bd004fbbef06@huawei.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Tue, 31 May 2022 14:50:44 +0800
Wu Guanghao <wuguanghao3@huawei.com> wrote:

> If disk_path = diskfd_to_devpath(), we need free(disk_path) before
> return, otherwise there will be a memory leak
> 
> Signed-off-by: Wu Guanghao <wuguanghao3@huawei.com>
> ---
>  super-intel.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/super-intel.c b/super-intel.c
> index ef21ffba..98fb63d5 100644
> --- a/super-intel.c
> +++ b/super-intel.c
> @@ -700,8 +700,11 @@ static struct sys_dev* find_disk_attached_hba(int fd,
> const char *devname) return 0;
> 
>  	for (elem = list; elem; elem = elem->next)
> -		if (path_attached_to_hba(disk_path, elem->path))
> +		if (path_attached_to_hba(disk_path, elem->path)) {
> +			if (disk_path != devname)
> +				free(disk_path);
>  			return elem;
> +		}
> 
>  	if (disk_path != devname)
>  		free(disk_path);

Patch is obviously correct but we can avoid code duplication:

	for (elem = list; elem; elem = elem->next)
		if (path_attached_to_hba(disk_path, elem->path))
			break;

	if (disk_path != devname)
		free(disk_path);

	return elem;

Last list element will be NULL anyway. Could you adopt it?

Thanks,
Mariusz
