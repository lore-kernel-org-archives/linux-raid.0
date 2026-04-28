Received: from va-2-27.ptr.blmpb.com (va-2-27.ptr.blmpb.com [209.127.231.27])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC6A63D6CD7
	for <linux-raid@vger.kernel.org>; Tue, 28 Apr 2026 08:55:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.27
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777366508; cv=none; b=SZC32NUrO8IcW9tPlitnGTXqsSJ6behzNGiyE/uREa2cWtDhkY4hKhYGFyrhpkzL20nvk/azvyKt2ZLhuQCSzjMGNxSpYLtuROtIuI9AhRA9S+Xi06SJF6H62wWMd4TRMbTqdEauXFPU6slWNEUfr7Cy2U/U1fWuAjiQ/YtkHNE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777366508; c=relaxed/simple;
	bh=gZUFngUbZIAqrEHmcSKDI6GWLW+68bJcHhX2QobUsLE=;
	h=Mime-Version:Subject:Date:Message-Id:In-Reply-To:References:From:
	 Content-Type:To; b=B+CcYOpF493DWEnUyO/zn5PAjAq82QTkP8K9yC37+aIPZeZzHPn1AEl871Xe3iXUpjueawTsgJ1niTnHoRHFmxgFmnzzTmvgeQpacQFxKr2kEfwkgErHYuNsq06DDgmNZfBDxi8rzRVNGXUIuIXv5UYXPW/NRAnceqN4ujeiStA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com; spf=pass smtp.mailfrom=fnnas.com; dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b=Qkdb1act; arc=none smtp.client-ip=209.127.231.27
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fnnas.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b="Qkdb1act"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fnnas-com.20200927.dkim.feishu.cn; t=1777366500;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=z9KQwfWfZudJmDcgaJBJv9Nfa1E5GKyBTx1njRbY6RU=;
 b=Qkdb1actdYd9KcFYZ+ErV8gl7Nbei7Pi6oER1HCW9gll497Ul5ePB/deVrHg6GH/flfv1d
 v4fLGy8F784ugb/Cjrh/biGmLdlakJvwW45OGSEdWBvNIEIj9DRpqsW1ZHP7PYpY31wFxY
 rhD7XS9hp9iOZmdu+fP38lm1a2MR6Snv7AmgIL5eyV/7Kcq8cLWaPdV++fBWhKn+hFoJ8n
 Rd1z114V7Se5sZIKx702tuK55G7xEtMHfCgVYb3Ej2+tMIyOrvqwO1j6FrWvDNbomBLRPC
 MEpyoCrgNu34Cx+QiePrQ/jLhnXRcP9UF+wgjQziNtq3FznmwPc+IWyTvtkjbg==
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Subject: Re: [PATCH] md/raid1: fix bio splitting in raid1 thread to avoid recursion and deadlock
Date: Tue, 28 Apr 2026 16:54:54 +0800
Message-Id: <2cf6f585-a0de-4c84-9cfc-05e1f6fde549@fnnas.com>
User-Agent: Mozilla Thunderbird
Content-Language: en-US
In-Reply-To: <20260427103446.300378-1-abd.masalkhi@gmail.com>
References: <20260427103446.300378-1-abd.masalkhi@gmail.com>
From: "Yu Kuai" <yukuai@fnnas.com>
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Received: from [192.168.1.104] ([39.182.0.183]) by smtp.feishu.cn with ESMTPS; Tue, 28 Apr 2026 16:54:56 +0800
To: "Abd-Alrhman Masalkhi" <abd.masalkhi@gmail.com>, <song@kernel.org>, 
	<shli@fb.com>, <neilb@suse.com>, <linux-raid@vger.kernel.org>, 
	<linux-kernel@vger.kernel.org>, <yukuai@fnnas.com>
X-Original-From: Yu Kuai <yukuai@fnnas.com>
X-Lms-Return-Path: <lba+269f075e1+f75392+vger.kernel.org+yukuai@fnnas.com>
Reply-To: yukuai@fnnas.com

Hi,

=E5=9C=A8 2026/4/27 18:34, Abd-Alrhman Masalkhi =E5=86=99=E9=81=93:
> Splitting a bio while executing in the raid1 thread can lead to
> recursion, as task->bio_list is NULL in this context.
>
> In addition, resubmitting an md_cloned_bio after splitting may lead to
> a deadlock if the array is suspended before the md driver calls
> percpu_ref_tryget_live(&mddev->active_io) on it's path to
> pers->make_request().

I don't understand, I agree this is problematic in the suspend case, but
what's wrong with task->bio_list being NULL? This can only cause the revers=
e
order because the split bio will submit first. However this is not a big de=
al
as this is the slow error patch.

