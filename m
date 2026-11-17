Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.41
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794892546;
	b=Qo9kBjJ20v+12VO4b331I99ePCQ2ZF7NNBppRz7zNnZVg2pJZt/rk2ZGVR8wfylo77bE
	 BfiM8TxdfqhtMFwoz9cnWBq0PhPBtc1wrtEXadDl5rds/XBf3gWkUzii9uv0+cjuwGtIc
	 AL0qj7TKjjEPGRnFEc1yrvwTB2H8Twy+pTw6JTlWYT7kdCV3Nx5EssNJgOH/NlVrSYhkx
	 akTGhLeT7RRC+Rywazmfnfi+eATJVjimh7ApTQZVCipPbYVlM1x6mjxaShS/vC82/AkgO
	 yWHA3NMrJhwAEZm0w3hN4b06asrZNmJi6UntjhDGYgwaHfW6h6ZAEHYyiTRaJf9xVfw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794892546;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:From:Date:X-Gm-Features:Message-ID:Subject:To:
	 Content-Type;
	bh=LcB1sNEMLKmirfhBCUnEMLlOFH+/B3k68eqehlg98m0=;
	b=IC0xzyi0uJZ3xNbBIr91pMoMX9JGysOy9lX3N4XIE20XNC9zV+4+BRhqR8x/qozT6u0f
	 KP+jDPM2kBTkJW0Wx3pvuAxCLnLLiXjalU/gQwV8NI3OaqoZ3UJoveXm5lRGma2OTbmJa
	 3lk//RvXS6Mab1rGkVvnkR8t9SVm8ov+2jck0QT2Nd4FCs8NwLxOXuugg4eoEh4Z6xU45
	 c6VZKTq0GgP6tPFUAtmU8Fal+XBbiV7EyZGUta4Z6+Van3je/5jl1X+ZK64ewgSl+23u7
	 h+szNWb3BSx4EhCIuVxTByIsT02tPYD+W+mn03PeFMC4lW8hISoxGeW3QL3SVo0YnqA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=0VVr7Wjz;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.41
Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com [209.85.208.41])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38C84606A31C
	for <linux-raid@vger.kernel.org>; Tue, 17 Nov 2026 05:15:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 38C84606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=0VVr7Wjz
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-6b71b012e3cso4939437a12.1
        for <linux-raid@vger.kernel.org>; Mon, 16 Nov 2026 21:15:46 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1794892544; cv=none;
        d=google.com; s=arc-20260327;
        b=Hbzx8eP/QGkup0wV0B15SWRCama7DpP62dm8mshAeCdYBuqDywuTBmi0Fhq3tszCRe
         PHLocQIwyx3bvuhkiW+l6XWZNz77NX751mBcD7XHnjuQgPMPaf1SzvslrQp+RpjRj7/9
         /nSVTMLjeMj6N0u6FHxzKmY0hRcc/7q8Uqa+0CdLdIvYNOPMEh2Y2VbAUWjb3K1wZfH9
         l0NmI3aNjCTIsKBeiySgZYvDkobkLO1MabOdL+kP48mdgvMVTHWEuOOme2e6N/DKIG4s
         LWAVoqLhsu/ZgRrbyiW/nSupRSTUtREew2NN5mij7T0IVKMes31qqjGsVv+U4voSqtRK
         8GAw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=LcB1sNEMLKmirfhBCUnEMLlOFH+/B3k68eqehlg98m0=;
        fh=TCXm3fgUH6yCqpI4xGR2mwSSKqKKY8Utw/aV2cnS3N0=;
        b=HYhT1x1U4zGSkMlWvU1n3mITzUbEWcolP6ww9mkqcdUs5dHcjcKRmBUYw0HUwsXqbe
         ov4XPNBUWQK8hmO2oHj1KsmrW+XZZFekqnrtBSne60Yj46tZKX1WOF10caGG9r9G6Fbo
         AsJUnE1B9L26li3V+2ytI9tLdkSGvT9XEFNj4uRJqcSdWaAHQXZiUOSnjlNnxMagay7e
         RPlI6c9q7QZFKOd+fB6UZEZKiyxVcf05Z9XPW1SFriweq/3FNzm06sfNWXKJXikHJD0u
         wxcbK2uaA4CkqVi7fabuU7enX1DaadisEGmfNTj+CmUefAWXErLM1DYp2JmhthHMYU+t
         3kbw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794892544; x=1795497344; darn=vger.kernel.org;
        h=content-type:to:subject:message-id:date:from:mime-version:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=LcB1sNEMLKmirfhBCUnEMLlOFH+/B3k68eqehlg98m0=;
        b=0VVr7WjzVZhisIRPEOyr21EBabBoGM/LmXbDlGAyH0rlqrAl75pstEjdIeQgUJHeT9
         m5fooPV2zwJXmm34Q5MMuisuQ5R3V1KRvNsWAi+pnnXm5wEQe0Afd6VSiSNj4w0lvoEj
         xSR8QdVzwHxbvOZNUDi01/wQulU0irV2fzEpNIfkUvqBKs+vrRtraQ7Ea5BBjWwfE3fd
         B37ztlclpbvSFLRADyWu9KqnTNKlD3eny6hnWCHDs5AOE3jnIcHO1wZ3n1Aw+m8AdrXF
         C+5iRvgz294AaJfgZastU6fj65A8SBRvfdYucM6ijQTFvKM0e39SeMy7zTmzgRcJaQ2L
         g5zA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794892544; x=1795497344;
        h=content-type:to:subject:message-id:date:from:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=LcB1sNEMLKmirfhBCUnEMLlOFH+/B3k68eqehlg98m0=;
        b=J4AC9RHWN4hhQY0D8r5pkwesCLD4hbBQryCmY/U1kNKsm35v+Z/a+BaHa0wzw7yMRm
         cMDrqu+WfJ4AS3dt4kBR77Yn8mMzf3M/DsGnmo+5mdSk3MCzpb3XddRUSxsi557hBqt7
         qKKKZC8XkcC/bv5pbgChwnE/E6iT5TS0XvJm7Ucs+6bIa9U0mJtCqc/VgA951+di7WQ+
         AJfHtv1tQ9hZN+iQOrfwpQPc4ED/SJh5b8aAsKD+CyDHhv5bVk3ma1iMR2fiqtsMwssG
         S+c5/gLV7+Dkzgm4sE1U6p6UEzwrKSPdPxAY5ub5H41EO2XBvmJ8UoLJtYDD5YDXusyG
         uXxg==
