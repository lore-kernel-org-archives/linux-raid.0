Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B16BD3C680
	for <linux-raid@vger.kernel.org>; Mon, 12 Feb 2024 15:20:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707751204; cv=none; b=A2jCv2XFRRtBZRgiUsCXAypFPkvP7OXkKySCZyvmX3k3AsoccFABnu+LmTQSjjxaKGQddtQcG7A5WPvkHyBhSuCxoajqsH9m9BkxpyVh4NU1g2b4g41i0rPAwjeU2dHBSS72aKWyl1ABxqZtLvvMMWkKImIOqBow1J7vG/kjaQs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707751204; c=relaxed/simple;
	bh=l1jYlHb/T/s4rVdk+cMBt7v4iTmwPQA0k52A1U1Jtlw=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kuk3BXglQAHItwuVsoq/oTLYTBy86Tupjn8XnbUnEARkzJS1NEN952Y8UcMJc1i7hMeWY1yPzSnCmBMhis6qst2U7w9UTptXSBKebLFe9/xPr3Nh1Xm8mlo06KG3LQhjXGjC6RAlVBmfKpfgPaZTmYtIqQIbDUg5puQoBHVORxc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Hq5QW9zt; arc=none smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Hq5QW9zt"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1707751203; x=1739287203;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=l1jYlHb/T/s4rVdk+cMBt7v4iTmwPQA0k52A1U1Jtlw=;
  b=Hq5QW9ztbr1lRN2PsnSKE+gCWj+u9rYaz7cX8veJdsM9NTDXAq1j90yC
   Uc5/dniwKniEa/VCwdBk1vrd8NPz6PazFFLPeb/wEeB/xLinNaeJxqveA
   DvrgVvkAeNaKaZ1B4Nc2vzv/IL/8BzET75TzhyMhDpm13RQSKXvGTq73r
   FJXMzDRDLqPGHfp+jt4gfvx/URMEkYxVSNIE1DAdevJzSsi37ixlMh6Ql
   Z3DKC+AIlIP/owrGOobvozgzRRxjfzm9tTTYfgp0fKyrAh4aTscUGrFBT
   2MPNGumMBsCjfeFpFCawm7wVeIa9r146b8nNn/eIdoTbq8D0+BBwfs8z5
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10982"; a="27175591"
X-IronPort-AV: E=Sophos;i="6.06,264,1705392000"; 
   d="scan'208";a="27175591"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Feb 2024 07:20:02 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,264,1705392000"; 
   d="scan'208";a="40077400"
Received: from mtkaczyk-mobl.ger.corp.intel.com (HELO localhost) ([10.237.142.42])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Feb 2024 07:20:01 -0800
Date: Mon, 12 Feb 2024 16:19:55 +0100
From: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To: Earl Chew <earl.chew@yahoo.ca>
Cc: linux-raid@vger.kernel.org
Subject: Re: mdadm --create vs --update with --homehost <ignore>
Message-ID: <20240212161845.00005b28@linux.intel.com>
In-Reply-To: <4325d3bb-a6d8-4d13-95b6-4f29db1a5206@yahoo.ca>
References: <4325d3bb-a6d8-4d13-95b6-4f29db1a5206.ref@yahoo.ca>
 <4325d3bb-a6d8-4d13-95b6-4f29db1a5206@yahoo.ca>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Sun, 11 Feb 2024 09:13:10 -0800
Earl Chew <earl.chew@yahoo.ca> wrote:

> Processing of --update blocks removal of homehost from existing arrays even
> though new arrays can be created without an embedded homehost.
> 
> Is there any concern allowing --update to remove of homehost from existing
> arrays?

I don't see any issue in making it possible so you need to try. I'm also fine
with removing homehost at all but I would like to hear native experienced user
opinion first.

Thanks,
Mariusz