If suspend is the only problem here, the simple fix is to add checking
in md_handle_request().

>
> Avoid splitting the bio in this context and require that it is either
> read in full or not at all.
>
> This prevents recursion and avoids potential deadlocks during array
> suspension.
>
> Fixes: 689389a06ce7 ("md/raid1: simplify handle_read_error().")
> Signed-off-by: Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>
> ---
> I sent an email about this issue two days ago, but at the time I was not
> sure whether it was a real problem or a misunderstanding on my part.
>
> After further analysis, it appears that this issue can occur.
>
> Apologies for the earlier confusion, and thank you for your time.
>
> Abd-Alrhman
> ---
>   drivers/md/raid1.c | 33 ++++++++++++++++++++++++---------
>   1 file changed, 24 insertions(+), 9 deletions(-)
>
> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
> index cc9914bd15c1..14f6d6625811 100644
> --- a/drivers/md/raid1.c
> +++ b/drivers/md/raid1.c
> @@ -607,7 +607,7 @@ static int choose_first_rdev(struct r1conf *conf, str=
uct r1bio *r1_bio,
>  =20
>   		/* choose the first disk even if it has some bad blocks. */
>   		read_len =3D raid1_check_read_range(rdev, this_sector, &len);
> -		if (read_len > 0) {
> +		if (read_len > 0 && (!*max_sectors || read_len =3D=3D r1_bio->sectors)=
) {
>   			update_read_sectors(conf, disk, this_sector, read_len);
>   			*max_sectors =3D read_len;
>   			return disk;
> @@ -704,8 +704,13 @@ static int choose_slow_rdev(struct r1conf *conf, str=
uct r1bio *r1_bio,
>   	}
>  =20
>   	if (bb_disk !=3D -1) {
> -		*max_sectors =3D bb_read_len;
> -		update_read_sectors(conf, bb_disk, this_sector, bb_read_len);
> +		if (!*max_sectors || bb_read_len =3D=3D r1_bio->sectors) {
> +			*max_sectors =3D bb_read_len;
> +			update_read_sectors(conf, bb_disk, this_sector,
> +					    bb_read_len);
> +		} else {
> +			bb_disk =3D -1;
> +		}
>   	}
>  =20
>   	return bb_disk;
> @@ -852,8 +857,9 @@ static int choose_best_rdev(struct r1conf *conf, stru=
ct r1bio *r1_bio)
>    * disks and disks with bad blocks for now. Only pay attention to key d=
isk
>    * choice.
>    *
> - * 3) If we've made it this far, now look for disks with bad blocks and =
choose
> - * the one with most number of sectors.
> + * 3) If we've made it this far and *max_sectors is 0 (i.e., we are tole=
rant
> + * of bad blocks), look for disks with bad blocks and choose the one wit=
h
> + * the most sectors.
>    *
>    * 4) If we are all the way at the end, we have no choice but to use a =
disk even
>    * if it is write mostly.
> @@ -882,11 +888,13 @@ static int read_balance(struct r1conf *conf, struct=
 r1bio *r1_bio,
>   	/*
>   	 * If we are here it means we didn't find a perfectly good disk so
>   	 * now spend a bit more time trying to find one with the most good
> -	 * sectors.
> +	 * sectors. but only if we are tolerant of bad blocks.
>   	 */
> -	disk =3D choose_bb_rdev(conf, r1_bio, max_sectors);
> -	if (disk >=3D 0)
> -		return disk;
> +	if (!*max_sectors) {
> +		disk =3D choose_bb_rdev(conf, r1_bio, max_sectors);
> +		if (disk >=3D 0)
> +			return disk;
> +	}
>  =20
>   	return choose_slow_rdev(conf, r1_bio, max_sectors);
>   }
> @@ -1346,7 +1354,14 @@ static void raid1_read_request(struct mddev *mddev=
, struct bio *bio,
>   	/*
>   	 * make_request() can abort the operation when read-ahead is being
>   	 * used and no empty request is available.
> +	 *
> +	 * If we allow splitting the bio while executing in the raid1 thread,
> +	 * we may end up recursing (current->bio_list is NULL), and we might
> +	 * also deadlock if we try to suspend the array, since we are
> +	 * resubmitting an md_cloned_bio. Therefore, we must be read either
> +	 * all the sectors or none.
>   	 */
> +	max_sectors =3D r1bio_existed;
>   	rdisk =3D read_balance(conf, r1_bio, &max_sectors);
>   	if (rdisk < 0) {
>   		/* couldn't find anywhere to read from */

--=20
Thansk,
Kuai