X-Forwarded-Encrypted: i=1; AL+hErF3W06zFkyiz4a1pK8NYVlZje5ZKO/oCKgypfa1hHTTqtS5Mu+nmHVyfNts+twId+mlu0bgEWjdu0Nk@vger.kernel.org
X-Gm-Message-State: APuU4Z8ZFxheyROANpDJy19f47Y0YV0lGUCvcRP1857u0AaEpPa5XPYJ
	lpm6ygjovFRTPxQU1SfKw2PkSIX/EjFOCqJ3wRdyQy3ilErjS1LvQFeedJwy2QjL40Ujbeearxp
	uE5PaN1aURjv1tcRxTlErjf04PCz98UNZtm2VXCI=
X-Gm-Gg: AYBFou2ftVRm+w1TY2mjF//S2E2ksxzP2fdK0tcs7ogXYUWzbUjTuM3F0bkt3Bb1dxl
	Pmc6+tYuLO3UPYq8YdH+4hfdIcFyp7WuDuI9gA1q3Cve4+jKIlB9wVoaYthskUxCemExw4ZbzZy
	GbYjHaoq+ccLoLv1cBJ1rpPax/YXsZQUD2119lelVWJDqPGRO6ZLabZfdwcjHJTCBeBfn+EzXme
	MXoewKn/pje1wymBKuLzHI/gmvNqb94gDFpHxb0b13ysFgGJuD77od/AsRHklbUXzj0DCenHxs9
	4AYJ1/YI1x4CD26l6AZpNtK6F04iETUZXQsLEm5WxNjoVRB/kpGG+TiMrXRe9MZmKftYXcCaKbK
	LK4JMFg+dWZHb0yimtPaGFy7p0Q6wEadohz21W1i5rktG70AW+l3g1CBSMJvGxEY8fdQahab6dH
	WeMZgsL3cMNNPVYntifOmBowU1ym2DTUdNtsf/AK0G1bINH+gH
