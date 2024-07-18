Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA2D72837D
	for <linux-raid@vger.kernel.org>; Thu, 18 Jul 2024 16:41:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721320917; cv=none; b=gQLud/1nq2y8P4kVrW+T4MiysMfsOneSSLZfTUFKB5jhbbJk1gZqhVwSU0qnjWb6cwOtSPiLcnlUy+UWOpAYWI8j49nkZzS+HFcd12oAPifqRUVUceI+GiLSAj9gZZrD80ibQFuuCTxIBxO3MbGbmuRiBPJ/ykiE2g+5O1E4rtA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721320917; c=relaxed/simple;
	bh=R0KQ6Fg/2ZVkxxC8ZnP2y4htycjtqS5Afc/svaaLcUA=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kqbVQ7tNTgjO7XLOx1SYzS1YPANzu4H+g6wyBfnHFNanPxro8MN61RgRKf8HYX9gmiUElsE0fXO4a+ATe/NoBBFnirn8TINdFHwHPvPrdjEip8TFwSZiuJLPve3LiekUqr7yZe4G00cKbQYmtoGC2J7tbYtjMWKI143yCExUWFQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=S1vh08fd; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="S1vh08fd"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1721320915; x=1752856915;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=R0KQ6Fg/2ZVkxxC8ZnP2y4htycjtqS5Afc/svaaLcUA=;
  b=S1vh08fd5TKv+ns/Cux+qspPbGf114IHn7Ufpfx1Fljk5LwdIJLafvvv
   HhTQ9ppxiFI/vkQjBSMX/aAl/upNe3+3GaQ+8UbCkUf0Fn0uCdpwHcbj7
   vsmX+C6AsVMM3uVeBOU89aaRj03d9IUSQTZNkCkezD6YA0x85XyZEfsCa
   kAXDH4iodEo2x4sDxhQ+efD01Slz4waQeka2ZaP4+S/C/8TRDeOt6Qcq8
   Jya08+LeX9pWdEm0nCf4ye8pjoltXmu4bR3S/Gpph66FyZvGF32zwBp89
   0wzq/4RZk8o2hORl4wN+7G1SBvlFNHmShutD9PQgtdI8IGU9saZkm0KH5
   A==;
X-CSE-ConnectionGUID: GioD1DIFSK+1FjmrO5Wleg==
X-CSE-MsgGUID: qjG/RUeCSmeNqez8glrTVg==
X-IronPort-AV: E=McAfee;i="6700,10204,11137"; a="29510687"
X-IronPort-AV: E=Sophos;i="6.09,218,1716274800"; 
   d="scan'208";a="29510687"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jul 2024 09:41:54 -0700
X-CSE-ConnectionGUID: NNKsUI/3Ql2qZfkBlq5XYg==
X-CSE-MsgGUID: LBS/5oJYRDeNXNEzppvLug==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,218,1716274800"; 
   d="scan'208";a="50858948"
Received: from ezamani-mobl.amr.corp.intel.com (HELO peluse-desk5) ([10.212.80.93])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jul 2024 09:41:54 -0700
Date: Thu, 18 Jul 2024 09:41:52 -0700
From: Paul E Luse <paul.e.luse@linux.intel.com>
To: Mateusz Kusiak <mateusz.kusiak@linux.intel.com>
Cc: linux-raid@vger.kernel.org
Subject: Re: IMSM: Drive removed during I/O is set to faulty but not removed
 from volume
Message-ID: <20240718094152.62dfa92f@peluse-desk5>
In-Reply-To: <f34452df-810b-48b2-a9b4-7f925699a9e7@linux.intel.com>
References: <f34452df-810b-48b2-a9b4-7f925699a9e7@linux.intel.com>
X-Mailer: Claws Mail 4.2.0 (GTK 3.24.41; aarch64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 18 Jul 2024 16:57:03 +0200
Mateusz Kusiak <mateusz.kusiak@linux.intel.com> wrote:

> Hello,
> recently we discovered an issue regarding drive removal during I/O.
> 
> Description:
> Drive removed during I/O from IMSM R1D2 array is being set to faulty
> but is not removed from a volume. I/O on the array hangs.
> 
> The scenario is as follows:
> 1. Create R1D2 IMSM array.
> 2. Create single partition, format it as ext4 and mount is somewhere.
> 3. Start multiple checksum tests processes (more on that below) and
> wait a while. 4. Unplug one RAID member.
> 

Thanks Mateusz, can you confirm if this is only with imsm metadata? In
other words with native metadata is this an issue or not?

-Paul

> About "Checksum test":
> Checksum test creates ~3GB file and calculates it's checksum twice.
> It basically does the following: # dd if=/proc/kcore bs=1024
> count=3052871 status=none | tee <filename> | md5sum ...and then
> recalculates checksum to verify if it matches. In this scenario we
> use it to simulate I/O, by running multiple tests.
> 
> Expected result:
> Raid member is removed from the volume and the container, array
> continues operation on one drive.
> 
> Actual result:
> Raid member is set to faulty on volume and does not disappear (it's
> not removed), but it is removed from a container. I\O on mounted
> volume hangs.
> 
> Additional notes:
> The issue reproduces on kernel-next. We bisected that potential cause
> of the issue might be patch "md: use new apis to suspend array for
> adding/removing rdev from state_store()"
> (cfa078c8b80d0daf8f2fd4a2ab8e26fa8c33bca1) as it's the first one we
> observe the issue on our reproduction setup.
> 
> Having said that, we also observed the issue for example on SLES15SP6
> with kernel 6.4.0-150600.10-default, which might indicate that the
> problem was here, but became apparent for some reason (race-condition
> or something else).
> 
> I will work on simplifying the scenario and try to provide script for
> reproduction.
> 
> Thank,
> Mateusz
> 

