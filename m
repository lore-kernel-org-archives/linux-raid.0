Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.127.231.60
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792952212;
	b=gXMJLqlBtpGnNDRmqujdWMjY8tM2a7rsfQKYps2Y8RnfDVplC39b8Jp9Slgk3b+N1OU1
	 A3f7B0rhJCsjcR/v8AIRak2Z7SHxVChQwKQEZgYo03XgP+XMf3p5w33QCGJMIHe3b51fT
	 lCQYqzoOyTFle9swGY0sYvpe+llpnsxTm/xjVvoMZDc5RbjzyXXqPvOS2FwlwHL5sbWdK
	 Eu2t29MqO19cfEdp+EEs43qS12/VrknBTKiVJVibxVnsdihslj/u346pcXQ4IPnWYWINJ
	 IJCvQUGLekzx59gwl9V5+H/MkMAeEALO9+du6bYsb99mLbdDKN4AAI9EhGvVgVk94hA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792952212;
	h=DMARC-Filter:DKIM-Signature:User-Agent:Cc:Mime-Version:In-Reply-To:
	 Date:Message-Id:X-Original-From:Received:To:From:Subject:References:
	 X-Lms-Return-Path:Reply-To:Content-Transfer-Encoding:Content-Type;
	bh=/5lwkv3QUM5YvGs1kBijpp/6wHjZlSgrb379+9vBQcE=;
	b=W3rYSaCMPfmyklKqn4LkTsawRbCCd36YGL0BAmVQ77P6/7msynN1khKGM8lIYSd6rG5Y
	 jSqj+CbNHkG3hSrL5d4vd1RhZssBs73Qt9psLcNtXMqt2T5dMiVwVOrxQaoMw7++iXpKA
	 zanchEI2Q9kA7Srt05scjBUVk7mMcK42cWeVVtZX4huukReDZzZBKuIxATaDlZYidvOc0
	 qDHI0vpa24g2TiFiLr2lEkJpv0F5KwESGN4lps62ValvE5sg1KKC0B0TQbaTarofbCf3R
	 DBJ1bd6fJ6LPSRuCGU8PNLG3gKbhVISZmKgEBvE3gEJGN7Sr3bbcnKiuTcR/N26Yquw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=fygo.io;
	spf=pass smtp.mailfrom=fygo.io;
	dkim=pass header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.a=rsa-sha256 header.s=s1 header.b=QuBD33Uo;
	arc=none smtp.remote-ip=209.127.231.60
Received: from va-2-60.ptr.blmpb.com (va-2-60.ptr.blmpb.com [209.127.231.60])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1FB8606A31A
	for <linux-raid@vger.kernel.org>; Sun, 25 Oct 2026 18:16:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E1FB8606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fygo.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.a=rsa-sha256 header.s=s1 header.b=QuBD33Uo
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fygo-io.20200929.dkim.larksuite.com; t=1792952204;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=/5lwkv3QUM5YvGs1kBijpp/6wHjZlSgrb379+9vBQcE=;
 b=QuBD33UoJ0XNrNXlulx7JRtaPsQ4qoqOqO8xJleODGAQi7PudADFCXzp3QV1GvRqWJZXf4
 pxOcuxVcAZoEqvS1aKDUfAVE86SFcvCiSgUpuUOyqAsEBtlCoRdRvRhqdnBIdqiydKXIyn
 5pT4JKYpfOjFId8YEuQqrQ3IkOOSdxRdFp9dSu7vJ2ARzG5LiPAxor+eID8RdsDUlVTNvm
 VxCCjMymqju3+OIX0xPBCl+UZW7C9RoL9wNqpneUkbqiZRpKfPqAYUNrAApqdBPxgm3S11
 pa/P4F00FcJhINf1B0xV0woy8m4g/TJNM6DCY3Ez7yQILu/DeCXaHo6qi3Iy4Q==
User-Agent: Mozilla Thunderbird
Cc: "wale.zhang.ftd@gmail.com" <wale.zhang.ftd@gmail.com>, 
	<kent.overstreet@linux.dev>, <colyli@fygo.io>, 
	"song@kernel.org" <song@kernel.org>, <regressions@lists.linux.dev>
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Post: <mailto:linux-raid@vger.kernel.org>
List-Help: <mailto:linux-raid+help@vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-raid+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
In-Reply-To: <CAO96y0V6oncv54ihXnHfJMYiG_QAQ-NM8BOdqPDXKL8r8-kR9Q@mail.gmail.com>
Date: Mon, 26 Oct 2026 02:16:39 +0800
Message-Id: <b6685fc8-0580-4118-ba65-a7d319c08bcf@fygo.io>
X-Original-From: yu kuai <yukuai@fygo.io>
Received: from [192.168.1.104] ([39.182.0.25]) by smtp.larksuite.com with ESMTPS; Sun, 25 Oct 2026 18:16:43 +0000
To: "Konstantin Nikiforov" <helllamer@gmail.com>, 
	<linux-bcache@vger.kernel.org>, <linux-raid@vger.kernel.org>, 
	"yu kuai" <yukuai@fygo.io>
