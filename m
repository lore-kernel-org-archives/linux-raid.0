Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4634B1B4236
	for <linux-raid@vger.kernel.org>; Mon, 26 May 2025 05:11:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748236315; cv=none; b=gvT0Yib0KHpJCYHhoN0ylOiX4aNE5A+G4DrbFau39eNAlEUzhxbhUxelBdaEKA4a8DqDywNKagzclKcPJepzaPCQdA9tKLqSI+tO/sdnNHU1Dx17Ajx+U2UIes2Iy92AGD15rTJUAFOXWUmqD8Pxs6NZp0zmNmmuqqPcNXYOk7k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748236315; c=relaxed/simple;
	bh=4DpoN7sYp3PTjm74hIgwij9fHOMm5aACDaenmUmgJOU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=S6TeAHyFFAu+ryUVqc6Qb8P0NO8mqIbgu8yR06gZSdcGmtJm0Mu7SLCRXy6y4ESQK2V7OdkoeAfg5NnaEZElhVlQ2PjVjBWCc5yySZwtIM5tDEZS62dr/u68vPN67xcyy/HFO3T/pkWWn33YBqrrPH0nGiIFei059lRM8MSuUVk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=eiVUT1ZS; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="eiVUT1ZS"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1748236313;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=hm8EFX3oBVzLtQdjE7Y+rPduhLbN0QlZeaN+4xj0avM=;
	b=eiVUT1ZSYOrxNy1nGe6i1LDzg5QlMp7r2p1qDFTHZuIxKYrFGM+jq0e3cf+s+cSvqiizqb
	zzbH1y4fGdm0FvA1hLTLv+wrJS+IuKmtpaNvArSOLnNIqWz/Cr2IPCXwjVFKz5rjDA/0Fh
	hVjvPmklW+ECzZLJBiGIqiTAJpHghow=
