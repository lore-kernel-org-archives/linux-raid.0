Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5133A433C4
	for <linux-raid@vger.kernel.org>; Thu, 23 May 2024 14:22:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716474171; cv=none; b=cUQjXDWC28towSoF+eWUFcfQLcxuov4CMeovukID+gFBLb+TlgkjgPWntd90aH6yduQn4YtW4wdbgVZPciGjlB4g+XuUDCCYjCdc7o549xhMgroS4k3nbgWHxFZA+yGp+yHYYkNO/lrAG7sWPEDNI0Pk9XErOw5F6u4JB6igUtg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716474171; c=relaxed/simple;
	bh=L742pVyQ+tU92G/CnVPSe/UdaHPTmRxlyxqB+0PKDJs=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=r6CfU1mm/fxv8D+sKApJRM5Lrlvt1Uv0uIoFdRgCjN1O1PeDgJTsm1PuheOwP5FqSdP+3XXBGnMwhH6/yC73t4aMW/oU+M7l3+7YUqtE2UVB+yiNCFTHtv2TykYGikmqj6at1mibgvFV8+hUIpRtdqD590BpMVycXQO+A52vpc4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Com3zbmv; arc=none smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Com3zbmv"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1716474170; x=1748010170;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=L742pVyQ+tU92G/CnVPSe/UdaHPTmRxlyxqB+0PKDJs=;
  b=Com3zbmvheOqWhXzZ6Ub6/jiU56BdfG2YnPFj5TuhRxX28+mPdtw0lto
   hZYElvARWST00A/TX3wSn7GM7I3AgShU7txuFG89OYFSK6wp/IuagNZDi
   hAtfjxlEZzXASRnBzOpYpQoC6xzLxVnljg9xrHIQb2x/nE+cJflDJoP94
   9yVZFEsUUpD25OSVuVWmTGOs22ekvHoPfIELj+0VHh/17zLuA16bRA2Vg
   IJ/sxN4aaqn/dteTSzwaeGG2YXUPKHZen4963kfFmGGZ58Hf2tlKvlc9M
   PVNWM87pVIAVeAMYrwToqU4VaqjbFRHAmP8QQWNZyEj64TyunjyVSSLms
   Q==;
X-CSE-ConnectionGUID: AO6jDEafQ72XQJQDnDtZhg==
X-CSE-MsgGUID: 7Rqe+85mQ9aB5la2PJt92Q==
X-IronPort-AV: E=McAfee;i="6600,9927,11081"; a="12668938"
X-IronPort-AV: E=Sophos;i="6.08,182,1712646000"; 
   d="scan'208";a="12668938"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 May 2024 07:22:49 -0700
X-CSE-ConnectionGUID: dOijTFEdQDC2+G7I4WwLBA==
X-CSE-MsgGUID: i3RXzVcMS/S+ZioXBFFlFA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,182,1712646000"; 
   d="scan'208";a="33536755"
Received: from mtkaczyk-mobl.ger.corp.intel.com (HELO localhost) ([10.245.112.252])
  by orviesa010-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 May 2024 07:22:48 -0700
Date: Thu, 23 May 2024 16:22:43 +0200
From: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To: Xiao Ni <xni@redhat.com>
Cc: linux-raid@vger.kernel.org, heinzm@redhat.com, ncroxon@redhat.com
Subject: Re: [PATCH 02/19] mdadm: Start update_opt from 0
Message-ID: <20240523162243.000076b7@linux.intel.com>
In-Reply-To: <20240522085056.54818-3-xni@redhat.com>
References: <20240522085056.54818-1-xni@redhat.com>
	<20240522085056.54818-3-xni@redhat.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 22 May 2024 16:50:39 +0800
Xiao Ni <xni@redhat.com> wrote:

> Before f2e8393bd722 ('Manage&Incremental: code refactor, string to enum'), it
> uses NULL to represent it doesn't need to update. So init UOPT_UNDEFINED to
> 0. This problem is found by test case 05r6tor0.
> 
> Signed-off-by: Xiao Ni <xni@redhat.com>
> ---
Applied! 

Thanks,
Mariusz
