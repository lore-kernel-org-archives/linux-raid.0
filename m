Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 992CC13CF86
	for <linux-raid@vger.kernel.org>; Mon,  6 May 2024 14:56:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715007411; cv=none; b=dA1acgYACUG7qoHqzE/x07UrJmar9DV63HD1WPUBQvXb/tEifiMHKUcKMuBjCLnTNwIIZKRc4SjwBkiyy8ScXPD4SW5kUQSQfKnL2EB01fC5jHqwnr/4Ly0EzwM2KSDJ/097aRQNDmzCZBH4EQodLACJLvZq/xuUjutCdlxqjSU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715007411; c=relaxed/simple;
	bh=yp+z2/3zRKUMdDqGobx7bUPLx22oCmL9IzznxTHicZ4=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DuGKuPSmKXIhipI1OfRZ156zeZu+bS8mEc3veFfnp4o2FGghV+ejmKKVSKMWq/NMS2cgDtu+PYNv6eK26IhrViCHHXo/4RfRRc57Te2AzWFdpkyxCaYOcC//Rbllw0F1Xc+2gXBaEqbrd78e5lnK6pkskI0545ohjK4bxKQRnIk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=IK+r+gE0; arc=none smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="IK+r+gE0"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1715007411; x=1746543411;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=yp+z2/3zRKUMdDqGobx7bUPLx22oCmL9IzznxTHicZ4=;
  b=IK+r+gE0d9WNd2DPvKWeQmfnQSCJnWXA/vJsihqDVj83m0bYkMDgBnFg
   xBOtg/a8L6QTcQ3fTriwB9GXkfn3H+5g9AV2RXp+J6u2ZIIC1OIthNRiO
   i31rRZjntxDKbHntQITpb70zTMCVQ+DnQi69fUfJEA+8ED9M6kDJmPPVF
   WbMRgjOcVwZP7yoNXbNfwB0/lTjeNtc6DISxVJkrkHNCTIeJutd4WKwVK
   jCIqGG2PSbl7ChEzEvgeqMHU+gKkmv3Dad3LYZfPyyxm5bxHG40ixnPER
   olh6yv6gxPv6F2jseTrcrlkLzQhQPSnnaQys3i4Z3VpoB37Rljk5KfeCc
   Q==;
X-CSE-ConnectionGUID: yF5IpNt/T6eKum6OXpcHtA==
X-CSE-MsgGUID: ybrC8OcFQfucAD88AnS/Ww==
X-IronPort-AV: E=McAfee;i="6600,9927,11065"; a="14572996"
X-IronPort-AV: E=Sophos;i="6.07,258,1708416000"; 
   d="scan'208";a="14572996"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 May 2024 07:56:51 -0700
X-CSE-ConnectionGUID: WeniGtcxSLKZWYg8xJ0PAA==
X-CSE-MsgGUID: XV36s7hzThOzgW8ZviwidQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,258,1708416000"; 
   d="scan'208";a="32774839"
Received: from mtkaczyk-mobl.ger.corp.intel.com (HELO localhost) ([10.237.142.116])
  by fmviesa004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 May 2024 07:56:49 -0700
Date: Mon, 6 May 2024 16:56:44 +0200
From: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To: Fabrice Fontaine <fontaine.fabrice@gmail.com>
Cc: linux-raid@vger.kernel.org, Jes Sorensen <jes@trained-monkey.org>
Subject: Re: [PATCH] Makefile: add USE_PIE
Message-ID: <20240506165644.000066aa@linux.intel.com>
In-Reply-To: <20240505133923.267977-1-fontaine.fabrice@gmail.com>
References: <20240505133923.267977-1-fontaine.fabrice@gmail.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Sun,  5 May 2024 15:39:23 +0200
Fabrice Fontaine <fontaine.fabrice@gmail.com> wrote:

> Do not hardcode -pie and allow the user to drop it (e.g. PIE could be
> enabled or disabled by the buildsystem such as buildroot)

What about -fPIE? It is in CWFLAGS but it is configurable.
Do you specify you own set of CWFLAGS?

> 
> Signed-off-by: Fabrice Fontaine <fontaine.fabrice@gmail.com>
> ---
>  Makefile | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/Makefile b/Makefile
> index 7c221a89..a5269687 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -137,7 +137,11 @@ LDFLAGS = -Wl,-z,now,-z,noexecstack
>  # If you want a static binary, you might uncomment these
>  # LDFLAGS += -static
>  # STRIP = -s
> -LDLIBS = -ldl -pie
> +LDLIBS = -ldl
> +USE_PIE = 1
> +ifdef USE_PIE
> +LDLIBS += -pie
> +endif
>  
>  # To explicitly disable libudev, set -DNO_LIBUDEV in CXFLAGS
>  ifeq (, $(findstring -DNO_LIBUDEV,  $(CXFLAGS)))

AFAIK -pie is not library specifier, it is a a gcc linking setting so having it
in LDLIBS seems weird to me. What about making LDFLAGS configurable?

diff --git a/Makefile b/Makefile
index 7c221a891181..adac7905ab57 100644
--- a/Makefile
+++ b/Makefile
@@ -132,12 +132,12 @@ CFLAGS += -DUSE_PTHREADS
 MON_LDFLAGS += -pthread
 endif

-LDFLAGS = -Wl,-z,now,-z,noexecstack
+LDFLAGS ?= -pie -Wl,-z,now,-z,noexecstack

 # If you want a static binary, you might uncomment these
 # LDFLAGS += -static
 # STRIP = -s
-LDLIBS = -ldl -pie
+LDLIBS = -ldl

It works on my setup however I'm not deeply sure if it is correct.
Let me know if it resolves your issue. I would prefer to give possibility to
customize LDFLAGS rather than add ifdef to Makefile.

Thanks,
Mariusz