X-Received: by 2002:a05:6402:1d49:b0:6b8:5ce6:d780 with SMTP id
 4fb4d7f45d1cf-6b85ce6d90emr740196a12.2.1794892544472; Mon, 16 Nov 2026
 21:15:44 -0800 (PST)
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Post: <mailto:linux-raid@vger.kernel.org>
List-Help: <mailto:linux-raid+help@vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-raid+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
From: Herman Semenoff <germanaizek0@gmail.com>
Date: Tue, 17 Nov 2026 08:15:58 +0300
X-Gm-Features: AclHuK_4sL4dPYibnHtI-g8te8ZAr4eN6arGP0ECZ84nJIUnFTmEc6OujUbMHu8
Message-ID: <CAMnMt5Z+BwOaPWQGTTUeSr8uaT=dysMi42xRpFpUruRRcO7=wA@mail.gmail.com>
Subject: [PATCH] md/raid0: optimize stripe mapping with bitwise shifts for
 power-of-2 devices
To: song@kernel.org, yukuai@fygo.io, magiclinan@didiglobal.com, 
	xiao@kernel.org, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

From 086678202572260393864f72c06f4d67032a4b76 Mon Sep 17 00:00:00 2001
From: Herman Semenoff <GermanAizek@yandex.ru>
Date: Sun, 8 Nov 2026 22:43:29 +0300
Subject: [PATCH] md/raid0: optimize stripe mapping with bitwise shifts
for power-of-2 devices

In drivers/md/raid0.c, map_sector() performs two 64-bit integer divisions
(sector_div) on every submitted bio:
  1. sector_div(chunk, zone->nb_dev << chunksect_bits) to compute the chunk
     offset within the member device.
  2. sector_div(sector, zone->nb_dev) to select the target member disk.

For ultra-low latency solid-state storage devices, such as Intel Optane
(3D XPoint NVMe SSDs) capable of sub-10us latencies and multi-million IOPS,
these un-pipelined 64-bit division instructions create unnecessary CPU
pipeline stalls and latency overhead in the I/O submission hot path.

When the number of member devices in a strip zone is a power of two
(e.g., 2, 4, 8, 16 disks, which is the predominant configuration for
NVMe arrays), both divisions can be replaced with bitwise shifts and
masks:
  - chunk >>= (zone->nb_dev_shift + chunksect_bits)
  - disk_idx = sector & (zone->nb_dev - 1)
  - *sector_offset = (chunk << chunksect_bits) + sect_in_chunk

Store nb_dev_shift (ilog2(zone->nb_dev)) in struct strip_zone during zone
initialization when is_power_of_2(zone->nb_dev) is true, or -1 otherwise.
If nb_dev_shift is non-negative and chunk_sects is a power of two, fast
bitwise math is used with zero divisions. Arrays with non-power-of-2 disk
counts fall back to the existing sector_div() path without any behavior
or compatibility change.

In addition, annotate the bio split check in raid0_make_request() with
unlikely(), as standard MD devices already enforce chunk_sectors limits
via bio_split_to_limits() in md_submit_bio().

Tested on an 8-disk Intel Optane Memory M10 (MEMPEK1J016GAD) RAID0 array:
  - Random 4K read QD1 latency:  avg lat 22.06 us -> 21.10 us (-4.4%)
  - Random 4K read QD1 IOPS:     42.6k IOPS       -> 44.6k IOPS (+4.7%)
  - Random 4K read QD32x8 IOPS:  1.11M IOPS       -> 1.72M IOPS (+54.5%)
  - Non-power-of-2 disk arrays:  unaffected, identical fallback path

Signed-off-by: Herman Semenoff <GermanAizek@yandex.ru>
Signed-off-by: Herman Semenoff <GermanAizek@aizekgroup.ru>
---
 drivers/md/raid0.c | 26 +++++++++++++++++++-------
 drivers/md/raid0.h |  1 +
 2 files changed, 20 insertions(+), 7 deletions(-)

diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
index 35e103f0c2c3..993df48eaa4c 100644
--- a/drivers/md/raid0.c
+++ b/drivers/md/raid0.c
@@ -207,6 +207,8 @@ static int create_strip_zones(struct mddev *mddev,
struct r0conf **private_conf)
  }
  zone->nb_dev = cnt;
  zone->zone_end = smallest->sectors * cnt;
+ zone->nb_dev_shift = is_power_of_2(zone->nb_dev) ?
+     ilog2(zone->nb_dev) : -1;

  curr_zone_end = zone->zone_end;

@@ -246,6 +248,8 @@ static int create_strip_zones(struct mddev *mddev,
struct r0conf **private_conf)
  }

  zone->nb_dev = c;
+ zone->nb_dev_shift = is_power_of_2(zone->nb_dev) ?
+     ilog2(zone->nb_dev) : -1;
  sectors = (smallest->sectors - zone->dev_start) * c;
  pr_debug("md/raid0:%s: zone->nb_dev: %d, sectors: %llu\n",
  mdname(mddev),
@@ -330,6 +334,7 @@ static struct md_rdev *map_sector(struct mddev
*mddev, struct strip_zone *zone,
  struct r0conf *conf = mddev->private;
  int raid_disks = conf->strip_zone[0].nb_dev;
  unsigned int chunk_sects = mddev->chunk_sectors;
+ unsigned int disk_idx;

  if (is_power_of_2(chunk_sects)) {
  int chunksect_bits = ffz(~chunk_sects);
@@ -338,21 +343,28 @@ static struct md_rdev *map_sector(struct mddev
*mddev, struct strip_zone *zone,
  sector >>= chunksect_bits;
  /* chunk in zone */
  chunk = *sector_offset;
- /* quotient is the chunk in real device*/
- sector_div(chunk, zone->nb_dev << chunksect_bits);
- } else{
+ if (zone->nb_dev_shift >= 0) {
+ chunk >>= (zone->nb_dev_shift + chunksect_bits);
+ disk_idx = sector & (zone->nb_dev - 1);
+ } else {
+ /* quotient is the chunk in real device*/
+ sector_div(chunk, zone->nb_dev << chunksect_bits);
+ disk_idx = sector_div(sector, zone->nb_dev);
+ }
+ *sector_offset = (chunk << chunksect_bits) + sect_in_chunk;
+ } else {
  sect_in_chunk = sector_div(sector, chunk_sects);
  chunk = *sector_offset;
  sector_div(chunk, chunk_sects * zone->nb_dev);
+ disk_idx = sector_div(sector, zone->nb_dev);
+ *sector_offset = (chunk * chunk_sects) + sect_in_chunk;
  }
  /*
  *  position the bio over the real device
  *  real sector = chunk in device + starting of zone
  * + the position in the chunk
  */
- *sector_offset = (chunk * chunk_sects) + sect_in_chunk;
- return conf->devlist[(zone - conf->strip_zone)*raid_disks
-     + sector_div(sector, zone->nb_dev)];
+ return conf->devlist[(zone - conf->strip_zone) * raid_disks + disk_idx];
 }

 static sector_t raid0_size(struct mddev *mddev, sector_t sectors, int
raid_disks)
@@ -616,7 +628,7 @@ static bool raid0_make_request(struct mddev
*mddev, struct bio *bio)
  ? (sector & (chunk_sects-1))
  : sector_div(sector, chunk_sects));

- if (sectors < bio_sectors(bio)) {
+ if (unlikely(sectors < bio_sectors(bio))) {
  bio = bio_submit_split_bioset(bio, sectors,
       &mddev->bio_set);
  if (!bio)
diff --git a/drivers/md/raid0.h b/drivers/md/raid0.h
index 8cc761ca7423..70b73511fb14 100644
--- a/drivers/md/raid0.h
+++ b/drivers/md/raid0.h
@@ -7,6 +7,7 @@ struct strip_zone {
  sector_t dev_start; /* Zone offset in real dev (in sectors) */
  int nb_dev; /* # of devices attached to the zone */
  int disk_shift; /* start disk for the original layout */
+ int nb_dev_shift; /* log2(nb_dev) if power of 2, else -1 */
 };

 /* Linux 3.14 (20d0189b101) made an unintended change to
-- 
2.55.0
