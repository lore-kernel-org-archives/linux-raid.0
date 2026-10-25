Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.214.178
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792931928;
	b=Dgb4gi6YLxloUkL7ntJeAi/khJIm0+/ArzOP0vIAdooY+crz6LijooEJem2FszuEeKn2
	 A03HHkPqQQcWykoUVVr7CbJHhZCC4Nu3wAX0lgB2wDWGsyWmXR7PodlUfQtzaPyWKnMRF
	 y8KPYgAumcHhjvWIbSnJz+pNpXQg2jV8bPSxQdGgTlPeE8qwzidJ2t4iEHQNwQRQ95m1c
	 eIeHYqLNodwMsk0/jHH9BTXr7QZUmapnlil6PuJb0JscQ0hNpatpXToPqpN0fleQPpz4a
	 nNZij3yE8n42bZYinlPKnLio2nsKYtlXmIp3/t5X2QFizAD7qamCnk98gF4XCm04Y7g==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792931928;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:From:Date:X-Gm-Features:Message-ID:Subject:To:Cc:
	 Content-Type;
	bh=ifIa5BWnf8laepgAGnQECywu1F41hu5JMjyB1fMNjtc=;
	b=sIiDsU7BZFpbRPkGVGI1l24cqOd/9GGW0qAuthQMayc6lVrJNrsBm47rzfO3RZiEJqZM
	 b3OkAvIxTKClDj/eTAgYjpbH5Iqox+Prt/UPSSnVyA4r8HLFFt1KcqOqR8Yzt5uQDWsfK
	 Pn7niyy2Gimr3KhWYExWbCtUPU5w5NxtPCIPFK32Tp62aTfRoQbJ0mDGIjyPLIyNCiRM4
	 gsunUa/aief+1eTEq5oOZ9ESdGral2rB5uWy5z4rvwSNt++i/+VOPaSs4NwqyogxdDmOq
	 IWETFVfrUmu5In0zhdhSATmxlsWMSShs2DNlP4jBaJENQeUO6KV1nHnU+C6UCrr/mng==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=iOtqb047;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.214.178
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E9E2606A31B
	for <linux-raid@vger.kernel.org>; Sun, 25 Oct 2026 12:38:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2E9E2606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=iOtqb047
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-2e8f2c3ad6bso13716215ad.1
        for <linux-raid@vger.kernel.org>; Sun, 25 Oct 2026 05:38:48 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792931927; cv=none;
        d=google.com; s=arc-20260327;
        b=MyWk0DuG/w+MZFXJWqQPuJgUfDs91rUKc41r84PG/6AtQRewpQKQYOrtms+9eVwWse
         CM8Q09rI7+NJpBKjum6EvCen9srxwauLCHR1qV8eFqj0QFAUMhPa9gSpD2RsDlzIiEwe
         JWID7xtgPvboJ0YR64k8EGAikta+KzKyNbFmZVNRW1ECU8yGUvr3oM/IrieJhj/0sb8G
         Spg3gB5/VYLZ5bs0oGibfQ0N0SbHi7FF+6IPoPhKyE35hcx3bk4ZXCZ+DwAEr8SakcO3
         r48CF11RZ2ye4KgTwTTfMEwy/q6efk2CW4XXu5AWEIER2PVTfiCbdwaZEMey0vPjGxHe
         iveA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=ifIa5BWnf8laepgAGnQECywu1F41hu5JMjyB1fMNjtc=;
        fh=cjnwvfwGl5chFw7ptyWIabkArt+2LSRPsFHdwA3gpeE=;
        b=gT35tLOs7nn0W5hd99NewDZhTHKByIxTN1NvM+CZnjlYYRgcRmgJG9L3Lb1k62U4eV
         FnMzhYxE96QeeZ+xLHfnIXYukSfb1CwhxdaDx/e5/gPWmz4KJFEML1Po9NgylztLS3Ew
         kbJWCgwcKjjiTGQyaAA/07xDRM6IYrZYqQooPmJX2n+AQV2qgf+N8+39cMLx5NjRcMGi
         Ow41l3LJ8NkbLnvvs5yluxc0v0zovpvqe84YrC3dBa8R/ahyBe3l/04AZSAvranzCrkf
         cQSToSk9C/Ozc5qo2tVcLUtA6jv00OF99ZQRCt3o200lVx3lDOIfQEsKZi1b5j/rVqKe
         PEEQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792931927; x=1793536727; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:mime-version:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=ifIa5BWnf8laepgAGnQECywu1F41hu5JMjyB1fMNjtc=;
        b=iOtqb047pnEUjxXecpH7QYAAr+0xFD5CcDSyHwjG3/WU1su2+31417TQX0mo173lXz
         IJ2GtlWfHIjw5XYazrF54FlBJivDQWD+a6tIVaNJ5ZIG8Y8lPZNbezvVVNAcKsmQjLao
         +5Kc2ezbXmfXt6ODeB67Z4TDljlwl6/7bF4DLWTZwYK079kp68HGtW3/PYrMGZlpIbOC
         6Hxs7U8Nh9DJmBBFSHf4PghnVjo6J1znjCoHBA68pzOc/LYcVV2xZ/AhhpEwIkrdFmj4
         eOzcraHDpl8Mcd92gD6TrWI+9nsRqXjK+qprUOrsNyxLf4H6cMXQTFmu0AHqGmzmM/7z
         WVUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792931927; x=1793536727;
        h=content-type:cc:to:subject:message-id:date:from:mime-version
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=ifIa5BWnf8laepgAGnQECywu1F41hu5JMjyB1fMNjtc=;
        b=LDePrf8Z7sh50qY9/06wocfVkU5HeKdu80PD0zvug3MaIocgaApkgM4c3f2diwOkhB
         gHntACSvnhTWmfHH1vZ5EvmxQ2reQIoc8Cy6RghXpiu4ySDoY0gpsVXmbHexF/peRZZo
         Jhtk7y4JUlXpuDx53thU037VmGnLup58cyC1cX8Q4ZFw/fE+SwrIkoCjeGSC3VWLGNtz
         /K2tlJ0ikHcL+1hllc0EAgD4ulekNZ5I6fc43IwbdQNbqe1QnqVH06taAnqmVQZylqmQ
         Ose1m6iP8zkN1q4n5ErVkItwzQJh2CSs65AoHhEZ8KsDckZyKYjGMJH19xDJdwW2Bps/
         eB8A==
