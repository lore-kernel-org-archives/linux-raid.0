Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F20445672;
	Mon, 13 May 2024 15:12:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715613164; cv=none; b=Yni7Gs//U0ShSIxZ3jJea3FmZvf8juV77B7pQzaOEiHu4tJXx6k9Um4liGtmE9bMAoTKKZ+bLAPOzEzXJDBQKww4e/EvrNWGif9pSL3MaBCeFHpE9G1Y0Y1U7ExhQj1uUJ1BMR8+krJoc7D8KlUR8nfZLfzAHk+Jsv8fuKFd+pQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715613164; c=relaxed/simple;
	bh=ynJ/pnM/GjNYy4Nt18Bb/K8F/EBJcsXYbqIjDqKLeAg=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dsiBDFZXOw8fnSYjfnLGh8k3PNmA5b2yFQC/R3QK5JB6PRmQ/Y97qjOdexaGj0e9hiBCJSNAcroELqdFft+mhnJw6oYE5NeSRXtcDyb5cE4H3xQd/w/dPb9WIpMH3c6PuZBEuQxixCRr3iD3xHZ+DHsrAYpB1VdFUQcKZGoMWPQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=J2pS4zid; arc=none smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="J2pS4zid"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1715613162; x=1747149162;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ynJ/pnM/GjNYy4Nt18Bb/K8F/EBJcsXYbqIjDqKLeAg=;
  b=J2pS4zidI5zQVXAFaPYOXxZDYZiukr5B0diA0sqwevC+G9IELlWICz6l
   Dk9pDXCOTXCVSpDO3hohfpE1ggvFluZ5vY5Gwzs8KdQSt7D/5tFRhQf7P
   PkJVuqGLgyq8Rtybnyqrz2Qn9xy80Ne0KkUOZYBlmzvLoi1JRQx8Xh5pb
   wnWFM902J1NR+0BRGOaVHWyilXTw9dsx1M/ZSXkyqyv1QlmYYLKsqNJgQ
   JITs1q54TE9j+859qs81Cf8bRADwcfhlVJ+6oV65hQ1RNGTu5tZYSjnco
   okWBxfGeN06pL8+wSsOLKMoCilE3EuuuZD/6c607/U3mZzHAljlB196au
   Q==;
X-CSE-ConnectionGUID: jTuS5JLpQ/qkRXu2dZu+OA==
X-CSE-MsgGUID: rkiN/lbpRWyQhDxniWmOkw==
X-IronPort-AV: E=McAfee;i="6600,9927,11072"; a="22223146"
X-IronPort-AV: E=Sophos;i="6.08,158,1712646000"; 
   d="scan'208";a="22223146"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 May 2024 08:12:41 -0700
X-CSE-ConnectionGUID: MNpgC/KdRVSO9VpxZreujg==
X-CSE-MsgGUID: lumNu1SMR0KQDOuZ2ColuA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,158,1712646000"; 
   d="scan'208";a="35056573"
Received: from mtkaczyk-mobl.ger.corp.intel.com (HELO localhost) ([10.245.98.108])
  by ORVIESA003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 May 2024 08:12:38 -0700
Date: Mon, 13 May 2024 17:12:33 +0200
From: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To: Yu Kuai <yukuai1@huaweicloud.com>
Cc: agk@redhat.com, snitzer@kernel.org, mpatocka@redhat.com,
 song@kernel.org, xni@redhat.com, dm-devel@lists.linux.dev,
 linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org,
 yukuai3@huawei.com, yi.zhang@huawei.com, yangerkun@huawei.com
Subject: Re: [PATCH md-6.10 1/9] md: rearrange recovery_flage
Message-ID: <20240513170958.00002282@linux.intel.com>
In-Reply-To: <20240509011900.2694291-2-yukuai1@huaweicloud.com>
References: <20240509011900.2694291-1-yukuai1@huaweicloud.com>
 <20240509011900.2694291-2-yukuai1@huaweicloud.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu,  9 May 2024 09:18:52 +0800
Yu Kuai <yukuai1@huaweicloud.com> wrote:

There is typo in subject.

