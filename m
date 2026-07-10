Received: from va-2-18.ptr.blmpb.com (va-2-18.ptr.blmpb.com [209.127.231.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F73F3559E1
	for <linux-raid@vger.kernel.org>; Fri, 10 Jul 2026 07:38:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783669084; cv=none; b=IQ82I1+9uu2UCvLGxPov7Ou9Dv970UhcmvmaqJ+MvyctLKABcxWz8imsOBa+2T5wEhDYKqmEsTvKreMxSC2aGXqTAzGRQKwrPBWNqLDFZ+mXv+IvtDnyWh/R5Y1oFcwmeFXfKtXVSELF/v7gSPTaE3VO+krs5oFtFUBxihGsARo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783669084; c=relaxed/simple;
	bh=V/b2Jx6MaiBwSx0c/Iv0CXO83U7T9Txpx3cxEPQPzBg=;
	h=Mime-Version:Content-Type:From:In-Reply-To:References:To:Subject:
	 Date:Message-Id; b=fKZ+gDV2O6bGoOQvfDfuijzt3ljuyBQrM6ymN/EQyC74WCyxDkT9La9Vz8Wln9F77wHVManfYuIdEeQvHGH7w9fc2glwMewUXs1deFdR27m2j2SFGxSLsyP8REryrJZvjvvYUNHJ5d6dvCgotmzHGev6+GE/lvxOgKyJNe8KiuU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io; spf=pass smtp.mailfrom=fygo.io; dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b=lLIDZtf5; arc=none smtp.client-ip=209.127.231.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fygo.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b="lLIDZtf5"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fygo-io.20200929.dkim.larksuite.com; t=1783669070;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=GsK/NlK2iSjaKNlhGAqTSUTpWOwNyuLtlKfn2S5ucSw=;
 b=lLIDZtf5Lee3QaE+TXB7kqUoPHU4inGEuC1Kb3hLWL9Ei1QhsbEAuqabZWw0F8MvLIznkU
 BygbDu4ONNOeLMg3euKbxG0CzrXgmOsuBnOiahO3uat+CHIrkr8NaR8xAajJKxKIBIt4R+
 B0tPbpq6i2/1Mc+rLKztgQ5/LN/T1VPz95qGMAOIPoofCJXVfqHfZZ68B6nNLS69dgSUIr
 RTbHY+tsrVawOms9856yZPGmHThW9Uhuv+lji3pKGQ2kpV+i7svw6tyKdQ3gEWRFArugvc
 ts+4X4hPUvDzGVMA8V9kXSWHuFL9c+x9rJq0JEwhyqTvfSTcev7zaE150YJh+g==
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
User-Agent: Mozilla Thunderbird
Content-Type: text/plain; charset=UTF-8
From: "yu kuai" <yukuai@fygo.io>
In-Reply-To: <20260708133534.770770-1-lgs201920130244@gmail.com>
X-Lms-Return-Path: <lba+26a50a14d+2c90fd+vger.kernel.org+yukuai@fygo.io>
Received: from [192.168.1.104] ([39.182.0.144]) by smtp.larksuite.com with ESMTPS; Fri, 10 Jul 2026 07:37:49 +0000
References: <20260708133534.770770-1-lgs201920130244@gmail.com>
X-Original-From: yu kuai <yukuai@fygo.io>
Reply-To: yukuai@fygo.io
To: "Guangshuo Li" <lgs201920130244@gmail.com>, "Song Liu" <song@kernel.org>, 
	"Li Nan" <magiclinan@didiglobal.com>, "Xiao Ni" <xiao@kernel.org>, 
	"Junrui Luo" <moonafterrain@outlook.com>, <linux-raid@vger.kernel.org>, 
	<linux-kernel@vger.kernel.org>, "yu kuai" <yukuai@fygo.io>
Subject: Re: [PATCH] md/raid5: validate journal checksum slots during recovery
Date: Fri, 10 Jul 2026 15:37:45 +0800
Message-Id: <fe7b5f75-f00a-41b4-b22a-e3fb3b51fccb@fygo.io>

Hi,

=E5=9C=A8 2026/7/8 21:35, Guangshuo Li =E5=86=99=E9=81=93:
> The change referenced by the Fixes tag added payload length validation
> before accessing journal metadata during raid5-cache recovery.
>
> However, the DATA and PARITY payload length is computed from the on-disk
> size field without ensuring that the checksum slots read later are
> actually present. struct r5l_payload_data_parity ends with a flexible
> checksum array, so sizeof(struct r5l_payload_data_parity) does not cover
> any checksum entries.
>
> A corrupted journal can set a DATA payload size smaller than one page.
> The computed checksum count then becomes zero and the payload length only
> covers the fixed header, but recovery still reads checksum[0]. For RAID6
> PARITY payloads, recovery also reads checksum[1], so the payload must
> cover two checksum entries.
>
> Make the validated DATA and PARITY payload length include the checksum
> entries that recovery may read. Also make sure fixed payload headers are
> present before reading their fields.
>
> Fixes: b0cc3ae97e89 ("md/raid5: validate payload size before accessing jo=
urnal metadata")

Does the problem this patch fixes introduced by above fix tag? Or it's just=
 a
new validation, if so please replace with a real fix tag.

> Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
> ---
>   drivers/md/raid5-cache.c | 108 +++++++++++++++++++++++++++++----------
>   1 file changed, 82 insertions(+), 26 deletions(-)
>
> diff --git a/drivers/md/raid5-cache.c b/drivers/md/raid5-cache.c
> index 7b7546bfa21f..4aef692182b4 100644
> --- a/drivers/md/raid5-cache.c
> +++ b/drivers/md/raid5-cache.c
> @@ -1980,6 +1980,29 @@ r5l_recovery_verify_data_checksum(struct r5l_log *=
log,
>   	return (le32_to_cpu(log_checksum) =3D=3D checksum) ? 0 : -EINVAL;
>   }
>  =20
> +static sector_t r5l_recovery_payload_data_parity_len(struct r5conf *conf=
,
> +		const struct r5l_payload_data_parity *payload, bool parity)
> +{
> +	unsigned int nr_csum;
> +	unsigned int min_csum =3D 1;
> +
> +	/*
> +	 * The payload size determines how many checksum entries are stored,
> +	 * but recovery always reads checksum[0].  For RAID6 parity payloads
> +	 * it also reads checksum[1] for Q.  Make the validated payload length
> +	 * cover every checksum entry that will be read below.
> +	 */
> +	nr_csum =3D le32_to_cpu(payload->size) >> (PAGE_SHIFT - 9);
> +
> +	if (parity && conf->max_degraded =3D=3D 2)
> +		min_csum =3D 2;
> +	if (nr_csum < min_csum)
> +		nr_csum =3D min_csum;
> +
> +	return sizeof(*payload) + (sector_t)sizeof(__le32) * nr_csum;

Please use struct_size()

> +}
> +
> +

Two blank line here. Please run checkpatch before submission.

>   /*
>    * before loading data to stripe cache, we need verify checksum for all=
 data,
>    * if there is mismatch for any data page, we drop all data in the mata=
 block
> @@ -1992,6 +2015,7 @@ r5l_recovery_verify_data_checksum_for_mb(struct r5l=
_log *log,
>   	struct r5conf *conf =3D mddev->private;
>   	struct r5l_meta_block *mb =3D page_address(ctx->meta_page);
>   	sector_t mb_offset =3D sizeof(struct r5l_meta_block);
> +	sector_t meta_size =3D le32_to_cpu(mb->meta_size);
>   	sector_t log_offset =3D r5l_ring_add(log, ctx->pos, BLOCK_SECTORS);
>   	struct page *page;
>   	struct r5l_payload_data_parity *payload;
> @@ -2001,28 +2025,42 @@ r5l_recovery_verify_data_checksum_for_mb(struct r=
5l_log *log,
>   	if (!page)
>   		return -ENOMEM;
>  =20
> -	while (mb_offset < le32_to_cpu(mb->meta_size)) {
> +	while (mb_offset < meta_size) {
>   		sector_t payload_len;
> +		u16 type;
>  =20
>   		payload =3D (void *)mb + mb_offset;
>   		payload_flush =3D (void *)mb + mb_offset;
>  =20
> -		if (le16_to_cpu(payload->header.type) =3D=3D R5LOG_PAYLOAD_DATA) {
> -			payload_len =3D sizeof(struct r5l_payload_data_parity) +
> -				(sector_t)sizeof(__le32) *
> -				(le32_to_cpu(payload->size) >> (PAGE_SHIFT - 9));
> -			if (mb_offset + payload_len > le32_to_cpu(mb->meta_size))
> +		if (mb_offset + sizeof(payload->header) > meta_size)
> +			goto mismatch;
> +
> +		type =3D le16_to_cpu(payload->header.type);
> +
> +		if (type =3D=3D R5LOG_PAYLOAD_DATA) {
> +			if (mb_offset + sizeof(*payload) > meta_size)
>   				goto mismatch;
> +
> +			payload_len =3D r5l_recovery_payload_data_parity_len(conf,
> +									  payload,
> +									  false);
> +			if (payload_len > meta_size - mb_offset)
> +				goto mismatch;
> +
>   			if (r5l_recovery_verify_data_checksum(
>   				    log, ctx, page, log_offset,
>   				    payload->checksum[0]) < 0)
>   				goto mismatch;
> -		} else if (le16_to_cpu(payload->header.type) =3D=3D R5LOG_PAYLOAD_PARI=
TY) {
> -			payload_len =3D sizeof(struct r5l_payload_data_parity) +
> -				(sector_t)sizeof(__le32) *
> -				(le32_to_cpu(payload->size) >> (PAGE_SHIFT - 9));
> -			if (mb_offset + payload_len > le32_to_cpu(mb->meta_size))
> +		} else if (type =3D=3D R5LOG_PAYLOAD_PARITY) {
> +			if (mb_offset + sizeof(*payload) > meta_size)
>   				goto mismatch;
> +
> +			payload_len =3D r5l_recovery_payload_data_parity_len(conf,
> +									  payload,
> +									  true);
> +			if (payload_len > meta_size - mb_offset)
> +				goto mismatch;
> +
>   			if (r5l_recovery_verify_data_checksum(
>   				    log, ctx, page, log_offset,
>   				    payload->checksum[0]) < 0)
> @@ -2034,15 +2072,18 @@ r5l_recovery_verify_data_checksum_for_mb(struct r=
5l_log *log,
>   						 BLOCK_SECTORS),
>   				    payload->checksum[1]) < 0)
>   				goto mismatch;
> -		} else if (le16_to_cpu(payload->header.type) =3D=3D R5LOG_PAYLOAD_FLUS=
H) {
> +		} else if (type =3D=3D R5LOG_PAYLOAD_FLUSH) {
> +			if (mb_offset + sizeof(*payload_flush) > meta_size)
> +				goto mismatch;
> +
>   			payload_len =3D sizeof(struct r5l_payload_flush) +
>   				(sector_t)le32_to_cpu(payload_flush->size);
> -			if (mb_offset + payload_len > le32_to_cpu(mb->meta_size))
> +			if (payload_len > meta_size - mb_offset)
>   				goto mismatch;
>   		} else /* not R5LOG_PAYLOAD_DATA/PARITY/FLUSH */
>   			goto mismatch;
>  =20
> -		if (le16_to_cpu(payload->header.type) !=3D R5LOG_PAYLOAD_FLUSH) {
> +		if (type !=3D R5LOG_PAYLOAD_FLUSH) {
>   			log_offset =3D r5l_ring_add(log, log_offset,
>   						  le32_to_cpu(payload->size));
>   		}
> @@ -2075,7 +2116,8 @@ r5c_recovery_analyze_meta_block(struct r5l_log *log=
,
>   	struct r5l_meta_block *mb;
>   	struct r5l_payload_data_parity *payload;
>   	struct r5l_payload_flush *payload_flush;
> -	int mb_offset;
> +	sector_t mb_offset;
> +	sector_t meta_size;
>   	sector_t log_offset;
>   	sector_t stripe_sect;
>   	struct stripe_head *sh;
> @@ -2094,22 +2136,31 @@ r5c_recovery_analyze_meta_block(struct r5l_log *l=
og,
>  =20
>   	mb =3D page_address(ctx->meta_page);
>   	mb_offset =3D sizeof(struct r5l_meta_block);
> +	meta_size =3D le32_to_cpu(mb->meta_size);
>   	log_offset =3D r5l_ring_add(log, ctx->pos, BLOCK_SECTORS);
>  =20
> -	while (mb_offset < le32_to_cpu(mb->meta_size)) {
> +	while (mb_offset < meta_size) {
>   		sector_t payload_len;
> +		u16 type;
>   		int dd;
>  =20
>   		payload =3D (void *)mb + mb_offset;
>   		payload_flush =3D (void *)mb + mb_offset;
>  =20
> -		if (le16_to_cpu(payload->header.type) =3D=3D R5LOG_PAYLOAD_FLUSH) {
> +		if (mb_offset + sizeof(payload->header) > meta_size)
> +			return -EINVAL;
> +
> +		type =3D le16_to_cpu(payload->header.type);
> +
> +		if (type =3D=3D R5LOG_PAYLOAD_FLUSH) {
>   			int i, count;
>  =20
> +			if (mb_offset + sizeof(*payload_flush) > meta_size)
> +				return -EINVAL;
> +
>   			payload_len =3D sizeof(struct r5l_payload_flush) +
>   				(sector_t)le32_to_cpu(payload_flush->size);
> -			if (mb_offset + payload_len >
> -			    le32_to_cpu(mb->meta_size))
> +			if (payload_len > meta_size - mb_offset)
>   				return -EINVAL;
>  =20
>   			count =3D le32_to_cpu(payload_flush->size) / sizeof(__le64);
> @@ -2130,13 +2181,18 @@ r5c_recovery_analyze_meta_block(struct r5l_log *l=
og,
>   		}
>  =20
>   		/* DATA or PARITY payload */
> -		payload_len =3D sizeof(struct r5l_payload_data_parity) +
> -			(sector_t)sizeof(__le32) *
> -			(le32_to_cpu(payload->size) >> (PAGE_SHIFT - 9));
> -		if (mb_offset + payload_len > le32_to_cpu(mb->meta_size))
> +		if (type !=3D R5LOG_PAYLOAD_DATA && type !=3D R5LOG_PAYLOAD_PARITY)
> +			return -EINVAL;
> +
> +		if (mb_offset + sizeof(*payload) > meta_size)
> +			return -EINVAL;
> +
> +		payload_len =3D r5l_recovery_payload_data_parity_len(conf, payload,
> +					type =3D=3D R5LOG_PAYLOAD_PARITY);
> +		if (payload_len > meta_size - mb_offset)
>   			return -EINVAL;
>  =20
> -		stripe_sect =3D (le16_to_cpu(payload->header.type) =3D=3D R5LOG_PAYLOA=
D_DATA) ?
> +		stripe_sect =3D (type =3D=3D R5LOG_PAYLOAD_DATA) ?
>   			raid5_compute_sector(
>   				conf, le64_to_cpu(payload->location), 0, &dd,
>   				NULL)
> @@ -2183,7 +2239,7 @@ r5c_recovery_analyze_meta_block(struct r5l_log *log=
,
>   			list_add_tail(&sh->lru, cached_stripe_list);
>   		}
>  =20
> -		if (le16_to_cpu(payload->header.type) =3D=3D R5LOG_PAYLOAD_DATA) {
> +		if (type =3D=3D R5LOG_PAYLOAD_DATA) {
>   			if (!test_bit(STRIPE_R5C_CACHING, &sh->state) &&
>   			    test_bit(R5_Wantwrite, &sh->dev[sh->pd_idx].flags)) {
>   				r5l_recovery_replay_one_stripe(conf, sh, ctx);
> @@ -2191,7 +2247,7 @@ r5c_recovery_analyze_meta_block(struct r5l_log *log=
,
>   			}
>   			r5l_recovery_load_data(log, sh, ctx, payload,
>   					       log_offset);
> -		} else if (le16_to_cpu(payload->header.type) =3D=3D R5LOG_PAYLOAD_PARI=
TY)
> +		} else if (type =3D=3D R5LOG_PAYLOAD_PARITY)
>   			r5l_recovery_load_parity(log, sh, ctx, payload,
>   						 log_offset);
>   		else

--=20
Thanks,
Kuai
