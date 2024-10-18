Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9483C17E00F
	for <linux-raid@vger.kernel.org>; Fri, 18 Oct 2024 12:51:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729255893; cv=none; b=VjyHjYeJ/rUBoeht+yGsBRVGd24w8wpvXCOazl4SqoPUvp6TZYKHALVocpH0QdnXR9LE0qkPO4bYp9EAoqIXMqwlwhkQZqeMSHDPuRk3G2LOvMbLk2NmMtvIxYaP1XjPqYxnija4y8EhqqQ1ExQHrxTzZ7Fc5LB/V7c5Cjqv1us=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729255893; c=relaxed/simple;
	bh=mQ/SjGlvX/VShK5omTwZTW7EOjjNVXodaOmEHT7WbL4=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KoPJyHkEjNzzav2tLc9d6ezdg+hKlV98vbDNnWrWXibV11gxMyOXP+jX5+G0tjQ6TTj+BVKoW9iaUniKvpInR2/P/3TsIXHykU5HPkCVipeH56RlxpydpFDqG7mP/JrVLNbnAyQ0P7MhujVdVPQx+WcDcfmt2ZeKjEH5UVsocrs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ZOBMF7rQ; arc=none smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ZOBMF7rQ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1729255892; x=1760791892;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=mQ/SjGlvX/VShK5omTwZTW7EOjjNVXodaOmEHT7WbL4=;
  b=ZOBMF7rQCbTa3Rv6INwQ6DhiDsFWX+GInhlVeed1KnvQx14J5IIKtRj7
   GFQFtfC95m2D/T5D3HwWF0zajiYlYA6oNusVRCqQH/p/scIlt35lr5s0j
   Sy7H4IwZ6jaSJ/3upHyr9NBJFXMGIU1mACrahfOCEZ2IwRdX5kDYFA8dD
   hB/bXsm1n5DafXdN5iHR6KGuWr3DnZOOuXGjb9O11w7UV2fXwWMJrY9j2
   j6izciKwxcaIoXiWfwCWquEDqBSZyh+JG3nDDjUy6bq9shf100nIPqNIN
   zGprazjn5h8Gf/GN5P8Qe6mAduQT690pKrs6pcWkMuirzxvKilsNi53zF
   A==;
X-CSE-ConnectionGUID: MXxdWT9MSOqk0dzj3PwUNg==
X-CSE-MsgGUID: bXqHfAA+THa1t1pcc4hZlQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11222"; a="28576680"
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="28576680"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Oct 2024 05:51:31 -0700
X-CSE-ConnectionGUID: 2RHuFokuRHehOoLawbacUA==
X-CSE-MsgGUID: q2y2Y79/TiKOnJXKYqs0aA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,213,1725346800"; 
   d="scan'208";a="78764128"
Received: from mtkaczyk-mobl.ger.corp.intel.com (HELO localhost) ([10.245.82.157])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Oct 2024 05:51:29 -0700
Date: Fri, 18 Oct 2024 14:51:25 +0200
From: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To: Xiao Ni <xni@redhat.com>
Cc: linux-raid@vger.kernel.org, ncroxon@redhat.com
Subject: Re: [PATCH 0/2] mdadm: minor fixes
Message-ID: <20241018145125.000067ac@linux.intel.com>
In-Reply-To: <20241018084817.60233-1-xni@redhat.com>
References: <20241018084817.60233-1-xni@redhat.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 18 Oct 2024 16:48:15 +0800
Xiao Ni <xni@redhat.com> wrote:

> Xiao Ni (2):
>   mdadm/Manage: Clear superblock if adding new device fails
>   mdadm/Grow: Check new_level interface rather than kernel version
> 
>  Grow.c   | 2 +-
>  Manage.c | 4 ++++
>  2 files changed, 5 insertions(+), 1 deletion(-)
> 

Applied! 

Thanks,
Mariusz
