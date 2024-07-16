Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B0AFF9E8
	for <linux-raid@vger.kernel.org>; Tue, 16 Jul 2024 15:44:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721144668; cv=none; b=Jyeo4zygJjvDlLoYhtz1vDfKvorlTlSrMF7hSkH5eu1J4CjoYqupD8ZvEaCRpiRSRDqDbOy2pOzs8kfuAYAexTN20UskbpEF7L4xlUq5ib5ZBMxuiFc4CvrEwjUYd84gm2qGIwUC4xD7ojieWjdV8BJu+cwV4mZmXm+yqzXzX/8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721144668; c=relaxed/simple;
	bh=FH6lXjl/gAn1jQYAh6DdmZa0f+RM/699/lf9hZ6THYo=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=i6m277gSRnPV9RsUEdQ78guWnf3mYfhxMHjUC+0+UAGEWKdIyznq6BofsWZMDS6rlv/qsnK2y+FaftgPReva9ZT2JV9NszRu4GqW5usSFcsK/OshD44UO/MTsd4hn5UJ9XW7WJi4DXMWAkP0ClyQNELFmSgW/+MNeePw9gP0YAs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=XuzDWQ7+; arc=none smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="XuzDWQ7+"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1721144667; x=1752680667;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=FH6lXjl/gAn1jQYAh6DdmZa0f+RM/699/lf9hZ6THYo=;
  b=XuzDWQ7+t99Cg4tuoCjOZRRs9CHLSx+XxGQK6XniDaEL8YpqZGr3NuqK
   JQ1bWLf4xiisORZgdUmb/W+FTs/tC1WNkLjeWzVFqGAd5FTmhGopEJJfO
   bq8ZzcxCYDI41KR7kOF4GC4eh8/5AUssbE73b75yy2y5AdbpN3YEpQCMM
   kxsA3CNjgIsmaE81J64RJ79fd9tePOhkELCCGPURyn1iuIjBR+d43ExQV
   EMV4X/BDoFgumFDhp6YpVB5Bdt2VUn2+0T9FrDf1sXLx83yRW6CIVN3xb
   PI3qJtajJFUPD2KpGkUY+z9In5yteF/94PMjXfuxv+6/01e9HJSPj/6AC
   g==;
X-CSE-ConnectionGUID: d2KnagY/Q9CtlAClPoXAZw==
X-CSE-MsgGUID: 6grX7mKLS0K+L428kQRAJw==
X-IronPort-AV: E=McAfee;i="6700,10204,11135"; a="18742338"
X-IronPort-AV: E=Sophos;i="6.09,211,1716274800"; 
   d="scan'208";a="18742338"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jul 2024 08:44:26 -0700
X-CSE-ConnectionGUID: AAJt839rQneFo4kH6INetw==
X-CSE-MsgGUID: aQL8sekaRlGfVzQgCsSVLw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,211,1716274800"; 
   d="scan'208";a="50783158"
Received: from mtkaczyk-mobl.ger.corp.intel.com (HELO localhost) ([10.245.98.108])
  by orviesa008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jul 2024 08:44:24 -0700
Date: Tue, 16 Jul 2024 17:44:19 +0200
From: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To: Xiao Ni <xni@redhat.com>
Cc: ncroxon@redhat.com, linux-raid@vger.kernel.org
Subject: Re: [PATCH 01/15] mdadm/Manage: 01r1fail cases fails
Message-ID: <20240716174419.00002ffb@linux.intel.com>
In-Reply-To: <20240715073604.30307-2-xni@redhat.com>
References: <20240715073604.30307-1-xni@redhat.com>
	<20240715073604.30307-2-xni@redhat.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 15 Jul 2024 15:35:50 +0800
Xiao Ni <xni@redhat.com> wrote:

> This patch fixes a regression issue which is checked by 01r1fail case.
> 
> Fixes: 1b4b73fd535a ('mdadm: Manage.c fix coverity issues')
> Signed-off-by: Xiao Ni <xni@redhat.com>
> ---
>  Manage.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/Manage.c b/Manage.c
> index aa5e80b2805d..f0304e1e4d3d 100644
> --- a/Manage.c
> +++ b/Manage.c
> @@ -1333,7 +1333,7 @@ bool is_remove_safe(mdu_array_info_t *array, const int
> fd, char *devname, const 
>  	char *avail = xcalloc(array->raid_disks, sizeof(char));
>  
> -	for (disk = mdi->devs; disk; disk = mdi->next) {
> +	for (disk = mdi->devs; disk; disk = disk->next) {
>  		if (disk->disk.raid_disk < 0)
>  			continue;
>  		if (!(disk->disk.state & (1 << MD_DISK_SYNC)))

Hi Xiao,
I didn't looked into your serie and I fixed it myself today.

I will skip this patch then.

Thanks,
Mariusz

