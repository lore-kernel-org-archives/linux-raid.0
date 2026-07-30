Received: from va-2-16.ptr.blmpb.com (va-2-16.ptr.blmpb.com [209.127.231.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3E3436F414
	for <linux-raid@vger.kernel.org>; Thu, 30 Jul 2026 09:37:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785404264; cv=none; b=djMjC7DJq0i32Y/vl80tfCbR7AYcYMM69O7908LSHpkv5++tbVJAtRsdM2glHoRFLAjakIwniJIyMIg1Gdzp/0KXwB1RbGqeV5BQRUDC4uvqdCwjPRVcKRl0CDC2BgktFQYsqdJ+Nbs9vyxWuW+NHG73a4s9v1z0PdVcdFiOfvY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785404264; c=relaxed/simple;
	bh=SkQC59h+4SC2Whs/9Iasza+sAK2CtCeUbom/zGkmrFE=;
	h=Date:References:From:Mime-Version:To:Message-Id:In-Reply-To:
	 Content-Type:Cc:Subject; b=Gdl8yDOgbLc1z59YWs5d4ljAyG7QQ2JH/WfFx+CGuKxVe/j5dde6g8bfp9gopDndPat9T30w2XO/HA+toR1lNMPkPWwy3YVJPlhFjfQxWpcArGg2z92SXK1Ftffzdp9kquwQWr/Nh/jwmW7X2aDCKFK6yvhYflcQfZZZ6uobmm0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io; spf=pass smtp.mailfrom=fygo.io; dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b=RUSR7n8L; arc=none smtp.client-ip=209.127.231.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fygo.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b="RUSR7n8L"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fygo-io.20200929.dkim.larksuite.com; t=1785404257;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=WZenZ1u1wOZkgf8qVccr2sC0toZ0zLT1ZtA2wuqVunQ=;
 b=RUSR7n8LBl6W+/0t9RMMZhdxSEdVT3V5KLv0EK4ZOa9pu7/+sA9oO/3mX79W9VEk5XJP+o
 Eh51pdrMPHf16VD6bR24X1rgGusZtb6tnR5Xatm1T8vhbbcm++QEEjCWJshx0yxtXaQmDi
 yphq7c2qKvdwkF73XEl+HkQDoZOAPYNA9ZPAuKc8rHA3tQ2z5ei+yMTZn6Oy0vSTdwzg6t
 +Qiq3UiMng1XbBedmJIic/egQetSdNpvNpRllVQTQQD7uOjg38naHpHDvRtthh60wjXW6b
 y9Ic247SYHmO9Z37zSBmqcT3RsXvLNqTh9NA0ZUlspVUNdO+UdvVuhu9n2J/7w==
Date: Thu, 30 Jul 2026 17:37:32 +0800
References: <20260624075824.2601110-1-chencheng@fnnas.com>
Received: from [192.168.1.104] ([39.182.0.181]) by smtp.larksuite.com with ESMTPS; Thu, 30 Jul 2026 09:37:35 +0000
Reply-To: yukuai@fygo.io
From: "yu kuai" <yukuai@fygo.io>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
To: "Chen Cheng" <chencheng@fnnas.com>, <linux-raid@vger.kernel.org>, 
	"yu kuai" <yukuai@fygo.io>
Message-Id: <89845577-abb6-44c2-9d5e-f4d9c345a9fc@fygo.io>
In-Reply-To: <20260624075824.2601110-1-chencheng@fnnas.com>
X-Lms-Return-Path: <lba+26a6b1b60+9e00a1+vger.kernel.org+yukuai@fygo.io>
Content-Type: text/plain; charset=UTF-8
Cc: <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3] md/raid5: fix reshape deadlock while failed devices more than max degraded
User-Agent: Mozilla Thunderbird
X-Original-From: yu kuai <yukuai@fygo.io>
Content-Transfer-Encoding: quoted-printable

=E5=9C=A8 2026/6/24 15:58, Chen Cheng =E5=86=99=E9=81=93:

> From: Chen Cheng<chencheng@fnnas.com>
>
> reshape stripe lifetime:
> - start reshape =3D=3D> reshape_request():
> 	* get destination stripe,
> 	  - if need to copy source data chunks, set STRIPE_EXPANDING;
> 	  - or, if new regions past the old end of the array, zero-filled,
> 	    no need source data, set STRIPE_EXPANDING | STRIPE_READY
> 	* get source stripe,
> 	  - set STRIPE_EXPAND_SOURCE
>
> - handle expand stripe =3D=3D> handle_stripe():
> 	reshape use reconstruct-write to construct stripe,
> 	four stages:
> 	1. prepare source data chunks for old geometry stripe
> 		- fill source stripe data by read or compute
> 	2. move data from old geometry source stripe to new geometry
> 	   destination stripe
> 		- source stripe clear STRIPE_EXPAND_SOURCE
> 		- drain data from source to destination stripe
> 		- mark stripe chunk as R5_Expanded|R5_UPTODATE when the
> 		  drain from source chunk to destionation chunk is completed
> 		- all stripe chunks drain are completed, then mark
> 		  STRIPE_EXPAND_READY
> 	3. calculate p/q chunks for destination stripe
> 		- if destination stripe does't depends on source dstripe,
> 		  then we can clear STRIPE_EXPANDING
> 	4. write-out to disks and release
> 		- set R5_Wantwrite|R5_Locked, writeout to disk
> 		- if write-out successed, clear STRIPE_EXPAND_READY, and
> 		  decrement reshape_stripe, call md_done_sync() to report
> 		  reshape progress.
>
> 1. cleanup the following kinds of **destination stripe**
> 	when failed device more than max degraded:
>    - new regions past the old end of the array, zero-filled in place,
>      requires no source data.
> 	(STRIPE_EXPANDING | STRIPE_EXPAND_READY)
>    - prepare source data chunks already done, and writeout failed
> 	(STRIPE_EXPAND_READY)
>
> 2. destination stripes that need source data
> 	(STRIPE_EXPANDING, no STRIPE_HANDLE)
>    - these kind of stripes sit idle in the stripe cache and are never see=
n
>      by handle_stripe(). So clean up indirectly when thier source stripe
>      (type 3) is processed.
>
> 3. source stripes (STRIPE_EXPAND_SOURCE)
>    - hit handle_stripe() after thier member disks are markded Faulty.
>    - clear STRIPE_EXPAND_SOURCE, finds and cleanup all dependent destinat=
ion
>      stripes that were waiting for data.
>    - walks the source's data disks, compute the corresponding destination
>      sector, looks up the destination stripe, and do cleanup(clear flags,
>      dec counters, call md_done_sync())
>
> Reproducer:
>    - Create a 4-disk RAID5 with mdadm on top of 5 disposable test disks
>      wrapped by dm targets.
>    - Add the 5th device as a spare and start a 4 -> 5 reshape.
>    - Wait until /sys/block/mdX/md/sync_action reports "reshape".
>    - Inject failures on two members so reshape exceeds max_degraded.
>    - After a few seconds, write "frozen" to /sys/block/mdX/md/sync_action=
.
>      Before this fix, the write blocks indefinitely.
>
> Read-error variant:
>    - Use dm-dust on /dev/sd[b-f].
>    - Preload bad blocks on two source members, e.g. dust0 and dust1:
>        dmsetup message dust0 0 addbadblock <range>
>        dmsetup message dust1 0 addbadblock <range>
>    - Start reshape:
>        mdadm -C /dev/mdX -e 1.2 -l 5 -n 4 -c 64 --assume-clean /dev/mappe=
r/dust{0..3}
>        mdadm --manage /dev/mdX --add /dev/mapper/dust4
>        mdadm --grow /dev/mdX -n 5 --backup-file=3D/tmp/grow.backup &
>    - Once reshape starts, enable the injected read failures:
>        dmsetup message dust0 0 enable
>        dmsetup message dust1 0 enable
>    - Then:
>        echo frozen > /sys/block/mdX/md/sync_action
>      hangs forever before the fix.
>
> Write-error variant:
>    - Use dm-flakey on /dev/sd[b-f].
>    - Start the same 4 -> 5 reshape on flakey0..flakey4.
>    - Once reshape starts, switch two members, e.g. flakey3 and flakey4,
>      to error_writes.
>    - Then:
>        echo frozen > /sys/block/mdX/md/sync_action
>      hangs forever before the fix.
>
> md_do_sync() exits its main loop on MD_RECOVERY_INTR but then blocks
> forever at:
>
>    wait_event(mddev->recovery_wait,
> 		!atomic_read(&mddev->recovery_active));
>
> After the fix recovery_active drains to zero, md_do_sync() prints
>
>      md/raid:md0: Cannot continue operation (2/5 failed).
>      md: md0: reshape interrupted.
>
> v2 -> v3:
> - just kick sashiko-bot to review my patch..
>
> changes v1 -> v2:
> - handle reshape write deadlock while failed devices more than max degrad=
ed
>
> Signed-off-by: Chen Cheng<chencheng@fnnas.com>
> ---
>   drivers/md/raid5.c | 74 ++++++++++++++++++++++++++++++++++++++++++++++
>   1 file changed, 74 insertions(+)
Applied to md-7.3 with change log removed.

--=20
Thanks,
Kuai
