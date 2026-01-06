Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA82B325736
	for <linux-raid@vger.kernel.org>; Tue,  6 Jan 2026 08:00:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767686405; cv=none; b=s05KXmC1tEtedNAdFJ6JtqMUDR/zdYa+Ymy3ssl4MrgrHV6m9o893CoX8/9XjCnV3G2H2nY7B/Stmfc1XynZ1+tXI+LHhetpxVevbbbH5RRzmukb/WkBJsezqlNvglwENbkJh4N09Ah8YBDZJont66mAdcXZ6m7nmpZXAWvpQaE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767686405; c=relaxed/simple;
	bh=AKxQ+2Tp64aA4lJE+l/O09QnrY1uHrQIPTcy8Mg6CMQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=f9mHEuSzksU4mI42G/54xp5qKv9KHk3NyxasRz78M2VQlZeLxOk97dk4JfdxfyXdQYOrPanke04jpfmxB4opYpabWwYqcyp5paN4/nJLNyEazfKca9GHbWfmHivr7vs1NRokIXeCIHQZ0hiEL0DmpBOhXMlIJUE4V3Ws7nbZeyc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Z6CssiI9; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=o3mHSh8h; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Z6CssiI9";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="o3mHSh8h"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1767686402;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=slTaJD98Jqtk3r/LKOwETKI2w53XXQEumEwhV0g02Zc=;
	b=Z6CssiI9lbrA8IS5fOUQ0UK2BDSdcGjO7XG6aRpJHBoBFXQy0DJY1oK0jbjRY+238MUGXW
	yaj/fzRVgBjE1EGI1q0OhIo4QLmYCEcqN/e3gnbsGpVkEImSLZRxGNQmns1DXbc70Ca0kC
	UHMKS/zvBO97vOyghi7fKNhc4kw9PCw=