From: "yu kuai" <yukuai@fygo.io>
Subject: Re: [REGRESSION] md/raid5: discards on an array of non-TRIM HDDs now fail with BLK_STS_NOTSUPP; bcache counts them as backing-device errors and stops the device
References: <CAO96y0V6oncv54ihXnHfJMYiG_QAQ-NM8BOdqPDXKL8r8-kR9Q@mail.gmail.com>
X-Lms-Return-Path: <lba+26ade478b+8e7a4e+vger.kernel.org+yukuai@fygo.io>
Reply-To: yukuai@fygo.io
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8

Hi,

=E5=9C=A8 2026/10/25 20:38, Konstantin Nikiforov =E5=86=99=E9=81=93:
> #regzbot introduced: 90573092673c
>
> Hi,
>
> since upgrading from 7.1.8 to 7.2.11 a machine with root on
> LVM -> bcache -> md raid5 (three SATA HDDs without TRIM) loses its root
> device a few minutes after boot. The same stack ran on 7.1.x without
> any bcache backing-device errors.
>
> Storage stack
> -------------
>    3x ST1000DM010-2EP102 (no TRIM; discard_max_hw_bytes =3D 0)
>     -> md126: raid5, 3 devices, 512K chunk, metadata 1.2
>     -> bcache0: md126 as backing device, cache set detached
>        (also reproduced while an NVMe cache was attached)
>     -> LVM vgpcrd5
>     -> btrfs (/usr, /var, /opt; mounted without any discard option)
>        + ext4 (/, /home)
>
> Kernel: 7.2.11-arch1-1 (Arch Linux), mdadm 4.6, bcache-tools 1.1
>
> Symptoms
> --------
> Every boot, starting ~3 minutes after mount, dmesg fills with:
>
>    bcache: bch_count_backing_io_errors() md126: IO error on backing
> device, unrecoverable
>
> in bursts of up to ~35 lines 2 ms apart. Per boot I counted 11, 17, 22
> and 63 of them. bcache's io_error_limit is 64, so once a boot crosses it
> bch_cached_dev_error() stops bcache0 and root, /usr, /var and /home
> disappear. No I/O errors are logged by libata, sd or md; all three
> members are healthy (SMART clean, array [UUU], no rebuild).
>
> Analysis
> --------
> Since 90573092673c ("md/raid5: validate discard support at request
> time", v7.2-rc1) raid5_set_limits() unconditionally sets
>
>    lim.max_hw_discard_sectors =3D UINT_MAX;
>
> and records member support in conf->raid5_discard_unsupported. On this
> array sysfs now shows:
>
>    /sys/block/md126/queue/discard_max_hw_bytes: 2199023255040
>    /sys/block/md126/queue/discard_max_bytes:    2199023255040
>    /sys/block/md126/queue/discard_granularity:  0
>    /sys/block/sd[abc]/queue/discard_max_hw_bytes: 0
>    (md127, a raid1 on the same disks, still shows 0 for all of these)
>
> Two upper layers react to the advertised discard support:
>
> 1. btrfs enables discard=3Dasync by default because the device advertises
>     discard (mount shows "ssd,discard=3Dasync" although nothing in fstab
>     asks for it).
>
> 2. bcache forwards discards to the backing device whenever
>     bdev_max_discard_sectors(dc->bdev) is non-zero (cached_dev_write()
>     and detached_dev_do_request()). Before 7.2 that was 0 for this array
>     and bcache completed the discards itself.
>
> raid5_discard_limits() then completes every such bio with
> BLK_STS_NOTSUPP. bcache's backing_request_endio() treats any non-zero
> bi_status as a media error and calls bch_count_backing_io_errors(), so
> each discard brings the backing device one step closer to being stopped.
> With 64 small deletions on the btrfs volume a root filesystem on
> raid5+bcache is gone.
>
> The granularity is also inconsistent: discard_granularity is 0 while
> discard_max_hw_bytes is non-zero, so writing any non-zero value to
> discard_max_bytes fails with EINVAL (only 0 is accepted).
>
> Related changes I found:
> - efdffeb6d491 ("md: skip discard on unsupported member devices", 7.3)
>    fixes the same bcache symptom for raid0/raid10 via
>    md_submit_discard_bio(), but raid5 does not use that helper and still
>    returns BLK_STS_NOTSUPP in current mainline (raid5_discard_limits()).
> - 85764f475f3b ("md/raid5: complete discard bios while reshape is
>    active") addresses a different fallout of the same commit (hang during
>    reshape).
>
> I have not found a report for this raid5 + bcache case on lore.
>
> Possible fixes (either side would do):
> - md/raid5: when conf->raid5_discard_unsupported is set, complete the
>    bio successfully (discard is advisory) instead of BLK_STS_NOTSUPP, or
>    do not advertise max_hw_discard_sectors in that case, as before 7.2.

I think it's fine to complete the bio successfully in this case, the same
as the old code did. I can cook a patch, however, if you like, feel free to
test and send a patch by yourself :)

> - bcache: do not count BLK_STS_NOTSUPP (or failed REQ_OP_DISCARD) in
>    bch_count_backing_io_errors(), the same way REQ_RAHEAD failures are
>    already ignored.
>
> Workaround in use
> -----------------
> A udev rule writing 0 to /sys/block/md126/queue/discard_max_bytes and
> /sys/block/bcache0/queue/discard_max_bytes (also inside the initramfs),
> plus "nodiscard" on the btrfs mounts. With that, io_errors stays at 0.
>
> I can test patches on this machine.
>
> Regards,
> Konstantin Nikiforov
> Claude Fable 5.1

--=20
Thanks,
Kuai
