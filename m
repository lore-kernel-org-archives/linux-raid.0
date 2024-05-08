Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D97F753E32
	for <linux-raid@vger.kernel.org>; Wed,  8 May 2024 08:36:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715157389; cv=none; b=juYa1fslWMrMDDb0lmSqpVdPqReEfok5dDR1pPoYJMCuoyrcNzEuBH4RT0I33+Aa8KQQMx1HocXYOG0IYXTd1SFq8LEdu2pJyZrAHjO71sFCrpF5ck3rGfdLmGU0GfAzDQp3jRawd4TSqVRRfA/5p+HjbioVBgIVUuQu3gyfKz8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715157389; c=relaxed/simple;
	bh=DTl7MkRBp2c1xgj+uN/PM6O9rsPk6MMNOYDizjEg3aQ=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WZ0E6qeV4YiMIKIPkfLFtmq9f2HnSmlVzMMoIoEQgaUdGf7XXmRzFFF4rPnW+7KYqhoOeAPhGu5/mg7x+aSg7XiPN62jOyCF7cOlKRtTWhG+WAXQepOTaD7tntS0YXMa9va0SOp+BRJ+ukxMf4sxhaOn0YcLad02OiFe1OJRPW0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=WYvblqMA; arc=none smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="WYvblqMA"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1715157388; x=1746693388;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=DTl7MkRBp2c1xgj+uN/PM6O9rsPk6MMNOYDizjEg3aQ=;
  b=WYvblqMAZ5kK/D/r726hXh5mtq15ojSpafcZ68K5wma6cIlqvJi79gp0
   w68RIwc1yz3PmBWBS0G5YE8eUVjT23oe5UcqJJYtdlUQgLKhijnsa3mdc
   yPtCSseCp62+m1FWs9XoLdWjmg7h9gwRjRQ5JnVMP6QOq5qbvKiRQ9+rb
   HOhrIKtwKYcN167wqLLBa+kcBKNkInncREN77tZEx3xKr3xW9S9bJZhz4
   CMdWVZ7lnmrC/6oxqbDkqh3yqGVsT8HhJwBTo45sZZIDCy8VBsz1iUAuu
   3ClAjJXM7uR3CrQ7yNOA+o7rG0qJOII3akzEitDr8R3WuOy/5w6eT+Hca
   w==;
X-CSE-ConnectionGUID: UxEa3c8uT46ov7XL7lq4wQ==
X-CSE-MsgGUID: pbWvx0X2TOGbV/92TzMH0A==
X-IronPort-AV: E=McAfee;i="6600,9927,11066"; a="22156080"
X-IronPort-AV: E=Sophos;i="6.08,144,1712646000"; 
   d="scan'208";a="22156080"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 May 2024 01:36:28 -0700
X-CSE-ConnectionGUID: R+X4OfC8QGuQYNsLCLw5lg==
X-CSE-MsgGUID: sJWxU137Rx+rBWEh1IWq+Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,144,1712646000"; 
   d="scan'208";a="52023835"
Received: from mtkaczyk-mobl.ger.corp.intel.com (HELO localhost) ([10.246.29.120])
  by fmviesa002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 May 2024 01:36:25 -0700
Date: Wed, 8 May 2024 10:36:21 +0200
From: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To: Xiao Ni <xni@redhat.com>
Cc: linux-raid@vger.kernel.org, jes@trained-monkey.org, song@kernel.org,
 yukuai1@huaweicloud.com, ncroxon@redhat.com, colyli@suse.de
Subject: Re: [PATCH 4/5] tests/01r5integ.broken
Message-ID: <20240508103621.00000f1c@linux.intel.com>
In-Reply-To: <20240418102321.95384-5-xni@redhat.com>
References: <20240418102321.95384-1-xni@redhat.com>
	<20240418102321.95384-5-xni@redhat.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 18 Apr 2024 18:23:20 +0800
Xiao Ni <xni@redhat.com> wrote:

> 01r5integ can be run successfully 152 times without error with
> kernel 6.9.0-rc4 and mdadm - v4.3-51-g52bead95. So remove this
> one broken case.
> 
> Signed-off-by: Xiao Ni <xni@redhat.com>
> ---

Applying this one!

Thanks,
Mariusz