X-Forwarded-Encrypted: i=1; AKwUvBw3FssEguy5932LkLWS8RTLpn+w5h8yKRDMEYNhjakKe7YQdF67w++lfyX/UGAlGw8O1cy4QF/etIIN@vger.kernel.org
X-Gm-Message-State: AFq9FYJVXFa3W5HYJbDOJiD+VSDd/A4VyUxJTqpge3ovrmbcyqHWdpkx
	rmNSVTrwtCm0czNMFn3itb9o5VAO3R0tq5vvKg8LRDlCX9C+/6V+bgGGzESrXlIZ0rlMO79qD28
	yOKV03l/gPIdOQv+0sQL3VWSQ1NGQ+ls=
X-Gm-Gg: AYBFou2XKcrHNA9WSQkYTl2WM/pyr+jwk2GbN9Fg3rPgbUiTABVHh9w/SUoKoDHAicG
	HzddyySEFUc51CIs6vnD5JcvX8+verJeLuDuTpSNRK1ek0lfwNjAKdWwzcrB9ecF1tXqpZamgYo
	T++aGNNVx/f9jwaFCgp6mnK92UyKgHaPdLmmJzc2yXTWxut9kfaAKP/OUgrpqkyaU1o4cODBquk
	NJph0nt3yi5n3C9MVe/sJmtRfLky5m9oNHn6O2DN+ZLhqwTw1ZTXHg6C02PQA/OLYZUaLzIg1IK
	Ua4LVuRIzz5Es9lby4bZyYnhCREGg5ay7IpobBmZ3l8VYWLu+fhhYG7/l8WbsukZw5nVeInN2Rq
	TQA6+mZA14re0arlVyd1LEH37cTLMuep9fqd7BI4=
X-Received: by 2002:a17:903:1103:b0:2e8:3e5d:b2b7 with SMTP id
 d9443c01a7336-2ea9c8754e2mr34279705ad.40.1792931927515; Sun, 25 Oct 2026
 05:38:47 -0700 (PDT)
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Post: <mailto:linux-raid@vger.kernel.org>
List-Help: <mailto:linux-raid+help@vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-raid+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
From: Konstantin Nikiforov <helllamer@gmail.com>
Date: Sun, 25 Oct 2026 15:38:36 +0300
X-Gm-Features: AclHuK-zJVIt5pMq4aEG8YbVUe1pdfb3ZT8Uy3v4AWHcgp8mQbjuBakU33gJh-A
Message-ID: <CAO96y0V6oncv54ihXnHfJMYiG_QAQ-NM8BOdqPDXKL8r8-kR9Q@mail.gmail.com>
Subject: [REGRESSION] md/raid5: discards on an array of non-TRIM HDDs now fail
 with BLK_STS_NOTSUPP; bcache counts them as backing-device errors and stops
 the device
