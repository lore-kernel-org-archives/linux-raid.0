Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E7C11509AB
	for <linux-raid@vger.kernel.org>; Mon,  1 Jun 2026 05:51:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=170.10.133.124
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780293119; cv=pass; b=i8voTluY+hzOpHA0B//2uo4N3Un1Vh0qB1IVJXLc+/DJQkNCwBzypItZOIawUcPyW47UMF3AcBVZ6qZ8mbVoyo7oDL9xzI8qrRNi+ow1FccipSNxGqN70qLRXHt2g1/5uHuCzTRAJJQ2mT+YciaGSjzPwKrfKUwLSUyGEuUKtXQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780293119; c=relaxed/simple;
	bh=kDoDlHKjd3Z56PG40nf4Zg7CiExwtev+XZn+3B6UGPQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=dTrarszrrv55+PDogUEMVkVrz0MB3Be5pqIg8EIYvDldlIN4Mwjxnb7dDwkjWP1wnkyfnDdKknFwCBkaqZTHCcOmYGnJnBTDtm0I1OpmKCIjzOWB/gSViGFiupB/DMNbK0O+Vnfhs1lrk3M3kKsftKbVzwCAxt0LtUUiODi36CY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=FbY16wLd; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=kwKtFcrR; arc=pass smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="FbY16wLd";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="kwKtFcrR"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1780293117;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=nrzBtbcForKR5c5MwYYteuxOpqRrxaKnM3GmTaITGVg=;
	b=FbY16wLd3RtZVBqb1MS6lp4B/ygWKGe2JxGExYLIZe3gZ2lx/FFvOoLZA6iDZjQZHIA96/
	IaGnTz5coSOVL1Hi3xY7rLMHMHdNk7+3qZdNStAcpBzUnnvyZ7Rz0Olxw7kAcGZwIepQLV
	VX9DMyMS3LCU2KazYMAdYLMYlgOLC18=
