Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.54
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795281918;
	b=qgtg77Ye+ew+qNLBhO/ypfAvyPd1F27mgS4gS2YAW/UwaaEvx6LPmOMsxdAjarqNIdiR
	 6cSGGZR/pLZxk4CucnjEULxStb1wzKRFiy5ffysdMbsQ1KFe1htqiXfRLzbxjy0RObsfO
	 FdCKF2leEciYdeh2sCQ4xhk03NKDEVcsL3UFciOBb7sI4jsIpsR8KvIynpkTUChxkwTUr
	 5VL4EuN9NE61KI+OkAFfjPpdh4UlZfUgurmGwEefryF3E/fBX2aKt/YQWQLsFNF8DES1a
	 sdhNo8BlB8iAEdSehuXXGJCcItwgTims0AEuGD2kv3guf33WCILQYYeKjypTKmJk4jQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795281918;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:From:Date:X-Gm-Features:Message-ID:Subject:To:
	 Content-Type;
	bh=jEVC9z3fKTdorHh4mzVaVfKrDjM6NNyS/otyoBpkmfM=;
	b=o/xJSRDNMc2RnIWvpph7i1DQHlrAzgJKzLVRYpzADd8z7PjvnuaVe7XqMayUA4IVY2Ab
	 uhzXueQBRBWWj4bUoyEggh0+l3WV8SLGY1fXs5iHcBe6bkVynaHDIOLMWiqM6dEUZqFTD
	 2wKWqAJ+FYWy0MVipZFCH78BLp/xXiORMVBgXAUxtFwvawQE+yIdE5Hw62cS63gjzqKOl
	 ajg/osLSZKvaG3DfamuQM/HMW3xIbHbmJMUn+cl2bkOV5CAMXC0qN6Y3SRBifsbBLWZVJ
	 jym9SVGC5/+6kzdmNPhzvYxa/SeSpEGhDFaxQUTXs9EqtiCDTf2zAvO33CUJxleMkuQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=f6Y9a7sv;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.54
Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B239606A32A
	for <linux-raid@vger.kernel.org>; Sat, 21 Nov 2026 17:25:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1B239606A32A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=f6Y9a7sv
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-6ba38c41804so2127517a12.3
        for <linux-raid@vger.kernel.org>; Sat, 21 Nov 2026 09:25:17 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795281916; cv=none;
        d=google.com; s=arc-20260327;
        b=Y39x9ZdhIuC5WSUTf2EVhKEQ5iGcPSdrh7y7VMEneQt9Z8AidaEh2HzFddh1OZcsNM
         VMN9dZ89uzvCPd8SYYAYfMuzV5oPvcpeY9ytC6XN/kvGHadVDTGLCmJLbS5YIqOtr35R
         tiCF/6VD07glj36nBKMPwaQaKt3yhqy4w1td9v8dMmIDhQn5U2UJI6Ct4yUF3PesTisc
         Hx9Yy7hevGGDGBMrgAWKVEwz3xLlcwLRpaWb4ub54+DSCpH2oDMQsvSYYO4GGNC8eqB0
         1Exf4aPsgH9LkjNwRnQ/8anu6JRo7rg6aa4G26F/5LAmkqPqEev6eV2dPV/JzjoKwMHy
         f+7Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=jEVC9z3fKTdorHh4mzVaVfKrDjM6NNyS/otyoBpkmfM=;
        fh=KZLmMaG1VGwgjZhF4hLc8bi739ycGUsWAo97++FN/c0=;
        b=A/+a7G6C7gMJeglCorjZAZQkJZYIg1fR6U3Nx8zQqChH9km/Bu+HmtVrqDgv6WLV/t
         ThXHZvAqPeNbHV7o1OwUeEFNYmo+OUDJZU0UaLONlNnoGCB/cXgZ43hCiHHO5Y5t0+B/
         CA2k/K8xPjLMaA+tdyzSonaM/YyOJ+ixTFznK+jSDW4eGV1WmVFd5YKxffDlm0iiB09v
         NXTAEM+7AU5eMvezVUgLepAoaNXOGdAiVt6O1PsD1qgMqAOyuYgPJyoAM0WCBQPgGXRd
         3S39LCTCMl2P8anPlevM8Bako8kpG5xOEBSbPBETqpYM5fw5JX2UnJUZ0Zise0H88IV2
         jq5Q==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795281916; x=1795886716; darn=vger.kernel.org;
        h=content-type:to:subject:message-id:date:from:mime-version:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=jEVC9z3fKTdorHh4mzVaVfKrDjM6NNyS/otyoBpkmfM=;
        b=f6Y9a7svjG0EyEwwrx0xhjyXCQMHAbjPLzlXgqSgV3RdK9zq2q1pgjPEnqqxR3efV1
         VnMrXJlgSYszaAVGh2Xnp3wuMmzRGfn8Lf9EedcTIdZL/PisRtB/+NO1L7CSbCW9GQcl
         76G37NuNS8u+7h7TPNhvzHNHS/jq2o52wfDdT/IAVLlHPYXAT5+yjSqbYWwC9YFcNEOB
         nRVuTLPHMgIF14QNgZSZwCtdZMmA0ZRySlkeXjhITL1z5JqyLekE3/ayLOD/mgXjVGqY
         Ew5HKpx+LrZKv8LCndASa8V32QBp/GOe/+DxHz/z+hnYWEGkulEaqcTeuAS/Qmf+ACBV
         E5SA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795281916; x=1795886716;
        h=content-type:to:subject:message-id:date:from:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=jEVC9z3fKTdorHh4mzVaVfKrDjM6NNyS/otyoBpkmfM=;
        b=aJO4azxltrKMON++hdCpiDUBQUeOZRGHhmZrCBsk1pEgCKoGgZFGGxKm2LsBWTatTh
         XisNhKEksBSw5Fgc1ljPwa2BDD7WG25DfCwmZxLmND2HJpYIG/gHv1mnSAKFWMyzfgyj
         9SX3dTmGNYcsTKNUrPRsanhgyQpvsor0epPP3+xUxuwtRPb4/gSR+4EM8oHgUmE4Gvex
         8cG/+ZmOubMlrUL6hh1drgbrABaAVprN07aXXMHk90KeWDeQit0lGupmsCPFSNVYP9XP
         Yca1VvlEMRYZAwKWU+CDa0YhyuhuvmgUPhMMnXH0sp1S6WnUYcp1U34TLAXxRkXjgh7F
         2UFA==
