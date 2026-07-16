Received: from va-2-54.ptr.blmpb.com (va-2-54.ptr.blmpb.com [209.127.231.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA75B329E5A
	for <linux-raid@vger.kernel.org>; Thu, 16 Jul 2026 09:53:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784195601; cv=none; b=ZPSZdpWRnudBVNyKdsbi0cwZYPzR/we9zEWcnUvyf07heql/K12zsl0K7R3AVD9SI8qXAYZXfjOjTPJ2nTy0NgekPx6jGIFHf0paUjz2VUU2kNA1nl/hhVk27HXKkIsuPWZ+UXJSf02qAEvNUo/ideJmq8VtseMLQIRf9JW2/ck=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784195601; c=relaxed/simple;
	bh=4eMleq43Cd6H54Eqdqlb9JiReP4VaKdStiUBMU8JfXk=;
	h=Content-Type:References:To:From:Subject:Mime-Version:Cc:Date:
	 Message-Id:In-Reply-To; b=r8g7IiKmlDiUZ0bqfpsPRPzUN5rBAXYUiKP/iq3h9aK14hCCR4bzvYGaaOhpRevC5uG4N0Rp+PNrVzFNd+aqdnecqcyqBcX0Z5WZABajiBHKRnpfmAn/z0mvQ2VtQ9bWUSMxoblZfXo5tfyjM72EdqvNH/Jp2KOZG7pYytEQqaI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io; spf=pass smtp.mailfrom=fygo.io; dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b=pd0/SrKY; arc=none smtp.client-ip=209.127.231.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fygo.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b="pd0/SrKY"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fygo-io.20200929.dkim.larksuite.com; t=1784195584;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=rrte504OYn/TzeIN6mr35emhg9sl06qxyxnO3ONL2uE=;
 b=pd0/SrKYvANJKIeUtm37C1TXSFV50a7xXETa7G2f3xwEPXYJBC5dZBz+hxCaNmKrm4ddso
 1OBg310czoOCwVpnJRKEMScgTZJWepDqoyTt6zkp18n9u0KFGjDPr5WARd9Y5u8kmSW+/a
 aYBXURMZ901gNKRR12GTwR8bE4YTKj2ZudYBzMrbrTQvsjfUzxUGDLoB5rWZs44YE3dqca
 8KuSJxYEQOngFjjhm4KF1898wy0jKRZK4KHFgy+xpHTO7g0CSxi6EBf5r3LWmOV6sUsdsJ
 bZphkUqhZOgle1hJDshus5WRR7wHRwNyXi62dMxh1aT2FI/n8xVTH581kCj6IQ==
Content-Type: text/plain; charset=UTF-8
References: <20260710101521.1714-1-abd.masalkhi@gmail.com> <20260710101521.1714-8-abd.masalkhi@gmail.com>
To: "Abd-Alrhman Masalkhi" <abd.masalkhi@gmail.com>, <song@kernel.org>, 
	<magiclinan@didiglobal.com>, <xiao@kernel.org>, <axboe@kernel.dk>, 
	<vverma@digitalocean.com>, <john.g.garry@oracle.com>, 
	<martin.petersen@oracle.com>, <linux-kernel@vger.kernel.org>, 
	"yu kuai" <yukuai@fygo.io>
From: "yu kuai" <yukuai@fygo.io>
Subject: Re: [PATCH v4 7/7] md/raid10: simplify read request error handling
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Received: from [192.168.1.104] ([39.182.0.157]) by smtp.larksuite.com with ESMTPS; Thu, 16 Jul 2026 09:53:03 +0000
Content-Transfer-Encoding: quoted-printable
User-Agent: Mozilla Thunderbird
X-Original-From: yu kuai <yukuai@fygo.io>
Cc: <linux-raid@vger.kernel.org>
Date: Thu, 16 Jul 2026 17:52:59 +0800
X-Lms-Return-Path: <lba+26a58aa00+76fd54+vger.kernel.org+yukuai@fygo.io>
Reply-To: yukuai@fygo.io
Message-Id: <feae08aa-7ce3-4375-91d0-42d501627908@fygo.io>
In-Reply-To: <20260710101521.1714-8-abd.masalkhi@gmail.com>

Hi,

=E5=9C=A8 2026/7/10 18:15, Abd-Alrhman Masalkhi =E5=86=99=E9=81=93:
> raid10_read_request() currently handles bio completion, barrier
> handling, and r10_bio lifetime management in several different error
> paths. This results in duplicated cleanup logic and increases the risk
> of introducing bugs in future modifications.
>
> Make raid10_read_request() return a status to its callers, consolidate
> the read error paths, and free r10_bio from a single location in the
> callers. Since the callers allocate r10_bio, they should also be
> responsible for freeing it when the request fails.
>
> This makes the read path follow the same ownership model as the write
> path and simplifies the error handling flow.
>
> Signed-off-by: Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>
> ---
> Changes in v4:
>   - No changes.
>   - Link to v3: https://lore.kernel.org/linux-raid/20260708101341.473750-=
8-abd.masalkhi@gmail.com/
>
> Changes in v3:
>   - No changes.
>   - Link to v2: https://lore.kernel.org/linux-raid/20260628142420.1051027=
-8-abd.masalkhi@gmail.com/
>
> Changes in v2:
>   - Fix a compilation error (bi -> bio).
>   - Link to v1: https://lore.kernel.org/linux-raid/20260623072456.333437-=
8-abd.masalkhi@gmail.com/
> ---
>   drivers/md/raid10.c | 45 +++++++++++++++++++++++++--------------------
>   1 file changed, 25 insertions(+), 20 deletions(-)

I don't think patch 6 and 7 are actually simplifications, and 7 in particul=
ar introduces
a fragile dependency I'd rather not take as-is. The diff lines also said th=
is and I'd
rather not take as-is.

>
> diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
> index d94c1f28a6f6..01162c483644 100644
> --- a/drivers/md/raid10.c
> +++ b/drivers/md/raid10.c
> @@ -1143,7 +1143,7 @@ static bool regular_request_wait(struct mddev *mdde=
v, struct r10conf *conf,
>   	return true;
>   }
>  =20
> -static void raid10_read_request(struct mddev *mddev, struct bio *bio,
> +static bool raid10_read_request(struct mddev *mddev, struct bio *bio,
>   				struct r10bio *r10_bio)
>   {
>   	struct r10conf *conf =3D mddev->private;
> @@ -1191,8 +1191,7 @@ static void raid10_read_request(struct mddev *mddev=
, struct bio *bio,
>  =20
>   	if (!regular_request_wait(mddev, conf, bio, r10_bio->sectors)) {
>   		bio_wouldblock_error(bio);
> -		free_r10bio(r10_bio);
> -		return;
> +		return false;
>   	}
>  =20
>   	rdev =3D read_balance(conf, r10_bio, &max_sectors);
> @@ -1202,8 +1201,8 @@ static void raid10_read_request(struct mddev *mddev=
, struct bio *bio,
>   					    mdname(mddev), b,
>   					    (unsigned long long)r10_bio->sector);
>   		}
> -		raid_end_bio_io(r10_bio);
> -		return;
> +		bio_io_error(bio);
> +		goto err_allow_barrier;
>   	}
>   	if (err_rdev)
>   		pr_err_ratelimited("md/raid10:%s: %pg: redirecting sector %llu to ano=
ther mirror\n",
> @@ -1215,10 +1214,8 @@ static void raid10_read_request(struct mddev *mdde=
v, struct bio *bio,
>   		bio =3D bio_submit_split_bioset(bio, max_sectors,
>   					      &conf->bio_split);
>   		wait_barrier(conf, false);
> -		if (!bio) {
> -			set_bit(R10BIO_Returned, &r10_bio->state);
> -			goto err_handle;
> -		}
> +		if (!bio)
> +			goto err_dec_pending;
>  =20
>   		r10_bio->master_bio =3D bio;
>   		r10_bio->sectors =3D max_sectors;
> @@ -1244,10 +1241,16 @@ static void raid10_read_request(struct mddev *mdd=
ev, struct bio *bio,
>   	read_bio->bi_private =3D r10_bio;
>   	mddev_trace_remap(mddev, read_bio, r10_bio->sector);
>   	submit_bio_noacct(read_bio);
> -	return;
> -err_handle:
> +
> +	return true;
> +
> +err_dec_pending:
>   	atomic_dec(&rdev->nr_pending);
> -	raid_end_bio_io(r10_bio);
> +
> +err_allow_barrier:
> +	allow_barrier(conf);
> +
> +	return false;
>   }
>  =20
>   static void raid10_write_one_disk(struct mddev *mddev, struct r10bio *r=
10_bio,
> @@ -1538,14 +1541,13 @@ static bool __make_request(struct mddev *mddev, s=
truct bio *bio, int sectors)
>   	memset(r10_bio->devs, 0, sizeof(r10_bio->devs[0]) *
>   			conf->geo.raid_disks);
>  =20
> -	ret =3D true;
>   	if (bio_data_dir(bio) =3D=3D READ)
> -		raid10_read_request(mddev, bio, r10_bio);
> -	else {
> +		ret =3D raid10_read_request(mddev, bio, r10_bio);
> +	else
>   		ret =3D raid10_write_request(mddev, bio, r10_bio);
> -		if (!ret)
> -			free_r10bio(r10_bio);
> -	}
> +
> +	if (!ret)
> +		free_r10bio(r10_bio);
>  =20
>   	return ret;
>   }
> @@ -1875,6 +1877,7 @@ static bool raid10_make_request(struct mddev *mddev=
, struct bio *bio)
>   	sector_t chunk_mask =3D (conf->geo.chunk_mask & conf->prev.chunk_mask)=
;
>   	int chunk_sects =3D chunk_mask + 1;
>   	int sectors =3D bio_sectors(bio);
> +	bool write =3D bio_data_dir(bio) =3D=3D WRITE;
>  =20
>   	if (unlikely(bio->bi_opf & REQ_PREFLUSH)
>   	    && md_flush_request(mddev, bio))
> @@ -1898,7 +1901,7 @@ static bool raid10_make_request(struct mddev *mddev=
, struct bio *bio)
>   		sectors =3D chunk_sects -
>   			(bio->bi_iter.bi_sector &
>   			 (chunk_sects - 1));
> -	if (!__make_request(mddev, bio, sectors))
> +	if (!__make_request(mddev, bio, sectors) && write)
>   		md_write_end(mddev);
>  =20
>   	/* In case raid10d snuck in to freeze_array */
> @@ -2866,7 +2869,9 @@ static void handle_read_error(struct mddev *mddev, =
struct r10bio *r10_bio)
>  =20
>   	rdev_dec_pending(rdev, mddev);
>   	r10_bio->state =3D 0;
> -	raid10_read_request(mddev, r10_bio->master_bio, r10_bio);
> +	if (!raid10_read_request(mddev, r10_bio->master_bio, r10_bio))
> +		free_r10bio(r10_bio);
> +
>   	/*
>   	 * allow_barrier after re-submit to ensure no sync io
>   	 * can be issued while regular io pending.

--=20
Thanks,
Kuai
