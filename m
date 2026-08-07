Received: from va-2-46.ptr.blmpb.com (va-2-46.ptr.blmpb.com [209.127.231.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAEB441A900
	for <linux-raid@vger.kernel.org>; Fri,  7 Aug 2026 08:11:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786090295; cv=none; b=e+C3mfTgHGN8trmNHKulqEITRwIkUDrY4UiJka9V+fs1+x/UgVT0WXMO0fYmq/4MOgYHAKRABivvUh4zscHyJk6TTFmTqIipzhLY7OKCJiNpf4gNF3b+y+rOqWSGHG8UQVIOKm24JG/KfwlV59AEMSOXwCjb6RU81FZtwU3ZLwQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786090295; c=relaxed/simple;
	bh=jhOko8JSig7CPmIa1KopY81EIdmnnrV8LaIrQULTbso=;
	h=Mime-Version:Content-Type:To:From:Message-Id:References:Cc:
	 Subject:Date:In-Reply-To; b=M7xPQTxIvShyFdb2XmqOqdP8uQsKySA7WX2i/qoOsU0VtbZ0JNQcHtoTUE2LfNAvcf3FGTQjpJ4gDE6rO55TuD4Rev01PVOu5+2U5RSYZbe7kQFNUQhz8u7wTxvePKlV1BUzuBqt4+uz0TDblPWp4W40YZvpREIT9Usv+ryrrzQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io; spf=pass smtp.mailfrom=fygo.io; dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b=E2YMuyV6; arc=none smtp.client-ip=209.127.231.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fygo.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b="E2YMuyV6"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fygo-io.20200929.dkim.larksuite.com; t=1786090270;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=j1D7b7JykFrXuMJHVkJ1gEFJoniiVsq6YBtAicxtCfA=;
 b=E2YMuyV6ih/rCBw+nqah71YxABkXFsIvsl4UDz0kVZ0pAiTj++dqj//IVyj6cFQtjnkvIj
 QkoVeHlqLQMMYouz3+RkryFdzYCVyl/JvvzI7ZULkvgR+ARzsxeT5xFXvMyczpUeqskuIU
 Fl3qY699b6DNmr+1Arn28HwWAo/VECpuIlH9qBSqHbt62V/vNrykSFrBI7IE86ABfgVUA8
 yaKkuR2inPIteQeurCGc/WIWPwTj6b8rqnsRd1NYAyD7yoHjqw/YC2PIiqy2XXCiWcezxh
 +FtzmJ+frzga426ktI0pHEo1S7qSctgeuULIZR3L7BZoUu/4xxKfT3eec3vyMg==
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Lms-Return-Path: <lba+26a75931e+9e5af5+vger.kernel.org+yukuai@fygo.io>
Content-Type: text/plain; charset=UTF-8
Received: from [192.168.1.104] ([39.182.0.170]) by smtp.larksuite.com with ESMTPS; Fri, 07 Aug 2026 08:11:08 +0000
To: "Yunye Zhao" <yunye.zhao@linux.alibaba.com>, 
	"Song Liu" <song@kernel.org>, "yu kuai" <yukuai@fygo.io>
From: "yu kuai" <yukuai@fygo.io>
Message-Id: <9eef1f2c-0042-412b-b37d-60a24861ba8e@fygo.io>
X-Original-From: yu kuai <yukuai@fygo.io>
User-Agent: Mozilla Thunderbird
References: <20260717062743.128189-1-yunye.zhao@linux.alibaba.com> <20260723135535.101995-1-yunye.zhao@linux.alibaba.com> <20260723135535.101995-2-yunye.zhao@linux.alibaba.com>
Reply-To: yukuai@fygo.io
Cc: "Li Nan" <magiclinan@didiglobal.com>, "Xiao Ni" <xiao@kernel.org>, 
	"Joseph Qi" <joseph.qi@linux.alibaba.com>, <linux-raid@vger.kernel.org>, 
	<linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 1/3] md/raid10: fix still_degraded being inverted in raid10_sync_request()
Date: Fri, 7 Aug 2026 16:11:05 +0800
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20260723135535.101995-2-yunye.zhao@linux.alibaba.com>

=E5=9C=A8 2026/7/23 21:55, Yunye Zhao =E5=86=99=E9=81=93:

> Commit fe6a19d40ceb ("md/md-bitmap: merge md_bitmap_start_sync() into
> bitmap_operations") converted still_degraded from int to bool, but
> inverted the assignment in the loop that checks whether the array will
> still be degraded after the current device is recovered:
> "still_degraded =3D 1" became "still_degraded =3D false".
>
> As a result, recovering a device while another mirror is still missing
> calls md_bitmap_start_sync() with degraded =3D=3D false, which clears bit=
map
> bits that the still-missing device needs.  When that device is re-added,
> its bitmap-based recovery finds the bits already cleared and skips every
> region written while the array was degraded, so it is marked In_sync
> while holding stale data: silent corruption.
>
> Reproducer (raid10 near=3D2, 4 disks, internal bitmap):
>   - fail and remove one disk of each mirror pair
>   - write to the degraded array
>   - re-add both disks and let recovery finish
>   - "check" reports mismatch_cnt=3D262272 after 256 MiB of degraded
>     writes and file contents differ; the second disk's "recovery"
>     completes in milliseconds because everything is skipped
>
> The same conversion in raid1 got it right (still_degraded =3D true).
> Restore the correct value.
>
> Fixes: fe6a19d40ceb ("md/md-bitmap: merge md_bitmap_start_sync() into bit=
map_operations")
> Cc:stable@vger.kernel.org
> Signed-off-by: Yunye Zhao<yunye.zhao@linux.alibaba.com>
> ---
>   drivers/md/raid10.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
Applied to md-7.3

--=20
Thanks,
Kuai
