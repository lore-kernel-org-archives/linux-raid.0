Received: from sg-1-33.ptr.blmpb.com (sg-1-33.ptr.blmpb.com [118.26.132.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E5AC347FD9
	for <linux-raid@vger.kernel.org>; Wed,  4 Feb 2026 17:02:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=118.26.132.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770224576; cv=none; b=ii/WLThoBUeFzBRc71+tNX94JQxg9vHjZtmJueyTMKX8NxnEyRPg8n5Dfj5cIr3SRshhaBLRP0nfpbFRh6H8wtqB0OZVLQaQTnY4pSN3K3QZIq++XfZb9IDj2VXFIsineSD6EyVtMDmwZCkAoSrcHf2/d3kJWW03njGjacH/Fwk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770224576; c=relaxed/simple;
	bh=ePZ6xRTxHDqyogH8TWwx1fxI7OglsnKwcf6DS7srdjk=;
	h=Cc:Message-Id:Subject:Mime-Version:References:Date:In-Reply-To:
	 Content-Type:To:From; b=P8xQIXaWC3W8V0MLRgxZMERvrH5lU5XeGwmdn9mLgPvMYqmti7jTsK164pMTW7NmoHq+sVbadd6v0mJTKMXSs4sG1T15306KfBK7nEQUNB79wDnDu0W+c5wB3ZI8Jp7nmA8bn6f+nQ4NzEBRjvBUByokwjOxxM1Rumo6tU5X1nk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com; spf=pass smtp.mailfrom=fnnas.com; dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b=PlEszsV3; arc=none smtp.client-ip=118.26.132.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fnnas.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b="PlEszsV3"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fnnas-com.20200927.dkim.feishu.cn; t=1770224570;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=o0qpFjDMjhwlHtTuv1CaMHQCpyV+DAuU+VTh24+M1VY=;
 b=PlEszsV3vvHnKbrilGx1qg7AFbOaqoheA3hFw7qfjZRQ+YbAekd4wb2XjstkXtUjgh8KOw
 bkmnCp19lpAff0NGEhxKBCeDJ8fZ0Y2g+rVcc86OITG514xsQ6cFqKOTl2izq46cq40dDh
 MbIta77DHrDl74O4YY5U7HFFxlXds/zcmNyspZrboqIqgCiyoHsibVR5A/RlEDwknboK45
 xAprQljjdw9K4kSuWPop5Xu9KVyD/fVDg/tqP3zCIJ36i/ueGCegzj63nHAX4Y1ZvVrt2X
 TH0v/ZVqXTNqVVwuPNgOjOa8z/WLLg7acfe5rqq3C8LaR9cPTJKIGf9fJioChw==
Cc: <xni@redhat.com>, <linux-raid@vger.kernel.org>, 
	<linux-kernel@vger.kernel.org>, <yangerkun@huawei.com>, 
	<yi.zhang@huawei.com>, <yukuai@fnnas.com>
Message-Id: <def3b536-7840-426a-9805-f62363174812@fnnas.com>
Subject: Re: [PATCH v2 00/14] folio support for sync I/O in RAID
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Lms-Return-Path: <lba+269837bb8+ad47c6+vger.kernel.org+yukuai@fnnas.com>
References: <20260128075708.2259525-1-linan666@huaweicloud.com>
Content-Transfer-Encoding: quoted-printable
Content-Language: en-US
X-Original-From: Yu Kuai <yukuai@fnnas.com>
Reply-To: yukuai@fnnas.com
Date: Thu, 5 Feb 2026 01:02:45 +0800
In-Reply-To: <20260128075708.2259525-1-linan666@huaweicloud.com>
User-Agent: Mozilla Thunderbird
Content-Type: text/plain; charset=UTF-8
To: <linan666@huaweicloud.com>, <song@kernel.org>
From: "Yu Kuai" <yukuai@fnnas.com>
Received: from [192.168.1.104] ([39.182.0.137]) by smtp.feishu.cn with ESMTPS; Thu, 05 Feb 2026 01:02:47 +0800

Hi,

=E5=9C=A8 2026/1/28 15:56, linan666@huaweicloud.com =E5=86=99=E9=81=93:
> From: Li Nan <linan122@huawei.com>
>
> This patchset adds folio support to sync operations in raid1/10.
> Previously, we used 16 * 4K pages for 64K sync I/O. With this change,
> we'll use a single 64K folio instead. Using folios reduces
> resync/recovery time by 20% on HDD.
>
> This is the first step towards full folio support in RAID. Going forward,
> I will replace the remaining page-based usage with folio.
>
> The patchset was tested with mdadm. Additional fault injection stress tes=
ts
> were run under file systems.

For conclusion, I think you can send patch 1,8,9 first, they're not quite
related to folio and can be applied. Then, please move patch 12,13 before p=
atch 5
in the separate patch set, and looks like the number of patches can be smal=
l.

BTW, there are still pages in other context, do you plan to convert them?

>
> v2:
>   - Remove patch "md: use folio for bb_folio". It will be included in
>     a later patch set
>   - In patch 5:
>      1) fix typo
>      2) rewrite the logic of copying data in process_checks()
>      3) rename resync_get_all_folio() to resync_get_folio()
>      4) s/resync_pages *rps/resync_folio *rfs/g in
>         raid1_alloc_init_r1buf() and raid10_alloc_init_r10buf()
>   - Subsequent patches: Adapting conflicts caused by patch 5
>
> Li Nan (14):
>    md/raid1,raid10: clean up of RESYNC_SECTORS
>    md: introduce sync_folio_io for folio support in RAID
>    md/raid1: use folio for tmppage
>    md/raid10: use folio for tmppage
>    md/raid1,raid10: use folio for sync path IO
>    md: Clean up folio sync support related code
>    md/raid1: clean up useless sync_blocks handling in raid1_sync_request
>    md/raid1: fix IO error at logical block size granularity
>    md/raid10: fix IO error at logical block size granularity
>    md/raid1,raid10: clean up resync_fetch_folio
>    md: clean up resync_free_folio
>    md/raid1: clean up sync IO size calculation in raid1_sync_request
>    md/raid10: clean up sync IO size calculation in raid10_sync_request
>    md/raid1,raid10: fall back to smaller order if sync folio alloc fails
>
>   drivers/md/md.h       |   2 +
>   drivers/md/raid1.h    |   2 +-
>   drivers/md/raid10.h   |   2 +-
>   drivers/md/md.c       |  29 +++-
>   drivers/md/raid1-10.c |  81 ++++-------
>   drivers/md/raid1.c    | 233 ++++++++++++++-----------------
>   drivers/md/raid10.c   | 315 ++++++++++++++++++++----------------------
>   7 files changed, 308 insertions(+), 356 deletions(-)
>
--=20
Thansk,
Kuai
