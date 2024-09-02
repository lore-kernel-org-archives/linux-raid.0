Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC76A13AA20
	for <linux-raid@vger.kernel.org>; Mon,  2 Sep 2024 10:00:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725271220; cv=none; b=VqhqUzhqDtD6q3GLe/oewc0BiZTzEQSh8Avt17pzNLRdD6CiszdhanzV9xEkPL677sS07gVfl5Pp6/mFqF+hEungxag3pbmbY9kFS+FEvQNwMf04OMYzm1F/er2YB06vBP5DznufhRUdAes257HcbxLNJKVwDHipR6b9mln7ewg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725271220; c=relaxed/simple;
	bh=2TW6fWLWq3Q6Qz0YnWe7l6Ufws5jaCgMNJ/ZU5mdnc0=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=F7aG408qrbt3mpXTKCXmE3VqdIz3f0FH1NiWQKIBen+Bscd4dIoAQFcVlIdqnpGo2WDpeuV8kK5W4VryIHBQreKk7HV/unXqMYft9Jl4lEVBWUKjL1SSlbtlNvZtAhaOn9M6DL1GZ8KgMfHz+8EsWUE7fNpO4MG6ex4qCmstSxc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Sv3RWpQv; arc=none smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Sv3RWpQv"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1725271218; x=1756807218;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=2TW6fWLWq3Q6Qz0YnWe7l6Ufws5jaCgMNJ/ZU5mdnc0=;
  b=Sv3RWpQv0qTicRdpHui0JasALwyPfqWX8ptvY+rcXlkdFNYhusxlAb9S
   WDOFvfCCudWASC0dug0n7gxcwZZAW4fEUnqH4vIO0seZofuU6jZTI/9Zp
   iK39qRVioDelSlqEs9UJTIOldEaAvhlXih4ovfol30khryyMtedAMyK0O
   8st02+fzNTD3u6Ar6uC6B9hkhZ7DCKMWDQVypwPvGzb3ERBPBjAPqwiNx
   7sWn3NEvePpIZxwhVE+g13VropJ8/ZxfbvdBZB6o3Y0NKIkbhmq1VaDv+
   a/AMnjcD/tJ6sb+1wzRl/hu48Ic47w5QIuxy5xwnwOn34ss3ECSmFdIG6
   g==;
X-CSE-ConnectionGUID: yT58xR+oSzeHzW5aIejzvQ==
X-CSE-MsgGUID: BA25BBF2SWOy62GIAA/sSg==
X-IronPort-AV: E=McAfee;i="6700,10204,11182"; a="24026578"
X-IronPort-AV: E=Sophos;i="6.10,195,1719903600"; 
   d="scan'208";a="24026578"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Sep 2024 03:00:18 -0700
X-CSE-ConnectionGUID: rJiBkKcaSeSBRIahz0FfzA==
X-CSE-MsgGUID: YiDCkHJ3Rzm9IJH/K9KCug==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,195,1719903600"; 
   d="scan'208";a="95370599"
Received: from unknown (HELO localhost) ([10.217.182.6])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Sep 2024 03:00:16 -0700
Date: Mon, 2 Sep 2024 12:00:12 +0200
From: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To: Xiao Ni <xni@redhat.com>
Cc: ncroxon@redhat.com, linux-raid@vger.kernel.org
Subject: Re: [PATCH 03/10] mdadm/Grow: Can't open raid when running --grow
 --continue
Message-ID: <20240902120012.00000653@linux.intel.com>
In-Reply-To: <20240828021150.63240-4-xni@redhat.com>
References: <20240828021150.63240-1-xni@redhat.com>
	<20240828021150.63240-4-xni@redhat.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 28 Aug 2024 10:11:43 +0800
Xiao Ni <xni@redhat.com> wrote:

> It passes 'array' as devname in Grow_continue. So it fails to
> open raid device. Use mdinfo to open raid device.
> 
> Signed-off-by: Xiao Ni <xni@redhat.com>
> ---
>  Grow.c | 9 ++++++---
>  1 file changed, 6 insertions(+), 3 deletions(-)
> 
> diff --git a/Grow.c b/Grow.c
> index 6b621aea4ecc..2a7587315817 100644
> --- a/Grow.c
> +++ b/Grow.c
> @@ -3688,9 +3688,12 @@ started:
>  		set_array_size(st, info, info->text_version);
>  
>  	if (info->new_level != reshape.level) {
> -		if (fd < 0)
> -			fd = open(devname, O_RDONLY);
> -		impose_level(fd, info->new_level, devname, verbose);
> +		fd = open_dev(sra->sys_name);
> +		if (fd < 0) {
> +			pr_err("Can't open %s\n", sra->sys_name);
> +			goto out;
> +		}
> +		impose_level(fd, info->new_level, sra->sys_name, verbose);
>  		close(fd);
>  		if (info->new_level == 0)
>  			st->update_tail = NULL;

You can consider declaring fd locally (inside if) but it is fine anyway.
You can also switch close(fd) to close_fd(&fd); because this resource is
probably reused later in the function body.

Anyway, LGTM but I will run my internal IMSM test suite to confirm that there is
no regression for IMSM before I will merge patchset.

Thanks,
Mariusz
