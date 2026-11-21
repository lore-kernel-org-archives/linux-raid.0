Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.127.231.41
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795233572;
	b=Tf2LP/TOYNaKlgCPcL4dxdRR49IbcaFMa3+3h0vvNfSb9qAgBO7pGS/+cEGpjbauWRMm
	 ABm69AEWmeRVpvhVrPYlHNVKv3HNmgfaOeWW4SFfJ68lBrNnBhGHm56uP5jkp2xaDv+U6
	 XV7fCJzCm6eoMhH+E/lmIfUKuDkezjPS70xy0EEat9TMr/dbNH9BqeakuOo2/Z5BLib7q
	 aO+fHvvAPVaTmYesHrvLIIKbNZ2K6fZcESN1ah9EKWqs0ayAxeHQts1aezDRHNlg1QI0p
	 R0TfX17MlU/e7qPJCCSrxJbMJLNGhdziHadeRSuGLjsq2J00+IgSKB1DJ3uQjo+nvoA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795233572;
	h=DMARC-Filter:DKIM-Signature:Subject:Reply-To:From:Date:User-Agent:
	 Mime-Version:X-Original-From:References:Content-Transfer-Encoding:
	 In-Reply-To:X-Lms-Return-Path:To:Cc:Received:Message-Id:Content-Type;
	bh=Ecje+ICZ2y4kOi3FzWBZvMRUmxKj66g4Uste2s+ql6U=;
	b=wvoN85+JhiHGM9tGM/VVCt6Ca46qFB+mvX3UBcY9cTYAwdinsWaIWbKU7UHnEhtY4TJE
	 Hy50rofIMGS1XQXYlHIjpAxUg5f/8yp1aZS5z9o/VnM8I40wtb7QmIfVM/ep8bMgAG53D
	 0qvPtQfCwPyxlC3Zv5XNubeqtnubcF3ts85oiGs65lhULRV+rdRCjdecdAnYvXRMx9iF9
	 gkj9dkhfkJq0Msi0P4g+pVQvFWAPl3aGlfq6vQe13EtvXtq8gNAHdqBkJbRtGC1AcSoHM
	 VAxTNfdm4DEXRImsfjHUpOmvET6VO19yBAHhIaTklwYyL42ija9Roan0Z7WKE1KbGAA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=fygo.io;
	spf=pass smtp.mailfrom=fygo.io;
	dkim=pass header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.a=rsa-sha256 header.s=s1 header.b=WmzBx7wX;
	arc=none smtp.remote-ip=209.127.231.41
Received: from va-2-41.ptr.blmpb.com (va-2-41.ptr.blmpb.com [209.127.231.41])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4CF9606A684
	for <linux-raid@vger.kernel.org>; Sat, 21 Nov 2026 03:59:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C4CF9606A684
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fygo.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.a=rsa-sha256 header.s=s1 header.b=WmzBx7wX
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fygo-io.20200929.dkim.larksuite.com; t=1795233564;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=Ecje+ICZ2y4kOi3FzWBZvMRUmxKj66g4Uste2s+ql6U=;
 b=WmzBx7wXxcoahtCOrfQ9kpQTdmlyTnrTuj5EnU1DR4uhRQDmyx58qA08GhdDOypHNztybW
 qi3h2xW6gVLaEydNTnJ8wTxh1xScjrsFxcukSlUyO3gLOvGDhw/39nkRjx9QKvWuJ/j3Wh
 UjfobUQvswd4b9VbFZb7QPBm4vVChcSokxPWn31OhcI+u/+F972+supTCABBh5MLSMAXq3
 7GYFCkVCJbC7awFjAdthMyx+vGzTyy2r04qjr6Xhgo/d15uPabFxPkQnsBqVsEMV/AanRV
 4+TsTrEpb2q+6LrJSaJsSXrl/uB/4xvsMdW2hjL/kaaBs8k4FZcV0OPu/5+93w==
