Received: from va-2-27.ptr.blmpb.com (va-2-27.ptr.blmpb.com [209.127.231.27])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC8EC3859C9
	for <linux-raid@vger.kernel.org>; Tue, 28 Apr 2026 08:21:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.27
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777364518; cv=none; b=lClWqgZmMmOSQxQkUKdXbjPUAyH+lgaMdC0Yiy5l3vZqeysOUi0yIi2mlzK0lTarwP2A17rPkAOS1XfvmUyCy3pAKFa9Nujdlway4HtZY9fPK3GiGdVAjFX0B2K+czKHSJt5Oj7enlCpZ1HFn+xSvVhi/vWFejttmcq1C4hcsXc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777364518; c=relaxed/simple;
	bh=m6WDakV2rlNWUW5uu54nROWRH2E6LOhDOlFmGfwNqls=;
	h=From:In-Reply-To:Cc:Date:Content-Type:Subject:Message-Id:To:
	 Mime-Version:References; b=VnEehQDAkuDvoU8hArHZnPGnZj/nuHaMFjMrDuDyIz/x51+UH8EUXupXF87s29ozbgy4YjAsQ4bfaERVXepPWICl7iXLg7yUFUre+VPnv1DeM2nhrXOx2W1hMOV62qQGnDaojZoZ+OPyot4phLyPOpiN+PlbiWsMwiAd0+Po9hM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com; spf=none smtp.mailfrom=fnnas.com; dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b=fMTGhF3R; arc=none smtp.client-ip=209.127.231.27
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=fnnas.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b="fMTGhF3R"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fnnas-com.20200927.dkim.feishu.cn; t=1777364504;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=m6WDakV2rlNWUW5uu54nROWRH2E6LOhDOlFmGfwNqls=;
 b=fMTGhF3Rs+AlzxuRaHVf5Qa4S2RDLYkyYlQVBLP0liSVd/2qeuqLEguBJjRT+GIvBentG1
 IRFOmCxIQnfv2dHHGChnPKfHLTkgYKCkLqbGDhJLdoywXB5TBRtyzGOXgrvBXYkrLoMn1K
 APAPNqNlzQsdUaMO9ffbW9GONanmRsUOYvmMb9OTHA5Toj8zVYam8UcFtGXp0LfGKnaMtQ
 Q8D5M+bTSNA6tDm96oMR8gtgUuLtpUeNeVxz4/vK6e5QfxqSqp1n36xjEhnU72LI4oBKBN
 cJrRNooOQmO868Di7gbYFiZpgnVXMxPe9G3Ng7S4E+WHUjniz2N0Qnv/lop7qQ==
From: "Yu Kuai" <yukuai@fnnas.com>
X-Original-From: Yu Kuai <yukuai@fnnas.com>
In-Reply-To: <qzo35t50.fsf@damenly.org>
Reply-To: yukuai@fnnas.com
Cc: "Song Liu" <song@kernel.org>, <glass.su@suse.com>, 
	"Li Nan" <linan122@huawei.com>, "Xiao Ni" <xiao@kernel.org>, 
	<linux-raid@vger.kernel.org>, <linux-kernel@vger.kernel.org>, 
	<yukuai@fnnas.com>
Date: Tue, 28 Apr 2026 16:21:39 +0800
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Received: from [192.168.1.104] ([39.182.0.183]) by smtp.feishu.cn with ESMTPS; Tue, 28 Apr 2026 16:21:41 +0800
Subject: Re: [PATCH v13 0/3] md/md-bitmap: restore bitmap grow through sysfs
Message-Id: <5b303e36-51ed-46cf-aa0d-29240822e94b@fnnas.com>
Content-Language: en-US
To: "Su Yue" <l@damenly.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Lms-Return-Path: <lba+269f06e16+e19024+vger.kernel.org+yukuai@fnnas.com>
User-Agent: Mozilla Thunderbird
References: <20260425024615.1696892-1-yukuai@fnnas.com> <qzo35t50.fsf@damenly.org>

Hi,

