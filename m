Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.127.231.41
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795258695;
	b=PagDzGewU7Y2EU50N06SLRKwMH18970QIwSlau+N49Wpfa5X6vAgme2KEZXxfK8aRn9p
	 6PuPrYPcDoL8Q1/4fluXvSguRcu+Tnq26UgN9keWS+k0NShmSv6O6HhQlUeSPjp0rmaEl
	 A/HM6XYJ6idfck3ALuf/SPz9Ckiwtvw1kNym7HReMHrcK7CZHG4zJPez3aFR1bd3x02Xy
	 ts3eXwm3A8FV81DUH9XJ/0r/oRo88S+asn8Q1Nfw8D2WD15x6SbM0fZG32PDdJTxvXMkN
	 vfcJCEcgNlQJ7o1/8azvmbyRarx98zSy/nSFJTvWN4A/Wtc1Xw6xLqelJJ3tm+v1Z3w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795258695;
	h=DMARC-Filter:DKIM-Signature:Date:X-Original-From:In-Reply-To:
	 Content-Transfer-Encoding:User-Agent:Reply-To:To:From:Subject:
	 Message-Id:Mime-Version:References:Content-Type:Received:
	 X-Lms-Return-Path;
	bh=V3bNUNiT/0ywDdd6Xcd8mmP1/n5MrmRMqYlXo9hj8KQ=;
	b=QY21PmhVO2Sf1vECw/y6AXHl4kjDgesLHnQ0DFxzIrCEJH7J6e0mjDd3sve3pShKEiCC
	 5Dty1uycnCZIiMUtoL19VoKkyt77howU9obvxoMOnby0ReWbLERtMoM6tw1dXhbOh+4Ql
	 3RyyCow3rjPZBdrwx+1XIBIUE5aEUZbVgAUvmLSCwqhGShK9Kp30I8XKyX62DrzZXWfwK
	 tN4lzqxFCwcCCrSYQAHvk3QCVWmZAxrW3VSF+bpTxCY2NI+nZSk4q3Ad6thAoJ8sWFMxx
	 u6nh98yurXe7gUW/A5PEw9y+KeI8TsVbIO3iWF/GDUfbLIKR2X7oZtz2Pv8zD9FVGeQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=fygo.io;
	spf=pass smtp.mailfrom=fygo.io;
	dkim=pass header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.a=rsa-sha256 header.s=s1 header.b=nHln9N2c;
	arc=none smtp.remote-ip=209.127.231.41
Received: from va-2-41.ptr.blmpb.com (va-2-41.ptr.blmpb.com [209.127.231.41])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92F7E606A320
	for <linux-raid@vger.kernel.org>; Sat, 21 Nov 2026 10:58:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 92F7E606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fygo.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.a=rsa-sha256 header.s=s1 header.b=nHln9N2c
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fygo-io.20200929.dkim.larksuite.com; t=1795258687;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=V3bNUNiT/0ywDdd6Xcd8mmP1/n5MrmRMqYlXo9hj8KQ=;
 b=nHln9N2cAzfwDu3cnQey9Y7CZtTETZg9uZsYpo0pHpDjVsC5t5/lZhp0THoklE49wAkZ5G
 1BV2ack+8Ch9njWF1qTdyGLHj276TNEU5ynKq50ITwBCjPFhK5imi6uPwgcEOWF8ybWfdS
 Oxdjqczz5t6Xl5TivFRKsZi59ou+nJ+EY+tMcnjUP/dBU29PFc74H5v8RdA+QE8QNupY9E
 errtTK05M2Ow4rtefrpO101fsXwWphDdeX4HVnuC+HvnZqH/4SQhqkKT6stXuDtTrzidYu
 GkP62Zd8ojuLgmdH4yxoYAgGbH7Shlepst5qaQEUjZh/oXA7+7uCD/O0ZBiLeA==
Date: Sat, 21 Nov 2026 18:58:01 +0800
X-Original-From: yu kuai <yukuai@fygo.io>
In-Reply-To: <CAMnMt5Z+BwOaPWQGTTUeSr8uaT=dysMi42xRpFpUruRRcO7=wA@mail.gmail.com>
Content-Transfer-Encoding: quoted-printable
User-Agent: Mozilla Thunderbird
Reply-To: yukuai@fygo.io
To: "Herman Semenoff" <germanaizek0@gmail.com>, <song@kernel.org>, 
	<magiclinan@didiglobal.com>, <xiao@kernel.org>, 
	<linux-raid@vger.kernel.org>, <linux-kernel@vger.kernel.org>, 
	"yu kuai" <yukuai@fygo.io>
