Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43ED144C76
	for <linux-raid@vger.kernel.org>; Mon,  2 Sep 2024 09:55:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725270946; cv=none; b=M8ZPa+ajLJLGST0TKjbFgyWENj2+WLGTfdiaUUCo+P899epRynqSLracv6SNCQ2+aICAPvDqY4XgAtYjOBzWWkGIUoaawW3tw7iensiOIuMND4hXiMTMpRN3Q08+A7ltahbDr5BCkWZqkcAROHviHP0kGY0hGvfKmSsiVDbfSzU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725270946; c=relaxed/simple;
	bh=rAv8maKVDv1eoh3IrOcrIK3vUtjMSE1jj/v95KH97Rc=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=FoDmN5jzN3M06DL5XZ8VfSZLIX+sGFygIABQJAJkZtkLMMMlphjpcVXs6s57Zhaoip7zCB1hCNaaOOhZyvtDyMtC6hFuVpZ8AQQo2MGCPSt6tva++oe5nXFIl/egMo7VbzBjUK3xOsfNrnlgInOlSgHPFhxRhiSN8+Lvb91gS9U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=h/ypwKCy; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="h/ypwKCy"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1725270944; x=1756806944;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=rAv8maKVDv1eoh3IrOcrIK3vUtjMSE1jj/v95KH97Rc=;
  b=h/ypwKCySFTRCx+Zix3uo4Uv2++Gu50ZyRbzWYb/SY+NcAmjXoOjX7Ek
   YIUDOy7cBt2gdg/qoWIdfcFOyxokhdsXCZaPuSzMsNkwyqY2zcvEjvxvA
   9TChcV7VPezwMZRXdSC18eQ/uw5awQEQ9XmZ27yVD/nFjh8vC/UoexPAV
   aPQnTy0Rn1Yyk3mO5fDFWQME0QVZGr26BZKgTuN/ZPaZY6CXDEzZecpkF
   Ed5pbvnamMspXRUQ5DYNV9zZu/b/LSeMlp0zaUUwQztLFT1amHRdhLgCR
   pkHWgJ6U12/f2zc0RNk0x0xv6F6LfSeXO2wbWPglrtFefPgfGbaLbWlt6
   w==;
X-CSE-ConnectionGUID: ZTcWPWTGTG+RKOIBBK18mg==
X-CSE-MsgGUID: dvjavszPR8yzfklQmGbO2g==
X-IronPort-AV: E=McAfee;i="6700,10204,11182"; a="23357393"
X-IronPort-AV: E=Sophos;i="6.10,195,1719903600"; 
   d="scan'208";a="23357393"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Sep 2024 02:55:44 -0700
X-CSE-ConnectionGUID: iTXZvvR5QUqysIN3a+5J2g==
X-CSE-MsgGUID: wjTj0aaORAqqtbYqTzoSFg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,195,1719903600"; 
   d="scan'208";a="64915368"
Received: from unknown (HELO localhost) ([10.217.182.6])
  by orviesa006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Sep 2024 02:55:43 -0700
Date: Mon, 2 Sep 2024 11:55:37 +0200
From: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To: Xiao Ni <xni@redhat.com>
Cc: ncroxon@redhat.com, linux-raid@vger.kernel.org
Subject: Re: [PATCH 02/10] mdadm/Grow: Update reshape_progress to need_back
 after reshape finishes
Message-ID: <20240902115537.000046d4@linux.intel.com>
In-Reply-To: <20240828021150.63240-3-xni@redhat.com>
References: <20240828021150.63240-1-xni@redhat.com>
	<20240828021150.63240-3-xni@redhat.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 28 Aug 2024 10:11:42 +0800
Xiao Ni <xni@redhat.com> wrote:

> It tries to update data offset when kicking off reshape. If it can't
> change data offset, it needs to use child_monitor to monitor reshape
> progress and do back up job. And it needs to update reshape_progress
> to need_back when reshape finishes. If not, it will be in a infinite
> loop.
> 
> Signed-off-by: Xiao Ni <xni@redhat.com>
> ---
>  Grow.c | 13 +++++++++----
>  1 file changed, 9 insertions(+), 4 deletions(-)
> 
> diff --git a/Grow.c b/Grow.c
> index 97e48d86a33f..6b621aea4ecc 100644
> --- a/Grow.c
> +++ b/Grow.c
> @@ -4142,8 +4142,7 @@ int progress_reshape(struct mdinfo *info, struct
> reshape *reshape,
>  		 * waiting forever on a dead array
>  		 */
>  		char action[SYSFS_MAX_BUF_SIZE];
> -		if (sysfs_get_str(info, NULL, "sync_action", action,
> sizeof(action)) <= 0 ||
> -		    strncmp(action, "reshape", 7) != 0)
> +		if (sysfs_get_str(info, NULL, "sync_action", action,
> sizeof(action)) <= 0) break;

There must be empty line after declaration.


>  		/* Some kernels reset 'sync_completed' to zero
>  		 * before setting 'sync_action' to 'idle'.
> @@ -4151,12 +4150,18 @@ int progress_reshape(struct mdinfo *info, struct
> reshape *reshape, */
>  		if (completed == 0 && advancing &&
>  		    strncmp(action, "idle", 4) == 0 &&
> -		    info->reshape_progress > 0)
> +		    info->reshape_progress > 0) {
> +			info->reshape_progress = need_backup;
>  			break;
> +		}
>  		if (completed == 0 && !advancing &&
>  		    strncmp(action, "idle", 4) == 0 &&
>  		    info->reshape_progress <
> -		    (info->component_size * reshape->after.data_disks))
> +		    (info->component_size * reshape->after.data_disks)) {
> +			info->reshape_progress = need_backup;
> +			break;

This look weird to assign need_backup (suggests boolean field) to
reshape_progress but it is not your code so you have my ack.

Thanks,
Mariusz

> +		}
> +		if (strncmp(action, "reshape", 7) != 0)
>  			break;
>  		sysfs_wait(fd, NULL);
>  		if (sysfs_fd_get_ll(fd, &completed) < 0)

