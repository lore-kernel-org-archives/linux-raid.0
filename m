Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF6E53EA83
	for <linux-raid@vger.kernel.org>; Fri, 22 Mar 2024 11:55:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711108556; cv=none; b=V2kVfx4FOI49CwTByO46joVzzT/7k4rvTlgtFiIP+4UzzmW0ktXPnjh/Ar2P1kslSjAuN7f5yqfnFiZ3U3JFK0qncEl15+Ek8dI3J14UhSqlRPlzmGRxaXuZxviDoZy4z0xeQpf8Gn/13QBWS0iWVgq/qL3HfyZB8Pd24AkTx9M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711108556; c=relaxed/simple;
	bh=9UIAxU6RtdKBPcG3x5y6tN7I7Dk9NcWOeHW3OSM0k+g=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YCa+hjv599Cy+T9Pg2pP4ZXZcG+WRjuKmeKWSX5Gc/SJfbecSDDdLLq2cI/PFXO1i8252lQwQnnf1eBwSR6gat7T83zUM7F1FIEleElTv97pKQBDjlFdLsSRpB65/V7svFIwEda7RwSq5nDmuxWPpLteCiYej5kGhA08DkZBZqM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=BH733YyB; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="BH733YyB"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1711108555; x=1742644555;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=9UIAxU6RtdKBPcG3x5y6tN7I7Dk9NcWOeHW3OSM0k+g=;
  b=BH733YyBtMabo66jqsj5/cBAHMdRtxLeBRav6pobRlhgx3JXZXrfME2R
   IEm6eWQ2DrQuLNs4ObVXYHo+7IpIOHhx1wPatO1lyvJLMWxD9HdFu3hOc
   msz/pqKjbhV6L9NXhMAN90prv2fCME8Ex+aPvIs157absVOzIJSxbeYhn
   MN8QTr99Fe7D3WzJ0On90i83i911NqrJs85p32trnFvmDJ8Pq4USLhaF/
   dqS//WIxQfo+Hr9XW+MldEOsO6E2Fh8JNhQ0L9EffUn6Wi2dTT942KvPL
   XNjxUKqmsKtMfd7Ul66gtcaZ9aM9P4PZFUAdlu7FNea8/rZuxNF9oyOop
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,11020"; a="17586948"
X-IronPort-AV: E=Sophos;i="6.07,145,1708416000"; 
   d="scan'208";a="17586948"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Mar 2024 04:55:38 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,145,1708416000"; 
   d="scan'208";a="19546025"
Received: from bkucman-mobl1.ger.corp.intel.com (HELO localhost) ([10.237.142.43])
  by fmviesa004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Mar 2024 04:55:36 -0700
Date: Fri, 22 Mar 2024 12:55:32 +0100
From: Blazej Kucman <blazej.kucman@linux.intel.com>
To: Paul Menzel <pmenzel@molgen.mpg.de>
Cc: Blazej Kucman <blazej.kucman@intel.com>,
 mariusz.tkaczyk@linux.intel.com, jes@trained-monkey.org,
 linux-raid@vger.kernel.org
Subject: Re: [PATCH 1/5] Add reading Opal NVMe encryption information
Message-ID: <20240322125243.0000544f@linux.intel.com>
In-Reply-To: <99cc0872-83f9-4c37-8050-9cbf95ace2c5@molgen.mpg.de>
References: <20240318162535.13674-1-blazej.kucman@intel.com>
 <20240318162535.13674-2-blazej.kucman@intel.com>
 <99cc0872-83f9-4c37-8050-9cbf95ace2c5@molgen.mpg.de>
Organization: intel
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hi Paul,

thanks for your review, I sent the corrections in V2.

On Mon, 18 Mar 2024 18:56:42 +0100
Paul Menzel <pmenzel@molgen.mpg.de> wrote:

> Dear Blazej,
>=20
>=20
> Am 18.03.24 um 17:25 schrieb Blazej Kucman:
> > For NVMe devices with Opal support, encryption information, status
> > and ability are completed based on Opal Level 0 discovery response.
> > =20
>=20
> What do you mean by =E2=80=9Care completed=E2=80=9D?
>=20
indeed, this word may not be precise, I meant "determined", I changed
it in V2.

and as for this comment
> Maybe document how to test this feature, preferebly with QEMU.

I added to patch "imsm: print disk encryption information",
example outputs for the new feature usage, for various cases, especially
SATA, it shows how it can be tested.

Thansk,
Blazej
