Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E43B2C879
	for <linux-raid@vger.kernel.org>; Wed,  3 Jul 2024 07:43:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719992582; cv=none; b=QtX93WzHoczZgzmZMl1fcQkPta8NV+nCwxLULbCIglDn+s/qgMn7ehXXxnTf/HvmfqwnPI/YJGs1UEANZGUehNYN7fGdjVizFob5mkKEAWT1Pk40XheCFmQoS+zsfRMosRkkNaCjfmhD4ZvZ5Gjn6rplowOnhQVmmmrIlP54gTU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719992582; c=relaxed/simple;
	bh=jz/CyLvRJpcL3d412wTpohpcY2f/cP0orV62evAod0w=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WQ6jJTTAV4ZBYf9FQLOwNWogJZKcc/oQJxt9N0EhWUBVFJZzEYX69MebXK5cfCV7TROqhvAM7dh6XSzoXbMPVsXcb+Gg89frGYgoSlHKv5s+2ZZRGUJg6XsFi5RjORuMFK5/2YpvrCU7c5jh9ea2rqIHsLxAixezi984nqIe0s4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=IFeLsR+B; arc=none smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="IFeLsR+B"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1719992581; x=1751528581;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=jz/CyLvRJpcL3d412wTpohpcY2f/cP0orV62evAod0w=;
  b=IFeLsR+BP/bEndp4KygUnphRsYhZsMDIBUzQabMNA/e/4OX0MFz+NX+B
   /2oY2Spyf46s3X9P0/yxfe12Gy/CIF9rID4+KMX7fgEA13hgsmK63V1Pc
   4rAxe7r5jNzlidAm+r6vVZP/2qLrhp4sdqnAvKcDqCcVeyF6KPAXgqGkz
   RHuuhuIaVtW1RpvWycZRyMfX7iWd81p525C/x46k6fQzTLLsGDCG6L1XH
   l1uWTFX+jpulbPpKbxsE023J2GyNlxJKlfq1lsJyhTwRGDdtTH+uKL+GS
   GhKOZHGlHbN1jCXs9xD28Hd4Y3zGhIxRhYCgmRDjmeIRQxsX9BS2qAq9o
   g==;
X-CSE-ConnectionGUID: yqr9mX/gQDiAPgmM99L9Sg==
X-CSE-MsgGUID: jjQdqZTKQj2aoVuDRULPJA==
X-IronPort-AV: E=McAfee;i="6700,10204,11121"; a="17030564"
X-IronPort-AV: E=Sophos;i="6.09,181,1716274800"; 
   d="scan'208";a="17030564"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jul 2024 00:43:00 -0700
X-CSE-ConnectionGUID: iF4pNziGShekDsjBCBSbgw==
X-CSE-MsgGUID: 0tq+7Gt6Rz2uzYtSCgrqjA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,181,1716274800"; 
   d="scan'208";a="46915311"
Received: from mtkaczyk-mobl.ger.corp.intel.com (HELO localhost) ([10.245.98.108])
  by orviesa008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jul 2024 00:42:59 -0700
Date: Wed, 3 Jul 2024 09:42:53 +0200
From: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To: Adam Niescierowicz <adam.niescierowicz@justnet.pl>
Cc: linux-raid@vger.kernel.org
Subject: Re: RAID6 12 device assemble force failure
Message-ID: <20240703094253.00007a94@linux.intel.com>
In-Reply-To: <347003bc-28f1-41e9-b5c4-a2cba5a4475c@justnet.pl>
References: <56a413f1-6c94-4daf-87bc-dc85b9b87c7a@justnet.pl>
	<20240701105153.000066f3@linux.intel.com>
	<25cb6321-9e61-405f-abd7-2187236af62a@justnet.pl>
	<20240702104715.00007a35@linux.intel.com>
	<347003bc-28f1-41e9-b5c4-a2cba5a4475c@justnet.pl>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 2 Jul 2024 19:47:52 +0200
Adam Niescierowicz <adam.niescierowicz@justnet.pl> wrote:

