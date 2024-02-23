Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD71C664D7
	for <linux-raid@vger.kernel.org>; Fri, 23 Feb 2024 11:45:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708688748; cv=none; b=MOwyCoiceVRbecKVhkaJ9AgjFiqAgsIJVS6zNUR+6t7B+FXkadH2OMIhFaUnHVPAqvZ6qrAP9RTlZRzPFjFuBs4Vc59482rZ16bs1vdrStFqn7IFi7kY/RWiDajCOm40rYtWXRKHDIsug3/ZP8r3lC26kDGIvw/4jbuDHIhPPTo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708688748; c=relaxed/simple;
	bh=5QZBkIKcRffXNRIpI96Jgm5nxAvJJDBpYgohcflVJQo=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Wm9GKfFMRC2tXNxFd+TdJsKJptiyj3YlcoS4Ud6bVxHiGT6emcpL3mJtcm5A57dxoeKJASXGE2nuf6S2uxVNQZZuGhl9RJ9DtmQHC2ViLRNglf+uIaTJZRGvI6NN0WNt38I38kF7f/39AMBSevvJ1h3KWUU1zwQvG3OGgCGQbx4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Pk9fJjlF; arc=none smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Pk9fJjlF"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1708688747; x=1740224747;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=5QZBkIKcRffXNRIpI96Jgm5nxAvJJDBpYgohcflVJQo=;
  b=Pk9fJjlF9+zbc+dsr7ydouEB+NeEzMYPJIVaXQIYECVl9gqSJaPEF8f8
   9OPU5cBtzJkMldB0cZme435ZDnDtiCtEbLrAu98UTbO2b3w6FdoGGYwFe
   QSvwouG96jKouU6JchOh6UrfzqeJmDNH1xuphaL9wHr/qZLADmNDpafFn
   Ko5OF6abhNzODnYMDMGySQfKrStZ9UmCHFccTMJPW5mipWKo089gGBQFY
   slM3o0YP/j4aJLtHIJKTmGngI809mYvtrvDRH/yJpOpQ8pL/bqF7C43ku
   C/B8I3Vr6Ir2/sVyi77LcC0v34JzD8QfvnevSpq/cZYJNlanfKZzXPRgM
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10992"; a="28429782"
X-IronPort-AV: E=Sophos;i="6.06,179,1705392000"; 
   d="scan'208";a="28429782"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Feb 2024 03:45:46 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,179,1705392000"; 
   d="scan'208";a="6259837"
Received: from mtkaczyk-mobl.ger.corp.intel.com (HELO localhost) ([10.246.1.223])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Feb 2024 03:45:45 -0800
Date: Fri, 23 Feb 2024 12:45:39 +0100
From: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To: Mateusz Kusiak <mateusz.kusiak@intel.com>
Cc: linux-raid@vger.kernel.org, jes@trained-monkey.org
Subject: Re: [PATCH 0/6] SAST fixes
Message-ID: <20240223124539.000046c4@linux.intel.com>
In-Reply-To: <20240220105612.31058-1-mateusz.kusiak@intel.com>
References: <20240220105612.31058-1-mateusz.kusiak@intel.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 20 Feb 2024 11:56:06 +0100
Mateusz Kusiak <mateusz.kusiak@intel.com> wrote:

> This patchset contains minor fixes for issues reported by SAST tool.
> 
> Mateusz Kusiak (6):
>   Create: add_disk_to_super() fix resource leak
>   mdadm: signal_s() init variables
>   Monitor: open file before check in check_one_sharer()
>   Grow: remove dead condition in Grow_reshape()
>   super1: check fd before passing to get_dev_size() in add_to_super1()
>   mdmon: refactor md device name check in main()
> 
>  Create.c  |  6 +++++-
>  Grow.c    |  6 +-----
>  Monitor.c | 13 +++++--------
>  mdadm.h   |  5 ++---
>  mdmon.c   | 21 +++++++++++----------
>  super1.c  |  5 ++++-
>  6 files changed, 28 insertions(+), 28 deletions(-)
> 

All applied! 

Thanks,
Mariusz
