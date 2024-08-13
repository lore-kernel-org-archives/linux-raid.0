Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED1E54436B;
	Tue, 13 Aug 2024 06:59:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723532344; cv=none; b=a+BoHe3lWWvQdk8dlEm8CjIccay3YdYbYeq8C2X+vDeDNAd207xhfabB0X0VKfytBxGzQgtB/eDONwR1teZIQPyLm/FUA7T9QcZurIO7CNusgB2HKO6yYtdVJ9C0R44Mh5fiwOfby5MaLCYEZ6tOKTaBvbOBESEvu30YLGbY6pU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723532344; c=relaxed/simple;
	bh=csr4lEhbkequ1alrCctQf2mie5S/MyJtwR2Ya+HwdGY=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RSmrSPsg+4d3VbRyPD3xldSKF07uzOHqVVrhtakmw0UPaEnbJknAbiU8E1gIxZ7XrCjM08TuR2VL5oJNveYmKk+Qe7UzmFnEtt9SwaLnhn3HNBbzrH+7dOTZfSXKujuouhz0YU9w/k7Nead+S1Q4nYWkqzYJwhYJPCUJ3fyekCo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=R2SwBPuG; arc=none smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="R2SwBPuG"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1723532343; x=1755068343;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=csr4lEhbkequ1alrCctQf2mie5S/MyJtwR2Ya+HwdGY=;
  b=R2SwBPuGc0EgGmAi8D5GO/uNT3lt5Ei2/6eDYanOMMJAVboda3V/faHY
   BEZLopTWTcqJp7OS0rpASVDHBunk8zklelOtMuQxiViLmF64/Ic1jEZsj
   6WrA5fwziXSDU7iJ6J6bdeVbg0K9LIMhkypiiI+k3y1F6lBv+zbVoMocN
   97dlrTCOqdpYDFcVYUAnogCGb533i77GwzeB8MegIJJInsYG5JWuaK4MZ
   V00Xo0AXCBTqP/MVvlnoVX3/cwRfLQsrHZe4fZg7oMD/UvoDEh9H03QGk
   M2+TT31DvTKZUU+4z3jEi4IAbRiGgCL0X/7CvUe35OMglhnIGpVzVfDvM
   A==;
X-CSE-ConnectionGUID: Yv4XiwxWSAiSqiA1WoQILw==
X-CSE-MsgGUID: ioXGcl0OTdi3rD6BH3RCag==
X-IronPort-AV: E=McAfee;i="6700,10204,11162"; a="32247168"
X-IronPort-AV: E=Sophos;i="6.09,285,1716274800"; 
   d="scan'208";a="32247168"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Aug 2024 23:59:02 -0700
X-CSE-ConnectionGUID: XtvB9tqCSk6+gcm/UxlxQw==
X-CSE-MsgGUID: u6RN161iRIOg+ZQRMTn2WA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,285,1716274800"; 
   d="scan'208";a="63426227"
Received: from mtkaczyk-mobl.ger.corp.intel.com (HELO localhost) ([10.245.112.252])
  by orviesa005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Aug 2024 23:58:59 -0700
Date: Tue, 13 Aug 2024 08:58:54 +0200
From: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To: Yu Kuai <yukuai1@huaweicloud.com>
Cc: song@kernel.org, linux-kernel@vger.kernel.org,
 linux-raid@vger.kernel.org, yukuai3@huawei.com, yi.zhang@huawei.com,
 yangerkun@huawei.com
Subject: Re: [PATCH RFC -next 01/26] md/md-bitmap: introduce struct
 bitmap_operations
Message-ID: <20240813085806.00006ec3@linux.intel.com>
In-Reply-To: <20240810020854.797814-2-yukuai1@huaweicloud.com>
References: <20240810020854.797814-1-yukuai1@huaweicloud.com>
 <20240810020854.797814-2-yukuai1@huaweicloud.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Sat, 10 Aug 2024 10:08:29 +0800
Yu Kuai <yukuai1@huaweicloud.com> wrote:

> From: Yu Kuai <yukuai3@huawei.com>
> 
> The structure is empty for now, and will be used in later patches to
> merge in bitmap operations, prepare to implement a new lock free
> bitmap in the fulture.


HI Kuai,

typo: future

I think that as "later" you meant next patches in this patchset, right? If yes,
Please you "next" instead.

At this point bringing "lock free implementation in the future" looks like
totally unnecessary. It may happen or may not. Eventually, You can mention it in
cover letter. What we have now is the most important.

This is just a code rework. The main goal of this (as you mentioned in second
patch):

"So that the implementation won't be exposed, and it'll be possible
to invent a new bitmap by replacing bitmap_operations."

but please mention that you are not going to implement second mechanism to not
confuse reader. You need it to improve code maintainability mainly I think.

I would mention something about common "struct _ops" pattern (the special
structure to keep related operations together) that it is going to follow now.

For me, this one can be easy merged with the patch 2, so we will got struct +
usage in one patch.

Anyway, LGTM.

Thanks,
Mariusz