Subject: Re: [PATCH v2 0/2] md/raid5: fix PPL disk add and replacement removal
Reply-To: yukuai@fygo.io
From: "yu kuai" <yukuai@fygo.io>
Date: Sat, 21 Nov 2026 11:59:19 +0800
User-Agent: Mozilla Thunderbird
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Post: <mailto:linux-raid@vger.kernel.org>
List-Help: <mailto:linux-raid+help@vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-raid+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
X-Original-From: yu kuai <yukuai@fygo.io>
References: <cover.1794555233.git.x-professor@outlook.com>
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <cover.1794555233.git.x-professor@outlook.com>
X-Lms-Return-Path: <lba+26b01171b+e10d50+vger.kernel.org+yukuai@fygo.io>
To: "Yingjie Wang" <x-professor@outlook.com>, "Song Liu" <song@kernel.org>, 
	"yu kuai" <yukuai@fygo.io>
Cc: "Li Nan" <magiclinan@didiglobal.com>, "Xiao Ni" <xiao@kernel.org>, 
	"Artur Paszkiewicz" <artur.paszkiewicz@intel.com>, 
	"linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Received: from [192.168.1.104] ([39.182.0.159]) by smtp.larksuite.com with ESMTPS; Sat, 21 Nov 2026 03:59:22 +0000
Message-Id: <dedbb4e5-3106-4e13-9f05-41d5de79d863@fygo.io>
Content-Type: text/plain; charset=UTF-8

=E5=9C=A8 2026/11/15 15:39, Yingjie Wang =E5=86=99=E9=81=93:

> This is v2 of the two independent PPL disk-transition fixes. The first
> patch is unchanged. The second patch also handles a slot that remains
> assigned above the current array width after a RAID5 shrink.
>
> When a newly added disk fails PPL setup, raid5_add_disk() can publish the
> private disk pointer before the caller rolls back raid_disk. A later
> removal can then free the disk while RAID5 still references it. Patch 1
> prepares the PPL log before publishing the pointer and restores the
> previous state on failure.
>
> Patch 2 keeps the active PPL log attached when an unpromoted replacement
> is removed. It also skips log_modify() when removing an active device fro=
m
> a slot at or above the current raid_disks value. Such a slot has no PPL
> child log after a shrink, but its device pointer still has to be cleared.
>
> Changes in v2:
>
>    * guard the active-device log update with number < conf->raid_disks;
>    * add a shrink test that leaves an extra slot blocked, enables PPL, an=
d
>      compares the v1 and v2 removal results.
>
> The v1 public thread is:
> https://lore.kernel.org/r/cover.1794215128.git.x-professor@outlook.com/
>
> Tested on x86_64 with KASAN, PROVE_LOCKING, DEBUG_ATOMIC_SLEEP, LOCKDEP,
> MD, and RAID456 enabled:
>
>    * per-commit W=3D1 builds for both commits;
>    * failed PPL disk addition, which reaches DONE on the v2 tip;
>    * unpromoted replacement removal, which reaches PASS and DONE on the
>      v2 tip, with tracing observing `ppl_write_stripe()` and a successful
>      return during a subsequent array write;
>    * the shrink comparison, where the sent v1 remains at slot 3 after
>      three remove attempts while v2 removes the slot on the first attempt=
;
>    * empty-header `-EIO` injection while adding a spare, where `slot=3D0`
>      returns an error, leaves the slot unassigned, restores `ppl_size`, a=
nd
>      leaves the degraded array writable.
>
> The runtime tests use native metadata 1.2. IMSM external metadata was not
> run. The empty-header failure uses a dedicated kernel with
> `CONFIG_FAIL_MAKE_REQUEST` enabled; the separate page-allocation `-ENOMEM=
`
> injection was not run.
>
> Yingjie Wang (2):
>    md/raid5: roll back failed PPL disk additions
>    md/raid5: preserve active PPL log when removing a replacement
>
>   drivers/md/raid5-ppl.c | 11 ++++++++++-
>   drivers/md/raid5.c     | 13 +++++++++----
>   2 files changed, 19 insertions(+), 5 deletions(-)
Applied
>
>
> base-commit: 47e1b18f38d74015cb9fd30b5ff2a1eb88e77d31

--=20
Thanks,
Kuai
