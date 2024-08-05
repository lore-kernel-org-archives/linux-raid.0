Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B74FB14F9D4
	for <linux-raid@vger.kernel.org>; Mon,  5 Aug 2024 09:20:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722849622; cv=none; b=JcKbfmO6wIZg5on6Lk521Ut0SRJAwmY/zgy9t0AjrrZBVxnRx6t/VZiCeRQJiSN8CANwmBCPfkQ5kevAdRS/H58J8WSo3ttVM0FHeTJUayAYBQmejzbey0mJpWw9fg+D/6adZzZEi7c6S1ALEQ+sNhezi44RXUKEV+UhixR+ksA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722849622; c=relaxed/simple;
	bh=le6BcdvVrqVqAxoV27Vlw+e/oTikbNOvcldO42tNNeA=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=P4MhJ/5BFr8a14cK1F/nznQYzlPPvEPVmIq78lCleWMOUyyfTFAWOCW04o9NFAITXnBUSK4sURZyYd/f8m7MGwzHg1xzTsGH+9wboPGTkYSZEQtFt2dfNQNepAJISyvPsqgypzgjbS7jC+QoCndlFHT2n13CQpHUFg3YcbDzj1k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=UZLsxA+3; arc=none smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="UZLsxA+3"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1722849621; x=1754385621;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=le6BcdvVrqVqAxoV27Vlw+e/oTikbNOvcldO42tNNeA=;
  b=UZLsxA+3yAj2UIctjyAynMu1LngjoVqR+htn1FjVO4p7f78V0OZnqyNf
   3jgJcC5IPXQv8H6SxNIT4F8YK/keeJG/fWcyusqIjVlSDhOB7+AZf3u2L
   bE4Ev9NIpa/6ftKnWTHF93e3qPaoefxNFYr2KNKUbgadH6/3jhh0KyLrK
   v1bEHTzZl+o6DIJZSBxxFVPC/Hdd7n33kvZzd+xuJRww0n4iwsxjdNkfh
   TQVRpXYHNk4Ku7GmM9gplQshySTBgfRJdH8kiQ72uTdaayDimIBNqqsIB
   1hsSScJFhgWPXQ6YxHALgw3mi8vssEPn1mHm4W9E+CSczehA0RdoDNgic
   w==;
X-CSE-ConnectionGUID: AnbpfEdAT3Gjnq9HGkC+6Q==
X-CSE-MsgGUID: pSfUW8TET1i7P2zxFVQ5lA==
X-IronPort-AV: E=McAfee;i="6700,10204,11154"; a="20966878"
X-IronPort-AV: E=Sophos;i="6.09,264,1716274800"; 
   d="scan'208";a="20966878"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Aug 2024 02:20:20 -0700
X-CSE-ConnectionGUID: tyGy2FBrRQm4HVKzY6SkKQ==
X-CSE-MsgGUID: 0Y+Iwl1ATQ+nXmSOMLdoeQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,264,1716274800"; 
   d="scan'208";a="55770966"
Received: from mtkaczyk-mobl.ger.corp.intel.com (HELO localhost) ([10.245.98.108])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Aug 2024 02:20:18 -0700
Date: Mon, 5 Aug 2024 11:20:14 +0200
From: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To: Xiao Ni <xni@redhat.com>
Cc: ncroxon@redhat.com, linux-raid@vger.kernel.org
Subject: Re: [PATCH V4 00/14] mdadm: fix coverity issues
Message-ID: <20240805112014.0000632b@linux.intel.com>
In-Reply-To: <20240726071416.36759-1-xni@redhat.com>
References: <20240726071416.36759-1-xni@redhat.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 26 Jul 2024 15:14:02 +0800
Xiao Ni <xni@redhat.com> wrote:

> V2: replace close with close_fd and use is_fd_valid
> V3: Fix errors reported by checkpatch
> V4:
> don't need check fd is valid before close_fd
> replace strcat with snprintf
> replace dev_name with dev_path_name
> 
> Xiao Ni (14):
>   mdadm/Grow: fix coverity issue CHECKED_RETURN
>   mdadm/Grow: fix coverity issue RESOURCE_LEAK
>   mdadm/Grow: fix coverity issue STRING_OVERFLOW
>   mdadm/Incremental: fix coverity issues.
>   mdadm/mdmon: fix coverity issue CHECKED_RETURN
>   mdadm/mdmon: fix coverity issue RESOURCE_LEAK
>   mdadm/mdopen: fix coverity issue CHECKED_RETURN
>   mdadm/mdopen: fix coverity issue STRING_OVERFLOW
>   mdadm/mdstat: fix coverity issue CHECKED_RETURN
>   mdadm/super0: fix coverity issue CHECKED_RETURN and EVALUATION_ORDER
>   mdadm/super1: fix coverity issue CHECKED_RETURN
>   mdadm/super1: fix coverity issue DEADCODE
>   mdadm/super1: fix coverity issue EVALUATION_ORDER
>   mdadm/super1: fix coverity issue RESOURCE_LEAK
> 
>  Grow.c        | 87 ++++++++++++++++++++++++++++++++++++++++-----------
>  Incremental.c | 20 ++++++------
>  mdmon.c       | 20 +++++++++---
>  mdopen.c      |  8 +++--
>  mdstat.c      | 12 +++++--
>  super0.c      | 10 ++++--
>  super1.c      | 32 ++++++++++++++-----
>  7 files changed, 139 insertions(+), 50 deletions(-)
> 

Applied!
Sorry for the delay. I was few days out of office!

Mariusz
