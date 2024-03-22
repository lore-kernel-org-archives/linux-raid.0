Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 758C6224F2
	for <linux-raid@vger.kernel.org>; Fri, 22 Mar 2024 11:23:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711106593; cv=none; b=Ar2z6uA/4EE+Lx8FbDQOT7agBdRA0hZrIIhgoExXOk3h0Ev8R9Ms/aOX0L2K7ch0wm7d5WVQrT5qtsakz5h6NTQxIFH7ZhQKLeOsGg4sXj1WuwxpVjO4qkCV+3SYq5EFteJ/GYBKWbupZi6iWC1us959MaZqVQMIFlvnMe9GA6Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711106593; c=relaxed/simple;
	bh=3GLc0S6ZqF4mHFzt621mlyiw1zOrFElbFQjnwHiOJn8=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=IU1gMf3cEP6ySoGkxbmxDaXL6tofz4h/VgJ4bjQX7d5qqd4bsPU9ZKeZct949AJsgWXc7bZUkmO/MNSbC5dKRJmaJFCEOXNINobf4knwV/Pbn1rXt82Y7LvGO6/BaNKaccuHGL4+EgtHe95MK3GfKw+nF/+T/hovbbH83KB4SbY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=cC+VEKq2; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="cC+VEKq2"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1711106592; x=1742642592;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=3GLc0S6ZqF4mHFzt621mlyiw1zOrFElbFQjnwHiOJn8=;
  b=cC+VEKq2105cU7dlUTBL7HpjDuQ+Pxm23x3ctpSq53PbWOyKiuAl0kIX
   oiRoXqxEB3hrZ1YdAExABLdm9MiqlGx/DiMb8//wCHsbif3nv9BAkRTVF
   kZxNOsNdhZ0ji7+RvnDB44cnlTLBjUC2TNQX5y9LoLOJiMrIFoxtfTQVg
   eFh3s0mUQ1WlYqasUY4CQNUAcuSMzYO2TS6JCrESd/6DE/zCrHWWcvN/X
   Lk7TUO+YnuE4aLWOizYuBjvr8pS2hjh8GZBQyMx/uq9kxAeyAXPCPu2jz
   VfsfyykUFUpsNLqVRj4ZqbToen7C19oCWK+c43vgg9Jbj9hGm3FQXLDtH
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,11020"; a="5976909"
X-IronPort-AV: E=Sophos;i="6.07,145,1708416000"; 
   d="scan'208";a="5976909"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Mar 2024 04:23:11 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,145,1708416000"; 
   d="scan'208";a="14771855"
Received: from mtkaczyk-mobl.ger.corp.intel.com (HELO localhost) ([10.246.17.194])
  by orviesa010-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Mar 2024 04:23:10 -0700
Date: Fri, 22 Mar 2024 12:23:06 +0100
From: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To: Mateusz Kusiak <mateusz.kusiak@intel.com>
Cc: linux-raid@vger.kernel.org, jes@trained-monkey.org
Subject: Re: [PATCH] Remove all "if zeros" pt.2
Message-ID: <20240322122306.000004de@linux.intel.com>
In-Reply-To: <20240319101529.5098-1-mateusz.kusiak@intel.com>
References: <20240319101529.5098-1-mateusz.kusiak@intel.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 19 Mar 2024 11:15:29 +0100
Mateusz Kusiak <mateusz.kusiak@intel.com> wrote:

> Commit e15e8b00cbce ("Remove all "if zeros"") did not remove all "if 0"
> code blocks.
> 
> This commit is cleanup for that commit.
> 
> Signed-off-by: Mateusz Kusiak <mateusz.kusiak@intel.com>
> ---

Applied! 

Thanks,
Mariusz
