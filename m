Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B45C623BD0B
	for <linux-raid@vger.kernel.org>; Mon, 24 Feb 2025 13:15:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740402961; cv=none; b=mIb5qzXVh2rBOlbHWdsyupr77bELa5SgBcS7m7wrl9FWyC1iqY9Wr8Ao8AV7/J099TG6lx4L+u/otWyDHHMP/cDupRk7CVl2Gk1nsH9HqdqnAvKbmiw3GBm3n8IARNavCeaEzaNfKW9o7m4S5yw0PIYyoNtSt8eguBOEBPz9qoE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740402961; c=relaxed/simple;
	bh=bmTUhNhqXemabv76zxFSUgiY0HLsKShsrx6J8FHEOkc=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fH6f9wMtlm5uhMh1v/zTuSf5zFW2/kCfgiioa6jgBp867vd2F6f04HQ9YU/h7cVnF6jps2tqGCUd7VzhlclVnCJi93mhdp0765jYP+akyyHi0iBgu+6dmFKOmds213B2fwZPCLOK7MbCLoKnpbn3tVskvMfKjTSob0cnXyDVD0o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ZWitXMC2; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ZWitXMC2"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1740402960; x=1771938960;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=bmTUhNhqXemabv76zxFSUgiY0HLsKShsrx6J8FHEOkc=;
  b=ZWitXMC2h+VxtVk7pvgL9Z7vIOcJu41CHBhPUFbzcf2h/TBO4XE11cF3
   HJVoVRejS0YC6HSn6mGMRee9NPYMq6k334wieEM6U4VaufpyPTtOhY0pQ
   3o+W7R9cXtkFVqE0YLCnY0iT/dcuuNemEOoQzv/VL1ILoRm3Q0yv8c/Pe
   KQXZKuXiK+0dtruqY+9Otb1zstiMO7PNgycDyF8gxCDggLYSgfNC4LpW0
   tapiCemJL5Bc53UWXK3yc9L2HWxR76z9EKOUAItugKMa0WUbJv4aV0WFL
   IZN5NC3SnqUKE5pKubwBtyIogjA7Wa9UKRFjqgyJRJekgHhHauqjX5Rgq
   A==;
X-CSE-ConnectionGUID: aPo6JFZET1ig95pJ0OyW4A==
X-CSE-MsgGUID: B4/iqsO2RcO040JekFWVmg==
X-IronPort-AV: E=McAfee;i="6700,10204,11355"; a="40392310"
X-IronPort-AV: E=Sophos;i="6.13,309,1732608000"; 
   d="scan'208";a="40392310"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Feb 2025 05:15:59 -0800
X-CSE-ConnectionGUID: 7HNHRAgSQkmtKcgnhMpCkA==
X-CSE-MsgGUID: BI9aX1NgQ5+6jTbgwfijEQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="116542755"
Received: from unknown (HELO localhost) ([10.217.182.253])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Feb 2025 05:15:57 -0800
Date: Mon, 24 Feb 2025 14:15:41 +0100
From: Blazej Kucman <blazej.kucman@linux.intel.com>
To: Junxiao Bi <junxiao.bi@oracle.com>
Cc: mtkaczyk@kernel.org, linux-raid@vger.kernel.org, ncroxon@redhat.com,
 song@kernel.org, xni@redhat.com, yukuai@kernel.org
Subject: Re: [PATCH V2] mdmon: imsm: fix metadata corruption when managing
 new array
Message-ID: <20250224141541.000042f1@linux.intel.com>
In-Reply-To: <20250218184831.19694-1-junxiao.bi@oracle.com>
References: <20250218184831.19694-1-junxiao.bi@oracle.com>
Organization: intel
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 18 Feb 2025 10:48:31 -0800
Junxiao Bi <junxiao.bi@oracle.com> wrote:

