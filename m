Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 750CC84D39
	for <linux-raid@vger.kernel.org>; Tue,  2 Jul 2024 08:47:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719910043; cv=none; b=tlJyqlZcrEBb7CTVQjx95tQhQYnZIq2YqW/RbLFEls+0coAZcRznzYUn6Z5L3uusof50xxp9tLSsbPfcz3seH3MJ204Nk6PozhKMUSzAevxQAOK9sch0J1FmsLOHZiLUATfmQN5SlVXuyLyrTYSXZR30zoqrcrHAo2wPKohU15Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719910043; c=relaxed/simple;
	bh=HnnPiIh2IUFp3AP/DMD7WmL/aWeBaGtDcT4e+zENQNE=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KqbDISlmyp0CyviW1ctI6dbkg/m4/OI8MaT/1e0ad7HTzsS5byp8bpvfg1oCRno1Lqjvjq1hZ9Wc70RAglsVGQi+/j92QyNe1Xe6dKegqok6gSYETU6cHj4X7ccDpcl8ADEG1PPF0gu2ipaljCap9y8r3SCtx9REP5fmyv+bh20=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=M8RQ6bLI; arc=none smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="M8RQ6bLI"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1719910043; x=1751446043;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=HnnPiIh2IUFp3AP/DMD7WmL/aWeBaGtDcT4e+zENQNE=;
  b=M8RQ6bLIzQNnpXtjSCimJSeocDhdz+D3OHw4oFxsoYgrswvMe/+OUr9i
   97lHhrh8CHMD5BmSKqUmlzqSMD47yrC6gMbENhMqFfrBHCwwSdWhGFTh/
   oX6xcZipxclqsWuJTDkBzQTYJqNnpcQmNhnTctlywRqquaEeoYnuArh/6
   5Ozxf7R4zi0EpksJamhTqKNqneub5fGX21MhLDsC39jCsB9eGwCIBLGA2
   w1T4J5Q9B6/PUPY+FqyRaYI77IERFSlm/t5XO+eI45sVmENsVRSC6VdH0
   ZsJKagk8Wi16O5+JXfoS03ct302d1eS96I34Lqo0XVbDFqmPbupwf7c8D
   A==;
X-CSE-ConnectionGUID: Zq9hcHZ8TPiYlGreXzTKRg==
X-CSE-MsgGUID: SidDhmWYQhWNBgyMQUnUzA==
X-IronPort-AV: E=McAfee;i="6700,10204,11120"; a="20833478"
X-IronPort-AV: E=Sophos;i="6.09,178,1716274800"; 
   d="scan'208";a="20833478"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jul 2024 01:47:22 -0700
X-CSE-ConnectionGUID: cy/IwnPdQOqtIi1h8bh8zQ==
X-CSE-MsgGUID: hAn/HaOwQ32ETvG9GANeMA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,178,1716274800"; 
   d="scan'208";a="46560493"
Received: from mtkaczyk-mobl.ger.corp.intel.com (HELO localhost) ([10.246.1.223])
  by orviesa008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jul 2024 01:47:21 -0700
Date: Tue, 2 Jul 2024 10:47:15 +0200
From: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To: Adam Niescierowicz <adam.niescierowicz@justnet.pl>
Cc: linux-raid@vger.kernel.org
Subject: Re: RAID6 12 device assemble force failure
Message-ID: <20240702104715.00007a35@linux.intel.com>
In-Reply-To: <25cb6321-9e61-405f-abd7-2187236af62a@justnet.pl>
References: <56a413f1-6c94-4daf-87bc-dc85b9b87c7a@justnet.pl>
	<20240701105153.000066f3@linux.intel.com>
	<25cb6321-9e61-405f-abd7-2187236af62a@justnet.pl>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 1 Jul 2024 11:33:16 +0200
Adam Niescierowicz <adam.niescierowicz@justnet.pl> wrote:

> Is there a way to force state=active in the metadata?
>  From what I saw each drive have exactly the same Events: 48640 and 
> Update Time so data on the drive should be the same.

The most important: I advice you to clone disks to have a safe space for
practicing. Whatever you will do is risky now, we don't want to make
situation worse. My suggestions might be destructible and I don't want to take
responsibility of making it worse.

We have --dump and --restore functionality, I've never used it
(I mainly IMSM focused) so I can just point you that it is there and it is an
option to clone metadata.

native metadata keep both spares and data in the same array, and we can see
that spare states for those 3 devices are consistently reported on every drive.

It means that at some point metadata with missing disk states updated to
spares  has been written to the all array members (including spares) but it does
not mean that the data is consistent. You are recovering from error scenario and
whatever is there, you need to be read for the worst case.

The brute-force method would be to recreate an array with same startup
parameters and --assume-clean flag but this is risky. Probably your array
was initially created few years (and mdadm versions) so there could be small
differences in the array parameters mdadm sets now. Anyway, I see it as the
simplest option.

We can try to start array manually by setting sysfs values, however it will
require well familiarize with mdadm code so would be time consuming.

>>> What can I do to start this array?  
>>   You may try to add them manually. I know that there is
>> --re-add functionality but I've never used it. Maybe something like that
>> would
>> work:
>> #mdadm --remove /dev/md126 <failed drive>
>> #mdadm --re-add /dev/md126 <failed_drive>  
>I tried this but didn't help.

Please provide a logs then (possibly with -vvvvv) maybe I or someone else would
help.

Thanks,
Mariusz