From: "yu kuai" <yukuai@fygo.io>
Subject: Re: [PATCH] md/raid0: optimize stripe mapping with bitwise shifts for power-of-2 devices
Message-Id: <f1aa2a91-0859-44d7-9cc1-b64ed4def889@fygo.io>
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Post: <mailto:linux-raid@vger.kernel.org>
List-Help: <mailto:linux-raid+help@vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-raid+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
References: <CAMnMt5Z+BwOaPWQGTTUeSr8uaT=dysMi42xRpFpUruRRcO7=wA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Received: from [192.168.1.104] ([39.182.0.159]) by smtp.larksuite.com with ESMTPS; Sat, 21 Nov 2026 10:58:05 +0000
X-Lms-Return-Path: <lba+26b01793e+928ddc+vger.kernel.org+yukuai@fygo.io>

Hi,

=E5=9C=A8 2026/11/17 13:15, Herman Semenoff =E5=86=99=E9=81=93:
>  From 086678202572260393864f72c06f4d67032a4b76 Mon Sep 17 00:00:00 2001
> From: Herman Semenoff <GermanAizek@yandex.ru>
> Date: Sun, 8 Nov 2026 22:43:29 +0300
> Subject: [PATCH] md/raid0: optimize stripe mapping with bitwise shifts
> for power-of-2 devices
>
> In drivers/md/raid0.c, map_sector() performs two 64-bit integer divisions
> (sector_div) on every submitted bio:
>    1. sector_div(chunk, zone->nb_dev << chunksect_bits) to compute the ch=
unk
>       offset within the member device.
>    2. sector_div(sector, zone->nb_dev) to select the target member disk.
>
> For ultra-low latency solid-state storage devices, such as Intel Optane
> (3D XPoint NVMe SSDs) capable of sub-10us latencies and multi-million IOP=
S,
> these un-pipelined 64-bit division instructions create unnecessary CPU
> pipeline stalls and latency overhead in the I/O submission hot path.
>
> When the number of member devices in a strip zone is a power of two
> (e.g., 2, 4, 8, 16 disks, which is the predominant configuration for
> NVMe arrays), both divisions can be replaced with bitwise shifts and
> masks:
>    - chunk >>=3D (zone->nb_dev_shift + chunksect_bits)
>    - disk_idx =3D sector & (zone->nb_dev - 1)
>    - *sector_offset =3D (chunk << chunksect_bits) + sect_in_chunk
>
> Store nb_dev_shift (ilog2(zone->nb_dev)) in struct strip_zone during zone
> initialization when is_power_of_2(zone->nb_dev) is true, or -1 otherwise.
> If nb_dev_shift is non-negative and chunk_sects is a power of two, fast
> bitwise math is used with zero divisions. Arrays with non-power-of-2 disk
> counts fall back to the existing sector_div() path without any behavior
> or compatibility change.
>
> In addition, annotate the bio split check in raid0_make_request() with
> unlikely(), as standard MD devices already enforce chunk_sectors limits
> via bio_split_to_limits() in md_submit_bio().
>
> Tested on an 8-disk Intel Optane Memory M10 (MEMPEK1J016GAD) RAID0 array:
>    - Random 4K read QD1 latency:  avg lat 22.06 us -> 21.10 us (-4.4%)
>    - Random 4K read QD1 IOPS:     42.6k IOPS       -> 44.6k IOPS (+4.7%)
>    - Random 4K read QD32x8 IOPS:  1.11M IOPS       -> 1.72M IOPS (+54.5%)
>    - Non-power-of-2 disk arrays:  unaffected, identical fallback path
>
> Signed-off-by: Herman Semenoff <GermanAizek@yandex.ru>
> Signed-off-by: Herman Semenoff <GermanAizek@aizekgroup.ru>
> ---
>   drivers/md/raid0.c | 26 +++++++++++++++++++-------
>   drivers/md/raid0.h |  1 +
>   2 files changed, 20 insertions(+), 7 deletions(-)

This patch is unacceptable, you need to regenerate it with correct format.