> When manager thread detects new array, it will invoke manage_new().
> For imsm array, it will further invoke imsm_open_new(). Since
> commit bbab0940fa75("imsm: write bad block log on metadata sync"),
> it preallocates bad block log when opening the array, that requires
> increasing the mpb buffer size.
> For that, imsm_open_new() invokes function
> imsm_update_metadata_locally(), which first uses
> imsm_prepare_update() to allocate a larger mpb buffer and store it at
> "mpb->next_buf", and then invoke imsm_process_update() to copy the
> content from current mpb buffer "mpb->buf" to "mpb->next_buf", and
> then free the current mpb buffer and set the new buffer as current.
> 
> There is a small race window, when monitor thread is syncing metadata,
> it gets current buffer pointer in
> imsm_sync_metadata()->write_super_imsm(), but before flushing the
> buffer to disk, manager thread does above switching buffer which
> frees current buffer, then monitor thread will run into
> use-after-free issue and could cause on-disk metadata corruption. If
> system keeps running, further metadata update could fix the
> corruption, because after switching buffer, the new buffer will
> contain good metadata, but if panic/power cycle happens while disk
> metadata is corrupted, the system will run into bootup failure if
> array is used as root, otherwise the array can not be assembled after
> boot if not used as root.
> 
> This issue will not happen for imsm array with only one member array,
> because the memory array has not be opened yet, monitor thread will
> not do any metadata updates.
> This can happen for imsm array with at lease two member array, in the
> following two scenarios:
> 1. Restarting mdmon process with at least two member array
> This will happen during system boot up or user restart mdmon after
> mdadm upgrade
> 2. Adding new member array to exist imsm array with at least one
> member array.
> 
> To fix this, delay the switching buffer operation to monitor thread.
> 
> Fixes: bbab0940fa75("imsm: write bad block log on metadata sync")
> Signed-off-by: Junxiao Bi <junxiao.bi@oracle.com>
> ---
> v2 <- v1:
>  - address code style in manage_new()
>  - make lines of git log not over 75 characters
> 
>  managemon.c   | 10 ++++++++--
>  super-intel.c | 14 +++++++++++---
>  2 files changed, 19 insertions(+), 5 deletions(-)
> 
> diff --git a/managemon.c b/managemon.c
> index d79813282457..74b64bfc9613 100644
> --- a/managemon.c
> +++ b/managemon.c
> @@ -721,11 +721,12 @@ static void manage_new(struct mdstat_ent
> *mdstat,
>  	 * the monitor.
>  	 */
>  
> +	struct metadata_update *update = NULL;
>  	struct active_array *new = NULL;
>  	struct mdinfo *mdi = NULL, *di;
> -	int i, inst;
> -	int failed = 0;
>  	char buf[SYSFS_MAX_BUF_SIZE];
> +	int failed = 0;
> +	int i, inst;
>  
>  	/* check if array is ready to be monitored */
>  	if (!mdstat->active || !mdstat->level)
> @@ -824,9 +825,14 @@ static void manage_new(struct mdstat_ent *mdstat,
>  	/* if everything checks out tell the metadata handler we
> want to
>  	 * manage this instance
>  	 */
> +	container->update_tail = &update;
>  	if (!aa_ready(new) || container->ss->open_new(container,
> new, inst) < 0) {
> +		container->update_tail = NULL;
>  		goto error;
>  	} else {
> +		if (update)
> +			queue_metadata_update(update);
> +		container->update_tail = NULL;
>  		replace_array(container, victim, new);
>  		if (failed) {
>  			new->check_degraded = 1;
> diff --git a/super-intel.c b/super-intel.c
> index cab841980830..4988eef191da 100644
> --- a/super-intel.c
> +++ b/super-intel.c
> @@ -8467,12 +8467,15 @@ static int imsm_count_failed(struct
> intel_super *super, struct imsm_dev *dev, return failed;
>  }
>  
> +static int imsm_prepare_update(struct supertype *st,
> +			       struct metadata_update *update);
>  static int imsm_open_new(struct supertype *c, struct active_array *a,
>  			 int inst)
>  {
>  	struct intel_super *super = c->sb;
>  	struct imsm_super *mpb = super->anchor;
> -	struct imsm_update_prealloc_bb_mem u;
> +	struct imsm_update_prealloc_bb_mem *u;
> +	struct metadata_update mu;
>  
>  	if (inst >= mpb->num_raid_devs) {
>  		pr_err("subarry index %d, out of range\n", inst);
> @@ -8482,8 +8485,13 @@ static int imsm_open_new(struct supertype *c,
> struct active_array *a, dprintf("imsm: open_new %d\n", inst);
>  	a->info.container_member = inst;
>  
> -	u.type = update_prealloc_badblocks_mem;
> -	imsm_update_metadata_locally(c, &u, sizeof(u));
> +	u = xmalloc(sizeof(*u));
> +	u->type = update_prealloc_badblocks_mem;
> +	mu.len = sizeof(*u);
> +	mu.buf = (char *)u;
> +	imsm_prepare_update(c, &mu);
> +	if (c->update_tail)
> +		append_metadata_update(c, u, sizeof(*u));
>  
>  	return 0;
>  }

Hi Junxiao,

LGTM, Approved

Thanks,
Blazej

