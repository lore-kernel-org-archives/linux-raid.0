Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BABD2575A
	for <linux-raid@vger.kernel.org>; Wed,  8 May 2024 10:29:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715164187; cv=none; b=XTxNX5OGs1mKq7AgkiZgmzQk5bp7sf/bvpLPX3+dJSaIE6hXgQCXNgeruowXNx0BxToSUb5YQkERdUvu/ewH+R26SO+MKragsoo69Vz+wZb3XhrYZRLMRQqJ2eZSV+wyuzf30srpeYnzud325s8CbYDs10ran8seHtS+jLvNB9c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715164187; c=relaxed/simple;
	bh=ViyKx6nAwk5qrm52gUEbSiRpK7b/Qwa1qvjH1qmFagY=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=i/NGqSQbOtI4HojMHx0lFPOKXc+60oIZqBvQQyviFqyNYal8PzHOwq/gXvLEcN6On44y82Twd6oQBhaexT5u8P1OL4K6Z9qhS7ipimAcFBHbUvPM0l9Dd2wgmF8JjtXcByv6dBCu3Uh99kTLMDg+HNHKU+7hs5fuT5C9BDCDGR4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=LYsvpKIC; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="LYsvpKIC"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1715164186; x=1746700186;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ViyKx6nAwk5qrm52gUEbSiRpK7b/Qwa1qvjH1qmFagY=;
  b=LYsvpKICliSS7ulfdFffsuAKuwmyDNhvw/rkY0q1qmC1n7Y+xENpf9TJ
   q6x58et9HE4pLQHhRLGj9HHF2Lim2UeQJyp2GkLWmqOj67kGf/imALQ3f
   UM79id3diyECEgddJfkv4Kd4uNB81rqUd82NUfDng+Z7iH6wpoisJcwhi
   C2cvoVJ0wCYEZRAkb1z8KgkZg8YHhgqw0lfYYeD/fMsnPmk91AJS/rTbk
   bi5jDsKyG1RWm9ebTWcMyj2lkr/uVH0lL6dhQlb4YmSJd5p3Qz3EGXFhf
   Kyve/2uwKROD9lCKpDUiCFHv8lFR/hQ5F1EIt6zdfFyIAUvyvcf/NWyO/
   g==;
X-CSE-ConnectionGUID: YJe0czQzQHuXbr9BerMQUQ==
X-CSE-MsgGUID: mde6huMQSf+ECCUAertTkw==
X-IronPort-AV: E=McAfee;i="6600,9927,11066"; a="28530730"
X-IronPort-AV: E=Sophos;i="6.08,145,1712646000"; 
   d="scan'208";a="28530730"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 May 2024 03:29:45 -0700
X-CSE-ConnectionGUID: iVi9fA6hT4uGc2Y1IHGteA==
X-CSE-MsgGUID: 0K4tk8INTlSQsuWlqYOCuA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,145,1712646000"; 
   d="scan'208";a="28782241"
Received: from mtkaczyk-mobl.ger.corp.intel.com (HELO localhost) ([10.246.29.120])
  by fmviesa008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 May 2024 03:29:44 -0700
Date: Wed, 8 May 2024 12:29:39 +0200
From: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To: Fabrice Fontaine <fontaine.fabrice@gmail.com>
Cc: linux-raid@vger.kernel.org, Jes Sorensen <jes@trained-monkey.org>
Subject: Re: [PATCH v2] Makefile: Move -pie to LDFLAGS
Message-ID: <20240508122939.000067c2@linux.intel.com>
In-Reply-To: <20240507173216.275378-1-fontaine.fabrice@gmail.com>
References: <20240507173216.275378-1-fontaine.fabrice@gmail.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue,  7 May 2024 19:32:16 +0200
Fabrice Fontaine <fontaine.fabrice@gmail.com> wrote:

> Move -pie from LDLIBS to LDFLAGS and make LDFLAGS configurable to allow
> the user to drop it by setting their own LDFLAGS (e.g. PIE could be
> enabled or disabled by the buildsystem such as buildroot).
> 
> Suggested-by: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
> Signed-off-by: Fabrice Fontaine <fontaine.fabrice@gmail.com>
> ---

We did compilation testing:
https://github.com/md-raid-utilities/mdadm/pull/5
Looks good. Applied!

Thanks,
Mariusz
