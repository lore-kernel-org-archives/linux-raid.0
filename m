Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EBC744C76
	for <linux-raid@vger.kernel.org>; Mon,  2 Sep 2024 09:50:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725270622; cv=none; b=Adokswl/fYCrD8BqmhABE23E8+RYc1tg9cFkKJCu787/1FbsieNborOMoe321zShphSsvnD+FG41NnkJTufERwFElSESNY7w6Dk2/VbRygkWA/GGLy9EjXsWrxbEI2Hl17fUNQDiUzImrJoz/uj+3dZoEUBiPfRO4r8A6uTy00o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725270622; c=relaxed/simple;
	bh=wbyNCqZJcfE+WN/wzR2dVRBw4oMiqzEbh+rjreBBa8Y=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YOJehrxTwXTsWn8oD9wXaPake7NL3P33DL+0uO18ABKnYAcvVBn9CyxfjEqq5eoFmLdJFyLKXuD8lGvWo2bbL7VLJtFHJr0+WRo5RvsZs1eOqKwMLDOXZ6OitgL4jk9JRf5623Ucia17Xum+cioLYiYDYhw9LMLFVmqxtHSq3hc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=TvPFj1+v; arc=none smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="TvPFj1+v"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1725270620; x=1756806620;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=wbyNCqZJcfE+WN/wzR2dVRBw4oMiqzEbh+rjreBBa8Y=;
  b=TvPFj1+v8Blw83SralyQa2EBFH+vHidi9KgN1fN3TzNvp+umTxrf0LXr
   TxfRa//DUudp0YxP6hFZvfWzvbY9cnoxEL16MF2wgiACNhnVbkEt7wmmd
   5EOw0oFUS7PRluvLoO9jzVr/+AcHbXa92owWQzgUOdBDe3TIRAn7BMR68
   gVCO+6Qp8H+aPVfA9HaI8JsnNlzz8nAsee8HydvA46M+3RgdW8pp+TjGJ
   Ff0KhNtPfSHC1vXmbJNiaM02uYbunvK4e4KBagMv6d6IO+LcrdcBw4JS5
   whEHuqnmfBKhUJkpDDFofF0ri5ytD7Uyi7DZ5mgkI5d56ojhQyHxtDDdB
   g==;
X-CSE-ConnectionGUID: tPMc/dhvS4mcW8lExpdvvg==
X-CSE-MsgGUID: rerdpdecR2unx4spWFZazw==
X-IronPort-AV: E=McAfee;i="6700,10204,11182"; a="34503743"
X-IronPort-AV: E=Sophos;i="6.10,195,1719903600"; 
   d="scan'208";a="34503743"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Sep 2024 02:50:19 -0700
X-CSE-ConnectionGUID: xyEh8X/nTyymEvYBTx2BgQ==
X-CSE-MsgGUID: mGxUyAuqRVO1cS/eFpjoeA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,195,1719903600"; 
   d="scan'208";a="65282404"
Received: from unknown (HELO localhost) ([10.217.182.6])
  by orviesa008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Sep 2024 02:50:18 -0700
Date: Mon, 2 Sep 2024 11:50:13 +0200
From: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To: Xiao Ni <xni@redhat.com>
Cc: ncroxon@redhat.com, linux-raid@vger.kernel.org
Subject: Re: [PATCH 01/10] mdadm/Grow: Update new level when starting
 reshape
Message-ID: <20240902115013.00006343@linux.intel.com>
In-Reply-To: <20240828021150.63240-2-xni@redhat.com>
References: <20240828021150.63240-1-xni@redhat.com>
 <20240828021150.63240-2-xni@redhat.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

Hi Xiao,
Thanks for patches.

On Wed, 28 Aug 2024 10:11:41 +0800
Xiao Ni <xni@redhat.com> wrote:

> Reshape needs to specify a backup file when it can't update data offset
> of member disks. For this situation, first, it starts reshape and then
> it kicks off mdadm-grow-continue service which does backup job and
> monitors the reshape process. The service is a new process, so it needs
> to read superblock from member disks to get information.

Looks like kernel is fine with reset the same level so I don't see a risk in
this change for other scenarios but please mention that.

> 
> But in the first step, it doesn't update new level in superblock. So
> it can't change level after reshape finishes, because the new level is
> not right. So records the new level in the first step.

> 
> Signed-off-by: Xiao Ni <xni@redhat.com>
> ---
>  Grow.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/Grow.c b/Grow.c
> index 5810b128aa99..97e48d86a33f 100644
> --- a/Grow.c
> +++ b/Grow.c
> @@ -2946,6 +2946,9 @@ static int impose_reshape(struct mdinfo *sra,
>  		if (!err && sysfs_set_num(sra, NULL, "layout",
>  					  reshape->after.layout) < 0)
>  			err = errno;
> +		if (!err && sysfs_set_num(sra, NULL, "new_level",
> +					info->new_level) < 0)
> +			err = errno;

Please add empty line before and after and please merge if statement to one
line (we support up to 100).


>  		if (!err && subarray_set_num(container, sra, "raid_disks",
>  					     reshape->after.data_disks +
>  					     reshape->parity) < 0)


Thanks,
Mariusz
