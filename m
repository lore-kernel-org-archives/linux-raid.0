Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DD22A59
	for <linux-raid@vger.kernel.org>; Thu, 24 Jul 2025 07:18:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753341501; cv=none; b=sD3R3880R0GzU3RR7/uXq5TwRCi8RmEOVEDX2BUFlKwcoJc+CodfT15VYc+aQ4hMneISn72LSN66OMI8gQ0J6eeuZFiByVleJKrxVmH6n4ECYut1xU3k7lgyTi8aWos+d4WJyE2MljsOrqPDcqe3B0UIV/bNFxvMerzmkcqEHyg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753341501; c=relaxed/simple;
	bh=qlEWIA62NRgOhhITR3pzy6EIQK5VxIZd6tbvcUqTUs4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=OGO76sp8NuVLianiEqIwsxGejYHqOtV1Q1sEpyYlycmcddFKmgUlaJtMSqTNAAiZbhocrJZxdzLACyB/Agla6r9BlMOQFL2XN2S6nReTSBb4JHi5By48q1bqNgiuKOPhR9rUPgUGRF+73uQ0cwS4vOz0GBBxGdFx5ho6KOsMspI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Xi8QWzeM; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Xi8QWzeM"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1753341496;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ucAcUI0oxjLLcTYAAp5xaRQcTTCmG7E8dOmD+w7aN5k=;
	b=Xi8QWzeMpmX/Xv6mlyWkQ8F3CvYn4R/uAQ4SFppG1OuVNVyv5D7MVaOBsYPpfFFhgkBf5k
	32KkV4dUwL4cLocXKy36tgFgAi7cgANr26pgn0gWA5AxNWWiOxzJiIGtDhL+4xA665pp2A
	3+2dDk9RxlB8ge/CnkQB4LaUf6dCxNk=
