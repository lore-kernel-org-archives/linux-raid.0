Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B44705A0E0
	for <linux-raid@vger.kernel.org>; Wed, 15 May 2024 09:24:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715765045; cv=none; b=cxmzRjhfRRP7i3QiI6oKUc7AUBfJ0FgveIHcZYjrfjjCp+PLXMow8dawiL/nECZmhBSbwrK+jjk9JI1K+fKvsEWOeQULratwD4lxT0DrKzLuo0ltieBYm+kwtO3d3h5WbiVulJlfNBo7k1+LdJXhmsLk7f7P/yX2s75jakjlXN0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715765045; c=relaxed/simple;
	bh=/ZG4pfLqgbc3VZ8OVy1+aCXNWSAKF2eU1nIlpno4+BA=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lIb8CXJUOiyo7a6CxlTmT0yHpjTxQrc6P0O0GXy1FSPzQijWbdSTYlV8+wJGpqfw1Yog9ubKDq0TrQMDXHdrUZiaJzP1NymFum3ULF/r6D+Gp5Ca5ZTkCy6XBDYkO766omPhibsYfQ2xfWQJz/oz7AfOHgjm0puOxJIRGErhMng=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=hK9LJ1oL; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="hK9LJ1oL"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1715765044; x=1747301044;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=/ZG4pfLqgbc3VZ8OVy1+aCXNWSAKF2eU1nIlpno4+BA=;
  b=hK9LJ1oL5NQjaVUQJaDM5ZXwRyjn5MBSc1Hvkp3VheC7UkoT+KKyMD1L
   WN71oH9Lazb4srGtGODF9CgdkUPxmzs30sUniSE5z2W31500yGuRYeLda
   1z8iBKcSgrhbMjMIxzNhBWKtGs289pWJUdp0pSUDuGocsDi2cjUAkZaYk
   MIAuORuZZo6aKlmecYk5p6xPlWnLE6e2Q45Wo5leRpsUWZNjpz5iCSqeH
   0AFNsL6IrhihLp3AtT/VsPjH0hSwmjMkTk4TaE2yIowHKAOaoGpm/Lsv4
   MnSzwNDCaqVB9OU5Ljpm39yNm3qP6M7K0qYDPKHfXlInccu82+g81Y9dM
   A==;
X-CSE-ConnectionGUID: LfGQHrfnRPycEujdJkrVAw==
X-CSE-MsgGUID: mwfZtwPOT3ykyJlQBFf+Og==
X-IronPort-AV: E=McAfee;i="6600,9927,11073"; a="29291434"
X-IronPort-AV: E=Sophos;i="6.08,161,1712646000"; 
   d="scan'208";a="29291434"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 May 2024 02:24:04 -0700
X-CSE-ConnectionGUID: Eu5NqpLLR+KcOqP8FjAmFw==
X-CSE-MsgGUID: 05OGmLmOSMy4ybGT0jLopg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,161,1712646000"; 
   d="scan'208";a="68443371"
Received: from mtkaczyk-mobl.ger.corp.intel.com (HELO localhost) ([10.245.82.157])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 May 2024 02:24:01 -0700
Date: Wed, 15 May 2024 11:23:56 +0200
From: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To: linux-raid@vger.kernel.org
Cc: Hannes Reinecke <hare@suse.de>, Paul E Luse
 <paul.e.luse@linux.intel.com>, Paul Menzel <pmenzel@molgen.mpg.de>, Song
 Liu <song@kernel.org>, Kinga Tanska <kinga.tanska@linux.intel.com>, Jes
 Sorensen <jes@trained-monkey.org>
Subject: Re: [RFC PATCH v3 0/1] mdadm: Change main repository to Github
Message-ID: <20240515112356.00002dfe@linux.intel.com>
In-Reply-To: <20240507153509.23451-1-mariusz.tkaczyk@linux.intel.com>
References: <20240507153509.23451-1-mariusz.tkaczyk@linux.intel.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue,  7 May 2024 17:35:08 +0200
Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com> wrote:

> Thanks to Song and Paul, we created organization for md-raid on Github.
> This is a perfect place to maintain mdadm. I would like announce moving
> mdadm development to Github.
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
> Note that Song and Paul are working on a per patch CI system using GitHub
> Actions and a dedicated rack of servers to enable fast container, VM and
> bare metal testing for both mdraid and mdadm. Having mdadm on GitHub will
> help with that integration.
> 
> Patches sent to ML will be accepted but Github Pull Requests are
> preferred so please use mailing list only if it is necessary. I will
> setup GitHub to send email to the mailing list on each new PR so that
> everyone is still aware of pending patches via the mailing list.
> 
> As a kernel.org mdadm maintainer, I will keep kernel.org repo and Github
> in-sync for both master/main branches. Although they will be kept
> in sync, developers should consider GitHub/main effective immediately
> after merging this patchset.
> 
> I have strong confidence that it is good change for mdadm but I
> understand that review flow will be worse.
> 
> Thanks all for comments!
> 
> Cc: Hannes Reinecke <hare@suse.de>
> Cc: Paul E Luse <paul.e.luse@linux.intel.com>
> Cc: Paul Menzel <pmenzel@molgen.mpg.de>
> Cc: Song Liu <song@kernel.org>
> Cc: Kinga Tanska <kinga.tanska@linux.intel.com>
> Cc: Jes Sorensen <jes@trained-monkey.org>
> 
> v2: Highlight that linux-raid@kernel.org remains as main place for
>     questions and discussions.
> v3: Accept patches sent through Mailing List and missed RFC tag.
> 

I'm scared that I'm doing it but I need to finish what I started.

I know that I'm pushing some of you to make it happen. I don't feel comfortable
with this but changes like this requires some self-confidence. I believe that it
is right thing to do.

This is not one way ticket, we can always take step back if after the time we
will realize that my decision was wrong or review flow is awful. There will be
adjustments for sure.

Thanks you all for helping me to make this happen. I will not push you to use
Github but I encourage you to try if you can.

Applied!

Thanks,
Mariusz
