Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 648B8154C19
	for <linux-raid@vger.kernel.org>; Wed, 25 Sep 2024 07:51:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727250707; cv=none; b=khrLiHvmPZPLl204Y+4vSscivmg2Q9BJrURo5wyIN2t9GnaeZGhfbX5pcm7ivW85WpVHarP0wih0GDjzc1uFFlPMgVpz3XsaxQpQ3ddmGoyRcIA51cnovxwjmzR42pb66AKcAFryuReiDve3ySDMV9JaUOIbLCeCsiCrMpjEUlE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727250707; c=relaxed/simple;
	bh=/Nd38meJG4QvnYDsSAbfI+ajn8+zaOJvq6f/pFDSc2c=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=aciTyQM0WzYt4/OAg/KYW244i9sZvBciYDa5ydiI6m2PZu9BIDOfSsJS/iwWoCYPXW9JSn+Pf8tW2tnluqTWxQAVzpIB1ZKF4qDQIMI4f0BDfXO7zi3w6FS6T3Xe1UomsN/N07J+bkQKMATPzlwYgjJ79/W5zAuRY1EWmpLCq5o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ZPWYXbVN; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ZPWYXbVN"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1727250706; x=1758786706;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=/Nd38meJG4QvnYDsSAbfI+ajn8+zaOJvq6f/pFDSc2c=;
  b=ZPWYXbVN8zCt2qUhdzo+bBzh3tD50RITe6YuXGNhWCQNWPagLfkyHCvE
   h7+bbq9V75lZVCwRFtUUTYzlVEo9o/8PTZzgISiLu+t1ZzAysyPme0QUj
   xt+NcqmUy9OOb7kQf7dBxImjVK3QfUoorxZVFRT6qNUReL/10xaJusuQx
   H/QvTMAGj7S4hgSThvZo9KTI/GW0LGVFNC7DHJyIUwrE2xM+2LP1R2aRb
   tw8QPwG170CLrNVy3EFIqsX9rOTG91RdeFEeoqlocYK6hL4rleWLMfd76
   nFMUiULfZyMRRC5uyPhGzqqBt/ah5o47v4ZLNg015Gs9ugI/EpbczYJpE
   w==;
X-CSE-ConnectionGUID: MuvQl/5ER0CMsn28dr4P2w==
X-CSE-MsgGUID: wytUC24/S5SICRGKRDsSCQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11205"; a="37661341"
X-IronPort-AV: E=Sophos;i="6.10,256,1719903600"; 
   d="scan'208";a="37661341"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Sep 2024 00:51:45 -0700
X-CSE-ConnectionGUID: uSBVsmnkRNqIyOKZqH9tCQ==
X-CSE-MsgGUID: ANomrnEXTmyDqvFtRd82TQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,256,1719903600"; 
   d="scan'208";a="76614786"
Received: from mtkaczyk-mobl.ger.corp.intel.com (HELO localhost) ([10.245.112.252])
  by orviesa004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Sep 2024 00:51:44 -0700
Date: Wed, 25 Sep 2024 09:51:39 +0200
From: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To: Xiao Ni <xni@redhat.com>
Cc: linux-raid@vger.kernel.org, ncroxon@redhat.com
Subject: Re: [PATCH V2 1/1] mdadm/Grow: Update new level when starting
 reshape
Message-ID: <20240925095139.0000066e@linux.intel.com>
In-Reply-To: <20240911085432.37828-2-xni@redhat.com>
References: <20240911085432.37828-1-xni@redhat.com>
	<20240911085432.37828-2-xni@redhat.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 11 Sep 2024 16:54:23 +0800
Xiao Ni <xni@redhat.com> wrote:

> +
> +		/* new_level is introduced in kernel 6.12 */
> +		if (!err && get_linux_version() >= 6012000 &&
> +				sysfs_set_num(sra, NULL, "new_level",
> info->new_level) < 0)
> +			err = errno;

Hi Xiao,
I realized that we would do this better by checking existence of new_level
sysfs file. This way, our solution is limited to kernel > 6.12 so, for example
redhat 9 with kernel 5.14 will never pass the condition. I know that you fixed
test issue but someone still may find this in real life.

I'm not going to rework it myself, I'm fine with current approach until
someone will report issue about that for older kernel.

If you are going to rework this, please left a comment about kernel version
that it was added, to let future maintainers know when the additional
verification can be removed.

Thanks,
Mariusz
