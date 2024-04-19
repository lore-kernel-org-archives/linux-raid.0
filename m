Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB7F57C089
	for <linux-raid@vger.kernel.org>; Fri, 19 Apr 2024 09:47:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713520032; cv=none; b=pIkKC30UyL1WxMNYCAUfVXSNnRYbEtewlhDRieIiyjEaJw2jbTYEZpaPXpw9OsupabUSMJWSYs3QRrlTN/H+x4zNkZXNjYl8KfJUFwdaUcqJJiP4oxi2csG9ZcjgmLC7U14hrs3PSDAvtc2IyJ13UVFOMIqJ/YpIy7PKgJ7AnxY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713520032; c=relaxed/simple;
	bh=xXa3gGLs1DuW/+TPEzwQTJt8tA21/fvwy4CvBXw0V70=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Xc37uzZn3gFrpkJ40nQbM3IzgYroXSQxK0WJnyhg79dsV5bl/t1xNBN+4iMaNaVvRjCAV0oFFULZ/tDoNkF0gZc2WjGHF87btG1ODPdFi1oglK3QQPnIBM7RGolcXvj+EOU5BaENmpBVo33YVm+8oRpbuAWX1B7l+W1TvexLruY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=AusX4uP0; arc=none smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="AusX4uP0"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1713520031; x=1745056031;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=xXa3gGLs1DuW/+TPEzwQTJt8tA21/fvwy4CvBXw0V70=;
  b=AusX4uP0S3EcKbzP+xDWcqktjJ3X9mViWVA4XEpbA7EZUp06UWRR+fWM
   cqF9S+x2AD9KJ2zdT+tfvmGarsaqnP7ITYo5FDg/LoMUeyZxnV53P/pT8
   vxZOvjP7Z4lD3watlrzhTaaQjmZ1ckHUkK2HL6DuBIncM1U8jqOMRtVvH
   ToLFIGKIDmucBocZ19ewTi2jp3+inMSIlvni8ziSVwVxbmWCneFRP6CHz
   ohE2LHAaSCKTDGlIFKAISUvFZCdRjIOAMHkmxEnS1RjQAq4XX87QrvqKu
   9ectAhVrc1iv5vw4m09XyG6JvLCFSkvY06wt9vKGlqS2fDx+HRouXIEcF
   A==;
X-CSE-ConnectionGUID: KdowckvETlaqmVy0okAIuQ==
X-CSE-MsgGUID: /j2EaSAvTPCku13nDswTkQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11047"; a="9655344"
X-IronPort-AV: E=Sophos;i="6.07,213,1708416000"; 
   d="scan'208";a="9655344"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Apr 2024 02:47:10 -0700
X-CSE-ConnectionGUID: 3fbCWeFUQc+mHresrfFyJg==
X-CSE-MsgGUID: f978DbSmTDOJCSm1is0B7Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,213,1708416000"; 
   d="scan'208";a="23903338"
Received: from mtkaczyk-mobl.ger.corp.intel.com (HELO localhost) ([10.245.112.252])
  by orviesa008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Apr 2024 02:47:07 -0700
Date: Fri, 19 Apr 2024 11:47:02 +0200
From: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To: Xiao Ni <xni@redhat.com>
Cc: linux-raid@vger.kernel.org, jes@trained-monkey.org, song@kernel.org,
 yukuai1@huaweicloud.com, ncroxon@redhat.com, colyli@suse.de
Subject: Re: [PATCH 2/5] tests/00createnames enhance
Message-ID: <20240419114702.0000694c@linux.intel.com>
In-Reply-To: <20240418102321.95384-3-xni@redhat.com>
References: <20240418102321.95384-1-xni@redhat.com>
	<20240418102321.95384-3-xni@redhat.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 18 Apr 2024 18:23:18 +0800
Xiao Ni <xni@redhat.com> wrote:

> +	local is_super1="$(mdadm -D --export $DEVNODE_NAME | grep
> MD_METADATA=1.2)"

You can also limit this test to super-1.2 it may depend on config, so we can
specify metadata directly in create command (if it is not specified).

Mariusz
