Received: from lf-1-15.ptr.blmpb.com (lf-1-15.ptr.blmpb.com [103.149.242.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 679441DF248
	for <linux-raid@vger.kernel.org>; Wed, 11 Feb 2026 02:19:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.149.242.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770776379; cv=none; b=N3gBN4hM48hVF/vvFD56rCk6d1KTbLYoTP2PApQnr0ZgXwBLnmgQdeZGytyIA1gmJde0/iCxcyJLRARwtR0b7i1KBH6TV27WRSIi2MjFIS8wZFzhvGXlovX77DqvSOdXHv5X/rZ5/DNDC8+d8ahaLYzPNfC/g2WRrdz3EWoZqKc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770776379; c=relaxed/simple;
	bh=M6sYKEkfd7FnPZ01/dmJbXTelqYG0Nvh487JkkJnBd8=;
	h=In-Reply-To:Content-Type:To:From:Subject:Date:Message-Id:Cc:
	 Mime-Version:References; b=emdleRBZc/EzyuMfkEmDHJDv0e7SmoLckZQ6pgZ2WLS3INkWcLYlOmN33wHQSZ3SiX5WTsw8URMu2b975aiCjAgeJRtPn1t/FAozc2BTzafC3HiDpk/xij0QHtv2Y4AtK6aK5UfoT4CN6J3rGrRAAye8Siq6bkL+qiosOS8kguA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com; spf=pass smtp.mailfrom=fnnas.com; dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b=y+H5D2Bj; arc=none smtp.client-ip=103.149.242.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fnnas.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b="y+H5D2Bj"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fnnas-com.20200927.dkim.feishu.cn; t=1770776331;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=+5uLB/fQUMuew6zZUbroY+TSmTvcb+B5tLYLF+j949c=;
 b=y+H5D2BjUKhYymYslKgufZLcvCw2ZlDHA86GkgCPQ6SVlkPNFe0QtsIDBY1oGHuSw3bjnN
 cuCQXSFGJN+wk9MbbLz4qUViO4stX0BKSNDwWYEvUdTWL5nkIAuidqbbaKdyKY09XGFyck
 FBBldudlbYca9RE3F2JENhi4+5Ur/oHGwAQmdYicW6j7NU5aTkfLzyUBIPgGNULUzfK+SY
 nPAo6hA2zCmlBgQ9ioo6+f+Ap1unETDBykis4uJd1+AAV9H8yMYYgQRDUxhig+xZ6BSU2D
 B7uhkysqGDPY3Ftph4Zvo7xqmtiL98Wg1OxjLYMMtU5GZUdA+DhQ/dkpKN+irQ==
Reply-To: yukuai@fnnas.com
X-Lms-Return-Path: <lba+2698be709+9b7126+vger.kernel.org+yukuai@fnnas.com>
Content-Transfer-Encoding: quoted-printable
X-Original-From: Yu Kuai <yukuai@fnnas.com>
In-Reply-To: <20260206053826.37416-2-xni@redhat.com>
Content-Type: text/plain; charset=UTF-8
To: "Xiao Ni" <xni@redhat.com>
From: "Yu Kuai" <yukuai@fnnas.com>
Subject: Re: [PATCH 1/2] md/raid1: fix the comparing region of interval tree
Date: Wed, 11 Feb 2026 10:18:46 +0800
Message-Id: <02c05b44-ee43-44c0-ae39-d1c77d31158f@fnnas.com>
Cc: <song@kernel.org>, <linux-raid@vger.kernel.org>, 
	<linan666@huaweicloud.com>, <yukuai@fnnas.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
User-Agent: Mozilla Thunderbird
References: <20260206053826.37416-1-xni@redhat.com> <20260206053826.37416-2-xni@redhat.com>
Received: from [192.168.1.104] ([39.182.0.137]) by smtp.feishu.cn with ESMTPS; Wed, 11 Feb 2026 10:18:48 +0800
Content-Language: en-US

Hi,

=E5=9C=A8 2026/2/6 13:38, Xiao Ni =E5=86=99=E9=81=93:
> Interval tree uses [start, end] as a region which stores in the tree.
> In raid1, it uses the wrong end value. For example:
> bio(A,B) is too big and needs to be split to bio1(A,C-1), bio2(C,B).
> The region of bio1 is [A,C] and the region of bio2 is [C,B]. So bio1 and
> bio2 overlap which is not right.
>
> Fix this problem by using right end value of the region.
>
> Signed-off-by: Xiao Ni <xni@redhat.com>
> ---
>   drivers/md/raid1.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)

Perhaps also add a fix tag, with this:

Reviewed-by: Yu Kuai <yukuai@fnnas.com>

>
> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
> index 867db18bc3ba..a41b1ec3d695 100644
> --- a/drivers/md/raid1.c
> +++ b/drivers/md/raid1.c
> @@ -62,7 +62,7 @@ static int check_and_add_serial(struct md_rdev *rdev, s=
truct r1bio *r1_bio,
>   	unsigned long flags;
>   	int ret =3D 0;
>   	sector_t lo =3D r1_bio->sector;
> -	sector_t hi =3D lo + r1_bio->sectors;
> +	sector_t hi =3D lo + r1_bio->sectors - 1;
>   	struct serial_in_rdev *serial =3D &rdev->serial[idx];
>  =20
>   	spin_lock_irqsave(&serial->serial_lock, flags);
> @@ -453,7 +453,7 @@ static void raid1_end_write_request(struct bio *bio)
>   	int mirror =3D find_bio_disk(r1_bio, bio);
>   	struct md_rdev *rdev =3D conf->mirrors[mirror].rdev;
>   	sector_t lo =3D r1_bio->sector;
> -	sector_t hi =3D r1_bio->sector + r1_bio->sectors;
> +	sector_t hi =3D r1_bio->sector + r1_bio->sectors - 1;
>   	bool ignore_error =3D !raid1_should_handle_error(bio) ||
>   		(bio->bi_status && bio_op(bio) =3D=3D REQ_OP_DISCARD);
>  =20

--=20
Thansk,
Kuai
