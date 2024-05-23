Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C094814B963
	for <linux-raid@vger.kernel.org>; Thu, 23 May 2024 14:26:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716474382; cv=none; b=T/mYS3eu1h2cq27hMYGrjJCrSlCRHCNOhDbzLUNQmNvVDHbK70M/FDgyV/DtpCjVQnzHu93D/z8iHfiMzVms/91mCca/j0Du9I0Nw/2ab90pYZyoHQM5Wucarcwn4d5+smj1qMZg4p+DwWnIs1pLiKo9rg3iq42hjitOu0vNDHw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716474382; c=relaxed/simple;
	bh=3pMhPwh1U2ljlHAnGOoEEtNUhNtU+Y17Ge8LOATHMnE=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=geI9O9bgFAqBRK03XJnVEZ2PLuPi1Jt+/e3HlOPOSMqUfUWuBloMFnzGhoFTbltzoF0ZbckPTSb4JErwZfY7OBXn2Ep0IhUBrbgHciJImrDQw2b3N6ZDayCASLgs90AuwK7P3Uu1jpoyBodB6GAhnRklAXax096KxLQlQcyAq+M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=FzCgJCOA; arc=none smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="FzCgJCOA"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1716474380; x=1748010380;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=3pMhPwh1U2ljlHAnGOoEEtNUhNtU+Y17Ge8LOATHMnE=;
  b=FzCgJCOADo0eyP7FLvBvY19VV2wAVZHyjpxPyY5o4w0VKWYPmdOkOApR
   V4XCToY8wYvzIA0z86XWZKjqcfI2Zyp/VY/aafeAwauzzv40Kaah1KQhd
   WwflP8axolgTj0nP7vMXuiRB8mPSQMQBwnN/HT0KOCDBaNPPe78mnWoSU
   cVKNvrckeVyyXmIWSFvAUQEJsr8SKieV0+E/FBWwdb72/GkXxIgdpnDKU
   /+B0P5HCb2TUC9tPSfX0wJIu3s1aShwoG2St37HxtqDfkvv6QgpACJRw9
   /vHOTSV6eULf4MDcQ5C2GODg9JKR7m1tkYWsiGjLHVLI+n9bFLNxwpLsp
   Q==;
X-CSE-ConnectionGUID: +l0ikVG+TzGPlU87g9+eog==
X-CSE-MsgGUID: zslPd600TnWrIpXBxWpXGQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11081"; a="12733861"
X-IronPort-AV: E=Sophos;i="6.08,182,1712646000"; 
   d="scan'208";a="12733861"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 May 2024 07:26:20 -0700
X-CSE-ConnectionGUID: lw04XVgRTrmMpnTaZgfcWQ==
X-CSE-MsgGUID: fpV+B5qISkWAsq4OWJoDpw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,182,1712646000"; 
   d="scan'208";a="38673407"
Received: from mtkaczyk-mobl.ger.corp.intel.com (HELO localhost) ([10.245.112.252])
  by orviesa004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 May 2024 07:26:19 -0700
Date: Thu, 23 May 2024 16:26:14 +0200
From: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To: Xiao Ni <xni@redhat.com>
Cc: linux-raid@vger.kernel.org, heinzm@redhat.com, ncroxon@redhat.com
Subject: Re: [PATCH 04/19] mdadm/tests: test enhance
Message-ID: <20240523162614.000049be@linux.intel.com>
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
>  test          | 10 +++++-----
>  tests/func.sh | 26 +++++++++++++++++++++++---
>  2 files changed, 28 insertions(+), 8 deletions(-)
> 
> diff --git a/test b/test
> index 338c2db44fa7..ff403293d60b 100755
> --- a/test
> +++ b/test
> @@ -6,7 +6,10 @@ targetdir="/var/tmp"
>  logdir="$targetdir"
>  config=/tmp/mdadm.conf
>  testdir=$PWD/tests
> -system_speed_limit=`cat /proc/sys/dev/raid/speed_limit_max`
> +system_speed_limit_max=0
> +system_speed_limit_min=0
> +test_speed_limit_min=100
> +test_speed_limit_max=500
>  devlist=
>  
>  savelogs=0
> @@ -39,10 +42,6 @@ ctrl_c() {
>  	ctrl_c_error=1
>  }
>  
> -restore_system_speed_limit() {
> -	echo $system_speed_limit > /proc/sys/dev/raid/speed_limit_max
> -}
> -
>  mdadm() {
>  	rm -f $targetdir/stderr
>  	case $* in
> @@ -103,6 +102,7 @@ do_test() {
>  		do_clean
>  		# source script in a subshell, so it has access to our
>  		# namespace, but cannot change it.
> +		control_system_speed_limit
>  		echo -ne "$_script... "
>  		if ( set -ex ; . $_script ) &> $targetdir/log
>  		then
> diff --git a/tests/func.sh b/tests/func.sh
> index b474442b6abe..221cff158f8c 100644
> --- a/tests/func.sh
> +++ b/tests/func.sh
> @@ -136,6 +136,23 @@ check_env() {
>  	fi
>  }
>  
> +record_system_speed_limit() {
> +	system_speed_limit_max=`cat /proc/sys/dev/raid/speed_limit_max`
> +	system_speed_limit_min=`cat /proc/sys/dev/raid/speed_limit_min`
> +}
> +
> +# To avoid sync action finishes before checking it, it needs to limit
> +# the sync speed
> +control_system_speed_limit() {
> +	echo $test_speed_limit_min > /proc/sys/dev/raid/speed_limit_min
> +	echo $test_speed_limit_max > /proc/sys/dev/raid/speed_limit_max
> +}
> +
> +restore_system_speed_limit() {
> +	echo $system_speed_limit_min > /proc/sys/dev/raid/speed_limit_max
> +	echo $system_speed_limit_max > /proc/sys/dev/raid/speed_limit_max
> +}
> +

Hi Xiao,
control and restore functions are not used or in this patch. if you want to use
them in next patches please highlight it in description.
Beside that LGTM.

I will loop over the patches and take as much I can. Looks like there are no
conflicts.

Thanks,
Mariusz
