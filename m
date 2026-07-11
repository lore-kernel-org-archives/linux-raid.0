Received: from va-2-51.ptr.blmpb.com (va-2-51.ptr.blmpb.com [209.127.231.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D036175A98
	for <linux-raid@vger.kernel.org>; Sat, 11 Jul 2026 16:39:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783787990; cv=none; b=eyMXmqHivu2I67nqkqdCi2t+2cF0+Hnho7oGIERXlKg8zdwhviugL8DeYamKFjIq8pi7hLsAjplyntDFGzpa9ZCjzwAysMmuUkTLMXH6Q1l0a0JURZYo8+6IunQ3YXB+ksM4XD+YpRB1yIwxu1HGvargRLTrtPVxpBqSn/oA9SE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783787990; c=relaxed/simple;
	bh=kfm+YMoHEbDTa8tfU7Fz0x21xlfJnFvz7ZO2iMDLlgY=;
	h=Cc:Date:Content-Type:To:Message-Id:Mime-Version:From:Subject:
	 In-Reply-To:References; b=GV3HaJtL08KLZhO1fw9jsoAzMNGOr6bAw4qCR/cPTXx2nB9qwKRdx86RFW/MICLR8kx/WqQAenYY6nMhBvlDTKkO6foKSomui5So7F2cZr3yN9f1INtlKbQ+jCv/8k9Ri/W0rO/0RnzYYhnTqVpHEY5fzK8TcaC3GD9ymk1KzEU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io; spf=pass smtp.mailfrom=fygo.io; dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b=M5FcIXkh; arc=none smtp.client-ip=209.127.231.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fygo.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b="M5FcIXkh"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fygo-io.20200929.dkim.larksuite.com; t=1783787977;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=IkHVOIgSF7tNzkUUl7Maq/x+q5QHVjYXwHA45lj15V4=;
 b=M5FcIXkhjemEBG+L9qQ66AhGdAH7kbkt8k8xWUNfcq4b86zlIMmeD2AmjIJvC4t8jnamOZ
 KzPRWY4m75wf98YY2ZeBtFlDoPDQ1ycUb4iAAzxJ7bbCyaN5cVM5znbxutv8/DxikIVQth
 sr/dK6OeSUNPnAoXx3PU3R3MkAtUF6BsfsEcmRvPwUwjwaEy3Q7V3zAh+W7WTWOYNJqSKI
 EJxFoWjkGNZQmTrSBf4MZt9vnzBg/fGeG7osVmYa/7eYDO+W35bnZIoDQ4Um8E1uZ+AmVM
 YxVrGZ1bdbUI3HlvHFZg7ElQOXG5+3wyHXZ54afJ4CJYXtQ12TsvvRjK6EDSQw==
Reply-To: yukuai@fygo.io
Cc: <linux-kernel@vger.kernel.org>
Date: Sun, 12 Jul 2026 00:39:32 +0800
Received: from [192.168.1.104] ([39.182.0.144]) by smtp.larksuite.com with ESMTPS; Sat, 11 Jul 2026 16:39:35 +0000
Content-Type: text/plain; charset=UTF-8
To: "Chen Cheng" <chencheng@fnnas.com>, <linux-raid@vger.kernel.org>, 
	<yukuai@fygo.io>
Message-Id: <d0e559c0-cd0b-44b5-9d16-dda94bcd5516@fygo.io>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Lms-Return-Path: <lba+26a5271c8+225890+vger.kernel.org+yukuai@fygo.io>
X-Original-From: yu kuai <yukuai@fygo.io>
From: "yu kuai" <yukuai@fygo.io>
Subject: Re: [PATCH v3] md/raid5: fix reshape deadlock while failed devices more than max degraded
In-Reply-To: <20260624075824.2601110-1-chencheng@fnnas.com>
User-Agent: Mozilla Thunderbird
References: <20260624075824.2601110-1-chencheng@fnnas.com>

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
Reviewed-by: Yu Kuai <yukuai@fygo.io>

--=20
Thanks,
Kuai
