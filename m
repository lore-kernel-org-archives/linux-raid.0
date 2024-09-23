Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7872C28684
	for <linux-raid@vger.kernel.org>; Mon, 23 Sep 2024 09:08:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727082531; cv=none; b=FUJswmony9gMhQH56Jd9N+CTz1hlO+p4RULq9JyT6cb/QQiwbnjH8Jh9ouDu/sR4stax3iXkZUCFi8rTMCdKpWvVJllqSH3fYf/UfaRaj4vCGIfJT7XsrfkAU/fz09e/HBVMG5vw+KDATZ8EVT2+D6Luy/MtrS2HOuiWY2aGvAw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727082531; c=relaxed/simple;
	bh=kSp6DsFshTarftJd+sWQ9BgXOoLyUxTscliGiOsugOM=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=D6PRsFt9QmXwvHa0JCIUzRi55/HSyLSoLtpKm+5imwtTYk8/rO4x3yPYE7pOxiX088a3NNEkmoSibpy+y64bb9QXJPO9Ysh5ALRJrhJk4rTGJb6mFrLX60bQiuDSFwxZT7bdNK+EDGFvXdxQQPxv+C/5GxFRH1JCjmARjHuaqOc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Qbf8x4IZ; arc=none smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Qbf8x4IZ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1727082530; x=1758618530;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=kSp6DsFshTarftJd+sWQ9BgXOoLyUxTscliGiOsugOM=;
  b=Qbf8x4IZ5TwtFzYHYeqhrvMWgKWjjuc8HGQ/uvFAc6/tqHRIe9dgxVBr
   rhrwM4FYtsFNcF+kSsPydBLMg0VWO1h5yFL/bxl+MzJqil2JNcrNslEqv
   8dW4tUpmCsvU2Wpw2VopLtkl2f4FxsS/VwXyLPePVqXvQsWdZBi7S1cna
   fJetPNbIQd8ShoQsf0eOLDPqy30onKtpKsnCeqVDPK50DsFTsUCpIn8gs
   p/wKEE8zwRCctcfxmKR9SvR8XYXjoeHsMfMKtWhX87Ked+4/0uOYgFKfQ
   S1ZVvWtP3DtSZj2b4YNJyfLF+ALxdrfDMYmGuDvPbtE0mCG+EXDHewFbi
   w==;
X-CSE-ConnectionGUID: N2XyAzn6T0W7xZ0BbhYmIw==
X-CSE-MsgGUID: 7MhqYcX5SjuK+hf4YLVjnQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11202"; a="25885515"
X-IronPort-AV: E=Sophos;i="6.10,250,1719903600"; 
   d="scan'208";a="25885515"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Sep 2024 02:08:49 -0700
X-CSE-ConnectionGUID: GRfkJzdVQEmuwIdVUv1nWg==
X-CSE-MsgGUID: SEok8QU+SCeSXj40zLHBOQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,250,1719903600"; 
   d="scan'208";a="71314142"
Received: from mtkaczyk-mobl.ger.corp.intel.com (HELO localhost) ([10.246.17.194])
  by orviesa006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Sep 2024 02:08:47 -0700
Date: Mon, 23 Sep 2024 11:08:42 +0200
From: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To: Xiao Ni <xni@redhat.com>
Cc: linux-raid@vger.kernel.org, ncroxon@redhat.com
Subject: Re: [PATCH 09/10] mdadm/tests: remove 09imsm-assemble.broken
Message-ID: <20240923110842.000024ac@linux.intel.com>
In-Reply-To: <20240911085432.37828-10-xni@redhat.com>
References: <20240911085432.37828-1-xni@redhat.com>
	<20240911085432.37828-10-xni@redhat.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 11 Sep 2024 16:54:31 +0800
Xiao Ni <xni@redhat.com> wrote:

> 09imsm-assemble can run successfully.
> 
> Signed-off-by: Xiao Ni <xni@redhat.com>
> ---
>  tests/09imsm-assemble.broken | 6 ------
>  1 file changed, 6 deletions(-)
>  delete mode 100644 tests/09imsm-assemble.broken
> 
> diff --git a/tests/09imsm-assemble.broken b/tests/09imsm-assemble.broken
> index a6d4d5cf911b..000000000000
> --- a/tests/09imsm-assemble.broken
> +++ /dev/null
> @@ -1,6 +0,0 @@
> -fails infrequently
> -
> -Fails roughly 1 in 10 runs with errors:
> -
> -    mdadm: /dev/loop2 is still in use, cannot remove.
> -    /dev/loop2 removal from /dev/md/container should have succeeded


you created dev/null (probably accidentally). I will remove it in new
commit because I already merged it.

Thanks,
Mariusz
