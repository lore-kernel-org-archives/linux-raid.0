Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 530EA558A0
	for <linux-raid@vger.kernel.org>; Mon, 10 Jun 2024 08:57:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718009854; cv=none; b=cRXEgoSQwuKV7TSrf7qs1vc/GT3uWrhQGsg4Wlv9w3cusigpzzKzQ9ti47zsHH6cv5Eiz0EzUbpsqP3pmQq432uRB+NM7vgTihX/Yj+i+Z/4LLnFS2FcABJxE98FRA9DXNJd0OyJPcI68LIo8g5Qsllk+HKAn0bxW24Hsf9vPwM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718009854; c=relaxed/simple;
	bh=unrvp4h6pt5MAd7SPzcSRDJimcp2sKYG4YrKsrLbyRs=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=cJz/1M/FhduTKW25dUpMSVVBEIa4wP7U8DBL+WvCRMNIgYFDDc0qxQHIR6vUQ9oTwTKmMovqIulM2iJJ+9bxcuGXXIItuSzmnyZ/U9iPC2vW3zqzotr5BGYUkkzth+79YRDz86l1xvHK9SJYw60t9ggUQ0D8Bd4Qs1L7hgegPvg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=fug+vGyJ; arc=none smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="fug+vGyJ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1718009852; x=1749545852;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=unrvp4h6pt5MAd7SPzcSRDJimcp2sKYG4YrKsrLbyRs=;
  b=fug+vGyJxZG0S4iPMXQNzngwjSYl25eV69Pga1drHR+5D79RrqIRtzMm
   Hhl70CEWpXtiWTbHZwpkyubNK0yDsHrjgFI7D/FWhZcQe9cLJykyOnuid
   ApcjkJa8UjLreOf7UlKlBafR49c38a2zwiqIU1u5KjWaMR/N684xW3/1z
   Bp6NZRPFIl9A4lyHJRoyq8M1CsbLDWlp27m6DMK6MUsW+eaxbj0XSQgCY
   p7IB4yNlizJW5aEiB3uHuF+h7SwDAr6hY7vVayn0kVC5zHf8Ie9BWsx4N
   sb4FyoJVPIM7GgdwB92W4SB3GBGTA+nJ0P5kS2w4SicC9veDOdhFUuDq1
   A==;
X-CSE-ConnectionGUID: gf9mradfTX+qGyl1mfrwYw==
X-CSE-MsgGUID: jn0HrftNTTSBwdGsC9ABkQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11098"; a="11994635"
X-IronPort-AV: E=Sophos;i="6.08,227,1712646000"; 
   d="scan'208";a="11994635"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jun 2024 01:57:31 -0700
X-CSE-ConnectionGUID: jRmF5taQTaafFOINZawpTg==
X-CSE-MsgGUID: MPVniSnuSiOU3gE6x0AWEA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,227,1712646000"; 
   d="scan'208";a="44128398"
Received: from mtkaczyk-mobl.ger.corp.intel.com (HELO localhost) ([10.237.142.70])
  by orviesa004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jun 2024 01:57:30 -0700
Date: Mon, 10 Jun 2024 10:57:25 +0200
From: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To: Logan Gunthorpe <logang@deltatee.com>
Cc: Xiao Ni <xni@redhat.com>, linux-raid@vger.kernel.org
Subject: Re: [RFC PATCH] mdadm: add --fast-initialize
Message-ID: <20240610105725.00002687@linux.intel.com>
In-Reply-To: <70ae9c73-ae48-4cc9-9118-e4e74102f090@deltatee.com>
References: <20240528143305.18374-1-mariusz.tkaczyk@linux.intel.com>
	<CALTww28s44pewrDH-w+djGVnUXi97bZD1upESixCZmUDPNKHKQ@mail.gmail.com>
	<70ae9c73-ae48-4cc9-9118-e4e74102f090@deltatee.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 4 Jun 2024 10:19:59 -0600
Logan Gunthorpe <logang@deltatee.com> wrote:

> On 2024-06-04 06:46, Xiao Ni wrote:
> > Hi Mariusz
> > 
> > The discard can't promise to write zero to nvme disks, right? If so,
> > we can't use it for resync, because it can't make sure the raid is in
> > sync state.  
> 
> Yes, discard requests are a best effort and the drive is free to ignore
> some or all of the request. See [1] for more information from Martin
> Peterson.
> 
> I think if we have a device that has a fast zero operation that we know
> guarantees zeroing then the kernel's write-zeros operation should be
> changed to use it. We shouldn't make fast-but-dangerous options in mdadm.
> 
> Thanks,
> 
> Logan
> 
> 
> [1] https://lore.kernel.org/all/yq1fsgwbijv.fsf@ca-mkp.ca.oracle.com/T/#u

Thanks for giving the valuable feedback. I'm not directly involved in technical
details about this implementation and in fact I didn't read the previous
discussion yet. You pointed great problem and I will make sure that it is
addressed.

I asked about mdadm API, it is despite the technical implementation.
I would like to propose one command to integrate existing way (--write-zeroes)
and potentially new way (if any other fast-initialization capability would be
safe to add).

Do you see it as right approach or we should keep them separately?

Mariusz
