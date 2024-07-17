Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA14879952
	for <linux-raid@vger.kernel.org>; Wed, 17 Jul 2024 11:29:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721215794; cv=none; b=qigiooa/XLgsVOghgzkTzAlgfmkpZ9y0bQrM+jWQ+YN+R1DgKd+UHOVTlN7e/1SXFsFv+n/FnFGM6wBzg5kIhyxMxF7IjNaRT7aeiFMbuFUiIC5w4H+J0KE4DA99pBkTs+19nGcCJRHWqeXPo4GOIuAYpi4W4Od8YOSQK3HyuDM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721215794; c=relaxed/simple;
	bh=IphvDj77CkKXEtdj2pLFmmAy4jzcJU/XWYkU559pwuw=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=uwIvMN6TalTnx4PCYlZOXEyEwthlBCUzHWPurePy6kgL0r4ZwRS9Lulipv8pDPjWo1P/fitY00StguSPnnn2wC2eP6cHrPpf5A39HkA13ZAuU0VgridUfeeXHYJzcquv8FHJ6KSMwBZXO6QG02HD8Qy+QOVHj57Gd8EnF8l8skA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=eVO4IOCr; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="eVO4IOCr"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1721215793; x=1752751793;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=IphvDj77CkKXEtdj2pLFmmAy4jzcJU/XWYkU559pwuw=;
  b=eVO4IOCrIzq7YBsH6tWa9nD1bIJOGD+Zl9JitOXxoTWg28RYaVx8M2S3
   1Hj2zwdpGf7aa6QIFY1Froafp2FYLZZ+5/bwxvkLn5EfxorH8ya0O6hP/
   Yv0Eyd8cIlFjJN9pBFsmGBE6tJV+q0qt1MiZONygTyUVegsVaO1xRB915
   +KdcRCHzMFW0wYdtsIZvLGpcxDy4t6RBDxQOQO6z2GoAeSFqujiUzaTIR
   2SoMy0WUrTPCF8nx0g+QR+2bH1M2swKx1RDA8WGmBBn8zT1D2OXGt26Oy
   WUoi3FloIuII7A26/RWG0tuEZwBT3JHyH/fhvzmCk+82JgmkvgQNBys38
   w==;
X-CSE-ConnectionGUID: wN7rysbbTfi7uQmUSV05tw==
X-CSE-MsgGUID: Th+l5GFeTjm9+TVTZdFVtQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11135"; a="29322167"
X-IronPort-AV: E=Sophos;i="6.09,214,1716274800"; 
   d="scan'208";a="29322167"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jul 2024 04:29:52 -0700
X-CSE-ConnectionGUID: uQB2OLpMS9qEeIxcB/WguA==
X-CSE-MsgGUID: pl2lto6SS4mgRyV3fl3Jzw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,214,1716274800"; 
   d="scan'208";a="50259221"
Received: from mtkaczyk-mobl.ger.corp.intel.com (HELO localhost) ([10.245.82.157])
  by fmviesa008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jul 2024 04:29:51 -0700
Date: Wed, 17 Jul 2024 13:29:46 +0200
From: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To: Xiao Ni <xni@redhat.com>
Cc: ncroxon@redhat.com, linux-raid@vger.kernel.org
Subject: Re: [PATCH 03/15] mdadm/Grow: fix coverity issue RESOURCE_LEAK
Message-ID: <20240717132946.00002373@linux.intel.com>
In-Reply-To: <20240715073604.30307-4-xni@redhat.com>
References: <20240715073604.30307-1-xni@redhat.com>
	<20240715073604.30307-4-xni@redhat.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 15 Jul 2024 15:35:52 +0800
Xiao Ni <xni@redhat.com> wrote:

> Signed-off-by: Xiao Ni <xni@redhat.com>
> ---
>  Grow.c | 53 ++++++++++++++++++++++++++++++++++++++++-------------
>  1 file changed, 40 insertions(+), 13 deletions(-)
> 
> diff --git a/Grow.c b/Grow.c
> index 7ae967bda067..632be7db8d38 100644
> --- a/Grow.c
> +++ b/Grow.c
> @@ -485,6 +485,7 @@ int Grow_addbitmap(char *devname, int fd, struct context
> *c, struct shape *s) int bitmap_fd;
>  		int d;
>  		int max_devs = st->max_devs;
> +		int err = 0;
>  
>  		/* try to load a superblock */
>  		for (d = 0; d < max_devs; d++) {
> @@ -525,13 +526,14 @@ int Grow_addbitmap(char *devname, int fd, struct
> context *c, struct shape *s) return 1;
>  		}
>  		if (ioctl(fd, SET_BITMAP_FILE, bitmap_fd) < 0) {
> -			int err = errno;
> +			err = errno;
>  			if (errno == EBUSY)
>  				pr_err("Cannot add bitmap while array is
> resyncing or reshaping etc.\n"); pr_err("Cannot set bitmap file for %s: %s\n",
>  				devname, strerror(err));
> -			return 1;
>  		}
> +		close(bitmap_fd);
> +		return err;

I don't think that we should return errno. I would say that mdadm should define
returned statues for functions, that is why I added mdadm_status_t.

Otherwise, same value may have two meanings. For example, in some cases we are
fine with particular error code from error might be misleading (it may match
allowed status).
This is not the case here, it is just an example.

I think that we should not return errno outside if not intended i.e. function is
projected to return errno in every case.