=E5=9C=A8 2026/4/25 16:41, Su Yue =E5=86=99=E9=81=93:
> On Sat 25 Apr 2026 at 10:46, Yu Kuai <yukuai@fnnas.com> wrote:
>
>> mdadm --grow adds an internal bitmap by writing bitmap/location for an
>> array that currently has no bitmap. That requires the bitmap directory
>> and location attribute to exist before the classic bitmap backend is
>> created.
>>
>> This series separates bitmap backend lifetime from bitmap sysfs=20
>> lifetime,
>> splits the sysfs layout into common and backend-specific groups, and=20
>> adds
>> a small "none" bitmap backend. The none backend keeps bitmap/location
>> available while no real bitmap is active, and the location store path=20
>> can
>> then switch between the none backend and the classic bitmap backend
>> without tearing down the common bitmap sysfs directory.
>>
>> Patch 1 factors bitmap creation and destruction into helpers that do not
>> touch sysfs registration.
>>
>> Patch 2 splits the classic bitmap sysfs files into a common group and an
>> internal-bitmap group, and converts bitmap backend operations to use a
>> sysfs group array.
>>
>> Patch 3 adds the none backend and uses it to restore mdadm --grow bitmap
>> addition through bitmap/location.
>>
>> Changes since v12:
>> - Keep the factoring patch focused on no-sysfs bitmap lifetime helpers.
>> - Make bitmap operation lookup depend only on the current bitmap id
>> =C2=A0 matching the installed backend.
>> - Trim the none backend to only the operations required by the active
>> =C2=A0 call paths.
>> - Rework bitmap/location error handling with explicit cleanup labels.
>> - Restore the none backend after bitmap removal and creation/load
>> =C2=A0 failures so bitmap/location stays available.
>>
>> Validation:
>> =C2=A0 - create a RAID1 array with --bitmap=3Dnone
>> =C2=A0 - verify /sys/block/md0/md/bitmap/location exists and reports =C2=
=A0 "none"
>> =C2=A0 - mdadm --grow /dev/md0 --bitmap=3Dinternal
>> =C2=A0 - verify location switches to "+8", mdadm reports "Intent Bitmap:
>> =C2=A0=C2=A0=C2=A0 Internal", and /proc/mdstat reports a bitmap
>> =C2=A0 - mdadm --grow /dev/md0 --bitmap=3Dnone
>> =C2=A0 - verify location switches back to "none" and only the common =C2=
=A0=20
>> location
>> =C2=A0=C2=A0=C2=A0 attribute remains under md/bitmap
>> =C2=A0 - repeat the internal/none switch once more
>> - Checked the QEMU serial log for panic, Oops, BUG, WARNING, Call Trace,
>> =C2=A0 RCU stall, and hung-task patterns; none were found.
>>
>> Yu Kuai (3):
>> =C2=A0 md: factor bitmap creation away from sysfs handling
>> =C2=A0 md/md-bitmap: split bitmap sysfs groups
>> =C2=A0 md/md-bitmap: add a none backend for bitmap grow
>>
>
> Thanks for all.
> Would you like to add tag Fixes: fb8cc3b0d9db for the whole series=20
> while merging?

Sure, sorry that I forgot the fix tag.

>
> --=20
> Su
>
>> =C2=A0drivers/md/md-bitmap.c=C2=A0=C2=A0 | 131 =C2=A0+++++++++++++++++++=
++++++++++++++++----
>> =C2=A0drivers/md/md-bitmap.h=C2=A0=C2=A0 |=C2=A0=C2=A0 2 +-
>> =C2=A0drivers/md/md-llbitmap.c |=C2=A0=C2=A0 7 ++-
>> =C2=A0drivers/md/md.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0 | 125 =C2=A0++++++++++++++++++++++++++-----------
>> =C2=A0drivers/md/md.h=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0 |=C2=A0=C2=A0 3 +
>> =C2=A05 files changed, 218 insertions(+), 50 deletions(-)

Applied with following fix tag for patch 3:

Fixes: fb8cc3b0d9db ("md/md-bitmap: delay registration of bitmap_ops until =
creating bitmap")

>>
>> base-commit: c85d314b135ff569c1031f2ef8e40368bcfe72ac

--=20
Thansk,
Kuai
