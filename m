Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F352117C9AC
	for <linux-raid@vger.kernel.org>; Fri, 18 Oct 2024 06:28:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729232909; cv=none; b=BveIbWINffojDfhy8WJ/VfB4DYda9tqQoDNYovm8X+u0RDzmcKqLsP1H0D2bnCeIcWuuDntRDzKy8VRU//jx266vtTL1I5QO13qMvaflQPJbf37JvGeGhPXSghO3ReI0BpzdvOTakYtLnNLvbVYGx0lNy30D+2g5VwT5bkQzvgQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729232909; c=relaxed/simple;
	bh=Tcx7NMf9xupMp1RkPlvfGY0TsW95h37wWFl3QRdDz88=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=SbtaqfThoqYTGz1sG7Lb/ocYrs3QwktddmspAK2mqHR+KuUrTNXGCvRViG/rb1sbEfawr1YfJ7AaXqnpqhBKniUmBzcEgS3aUVgjHlvQWD5gA0ZJIv+hd8419dXi0/gs1qljnU5s9Egk0WUz4bYtW1lpscnMIdR0l5IeynFZy6E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=hyz0EUyF; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="hyz0EUyF"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1729232908; x=1760768908;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Tcx7NMf9xupMp1RkPlvfGY0TsW95h37wWFl3QRdDz88=;
  b=hyz0EUyFdR2u60qd+a2odEjVPRsTlXQ5KOhFOmJR08L6GGmgRpnn2cKf
   p50rILAEhC8ZYTxRaXyD71rv0WuXtqDZt5fyYdCWl7huN+lz07NTgyNZy
   LmiJwtWwYB4VFrxA7NDgTtjjFWM9E5OW3DYoLqiaaiKy5yVspHTXVNpU4
   GWEdS+qTz0IulbYaTVv0QIh7Xu/F4BsWK0fcj/BISLOJ2Ua2gxV1ZJfX+
   F9kQIg3GbRIUoxCJQ6DGrDPjpACa1uYwp/YUdqzvoheFDe312Tkft/CHH
   jdHErQZZrDvmV43Dt0CcjjoG8Ii9vAiHAyjBx59fwrSbcAqRtMZ+XDkdQ
   Q==;
X-CSE-ConnectionGUID: uRW1FPsQQrWTUq9j3v4+WA==
X-CSE-MsgGUID: hoegQ1lTSCSuaLEV6hWldA==
X-IronPort-AV: E=McAfee;i="6700,10204,11228"; a="40115529"
X-IronPort-AV: E=Sophos;i="6.11,212,1725346800"; 
   d="scan'208";a="40115529"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Oct 2024 23:28:26 -0700
X-CSE-ConnectionGUID: hpHuc7/jR2i1cIZkHfd+KA==
X-CSE-MsgGUID: 1lucmg2vRV2uSuCrGEN38Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,212,1725346800"; 
   d="scan'208";a="83555001"
Received: from mtkaczyk-mobl.ger.corp.intel.com (HELO localhost) ([10.245.82.157])
  by orviesa005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Oct 2024 23:28:24 -0700
Date: Fri, 18 Oct 2024 08:28:19 +0200
From: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To: "Hellwig, Christoph" <hch@infradead.org>
Cc: Laurence Oberman <loberman@redhat.com>, Xiao Ni <xni@redhat.com>,
 linux-raid@vger.kernel.org
Subject: Re: [PATCH] Add the ":" to the allowed_symbols list to work with
 the latest POSIX changes
Message-ID: <20241018082819.00001d0f@linux.intel.com>
In-Reply-To: <ZxEtxXTLZVgP-_kJ@infradead.org>
References: <20241015173553.276546-1-loberman@redhat.com>
	<20241016101433.00005bb9@linux.intel.com>
	<5321cf0e579ee5e025396e9f9b62432dd2ed3458.camel@redhat.com>
	<CALTww29q5M_to+nN4G6rSdVMMbBj5orBjTE3dCUcBc6ZzAX1bg@mail.gmail.com>
	<20241017132631.00004d46@linux.intel.com>
	<5a53110cad3519de3990cbe4eb67acee72f9238b.camel@redhat.com>
	<49af106759fc1ec3da109c166c4c09e7251bf9e8.camel@redhat.com>
	<ZxEtxXTLZVgP-_kJ@infradead.org>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 17 Oct 2024 08:31:17 -0700
"Hellwig, Christoph" <hch@infradead.org> wrote:

> On Thu, Oct 17, 2024 at 11:27:24AM -0400, Laurence Oberman wrote:
> > I re-ran all the tests in house and I can actually start the arrays
> > that have the ":" in the names, just not create new ones. So I think we
> > leave this as is and we keep the adherence to POSIX for newly created
> > arrays only.   
> 
> Can we please stop talking about Posix compliance here?
> 
> The POSIX Portable Character Set is the minimum set of characters that
> need to be supported in each character set for Posix compliance.
> 
> Including other characters is perfectly Posix complain, just not fully
> portable.
> 

Right, good one. I named it just POSIX for simplicity and now we are abusing
it.

Cool, the main reasons ":" is excluded is special meaning for native metadata
and I still think it is right change. They can use --homehost option if they
want to customize it, it should be perfectly valid:

# mdadm -CR vol0 --homehost myhost -l0 -n2 /dev/nvme[45]n1 -z5G --assume-clean

# mdadm -E /dev/nvme4n1 | grep Name
           Name : myhost:vol0

Isn't result the same?
I still need to look into assemble issue to understand why it is not working.
Maybe there is small functional difference I'm not familiar with.

Thanks,
Mariusz
