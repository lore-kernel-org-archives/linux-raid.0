Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD4B433EE
	for <linux-raid@vger.kernel.org>; Tue,  2 Apr 2024 06:32:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712039530; cv=none; b=q0TkTsWqM39jzMIQq/MINSgdmTTOk71XI1rj/6Xa2TlROPbZqqd+wmRdFk6fK9vcv12KW+zk5pHWLTMAE2doTMk34WlAaVkDOt9+yjLn/FjfbflGfDqvjoZlrnZPXHLH2FBP8jGuHxTYkWQlzD9dU+mI8SwW/Ca0Xk/up4EZ3OA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712039530; c=relaxed/simple;
	bh=HqMEqwy6ar7uMf+JWR+/oSUWXuscDJxuHXGIwlFoWMM=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=h3ocsybuitydyBoX1NwG4f/H1qfzmillZRqSi5gjcouI7se5VfD4K46ItXu2sqSu0O5uKlMmZ9hNZRVoSNpa0/VKFwvyGGKZm8natJO3QelMPkDdCXm+49QpMoOA/iBxcnJbven/CrbEe1dfgljOnq3beyDPja5nwsbSWL1FvjU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=KrIkKw2u; arc=none smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="KrIkKw2u"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1712039528; x=1743575528;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=HqMEqwy6ar7uMf+JWR+/oSUWXuscDJxuHXGIwlFoWMM=;
  b=KrIkKw2uNQyXhjBjQsbWRzHtyTYV5tGc9KgjG1A/+/oXs0FSA8SmKaIm
   0dEpAI2y0jZ8VA85dn3yJuo0GKTZvbmlvnOzpD3+Z8QYkCEsEXgekcRMJ
   FcE8AYQtPgO/fa8EhXoL04qhJruhN6rJUvv3OL+S5UUHDqNTSM5r02Mm4
   BCQQcLufaV6nl49uqpNVH2npk6KzzeIaFpiJ+6y7JEuTovDeUMqh1qazy
   96sdqeLaPIYNYHdTTLfC5vEmqzoG42zit3NFIIiyMlNGhwtLt4ERZR8+M
   Y7omh6CPq5Umsl37L9oixgwT0Vq0OjQut7rCAQc0JwIhVehwJyFP+giQ2
   A==;
X-CSE-ConnectionGUID: ms1Jd2eZTsO0NVo0liWk4Q==
X-CSE-MsgGUID: g48W/grXQ+C2FfnPOf1A+w==
X-IronPort-AV: E=McAfee;i="6600,9927,11031"; a="7125089"
X-IronPort-AV: E=Sophos;i="6.07,174,1708416000"; 
   d="scan'208";a="7125089"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Apr 2024 23:32:08 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,174,1708416000"; 
   d="scan'208";a="22404219"
Received: from mtkaczyk-mobl.ger.corp.intel.com (HELO localhost) ([10.245.112.252])
  by fmviesa005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Apr 2024 23:32:06 -0700
Date: Tue, 2 Apr 2024 08:32:01 +0200
From: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To: Blazej Kucman <blazej.kucman@intel.com>
Cc: jes@trained-monkey.org, linux-raid@vger.kernel.org
Subject: Re: [PATCH v2 0/6] Disk encryption status handling
Message-ID: <20240402083201.00003023@linux.intel.com>
In-Reply-To: <20240322115120.12325-1-blazej.kucman@intel.com>
References: <20240322115120.12325-1-blazej.kucman@intel.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 22 Mar 2024 12:51:14 +0100
Blazej Kucman <blazej.kucman@intel.com> wrote:

> The purpose of this series is to add functionality of reading information
> about the encryption status of OPAL NVMe/SATA and SATA drives and use this
> information for purposes of IMSM metadata, which introduces restrictions
> on the possibility of mixing disks with encryption enabled and disabled
> because of security reasons.
> 
> Changes in V2:
> - add separate patch for change location of pr_vrb(),
> - add example results for usage of new feature to commit message in patch 5,
> - adjust commit messages to 75 characters,
> - general fixes after review.
>

No more questions from community..
Applied!

Thanks,
Mariusz
