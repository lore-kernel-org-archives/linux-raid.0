Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BD461EB39
	for <linux-raid@vger.kernel.org>; Wed, 17 Jan 2024 16:06:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705507608; cv=none; b=SSLyMkREMwnnNraAEGebT+9tuPeJAw/biHjEyNPEZufUYHYSzQyoDKQTiiRVFrcMTnub+UJL+RiylgEOKs0FiwRKIiOeYz5kWSj4noPzyjYbNISqURiSh1a9aPYRExgdoLBM3L93L0LcX0u1CVk3BmjQZ1cw5u2iQV8ae6TJy/g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705507608; c=relaxed/simple;
	bh=4SO5gJg61qQ+xDNYMh9UjBXJcwyOObG+r/dhNtm//xs=;
	h=DKIM-Signature:X-IronPort-AV:X-IronPort-AV:Received:X-ExtLoop1:
	 X-IronPort-AV:Received:Date:From:To:Cc:Subject:Message-ID:
	 In-Reply-To:References:X-Mailer:MIME-Version:Content-Type:
	 Content-Transfer-Encoding; b=HcS3M0KN9lHAL31wPIksacPOCt0MFXv2PAJP3By1kNG7oXJc8MUzwd6VmDbnpnkebDcyk6eKBmaG2FGMq7gujrTAm3vcLnNxfNZmQLgHVNcUSas+69bShgK8X8BTvdI2utMwPC4odcschJjqSzmT0rJxYQSZAvGK8dGf7TFBOiY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=R4jY++AZ; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="R4jY++AZ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1705507608; x=1737043608;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=4SO5gJg61qQ+xDNYMh9UjBXJcwyOObG+r/dhNtm//xs=;
  b=R4jY++AZrbypHnPWv1Ue2iPKinKGaylq0js72uB0eSP8o7KtjspU0djB
   qMashLLO5H/9uz7sA7uS54Jd8FCF6o78Yc4p+EvYT5++kpLdCrd7mAEon
   qu2mDhEwEUyLvo4fJKH89+POdUtZS/JdrcFMtkdOR1DsBBEaizhjWKj7+
   pOBJIsFg2dApk8TL/hDw5EwhvLhqvYURy8Qxu5z19CZ6tSUfvH+ccho60
   9vyk8cmea2ivDzcTtC7H5ZXAn5BIJBsVtlN3txvXx+A+A/5MdbYGu+VUp
   8/FIK69WSqal2WXx+O6y1neQ1m55nmD4xL/rGcQ9zc8MbW923nAZVPThK
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10956"; a="18795025"
X-IronPort-AV: E=Sophos;i="6.05,200,1701158400"; 
   d="scan'208";a="18795025"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jan 2024 08:06:47 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.05,200,1701158400"; 
   d="scan'208";a="52802"
Received: from jbelkin-mobl.amr.corp.intel.com (HELO peluse-desk5) ([10.212.92.214])
  by fmviesa003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jan 2024 08:06:46 -0800
Date: Tue, 16 Jan 2024 01:31:36 -0700
From: Paul E Luse <paul.e.luse@linux.intel.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Yiming Xu <teddyxym@outlook.com>, song@kernel.org,
 linux-raid@vger.kernel.org, paul.e.luse@intel.com, firnyee@gmail.com
Subject: Re: [RFC] md/raid5: optimize RAID5 performance.
Message-ID: <20240116013136.06d3d173@peluse-desk5>
In-Reply-To: <ZWQ63SpjIE4bc+pi@infradead.org>
References: <SJ2PR11MB75742EC42986F1532F7A0977D8BEA@SJ2PR11MB7574.namprd11.prod.outlook.com>
	<ZWQ63SpjIE4bc+pi@infradead.org>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; aarch64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Sun, 26 Nov 2023 22:44:45 -0800
Christoph Hellwig <hch@infradead.org> wrote:

> Hi Shushu,
> 
> the work certainly l-ooks interesting!
> 
> However:
> 
> > Optimized by using fine-grained locks, customized data structures,
> > and scattered address space. Achieves significant improvements in
> > both throughput and latency.
> 
> this is a lot of work for a single Linux patch, we usually do that
> work pice by pice instead of complete rewrite, and for such
> signigicant changes the commit logs also tend to be a bit extensive.
> 
> I'm also not quite sure what scattered address spaces are - I bet
> reading the paper (I plan to get to that) would explain it, but it
> also helps to explain the idea in the commit message.
> 
> That's my high level nitpicking for now, I'll try to read the paper
> and the patch in detail and come back later.
> 
> 

Hi Everyone,

I went ahead and ran a series of performance tests on this patch to
help the community understand the value.Here's a summary of what have
completed and am happy to run some more to keep the patch moving.

I have not yet reviewed the code as I wanted to make sure it provided
good benefit first and it does for sure. I will be reviewing shortly.
Here is a summary of my tests:

* Kioxia CM7 drives
  https://americas.kioxia.com/content/dam/kioxia/shared/business/ssd/enterprise-ssd/asset/productbrief/eSSD-CM7-V-product-brief.pdf
* Dual Socket Xeon 8368 2.4GHz 256G RAM
* Results are the average of just 2 60 second runs per data point, if
  interest continues I can re-run to eliminate any potential anomalies
* I used 8 fio jobs per disk and 2 group_thread_cnt per disk so when
  reading the graph, for example, 8DR5_patch_64j15gtc means an 8 Disk
  RAID5 run against the patch with 64 fio jobs and group-thread_cnt set
  to 16.  'base' in the name is md-next branch as of yesterday.
* Sample fio command: fio --filename=/dev/md0 --direct=1
  --output=/root/remote/8DR5_patch_64j16gtc_1/randrw_131072_1.json
  --rw=randrw --bs=131072 --ioengine=libaio --ramp_time=3 --runtime=60
  --iodepth=1 --numjobs=64 --time_based --group_reporting
  --name=131072_1_randrw --output-format=json --numa_cpu_nodes=0

Results: https://photos.app.goo.gl/Cip1rU3spbD8nvG28 

-Paul