>
> diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
> index 35e103f0c2c3..993df48eaa4c 100644
> --- a/drivers/md/raid0.c
> +++ b/drivers/md/raid0.c
> @@ -207,6 +207,8 @@ static int create_strip_zones(struct mddev *mddev,
> struct r0conf **private_conf)
>    }
>    zone->nb_dev =3D cnt;
>    zone->zone_end =3D smallest->sectors * cnt;
> + zone->nb_dev_shift =3D is_power_of_2(zone->nb_dev) ?
> +     ilog2(zone->nb_dev) : -1;
>
>    curr_zone_end =3D zone->zone_end;
>
> @@ -246,6 +248,8 @@ static int create_strip_zones(struct mddev *mddev,
> struct r0conf **private_conf)
>    }
>
>    zone->nb_dev =3D c;
> + zone->nb_dev_shift =3D is_power_of_2(zone->nb_dev) ?
> +     ilog2(zone->nb_dev) : -1;
>    sectors =3D (smallest->sectors - zone->dev_start) * c;
>    pr_debug("md/raid0:%s: zone->nb_dev: %d, sectors: %llu\n",
>    mdname(mddev),
> @@ -330,6 +334,7 @@ static struct md_rdev *map_sector(struct mddev
> *mddev, struct strip_zone *zone,
>    struct r0conf *conf =3D mddev->private;
>    int raid_disks =3D conf->strip_zone[0].nb_dev;
>    unsigned int chunk_sects =3D mddev->chunk_sectors;
> + unsigned int disk_idx;
>
>    if (is_power_of_2(chunk_sects)) {
>    int chunksect_bits =3D ffz(~chunk_sects);
> @@ -338,21 +343,28 @@ static struct md_rdev *map_sector(struct mddev
> *mddev, struct strip_zone *zone,
>    sector >>=3D chunksect_bits;
>    /* chunk in zone */
>    chunk =3D *sector_offset;
> - /* quotient is the chunk in real device*/
> - sector_div(chunk, zone->nb_dev << chunksect_bits);
> - } else{
> + if (zone->nb_dev_shift >=3D 0) {
> + chunk >>=3D (zone->nb_dev_shift + chunksect_bits);
> + disk_idx =3D sector & (zone->nb_dev - 1);
> + } else {
> + /* quotient is the chunk in real device*/
> + sector_div(chunk, zone->nb_dev << chunksect_bits);
> + disk_idx =3D sector_div(sector, zone->nb_dev);
> + }
> + *sector_offset =3D (chunk << chunksect_bits) + sect_in_chunk;
> + } else {
>    sect_in_chunk =3D sector_div(sector, chunk_sects);
>    chunk =3D *sector_offset;
>    sector_div(chunk, chunk_sects * zone->nb_dev);
> + disk_idx =3D sector_div(sector, zone->nb_dev);
> + *sector_offset =3D (chunk * chunk_sects) + sect_in_chunk;
>    }
>    /*
>    *  position the bio over the real device
>    *  real sector =3D chunk in device + starting of zone
>    * + the position in the chunk
>    */
> - *sector_offset =3D (chunk * chunk_sects) + sect_in_chunk;
> - return conf->devlist[(zone - conf->strip_zone)*raid_disks
> -     + sector_div(sector, zone->nb_dev)];
> + return conf->devlist[(zone - conf->strip_zone) * raid_disks + disk_idx]=
;
>   }
>
>   static sector_t raid0_size(struct mddev *mddev, sector_t sectors, int
> raid_disks)
> @@ -616,7 +628,7 @@ static bool raid0_make_request(struct mddev
> *mddev, struct bio *bio)
>    ? (sector & (chunk_sects-1))
>    : sector_div(sector, chunk_sects));
>
> - if (sectors < bio_sectors(bio)) {
> + if (unlikely(sectors < bio_sectors(bio))) {
>    bio =3D bio_submit_split_bioset(bio, sectors,
>         &mddev->bio_set);
>    if (!bio)
> diff --git a/drivers/md/raid0.h b/drivers/md/raid0.h
> index 8cc761ca7423..70b73511fb14 100644
> --- a/drivers/md/raid0.h
> +++ b/drivers/md/raid0.h
> @@ -7,6 +7,7 @@ struct strip_zone {
>    sector_t dev_start; /* Zone offset in real dev (in sectors) */
>    int nb_dev; /* # of devices attached to the zone */
>    int disk_shift; /* start disk for the original layout */
> + int nb_dev_shift; /* log2(nb_dev) if power of 2, else -1 */
>   };
>
>   /* Linux 3.14 (20d0189b101) made an unintended change to

--=20
Thanks,
Kuai
