Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1869D81742
	for <linux-raid@vger.kernel.org>; Wed, 15 May 2024 12:45:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715777109; cv=none; b=RIqGdGPH5o/Hzxf/+71n9ZW8fqWwQCKVc4xK8FvC5KYo8eU4mhtdQeHDGbeWd/Ahw54GTIBnomqGILG4AeJ3Af6fqDbnhD7m5TyaMDuyII5rXoDgCsJrNySnXBgsi9mvyrGWozGD+dVWn4sxK4rHehn/LheDmxw7z5L/wKSJwhc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715777109; c=relaxed/simple;
	bh=MUFOHj0T1+d312vj2PmQFpWTc5pqORpUy1lcFApSMf4=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mygjt2OInL80cAYoOgJ4aqyzlWDxXKuAWgqExjkKc+xNOSCXU6kRt09SpkVR+INK197gkZeNuZvLW5Mv9AOFmJSaDoLiXZ3nejlJFf9iR+7FcF+ddBoAO7JNVKChF3DIhqgmErVdE3VlhpZg/wdfactGMUIh6zclW8id/SP2fyk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Z66P3eZs; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Z66P3eZs"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1715777108; x=1747313108;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=MUFOHj0T1+d312vj2PmQFpWTc5pqORpUy1lcFApSMf4=;
  b=Z66P3eZs79vi4Rk/Tp+cFRtV0tcLtpOyrXyr7M9bWjmArwVbL/KK1TKq
   x5/WCmo6HRXwxF8ig9zB9srX/S5uYqMp3uGxU9XrdqcRE9zoQ+lKhoEM6
   y/PfkpP+dfSI36UVKzeYWJO/LMaliGeX049GuO2k9YEPFf87SwSCycvWy
   TH8uhzpHjKVXhK5TT0kNFz4jseP+c6JYK/AxP1+AhvXBzQ8MiDIX7BbL1
   9xNsymrKLk0SzLAEEKwATyhLDLd132CPxW80Hx04Tqx6E0YChd2OZOqEr
   QkxIVXuzp1SyHXNXK2wwGIj7T/E+uilaLduSx3N5aSU/zcKiRGRnjZFWw
   g==;
X-CSE-ConnectionGUID: 4SH4y6aTRACxkZ4nnCdfiw==
X-CSE-MsgGUID: B4LzTK3zQ3yXk9jEYeRp6g==
X-IronPort-AV: E=McAfee;i="6600,9927,11073"; a="14769750"
X-IronPort-AV: E=Sophos;i="6.08,161,1712646000"; 
   d="scan'208";a="14769750"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 May 2024 05:45:07 -0700
X-CSE-ConnectionGUID: wmeylunSQKS0RrARC9zHdA==
X-CSE-MsgGUID: TpStRtBtT4+WeYdLCYnpdw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,161,1712646000"; 
   d="scan'208";a="30972032"
Received: from mtkaczyk-mobl.ger.corp.intel.com (HELO localhost) ([10.245.82.157])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 May 2024 05:45:06 -0700
Date: Wed, 15 May 2024 14:45:01 +0200
From: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To: Nigel Croxon <ncroxon@redhat.com>
Cc: "Kernel.org-Linux-RAID" <linux-raid@vger.kernel.org>, Xiao Ni
 <xni@redhat.com>, Jes Sorensen <jes@trained-monkey.org>
Subject: Re: [PATCH] add checking of return status on fstat calls
Message-ID: <20240515144501.000048ad@linux.intel.com>
In-Reply-To: <bc9e94e6-96c5-411b-977b-30aea31cf9c3@redhat.com>
References: <bc9e94e6-96c5-411b-977b-30aea31cf9c3@redhat.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 15 May 2024 07:55:57 -0400
Nigel Croxon <ncroxon@redhat.com> wrote:

> From 99c48231fe50845f622572d10fbb91a5ece0501f Mon Sep 17 00:00:00 2001
> From: Nigel Croxon <ncroxon@redhat.com>
> Date: Fri, 10 May 2024 09:08:02 -0400
> Subject: [PATCH] add checking of return status on fstat calls
> 
> There are a few places we don't check the return status when
> calling fstat for success. Clean up the calls by adding a
> check before continuing.
> 
> Signed-off-by: Nigel Croxon <ncroxon@redhat.com>
> ---
Hi Nigel,
I'm observing following errors:

warning: Patch sent with format=flowed; space at the end of lines might be lost.
Applying: add checking of return status on fstat calls
error: corrupt patch at line 16
Patch failed at 0001 add checking of return status on fstat calls
----

Probably you need to rebase patch to current main.

I also see, some checkpatch issues like "rv=0".
At this moment, you can just fork the github repo:
https://github.com/md-raid-utilities/mdadm

and open pull request, then checkpatch will be automatically run for you :)

Thanks,
Mariusz