X-Forwarded-Encrypted: i=1; AL+hErGYstBjyv7X9x7lQKW9Vud0hjuoN9RCH2a1DJYt734XnVtmHuDQTUtwmNk25SSsSi9oNqrg73boDA+7@vger.kernel.org
X-Gm-Message-State: APuU4Z/Gtxodm5jy6WkQ5D5aFqqgUf08PDaHgdY18Ya4x8seWppKkT/h
	veIbx+Kwgu1C1UG4zF1lTB9j1MvGzmyjTZwe8J+Rq/QBj2DgxaqlMgTujooMEdtdlbtxJS1WSPH
	ErMe8dphN1B/h2Q8RvsOqVO02WuT4ccxYpy9DPjDGBw==
X-Gm-Gg: AZFdTZeYLoPSdHsvDZJ7XX8GjmbWj+2/ft3ViFzJjJBRI0KR8hHsBGl+mcqpxx6VSvY
	Kk5J47Jon8hwq8KfXh6ipnJ9wqRIyq3EN1yDe+P1ZO9bQmznBeM0RfKPMrJU5bvAlPtP4/oFUeI
	ocH1LXQF4QlylNLiRlStmci5zVoCC57XkDcv1WlpM+soEStmwyAO4GMytkSXjt0XllTTKFnsjpF
	RZ/PqSXwsRNkkS1cLqSKCin8XBrnPm+S94sGmxV7vGe17tMDepvsR+WOJxZOSw9nfHN7khtgN4u
	bKWqC1EGEw1fXYDDIISvRblfTvrtQN/6f2sD5yXsa9FLfsNfCZpl4j+gL9lBf54172ZH357J2OT
	KB+VXa8n35HETI83ucKTVEstvVQKpB0vRUe/D+mMp7A3OPzoZo/sLN8c/R7VtvuFNMIb/WG89VK
	8PlbOeiROqH5s0W33MbE0gQgQgG5Lv5hzs7lFYU5NbDFXoqz7E
X-Received: by 2002:a05:6402:a6cb:10b0:6b7:82cf:f6ab with SMTP id
 4fb4d7f45d1cf-6ba37e8ae50mr3382914a12.28.1795281916291; Sat, 21 Nov 2026
 09:25:16 -0800 (PST)
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
Date: Sat, 21 Nov 2026 20:25:33 +0300
X-Gm-Features: Aa3M54qKzxb3G59FpL5NAPHMGhwfKir0wVcdEZBT1nycH2gYN6zKK6d4CYnGEpA
Message-ID: <CAMnMt5bHeL-yk4hHmUYDC0yq6V5mxj8smkCPyGqjV-YnUBQ-xA@mail.gmail.com>
Subject: [PATCH v2] md/raid0: optimize stripe mapping with bitwise shifts for
 power-of-2 devices
To: Song Liu <song@kernel.org>, Yu Kuai <yukuai@fygo.io>, Li Nan <magiclinan@didiglobal.com>, 
	Xiao Ni <xiao@kernel.org>, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

From 450ebc4be1d31f25855c6771e67d27718ab6540f Mon Sep 17 00:00:00 2001
From: Herman Semenoff <GermanAizek@yandex.ru>
Date: Sun, 8 Nov 2026 22:43:29 +0300
Subject: [PATCH v2] md/raid0: optimize stripe mapping with bitwise
shifts for power-of-2 devices

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
index 35e103f0c2c3..aeb305077a5e 100644
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

base-commit: af5f12805e5cefa4fe68d6127c7e1fb78cd5535c
