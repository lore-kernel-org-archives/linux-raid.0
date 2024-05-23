Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A09D14BFBC
	for <linux-raid@vger.kernel.org>; Thu, 23 May 2024 14:29:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716474566; cv=none; b=BaCODNy5dc26/2+vBQxmdQbLPkqqKMVLmjlbU/oXz/qklfWvTzuvpFpHOzHpCPQi6kFxOZQlfSoHBsQl6z6gH1fG6a6bfSuzcqr3OwVeFwv9NOgpHTneh0BQIzNMzQ/bq1wsllJiKrfFmv6VLcQX52doIW1AUj2NN3v1qnmKXNU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716474566; c=relaxed/simple;
	bh=rrzZ15hiFUTzngo/bs38CT3KnLX5h0sOkmBSTmvXIjc=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mYiz4FVs445yyrw+hLnp9mL8NUg6j357s9cmmgiout6VEl5f+mj9+bVMg+OCasP1fTA7LKxx9pynTc9G37MQnkW8ZnRdJau9hevrCnBwla4tMDNPR3Kyft2koCbYrARJfWpZeuv37Kn9isVdr6BGSXGPjbx7u0aJYRVeq08a76U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=bKfCkhVF; arc=none smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="bKfCkhVF"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1716474564; x=1748010564;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=rrzZ15hiFUTzngo/bs38CT3KnLX5h0sOkmBSTmvXIjc=;
  b=bKfCkhVF+t4QUvd1zRlVAytiKPHslEwqUn9x76k6ihYk9GU7hLJz5PSm
   bXRioXIgWp26zFqjcrW3JnvMUiFhNHcN1T1p0bbLkz9jdg+LP06E8kxwP
   uSFJ8eqzwLZE5Jvhof7x/PyswM/7dOFhhcrfId7HigeGvR9frTkktx5sz
   wS0jW8LToN4hzUqdmxLRTOH+rXfFRHQedB3t34E87Iy2D9dGjZyQhNc4t
   /OTxfdPX45apsMgcNQKWZnBVckvrMu7YceqMbYh7jEdlxwfpaiP3RwZit
   FQiTI21fuxajv6OjBK3bTdo3GeCZu8rGju5oYirWFDCcVRXmGeWCFTO6x
   A==;
X-CSE-ConnectionGUID: ossA3gxTQtGy+ea8cCcC+A==
X-CSE-MsgGUID: 14DARtJ1RGe+mycmzyTfng==
X-IronPort-AV: E=McAfee;i="6600,9927,11081"; a="12913093"
X-IronPort-AV: E=Sophos;i="6.08,182,1712646000"; 
   d="scan'208";a="12913093"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 May 2024 07:29:24 -0700
X-CSE-ConnectionGUID: oJLaqvExQEmaVhuhJvpPRw==
X-CSE-MsgGUID: 5IWxbvfYRuWH7uaa+uFW4g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,182,1712646000"; 
   d="scan'208";a="56926409"
Received: from mtkaczyk-mobl.ger.corp.intel.com (HELO localhost) ([10.245.112.252])
  by fmviesa002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 May 2024 07:29:22 -0700
Date: Thu, 23 May 2024 16:29:18 +0200
From: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To: Xiao Ni <xni@redhat.com>
Cc: linux-raid@vger.kernel.org, heinzm@redhat.com, ncroxon@redhat.com
Subject: Re: [PATCH 05/19] mdadm/tests: test don't fail when systemd reports
 error
Message-ID: <20240523162918.0000132b@linux.intel.com>
In-Reply-To: <20240522085056.54818-6-xni@redhat.com>
References: <20240522085056.54818-1-xni@redhat.com>
	<20240522085056.54818-6-xni@redhat.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 22 May 2024 16:50:42 +0800
Xiao Ni <xni@redhat.com> wrote:

> Sometimes systemd reports error in dmesg and test fails. Add
> a condition to avoid this failure.
> 
> Signed-off-by: Xiao Ni <xni@redhat.com>
> ---
Applied! 

Thanks,
Mariusz
