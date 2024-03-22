Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C23543D961
	for <linux-raid@vger.kernel.org>; Fri, 22 Mar 2024 11:18:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711106338; cv=none; b=gfvJzjiEdJWeugOpNnY3XzkQJSenzyHXkP2GR9Tq2iOM2MkhZ4gEg9WZ4MJ8KM64XC5wb0qa6U+lXGHwK9wDW6bhwo8Hv1UKt7Z5HHW0L5cCehQXb02x4epm6TN96yAa4jdaMwastFwtU4+c+JouVmdCTNUV7GJ6rwgS10kHT0E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711106338; c=relaxed/simple;
	bh=rfr7BpWx7GabSswkSmlQD3LGuJc2gs3LWRgi2J5ecmQ=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Vaw/H6UNmT6t6MCCmUYFtRK/NO9jtfS6gtOGEZ+y8aMbw24PeAB4YKUk4ZKaY8cyrOTj90FEwlqu8Enhb8uxJGYlbIlNItzk6DQByzuKgxv7d0oeNkkERJgPHu5XYS/8tIbvqw5V+ihpUddNcbVhsvF0KqV1Llybiqy8Eev/Z5U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=fmyIN3ql; arc=none smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="fmyIN3ql"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1711106336; x=1742642336;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=rfr7BpWx7GabSswkSmlQD3LGuJc2gs3LWRgi2J5ecmQ=;
  b=fmyIN3ql9jMpn3Gro/6lOmeMDaDZYS9k4KtTu9OiQClH8FCisaebkDQ+
   uc3byhzm6wHpzPhVhNXg/rib26eDbNR/n573mQVoks7QRYrJTRsxYNe3j
   Jd6qhohEp1s7XMzNzi9IQ5o9fcJeK7+RUS+/fkQFs9UgmP4vKbb3Ky76h
   F+vIG5yawN1fhgUI3LpBdb1V3h2oIrnwY5v7K+4l4njr3k49W4ak/YNK+
   TsgaQgULcT661wJ1/XY61pBDWbTvtei3QIj2WnObnmhsYD9Gkd+mySWIV
   joh9nIgctEXlOFUgf/T/XqpFT7v8FPTLq8UDdLt0VUT+3xlW1O6A2lgMX
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,11020"; a="6332955"
X-IronPort-AV: E=Sophos;i="6.07,145,1708416000"; 
   d="scan'208";a="6332955"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Mar 2024 04:18:56 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,145,1708416000"; 
   d="scan'208";a="19593739"
Received: from mtkaczyk-mobl.ger.corp.intel.com (HELO localhost) ([10.246.17.194])
  by orviesa005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Mar 2024 04:18:55 -0700
Date: Fri, 22 Mar 2024 12:18:50 +0100
From: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To: Mateusz Kusiak <mateusz.kusiak@intel.com>
Cc: linux-raid@vger.kernel.org, jes@trained-monkey.org
Subject: Re: [PATCH] sysfs: remove vers parameter from sysfs_set_array
Message-ID: <20240322121850.0000764f@linux.intel.com>
In-Reply-To: <20240318155331.1439-1-mateusz.kusiak@intel.com>
References: <20240318155331.1439-1-mateusz.kusiak@intel.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 18 Mar 2024 16:53:31 +0100
Mateusz Kusiak <mateusz.kusiak@intel.com> wrote:

> 9003 was passed directly to sysfs_set_array() since md_get_version()
> always returned this value. md_get_version() was removed long ago.
> 
> Remove dead version check from sysfs_set_array().
> Remove "vers" argument and fix function calls.
> 
> Signed-off-by: Mateusz Kusiak <mateusz.kusiak@intel.com>

Applied! 

Thanks,
Mariusz