> From: Yu Kuai <yukuai3@huawei.com>
> 
> Currently there are lots of flags and the names are confusing, since
> there are two main types of flags, sync thread runnng status and sync
> thread action, rearrange and update comment to improve code readability,
> there are no functional changes.
> 
> Signed-off-by: Yu Kuai <yukuai3@huawei.com>
> ---
>  drivers/md/md.h | 52 ++++++++++++++++++++++++++++++++++++-------------
>  1 file changed, 38 insertions(+), 14 deletions(-)
> 
> diff --git a/drivers/md/md.h b/drivers/md/md.h
> index 029dd0491a36..2a1cb7b889e5 100644
> --- a/drivers/md/md.h
> +++ b/drivers/md/md.h
> @@ -551,22 +551,46 @@ struct mddev {
>  };
>  
>  enum recovery_flags {
> +	/* flags for sync thread running status */
> +
> +	/*
> +	 * set when one of sync action is set and new sync thread need to be
> +	 * registered, or just add/remove spares from conf.
> +	 */
> +	MD_RECOVERY_NEEDED,
> +	/* sync thread is running, or about to be started */
> +	MD_RECOVERY_RUNNING,
> +	/* sync thread needs to be aborted for some reason */
> +	MD_RECOVERY_INTR,
> +	/* sync thread is done and is waiting to be unregistered */
> +	MD_RECOVERY_DONE,
> +	/* running sync thread must abort immediately, and not restart */
> +	MD_RECOVERY_FROZEN,
> +	/* waiting for pers->start() to finish */
> +	MD_RECOVERY_WAIT,
> +	/* interrupted because io-error */
> +	MD_RECOVERY_ERROR,
> +
> +	/* flags determines sync action */
> +
> +	/* if just this flag is set, action is resync. */
> +	MD_RECOVERY_SYNC,
> +	/*
> +	 * paired with MD_RECOVERY_SYNC, if MD_RECOVERY_CHECK is not set,
> +	 * action is repair, means user requested resync.
> +	 */
> +	MD_RECOVERY_REQUESTED,
>  	/*
> -	 * If neither SYNC or RESHAPE are set, then it is a recovery.
> +	 * paired with MD_RECOVERY_SYNC and MD_RECOVERY_REQUESTED, action is
> +	 * check.
>  	 */
> -	MD_RECOVERY_RUNNING,	/* a thread is running, or about to be
> started */
> -	MD_RECOVERY_SYNC,	/* actually doing a resync, not a recovery
> */
> -	MD_RECOVERY_RECOVER,	/* doing recovery, or need to try it. */
> -	MD_RECOVERY_INTR,	/* resync needs to be aborted for some
> reason */
> -	MD_RECOVERY_DONE,	/* thread is done and is waiting to be
> reaped */
> -	MD_RECOVERY_NEEDED,	/* we might need to start a
> resync/recover */
> -	MD_RECOVERY_REQUESTED,	/* user-space has requested a sync
> (used with SYNC) */
> -	MD_RECOVERY_CHECK,	/* user-space request for check-only, no
> repair */
> -	MD_RECOVERY_RESHAPE,	/* A reshape is happening */
> -	MD_RECOVERY_FROZEN,	/* User request to abort, and not
> restart, any action */
> -	MD_RECOVERY_ERROR,	/* sync-action interrupted because
> io-error */
> -	MD_RECOVERY_WAIT,	/* waiting for pers->start() to finish */
> -	MD_RESYNCING_REMOTE,	/* remote node is running resync thread
> */
> +	MD_RECOVERY_CHECK,
> +	/* recovery, or need to try it */
> +	MD_RECOVERY_RECOVER,
> +	/* reshape */
> +	MD_RECOVERY_RESHAPE,
> +	/* remote node is running resync thread */
> +	MD_RESYNCING_REMOTE,
>  };
>  
>  enum md_ro_state {

I don't know if it is better readable but I know that Kernel coding style comes
with different approach. I used it for enum mddev_flags in md.h please take a
look.

Also, I get used to comment above, not below enum values but I don't have strong
justification here.

Thanks,
Mariusz