Received: from mail-lf1-f69.google.com (mail-lf1-f69.google.com
 [209.85.167.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-164-EglQpck_NSGz7RhrQE2o3w-1; Tue, 06 Jan 2026 02:59:58 -0500
X-MC-Unique: EglQpck_NSGz7RhrQE2o3w-1
X-Mimecast-MFC-AGG-ID: EglQpck_NSGz7RhrQE2o3w_1767686397
Received: by mail-lf1-f69.google.com with SMTP id 2adb3069b0e04-59b6a97e566so78189e87.1
        for <linux-raid@vger.kernel.org>; Mon, 05 Jan 2026 23:59:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1767686397; x=1768291197; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=slTaJD98Jqtk3r/LKOwETKI2w53XXQEumEwhV0g02Zc=;
        b=o3mHSh8hVp4fQ8dHI7h5UmqqGZEdO/sT2MATN4VNekVZov6TLt6lcPpt/uL77rkJvk
         Oj2JDQFk/wsnQa13l5G27qp0Vw14wG6pr0wv/5ySv+P/eELZZISRkujZM0rw8MLQbmAC
         b/WnZ83eI/4FOunmmBubhpmXC+3yvi2JBaa5xwzIQrhpq9v46H84iec4cbzRqni3rM2F
         jK55AnVEVQ5Pp5qWKfF4wr7Cfkn/SMIgtnoiRpqCPlfnnAWdL/72g7n6gyDnTDyNYvj1
         uLWDsGXhm2durOuSsZk0dqFJwFGl5OZnRVOIHIzOfbxaATEPGjxWXM9r2Hua+TT9r2pD
         oDAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767686397; x=1768291197;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=slTaJD98Jqtk3r/LKOwETKI2w53XXQEumEwhV0g02Zc=;
        b=FIS32wBCLkzxvqo9TC2WpMop6gtfZmWcygkhGRuiiEHe8hG2IoJ3f1ao+u4cFCoFDq
         Tb6DTjImUj4FaSXCGE7oexaVMPHnBiayAdWmNhskViUg16oUkRk1G5Hfc762SV73+BiX
         rwv4kicxrOiIO9DEIQ5Sf9KoDhOZkQhPp2Xy2V+gNMVoZx0nTSfd5gsQlfY37o7D8NNf
         AD87wWKsQrutvHqbI2pf3a/OrO8PyTQ0oA0hfY8IKYs2Me6CzwfIEeVYKGiGdt3cFfmg
         v9InDQ/m4AD4bsy1LG/TgJstWyZowCoGfMIWM5Vesl1HaOavqnH6QQkYFhQWOvhMTi7S
         kg/A==
X-Forwarded-Encrypted: i=1; AJvYcCWHApie0nR7/hn6/BpMyaE7jcDN4BSbk8iozGxnlIsgfDokUmdkPvDGS99NClSlEpJaelnFtt2s1cC5@vger.kernel.org
X-Gm-Message-State: AOJu0YyjwABw081V25774SaEXL4KIRcmm1w8T7GtaW0fQRXNXVjmzeCe
	D5liu+BUMMKfffbag3K7cYlPmtWfphK1Q4wkF7xHLuRp6OgLZI2F/O8EsLaWy3w6Y4uCafAz3Lx
	jNOMV0chjXzMJKwPaf37xSHs+H++i6eoMf4aL/scy1v4M0DY7dfyadwQjk9UBCjIkMfDROCIINw
	JJJjsxxKFl2h39PPlTijWcAa1NztoQlOxWq1+osw==
X-Gm-Gg: AY/fxX7/mHscJxJe2JH4o+5soVZJcWHrCjTVxQJespgjstc6Ep1CjmuDQfU14Frbo6l
	Tlw6j4gcfd1r2n/dduYrLrtv3IS1UEgBxU88tlG7MEHGc6d48gxjrfAjprJTrNNFl9/BD1wEGUj
	pIzz9A4NIZCxPrs81gOtgnDe/BctM6UoW9M/5oUe2XgKWWT85OawVgvnbWFHlaHbSKBbx/gjjvD
	kSB5+fvRapPWDP4eCQZuBkQG+MplWg9szMlOHNFsyq+QHeitFtFfiZyr9CUG54J6nyVVg==
X-Received: by 2002:a05:6512:10c3:b0:596:a540:c95f with SMTP id 2adb3069b0e04-59b6521c972mr809424e87.19.1767686396646;
        Mon, 05 Jan 2026 23:59:56 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHTqGFFCHyvt4cGLwz5Gw2nA6V25MmvNFu2kaKqrOxTVl+1ZfLDZ79lKGdp+Bnd/whYYNFJUufT0NS8aOthsjs=
X-Received: by 2002:a05:6512:10c3:b0:596:a540:c95f with SMTP id
 2adb3069b0e04-59b6521c972mr809413e87.19.1767686396165; Mon, 05 Jan 2026
 23:59:56 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260105144025.12478-1-k@mgml.me> <20260105144025.12478-2-k@mgml.me>
 <7944a042-2e1e-1487-1b42-529768afbbd0@huaweicloud.com>
In-Reply-To: <7944a042-2e1e-1487-1b42-529768afbbd0@huaweicloud.com>
From: Xiao Ni <xni@redhat.com>
Date: Tue, 6 Jan 2026 15:59:44 +0800
X-Gm-Features: AQt7F2rQ1QUDDYTLHcuTAnwfszzg3zzy2RwqoMfjsR_wUNdfPXI_QsvnU5UqE9s
Message-ID: <CALTww2_j--2wA16=eM=2V8XXghwWrH9ARwi9vizZ0TOT3LnXnA@mail.gmail.com>
Subject: Re: [PATCH v6 1/2] md: Don't set MD_BROKEN for RAID1 and RAID10 when
 using FailFast
To: Li Nan <linan666@huaweicloud.com>
Cc: Kenta Akagi <k@mgml.me>, Song Liu <song@kernel.org>, Yu Kuai <yukuai@fnnas.com>, 
	Shaohua Li <shli@fb.com>, Mariusz Tkaczyk <mtkaczyk@kernel.org>, linux-raid@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jan 6, 2026 at 10:57=E2=80=AFAM Li Nan <linan666@huaweicloud.com> w=
rote:
>
>
>
> =E5=9C=A8 2026/1/5 22:40, Kenta Akagi =E5=86=99=E9=81=93:
> > After commit 9631abdbf406 ("md: Set MD_BROKEN for RAID1 and RAID10"),
> > if the error handler is called on the last rdev in RAID1 or RAID10,
> > the MD_BROKEN flag will be set on that mddev.
> > When MD_BROKEN is set, write bios to the md will result in an I/O error=
.
> >
> > This causes a problem when using FailFast.
> > The current implementation of FailFast expects the array to continue
> > functioning without issues even after calling md_error for the last
> > rdev.  Furthermore, due to the nature of its functionality, FailFast ma=
y
> > call md_error on all rdevs of the md. Even if retrying I/O on an rdev
> > would succeed, it first calls md_error before retrying.
> >
> > To fix this issue, this commit ensures that for RAID1 and RAID10, if th=
e
> > last In_sync rdev has the FailFast flag set and the mddev's fail_last_d=
ev
> > is off, the MD_BROKEN flag will not be set on that mddev.
> >
> > This change impacts userspace. After this commit, If the rdev has the
> > FailFast flag, the mddev never broken even if the failing bio is not
> > FailFast. However, it's unlikely that any setup using FailFast expects
> > the array to halt when md_error is called on the last rdev.
> >
>
> In the current RAID design, when an IO error occurs, RAID ensures faulty
> data is not read via the following actions:
> 1. Mark the badblocks (no FailFast flag); if this fails,
> 2. Mark the disk as Faulty.
>
> If neither action is taken, and BROKEN is not set to prevent continued RA=
ID
> use, errors on the last remaining disk will be ignored. Subsequent reads
> may return incorrect data. This seems like a more serious issue in my opi=
nion.
>
> In scenarios with a large number of transient IO errors, is FailFast not =
a
> suitable configuration? As you mentioned: "retrying I/O on an rdev would
> succeed".

Hi Nan

According to my understanding, the policy here is to try to keep raid
work if io error happens on the last device. It doesn't set faulty on
the last in_sync device. It only sets MD_BROKEN to forbid write
requests. But it still can read data from the last device.

static void raid1_error(struct mddev *mddev, struct md_rdev *rdev)
{

    if (test_bit(In_sync, &rdev->flags) &&
        (conf->raid_disks - mddev->degraded) =3D=3D 1) {
        set_bit(MD_BROKEN, &mddev->flags);

        if (!mddev->fail_last_dev) {
            return;  // return directly here
        }



static void md_submit_bio(struct bio *bio)
{
    if (unlikely(test_bit(MD_BROKEN, &mddev->flags)) && (rw =3D=3D WRITE)) =
{
        bio_io_error(bio);
        return;
    }

Read requests can submit to the last working device. Right?

Best Regards
Xiao


>
> --
> Thanks,
> Nan
>

