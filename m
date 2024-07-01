Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 296D085C74
	for <linux-raid@vger.kernel.org>; Mon,  1 Jul 2024 08:58:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719824298; cv=none; b=ChTRXMZ8gf3c/edYb2YQbVScUlN+sjaN9ksqSgpW70GCRMCEdVp+2quLbxBDpyz0RFBLLS4v9BUKe+nbbzCSZ834o0BLx+8nxfMoPHVbDY3HMcfa/vQK0x4jogSsVS+2jGEUouDc2FbExrnmCdy89JL4HbTr30bOGAAcV7gyJsk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719824298; c=relaxed/simple;
	bh=KQvNwqMhM8wS21stkecgFIR2iOvvYjnidfB6xQK4xAg=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NXR3swNrlw8de1Xfua/B54oMmeX/1SrZunf2RlwdD/CUO4gl5pqP3xcNl1wGscU/779DyW34UPQnVs+wNR/RQ+lSXNew//MFOQL+gMEHR/odOrM5Cm5IisGM0GDhfsLkg8l189s+nAY2hJ7SanXH6EJydmlP0VoV9rRG2fcPmMM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=kJGjlzKp; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="kJGjlzKp"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1719824297; x=1751360297;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=KQvNwqMhM8wS21stkecgFIR2iOvvYjnidfB6xQK4xAg=;
  b=kJGjlzKpvrgGgoZtFO5DiKpV/eh0hk2WDcn6lupfVDHeJDLhJ1IWxifp
   f2DNAA4b8I5Ej4H8mghXvtldR04km9aTk02t/bIOtoW2TxWjTLVkl3H40
   KCtAHMRL/mJqsUiWfYKO+24uVGCa2zErWDASJBHOux/jwG5lNwlJwu2Ig
   4jmG588ew1hVIuf59C1xldadSt8AH9xS5gsM2GQxNHqOAXVIPw0+t6dam
   uWg4dqhhD9lHbcvXsoPUIQ7PLm02XiGxGKXyZAef54kWcw191Of4/Fxqe
   Pr/uiVb+7CWVrRYlTtw4vs5IpuDCHknb4Iy+Byd05oCvDSiuMVLola4jh
   g==;
X-CSE-ConnectionGUID: UgybgTc+TF+hCqedUGXLXw==
X-CSE-MsgGUID: Ev79yacFRV68i2YSRdH9Yg==
X-IronPort-AV: E=McAfee;i="6700,10204,11119"; a="19835359"
X-IronPort-AV: E=Sophos;i="6.09,175,1716274800"; 
   d="scan'208";a="19835359"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jul 2024 01:58:16 -0700
X-CSE-ConnectionGUID: 9uJKs+SBR9qR2AjX1TQZzA==
X-CSE-MsgGUID: Hq8XB9d6RM6vqTWKV+TEoA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,175,1716274800"; 
   d="scan'208";a="50047891"
Received: from mtkaczyk-mobl.ger.corp.intel.com (HELO localhost) ([10.237.142.70])
  by fmviesa004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jul 2024 01:58:16 -0700
Date: Mon, 1 Jul 2024 10:58:11 +0200
From: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To: MC <darkhat@gmail.com>
Cc: linux-raid@vger.kernel.org
Subject: Re: NAS RAID configuration overwritten by ransomware
Message-ID: <20240701105811.000073e0@linux.intel.com>
In-Reply-To: <CAF1V9aCeNLS5yiMwhkwtZPbgbpybS0eBxNKtB3p82Lo=WnLkOA@mail.gmail.com>
References: <CAF1V9aCeNLS5yiMwhkwtZPbgbpybS0eBxNKtB3p82Lo=WnLkOA@mail.gmail.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Sun, 30 Jun 2024 11:16:34 -0700
MC <darkhat@gmail.com> wrote:

> Hi everyone,
> 
> Is there a way to force mdadm to assemble a certain set of drives into
> a particular RAID format? A friend of mine had a NAS that was hit with
> ransomware. His setup was a RAID-5, 64kb chunk size, 4x4TB, XFS
> filesystem setup, while during the attack, they overwrote the config
> to be RAID-0/512kb chunk size (it is a Buffalo NAS, running Linux with
> libmd). He pulled the plug while it was in the process of formatting
> the XFS filesytem. Much of the data I have been able to recover, but
> now it would be a lot nicer for me if I could access a raw /dev device
> assembled as RAID-5/64kb chunk (rather than the current RAID-0
> mdadm/mdstat currently shows), instead of using a tool like UFS
> Explorer to assemble it properly for me. Obviously, minimal
> (preferably none) writes to the disk if possible. I was afraid to
> start throwing mdadm assemble and create commands around. Could
> someone please advise on best path forward?
> 
> Thanks in advance,
> Mike
> 

Hello Mike,
there is a --build option for mdadm (run array with no metadata). Perhaps this
is option you are looking for:

#mdadm -Ss (stop all existing)
# mdadm --build /dev/md126 <here your raid5 params comes> --assume-clean

use --assume-clean to avoid reconstruction. so far I know, --readonly is not
supported. You can set /sys/block/md126/ro = 1 manually to prevent writes.

Thanks,
Mariusz
