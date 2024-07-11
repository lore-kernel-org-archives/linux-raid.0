Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3F3F51004;
	Thu, 11 Jul 2024 21:14:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720732462; cv=none; b=f3bVLfjctUrD15fLd2j5XHYRe/S6WpRJ++Qs2rLVV0EorKEJFmepMw3QAtLjnFS34Znx0PsyMIykRsqgHLTAkyfqC513QXgaDxPz9BILd+MQYrW2D4gWJRpRWCNdqtUzWRVAdGVb9cFS5CwD6OjRE3YhtcONGhpdR7kWVjcDo3s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720732462; c=relaxed/simple;
	bh=W2hf6xC3VFwwfj1PmmS3ARCLCbbL+jcjKAxdaPfr4jo=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=aImR3xFa8+2sZqZvmK6LJt3U4w/Ln9HVySNw4YuldINnHJ+zMsWYCWmNALw3PcKPPvUlGKIMDj0eqDq78FVJWtlD9xD3iavix0gpQeh0wZaQ5chGs354HCUDYAcqtjXZe6t+3sGVvKaASNxunUGLCbXX7snDbHmHPfvA1B37H/0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=cakBVmqj; arc=none smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="cakBVmqj"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1720732461; x=1752268461;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=W2hf6xC3VFwwfj1PmmS3ARCLCbbL+jcjKAxdaPfr4jo=;
  b=cakBVmqj1+pOmAKPoAUapNI4LuM5uIsDwZ4r5MhI5rSRwbnTV6ApfAx7
   qk0bk8xTEr3SCWd1dGdLg4XrAUTkibQZCfisulwyE00X3n+rH4RyONgAX
   jyFszv/USYJJxHrFbCHkJZboJPEuOqHDW9/2/0igdEytoaX7D6CXOwh37
   Fsqe54Imb+7F3r5z/hdWanBGTG5GSvLq7AZZKEc1s1FMc5z54PfmVIt+7
   irRvaDw7mNxsaLPp6rARQaayJdQtY4wdXHkREvMpHCHoLBZVszKWO0qto
   XhWN+dZcdbIiGDilVzasBfh8NLcpMoVv3PtimstYQKYyXyWbHaJrkN5r1
   Q==;
X-CSE-ConnectionGUID: 3HVoAmlCROmItBYwpOkzEQ==
X-CSE-MsgGUID: 8LFzu2QmTGydyFu5zEKpIw==
X-IronPort-AV: E=McAfee;i="6700,10204,11130"; a="29300097"
X-IronPort-AV: E=Sophos;i="6.09,201,1716274800"; 
   d="scan'208";a="29300097"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jul 2024 14:14:20 -0700
X-CSE-ConnectionGUID: nbw7fb/RRtild7EulLGtBA==
X-CSE-MsgGUID: gZ3v31NMRtybnAkf//dHHw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,201,1716274800"; 
   d="scan'208";a="53627003"
Received: from hsuanchi-mobl1.amr.corp.intel.com (HELO peluse-desk5) ([10.213.173.245])
  by orviesa005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jul 2024 14:14:20 -0700
Date: Thu, 11 Jul 2024 14:14:18 -0700
From: Paul E Luse <paul.e.luse@linux.intel.com>
To: Mateusz =?UTF-8?B?Sm/FhGN6eWs=?= <mat.jonczyk@o2.pl>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org,
 stable@vger.kernel.org, Song Liu <song@kernel.org>, Yu Kuai
 <yukuai3@huawei.com>, Xiao Ni <xni@redhat.com>, Mariusz Tkaczyk
 <mariusz.tkaczyk@linux.intel.com>
Subject: Re: [PATCH] md/raid1: set max_sectors during early return from
 choose_slow_rdev()
Message-ID: <20240711141418.196c8b04@peluse-desk5>
In-Reply-To: <20240711202316.10775-1-mat.jonczyk@o2.pl>
References: <349e4894-b6ea-6bc4-b040-4a816b6960ab@huaweicloud.com>
	<20240711202316.10775-1-mat.jonczyk@o2.pl>
X-Mailer: Claws Mail 4.2.0 (GTK 3.24.41; aarch64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Thu, 11 Jul 2024 22:23:16 +0200
Mateusz Jo=C5=84czyk <mat.jonczyk@o2.pl> wrote:

> Linux 6.9+ is unable to start a degraded RAID1 array with one drive,
> when that drive has a write-mostly flag set. During such an attempt,
> the following assertion in bio_split() is hit:
>=20

Nice catch and good patch :)  Kwai?

