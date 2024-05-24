Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 852547604F
	for <linux-raid@vger.kernel.org>; Fri, 24 May 2024 07:59:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716537556; cv=none; b=CEjX0J1GFgdVFgTb1xcPYyN1g/tN9+9hQE8hwvO6p3pXkQnTSCfTzd6OsqbHYGHM6XVpdikYIZLtWxwp/F5aVZpsc/vjeBpkUm2CobLWDn5veWsm+DYI8pZtqa+sPSEPAwVr1jhulvOgRw+3YPOCLkHu2Efp+1uhqIenm3n/Qrg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716537556; c=relaxed/simple;
	bh=qsUKXqF/Ij1rL7OD4zHNlccFXcRmIGdKu3dHOF6Wecc=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rM9XUX0bK4W+uVni2qI1XDL7bt2nwvYDgmfb+cHTbqpVYhO/Zf5cPf09emrGxAi13xvYNH4+o/6QsE74pXt9DIK4ldVj66QUDSqM3m6nJMZkTDb8JtjT+ZgS35cnAii0U9W+qOk5c+qz+P2q82pZtF6eT6hoZ+iSEmB+lhzcfMA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=IKzFLi6y; arc=none smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="IKzFLi6y"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1716537555; x=1748073555;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=qsUKXqF/Ij1rL7OD4zHNlccFXcRmIGdKu3dHOF6Wecc=;
  b=IKzFLi6yXfne56PPejgS7P7J0teLTEZhhcTJ2QHBHWzTLEQJInLBdw8u
   SpOxwNqJhT7p8SO++7EdWGVIvXMAvk8jxFKgxYtP7AQXTr75yp7FRz8+t
   Wo9KS4h2P5IFPLd+YUT5VFycJOvTnAJv8MhtLXR1Eo5W/Rs7C26cRtOFO
   FZGA2oO2YwLyR/79LcY5cYTrlRKI+7wn1XS1Ov/2ZBuz6pcnYo8aD8YUD
   nhta5WhwKdYWGf0uHmhvJuYD++axqZZ5w6NQ5OYkDKolbaFJHUoCdQrqw
   hNS5oX3aJqlSHOR8kALfJJjHeQ7Qb90X3yPg1vtRgEBWQ1qQXrNFMyHOt
   A==;
X-CSE-ConnectionGUID: TNj7DYatT8OZE01yDNXbmA==
X-CSE-MsgGUID: 4CnU6OsZSYyRjRhU20Z9vA==
X-IronPort-AV: E=McAfee;i="6600,9927,11081"; a="38287650"
X-IronPort-AV: E=Sophos;i="6.08,184,1712646000"; 
   d="scan'208";a="38287650"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 May 2024 00:59:14 -0700
X-CSE-ConnectionGUID: TUbIx/dLQI6si1T2Xyp7Ng==
X-CSE-MsgGUID: pLt2u2GqQDe42Jbntq1mfQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,184,1712646000"; 
   d="scan'208";a="38385137"
Received: from mtkaczyk-mobl.ger.corp.intel.com (HELO localhost) ([10.237.142.64])
  by fmviesa003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 May 2024 00:59:13 -0700
Date: Fri, 24 May 2024 09:59:08 +0200
From: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To: Xiao Ni <xni@redhat.com>
Cc: linux-raid@vger.kernel.org, heinzm@redhat.com, ncroxon@redhat.com
Subject: Re: [PATCH 04/19] mdadm/tests: test enhance
Message-ID: <20240524095908.00002655@linux.intel.com>
In-Reply-To: <20240522085056.54818-5-xni@redhat.com>
References: <20240522085056.54818-1-xni@redhat.com>
	<20240522085056.54818-5-xni@redhat.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 22 May 2024 16:50:41 +0800
Xiao Ni <xni@redhat.com> wrote:

> There are two changes.
> First, if md module is not loaded, it gives error when reading
> speed_limit_max. So read the value after loading md module which
> is done in do_setup
> 
> Second, sometimes the test reports error sync action doesn't
> happen. But dmesg shows sync action is done. So limit the sync
> speed before test. It doesn't affect the test run time. Because
> check wait sets the max speed before waiting sync action. And
> recording speed_limit_max/min in do_setup.
> 
> Fixes: 4c12714d1ca0 ('test: run tests on system level mdadm')
> Signed-off-by: Xiao Ni <xni@redhat.com>
> ---
Applied! 

Thanks,
Mariusz
