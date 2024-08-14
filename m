Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5CBE1109;
	Wed, 14 Aug 2024 12:53:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723639984; cv=none; b=pgGpdz1Lk2vCu36eIda5XWttMgxCENyBVTOF8kV5PJkBeua4q1XdRJufzQQInIFtuYqMAuDbGu1HHvru52pSPVBUnplHVWNBZj6JAZHvY3PXQwBEVKGMZQt/EI9KB7scHTGYMRiM+51A2eV6MgV/VICupBXFwRq1Ng0swIpn6r8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723639984; c=relaxed/simple;
	bh=zhmO0zFzKNae4Kb3ntQiQtymVF8pyZKYQrbO9fHGS0g=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=L3f7zfnNGkvJG8faVvzeZfNyG+ZRzj/5uaEYo0N3hBwA8EOQlfbmRAwYCNRYOq6AShPqj2YKGbKECE+r5yvrHxzEqhKGJNrvhhaClOd4JcihCMSy5Tx3TxI5fQ41tAHl0GnBTRBnsWRtAdCqAhube60HG1rwXtEmD7yf4PpHpVE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Kgca31zA; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Kgca31zA"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1723639983; x=1755175983;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=zhmO0zFzKNae4Kb3ntQiQtymVF8pyZKYQrbO9fHGS0g=;
  b=Kgca31zA7FRXQOir9sDdUI5JQWnY0FZqrZRoff7z+HdhV+/esulRhpA0
   aAddjBdJpuD6VRkfW7zZMBI9Gomg3tj7poQsbqNhZVUSsJHCldJIpgZKg
   XoYrstKKyJ5J2bM1JplWeKglr2CnYAjBEy1ztXQdqYNHgFuVfW3NBYVMb
   BGoNFeRGKrXkxVLY/fVMLoBz+ovujjkxUihPuk4wN08s+TEhZDhs8673x
   0PjPwqFL2BedkBgQB4nuo+7fv5N51w7liR/bW/bZ+EC1S4eIe+Rk32XHP
   Zr+qVV85oVCgPsNrDwrMhbVYJ9YLAiRyCL5/I6JFdmmhjIwzoHi3WMUDM
   A==;
X-CSE-ConnectionGUID: x2V+UXAYQ/KnSQJ9WBv3rQ==
X-CSE-MsgGUID: Gs/Nf5KHQKe4JIFJ6PccrA==
X-IronPort-AV: E=McAfee;i="6700,10204,11164"; a="39304752"
X-IronPort-AV: E=Sophos;i="6.10,145,1719903600"; 
   d="scan'208";a="39304752"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Aug 2024 05:53:02 -0700
X-CSE-ConnectionGUID: mlQmjvzvR+C1vgsPJsJoQg==
X-CSE-MsgGUID: PD/B/CEbRpav2gNWOipzvA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,145,1719903600"; 
   d="scan'208";a="63669478"
Received: from mtkaczyk-mobl.ger.corp.intel.com (HELO localhost) ([10.246.29.120])
  by fmviesa004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Aug 2024 05:53:00 -0700
Date: Wed, 14 Aug 2024 14:52:55 +0200
From: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To: Yu Kuai <yukuai1@huaweicloud.com>
Cc: hch@infradead.org, song@kernel.org, linux-kernel@vger.kernel.org,
 linux-raid@vger.kernel.org, yukuai3@huawei.com, yi.zhang@huawei.com,
 yangerkun@huawei.com
Subject: Re: [PATCH RFC -next v2 05/41] md/md-bitmap: add 'sync_size' into
 struct md_bitmap_stats
Message-ID: <20240814145255.00002a30@linux.intel.com>
In-Reply-To: <20240814071113.346781-6-yukuai1@huaweicloud.com>
References: <20240814071113.346781-1-yukuai1@huaweicloud.com>
	<20240814071113.346781-6-yukuai1@huaweicloud.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 14 Aug 2024 15:10:37 +0800
Yu Kuai <yukuai1@huaweicloud.com> wrote:

> From: Yu Kuai <yukuai3@huawei.com>
> 
> To avoid dereferencing bitmap directly in md-cluster to prepare
> inventing a new bitmap.
> 
> BTW, also fix following checkpatch warnings:
> 
> WARNING: Deprecated use of 'kmap_atomic', prefer 'kmap_local_page' instead
> WARNING: Deprecated use of 'kunmap_atomic', prefer 'kunmap_local' instead
> 
> Signed-off-by: Yu Kuai <yukuai3@huawei.com>
> ---
>  drivers/md/md-bitmap.c  |  6 ++++++
>  drivers/md/md-bitmap.h  |  1 +
>  drivers/md/md-cluster.c | 25 +++++++++++++++----------
>  3 files changed, 22 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
> index 8a2411040d2f..9ff5ed250ba5 100644
> --- a/drivers/md/md-bitmap.c
> +++ b/drivers/md/md-bitmap.c
> @@ -2096,11 +2096,16 @@ EXPORT_SYMBOL_GPL(md_bitmap_copy_from_slot);
>  
>  int md_bitmap_get_stats(struct bitmap *bitmap, struct md_bitmap_stats *stats)
>  {
> +	bitmap_super_t *sb;
>  	struct bitmap_counts *counts;

Hi Kuai,

Use reversed christmas tree convention if possible :)



> diff --git a/drivers/md/md-bitmap.h b/drivers/md/md-bitmap.h
> index c8527ba38dfc..1a7ad2cf9f75 100644
> --- a/drivers/md/md-bitmap.h
> +++ b/drivers/md/md-bitmap.h
> @@ -237,6 +237,7 @@ struct bitmap {
>  struct md_bitmap_stats {
>  	unsigned long pages;
>  	unsigned long missing_pages;
> +	unsigned long sync_size;

Same here.

Anyway, LGTM.
Mariusz
