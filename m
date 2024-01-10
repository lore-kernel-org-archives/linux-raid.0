Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B6C047762
	for <linux-raid@vger.kernel.org>; Wed, 10 Jan 2024 10:54:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="SPKTlfTZ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1704884047; x=1736420047;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=L/+nbhLckbQA0dlq/Shejf6mE5ahF8aOWNxDfcMhlQw=;
  b=SPKTlfTZOlvIoIoCqEdsdoaFWXngUuuEEmh70FPvmFrRM7dceuHqznyX
   lPSDYfRLUTwrfAOPMZWumKNDZySQ48mr79fFJFcT3KCP6tv056aN+DhNf
   pJd4htH/lC54gZYVVPtxkNeWRhOBxNLyVxUjTzUZbQvYXec2hjbdg+LGP
   JxS3+lIy9KY9FQSqH9wyXPT4pVRjO4j1CyyIxQGokJMhkpJe9NRrumPvm
   xr5aheuvGz4orqMOQkg+wpfQlX8V0ZFDdrh8RGu48kBblvCANwPN3g7E/
   jP80drqs32gmpQOJcPl4Ai8aiKyUUZcsFlJ3ePnRCim0DS819gfcsgoZp
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10947"; a="402259722"
X-IronPort-AV: E=Sophos;i="6.04,184,1695711600"; 
   d="scan'208";a="402259722"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jan 2024 02:53:53 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10947"; a="775184892"
X-IronPort-AV: E=Sophos;i="6.04,184,1695711600"; 
   d="scan'208";a="775184892"
Received: from mtkaczyk-mobl.ger.corp.intel.com (HELO localhost) ([10.249.150.138])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jan 2024 02:53:51 -0800
Date: Wed, 10 Jan 2024 11:53:46 +0100
From: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To: Song Liu <song@kernel.org>
Cc: linux-raid@vger.kernel.org, jes@trained-monkey.org
Subject: Re: [PATCH v2 mdadm] tests: Gate tests for linear flavor with
 variable LINEAR
Message-ID: <20240110115346.0000226e@linux.intel.com>
In-Reply-To: <20240109230716.2433929-1-song@kernel.org>
References: <20240109230716.2433929-1-song@kernel.org>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue,  9 Jan 2024 15:07:16 -0800
Song Liu <song@kernel.org> wrote:

> linear flavor is being removed in the kernel [1], so tests for the linear
> flavor will fail. Add detection for linear flavor and --disable-linear
> option, with the same logic as multipath.
> 
> [1]
> https://lore.kernel.org/linux-raid/20231214222107.2016042-1-song@kernel.org/
> Signed-off-by: Song Liu <song@kernel.org> ---

Reviewed-by: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>

I will give few days for other folks to review.

Thanks,
Mariusz
