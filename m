Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BE1A433C4
	for <linux-raid@vger.kernel.org>; Thu, 23 May 2024 14:20:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716474036; cv=none; b=HjT2ad/pn1VHxoV1hA4eafU41Xc5zsmNmsQuS+DpInzxRgOnez7kfRs6NDFt9oJhxtY8WfQKyDh90AmnwdK9TNBtip4ZD850n9uwQnGyqCl0FoVqskFGO/QgESA1wMLRAtdc2zKu6/pZLv5NREprdFau6gLg6e+GjbCdX3mKRGI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716474036; c=relaxed/simple;
	bh=oL4dVxZ2NyLtoo0Njvs3PJpU6Z98ugK3vIPfZTHzX2s=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pEHeRjC4elzpRdqXQijEdM5SIkz7dnNr1J0iVVhKpEjw6nuovF4BN8rH4M1DnuwydzbFJYOKghOnAhJ1xS13cijiSj7iYzRpxQ5jDgVNxJlILX3QKAcsYR3wCXz8VxPMFDGDPJfhBVSZkYwofwIgYtdHnxwqJYtij+eveYsvNqM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=FTa22W2r; arc=none smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="FTa22W2r"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1716474035; x=1748010035;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=oL4dVxZ2NyLtoo0Njvs3PJpU6Z98ugK3vIPfZTHzX2s=;
  b=FTa22W2rYhIZ0KJYtKmOuNqaPzAuMteFodr8Bz6SKPpWQE1uKTmMP8VY
   ndTmx/H53OSH9ETkVqtYRfwAQeSi0sv2Auk5qEDBU6/OPvhLQDLF13rOV
   F8iyu7OPtFR1LXz7aTV3Q95HPOYb5fQERuJbnszdRjW66fDGQ2ga7kNRp
   6cgfmRcfLZiBdF3hYddITD5LaVp6J4BKN3MxiKmy4PmFiyU4hCftJe2PY
   OoTVKL20qeBBxus+PhKlKNy1Ni3c8Bz+Ne2RCkhPwrLYlV2abnSb/yfHh
   lzvusAbV/WG5Txov1TpMQ+vvgRvgNRbHOtUNFi9mzM/SOnAASNUCfTJz7
   g==;
X-CSE-ConnectionGUID: QKlgY8oNSRKQcsUUYhH7DQ==
X-CSE-MsgGUID: 94Vgrdv+QT6KKSqte0icTA==
X-IronPort-AV: E=McAfee;i="6600,9927,11081"; a="12911484"
X-IronPort-AV: E=Sophos;i="6.08,182,1712646000"; 
   d="scan'208";a="12911484"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 May 2024 07:20:34 -0700
X-CSE-ConnectionGUID: oy+7brJCTkeUasf1YO/ycw==
X-CSE-MsgGUID: Hn4Y908XSbCiG/1bfsuHow==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,182,1712646000"; 
   d="scan'208";a="34152689"
Received: from mtkaczyk-mobl.ger.corp.intel.com (HELO localhost) ([10.245.112.252])
  by orviesa006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 May 2024 07:20:33 -0700
Date: Thu, 23 May 2024 16:20:28 +0200
From: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To: Xiao Ni <xni@redhat.com>
Cc: linux-raid@vger.kernel.org, heinzm@redhat.com, ncroxon@redhat.com
Subject: Re: [PATCH 01/19] Change some error messages to info level
Message-ID: <20240523162028.00007cc8@linux.intel.com>
In-Reply-To: <20240522085056.54818-2-xni@redhat.com>
References: <20240522085056.54818-1-xni@redhat.com>
	<20240522085056.54818-2-xni@redhat.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 22 May 2024 16:50:38 +0800
Xiao Ni <xni@redhat.com> wrote:

> These logs are not error logs. Change them to info level.
> 
> Signed-off-by: Xiao Ni <xni@redhat.com>
> ---
Applied!

Thanks,
Mariusz
