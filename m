Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0004A81ABE
	for <linux-raid@vger.kernel.org>; Fri, 24 May 2024 08:46:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716540364; cv=none; b=JQdjhw73a4B0Y+QSrs5rXsH8HVuJaE5ekaqZSV/ZZZ74VwE9dyQkkoejSOLf9njgucQeTakLnu7EhmCKvQvdob8bJU4dFmolPj6xoFKZJrwTTJchgQPcj44bmkn3rcAhkOUCdRHSrb/y1uEuKRVIu67l5KuJn/3mvexI86++X6w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716540364; c=relaxed/simple;
	bh=LGZ4Lo6uJYmNCisX+tjmvwg+uCaMPaY7hlXHKokSMM0=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=sAuXn2bqEOjYeJAQF0TUd5Zl9P0osz2yckXNV2VTi3sTBGnVhLcMdeTdL6KlWHrrfe40CgrdP+GWEw+tz0/3hUv9adI5w8f5orNnhSRY5QNPHnRsRdFspK2ume+8zLWjwDsmgKS2LvOCKikwADt8bpoxP35t4ajHGjnQ7TfvUcI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Ny+HokRA; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Ny+HokRA"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1716540363; x=1748076363;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=LGZ4Lo6uJYmNCisX+tjmvwg+uCaMPaY7hlXHKokSMM0=;
  b=Ny+HokRAcVGYjLpcip0wLanlCtOZwPGephfJSdwX/W0tpQ3CfuWO1Hpy
   zD0yr6oSqr57DNQerHjTYF5q5LuURDe9GJDNrspAtFaO8q+zuS59EaaAm
   mD65036VGo5/ZfDt6sk8R42CTC/cevM3nHPbNn8mWQ/cgwjh2o3nPP5dN
   yB5Ew46eBQI4RCoq2buo06d5vdkSIM2M3Jz32WzY4P3AEGguxT7YtfKsz
   5a7JsJjmGSkHdr5M3pHnOgGTXtMxWNs8dGanChWbK3us775gzikZhsS9l
   Xazuk2zbnP3psbDB2QObifY8GbJYPmlkJjIiVMzNzztbQC5paVlVfLWmJ
   Q==;
X-CSE-ConnectionGUID: irggNXWGSk2C/2b3n1Xsew==
X-CSE-MsgGUID: g+FKC56aSty50ajDorDAug==
X-IronPort-AV: E=McAfee;i="6600,9927,11081"; a="12692112"
X-IronPort-AV: E=Sophos;i="6.08,184,1712646000"; 
   d="scan'208";a="12692112"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 May 2024 01:46:02 -0700
X-CSE-ConnectionGUID: /UevvGHiRxOCdO8tij+erw==
X-CSE-MsgGUID: NJ0nmOnLS623sN6Q0he2GQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,184,1712646000"; 
   d="scan'208";a="33940394"
Received: from mtkaczyk-mobl.ger.corp.intel.com (HELO localhost) ([10.237.142.64])
  by fmviesa008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 May 2024 01:46:01 -0700
Date: Fri, 24 May 2024 10:45:56 +0200
From: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To: Xiao Ni <xni@redhat.com>
Cc: linux-raid@vger.kernel.org, heinzm@redhat.com, ncroxon@redhat.com
Subject: Re: [PATCH 00/19] mdadm/tests: enhance/fix regression cases
Message-ID: <20240524104556.0000669b@linux.intel.com>
In-Reply-To: <20240522085056.54818-1-xni@redhat.com>
References: <20240522085056.54818-1-xni@redhat.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 22 May 2024 16:50:37 +0800
Xiao Ni <xni@redhat.com> wrote:

> Hi all
> 
> This is the first set which has fixed and enhanced some cases. I'll
> go on fixing/enhancing the following cases.
> 

Hello,
I applied them, expect 14 because this test has been recently removed by me:
https://git.kernel.org/pub/scm/utils/mdadm/mdadm.git/commit/?id=50b100768a115526f5029113af957658ef76b383

Thank you, great job!
Mariusz
