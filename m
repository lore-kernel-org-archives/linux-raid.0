Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62FD41CEE98
	for <linux-raid@vger.kernel.org>; Tue,  5 Nov 2024 08:16:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730794568; cv=none; b=eYeqfJrdjpdQDuT+VCgpd4xG9RS4bEZJisLwQqfXeGQjZH11qZXeyck8B7vXwtFca22Xig4zgcDTzoYQsqZZbkE26p6bVTOsUpfX75DsMwSIhwJaD+US4UlUrV+v6mKd9wugQD0DfewLVU3RNxHuZbdXCKalJjNQJ4FRBDXAkrU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730794568; c=relaxed/simple;
	bh=L59qzXqAKO/bSmZk/TRdr81fIwsT2epF1KLv+tnelvs=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=phBF6EdjzIwcntBAIIwzpxh+Mff8qZCJ60p4gMOIp6kadQ9TLcoVf3dOZhGOtoOA4BXQipsDvLwo256uEq8+4IZOwuAFgkp96gu/J9KuOGnk0Xczxy9PCcTeqihx3cS/WEowiTnW+9nklM1xfw+hBD9cIZc37iNge7qPFkORxJY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=VS/+ksQJ; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="VS/+ksQJ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730794567; x=1762330567;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=L59qzXqAKO/bSmZk/TRdr81fIwsT2epF1KLv+tnelvs=;
  b=VS/+ksQJvKeY4O8e6rdkI/0TwCNUHnH64QuKchg1kFw0VHpvvdb1Ua7X
   xnzA0WmlGChMcsiy1S/hssk8h6LdDWc9p5Z+q1auC142ckQHqymEzWfbD
   97i4aBc29XT5IMR089oZZQwVfp25Jg+pfB+oHVDrhvv9c+0Fc9OiJAHSR
   XUFQO6fS9Frd67S7kUnG2aDS3jUT9LQZjTa24EINdF5wyxudipyX0YkBs
   dpTuRtELjMBH21UUlWwtwEBDInT4LNl3TlEUW3/xTQteLxs39ZkaQtoql
   tVPmK/YWpK+HSDSu3TrkPgl/jCZ9/E7z/NuAMXSm64Pd/edEMvGY41ieF
   w==;
X-CSE-ConnectionGUID: lMtLtjpyS+yMPv3SiyyN3g==
X-CSE-MsgGUID: Coc0csnISYuM5s9reHzRpg==
X-IronPort-AV: E=McAfee;i="6700,10204,11246"; a="41119479"
X-IronPort-AV: E=Sophos;i="6.11,259,1725346800"; 
   d="scan'208";a="41119479"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Nov 2024 00:16:07 -0800
X-CSE-ConnectionGUID: Kr5HiJNbTeO7LdyZPdMn5A==
X-CSE-MsgGUID: JegMsm+OQwuQMLS6xH0WvQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,259,1725346800"; 
   d="scan'208";a="88434284"
Received: from mtkaczyk-mobl.ger.corp.intel.com (HELO localhost) ([10.245.96.80])
  by fmviesa005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Nov 2024 00:16:05 -0800
Date: Tue, 5 Nov 2024 09:16:01 +0100
From: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To: Xiao Ni <xni@redhat.com>
Cc: song@kernel.org, yukuai3@huawei.com, linux-raid@vger.kernel.org
Subject: Re: [PATCH RFC 1/1] md: Use pers->quiesce in mddev_suspend
Message-ID: <20241105091601.00001267@linux.intel.com>
In-Reply-To: <20241105075733.66101-1-xni@redhat.com>
References: <20241105075733.66101-1-xni@redhat.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue,  5 Nov 2024 15:57:33 +0800
Xiao Ni <xni@redhat.com> wrote:

> One customer reports a bug: raid5 is hung when changing thread cnt
> while resync is running. The stripes are all in conf->handle_list
> and new threads can't handle them.

Is issue fixed with this patch? Is is missing here :)
> 
> Commit b39f35ebe86d ("md: don't quiesce in mddev_suspend()") removes
> pers->quiesce from mddev_suspend/resume, then we can't guarantee sync
> requests finish in suspend operation. One personality knows itself the
> best. So pers->quiesce is a proper way to let personality quiesce.

> 
> Fixes: b39f35ebe86d ("md: don't quiesce in mddev_suspend()")
> Signed-off-by: Xiao Ni <xni@redhat.com>
> ---
>  drivers/md/md.c | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 67108c397c5a..7409ecb2df68 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -482,6 +482,9 @@ int mddev_suspend(struct mddev *mddev, bool interruptible)
>  		return err;
>  	}
>  
> +	if (mddev->pers)
> +		mddev->pers->quiesce(mddev, 1);
> +

Shouldn't it be implemented as below? According to b39f35ebe86d, some levels are
not implementing this?

+	if (mddev->pers && mddev->pers->quiesce)
+		mddev->pers->quiesce(mddev, 1);

Is it reproducible with upstream kernel?

Thanks,
Mariusz
