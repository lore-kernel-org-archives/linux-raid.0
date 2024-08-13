Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B954119AD9B
	for <linux-raid@vger.kernel.org>; Tue, 13 Aug 2024 12:41:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723552893; cv=none; b=Yol/Z0/vJ+897LRX62u+owPESGEIqFU23Ktdz4dK4QSDSvAPXmMEKPWUNv35xedfyHwdkW5NcCNLPeUVbBjViY8jWRSLsRpvpK01c4FlCknc8U4sZ/FEXne79suA6ko+cD1nrsLFHWmA+nxQjq1Gutd/jNbdirwa6dWsRMCLprM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723552893; c=relaxed/simple;
	bh=xg47eM7Z5bgTgFyABOcA0hd9HEGz4pxX8mwjvkGGOmY=;
	h=Date:From:To:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kvr3BIxknDKbLVj49xdSDMCEbVxm2uQa3Yb5FD5+wW1ZM4sDVCizF/QwiIerGy+jTPHH/zYr4Dl5/YQBXLDaR81ubj1WktoXw+bc9uX4xVD3j9pTjt1SJILrAnP98g2Z7/gkUEPxbxIAiQKlSEeoMAPMam0hAOfUNTPTKxvGweg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=OkSmKOHs; arc=none smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="OkSmKOHs"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1723552892; x=1755088892;
  h=date:from:to:subject:message-id:in-reply-to:references:
   mime-version:content-transfer-encoding;
  bh=xg47eM7Z5bgTgFyABOcA0hd9HEGz4pxX8mwjvkGGOmY=;
  b=OkSmKOHs7Pv8y/iJR5DSs/pZq7Dj/GIJNG4dNy6U/J35GoLKOmOWGRpC
   Mp4VFUJRdCLsg9g1rj3/U2DGi8sSqS9J499nGNxejMISAzo1Wn4rc4m1b
   txmoc4rXlPxLAlg+YaeSXAXJ2q3f4TVdNQd/ShUK2rROncZA06BddTWKC
   Bere58airrxPbfbQ3BlhyRpZo71K3GLsld7/YhOE3YsD3WiGFGxV8OhdW
   nABttu6+VjrB5A1TsCzRLnwOFORXWIGKc3QLKSARu1ZdEURfP02l0IFf0
   gN++c7wR/+Ampd4Cf7+Zno+bMDTjVyvI7+62gxsup3WYFjlls/wzCg15z
   A==;
X-CSE-ConnectionGUID: RTG34YpdSkio0+qWauCy4g==
X-CSE-MsgGUID: dt4eY8PQT9yWWBw6cb6L4g==
X-IronPort-AV: E=McAfee;i="6700,10204,11162"; a="21880717"
X-IronPort-AV: E=Sophos;i="6.09,285,1716274800"; 
   d="scan'208";a="21880717"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Aug 2024 05:41:31 -0700
X-CSE-ConnectionGUID: XjP6q7VdSWSt71/W9uF0Tg==
X-CSE-MsgGUID: 80U0s8/MSFm7mCwPdosbPQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,285,1716274800"; 
   d="scan'208";a="58956953"
Received: from mtkaczyk-mobl.ger.corp.intel.com (HELO localhost) ([10.245.112.252])
  by orviesa006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Aug 2024 05:41:30 -0700
Date: Tue, 13 Aug 2024 14:41:24 +0200
From: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To: linux-raid@vger.kernel.org
Subject: Re: mdadm v4.4 is coming (~4 weeks)
Message-ID: <20240813144124.000074a6@linux.intel.com>
In-Reply-To: <20240702123802.00000c97@linux.intel.com>
References: <20240702123802.00000c97@linux.intel.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 2 Jul 2024 12:38:02 +0200
Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com> wrote:

> Hello,
> Within 4 weeks I would like to release mdadm v4.4
> 
> Please let me know, if there is something urgent and it requires my attention.
> 
> Thanks,
> Mariusz
> 

FYI, we are delayed because urgent vulnerability has been detected with
IMSM:
https://github.com/md-raid-utilities/mdadm/pull/66

Thanks,
Mariusz
