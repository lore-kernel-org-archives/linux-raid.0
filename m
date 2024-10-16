Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 774ED1CBA1B
	for <linux-raid@vger.kernel.org>; Wed, 16 Oct 2024 07:50:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729065051; cv=none; b=EumWLo3EJ0mZnxsXEIgJcCASn2A40NIeosLrYIKyE1tkwfg6oJoisDH0Oyun6kfLPBCRFM6ZNb/9EbNdo7b18dWYelv35rhp18bVGvRNN8CSrNwLTqCd/3U/NPsPMpwR0Ar4walzQlus2cyNRfyiy/3uZA3meeKExUjHShM5kNU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729065051; c=relaxed/simple;
	bh=Uu4AVoUV5M6nPtjZ0LDlHeoC8hL5ug3rvMxrW56sXLw=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Es8Op9BBxjKiwKllDtSmdc2Tvf7KI8YMZSmXXrHNxaugWvC8xbhNsFJxj4QoOsKKcAJWgnRTGQa+2kP1lNvv+We/w/WMUhhd2ddUuJOxGWQ/UdkPZO3IbAS4Ed+5dVyMFky7z8rWS5qp0vfyd8V4LTGyGyAd6Swacxor68TMM+M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=k+zw9DwT; arc=none smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="k+zw9DwT"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1729065050; x=1760601050;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Uu4AVoUV5M6nPtjZ0LDlHeoC8hL5ug3rvMxrW56sXLw=;
  b=k+zw9DwTO2BZjx/AgFmmm0GYB+ADOyazgbb93S+sWr0nFJ/UJYzmq9/I
   1MvBzpCS0UkKhVxoHRhJi4dPvDKW+Wf8x29Ts6bWiT0gjvGigPDUxN+ot
   wXZlnAJyclfc1hDjH1ClqMgFd0bzhhsV7NIC9CVbFLsnei2z62lY5nEq7
   uArt0z8mIyfWeaIUfBX2nFvE2ZOLoOAC5+Yusc411dNx6lacVTyPtMxcq
   skxBeFxZ3J+RJGmZjaa+YkcAhJ0g1esKobpcGQxhAWXGDAHVAYQaMeaPz
   iOtesPzVO0L+Xw2nFYFiliSyuSzW5KAwS0wEW+0dviVMeNQZRvHU4gCBr
   g==;
X-CSE-ConnectionGUID: gWXQJ+WUT8iATSeIlNJa1g==
X-CSE-MsgGUID: VBrVxcBvSzCcuj8P5/omZA==
X-IronPort-AV: E=McAfee;i="6700,10204,11225"; a="39130587"
X-IronPort-AV: E=Sophos;i="6.11,207,1725346800"; 
   d="scan'208";a="39130587"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Oct 2024 00:50:49 -0700
X-CSE-ConnectionGUID: LyyTS6yQSM6P/76emnSTfA==
X-CSE-MsgGUID: gab9lGiLRaua+UDYH0RI2A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,207,1725346800"; 
   d="scan'208";a="78981081"
Received: from mtkaczyk-mobl.ger.corp.intel.com (HELO localhost) ([10.245.112.252])
  by orviesa008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Oct 2024 00:50:48 -0700
Date: Wed, 16 Oct 2024 09:50:43 +0200
From: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Laurence Oberman <loberman@redhat.com>, linux-raid@vger.kernel.org
Subject: Re: [PATCH] Add the ":" to the allowed_symbols list to work with
 the latest POSIX changes
Message-ID: <20241016095043.00000201@linux.intel.com>
In-Reply-To: <Zw86MBHnb5PsbH6c@infradead.org>
References: <20241015173553.276546-1-loberman@redhat.com>
	<Zw86MBHnb5PsbH6c@infradead.org>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 15 Oct 2024 20:59:44 -0700
Christoph Hellwig <hch@infradead.org> wrote:

> What are "the latest POSIX changes"?
> 
> 

This is mdadm change, it is not kernel. I limited subset of supported symbols in
md device name to make it more portable and compatible with udev.

If you are interested, here are details:
https://git.kernel.org/pub/scm/utils/mdadm/mdadm.git/commit/?id=e2eb503bd797908f515b58428b274f1ba6a05349


Thanks,
Mariusz
