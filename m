Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4759D5684;
	Wed, 15 May 2024 13:12:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715778733; cv=none; b=Op1ts+3Ji2sI4nm1xfb/oR3yaKO3c+f0/CZPTx9Ga/QNhjogHzRFUHGZFTx5zoCoKkb5hVpel/olrdkEKHP5s0QKj1vi/0LV83lGA47zUUKZyGIDAxQqQkxJySZV8KOj8Pg7fXz7+U3PIspz/fsGKFF/J+sQz/dYkV1hDYdbeME=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715778733; c=relaxed/simple;
	bh=Ya87/SS7ypILoGzc5H3cX5V3C38M9G0fWSR3Uh6LN9k=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QdHSU7DyhbNqgSoLodMirU66XuOKIoP+rQK3iEMsaqMlxYPfvioNYiIBgecFr0qLw6DiPHA9TUHg4SONxwY0yH5WLIV9ZLTKAdvfYrMU85U9KjVUgVLn39zoSeVjwlZSJLYCG5ekWuEb3L7fjyyL/WRI2ZzoS3MRrqQLSBoBLkw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=KujRl6ir; arc=none smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="KujRl6ir"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1715778732; x=1747314732;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Ya87/SS7ypILoGzc5H3cX5V3C38M9G0fWSR3Uh6LN9k=;
  b=KujRl6irgYv4H78DFy5K9/tKfLoLGQ3CcYZ06d77n38opHs1RJyEEL1g
   FeNaUbJGHatx1sx34RRThMv8q4ukbbeac5zf85V4Lx9xzjmwVJSoC5i7Z
   tpnw2kKMtG9FzSSxW2xoRzTk3rswM+NI5sC8+sSefNkTyGlqOW7xf601F
   ugPeLUHNEd3O4mNWPb2wYdunKosGI3DuMp+bNp/4+dGceWIWFQjxl4SHq
   fNc9tEIabTPTxoih4FRharCFm0yjSnWHNZIRqwqHL05yfpkCxxnMa9GTo
   vsm2mMyMd5rceWAMl1lt87hOtbXoJjId4awwBaTAX28EbdR9kMToOcSKO
   A==;
X-CSE-ConnectionGUID: svOiIqIHQRCVlUIKeD2x+A==
X-CSE-MsgGUID: Bb98QNv1QU6rnygAd7zd7g==
X-IronPort-AV: E=McAfee;i="6600,9927,11073"; a="37205438"
X-IronPort-AV: E=Sophos;i="6.08,161,1712646000"; 
   d="scan'208";a="37205438"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 May 2024 06:12:11 -0700
X-CSE-ConnectionGUID: nqubSkUvRNiKPryFnJEuMA==
X-CSE-MsgGUID: C4okDTneSE6NU9Br6QKa1A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,161,1712646000"; 
   d="scan'208";a="35595725"
Received: from mtkaczyk-mobl.ger.corp.intel.com (HELO localhost) ([10.245.82.157])
  by fmviesa004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 May 2024 06:12:09 -0700
Date: Wed, 15 May 2024 15:12:04 +0200
From: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To: Yu Kuai <yukuai1@huaweicloud.com>
Cc: linan666@huaweicloud.com, song@kernel.org, linux-raid@vger.kernel.org,
 linux-kernel@vger.kernel.org, yi.zhang@huawei.com, houtao1@huawei.com,
 yangerkun@huawei.co, "yukuai (C)" <yukuai3@huawei.com>
Subject: Re: [PATCH] md: do not delete safemode_timer in mddev_suspend
Message-ID: <20240515151204.0000113d@linux.intel.com>
In-Reply-To: <33185f65-b657-b15b-ffa8-e35319fa0a5f@huaweicloud.com>
References: <20240508092053.1447930-1-linan666@huaweicloud.com>
	<33185f65-b657-b15b-ffa8-e35319fa0a5f@huaweicloud.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 9 May 2024 09:34:15 +0800
Yu Kuai <yukuai1@huaweicloud.com> wrote:

> However, since this behaviour is introduced since 2012, does anybody
> really care about array status is 'active' instead of 'clean' while
> there is no IO after suspend?

It may cause rebuild after reboot (bad but we can live with it) or platform hang
(this is bad). mdadm is waiting for transition to clean on shutdown if I
remember correctly.
Probably nobody tried that as we all know that Linux doesn't like suspending
and this is rare to reboot platform just after suspend. Probably any write will
fix it.

But this is all based on my knowledge, not tested or proved however I believe
that it gives light where to look for problems if you want.

Mariusz