To: linux-bcache@vger.kernel.org, linux-raid@vger.kernel.org
Cc: "wale.zhang.ftd@gmail.com" <wale.zhang.ftd@gmail.com>, kent.overstreet@linux.dev, colyli@fygo.io, 
	"song@kernel.org" <song@kernel.org>, yukuai@fygo.io, regressions@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

#regzbot introduced: 90573092673c

Hi,

since upgrading from 7.1.8 to 7.2.11 a machine with root on
LVM -> bcache -> md raid5 (three SATA HDDs without TRIM) loses its root
device a few minutes after boot. The same stack ran on 7.1.x without
any bcache backing-device errors.

Storage stack
-------------
  3x ST1000DM010-2EP102 (no TRIM; discard_max_hw_bytes = 0)
   -> md126: raid5, 3 devices, 512K chunk, metadata 1.2
   -> bcache0: md126 as backing device, cache set detached
      (also reproduced while an NVMe cache was attached)
   -> LVM vgpcrd5
   -> btrfs (/usr, /var, /opt; mounted without any discard option)
      + ext4 (/, /home)

Kernel: 7.2.11-arch1-1 (Arch Linux), mdadm 4.6, bcache-tools 1.1

Symptoms
--------
Every boot, starting ~3 minutes after mount, dmesg fills with:

  bcache: bch_count_backing_io_errors() md126: IO error on backing
device, unrecoverable

in bursts of up to ~35 lines 2 ms apart. Per boot I counted 11, 17, 22
and 63 of them. bcache's io_error_limit is 64, so once a boot crosses it
bch_cached_dev_error() stops bcache0 and root, /usr, /var and /home
disappear. No I/O errors are logged by libata, sd or md; all three
members are healthy (SMART clean, array [UUU], no rebuild).

Analysis
--------
Since 90573092673c ("md/raid5: validate discard support at request
time", v7.2-rc1) raid5_set_limits() unconditionally sets

  lim.max_hw_discard_sectors = UINT_MAX;

and records member support in conf->raid5_discard_unsupported. On this
array sysfs now shows:

  /sys/block/md126/queue/discard_max_hw_bytes: 2199023255040
  /sys/block/md126/queue/discard_max_bytes:    2199023255040
  /sys/block/md126/queue/discard_granularity:  0
  /sys/block/sd[abc]/queue/discard_max_hw_bytes: 0
  (md127, a raid1 on the same disks, still shows 0 for all of these)

Two upper layers react to the advertised discard support:

1. btrfs enables discard=async by default because the device advertises
   discard (mount shows "ssd,discard=async" although nothing in fstab
   asks for it).

2. bcache forwards discards to the backing device whenever
   bdev_max_discard_sectors(dc->bdev) is non-zero (cached_dev_write()
   and detached_dev_do_request()). Before 7.2 that was 0 for this array
   and bcache completed the discards itself.

raid5_discard_limits() then completes every such bio with
BLK_STS_NOTSUPP. bcache's backing_request_endio() treats any non-zero
bi_status as a media error and calls bch_count_backing_io_errors(), so
each discard brings the backing device one step closer to being stopped.
With 64 small deletions on the btrfs volume a root filesystem on
raid5+bcache is gone.

The granularity is also inconsistent: discard_granularity is 0 while
discard_max_hw_bytes is non-zero, so writing any non-zero value to
discard_max_bytes fails with EINVAL (only 0 is accepted).

Related changes I found:
- efdffeb6d491 ("md: skip discard on unsupported member devices", 7.3)
  fixes the same bcache symptom for raid0/raid10 via
  md_submit_discard_bio(), but raid5 does not use that helper and still
  returns BLK_STS_NOTSUPP in current mainline (raid5_discard_limits()).
- 85764f475f3b ("md/raid5: complete discard bios while reshape is
  active") addresses a different fallout of the same commit (hang during
  reshape).

I have not found a report for this raid5 + bcache case on lore.

Possible fixes (either side would do):
- md/raid5: when conf->raid5_discard_unsupported is set, complete the
  bio successfully (discard is advisory) instead of BLK_STS_NOTSUPP, or
  do not advertise max_hw_discard_sectors in that case, as before 7.2.
- bcache: do not count BLK_STS_NOTSUPP (or failed REQ_OP_DISCARD) in
  bch_count_backing_io_errors(), the same way REQ_RAHEAD failures are
  already ignored.

Workaround in use
-----------------
A udev rule writing 0 to /sys/block/md126/queue/discard_max_bytes and
/sys/block/bcache0/queue/discard_max_bytes (also inside the initramfs),
plus "nodiscard" on the btrfs mounts. With that, io_errors stays at 0.

I can test patches on this machine.

Regards,
Konstantin Nikiforov
Claude Fable 5.1
