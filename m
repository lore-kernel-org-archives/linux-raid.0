Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2879842A9B
	for <linux-raid@vger.kernel.org>; Fri, 26 Apr 2024 08:22:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714119767; cv=none; b=FU7zM2LU1OnCUqWBRe7poD9CZiYwWLbZ/8TEhKeqCNLfcHbv9Pu5nzzP0MkPVIi/3nfVxrchYXsg/uYA1BbjmiiqnLx/3OZ+Edqezoe4Vgm7NSQcHhYFe161uQFzI7B7340H+aWESzE0TWG6js7Vns1LZwibN+jTwIcF1/HF3UE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714119767; c=relaxed/simple;
	bh=grzShEjDXvKrolm2UluSnWEoM1cLwbCWDKv5tD98ZGE=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NeKHN6+tE9zRpt8jjwILbeYrkH5pvFjkuIfarsbS2HZsJZSOYQWJXsRW9AE0bMfx35199LGqZytbRnkEahcDSVLrwYuRgE7DIVw0dmFb6d3Pg96Drc9CQzEapVoJPNh44ma/4WU4EXqOFHNp5bfuBRQqxIBRH1iF9VPXg4ueNYI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Fv03ompY; arc=none smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Fv03ompY"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1714119767; x=1745655767;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=grzShEjDXvKrolm2UluSnWEoM1cLwbCWDKv5tD98ZGE=;
  b=Fv03ompY8D/7QEIgSPoMM1YTT+Npim8rJpY46FvWgZjxrIsvAiX04s0d
   X05554BJub8KUDNPfX7B8xoH5ircfj/gRqWi2979AALh2XRvEHcwj+0Js
   jzul3144M19Gm8gnS1d4lZ+yxJs8pPNEAinVK8IGY298V/Y1eFLxN9xrS
   jWTdi7v9U4iICEtxilI2J+WEj+S5gDidQNASvdNfvrnPm+e5kP008N+kC
   LttJZs2rL+KKDXQkqE1iZ++dg1j/9yLndpxVU1nL2EzWEaKrpwGq5nIjv
   w1Tb3dA92EHEJ0rhKZ+P/PIjJxsMffRUKXdJhAtUc1SNkSk3jdLGcRNqH
   w==;
X-CSE-ConnectionGUID: IR99uZi6SjWY0zGBok1djQ==
X-CSE-MsgGUID: Vesk3VaQQgWZK64looGRHA==
X-IronPort-AV: E=McAfee;i="6600,9927,11055"; a="20401583"
X-IronPort-AV: E=Sophos;i="6.07,232,1708416000"; 
   d="scan'208";a="20401583"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Apr 2024 01:22:46 -0700
X-CSE-ConnectionGUID: opPIlGepQbyaQw1g5B7apg==
X-CSE-MsgGUID: I2CBBEtVQ5Cdf3IHAW2ODw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,232,1708416000"; 
   d="scan'208";a="30005789"
Received: from mtkaczyk-mobl.ger.corp.intel.com (HELO localhost) ([10.245.82.157])
  by ORVIESA003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Apr 2024 01:22:44 -0700
Date: Fri, 26 Apr 2024 10:22:39 +0200
From: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To: Wols Lists <antlists@youngman.org.uk>
Cc: Paul E Luse <paul.e.luse@linux.intel.com>, John Stoffel
 <john@stoffel.org>, linux-raid@vger.kernel.org
Subject: Re: Move mdadm development to Github
Message-ID: <20240426102239.00006eba@linux.intel.com>
In-Reply-To: <3ba48a44-07fd-40dc-b091-720b59b7c734@youngman.org.uk>
References: <20240424084116.000030f3@linux.intel.com>
	<26154.50516.791849.109848@quad.stoffel.home>
	<20240424052711.2ee0efd3@peluse-desk5>
	<3ba48a44-07fd-40dc-b091-720b59b7c734@youngman.org.uk>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 26 Apr 2024 08:27:44 +0100
Wols Lists <antlists@youngman.org.uk> wrote:

> On 24/04/2024 13:27, Paul E Luse wrote:
> > * Instead of using the mailing list to propose patches, use GitHub Pull
> >    Requests. Mariusz is setting up GitHub to send an email to the mailing
> >    list so that everyone can still be made aware of new patches in the
> >    same manner as before.  Just use GitHub moving forward for actual
> >    code reviews.  
> 
> Does that mean contributors now need a github account? That won't go 
> down well with some people I expect ...
> 
> Cheers,
> Wol

Hi Wol,

There are thousands repositories on Github you have to register to participate
and I don't believe that Linux developers may don't have Github account. It is
almost impossible to not have a need to sent something to Github.

Here some examples:
https://github.com/iovisor/bcc
https://github.com/axboe/fio
https://github.com/dracutdevs/dracut
https://github.com/util-linux/util-linux
https://github.com/bpftrace/bpftrace
https://github.com/systemd/systemd

I see this as not a problem.

Thanks,
Mariusz
