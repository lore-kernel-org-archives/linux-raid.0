Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4633172769
	for <linux-raid@vger.kernel.org>; Tue, 28 May 2024 15:16:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716909367; cv=none; b=qe4G0oMYbxmOteSWgvk/N45/9DeDjADwcIX9oGx77C1kQcqc/pfHs89QgvB90wUhCEnc29yeHZ1Qx4eS383XhINgGYIjr6btJZvOVUOn/W9vNhABMbK5qKQhITsqxzdio/mfGxDyBMAfo5t//W6UEbQsnF6oBriRwQAoB5t8Ns4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716909367; c=relaxed/simple;
	bh=xZd/ZF0CIl4/egABeKdoGEmzX8qdlQjXOc7dV1RvuTw=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=daGtmnnxQh3WZgUs3dCgCP9jIzara7R1Vnv8ftU5/BVeMUwHYpeb85OZYtjiZMf+D+xXuI9VdW7vwbWPZj7WIC239tKsCFoXu60WW33H12XtKjY7nyeVPz2IPjqAjYfQHDKWIM272XNHLRsPJZ/tffcf2o3HFg3O25EcKgCuzoM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=kwntvgpj; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="kwntvgpj"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1716909366; x=1748445366;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=xZd/ZF0CIl4/egABeKdoGEmzX8qdlQjXOc7dV1RvuTw=;
  b=kwntvgpjPRW2ZUbIQ7+z/xxZhZPIV/a0IHDoClHYCeRHKzj0U4lQXKme
   u6RNNQ2OCY3nYPCUs95cIZFvAADX6X7nz8mqaWDHaAtDLgQX9JwEOyvHk
   UQS+8uPdOd4Rcg5q7K8HKnqahhmF8cb7NGmlvzEPC8xe+wi8yqJNtG9dj
   SGpOTRcOpxBYekdgznrn+cVvuGMj5Aitf4I/Dexs6Bfcn8QKS5QuuECo7
   sVHQQvP21sINyZyd6gX9ywWvrLthAu23KeeExqRSXyqXZ66lfjjGoQOpQ
   bakWjXHg1Fu0oBf/NQDmuOgmzE656xFR9trNBbTGaIY5OczUPDLKz4nOw
   w==;
X-CSE-ConnectionGUID: kirlYTw8TCGiGe4bhB+2Hg==
X-CSE-MsgGUID: VH7dOMqET7SW2+FJd0gABw==
X-IronPort-AV: E=McAfee;i="6600,9927,11085"; a="30785634"
X-IronPort-AV: E=Sophos;i="6.08,195,1712646000"; 
   d="scan'208";a="30785634"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 May 2024 08:16:05 -0700
X-CSE-ConnectionGUID: ssVf+CFCS0aR3TVOVK3JKQ==
X-CSE-MsgGUID: +R3JljdpTuSrqyhynqQP0w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,195,1712646000"; 
   d="scan'208";a="35046851"
Received: from mtkaczyk-mobl.ger.corp.intel.com (HELO localhost) ([10.237.142.75])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 May 2024 08:16:04 -0700
Date: Tue, 28 May 2024 17:15:59 +0200
From: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To: Xiao Ni <xni@redhat.com>
Cc: linux-raid@vger.kernel.org
Subject: Re: [PATCH 0/4] mdadm/tests: fix and enhance some cases
Message-ID: <20240528171559.00002f14@linux.intel.com>
In-Reply-To: <20240528135150.26823-1-xni@redhat.com>
References: <20240528135150.26823-1-xni@redhat.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 28 May 2024 21:51:46 +0800
Xiao Ni <xni@redhat.com> wrote:

> Hi all
> 
> This is the third patch set that fix and enhance some test cases.

Applied all. Here some minor comments:
> 
> Xiao Ni (4):
>   mdadm/tests: bitmap cases enhance
>   mdadm/tests: 04update-uuid
you can remove testing of bitmap file.

>   mdadm/tests: 05r1-re-add-nosuper
same in this test.

I missed those tests but I wrote in 50b100768a11:

"The implementation of custom bitmap file looks like it's
abandoned. It cannot be done by Incremental so it is not respected by
any udev based system and it seems to not be recorded by metadata.
User must assemble such volume manually."

I do not consider it as a real-life feature. We should help it to become
deprecated (it is in kernel) and dropping tests is reasonable for me.

Thanks for patches,
Mariusz
