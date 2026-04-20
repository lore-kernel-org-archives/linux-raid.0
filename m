Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E142F28641E
	for <linux-raid@vger.kernel.org>; Mon, 20 Apr 2026 07:34:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776670491; cv=none; b=dJwVuqfeFIHQQf2xFaSkwoVkxZoIcDMKtHkrDzcXP789gdlh4lXV4bXrGMLfh9zEftBF25XshG6J0fr/Cyer3RZgTICkSbrFa/B27N4sOTF6am90moIYEwTgNPDUHeWrVyIiURQdQqE7ivR17DfuQdo5VoQjpYTSDxLFIgQsX1s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776670491; c=relaxed/simple;
	bh=ThhjxKrotkPtOUDNuapQPQsZu7VdkC5wsW28mXApYRg=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=LstN071B9T96ZlqfzN+02v/zQQOdePKLp62L3wmrxAWAE1nDIvg1wzrqgGCYGJJN3WdElsor+jzGLVUrot4KFViQcFP0SmH2QEAcrxIFB0oa1AKLCV67pPc+J9qP+B02RcUTZQA1TSVsPlSJlNfr2sH7FgWMgppsluYqbvfeuts=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=cFirvEsc; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cFirvEsc"
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-48984d29fe3so3388045e9.0
        for <linux-raid@vger.kernel.org>; Mon, 20 Apr 2026 00:34:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776670488; x=1777275288; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:references
         :in-reply-to:subject:cc:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Lq5FJYhty33K0kfKJ+T3C26cIkBjDtBgsIpIlDMTtTY=;
        b=cFirvEsc7/xIPkErQ6FbYa7wG0uE2C5MpU3eA8w6FWlbtnMyCE3cJ2Ey/jAQrU/83Y
         E2AiDxF7QFJ4b7oQkB88UTos952XQdAC8gLsFCoPdEBVqCehVDrcb8peDG6TYl83KPW4
         QwdZwJHtZCge/2Qckg6snW4rpBEkBniGs4M9tVRK29D5UrKYOLG5L8GTLGprA8ZPyfCh
         k9cMdiMywUlDNbZO9H+eVB93KmB5lC+p5vTFIKri6jlrmss4pMCeNvlNq4tTlNwS3BlS
         dNKth/wMnvjEV2MRivu2LfJzMGj7oCoLlmWNwMU1dB5Ep7tZbFqFH6qZYoIX/i5sCDgf
         5EHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776670488; x=1777275288;
        h=content-transfer-encoding:mime-version:message-id:date:references
         :in-reply-to:subject:cc:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=Lq5FJYhty33K0kfKJ+T3C26cIkBjDtBgsIpIlDMTtTY=;
        b=S1cxEX7GLDa7qzP1x476Rsg7/2bO9sA8F8D/5So56Ih7HGX5DeK7pDO3I3Kk6GNqOP
         r73VHZtTTTReqooaTJQC/g4jglT8k+oVsYO39gZCKmXA0IdZie9VN4cFHWpZl+zvlSLE
         NkdYIKuHks43kPVKOV5Rd75Z+mVKBkVtvrykH+cC8IovEViHxubOidhqIEpG55XekOgD
         ihaq82bBgF2UNlSxO49kRFW0eYeP+L/O3hR2mkqw2jgYP3ohjbysV6NfhnoC9P/JVcBJ
         5+VefMdBI/W3B9wMr6wWi/kvBvLroRDeLaA/NrF++eSlrtitxOiU1FDDQC/xuknhQDf6
         SU0w==
X-Gm-Message-State: AOJu0YzrrEjjq7Q4W6TK8NywBCmMiSci+PyQFDCWmGn/YPMTpogJwQne
	miuHGCl919k8DRP6dlx2giGGVyWk22RVAs7prDUXIJSyXPQqW0S/qk5w
