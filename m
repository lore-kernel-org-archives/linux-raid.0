Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AD46140E38
	for <linux-raid@vger.kernel.org>; Tue, 22 Oct 2024 11:25:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729596318; cv=none; b=dX3wxgStxkxkrG5i8uFicvHMYuKH80g88n1LOEh8EfD7j01G3cLmRPnOtFc9ekjgQVjfr5xzufzEbr1lQCuWue4zPjOOn6vcnbGebvQqoHHqXJxiCaD958ugI2HJzBkm00DSKgQI/kOBIZQ4NdiQgiqrjczYLddugeAur1fHXVE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729596318; c=relaxed/simple;
	bh=zDN6FLbXTfODlZZg7lcxCgekUOqadjXHsfJuo3yVWjM=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HdceCdGRElPrdYGP4/Dg+aF2CaGkB4+1XkMcrMkl18lWo6M4BROY40tohHCu4e0uzplUgWZFl6lzZo2ovkiGw+Yfv/DTohPkhS9fgzxIf9zq3kNI/4a0k/vIlsNKw1bdFc7fIgidJbGtyJ+BqmAzG25JOuOWK0FbZApzMv5df4c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Wq66Xdoy; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Wq66Xdoy"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1729596316; x=1761132316;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=zDN6FLbXTfODlZZg7lcxCgekUOqadjXHsfJuo3yVWjM=;
  b=Wq66Xdoy1g6hg2qvW5Ud9Qg1f9w3s0XYiMvWDsvT7XzedH6DM0E+Hcwp
   wfU5LBMzOEXxa5B4d1QJ4/A6lrbqxHkW8Ae3d5YGoHy1+ce3tOXgR34ve
   HUkY4nnFjlHPP99VqlQfb9UsAr7jdlHU25uoRgaS2kjbUtbmNS2GVPQjM
   iGmouyTC6QnC4uvF7oC1cQeCR7VsgDGUffV3XA6pEZLTh/VWPK0bLTpUe
   CgtF/ER2fOdxCkadXd6PacBML5sy9IbMFAtkYmTZ2LQSoHpIGv6aQVxNX
   4o6nXTEirjMFRdw49w4rSrCXfsV8ks+utPzfRPF65sc/NmqKIYa8Xo+NA
   w==;
X-CSE-ConnectionGUID: 8wnvwZv0RtWQFaHdSRBNZA==
X-CSE-MsgGUID: 72ijpfnUQlWaCn2IKXPgpA==
X-IronPort-AV: E=McAfee;i="6700,10204,11222"; a="29001207"
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="29001207"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Oct 2024 04:25:16 -0700
X-CSE-ConnectionGUID: 1fk6ZM00SReXg78JPTkQCQ==
X-CSE-MsgGUID: bsV2D2uIQceH4kXuRm5qbQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,223,1725346800"; 
   d="scan'208";a="79854775"
Received: from unknown (HELO localhost) ([10.217.182.185])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Oct 2024 04:25:15 -0700
Date: Tue, 22 Oct 2024 13:25:10 +0200
From: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To: Marc Haber <mh+linux-raid@zugschlus.de>
Cc: linux-raid@vger.kernel.org
Subject: Re: Cannot update homehost of an existing array: mdadm: /dev/sda3
 has wrong name.
Message-ID: <20241022132510.0000151f@linux.intel.com>
In-Reply-To: <Zxa6knvDsm6KlNkH@torres.zugschlus.de>
References: <ZxNSmXIdVlQMWf9x@torres.zugschlus.de>
	<0e2df2b5-1215-44c3-b41a-086782c5fc37@demonlair.co.uk>
	<ZxQTFA8Mwi8V5jye@torres.zugschlus.de>
	<20241021085132.00000cad@linux.intel.com>
	<Zxa6knvDsm6KlNkH@torres.zugschlus.de>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 21 Oct 2024 22:33:22 +0200
Marc Haber <mh+linux-raid@zugschlus.de> wrote:

> Hi Mariusz,
> 
> thanks for your answer.
> 
> On Mon, Oct 21, 2024 at 08:51:32AM +0200, Mariusz Tkaczyk wrote:
> > I'm looking into Incremental right now and there is a comment:
> > 
> > 	 * 3/ Check if there is a match in mdadm.conf
> > 	 * 3a/ if not, check for homehost match.  If no match, assemble as
> > 	 *    a 'foreign' array.
> > 
> > I believe that this is kind of "foreign" naming for native raid.  
> 
> But the array is not intended to be considered as foreign, it is running
> on its native host.
> 
> Good call, I indeed forgot updating mdadm.conf. And I also forgot that
> we are on Debian stable with a current kernel now, that means Kernel
> 6.11.3 and mdadm 4.2
> 
> > You can probably correct it by updating your mdadm.conf or you can update
> > your homehost to production system hostname.  
> 
> It now says:
> HOMEHOST <system>
> ARRAY /dev/md/myrealhostname:md_root metadata=1.2 name=myrealhostname:md_root
> UUID=9d455b1e:35a52a2b:59b2bc1a:db22369f The ARRAY line is what mdadm
> --detail --scan prints, and hostname(1) returns "myrealhostname". And still,
> /dev/md/myrealhostname:md_root exists after rebuilding initramfs and
> rebooting..
> 
> Changing the ARRAY line to
> ARRAY /dev/md/md_root metadata=1.2 name=myrealhostname:md_root
> UUID=9d455b1e:35a52a2b:59b2bc1a:db22369f and rebuilding initramfs yielded the
> expected behavior, having /dev/md/md_root.
> 
> Thanks for pointing me so effienctly to the correct solution.
> 
> > So yes, it looks like expected, we are highlighting that it is not our MD
> > array.  
> 
> But it IS "our" MD array. Or, at least it is supposed to be.
> 
> Greetings
> Marc
> 


Got you. Well, looks like this array name "ARRAY
/dev/md/myrealhostname:md_root" forced bad naming. Generally, I recommend
#mdadm --examine --scan for conf generation. You can try and see if the output
is different comparing to --detail --scan.

Probably, we should consider fixing that for --detail --scan.

Thanks,
Mariusz
