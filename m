Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F0151A581
	for <linux-raid@vger.kernel.org>; Tue, 16 Jan 2024 11:05:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="CJnWxWk8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1705403116; x=1736939116;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=gNSJpwB4DMh8XdvNfS2oLRudldZPn4jVZiyYyi5lQWM=;
  b=CJnWxWk8/Dw5AzzusglgsvkNgCzF0tYRm+VaR8dJcX07NNahY60mD+TA
   DsfQZ8/eSIMtqf1pk2bdEB9JCS3uel8lgDKR1uPG/iSdMWScoawtyTQjz
   wXa3TpidBWSbrdPdFfQPWhvqB+XXjVftYw+8z2iP1sGkRaeVmq3DiKKML
   sYw+1zqvcCTA/Hwt34Zfx1biH4L8TwKpR+Mdef6Y7kl3u1jdroaGTbc9e
   7GVEqvegSz5LSepQtUzQjzh1HMs/F9pEk4TRaX6SEiB+8KGtUI9awaVdl
   69Z9b0GdqLybwcgK1bso4abX0eIaAIzyZBeZjzPIkdNs2HB4PAaQReiJe
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10954"; a="390280072"
X-IronPort-AV: E=Sophos;i="6.04,198,1695711600"; 
   d="scan'208";a="390280072"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jan 2024 03:05:15 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10954"; a="784096072"
X-IronPort-AV: E=Sophos;i="6.04,198,1695711600"; 
   d="scan'208";a="784096072"
Received: from mtkaczyk-mobl.ger.corp.intel.com (HELO localhost) ([10.245.98.108])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jan 2024 03:05:13 -0800
Date: Tue, 16 Jan 2024 12:05:09 +0100
From: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To: Song Liu <song@kernel.org>
Cc: linux-raid@vger.kernel.org, jes@trained-monkey.org
Subject: Re: [PATCH v2 mdadm] tests: Gate tests for linear flavor with
 variable LINEAR
Message-ID: <20240116120509.000005a7@linux.intel.com>
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

Applied! 

Thanks,
Mariusz