X-Gm-Gg: AeBDiet/Di8C49VCLtSKbXCALpzjHIN4U7H7NqUS2/Gn/7lohR67c3WC5yDmvDMPqoG
	9HaylgdSKpeaAtR6/8x0lo4fEYnH/JjmsmK4CqjIprpMJE8dAgBqgm13kokYI0JufRM1k9Ekl1Q
	r78CnoF64LuYXGRIcD/C9jl7iLl0QpBMISBk5bTb1lHPcLOz+IMlCn7CR2NB3l6NjL6tC1VKjed
	L3jIlpIYbc0K7JmwwP8ZymIqUX9zuwMY9cY+e1SwhNE3m2CNkSDclzO1swh00DfFGz2Nxgxytwr
	EeCPXrQU4quKVh7oJ51/gnX9E/CO5C3KlBM8VtpukgjLMcwgpnVGGt7pyIk5NW8S7iVSbga57Ji
	4CT/AQHbUZb2f6vRJLZIGUJRQyQM0riJCBUjP21SpzDXJkmXaIT/Bl+Agio2tmTjjFPK+byVKSz
	daQNCMniF1W/CbR1sHIp8uO2bO4VJAiI49ijp1UhNqZEka5JkUqvC4XCRMCHf1wZO0Pe9I4h1Yr
	/u2muXuRMok7g==
X-Received: by 2002:a05:600c:4895:b0:488:ffad:6728 with SMTP id 5b1f17b1804b1-488ffad67f4mr74690135e9.19.1776670488045;
        Mon, 20 Apr 2026 00:34:48 -0700 (PDT)
Received: from Abds-MacBook-Air.local ([2a02:3037:609:eca:2198:a7d3:5d4c:1f21])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-488fb7bf7besm92777985e9.34.2026.04.20.00.34.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Apr 2026 00:34:47 -0700 (PDT)
From: Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>
To: Yu Kuai <yukuai@fnnas.com>, song@kernel.org, linan666@huaweicloud.com
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, yukuai@fnnas.com
Subject: Re: [PATCH v2] md: use md_free_cloned_bio() in md_end_clone_io()
In-Reply-To: <36f8b219-140d-4d66-85f9-2522215f5a2b@fnnas.com>
References: <20260415081941.352389-1-abd.masalkhi@gmail.com>
 <36f8b219-140d-4d66-85f9-2522215f5a2b@fnnas.com>
Date: Mon, 20 Apr 2026 09:34:45 +0200
Message-ID: <m2jyu2kru2.fsf@gmail.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Hi Kuai,

On Sun, Apr 19, 2026 at 12:51 +0800, Yu Kuai wrote:
> Hi,
>
> =E5=9C=A8 2026/4/15 16:19, Abd-Alrhman Masalkhi =E5=86=99=E9=81=93:
>> md_end_clone_io() and md_free_cloned_bio() share identical teardown
>> logic. Use md_free_cloned_bio() in md_end_clone_io() for cleanup and
>> call bio_endio() afterwards.
>>
>> Signed-off-by: Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>
>> ---
>> Changes in v2:
>>   - Reuse md_free_cloned_bio() instead of introducing a new helper
>>   - Link to v1: https://lore.kernel.org/linux-raid/20260414103813.307601=
-1-abd.masalkhi@gmail.com
>> ---
>>   drivers/md/md.c | 13 +------------
>>   1 file changed, 1 insertion(+), 12 deletions(-)
>>
>> diff --git a/drivers/md/md.c b/drivers/md/md.c
>> index ac71640ff3a8..8565566a447b 100644
>> --- a/drivers/md/md.c
>> +++ b/drivers/md/md.c
>> @@ -9212,20 +9212,9 @@ static void md_end_clone_io(struct bio *bio)
>>   {
>>   	struct md_io_clone *md_io_clone =3D bio->bi_private;
>>   	struct bio *orig_bio =3D md_io_clone->orig_bio;
>> -	struct mddev *mddev =3D md_io_clone->mddev;
>> -
>> -	if (bio_data_dir(orig_bio) =3D=3D WRITE && md_bitmap_enabled(mddev, fa=
lse))
>> -		md_bitmap_end(mddev, md_io_clone);
>> -
>> -	if (bio->bi_status && !orig_bio->bi_status)
>> -		orig_bio->bi_status =3D bio->bi_status;
>> -
>> -	if (md_io_clone->start_time)
>> -		bio_end_io_acct(orig_bio, md_io_clone->start_time);
>>=20=20=20
>> -	bio_put(bio);
>> +	md_free_cloned_bio(bio);
>>   	bio_endio(orig_bio);
>> -	percpu_ref_put(&mddev->active_io);
>>   }
>>=20=20=20
>>   static void md_clone_bio(struct mddev *mddev, struct bio **bio)
>
> Same as I replied to v1,
> This patch is no longer needed after following patch:
> https://lore.kernel.org/r/20260408043548.1695157-1-bmarzins@redhat.com

Thanks, I'll drop this patch.
>
> --=20
> Thansk,
> Kuai

--=20
Best Regards,
Abd-Alrhman
