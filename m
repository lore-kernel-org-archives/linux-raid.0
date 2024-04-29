Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C2A910A1D
	for <linux-raid@vger.kernel.org>; Tue, 30 Apr 2024 03:40:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714448440; cv=none; b=TfF8a9fahnXVSI2Hmn85rCUQevl1wRyaGa6sCxVw3mqMsK+wC4pvd7HWFFof9StBCmb6XsTT1zmUvMk1viLIKWKJQANvPa+c7SsiyCLHCA7vDXtX/WbnEWpe6VwT8ad0LyVKz1OFYJbJKwZIeoa9ha4hvz1JDVPGevhWH2UlzwQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714448440; c=relaxed/simple;
	bh=WTvMi5bXWOpTyE0N3+2dqiUUAJ1ICcPtsJ6ADOW+7vg=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dpMK6vz4o2j53j2VAB1LSxzHRRDIH5l5zns8ZstAry6FRqTZ6w2zUsJiAAQSoTvseapH/iWAAEhD1hCKJJlN+pVfGPhATRdWCGNk1EfTFPJYB16X4yjuiMP2TxVlQh6qKQJhZXmxzkW5tI24fPdR39sz1MRwfZbPXJatSj9pIsA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=d+ZC3kuI; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="d+ZC3kuI"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1714448439; x=1745984439;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=WTvMi5bXWOpTyE0N3+2dqiUUAJ1ICcPtsJ6ADOW+7vg=;
  b=d+ZC3kuIrn8VbqUB3nzWBolXJTbNjaY3dyKrcQ2rBiT3OatcdngPIjtD
   0njc6m/rrM4hQrfNYac1MVo+B+VOeKvvIjqeTuYaerXnI7HPo2gAVVVjM
   aVrRvcI1kXswpyHBCQeGEmEkJ+KJ7HIixEJAlRVWcj4Y3A+7RmpZ1QW2D
   LnPxheitcuvqJyG2iHIRyHlVshUtSOHa5oT1DnMlIKnkD0kPV3uGOp8L8
   6oOgJ1LZK3f5a7d6PkMNTvNGfbuOO6CseI3oOcUnPGaR/P2aSxHIGi5Rh
   TF3Uci2mZzrL98dt35+rrkW/Xg6sXugCB93M32EdKA64koXUwUP24CDCB
   A==;
X-CSE-ConnectionGUID: fHDsqscqTSKAzJEWLT2iVQ==
X-CSE-MsgGUID: sE61bnUcTYyr0H42HHi9hg==
X-IronPort-AV: E=McAfee;i="6600,9927,11059"; a="13064491"
X-IronPort-AV: E=Sophos;i="6.07,241,1708416000"; 
   d="scan'208";a="13064491"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Apr 2024 20:40:39 -0700
X-CSE-ConnectionGUID: Yfpo4uzWR+OxwxhDdhpvww==
X-CSE-MsgGUID: 62xw6JQJTNunEPo3M6jq8g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,241,1708416000"; 
   d="scan'208";a="63797837"
Received: from mlmudd-mobl1.amr.corp.intel.com (HELO peluse-desk5) ([10.209.144.206])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Apr 2024 20:40:38 -0700
Date: Sun, 28 Apr 2024 19:47:43 -0700
From: Paul E Luse <paul.e.luse@linux.intel.com>
To: Jes Sorensen <jes@trained-monkey.org>
Cc: linux-raid@vger.kernel.org, Mariusz Tkaczyk
 <mariusz.tkaczyk@linux.intel.com>, Song Liu <song@kernel.org>, Kinga Tanska
 <kinga.tanska@linux.intel.com>
Subject: Re: [PATCH 0/1] Move mdadm development to Github
Message-ID: <20240428194743.2704462f@peluse-desk5>
In-Reply-To: <96eee057-941f-48dc-8aad-c74039c0b1fe.maildroid@localhost>
References: <20240419014839.8986-1-mariusz.tkaczyk@linux.intel.com>
	<96eee057-941f-48dc-8aad-c74039c0b1fe.maildroid@localhost>
X-Mailer: Claws Mail 4.2.0 (GTK 3.24.41; aarch64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 29 Apr 2024 22:52:46 -0400
Jes Sorensen <jes@trained-monkey.org> wrote:

> Disappointed to see this :(
> 
> The github interface is not a favorite. Mailing lists are the way
> open source projects work.
> 
> I haven't had much time to contribute for quite a while now and
> probably won't in the near future. Given this decision was made
> without my involvement, I'll sign off.
> 
> Jes 
> 

Applaud the decision to 'sign off' despite personal preferences. I am
confident if things start going in the wrong direction that Mariusz
will course correct accordingly.

Thanks Jes :)

-Paul

> 
> -----Original Message-----
> From: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
> To: linux-raid@vger.kernel.org
> Cc: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>, Paul E Luse
> <paul.e.luse@linux.intel.com>, Song Liu <song@kernel.org>, Kinga
> Tanska <kinga.tanska@linux.intel.com>, Jes Sorensen
> <jes@trained-monkey.org> Sent: Fri, 19 Apr 2024 5:39 Subject: [PATCH
> 0/1] Move mdadm development to Github
> 
> Thanks to Song and Paul, we created organization for md-raid on
> Github. This is a perfect place to maintain mdadm. I would like
> announce moving mdadm development to Github.
> 
> It is already forked, feel free to explore:
> https://github.com/md-raid-utilities/mdadm
> 
> Github is powerful and it has well integrated CI. On the repo, you can
> already find a pull request which will add compilation and code style
> tests (Thanks to Kinga!).
> This is MORE than we have now so I believe that with the change mdadm
> stability and code quality will be increased. The participating method
> will be simplified, it is really easy to create pull request. Also,
> anyone can fork repo with base tests included and properly configured.
> 
> Note that Song and Paul are working on a per patch CI system using
> GitHub Actions and a dedicated rack of servers to enable fast
> container, VM and bare metal testing for both mdraid and mdadm.
> Having mdadm on GitHub will help with that integration.
> 
> As a result of moving to GitHub, we will no longer be using mailing
> list to propose patches, we will be using GitHub Pull Requests (PRs).
> As the community adjusts to using PRs I will be setting up
> auto-notification for those who attempt to use email for patches to
> let them know that we now use PRs.  I will also setup GitHub to send
> email to the mailing list on each new PR so that everyone is still
> aware of pending patches via the mailing list.
> 
> Please let me know if you have questions of other suggestions.
> 
> As a kernel.org mdadm maintainer, I will keep kernel.org repo and
> Github in-sync for both master/main branches. Although they will be
> kept in sync, developers should consider GitHub/main effective
> immediately after merging this patchset.
> 
> I will wait at least one week with merge to gather feedback and
> resolve objections. Feel free to ask.
> 
> Cc: Paul E Luse <paul.e.luse@linux.intel.com>
> Cc: Song Liu <song@kernel.org>
> Cc: Kinga Tanska <kinga.tanska@linux.intel.com>
> Cc: Jes Sorensen <jes@trained-monkey.org>
> 
> Mariusz Tkaczyk (1):
>   mdadm: Change main repository to Github
> 
>  MAINTAINERS.md | 41 +++++++++++----------------------
>  README.md      | 61
> ++++++++++++++++++++------------------------------ 2 files changed,
> 37 insertions(+), 65 deletions(-)
> 