Received: from mail-lj1-f197.google.com (mail-lj1-f197.google.com
 [209.85.208.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-472-auZ9cP31NGW_KuaqTUOTVw-1; Mon, 01 Jun 2026 01:51:55 -0400
X-MC-Unique: auZ9cP31NGW_KuaqTUOTVw-1
X-Mimecast-MFC-AGG-ID: auZ9cP31NGW_KuaqTUOTVw_1780293114
Received: by mail-lj1-f197.google.com with SMTP id 38308e7fff4ca-395ce2d20c2so52854131fa.3
        for <linux-raid@vger.kernel.org>; Sun, 31 May 2026 22:51:55 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1780293114; cv=none;
        d=google.com; s=arc-20240605;
        b=GS/Qhk9Vu++haa2CxKH1Tu6Kvn2qabMvAxXmeIv/cfsqGrpB97Zk7d4+gLKR+FpZpX
         gJk9Uj8Ynt4i21+wvxgwIGRNDx4yK3b3PRv3p0+VUb+tcJ093IEKlcItLPVV82IMvRNS
         xDcnJVvPW6tvRyjpJYJHON4FxoLDlAOGHFK8bx22Ef+32MelAyPjswxb8/nzOkWiQ3w4
         s84WEe6qVjNSSymeWNZaxqxpE8T7teEyKoc7znecq9pBoQ2DPl7qnS7SppzbkPMXCVa1
         zfOg6MzBnM+NZwB6H8lxXiHLDKk64TlVAZjqu5qan6b+0CwufJKqze1DODHPFerZimx0
         Z3Jw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=nrzBtbcForKR5c5MwYYteuxOpqRrxaKnM3GmTaITGVg=;
        fh=YxCaRjF9eEJ9Xg+LuyK0BszzBIgkQ/uZOKVUskkfJsI=;
        b=ZaIUURyGa0tYS21eKraNP0d+8S97jBs3AchDD9leHrvGnU2cKEVZekZfVbtFDcv9qq
         VKGoRQIOQdD59xaQOxy3XlGCCinWhJDVh4uBrN1goDccVcY/2cca5qfX40MkErjQPb4x
         Mdku4/pe2m3W6gz2sRWsW4RipKBBYu6lwiHSXwukclrCBOw0X3QAJSDSdN74166cAEn9
         ON88IlxlVemzk+mmdFNhFGdyezHaEZ1zc/x2VTK82yThn0u/EwxvuvA6B8KG1Aa1LuAd
         /2Azj5nvKyjiEW52TwJqST9Ze3nVErKh8taNY4EA5LiHakel8SzdcqtWatPW6Vta/C6h
         MgwA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1780293114; x=1780897914; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nrzBtbcForKR5c5MwYYteuxOpqRrxaKnM3GmTaITGVg=;
        b=kwKtFcrRtI99y0P3hIF+A3kKNuQuDb5FfODeekv6/e3AwTwOyTXFWXQnHZu3K09ako
         UO0BYjaYqEMmOkBCqIRbn7u6qo5UPg/62ktcSwT/CuL3lAOMKkQ49C0tI/kUGpzSHt5t
         osqgYd03LutHENaPRFiZ9DZu6me9VHS+o4L0LTmYRSl0GQn096XkWMX9T5qy9HKIdv9W
         WwpH0GXe0V3c6oonxU0REUK63fbiy3wepmuKUQCMEMpnV9JzdE/ZHYWHjmG0U6ITlvhG
         H1i2IJltBJZsAb0gfc7CYbXrt08UKgjIuhgELpDubapqkl6SBnbVal+Rkc+c13S/oeTw
         syxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780293114; x=1780897914;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=nrzBtbcForKR5c5MwYYteuxOpqRrxaKnM3GmTaITGVg=;
        b=HHWxw5kovEdrBejsG2SdFDy1QtlUXXxHnC9I8MjfbYxey8Ozylh95PJ5DJMdMzsGUX
         Jwi8gUNms2G5BxPZQ+X9ImmXzKx4Mtm1LuG44qFArDqe//xuo9pnyCyUfDM8uEy/mWJS
         iZv6hxe8lLJoCMMzcjZpV4o840Y/tdXCPv5fevEbXMXUC+vsYoKROkNo/IcRez9SwEXg
         iD+PTM1XcDYT65t0/pO9BygN3HX6v1ZyGpgPqlA9wSrvkgwzDb4AeWnkRKFL4ao6tGd1
         nCFpFWYEkG2dcs4RH6oPFUV59760d3ePPd78qodTo7/zm8D7vpwk1K9qP0xiPHniqumR
         FCtg==
X-Forwarded-Encrypted: i=1; AFNElJ9vqmQH1mUY+xB5YzkeLKMq5cpNbRt02N/bqKZXYkV5uohkeQxcamF2w3HuNXHtEWKJI54cxIvXH/cQ@vger.kernel.org
X-Gm-Message-State: AOJu0YxJ5tvPi/YyV9f2+ixUC0RQKanvMbxQaVY6ilm3+Gvf7T2HH/MX
	+AnnZUxntSuD7wNLENAc4N7T5ZQkK76T5iyay/rs5dKEhgQjGDb0Vv/yTYMD9SI00d/oSXbPXxr
	0IWpu0KEmOJcYO3psqa1KkvjCXFkNtf756Wjw+rcqpyqHhXkWP0Jjg0GUzSWfce40XW8lCrJ/NA
	EQLGzazVv4F42FSka8P/hrW9vqmHzANAunxegNj0htv7UZIg==
X-Gm-Gg: Acq92OHwSRd9H1BcuuHPHJlJZT+5Pak394nvNVlEyW3YcVON+xKVxyxqQWWarGgxbp0
	wMnADOHZ0yG/KgDL4oDhKNgYS7YUwrRPl0q/g78JDmRzD5qVWAuWTbq/vDsaz71XX84j5FUXB1c
	UAZFWLyfOvZLiBuF5wXuG9OdnVgXuLnf/LjctTVuxb3+R/E+zzzfjQFhzdTesrmBpGppfurXb8D
	FeNWlODeN2JDK70QbtXpx75DKlnDKAL7WQwd8gMdwdUXUV3Wnvl5LqLQxPj6SN0rfehdOTnUMiS
	sASTnx/hKH4m
X-Received: by 2002:a05:6512:39d5:b0:5aa:65a3:467f with SMTP id 2adb3069b0e04-5aa65a348e8mr2108558e87.0.1780293114206;
        Sun, 31 May 2026 22:51:54 -0700 (PDT)
X-Received: by 2002:a05:6512:39d5:b0:5aa:65a3:467f with SMTP id
 2adb3069b0e04-5aa65a348e8mr2108542e87.0.1780293113787; Sun, 31 May 2026
 22:51:53 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260529054308.2720300-1-hch@lst.de> <20260529054308.2720300-2-hch@lst.de>
In-Reply-To: <20260529054308.2720300-2-hch@lst.de>
From: Xiao Ni <xni@redhat.com>
Date: Mon, 1 Jun 2026 13:51:39 +0800
X-Gm-Features: AVHnY4LDd8B4ZYFQmWOJdCwY0XAZIkWRFEAw_bIny7HvPBKGoaqnr9oILNPNAL4
Message-ID: <CALTww2-29Pf_rzmx8FR6eaDp=11SRKEQ+UhbEKXLBMCKTjN8Ow@mail.gmail.com>
Subject: Re: [PATCH 1/2] md/raid1: cleanup handle_read_error
To: Christoph Hellwig <hch@lst.de>
Cc: Song Liu <song@kernel.org>, Yu Kuai <yukuai@fnnas.com>, Li Nan <linan122@huawei.com>, 
	Xiao Ni <xiao@kernel.org>, linux-raid@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, May 29, 2026 at 1:46=E2=80=AFPM Christoph Hellwig <hch@lst.de> wrot=
e:
>
> Unwind the main conditional with duplicate conditions and initialize
> variables at initialization time where possible.
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  drivers/md/raid1.c | 34 ++++++++++++++++------------------
>  1 file changed, 16 insertions(+), 18 deletions(-)
>
> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
> index 64d970e2ef50..8fad1692cf66 100644
> --- a/drivers/md/raid1.c
> +++ b/drivers/md/raid1.c
> @@ -2627,35 +2627,33 @@ static void handle_write_finished(struct r1conf *=
conf, struct r1bio *r1_bio)
>
>  static void handle_read_error(struct r1conf *conf, struct r1bio *r1_bio)
>  {
> +       struct md_rdev *rdev =3D conf->mirrors[r1_bio->read_disk].rdev;
> +       struct bio *bio =3D r1_bio->bios[r1_bio->read_disk];
>         struct mddev *mddev =3D conf->mddev;
> -       struct bio *bio;
> -       struct md_rdev *rdev;
>         sector_t sector;
>
>         clear_bit(R1BIO_ReadError, &r1_bio->state);
> -       /* we got a read error. Maybe the drive is bad.  Maybe just
> -        * the block and we can fix it.
> -        * We freeze all other IO, and try reading the block from
> -        * other devices.  When we find one, we re-write
> -        * and check it that fixes the read error.
> -        * This is all done synchronously while the array is
> -        * frozen
> -        */
>
> -       bio =3D r1_bio->bios[r1_bio->read_disk];
>         bio_put(bio);
>         r1_bio->bios[r1_bio->read_disk] =3D NULL;
>
> -       rdev =3D conf->mirrors[r1_bio->read_disk].rdev;
> -       if (mddev->ro =3D=3D 0
> -           && !test_bit(FailFast, &rdev->flags)) {
> +       /*
> +        * We got a read error. Maybe the drive is bad.  Maybe just the b=
lock
> +        * and we can fix it.
> +        *
> +        * If allowed, freeze all other IO, and try reading the block fro=
m other
> +        * devices.  If we find one, we re-write and check it that fixes =
the
> +        * read error.  This is all done synchronously while the array is
> +        * frozen.
> +        */
> +       if (mddev->ro) {
> +               r1_bio->bios[r1_bio->read_disk] =3D IO_BLOCKED;
> +       } else if (test_bit(FailFast, &rdev->flags)) {
> +               md_error(mddev, rdev);
> +       } else {
>                 freeze_array(conf, 1);
>                 fix_read_error(conf, r1_bio);
>                 unfreeze_array(conf);
> -       } else if (mddev->ro =3D=3D 0 && test_bit(FailFast, &rdev->flags)=
) {
> -               md_error(mddev, rdev);
> -       } else {
> -               r1_bio->bios[r1_bio->read_disk] =3D IO_BLOCKED;
>         }
>
>         rdev_dec_pending(rdev, conf->mddev);
> --
> 2.53.0
>
>

Yes, it's more readable. This patch is good to me.
Reviewed-by: Xiao Ni <xiao@kernel.org>