Received: from mail-lj1-f200.google.com (mail-lj1-f200.google.com
 [209.85.208.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-517-MCG12ZxDOs-sTuL0L_Jv0w-1; Mon, 26 May 2025 01:11:50 -0400
X-MC-Unique: MCG12ZxDOs-sTuL0L_Jv0w-1
X-Mimecast-MFC-AGG-ID: MCG12ZxDOs-sTuL0L_Jv0w_1748236309
Received: by mail-lj1-f200.google.com with SMTP id 38308e7fff4ca-328008020bcso8103391fa.0
        for <linux-raid@vger.kernel.org>; Sun, 25 May 2025 22:11:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748236309; x=1748841109;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hm8EFX3oBVzLtQdjE7Y+rPduhLbN0QlZeaN+4xj0avM=;
        b=Vub+pXhJXrlCNIT4PebAhN4XAt9nwCzQXZfAaKqdsLnv07QNUBJZub628R2auQdecQ
         raNHW1tRPOspPn2odoOx7GuCeH8aQx9rERV3sYPygeYRmtH5CQpgWu1rfJwd1GqM8UjI
         xTg3XPbBSY6iE4JUM9qy2/mrUlMA9ebMZYNlI890v/VO3+ejCbGPKmplp7ZvqZA4Mi8y
         j0F50z/K1mMaDd/OfquKfmhO/3Yk3Upn54dd5PuRYWliuQER9dFLm1O+BbLd8YaqeE7c
         s+kl1HK1EftQYzJ8vT06tQMs/35e2nfiXRN0M9XjkaXyclMG41cSGraHhfktAgqvRbjL
         HZFA==
X-Forwarded-Encrypted: i=1; AJvYcCUJ0BU+QG/CflGP3/pILUVJYcU7NGaVSiz08tEIbb7Nc2fbGeCpmhfv3azO+z+eHKvT33YPT0UWh9Su@vger.kernel.org
X-Gm-Message-State: AOJu0YxUGCKdW/S+Vb7eWvF8es+WjIeHMxMWI9kGRLXtj+n9AM9uJeEK
	cKK80wjcDlLencPlDfCVIPFbsuWmNPC2yxQMIQDkRezzLSuP8BIVPqkgc4C207lf115jV6OUmWX
	g4Mwdwn9/gbNwJ9amIrmQ4H4hAcGaNTr2hxsdJcq7xTFUWnz1ncMZwUTlxF2h6bHg273KRe62aK
	N8wgrJjvmhjZQ5FnQwQ8056kAHHGK+O4ncryC1VQ==
X-Gm-Gg: ASbGncsHZUswmCc5MYRg8Zv8LPLV+A2qX3CtC5tpEj97B/SZXO3awRuZfZ4IoeJJ/Jb
	M7W7Jh6ki2QwOsm7DrL/Y6yQAmHOcsdfXT8Dc/3HgXEdOvL3X9VYHF5FN9jOCpC6Ksl6qoQ==
X-Received: by 2002:a2e:a9a8:0:b0:30b:f775:bae0 with SMTP id 38308e7fff4ca-3295bb08af9mr20214781fa.36.1748236309198;
        Sun, 25 May 2025 22:11:49 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGkeoBBm0s8wnRag407w6g6VTzBbfotg1uM2hr4L9oZ5LkaVUSvEpg2AFicZaEQ2mVAlRAqBoEJbWU/D7JUBZA=
X-Received: by 2002:a2e:a9a8:0:b0:30b:f775:bae0 with SMTP id
 38308e7fff4ca-3295bb08af9mr20214621fa.36.1748236308703; Sun, 25 May 2025
 22:11:48 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250524061320.370630-1-yukuai1@huaweicloud.com>
 <20250524061320.370630-7-yukuai1@huaweicloud.com> <CALTww2_sxkU83=F+BqBJB29-gada2=sF-cZR98e5UiARJQuNjg@mail.gmail.com>
 <0e527b24-3980-2126-67f0-0958f2bc3789@huaweicloud.com>
In-Reply-To: <0e527b24-3980-2126-67f0-0958f2bc3789@huaweicloud.com>
From: Xiao Ni <xni@redhat.com>
Date: Mon, 26 May 2025 13:11:36 +0800
X-Gm-Features: AX0GCFv3eQO4frkeDpWCH9Sa5P5LFU16Bs3flExBAX3Dd3osDvI28iA3t2cmcC8
Message-ID: <CALTww2_wuO+uf2rf=VWvUChY1-zOdkoXPRT7dSLr69Nfkkoz8g@mail.gmail.com>
Subject: Re: [PATCH 06/23] md/md-bitmap: add a new sysfs api bitmap_type
To: Yu Kuai <yukuai1@huaweicloud.com>
Cc: hch@lst.de, colyli@kernel.org, song@kernel.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, yi.zhang@huawei.com, 
	yangerkun@huawei.com, johnny.chenyi@huawei.com, 
	"yukuai (C)" <yukuai3@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, May 26, 2025 at 9:14=E2=80=AFAM Yu Kuai <yukuai1@huaweicloud.com> w=
rote:
>
> Hi,
>
> =E5=9C=A8 2025/05/26 0:32, Xiao Ni =E5=86=99=E9=81=93:
> >> The api will be used by mdadm to set bitmap_ops while creating new arr=
ay
> > Hi Kuai
> >
> > Maybe you want to say "set bitmap type" here? And can you explain more
> > here, why does it need this sys file while creating a new array? The
> > reason I ask is that it doesn't use a sys file when creating an array
> > with bitmap.
>
> I do mean mddev->bitmap_ops here, this is the same as mddev->pers and
> the md/level api. The mdadm patch will write the new helper before
> running array.

+ if (s->btype =3D=3D BitmapLockless &&
+    sysfs_set_str(&info, NULL, "bitmap_type", "llbitmap") < 0)
+ goto abort_locked;

The three lines of code are in the Create function. From an intuitive
perspective, it's used to set bitmap type to llbitmap rather than
bitmap ops. And in this patch, it adds the bitmap_type sysfs api to
set mddev->bitmap_id. After adding some debug logs, I understand you.
It's better to describe here more. Because the sysfs file api is used
to set bitmap type. Then it can be used to choose the bitmap ops when
creating array in md_create_bitmap


> >
> > And if it really needs this, can this be gotten by superblock?
>
> Theoretically, I can, however, the bitmap superblock is read by
> bitmap_ops->create method, and we need to set the bitmap_ops
> first. And changing the framwork will be much complex.

After adding some debug logs, I understand you. Now the default bitmap
is "bitmap", so it can set bitmap ops in md_run->md_bitmap_create. If
it wants to use llbitmap, it needs to set bitmap type first. Then it
can set bitmap ops in md_run->md_bitmap_create.

And it's better to explain why it's a better choice to use bitmap_type
sys rather than reading from superblock. So in future, developers can
understand the design easily.

Regards
Xiao
>
> Thanks,
> Kuai
>
>

