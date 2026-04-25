Received: from va-2-40.ptr.blmpb.com (va-2-40.ptr.blmpb.com [209.127.231.40])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19A82223707
	for <linux-raid@vger.kernel.org>; Sat, 25 Apr 2026 02:49:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.40
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777085355; cv=none; b=ogjgpV2rX98zD40yi74eVMdXwHp0dHZu1UdehQxNO4oeDc0yQHGHRuwq+YVX7mdMBX343rF78SH011XsaCEDzPHZkNJliWrF2G+f7ynEgzcq+2vMeseQQhv4HdcneNgNBqPHpLc3RRqy4aBDFzYeMD5lI/vB1cke5YRaVj9ncf8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777085355; c=relaxed/simple;
	bh=3x3iPUo404Swh7QMatabdHJzC9EgEZdAMMifh1uoEmc=;
	h=Content-Type:Cc:From:Mime-Version:To:Message-Id:Date:References:
	 Subject:In-Reply-To; b=dRzX89otHA0JzMnadoL2ahEHuAAyKxveIUpBg6GdPNlTkPkm0YsodLib7lnzzMwON4HGeX/kDrFvL2ZU0rihvTyN9cyesBUjMl0mOiLHZV9nG8CeaXl2X03YMquNcQK7IsMwku12FwTwueRruuDAuZUDSbwcrp5+b+lOe403Tus=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com; spf=none smtp.mailfrom=fnnas.com; dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b=Z7cJr7fU; arc=none smtp.client-ip=209.127.231.40
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=fnnas.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b="Z7cJr7fU"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fnnas-com.20200927.dkim.feishu.cn; t=1777085346;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=We5E8voQh24P+8oj/Fsj+NQTodjfpZiYjJrxts7anMo=;
 b=Z7cJr7fU0qDJFxuWG7Eb40fCMZZKdtEjwLkHuWu6AB84ggNvlvOPDzewyJY2cUCqvZw4iV
 kJqWngsJ5cbEJ6UR6z0G1JMteeMeIZQpW/m5QxCiyjL5nQXOTv3vL4pWvs/GbksQ5kxPA5
 O3eX0huS/5+b2zabI6Q4EkftzJd3kHoLY4V89q6eHGI0ytLDkDV3UNmtot04drWLOvTjlS
 BOpBTTJ53zJEmquvzRPaKborAJ5KrxTqQUGpQOcXPwLs+kJp2fY21pzotkyQFGC6MpEtks
 7W+vesh3QhsjO+MNnF8y/0i5Izv5bdl+mZVEEDgaRvjKjRevpD0ltrm6SKZN3w==
X-Lms-Return-Path: <lba+269ec2ba0+407673+vger.kernel.org+yukuai@fnnas.com>
X-Original-From: Yu Kuai <yukuai@fnnas.com>
Content-Type: text/plain; charset=UTF-8
Cc: <glass.su@suse.com>, "Li Nan" <linan122@huawei.com>, 
	"Xiao Ni" <xiao@kernel.org>, <linux-raid@vger.kernel.org>, 
	<linux-kernel@vger.kernel.org>, <yukuai@fnnas.com>
From: "Yu Kuai" <yukuai@fnnas.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
User-Agent: Mozilla Thunderbird
Reply-To: yukuai@fnnas.com
To: "Song Liu" <song@kernel.org>
Message-Id: <47e850c8-fcc4-43a0-91b3-12121bfb9dac@fnnas.com>
Date: Sat, 25 Apr 2026 10:49:01 +0800
Received: from [192.168.1.104] ([39.182.0.183]) by smtp.feishu.cn with ESMTPS; Sat, 25 Apr 2026 10:49:03 +0800
References: <20260425024615.1696892-1-yukuai@fnnas.com>
Subject: Re: [PATCH v13 0/3] md/md-bitmap: restore bitmap grow through sysfs
Content-Language: en-US
In-Reply-To: <20260425024615.1696892-1-yukuai@fnnas.com>

Hi,

Please just ignore the v13, it's local version by ai that I forgot to remov=
e.

=E5=9C=A8 2026/4/25 10:46, Yu Kuai =E5=86=99=E9=81=93:
> mdadm --grow adds an internal bitmap by writing bitmap/location for an
> array that currently has no bitmap. That requires the bitmap directory
> and location attribute to exist before the classic bitmap backend is
> created.
>
> This series separates bitmap backend lifetime from bitmap sysfs lifetime,
> splits the sysfs layout into common and backend-specific groups, and adds
> a small "none" bitmap backend. The none backend keeps bitmap/location
> available while no real bitmap is active, and the location store path can
> then switch between the none backend and the classic bitmap backend
> without tearing down the common bitmap sysfs directory.
>
> Patch 1 factors bitmap creation and destruction into helpers that do not
> touch sysfs registration.
>
> Patch 2 splits the classic bitmap sysfs files into a common group and an
> internal-bitmap group, and converts bitmap backend operations to use a
> sysfs group array.
>
> Patch 3 adds the none backend and uses it to restore mdadm --grow bitmap
> addition through bitmap/location.
>
> Changes since v12:
> - Keep the factoring patch focused on no-sysfs bitmap lifetime helpers.
> - Make bitmap operation lookup depend only on the current bitmap id
>    matching the installed backend.
> - Trim the none backend to only the operations required by the active
>    call paths.
> - Rework bitmap/location error handling with explicit cleanup labels.
> - Restore the none backend after bitmap removal and creation/load
>    failures so bitmap/location stays available.
>
> Validation:
>    - create a RAID1 array with --bitmap=3Dnone
>    - verify /sys/block/md0/md/bitmap/location exists and reports "none"
>    - mdadm --grow /dev/md0 --bitmap=3Dinternal
>    - verify location switches to "+8", mdadm reports "Intent Bitmap:
>      Internal", and /proc/mdstat reports a bitmap
>    - mdadm --grow /dev/md0 --bitmap=3Dnone
>    - verify location switches back to "none" and only the common location
>      attribute remains under md/bitmap
>    - repeat the internal/none switch once more
> - Checked the QEMU serial log for panic, Oops, BUG, WARNING, Call Trace,
>    RCU stall, and hung-task patterns; none were found.
>
> Yu Kuai (3):
>    md: factor bitmap creation away from sysfs handling
>    md/md-bitmap: split bitmap sysfs groups
>    md/md-bitmap: add a none backend for bitmap grow
>
>   drivers/md/md-bitmap.c   | 131 +++++++++++++++++++++++++++++++++++----
>   drivers/md/md-bitmap.h   |   2 +-
>   drivers/md/md-llbitmap.c |   7 ++-
>   drivers/md/md.c          | 125 ++++++++++++++++++++++++++-----------
>   drivers/md/md.h          |   3 +
>   5 files changed, 218 insertions(+), 50 deletions(-)
>
> base-commit: c85d314b135ff569c1031f2ef8e40368bcfe72ac

--=20
Thansk,
Kuai
