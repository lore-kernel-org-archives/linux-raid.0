Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A737193445
	for <linux-raid@vger.kernel.org>; Wed, 10 Jul 2024 14:10:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720620607; cv=none; b=BihhB9txRQmrYBgzLEtW+fJPadZhory/luL71iTyPAL9TQZa1c53ftnwQTsEwERrpEgRM7mQP2xzAGes+7j/zY2Wzeu511aijC6YUq1xE6cPCiuPOTM4P9+poY0gFtZNGA8N0ubGVmm+ip5i/nQCSksmk+SuawwrtkQ7NFieVWk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720620607; c=relaxed/simple;
	bh=37vSLvoku+EolSugIFqazzFwLtTA2zQUYQlEZRwvtxA=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=G+77neMxoYaiL3TfpsTV0nVkcYvOcTMHKk7Q406mMWTJBdTbZJlG9z5ascXv1ERrC/JPfPn4n3RbjpJS5iB/QgU6F2mNONhYm73nUnbOlKKsCgqRtjMFtPhRDilEGD4M6Pyqx249hZkEdD/BdwfFYHwHgI16ccAx/Z8EV4ZupYM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=CtcIF15F; arc=none smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="CtcIF15F"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1720620606; x=1752156606;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=37vSLvoku+EolSugIFqazzFwLtTA2zQUYQlEZRwvtxA=;
  b=CtcIF15Fx52LcIrFWi7yB02ZUi9gKmsYn6v2jz9BqjeMZc7dP8LbtKE7
   t/2do9bn9dXeUIWtYSFIA+HGMB1MN7mnkF/Bdps6r6LxENuWvMKdtYCkn
   18x72GaJogjgerJom2WCWBYu179kRL+ASX7hScREzwd+wjcyK9+IYORie
   k0hGO2WnFERl7DL18gm3rSFyZKQ7iBem566Y1UfzYNQ4tDp4+AHhQtCGT
   XX2EnhRO06M8NrkwVpf7BiEY4Rges36FKb+ZKk8ylkIND8dPPSVkPa8q4
   WTG+dIPcALMf02RONdDhQ3f05M+R+UriyJv+kqWl5HonUG6/jQ5Lk4gL9
   g==;
X-CSE-ConnectionGUID: 4mvzDh+cQsSPUUc1B9na+A==
X-CSE-MsgGUID: YkWDXwiyQUGxZSnBhjyXmw==
X-IronPort-AV: E=McAfee;i="6700,10204,11129"; a="12477150"
X-IronPort-AV: E=Sophos;i="6.09,198,1716274800"; 
   d="scan'208";a="12477150"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jul 2024 07:10:05 -0700
X-CSE-ConnectionGUID: +mT8HJnOTfSPjxNsGm1PVQ==
X-CSE-MsgGUID: vhq2FWe5Ql2z23FXfthcqw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,198,1716274800"; 
   d="scan'208";a="48200563"
Received: from mtkaczyk-mobl.ger.corp.intel.com (HELO localhost) ([10.246.17.194])
  by fmviesa008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jul 2024 07:10:04 -0700
Date: Wed, 10 Jul 2024 16:10:00 +0200
From: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To: Heming Zhao <heming.zhao@suse.com>
Cc: jes@trained-monkey.org, linux-raid@vger.kernel.org, xni@redhat.com
Subject: Re: [PATCH 1/2] mdadm/clustermd_tests: add some APIs in func.sh to
 support running the tests without errors
Message-ID: <20240710161000.000018f5@linux.intel.com>
In-Reply-To: <20240709120452.25398-1-heming.zhao@suse.com>
References: <20240709120452.25398-1-heming.zhao@suse.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue,  9 Jul 2024 20:04:51 +0800
Heming Zhao <heming.zhao@suse.com> wrote:

> clustermd_tests/func.sh lacks some APIs to run, this patch makes
> clustermd_tests runnable from the test suite.
> 
> Signed-off-by: Heming Zhao <heming.zhao@suse.com>
> ---
Applied both but please use cover-letter next time.

Thanks,
Mariusz