Received: from mail-lf1-f72.google.com (mail-lf1-f72.google.com
 [209.85.167.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-607-2KtvvpnXPzSK7hnYhThYLw-1; Thu, 24 Jul 2025 03:18:13 -0400
X-MC-Unique: 2KtvvpnXPzSK7hnYhThYLw-1
X-Mimecast-MFC-AGG-ID: 2KtvvpnXPzSK7hnYhThYLw_1753341492
Received: by mail-lf1-f72.google.com with SMTP id 2adb3069b0e04-553b70a3592so398013e87.2
        for <linux-raid@vger.kernel.org>; Thu, 24 Jul 2025 00:18:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753341492; x=1753946292;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ucAcUI0oxjLLcTYAAp5xaRQcTTCmG7E8dOmD+w7aN5k=;
        b=Dqu9bCNgEd/E09TGjI3p7txa7HEfa0C6iQ7DK2UC0VgTHJGETAUwifMFZi5E75J2qM
         q798GIPeXaXgf/iUwVPsBcVvhkx6ZNmO8Sf8VDt4Pj2gYY1mo6WFs+1b8iBWqO/YPkaF
         BJZx2+NJU4og72tzkTEHkUAsWupPJ3o1UgD1pL7qId5UU6seTW9O26rnqdec4ozvkauB
         UzQTNTdXkdFQlBzIONDHn6lkVm+o7vji7K78dkJYjjgbM1SMY10fxGnhZ9ONnC5rvVcJ
         ruvF0mfFSfg5Oy4GYL+/UofUqNL9x1uaeVmYuLTiK+o9HjOYMmxD5pT/zC0k/Vp1zuK4
         KAoA==
X-Forwarded-Encrypted: i=1; AJvYcCXTnf0O5zkFzdHsynjQxgxQj0weZhw2IkKm4H5PEJfmfKibY75FPNPU5UXW0vj5ocdxRSlgir1o4Lwb@vger.kernel.org
X-Gm-Message-State: AOJu0YxExBjCzFO/jAUk1lml3cIWEJhB59PyAp8vD4dWtkLdl+9Mh6d/
	UKBasBRr1d70w6e9L/MFWtfCAGYmwrcZQYs7XBEdpRh7l2btNT2U/tISlIRBko31TE/awfiOUln
	uVGgFJFFQwJpptxgsv2NxR8paYP2PbYEZml+qemMfRTxsTJyAKQftaUf/pAFe9hZnSqdWBvQhnj
	crhAOzyQ5P2UXEuIFIO8mjeZ1jFh8civcvN7Rh5w==
X-Gm-Gg: ASbGncvlkbXLGjQZ0Uy+AZBP3FRzLcPqRRJPwezrI1TQDQFYBtawevfsb/KLDm8woSb
	avQRCOf/H0tL5Yfb4wkdpldp2X6X/2w/aS3BInIth343L5RYqZGBRDKvXg4H91l5LCaD4Ow6oXe
	AHx0QFinjJMxRB04ezhi+Pgw==
X-Received: by 2002:a05:6512:24cc:20b0:553:d122:f8e1 with SMTP id 2adb3069b0e04-55a513a031cmr1469202e87.43.1753341492178;
        Thu, 24 Jul 2025 00:18:12 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFDb5edJwELvHRkbQZM+EcQjmIGAd+QEsxWwJrNVj551Ci8VvY5ZGjpkUXmT6yuDeKxiRjH9eRx9x8tewq3rHE=
X-Received: by 2002:a05:6512:24cc:20b0:553:d122:f8e1 with SMTP id
 2adb3069b0e04-55a513a031cmr1469191e87.43.1753341491697; Thu, 24 Jul 2025
 00:18:11 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAGVVp+X8GYS7yKkq-qxJ5hpTL=vHMBgG=wuSsNJZ0VrjQeMA6w@mail.gmail.com>
In-Reply-To: <CAGVVp+X8GYS7yKkq-qxJ5hpTL=vHMBgG=wuSsNJZ0VrjQeMA6w@mail.gmail.com>
From: Xiao Ni <xni@redhat.com>
Date: Thu, 24 Jul 2025 15:17:59 +0800
X-Gm-Features: Ac12FXyHq_9raNt2rbflET65oGnekZLLf2VwvrGVcrstswcV72irJhPwzEwl5qo
Message-ID: <CALTww2-_9saPOtLC0dXUhQiK+2eV739rjwX3K3KDAz6AgbE6Ug@mail.gmail.com>
Subject: Re: [bug report] mdadm: Unable to initialize sysfs
To: Changhui Zhong <czhong@redhat.com>
Cc: Linux Block Devices <linux-block@vger.kernel.org>, linux-raid@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Changhui

I guess you need to use the latest upstream mdadm. Could you have a
try with https://github.com/md-raid-utilities/mdadm/

Regards
Xiao

On Thu, Jul 24, 2025 at 3:07=E2=80=AFPM Changhui Zhong <czhong@redhat.com> =
wrote:
>
> Hello,
>
> mdadm fails to initialize the sysfs interface while attempting to
> assemble a RAID array,
> please help check and let me know if you need any info/test, thanks.
>
> repo: https://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux-block.g=
it
> branch: for-next
> INFO: HEAD of cloned kernel
> commit a8fa1731867273dd09125fd23cc1df4c33a7dcc3
> Merge: b41d70c8f7bf 5ec9d26b78c4
> Author: Jens Axboe <axboe@kernel.dk>
> Date:   Tue Jul 22 19:10:37 2025 -0600
>
>     Merge branch 'for-6.17/block' into for-next
>
> reproducer:
> # mdadm -CR /dev/md0 -l 1 -n 2 /dev/sdb /dev/sdc -e 1.0
> mdadm: array /dev/md0 started.
> # mdadm -S /dev/md0
> mdadm: stopped /dev/md0
> # mdadm -A /dev/md0 /dev/sdb /dev/sdc
> mdadm: Unable to initialize sysfs
> # rpm -qa | grep mdadm
> mdadm-4.4-2.el10.x86_64
>
> and not hit this issue with upstream kernel
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git
>
>
> Best Regards,
> Changhui
>

