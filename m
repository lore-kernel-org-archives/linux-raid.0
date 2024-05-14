Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D4D6125C1
	for <linux-raid@vger.kernel.org>; Tue, 14 May 2024 09:01:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715677291; cv=none; b=PrcDQHVPaeFdXNBSf7r2eR3czM20LoQIRpwolWzIN/xEHFyxkQzV8zfqV4p2EjXlS5AmEtCzRzkloly83lQxY0dGMi3cUId672wEe2OXaUBxUGwi0YYPvvFpWB7WEgIm1jzSmSYC28vuCGNBsfQwKHoeg8bOfu1aha//WQdmOUQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715677291; c=relaxed/simple;
	bh=M073ElgU+KWL86rjx06xqLqFj9wZarS9EQ3B/0tyyg8=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CPe/jGjK2i8Fza52p+XOmEfH7O/5WsbAjLNI9+sB6D9bSQEXlEYELIzf2peVSyqU1Jr/Nt+n8pGALNknz7yp65gGsQuyk7tKvWAoGUobQL3hAX0Xs9pjTZWjqCV4QFDGwZHDzKlJSTKFkaeNzK0kAIKKCfV6SOtry0Fel5cuoKI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=UKF7mjiC; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="UKF7mjiC"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1715677290; x=1747213290;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=M073ElgU+KWL86rjx06xqLqFj9wZarS9EQ3B/0tyyg8=;
  b=UKF7mjiCxjs8dUAonypHol0IZJaqbfuNNd75t9G1A9cgy5vu+huPTTCP
   CrECIcqZwXdQC9ezpWdajBaBR/mO4fmsoBC5m30RWW639V40QqhgA7fAz
   j12MRwnUkFwcZmmo5wJT57MCbhGqwyJohTrL4pxdMNDBg0cHGtdu+/Qyr
   ELWmWgo6Aj1hwsYro4qjH4ykQRfUiCKYtnNBgObpIN5+8sVGtGZq4h1l7
   Lb0GsPfWzUZu+SZKHaM5e3wxEnAy6n/5cRVV2uR/9y+bckvlSdHYX0Aso
   OOVgLgVVOQARb+i8aHJYtkWjSacmiQaXcyyPS7kReArRJ8RliT7HOHawk
   g==;
X-CSE-ConnectionGUID: JZzD9wlFS+eBxraAHNstzQ==
X-CSE-MsgGUID: Pr0VTS2VSfiAGGp4Mx95Mg==
X-IronPort-AV: E=McAfee;i="6600,9927,11072"; a="11468549"
X-IronPort-AV: E=Sophos;i="6.08,159,1712646000"; 
   d="scan'208";a="11468549"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 May 2024 02:01:29 -0700
X-CSE-ConnectionGUID: WL2I3V8wSwKHeKd3+B+Law==
X-CSE-MsgGUID: fViOCL9ZTlKE638Q0MbKzw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,159,1712646000"; 
   d="scan'208";a="35072212"
Received: from mtkaczyk-mobl.ger.corp.intel.com (HELO localhost) ([10.246.29.120])
  by fmviesa005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 May 2024 02:00:33 -0700
Date: Tue, 14 May 2024 11:00:28 +0200
From: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To: linux-raid@vger.kernel.org
Cc: Hannes Reinecke <hare@suse.de>, Paul E Luse
 <paul.e.luse@linux.intel.com>, Paul Menzel <pmenzel@molgen.mpg.de>, Song
 Liu <song@kernel.org>, Kinga Tanska <kinga.tanska@linux.intel.com>, Jes
 Sorensen <jes@trained-monkey.org>
Subject: Re: [RFC PATCH v3 0/1] mdadm: Change main repository to Github
Message-ID: <20240514110028.000056d5@linux.intel.com>
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
> v3: Accept patches sent through Mailing List and add missed RFC tag.
> 
> Mariusz Tkaczyk (1):
>   mdadm: Change main repository to Github
> 
>  MAINTAINERS.md | 41 ++++++++----------------
>  README.md      | 86 ++++++++++++++++++++++++++++----------------------
>  2 files changed, 61 insertions(+), 66 deletions(-)
> 

No new comments. I'm going to apply this tomorrow!

Thanks,
Mariusz
