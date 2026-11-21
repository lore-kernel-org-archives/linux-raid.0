Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.218.48
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795296081;
	b=TkFtRX4zqg87QOz1JrSySicHyFWEf2bBIaU5K1UlEB6x9FKZZN9mgCmGNzLj0nI0P6GN
	 YDH46LhQ7b8Y5/MDsIxiUSSal23jiihtW8lPCM/GKLsQJEXXFd2qbjlEsVI9ffoC30/S2
	 CiCWeypPefa46imgUbFqCabWf77SldyicriqONzBKumD2YQSq4HedFdALhr45UPIESlwS
	 tWkW4qq2qQIBIuUmFsZTZns95T6B+PQ1S0gZOsooP2znG6B8Z+qkkzgTleSnvYyRQUpJc
	 CDOvv587JB1Ps1Gy1Ye0hHoDAyBXq+Rl4BhjFcsSDj+f6bgSKg7myilXfxQ4YRN8FXQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795296081;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:Date:Message-ID;
	bh=O3ljys2G/dfGrzQSHlcDxa7rlNuO9sIfulWEdwLNsJ0=;
	b=EUACn8zcMBCjSUSHBUg2lLlOeBQdaLib13JKWif8CkoIDxQOnddi8p1DD5JAMx6mv+yQ
	 suVmm/VLXgY5HW97CJBfX75BDvnu5IOQuxUZeJnZ0vgb5kH44NfcJRvuiwx0JH7miPuVw
	 +SUCF5p8E6N4GGc1VMO46CHmcxx0C0bZK7jc4Z6ptrRT+ZyXPZd/Klyinq6oEQaQW2H8c
	 Qn3y7WOoERHBeMhRZq0r0erPU8JGnOfGO80dNIHQ9poKlQ7NX37HbGJ9ddZwuy00Ihn7h
	 vA/Lg6FuAfFUNOZsQ4qSHE5AT/aO6vAaXllV6m5ucWgfINFovOxpD61SQGsIVz71AlA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=i8Rz2RMp;
	arc=none smtp.remote-ip=209.85.218.48
Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1B49606A332
	for <linux-raid@vger.kernel.org>; Sat, 21 Nov 2026 21:21:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E1B49606A332
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=i8Rz2RMp
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-c50e26763a4so381111966b.1
        for <linux-raid@vger.kernel.org>; Sat, 21 Nov 2026 13:21:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795296079; x=1795900879; darn=vger.kernel.org;
        h=message-id:date:content-transfer-encoding:content-type:mime-version
         :references:in-reply-to:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=O3ljys2G/dfGrzQSHlcDxa7rlNuO9sIfulWEdwLNsJ0=;
        b=i8Rz2RMpPmkXYItSIndpWJR63ShbcEOT18h3HDALB8+aTuOXp4xTJl0bXxP5lQ8Su3
         E382aOfjHM96onbffE4BozXFmdo5gHP3RvxEg5KXM33RJL/vSmFp16Wtjd8BBedvHhgW
         1iVU/K1qLjSptz5Yfltsg+Pudxm/+TbBWQOFPx+tVxAQhS8PMrW6XYqtk242qjuUvHGp
         qnpLBWi5bevQxy9wxEdfLIwsD/K87xZHuH9/1TudVpGLrDLz6Ir8Zzo5Fed3UlYCQpBu
         +dSqoOWTHFtfYm9IpDMTtsHZKW9o8LuBFQHc4q0zR4lsKsUGfdVGttxQSb2z0MremoYk
         he4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795296079; x=1795900879;
        h=message-id:date:content-transfer-encoding:content-type:mime-version
         :references:in-reply-to:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=O3ljys2G/dfGrzQSHlcDxa7rlNuO9sIfulWEdwLNsJ0=;
        b=lrTop5sWpz4Yu5jFLe4gnpE0/CoEsDhyO7jzSTMnM0VTB8GPhc0Fr7z/G+1om4t8cw
         ttuecNMg1l6BgIUL5X2PkvXeNpbOrvd7NM7KxTNOEJOt+N6UoUym6dIlvtHOMgILQDEw
         IbgKMKfZwjQilWm2xBS1EDyXk765NJ14gcLtBvYjjaIkIcZpe5wV6f8zsOO8qu09ZVNX
         FQ87sRq6Plqh2w4toRAjcpmsYGRbF+lqTuStWFDcN05XETU2hst84wO/cAzPW5UUyPDE
         V9oITHPiY4JnqUCluN9SY/uuqcAeIZzFWDaP4Z5Cp+JLr0+uEP9Fv4OHcl4z8wuIBBYF
         FwNw==
X-Gm-Message-State: APuU4Z+oTOSgl2xMksWq/qNcfBGNyk43RlQY3plIEpFBpi+Hfq9YGCU1
	V0Y7yf4vVsusQEGTp5ZUao7cR6PevxfDKIIxYMKrW0lrpTjWfv++A70mxiJbi1w62J19Pg==