-Paul

> 	BUG_ON(sectors <=3D 0);
>=20
> Call Trace:
> 	? bio_split+0x96/0xb0
> 	? exc_invalid_op+0x53/0x70
> 	? bio_split+0x96/0xb0
> 	? asm_exc_invalid_op+0x1b/0x20
> 	? bio_split+0x96/0xb0
> 	? raid1_read_request+0x890/0xd20
> 	? __call_rcu_common.constprop.0+0x97/0x260
> 	raid1_make_request+0x81/0xce0
> 	? __get_random_u32_below+0x17/0x70
> 	? new_slab+0x2b3/0x580
> 	md_handle_request+0x77/0x210
> 	md_submit_bio+0x62/0xa0
> 	__submit_bio+0x17b/0x230
> 	submit_bio_noacct_nocheck+0x18e/0x3c0
> 	submit_bio_noacct+0x244/0x670
>=20
> After investigation, it turned out that choose_slow_rdev() does not
> set the value of max_sectors in some cases and because of it,
> raid1_read_request calls bio_split with sectors =3D=3D 0.
>=20
> Fix it by filling in this variable.
>=20
> This bug was introduced in
> commit dfa8ecd167c1 ("md/raid1: factor out choose_slow_rdev() from
> read_balance()") but apparently hidden until
> commit 0091c5a269ec ("md/raid1: factor out helpers to choose the best
> rdev from read_balance()") shortly thereafter.
>=20
> Cc: stable@vger.kernel.org # 6.9.x+
> Signed-off-by: Mateusz Jo=C5=84czyk <mat.jonczyk@o2.pl>
> Fixes: dfa8ecd167c1 ("md/raid1: factor out choose_slow_rdev() from
> read_balance()") Cc: Song Liu <song@kernel.org>
> Cc: Yu Kuai <yukuai3@huawei.com>
> Cc: Paul Luse <paul.e.luse@linux.intel.com>
> Cc: Xiao Ni <xni@redhat.com>
> Cc: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
> Link:
> https://lore.kernel.org/linux-raid/20240706143038.7253-1-mat.jonczyk@o2.p=
l/
>=20
> --
>=20
> Tested on both Linux 6.10 and 6.9.8.
>=20
> Inside a VM, mdadm testsuite for RAID1 on 6.10 did not find any
> problems: ./test --dev=3Dloop --no-error --raidtype=3Draid1
> (on 6.9.8 there was one failure, caused by external bitmap support not
> compiled in).
>=20
> Notes:
> - I was reliably getting deadlocks when adding / removing devices
>   on such an array - while the array was loaded with fsstress with 20
>   concurrent processes. When the array was idle or loaded with
> fsstress with 8 processes, no such deadlocks happened in my tests.
>   This occurred also on unpatched Linux 6.8.0 though, but not on
>   6.1.97-rc1, so this is likely an independent regression (to be
>   investigated).
> - I was also getting deadlocks when adding / removing the bitmap on
> the array in similar conditions - this happened on Linux 6.1.97-rc1
>   also though. fsstress with 8 concurrent processes did cause it only
>   once during many tests.
> - in my testing, there was once a problem with hot adding an
>   internal bitmap to the array:
> 	mdadm: Cannot add bitmap while array is resyncing or
> reshaping etc. mdadm: failed to set internal bitmap.
>   even though no such reshaping was happening according to
> /proc/mdstat. This seems unrelated, though.
> ---
>  drivers/md/raid1.c | 1 +
>  1 file changed, 1 insertion(+)
>=20
> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
> index 7b8a71ca66dd..82f70a4ce6ed 100644
> --- a/drivers/md/raid1.c
> +++ b/drivers/md/raid1.c
> @@ -680,6 +680,7 @@ static int choose_slow_rdev(struct r1conf *conf,
> struct r1bio *r1_bio, len =3D r1_bio->sectors;
>  		read_len =3D raid1_check_read_range(rdev, this_sector,
> &len); if (read_len =3D=3D r1_bio->sectors) {
> +			*max_sectors =3D read_len;
>  			update_read_sectors(conf, disk, this_sector,
> read_len); return disk;
>  		}
>=20
> base-commit: 256abd8e550ce977b728be79a74e1729438b4948