>  	}
>  
>  	return 0;
> @@ -3083,6 +3085,7 @@ static int reshape_array(char *container, int fd, char
> *devname, int done;
>  	struct mdinfo *sra = NULL;
>  	char buf[SYSFS_MAX_BUF_SIZE];
> +	bool located_backup = false;
>  
>  	/* when reshaping a RAID0, the component_size might be zero.
>  	 * So try to fix that up.
> @@ -3165,8 +3168,10 @@ static int reshape_array(char *container, int fd, char
> *devname, goto release;
>  		}
>  
> -		if (!backup_file)
> +		if (!backup_file) {
>  			backup_file = locate_backup(sra->sys_name);
> +			located_backup = true;
> +		}
>  
>  		goto started;
>  	}
> @@ -3612,15 +3617,15 @@ started:
>  			mdstat_wait(30 - (delayed-1) * 25);
>  	} while (delayed);
>  	mdstat_close();
> -	if (check_env("MDADM_GROW_VERIFY"))
> -		fd = open(devname, O_RDONLY | O_DIRECT);
> -	else
> -		fd = -1;
>  	mlockall(MCL_FUTURE);
>  
>  	if (signal_s(SIGTERM, catch_term) == SIG_ERR)
>  		goto release;
>  
> +	if (check_env("MDADM_GROW_VERIFY"))
> +		fd = open(devname, O_RDONLY | O_DIRECT);
> +	else
> +		fd = -1;

close_fd() is used unconditionally on fd few line earlier so it seems that else
path is not needed but this code is massive so please double check if I'm right.

We may call close_fd() on the closed resource and then it is not updated to -1,
assuming that close fails with EBADF.

Right way to fix it is to replace all close(fd) by close_fd(fd). It will give is
credibility that double close is not possible.


>  	if (st->ss->external) {
>  		/* metadata handler takes it from here */
>  		done = st->ss->manage_reshape(
> @@ -3632,6 +3637,8 @@ started:
>  			fd, sra, &reshape, st, blocks, fdlist, offsets,
>  			d - odisks, fdlist + odisks, offsets + odisks);
>  
> +	if (fd >= 0)
> +		close(fd);
>  	free(fdlist);
>  	free(offsets);
>  
> @@ -3701,6 +3708,8 @@ out:
>  	exit(0);
>  
>  release:
> +	if (located_backup)
> +		free(backup_file);

>  	free(fdlist);
>  	free(offsets);
>  	if (orig_level != UnSet && sra) {
> @@ -3839,6 +3848,7 @@ int reshape_container(char *container, char *devname,
>  			pr_err("Unable to initialize sysfs for %s\n",
>  			       mdstat->devnm);
>  			rv = 1;
> +			close(fd);
>  			break;
>  		}
>  
> @@ -4717,6 +4727,7 @@ int Grow_restart(struct supertype *st, struct mdinfo
> *info, int *fdlist, unsigned long long *offsets;
>  	unsigned long long  nstripe, ostripe;
>  	int ndata, odata;
> +	int fd, backup_fd = -1;
>  
>  	odata = info->array.raid_disks - info->delta_disks - 1;
>  	if (info->array.level == 6)
> @@ -4732,9 +4743,18 @@ int Grow_restart(struct supertype *st, struct mdinfo
> *info, int *fdlist,
>  		 * been used
>  		 */
>  		old_disks = cnt;
> +
> +	if (backup_file) {
> +		backup_fd = open(backup_file, O_RDONLY);
> +		if (backup_fd < 0) {
> +			pr_err("Can't open backup file %s : %s\n",
> +				backup_file, strerror(errno));
> +			return -EINVAL;
> +		}
> +	}
> +
>  	for (i=old_disks-(backup_file?1:0); i<cnt; i++) {
>  		struct mdinfo dinfo;
> -		int fd;
>  		int bsbsize;
>  		char *devname, namebuf[20];
>  		unsigned long long lo, hi;
> @@ -4747,12 +4767,9 @@ int Grow_restart(struct supertype *st, struct mdinfo
> *info, int *fdlist,
>  		 * else restore data and update all superblocks
>  		 */
>  		if (i == old_disks-1) {
> -			fd = open(backup_file, O_RDONLY);
> -			if (fd<0) {
> -				pr_err("backup file %s inaccessible: %s\n",
> -					backup_file, strerror(errno));
> +			if (backup_fd < 0)
>  				continue;

You can use is_fd_valid(). Please also review other patches on that.

> -			}
> +			fd = backup_fd;
>  			devname = backup_file;
>  		} else {
>  			fd = fdlist[i];
> @@ -4907,6 +4924,8 @@ int Grow_restart(struct supertype *st, struct mdinfo
> *info, int *fdlist, pr_err("Error restoring backup from %s\n",
>  					devname);
>  			free(offsets);
> +			if (backup_fd >= 0)
> +				close(backup_fd);
we have close_fd() for that.

>  			return 1;
>  		}
>  
> @@ -4923,6 +4942,8 @@ int Grow_restart(struct supertype *st, struct mdinfo
> *info, int *fdlist, pr_err("Error restoring second backup from %s\n",
>  					devname);
>  			free(offsets);
> +			if (backup_fd >= 0)
> +				close(backup_fd);

You can use close_fd(). Also please analyze other patches on that.

>  			return 1;
>  		}
>  
> @@ -4984,8 +5005,14 @@ int Grow_restart(struct supertype *st, struct mdinfo
> *info, int *fdlist, st->ss->store_super(st, fdlist[j]);
>  			st->ss->free_super(st);
>  		}
> +		if (backup_fd >= 0)
> +			close(backup_fd);
>  		return 0;
>  	}
> +
> +	if (backup_fd >= 0)
> +		close(backup_fd);

As above (use close_fd())
> +
>  	/* Didn't find any backup data, try to see if any
>  	 * was needed.
>  	 */

Thanks,
Mariusz
