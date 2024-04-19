Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E60202AF16
	for <linux-raid@vger.kernel.org>; Fri, 19 Apr 2024 10:06:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713521167; cv=none; b=fa+nUk28QuqTMIlN7VhcoBfd0/ytA+Tyhq34DkLR0H6/Tty2h/bkEnIKVa+5hsPq3ZAO6OQcsKNSCZiSVo9nOyHh4idIks0BfmLkMtjYYv7YpMI4IcTGXSQ9s/dcEtHGWYVFqjpN9lYgwX62karEGZIb5FbB/ib3VQlNmXrk4sg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713521167; c=relaxed/simple;
	bh=0NocahjIfgitXdDRiVMcixR487lU1F3hj2o8p0MWCfQ=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HX1SttdjLfVwIeL0BPfpOWBHm0R8PwRYFj7j4iN3FAvrL8rbpIrghOy2xNFW80uXWFFeHeM+FnN1ZCxoDK+TVWn0/7mDnnG4mMd3IzYBbde6Lfvy/aypswVrCb8/t3fDHM4xsmRpesk6nGvFJECN87MAWeeBVG0pyY3Ehbx1XRU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=JEuhlzcb; arc=none smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="JEuhlzcb"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1713521166; x=1745057166;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=0NocahjIfgitXdDRiVMcixR487lU1F3hj2o8p0MWCfQ=;
  b=JEuhlzcbOVnyivUdkstKRyFWNRUj0hjQcKH66Xn8fpaPkm/wJa3sthdf
   AnJTxiB+0DmfTolDP9HsclqEqsKb5xsSPtpKaOx9nv1L33ASRxXKlm0+F
   8JtaDewZ4KyJiGwMBDAKHiXqwX8aiW7njC1YhxoiCdLhmdpJ2rgoY9nNJ
   Kfb11WS0xVfx40H4UAi971Zr22MHSafbcXkY0i9kSTtL8l9Vu66JmaaTu
   dxuuTP3tsDL+qgBTb5XtLZOQa7HB3X877O1UraTlIVv17IxZXkEKLM3xA
   Qkp6BD3/uZ8AiHTSwWEIx866TOtz8pmTD4NxCgyqhm4uVtgruLxRi5gAj
   A==;
X-CSE-ConnectionGUID: 8NptNUjzTmGX+UNjzWd3Dg==
X-CSE-MsgGUID: 0kjMvjRnT/GuJ4HwYHY8Xw==
X-IronPort-AV: E=McAfee;i="6600,9927,11047"; a="9657459"
X-IronPort-AV: E=Sophos;i="6.07,213,1708416000"; 
   d="scan'208";a="9657459"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Apr 2024 03:06:04 -0700
X-CSE-ConnectionGUID: j5R/KP9XRlOLsAVkEpAR7Q==
X-CSE-MsgGUID: YzmNp+tsS4yxC+lKwAm5QQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,213,1708416000"; 
   d="scan'208";a="23726784"
Received: from mtkaczyk-mobl.ger.corp.intel.com (HELO localhost) ([10.245.112.252])
  by orviesa006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Apr 2024 03:06:01 -0700
Date: Fri, 19 Apr 2024 12:05:55 +0200
From: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To: Xiao Ni <xni@redhat.com>
Cc: linux-raid@vger.kernel.org, jes@trained-monkey.org, song@kernel.org,
 yukuai1@huaweicloud.com, ncroxon@redhat.com, colyli@suse.de
Subject: Re: [PATCH 5/5] tests/01raid6integ.broken can be removed
Message-ID: <20240419120555.00002b95@linux.intel.com>
In-Reply-To: <20240418102321.95384-6-xni@redhat.com>
References: <20240418102321.95384-1-xni@redhat.com>
	<20240418102321.95384-6-xni@redhat.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 18 Apr 2024 18:23:21 +0800
Xiao Ni <xni@redhat.com> wrote:

> 01raid6integ can be run successfully with kernel 6.9.0-rc3.
> So remove 01raid6integ.broken.
> 
> Signed-off-by: Xiao Ni <xni@redhat.com>
> ---
I don't follow the *.broken file concept. We could also describe that in comment
in the test, so LGTM for the changes.

If you want to, you can remove all *.broken files and add some comments
in test instead. If we have some tests failing marked as broken long time ago,
you can either remove those scenarios as we are obiously not interested in
fixing those scenarios.

Mariusz
