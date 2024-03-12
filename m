Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C794A811
	for <linux-raid@vger.kernel.org>; Tue, 12 Mar 2024 12:37:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710247081; cv=none; b=db3tf3z7HN1uiL3atRsQusDs46hXlymU6VPg3TiBev7imfSlk7kOjc7iRBOckjEmSqrC2pvx5qsrb094bI9AMy588+jJ9OsLU00/d+PLe5lp2DCqLv2/8opLjabpFTTEt/Bf9d5v5/nR0ijQqqcJYKxV/olINTBkzOQnfTwczG8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710247081; c=relaxed/simple;
	bh=ppUp1Oft/yKV7vK0ksJ6TZklLKuzoUhRsC54IDn+hBc=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bqY3XBcGvuBkDQjElBIM4zWd1BzUW62ztYFVavrQpD9pS2QzFh7HH/iJ5kOD9VMjewvHoIOmQf608Dw3ObLaj61sqcHbJbB58Sp1g2YUZjH0UqQbaX7cvclwR5lTwRM9WQCao6mtsKtlQu7sXA+ll7ikrC6e45ONNZbPaLeSPc4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=B6qT5ctG; arc=none smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="B6qT5ctG"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1710247077; x=1741783077;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ppUp1Oft/yKV7vK0ksJ6TZklLKuzoUhRsC54IDn+hBc=;
  b=B6qT5ctG/NRiiIs4Cu0WMX92cx4ygS5OMmD93tAYVlkGVD7gmnP/Strg
   s0WEEdsXtTkq+HZYtRX650oGwRlWXQfaGEHTtB8MFcTQgHdODVUAIpp7A
   jOn9n+KxioIR0yK0N63cXUcvNTAw958iWQMlzqfdGciz9kFdp4K0pDere
   x7QOfjqK0POgCUOVYOKvf8kdJktQqUMscJkeZV6tAAIRnRXpNKp+VevZR
   LHwYb0LfU9eoHkbkCss9tW9tY4n2SikntgPmNoCdG6GNFBmG9Vc1wyC8W
   wUJyXJ0fZYkRi5OhFsGlKxBEedm+QznQJsh1BBwqTS6f58qAmrv0zPbhD
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,11010"; a="5078171"
X-IronPort-AV: E=Sophos;i="6.07,119,1708416000"; 
   d="scan'208";a="5078171"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2024 05:37:57 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,119,1708416000"; 
   d="scan'208";a="16177912"
Received: from mtkaczyk-mobl.ger.corp.intel.com (HELO localhost) ([10.245.98.108])
  by orviesa004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2024 05:37:55 -0700
Date: Tue, 12 Mar 2024 13:37:50 +0100
From: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To: jes@trained-monkey.org
Cc: linux-raid@vger.kernel.org, Boian Bonev <bbonev@ipacct.com>
Subject: Re: [PATCH] udev.c: Do not require libudev.h if DNO_LIBUDEV
Message-ID: <20240312133750.00001a43@linux.intel.com>
In-Reply-To: <20240306145055.31744-1-mariusz.tkaczyk@linux.intel.com>
References: <20240306145055.31744-1-mariusz.tkaczyk@linux.intel.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed,  6 Mar 2024 15:50:55 +0100
Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com> wrote:

> libudev may not be presented at all, do not require it.
> 
> Reported-by: Boian Bonev <bbonev@ipacct.com>
> Signed-off-by: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
> ---
No comments..
Applied! 

Thanks,
Mariusz
