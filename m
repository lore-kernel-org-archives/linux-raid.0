Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65CF778C74
	for <linux-raid@vger.kernel.org>; Tue,  7 May 2024 06:47:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715064423; cv=none; b=EuiiU+/rmW9d6aoDdpQwrkpvbxCWGaPHYVe6yNYBH0rmk7Jl0h7ZpQvkY7FGoOHqgraz/BvmAFwP5R9DAaMowL5t8elpiKPVP4ZSRwRCXjmBPl8UGjFiSX90VLUHdOmHujnd0mQsQQKqniIQORJa1GRsxe47gcvwS1mm038woRM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715064423; c=relaxed/simple;
	bh=aWjbNgI8avz21lxwfyRy2zwhT6wP17R6ONRHRi9jdp8=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=cSpjKyMIDnuJEhEuK5g7BGtyMJxHMhpzzSIf0/FM7Yy8OiMFAySFZkki0NL4dK3qUxFel0ezZXiHVvhJbDATCGvA2wKfcwYl7Lontk5OwyqDJ0F6FvgI+/326uG3c5FqicgVAr6cFmoK3IXqlpuOOd6iHjcTWoayT1CZJwHWz8o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=m0boaWME; arc=none smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="m0boaWME"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1715064422; x=1746600422;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=aWjbNgI8avz21lxwfyRy2zwhT6wP17R6ONRHRi9jdp8=;
  b=m0boaWMETTETNqe6F5cBgFlSLjqasFo42UWzeB6QiY37wl0j/0NpKUSm
   UwmbbEHr0GzeLfYxSoQcSiaIF67lQuTmUBMFehUCozbtyZ8H4lGDAjHtd
   7N69EmbmoH95YlWLadvLr+hfNFo2hSn+2fbflJ9NDViQNeinV2ua1/3GV
   CGI/qReJW8EIbVUSO1gPt7H9kOePfvf5EkbjfzbzhoTncaeQlo/3uPbug
   15y+0aADHVaNVqc0buQGk84LoOwvzPpal46IqQpLoDvLVQUxbEZhUop7F
   4MhZnnsL1UbyN/UYsAyJD8Q5AfGKihI1fgd6aSWJEBK9Ynq8QDZ8gEnwt
   g==;
X-CSE-ConnectionGUID: cIrhl3rwQ4ixBdLPyf4+0w==
X-CSE-MsgGUID: rxlV/6RNSSmx0e26XGKwQQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11065"; a="21391161"
X-IronPort-AV: E=Sophos;i="6.07,260,1708416000"; 
   d="scan'208";a="21391161"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 May 2024 23:47:02 -0700
X-CSE-ConnectionGUID: FgzVRv2WRoup09LN2WXR/w==
X-CSE-MsgGUID: aXJwNQRAS9a1d2Xx1g0Njw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,260,1708416000"; 
   d="scan'208";a="28485434"
Received: from mtkaczyk-mobl.ger.corp.intel.com (HELO localhost) ([10.246.29.120])
  by fmviesa006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 May 2024 23:47:00 -0700
Date: Tue, 7 May 2024 08:46:56 +0200
From: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To: Fabrice Fontaine <fontaine.fabrice@gmail.com>
Cc: linux-raid@vger.kernel.org, Jes Sorensen <jes@trained-monkey.org>
Subject: Re: [PATCH] Makefile: add USE_PIE
Message-ID: <20240507084656.000036e4@linux.intel.com>
In-Reply-To: <CAPi7W837_3Jn_oK1y5_ud6_eJKZufpzdi75QuW7h1EUTpHcP-A@mail.gmail.com>
References: <20240505133923.267977-1-fontaine.fabrice@gmail.com>
	<20240506165644.000066aa@linux.intel.com>
	<CAPi7W837_3Jn_oK1y5_ud6_eJKZufpzdi75QuW7h1EUTpHcP-A@mail.gmail.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 6 May 2024 17:54:22 +0200
Fabrice Fontaine <fontaine.fabrice@gmail.com> wrote:

> > AFAIK -pie is not library specifier, it is a a gcc linking setting so
> > having it in LDLIBS seems weird to me. What about making LDFLAGS
> > configurable?  
> 
> Sure, moving -pie to LDFLAGS and allowing the user to override it will
> also work.

Could you please send v2 with possibility to customize LDFLAGS? You can add me
in Suggested-by.

Thanks,
Mariusz
