Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24D9B811
	for <linux-raid@vger.kernel.org>; Tue, 12 Mar 2024 12:41:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710247281; cv=none; b=ct1qlERQvvvq3nGOZ7zD5EmebSX+xI8oe9qoQiyZVNG5c5xC8zCPzHFPRP2qtA1gXTnl2t97UDeecbtVA1Uz1Ef6K1nrDGH6I9eSOmLCDaxVUvQbSxV2Lns32aLbSn66lpdKb4O9An7zXLhNxSTBzIPwcrM3ffHkfpre3aoMdqk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710247281; c=relaxed/simple;
	bh=X1dONpG1YCsQpOFmiknNJ9ctPKFisbKcv2YTSlTUCDs=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CBuTWDhp8MtYwDQ5s9+ry5XvpJryQ2rcCQbMIPWriLtZlbJFUtlupCwmDU9pCOPtGNCN5CWSUzbQ03Azdv5OTk2IpuzDEkGjhgNGoI0YhnkaYJp42UCGssEn+jfkh7Zuiak+khCkRiONAXM360fgXmgoqhKSmF0Hxx0xffCPI1w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=T+Dkg5Ll; arc=none smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="T+Dkg5Ll"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1710247281; x=1741783281;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=X1dONpG1YCsQpOFmiknNJ9ctPKFisbKcv2YTSlTUCDs=;
  b=T+Dkg5LlpQM6YatMdvnZ7kuj2viK6c1ySg8iIXUmxmFZaBnlVPKJYV0r
   x6j5fkY9VelZ4K4BbsF42bYObSxrouuYdY5c+AhGwJXle1kz9nDbIuEun
   VJzYBdVmcgb9bEkZZg0HDS5OZ2LtqoHCvxiJArzuRV1xrml1W5ZKtnrZq
   AdXmQERWzvuATVuYnkwFjsw7h2JflJyZ6wGPViVDBNYF6ML6LpIu0Ij8d
   jzrvEfQyW5qgC2RyBSmldDUPrEkAsnzwhySd08fS9xOIeJmWDVoHUPePy
   YNY+lj8xnz5j0dKxeK+49H4dO1doxpEH+j2JVABsA17B2XWfkqz2TA7gi
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,11010"; a="5086930"
X-IronPort-AV: E=Sophos;i="6.07,119,1708416000"; 
   d="scan'208";a="5086930"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2024 05:41:20 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,119,1708416000"; 
   d="scan'208";a="11601669"
Received: from mtkaczyk-mobl.ger.corp.intel.com (HELO localhost) ([10.245.98.108])
  by fmviesa006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2024 05:41:18 -0700
Date: Tue, 12 Mar 2024 13:41:13 +0100
From: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To: Alexander Kanavin <alex@linutronix.de>
Cc: linux-raid@vger.kernel.org
Subject: Re: [mdadm][PATCH] util.c: add limits.h include for NAME_MAX
 definition
Message-ID: <20240312134113.00000c70@linux.intel.com>
In-Reply-To: <20240312100150.392586-1-alex@linutronix.de>
References: <20240312100150.392586-1-alex@linutronix.de>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 12 Mar 2024 11:01:50 +0100
Alexander Kanavin <alex@linutronix.de> wrote:

> Signed-off-by: Alexander Kanavin <alex@linutronix.de>

checkpatch raised:
> WARNING: Missing commit description - Add an appropriate one
>
> total: 0 errors, 1 warnings, 0 checks, 8 lines checked

I added description and applied it. No need to resend.

Thanks,
Mariusz
