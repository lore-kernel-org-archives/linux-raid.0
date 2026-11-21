Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.218.41
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795280100;
	b=xa5m7sBIxTvOATZ2b5CF/aKcuXyhQBB7wq4hLW6h0LJksNaTxLMKP/sO9w/BX+euCbK1
	 60WFJWFTnRGqu+F63RfpILmzqUHO4AlmjQ09dPfPNuewE1Qxg+Emr7z0V2eahToiv6QUR
	 a7SiX+QXlvxe16+ArNoWulOa877QHrVs/VX7D0Ndq0Thpn3gS0muy0dAAqsbQJsBWMvL1
	 sKImm1HZabGcTaX55sUVH7D1ozwRPBnVdRVdRlxSsgN4NqK2ASYmG6XBs/7bLdEqJ6PQc
	 Cio3DOfTqnpHTrPw8i8MswtASxGWK3NdXkXTAdo9sZIZw2p0yYwc4GpMDra25txnbwg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795280100;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:From:Date:X-Gm-Features:Message-ID:Subject:To:
	 Content-Type;
	bh=p4VRFPXRszZf9dXxkcrFMy0Ly2f9TrDiVC01Lr7U2eo=;
	b=zQvYFgfIqc1O4xoZnmFfTc8L6mjMLKA/RBrFJ9mEZCYMe3B6DdygpM2mQllfF6S76+s0
	 FChBQX2OyYakqBcWvr1qYgdmYnS4EUuHnjJ+VOFj4k92YH82VBa9jMnlwPWX/J1/zIo3M
	 MqX+aLfv9InkLjaeSzH+WtFq4cfja9Fv87Z/Xp5ScHeNBdPgeXdrfgwKlfqv+VYkqTvtV
	 9u0XxdrbIlvWBD3oJjgucv+7sX1JjqbmjlJKgNuuN6ay4TqNvpXN0FHRWlZu0AvdjoqY/
	 oaqtaIplH24O0b/XYoBvHkSrV+PEJJDKmmnFsSMrhE+8XofuluN+vSwAAD/zmZjVILw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Ntv+tyfo;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.218.41
Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD2FA606A320
	for <linux-raid@vger.kernel.org>; Sat, 21 Nov 2026 16:54:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CD2FA606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Ntv+tyfo
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-c50933bdf4bso455881466b.1
        for <linux-raid@vger.kernel.org>; Sat, 21 Nov 2026 08:54:59 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795280098; cv=none;
        d=google.com; s=arc-20260327;
        b=eEK5jOBwmCLR4+xj7wgYfMXDxHOasT7dOFGc8fVtCDffjr4EP4TytvEFxPiHj7TF8V
         9BA4kDvyw+OZOdfD41IX+YRPLA7i1eD49Q/fNKNEkzN8EewdUB8vjmz8IygBuhJ3TLJ6
         iq0eHoL7W/q73x2wJLeQYlFHwMcMLY3IDF5zReC4y8878cZYexctDc6uANlygFLigrGS
         1Gvs4GBFjBy0s6Qwm//x+PU9sHz4V0UBxYWUN3EInJsL23+SwCiIEVtFE/NA3mqSCMfA
         vGUgTWEU5Qn8vLIAumb4+kcBjBbnB8f3Hu2a6dcTidEoTDxBCe+PXD0EMcreDBbbajbK
         5yxw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=p4VRFPXRszZf9dXxkcrFMy0Ly2f9TrDiVC01Lr7U2eo=;
        fh=cuGsOVX/Yw/IEK9ESTL8nKgWoz0gnVB7eWhEDM/aEHw=;
        b=H9pWQEKANpMfRvelh8LLX+Xz0UN5ORMGr6fziHX4Mt/KPM1WbftbJfgXd0QUmt3X1Q
         FATzMGoPkd7luZSn0Bx5/XRCSygjCgqyNPaBxvO/GYkemtxpDxzuNaIW4TS/oE3qkxbs
         ok9i66xGVVTHORzntw6nbpVCAY/cDrzlFtsRB4bic1fFzOIt+tr6jif3FNQ1RlvtLu8b
         iim42OZynitLGsQdS8zwYp4Ywrl4SSf3h3h53FxmyhL0kJNvVpyWFurmdFTQTUOgbTm7
         8O/ycckT/8V8efTMwPpNXTm0yqzSfL5Y1v0A2GYNgiGgJWv/OxmI5wqa0Lo1OVnbx9cX
         Fi8A==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795280098; x=1795884898; darn=vger.kernel.org;
        h=content-type:to:subject:message-id:date:from:mime-version:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=p4VRFPXRszZf9dXxkcrFMy0Ly2f9TrDiVC01Lr7U2eo=;
        b=Ntv+tyfoGZrKdNVbzRR93la72PF6+CfgZUt3q8pplxGe0KIEQD332IQfH40HQvQn1B
         zYHV3V67lL5OFXv+ExjfbvGiowVo6BgkNycLr1LqmGKR5woeYOUgUQADNM43AZpe4zIc
         9TocEcT4LEkzWgwZdzjZCezBqB5Ilg+K+0zLB3EROmJJ3WXnijHGkq1qQkPgEDrxDubG
         SL2GELit0O7Dc9zRtlSGC1tdUkrtxGzcd08v67EIPI1NW34mIK5np3HkVwSlAKaFqWRq
         r5shaDT6Nr37jFyfuBeE4cd+J+uAwTtkt2MzyL/gXll1WSmXsOL/y6BLeaFF7xbKlDx+
         jsvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795280098; x=1795884898;
        h=content-type:to:subject:message-id:date:from:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=p4VRFPXRszZf9dXxkcrFMy0Ly2f9TrDiVC01Lr7U2eo=;
        b=wZ/vNH6W/c3IQRLrZnkzFTSuGf3awwGnU540n702kyFlzN1cPgMD+QNxHNEQwRl3S3
         QA66ZOKlel0sRVzpehwg8LYOzk9v6L/jajdnSRXeOhb4FrDwy+3Gb3WKCSWgjv66XOno
         5ZcHWdxm04hedafdDLkeniGEcCN1+XlDlGWOiOa9nHA2jZAv+es5ILme0Vn7eY3KgG8h
         ruBD8FvSAorpHZjR8VN6Wlo1dP+AX6Ws4b2oeAdj8SZY48N7NWxYNMRLZz95+RUyd3RS
         5wXehDf5j0zttiAkwd8iTVK2Zx/xz+tmDnOw+AGCCZFnAHInYd+ETj15iMw5segom59C
         nNVQ==
