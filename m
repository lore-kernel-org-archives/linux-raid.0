Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D777B13F45B
	for <linux-raid@vger.kernel.org>; Wed, 15 May 2024 14:27:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715783224; cv=none; b=ZPeRbmBgTLZqEm+7VPL2SgEVZkU1iI4QBm5hsUL7+/tZRiRsVESi9XgFK3kgeb+LHJ64NlDKk7JMKsWfQndFjoHK6TEnClIL2XR5ys8ILi3uqaQhZ+78vnxnQ0zwnGf5K+CWHyycp8F2gyamQR12uXGh+ZSs0OqqN0GMfFsvC0Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715783224; c=relaxed/simple;
	bh=gNAZdo/zefzY8OFafqXPvctlIIH4URGpSL3ogW4OzxA=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YLuqZ8hj9N1k6Xvhv42TTQSn5NzFdVE0JYMuoqNdF4m8uQ4kDzdhwMMTWXjDLFMbLNf8BciUjFU/oqHCQqfSKdvSNBozsTOwLLi1ZXfWSXFcRiKNsjnIMLCoqEPQpq48JfSiWGra4A5IV0izDhMKoG1sQP10JVQWjcb41jcSaIY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=isU+DO7o; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="isU+DO7o"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1715783223; x=1747319223;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=gNAZdo/zefzY8OFafqXPvctlIIH4URGpSL3ogW4OzxA=;
  b=isU+DO7oLI/P/X5u4hRFX4bv9Z1qK218eh79MvPyPbrR6rW/aflG0PLm
   j9rbn6R3mRWWXCZoqoIB/ryW1qRC19OnHaJ9T0YN48dAyU9rrZ7TOr+i+
   irP8Bpk8Fiv06Kw6py6pFS4GQ8qrpMCmFPYI5piFb3o/MKwYyV4DwyaSp
   8gGB62yiL+EXYNmgzVc0KWytYbuyoMqCFA+K3i8duvclvZk6q0AZYqEa4
   ZqyVui5Vklqg74H/hKn3w1QSlFEWX8NQ+u58Bz+rjef+hA77vp+WFujl4
   Guqfxx3XsTROVOY2msw8/XRNdgGCeBIQwCLMZ6tVcdcPq4umWNj+wldwP
   g==;
X-CSE-ConnectionGUID: KbsoxkTbRjWOhU0b19Pykg==
X-CSE-MsgGUID: pnrjDtYxTAKA1DhI5T147g==
X-IronPort-AV: E=McAfee;i="6600,9927,11074"; a="29356919"
X-IronPort-AV: E=Sophos;i="6.08,162,1712646000"; 
   d="scan'208";a="29356919"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 May 2024 07:27:03 -0700
X-CSE-ConnectionGUID: hzWMZ6IGSDeuEhyQdoS+8g==
X-CSE-MsgGUID: MQU7PXofSbqgHwE++8GHzQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,162,1712646000"; 
   d="scan'208";a="31167244"
Received: from bkucman-mobl1.ger.corp.intel.com (HELO localhost) ([10.246.49.83])
  by fmviesa010-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 May 2024 07:27:01 -0700
Date: Wed, 15 May 2024 16:26:56 +0200
From: Blazej Kucman <blazej.kucman@linux.intel.com>
To: Xiao Ni <xni@redhat.com>
Cc: Blazej Kucman <blazej.kucman@intel.com>,
 mariusz.tkaczyk@linux.intel.com, jes@trained-monkey.org,
 linux-raid@vger.kernel.org
Subject: Re: [PATCH v2 2/6] Add reading Opal NVMe encryption information
Message-ID: <20240515162656.00003dee@linux.intel.com>
In-Reply-To: <CALTww2_=gHgut3M=q6SqjenG1oS3FAmG5N+FdQ0fahexZ39PSg@mail.gmail.com>
References: <20240322115120.12325-1-blazej.kucman@intel.com>
	<20240322115120.12325-3-blazej.kucman@intel.com>
	<CALTww2_=gHgut3M=q6SqjenG1oS3FAmG5N+FdQ0fahexZ39PSg@mail.gmail.com>
Organization: intel
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Wed, 15 May 2024 11:20:33 +0800
Xiao Ni <xni@redhat.com> wrote:

>
> Hi all
>=20
> In i686 platform, it reports error:
>=20
> drive_encryption.c: In function =E2=80=98nvme_security_recv_ioctl=E2=80=
=99:
> drive_encryption.c:236:25: error: cast from pointer to integer of
> different size [-Werror=3Dpointer-to-int-cast]
>   236 |         nvme_cmd.addr =3D (__u64)response_buffer;
>       |                         ^
> drive_encryption.c: In function =E2=80=98nvme_identify_ioctl=E2=80=99:
> drive_encryption.c:271:25: error: cast from pointer to integer of
> different size [-Werror=3Dpointer-to-int-cast]
>   271 |         nvme_cmd.addr =3D (__u64)response_buffer;
>       |                         ^
> cc1: all warnings being treated as errors
> make: *** [Makefile:211: drive_encryption.o] Error 1
>=20
> The pointer should be 32bit and it tries to convert to 64 bit.
>=20
> Best Regards
> Xiao
>=20

Hi Xiao,
Thanks for reporting the issue, I'm already working on a fix,
I'm currently in the fix testing phase.

Thanks,
Blazej
