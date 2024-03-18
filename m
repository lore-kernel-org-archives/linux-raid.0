Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D84C36138
	for <linux-raid@vger.kernel.org>; Mon, 18 Mar 2024 11:18:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710760693; cv=none; b=oh1U+QnBGOesgJd3f5rPWcuzz67LcCELjJHnxRgoEYvb0qLIhkpsNx2hWT4/jX5/3o53XiNfz/YnBYafbTaN+FVj+nA1GZ93eDSzg+cBJjvfR6zxuU96g3AMyuKQMWEIlJYs4SyNuKWJRYS9Qs3b2o8XxgxgQQbQjnizZbl0YEQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710760693; c=relaxed/simple;
	bh=h9xQsu/9mrl3Fqvp3YF94Ai/VNVPTGDjMgWlJeSWSQs=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tHr2ycMIethEYPLhF2OgbWXoHvD4RId1gM/eT4mc/3+/NEGKLiYXcI9duuqoNhkzB+qfllWujtNQJtswBt1S/k96NEobU9ADersVa8eXcuQfFSJw4ez0mCmOYh269bErElPUzo32qGmUEe60eP6iiLDlHnGR27Ag9ltfDXyq9JM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=UhEfqlKt; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="UhEfqlKt"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1710760693; x=1742296693;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=h9xQsu/9mrl3Fqvp3YF94Ai/VNVPTGDjMgWlJeSWSQs=;
  b=UhEfqlKteZQHNhJHsUIJYo+CBIlWfpIHBsvkiHq687vQrwQoTrX2ZcMT
   qZFHfniRBrMkMBW6E3y2D5N6Vt1FnRNxQigw8IVKOJB3aiqMVUFoUyodE
   +k5j1xygcGCdZ/7pr5GVWV7nnFZlwKnfkvOwICFU3o0eI9smSjJ5tFC5I
   sdZpRKi21J9bGzApV/PLLsYPE1oeWLYkM7HDYRQadXmXF4fIG51uA6PwW
   r9iL/3TfO2S22Ea8IiQTC0b5YLwud2XOse2yGCmWnaDg1kLi9rarmtqX3
   KXlqsiMa3DdK4n2NCXwKH/lGW/4UHmGFCdyqoKpnQQ/TzK6eDWu6P7AGG
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,11016"; a="23025892"
X-IronPort-AV: E=Sophos;i="6.07,134,1708416000"; 
   d="scan'208";a="23025892"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Mar 2024 04:18:12 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,134,1708416000"; 
   d="scan'208";a="18145618"
Received: from mtkaczyk-mobl.ger.corp.intel.com (HELO localhost) ([10.237.142.117])
  by ORVIESA003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Mar 2024 04:18:11 -0700
Date: Mon, 18 Mar 2024 12:18:06 +0100
From: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To: Shaya Potter <spotter@gmail.com>
Cc: linux-raid@vger.kernel.org
Subject: Re: Issue with moving LSI/Dell Raid to MD
Message-ID: <20240318121806.00001147@linux.intel.com>
In-Reply-To: <CALHdMH30LuxR4tz9jP2ykDaDJtZ3P7L3LrZ+9e4Fq=Q6NwSM=Q@mail.gmail.com>
References: <CALHdMH30LuxR4tz9jP2ykDaDJtZ3P7L3LrZ+9e4Fq=Q6NwSM=Q@mail.gmail.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Sat, 16 Mar 2024 20:26:15 +0200
Shaya Potter <spotter@gmail.com> wrote:

> note: not subscribed, so please cc me on responses.
> 
> I recently had a Dell R710 die where I was using the Perc6 to provide
> storage to the box.  As the box wasn't usable, I decided to image the
> individual disks to a newer machine with significantly more storage.
> 
> I sort of messed up the progress, but that might have discovered a bug in
> mdadm.
> 
> Background, the Dell R710 supported 6 drives, which I had as a 1TB
> SATA SSD and 5x8TB SATA disks in a RAID5 array.
> 
> In the process of imaging it, I I was setting up devices on /dev/loop
> to be prepared to assemble the raid, but I think I accidentally
> assembled the raid while imaging the last disk (which in effect caused
> the last disk to get out of sync with the other disks.  This was
> initially ok, until the VM I was doing it on, crashed with a KVM/QEMU
> failure (unsure what occurred).
> 
> I was hoping, it was going to be easy to bring up the raid array
> again, but now mdadm was segfault on a null pointer exception whenever
> I tried to assemble the array (was just trying the RAID5 portion).
> 
> I was thinking perhaps my VM got corrupted, but I couldn't figure that
> out, so I decided to try and reimage the disks (more carefully this
> time), but yes, the 5th disk was marked as in quick init, while the
> others were more consistent.
> 
> Howvever, same segfault was occuring, so I built mdadm from source
> (with -g and no -O, as an aside, this would be a good Makefile target
> to have, to make issues easier to debug)
> 
> After understanding the issue, the segfault seems to be due to
> Assemble.c wanting to call update_super() with a ddf super.  Except
> super-ddf.c doesn't provide that.
> 
> i.e. in Assemble.c it was crashing at
> 
> if (st->ss->update_super(st, &devices[j].i, UOPT_SPEC_ASSEMBLE, NULL,
> c->verbose, 0, NULL)) {...}
> 
> which now explained the seg fault on null pointer exception.  I was
> able to progress past the segfault (perhaps badly, but it "seems" to
> work for me), by putting in a null check before the update_super()
> call, i.e.
> 
> if (st->ss->update_super && st->ss->update_super(....)) { ... }
> 
> thoughts about my "fix" (perhaps super-ddf.c needs an empty
> update_super function?) , if this is a bug? (perhaps its unexpected
> for me to have gotten into this state in the first place?)
> 

Hello Shaya,
DDF is not actively developed. I'm considering dropping
it.
If you are interested in bringing it too life then you are
more than welcome to send patches!

If DDF doesn't implement update_super() then fix proposed by you seems to be
valid. Please send proper patch for that then we will review it.

Thanks,
Mariusz