X-Gm-Gg: AZFdTZd/IsMJaovqPFbsF7NKG7sHj0/3ypQtpnnKjtx/BfSlCcd4dH6VWMBZnhzta52
	4r/hmTzqwa0s7TS5WTWGLtdPSim9n9vVuJI5zS084Play94prhkV5ijR0jXDEIM8xHYI4+U93Z9
	nKqtI0YqchzeMOxrMeJM6g9W5uS+ohZo77rCJWlyFqvUVQSXbwM1nic4raEB7/nOWqTZvdZ2KYO
	3FxV8XzAGCBjvYnQ8DtoclHQdWsAOor6rgNm+GeaMUYfeRh7KKfvMonpec06bs+5nCyDLYW00Ys
	Y1+cTIFcgxseugqc/jdIr4RRqDf9yeEbD26Za4FhbcN4fZ2YqsePJ/EslWR3jTyZfqyAOo1Aawc
	aFzgzvSlrItEMmlr8KL7o3aYlYq2xyzY8oKzztZPuCfoIRKp0y6AogTHzw4+Ts4y9ALZJh7MMf+
	+oBYDEB1rfW0+ckFw45FWBE1RB8U4cjoZ/M1BmfxoEO1fba5jAjD7PnG47mg6iFlHSVMt6lmENi
	0e/RRjIU9MkQ3bvya/Lx1VglawS31WS/F5aIwu2FXQpNgZQivLxhR0C2hXGygL67OZWyGqy9+pd
	BEiEDvz3M9SMBpuYerZFFLNn3z0=
X-Received: by 2002:a17:906:7f01:b0:c4d:2867:281c with SMTP id a640c23a62f3a-c513a89466dmr477367466b.1.1795296079086;
        Sat, 21 Nov 2026 13:21:19 -0800 (PST)
Received: from [172.17.0.1] ([2a0c:db40:0:80df::2])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c513ad010a6sm243362266b.7.2026.11.21.13.21.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 21 Nov 2026 13:21:17 -0800 (PST)
From: Konstantin Nikiforov <helllamer@gmail.com>
To: linux-raid@vger.kernel.org
Cc: linux-bcache@vger.kernel.org, regressions@lists.linux.dev,
 linux-kernel@vger.kernel.org, stable@vger.kernel.org,
 Yu Kuai <yukuai@fygo.io>, Song Liu <song@kernel.org>,
 Coly Li <colyli@fygo.io>, Kent Overstreet <kent.overstreet@linux.dev>,
 magiclinan@didiglobal.com, xiao@kernel.org
Subject: Re: [PATCH] md/raid5: complete unsupported discards successfully
In-Reply-To: <179299857972.12222.2729359466842183358@gmail.com>
References:
 <CAO96y0V6oncv54ihXnHfJMYiG_QAQ-NM8BOdqPDXKL8r8-kR9Q@mail.gmail.com>
 <179299857972.12222.2729359466842183358@gmail.com>
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Post: <mailto:linux-raid@vger.kernel.org>
List-Help: <mailto:linux-raid+help@vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-raid+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Sun, 22 Nov 2026 00:21:15 +0300
Message-ID: <179529607529.5.3302391929789139470@gmail.com>

Hi Kuai,

I built and tested md-7.5 with b964c9240a37 on the machine from the
regression report.  The reproducer passes and the machine runs without
backing-device errors.

Tested tree
-----------
md-7.5 tip c526b7cd32f7, based on v7.4-rc2, with b964c9240a37 applied.
Built as 7.4.0-rc2-md75+ (x86_64, Arch config, gcc 16.2.1) and booted
on the affected machine.

Reproducer
----------
Three 256M loop files -> raid5 (64K chunk, metadata 1.2) -> bcache
backing device.  devices_handle_discard_safely is left at its default
(N), so the array takes the raid5_discard_limits() path changed by the
patch.

  md125: discard_max_bytes=2199023255040, discard_granularity=131072
  blkdiscard 8M on md125: exit 0
  bcache1 over md125: discard_max_bytes=2199023255040
  4x blkdiscard 8M on bcache1: io_errors=0, no
  bch_count_backing_io_errors lines in dmesg

The same reproducer gave io_errors=4 with the unpatched 7.2.11 module.
With the patched 7.2.11 module, and now with this kernel, it stays 0.

Affected machine
----------------
3x ST1000DM010 (no TRIM) -> md126 raid5 -> bcache0 (NVMe cache
attached, writethrough) -> LVM -> ext4/btrfs root.

Since booting 7.4.0-rc2-md75+, md126 and md127 are [UUU],
/sys/block/bcache0/bcache/io_errors is 0, and dmesg has no
bch_count_backing_io_errors or md/bcache I/O errors.

Caveat: the local workaround (udev rule zeroing discard_max_bytes on
md*/bcache*, plus nodiscard mounts) is still in the initramfs, so the
HDD-backed array has not received discards on this boot.  The loop
reproducer is what exercises the changed code path.  I can do a
no-workaround boot and a scratch-LV discard test if you want that
before this goes to stable.

Note: 7.2.y is EOL (7.2.15, 2026-11-01), so the "Cc: stable # 7.2" is
stale; v7.3.5 still has the old code, so the fix is needed in 7.3.y
once this reaches mainline.

Tested-by: Konstantin Nikiforov <helllamer@gmail.com>

#regzbot fix: md/raid5: complete unsupported discards successfully

Thanks,
Konstantin
DeepSeek Harness 0.2.2-rc.5; model: deepseek-flash
