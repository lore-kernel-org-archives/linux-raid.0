Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3661E3E48C
	for <linux-raid@vger.kernel.org>; Fri, 22 Mar 2024 11:18:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711106306; cv=none; b=YF3t7rvXQZw+THMHBY9vwEc4nTJ6xtGOQCq7shC8KrBCgYg/ui/Vh1WY1MJOKqJcHDHQIWjwQno5c8g+vzM11XG2VOQDs1TVgszsC2DDImBSvtivq4FFvXfCcVoDKYaDGe6PCofJK/lnVMpaEKBviEf+FHHZExFeZk9+8m/IY6k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711106306; c=relaxed/simple;
	bh=mXFqdq+ZVRC3Ucs/ZClaZPjY5W3c+OSMX29VEqVdC+w=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Of/tR1RJJG5bXrKP/tetny/8mR73Phr656K5bvjrFZG4puWzI7p63f1WyxsCCMWGCu+jOLRZr1J6jWvmWmvvMIexEt1yib60n/515q3BRsFRwITd/SemEsKwLaYot6vSduGluQNF6GoaMdkNJAGZalZHe+8wWYmA7lDTzCR3DCk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Z3RHx9vk; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Z3RHx9vk"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1711106305; x=1742642305;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=mXFqdq+ZVRC3Ucs/ZClaZPjY5W3c+OSMX29VEqVdC+w=;
  b=Z3RHx9vkaoJh6ElXZ3h+37XHbN9u5sW5TnAOipGc+O5O97as35pl7C8K
   vbpWbLTZBhOldK+qGDZI7Oi471xEkzpCtAIGRGID8kNHboFfEJ7ElTKMJ
   dmb8dEpWIiKiuOIDBdFAOOeBMAb0VokgmEMll9tW7BFf+9jVk/bLRIoAW
   Ors5sGLT4kV18mrtPXYz1Zo1GKf11d1g9QHC65shaX91zhOD9PGjpHlGE
   V3BXS5pT+3siE3FRvKCODN+nIL62g2Y0umtlQpMDrCPhCziobHc6NXWo4
   jH086Ol8JcmJutUkxpk/eX3P/e6jcnS0Ig9atShEj1XmC2v5xY5YG7o3g
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,11020"; a="5976422"
X-IronPort-AV: E=Sophos;i="6.07,145,1708416000"; 
   d="scan'208";a="5976422"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Mar 2024 04:18:25 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,145,1708416000"; 
   d="scan'208";a="19579654"
Received: from mtkaczyk-mobl.ger.corp.intel.com (HELO localhost) ([10.246.17.194])
  by ORVIESA003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Mar 2024 04:18:23 -0700
Date: Fri, 22 Mar 2024 12:18:18 +0100
From: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To: linux-raid@vger.kernel.org
Cc: Xiao Ni <xni@redhat.com>, Jes Sorensen <jes@trained-monkey.org>
Subject: Re: [PATCH 0/2] mdadm: Fix --detail --export issue
Message-ID: <20240322121818.0000404a@linux.intel.com>
In-Reply-To: <20240318151930.8218-1-mariusz.tkaczyk@linux.intel.com>
References: <20240318151930.8218-1-mariusz.tkaczyk@linux.intel.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 18 Mar 2024 16:19:28 +0100
Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com> wrote:

> Commit 60c19530dd7c ("Detail: remove duplicated code") introduced
> regression catched by 00confnames because generated UUID was different
> than expected. This patchset fixes the issue.
> 
> Mariusz Tkaczyk (2):
>   mdadm: set swapuuid in all handlers
>   mdadm: Fix native --detail --export
> 
> Cc: Xiao Ni <xni@redhat.com>
> Cc: Jes Sorensen <jes@trained-monkey.org>
> 
>  Detail.c      | 26 +++++++++++++++++++++++++-
>  mdadm.h       |  3 +--
>  super-ddf.c   | 11 ++++++-----
>  super-intel.c | 17 +++++++++--------
>  super0.c      |  2 ++
>  util.c        | 24 +++++++++++++-----------
>  6 files changed, 56 insertions(+), 27 deletions(-)
> 

Applied! 

Thanks,
Mariusz
