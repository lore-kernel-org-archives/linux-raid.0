Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A68DF12B16E
	for <linux-raid@vger.kernel.org>; Thu, 23 May 2024 14:40:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716475231; cv=none; b=EHh3HbT/f2SQxWW7BhnCescSvjIGiGe52NWobb6l9e3FkT345wbACCZ565k2HitHgV74bicGBTgQX/PSE0kPI8G34jECHVQPbDH/8HTlDH8uW7gBTC0piwQbcPvgPotx/3+GsLCjoD051lWZVMW/T7LFuDnLiNNHjoLjycGBaFw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716475231; c=relaxed/simple;
	bh=+IYmNxvSV0ALZ7XCICShZXfbjgDX4UNeyW24RtG/7m4=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dNHvajzYkYmMv0DF5FDRutu4ODWaOqbcWTIrmgSux+9DM6/zOEmBYSkSpTGd+drQX0etsjTDxeqyoaLJTGQ8hOoJW4fe4iUxcOaRpGOxQmOu9PCIGwwCmEdzHxaQMg5dDoE/6BkX2npCEDmI2aBjAOxlGQJYFhNLPg6w/dWV4cw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=IRMdtTRq; arc=none smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="IRMdtTRq"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1716475229; x=1748011229;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=+IYmNxvSV0ALZ7XCICShZXfbjgDX4UNeyW24RtG/7m4=;
  b=IRMdtTRqP6VKyJhfiQEgPzVdAN/EBEzbxPAZFEw7dBPvAUVzk5Q0qExj
   kknb2CyP4oX5Sa83sE+vhG20n7IXkT5BpsY8TWF2hxTIC1EWT++WPvzPN
   Q8CvnBsRfZgCd6WxRRcgRvWwQfQ6nEIVVOqR4DZoAEqbc4Xrh+vhlHAw+
   nju1czNw8gN0TGImUF22wESigiRCMDO8pH9H1v8OSSqr0/3pAccpkS9vZ
   2K/EG4CrmY335cAaVHN/ail3VaM6Gq5if4JRJQdqMPbBRcnYGQHyje4cV
   e4rQuKPDiyI7gvZtfrLPt1p73Cg9mpsdERqRoE2Dj0WdOoL1cqnuHKgh5
   A==;
X-CSE-ConnectionGUID: mF2E5thWR5m1hOnBtWlSuA==
X-CSE-MsgGUID: GqmDT6GTR4yKE92mt/JX2Q==
X-IronPort-AV: E=McAfee;i="6600,9927,11081"; a="23465354"
X-IronPort-AV: E=Sophos;i="6.08,182,1712646000"; 
   d="scan'208";a="23465354"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 May 2024 07:40:28 -0700
X-CSE-ConnectionGUID: E24S6lHaRI2XxZKJgkNB5g==
X-CSE-MsgGUID: SIqYVZ1tTBqwJ+Ok/Egfwg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,182,1712646000"; 
   d="scan'208";a="34228613"
Received: from mtkaczyk-mobl.ger.corp.intel.com (HELO localhost) ([10.245.112.252])
  by orviesa008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 May 2024 07:40:28 -0700
Date: Thu, 23 May 2024 16:40:23 +0200
From: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To: Xiao Ni <xni@redhat.com>
Cc: linux-raid@vger.kernel.org, heinzm@redhat.com, ncroxon@redhat.com
Subject: Re: [PATCH 08/19] mdadm/tests 03r0assem enhance
Message-ID: <20240523164023.00000996@linux.intel.com>
In-Reply-To: <20240522085056.54818-9-xni@redhat.com>
References: <20240522085056.54818-1-xni@redhat.com>
	<20240522085056.54818-9-xni@redhat.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 22 May 2024 16:50:45 +0800
Xiao Ni <xni@redhat.com> wrote:

> dcc22ae74a864 ('super1: remove support for name= in config') already
> removes name= support. So remove related test codes in 03r0assem.
> 
> Signed-off-by: Xiao Ni <xni@redhat.com>
> ---
Applied! 

Thanks,
Mariusz
