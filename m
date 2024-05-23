Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DC3612B171
	for <linux-raid@vger.kernel.org>; Thu, 23 May 2024 14:37:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716475074; cv=none; b=NO44jKHxSXntEd0BuB9hnGROsNghP6f5hFb2UyYb4bUuzXW+C2wXeCRWKzXWW+fPiwLQO2y9nJfUmdrdLv2uAL34eSYvFc/d9Mmnpv3wGeCVAbLjgrF2EBvWxV+Nc0jX1kr0UgZKZ5rDx8TPrA9FqSuxUHYO5j96LxavC1Bq0UE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716475074; c=relaxed/simple;
	bh=jA7cfGHmxOwTuvXODAoaYigrXPcD5DrREU3b1+/9fD4=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=XmmWEU5vpjE+N+2O24nCNvxG4p32BrPyf/DVEDK1/atuTa0NgqskFP+VWmzIDUZn7Y/B98NLV8R1KARxHjrG68pZRj1L92i+CKVZuEgNgIltQSLEnhod4GfuW7c9EoUNDrjBn+VKcxvLhBmwQFXdrMNTTr7XC46RKFEv1JNjEBQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=RuH0rA4h; arc=none smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="RuH0rA4h"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1716475073; x=1748011073;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=jA7cfGHmxOwTuvXODAoaYigrXPcD5DrREU3b1+/9fD4=;
  b=RuH0rA4hfaePRt1Mu1gfBuMejqB42u1gPAPFxgebczeAIQRa7DnQ+D4B
   i3/vmlYLuChoNFG5iJ0VCy+INPfXfjAlcPsxxIYLLhbUNXk5XvXRdoPDN
   SwwkJmz+MKHlJoT35xdzpxcYZvgiMV8Xp+lXPKq7+2jh9Zh0lZ8EodWIL
   L6M5rEuB9YPsxMd+6j79Fgrjvm4QsEG6ynamQAvv3FBsbO3I3wBMZBpr7
   7vefKU/ogVeMs1EXqldzrjRC25FCfdFVsFg/MEN2UvvHXx1B4100r7iGA
   SXdc9M7jgQnPo8JQpCoBA9VrfjsWGf4o792FWPkDNuBa3fwo4/te1wJtu
   Q==;
X-CSE-ConnectionGUID: 84WkQWSaTwK62ouizqSDKQ==
X-CSE-MsgGUID: bpFjzTVGRciazAj4NkDymw==
X-IronPort-AV: E=McAfee;i="6600,9927,11081"; a="16633162"
X-IronPort-AV: E=Sophos;i="6.08,182,1712646000"; 
   d="scan'208";a="16633162"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 May 2024 07:37:53 -0700
X-CSE-ConnectionGUID: 1ajn9i9fQki7kxktjyF51Q==
X-CSE-MsgGUID: FkWE3dCuQYGda8bedZPYRw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,182,1712646000"; 
   d="scan'208";a="33750154"
Received: from mtkaczyk-mobl.ger.corp.intel.com (HELO localhost) ([10.245.112.252])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 May 2024 07:37:51 -0700
Date: Thu, 23 May 2024 16:37:46 +0200
From: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To: Xiao Ni <xni@redhat.com>
Cc: linux-raid@vger.kernel.org, heinzm@redhat.com, ncroxon@redhat.com
Subject: Re: [PATCH 06/19] mdadm/tests: names_template enhance
Message-ID: <20240523163746.000005bf@linux.intel.com>
In-Reply-To: <20240522085056.54818-7-xni@redhat.com>
References: <20240522085056.54818-1-xni@redhat.com>
	<20240522085056.54818-7-xni@redhat.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 22 May 2024 16:50:43 +0800
Xiao Ni <xni@redhat.com> wrote:

> For super1, if the length of hostname is >= 32, it doesn't add hostname
> in metadata name. Fix this problem by checking the length of hostname.
> Because other cases may use need to check this, so do the check in
> do_setup.
> 
> And this patch adds a check if link /dev/md/name exists.
> 
> Signed-off-by: Xiao Ni <xni@redhat.com>
> ---
LGTM but I cannot apply this due to conflict after omitting 04.

Thanks,
Mariusz