> >>>> What can I do to start this array?  
> >>>    You may try to add them manually. I know that there is
> >>> --re-add functionality but I've never used it. Maybe something like that
> >>> would
> >>> work:
> >>> #mdadm --remove /dev/md126 <failed drive>
> >>> #mdadm --re-add /dev/md126 <failed_drive>  
> >> I tried this but didn't help.  
> > Please provide a logs then (possibly with -vvvvv) maybe I or someone else
> > would help.  
> 
> Logs
> ---
> 
> # mdadm --run -vvvvv /dev/md126
> mdadm: failed to start array /dev/md/card1pport2chassis1: Input/output error
> 
> # mdadm --stop /dev/md126
> mdadm: stopped /dev/md126
> 
> # mdadm --assemble --force -vvvvv /dev/md126 /dev/sdq1 /dev/sdv1 
> /dev/sdr1 /dev/sdu1 /dev/sdz1 /dev/sdx1 /dev/sdk1 /dev/sds1 /dev/sdm1 
> /dev/sdn1 /dev/sdw1 /dev/sdt1
> mdadm: looking for devices for /dev/md126
> mdadm: /dev/sdq1 is identified as a member of /dev/md126, slot -1.
> mdadm: /dev/sdv1 is identified as a member of /dev/md126, slot 1.
> mdadm: /dev/sdr1 is identified as a member of /dev/md126, slot 6.
> mdadm: /dev/sdu1 is identified as a member of /dev/md126, slot -1.
> mdadm: /dev/sdz1 is identified as a member of /dev/md126, slot 11.
> mdadm: /dev/sdx1 is identified as a member of /dev/md126, slot 9.
> mdadm: /dev/sdk1 is identified as a member of /dev/md126, slot -1.
> mdadm: /dev/sds1 is identified as a member of /dev/md126, slot 7.
> mdadm: /dev/sdm1 is identified as a member of /dev/md126, slot 3.
> mdadm: /dev/sdn1 is identified as a member of /dev/md126, slot 2.
> mdadm: /dev/sdw1 is identified as a member of /dev/md126, slot 4.
> mdadm: /dev/sdt1 is identified as a member of /dev/md126, slot 0.
> mdadm: added /dev/sdv1 to /dev/md126 as 1
> mdadm: added /dev/sdn1 to /dev/md126 as 2
> mdadm: added /dev/sdm1 to /dev/md126 as 3
> mdadm: added /dev/sdw1 to /dev/md126 as 4
> mdadm: no uptodate device for slot 5 of /dev/md126
> mdadm: added /dev/sdr1 to /dev/md126 as 6
> mdadm: added /dev/sds1 to /dev/md126 as 7
> mdadm: no uptodate device for slot 8 of /dev/md126
> mdadm: added /dev/sdx1 to /dev/md126 as 9
> mdadm: no uptodate device for slot 10 of /dev/md126
> mdadm: added /dev/sdz1 to /dev/md126 as 11
> mdadm: added /dev/sdq1 to /dev/md126 as -1
> mdadm: added /dev/sdu1 to /dev/md126 as -1
> mdadm: added /dev/sdk1 to /dev/md126 as -1
> mdadm: added /dev/sdt1 to /dev/md126 as 0
> mdadm: /dev/md126 assembled from 9 drives and 3 spares - not enough to 
> start the array.
> ---

Could you please share the logs with from --re-add attempt? In a meantime I
will try to simulate this scenario.
> 
> Can somebody explain me behavior of the array? (theory)
> 
> This is RAID-6 so after two disk are disconnected it still works fine. 
> Next when third disk disconnect the array should stop as faulty, yes?
> If array stop as faulty the data on array and third disconnected disk 
> should be the same, yes?

If you will recover only one drive (and start double degraded array), it may
lead to RWH (raid write hole).

If there were writes during disks failure, we don't know which in flight
requests completed. The XOR based calculations may leads us to improper results
for some sectors (we need to read all disks and XOR the data to get the data
for missing 2 drives).

But.. if you will add again all disks, in worst case we will read outdated data
and your filesystem should be able to recover from it.

So yes, it should be fine if you will start array with all drives.

Mariusz