X-Forwarded-Encrypted: i=1; AL+hErHa21uvtPNyluhzMS6yURX4XCgVO5gBqBnTLEKvG3T+d5MlWYMh+Uy2UV6JMPPM9yHNrx+PQDaweIbt@vger.kernel.org
X-Gm-Message-State: APuU4Z8kH5VfubAyQv0nmWZPphvym4YgpsjTNKwqNKdOs3jO8rjZgqJ9
	JMf5RHh6Gi1iRZVkC0BxQa66pMD2BB6ymhPp3xFVtlvUSQp3k09ErZtJgcs16U/g8tCJTPxTfSM
	fQk4UwYJZIaySe/eNGa+o6TpRanYrXOE=
X-Gm-Gg: AZFdTZeTA3HpMyQC2JkmdOTT35nBXtpEH5h8cwIwgxsjgDtutKr0RQjJIpqHcHB8BNt
	swo+LttYz+Im+BNBgJuvxxZV+YkMwvqhDa85UuDlNX+fDuU4MgywHLEM3wyropX31hhC/E0fjv6
	ilNokRRAm2gJmE1v9eZ41fjPBQru7BJuYjTiOT3O4QkSWD9/U934jY8StVqlj6tP4XodaU+gXpi
	LKPtoQkYwfE303MVgYuwI04W+WlQnjlHWdi1YAUr+9ehK++mtuBtchWVlazZi1vb5cvp4pqPygo
	8dxf9Gfvz9TPjeQ5EytWIs3QzyMNxoeYzOTPkTjXFE5f1qoL+7nnkDG7MnjPpfSoNuEoaVTg6Jk
	BLhBV1kZSO/fSDQGFpxt2jJsFne9OkdFHI9hx5qq0xfPX7BoJGi76kn7yLq1GVbJbzEzWXXqWEE
	/ddEdlmEeAz2z8igKlW5EGz3HIlRAO1YGQW0/n1JJxG0j7/JPI
X-Received: by 2002:a17:906:730a:b0:c2e:1b6b:8b19 with SMTP id
 a640c23a62f3a-c51319443e5mr756376366b.23.1795280098016; Sat, 21 Nov 2026
 08:54:58 -0800 (PST)
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
Date: Sat, 21 Nov 2026 19:55:14 +0300
X-Gm-Features: Aa3M54qjEMC-B19WwPy3mwsbI41xLRHwyJMCWJ-SqiNDvruJ2FeNFUQFuycHa_A
Message-ID: <CAMnMt5YdKe__Q3o3M-og5LnC0To0DOiX80nDosYKNfVbZg1QgQ@mail.gmail.com>
Subject: [PATCH v2] md/raid0: optimize stripe mapping with bitwise shifts for
 power-of-2 devices
To: Song Liu <song@kernel.org>, Yu Kuai <yukuai@fygo.io>, Li Nan <magiclinan@didiglobal.com>, 
	Xiao Ni <xiao@kernel.org>, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

From 450ebc4be1d31f25855c6771e67d27718ab6540f Mon Sep 17 00:00:00 2001
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
