Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7B3517E44A
	for <linux-raid@vger.kernel.org>; Fri, 15 Nov 2024 10:12:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731665529; cv=none; b=oh8jG7H2yvkxi46wq3lMhKM1uLgW+9kgJu7Q3UcIETwaBS7fSogl8RMkAWe1gYsQctA/JCSd1eanLiGMeJ7Ltt8XaOSGESyTZ7VeWI5hvNy3nUpXu5dAFhIr2e+mkvZI3DJyKci7O951O+c+erkprGIkNM+ZUmpQQwNNoXpTxJw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731665529; c=relaxed/simple;
	bh=cOkfFlgIXq1Y6b4imQ6l5uX0NI3ed8L97st2D95ZPA0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=HNmYh5q9I5nFc3hBtXDiYAMhcPh3y03vc0nlP5AJjizh8Alj6TEtIzYb31w6ayrGqCFn1mFe4e0YuE/0BWDOeA/GRkQhamRGur1dQOx3aajbtTRIQKstNuZ4DKSxW4lrAz2w0rJL5LV0ZB+CmZAk947hyt7h7iMiknWLMi7K1f4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Vx6XWItG; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Vx6XWItG"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1731665526;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cOkfFlgIXq1Y6b4imQ6l5uX0NI3ed8L97st2D95ZPA0=;
	b=Vx6XWItGekluG1jCw6QWXKQhsBXHZGXYZSah0q2Cy4cMBpwYlBAbgsX5lx+93lrn/pXKSm
	sWhyu2wZRuRfoukOttvHEUjAJhEDTsxAgDM1RDptYOvcGtEI8S0Q3AmPWt5XiIKVb2CN7d
	WH83tuItIFhxaYv+q4f244h5cJ3CGxQ=
Received: from mail-lj1-f199.google.com (mail-lj1-f199.google.com
 [209.85.208.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-651-e4E9raf-PYiWaf8fn_RwIA-1; Fri, 15 Nov 2024 05:12:05 -0500
X-MC-Unique: e4E9raf-PYiWaf8fn_RwIA-1
X-Mimecast-MFC-AGG-ID: e4E9raf-PYiWaf8fn_RwIA
Received: by mail-lj1-f199.google.com with SMTP id 38308e7fff4ca-2ff62914442so3009491fa.1
        for <linux-raid@vger.kernel.org>; Fri, 15 Nov 2024 02:12:05 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731665522; x=1732270322;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cOkfFlgIXq1Y6b4imQ6l5uX0NI3ed8L97st2D95ZPA0=;
        b=I6sd1f7UHbFF2aCcSVo90MHnyxtVgS2YZ2Bpk7lm2mzz18eEIDD6DK/EO5aUZWOaY7
         q+C6boPBb8qti+EepoJLWfNkRfVneKbOWGOWj7vz4TA84W4Ayr2nsMHDffPw8GMYUG44
         UIwwBw1ZyGNgM+9j9N43AzY7tCTf3U4nacm4fV2xnV1IYqOLvmdaY350Cy5Pa4ra3N8w
         H6nM5oMUsijb/S6MAw1chlYBLR8ePDEupAWIkuh6PyQA12z4dLip9nBExZ+bwlF4SDgn
         kXLc3pT/ZeeXCSV0658HHVHSQD7DvlEuogLrJX0IGC8GRsVLu5I5kTRXYCMrd4iEi6ZY
         tnLA==
X-Forwarded-Encrypted: i=1; AJvYcCUGgg78kiG8p8RTmPBkgDqm21J70T2/RHMVjJOcEkBNsnatTY5EZxWw2qetAntcdQzHDFF3LNJj5mo5@vger.kernel.org
X-Gm-Message-State: AOJu0YzWvH6qtpoju02vaydIK8aeORn9qj4H30hPiRmLjPkSITDy+nKd
	sj0XBeltxMhhJ076gGSgupN9lbrq8xLe6gB/7OUXd8ngQTEjUz1CkLwZW+KgLjrHae8yabB5wfc
	zjEjnyyyqEm+kNAz8NwRRD9/3N4bD6BAXBUXgv1JOV7Wd/mDbvv4mvz0j1NVYaGflwBn/ISke0A
	+AUJdaDJRL8rfSX6eDbaoxsUlSipCQf2Ee5Q==
X-Received: by 2002:a05:651c:905:b0:2ff:56a6:2992 with SMTP id 38308e7fff4ca-2ff60767c16mr12843031fa.37.1731665522327;
        Fri, 15 Nov 2024 02:12:02 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHP9da0O/vVE3fy8t6js4Lw+/PnHLC4WzOzeXgFomOecfiIIql8+P+kgx6xirXrt0LpC8KE397ewiOIhsF5z6I=
X-Received: by 2002:a05:651c:905:b0:2ff:56a6:2992 with SMTP id
 38308e7fff4ca-2ff60767c16mr12842771fa.37.1731665521916; Fri, 15 Nov 2024
 02:12:01 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <ADF7D720-5764-4AF3-B68E-1845988737AA@flyingcircus.io>
 <45d44ed5-da7c-6480-9143-f611385b2e92@huaweicloud.com> <9C03DED0-3A6A-42F8-B935-6EB500F8BCE2@flyingcircus.io>
 <DD99A1F0-56E7-473D-B917-66885810233E@flyingcircus.io> <78517565-B1AB-4441-B4F8-EB380E98EB0F@flyingcircus.io>
 <26403.59789.480428.418012@quad.stoffel.home> <5fb0a6f0-066d-c490-3010-8a047aae2c29@huaweicloud.com>
 <F8CEEB15-0E3C-4F67-951D-12E165D6CC05@flyingcircus.io> <B6D76C57-B940-4BFD-9C40-D6E463D2A09F@flyingcircus.io>
 <5170f0d2-cb0f-2e0f-eb5e-31aa9d6ff65d@huawei.com> <2b093abc-cd9a-0b84-bcba-baec689fa153@huaweicloud.com>
 <63DE1813-C719-49B7-9012-641DB3DECA26@flyingcircus.io> <F8A5ABD5-0773-414D-BBBC-538481BCD0F4@flyingcircus.io>
 <753611d4-5c54-ee0d-30ab-9321274fd749@huaweicloud.com> <9A0AE411-B4B8-424A-B9F6-AF933F6544F9@flyingcircus.io>
 <BE85CBCF-1B09-48D0-9931-AA8D298F1D6B@flyingcircus.io> <b2a654e7-6c71-a44e-645c-686eed9d5cd8@huaweicloud.com>
 <240E3553-1EDD-49C8-88B8-FB3A7F0CE39C@flyingcircus.io> <12295067-fc9a-8847-b370-7d86b2b66426@huaweicloud.com>
 <CALTww28iP_pGU7jmhZrXX9D-xL5Xb6w=9jLxS=fvv_6HgqZ6qw@mail.gmail.com>
 <09338D11-6B73-4C4B-A19A-6BDC6489C91D@flyingcircus.io> <C3A9A473-0F0E-4168-BB96-5AB140C6A9FC@flyingcircus.io>
 <0B1D29D1-523C-4E42-95F9-62B32B741930@flyingcircus.io> <4DA6F1FE-D465-40C7-A116-F49CF6A2CFF0@flyingcircus.io>
 <CALTww292Dwduh=k1W4=u+N2K6WYK7RXQyPWG3Yn-JpLY9QDbDQ@mail.gmail.com> <362DFCF4-14C5-464C-A73F-72C9A3871E2F@flyingcircus.io>
In-Reply-To: <362DFCF4-14C5-464C-A73F-72C9A3871E2F@flyingcircus.io>
From: Xiao Ni <xni@redhat.com>
Date: Fri, 15 Nov 2024 18:11:49 +0800
Message-ID: <CALTww280ztWNUW23-Y+8w_S4ZAR4UYdtAmZU4b_wLHjjpTRPJQ@mail.gmail.com>
Subject: Re: PROBLEM: repeatable lockup on RAID-6 with LUKS dm-crypt on NVMe
 devices when rsyncing many files
To: Christian Theune <ct@flyingcircus.io>
Cc: Yu Kuai <yukuai1@huaweicloud.com>, John Stoffel <john@stoffel.org>, 
	"linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, dm-devel@lists.linux.dev, 
	=?UTF-8?Q?Dragan_Milivojevi=C4=87?= <galileo@pkm-inc.com>, 
	"yangerkun@huawei.com" <yangerkun@huawei.com>, "yukuai (C)" <yukuai3@huawei.com>, 
	David Jeffery <djeffery@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 15, 2024 at 4:45=E2=80=AFPM Christian Theune <ct@flyingcircus.i=
o> wrote:
>
> Hi,
>
> > On 15. Nov 2024, at 09:07, Xiao Ni <xni@redhat.com> wrote:
> >
> > On Thu, Nov 14, 2024 at 11:07=E2=80=AFPM Christian Theune <ct@flyingcir=
cus.io> wrote:
> >>
> >> Hi,
> >>
> >> just a followup: the system ran over 2 days without my workload being =
able to trigger the issue. I=E2=80=99ve seen there is another thread where =
this patch wasn=E2=80=99t sufficient and if i understand correctly, Yu and =
Xiao are working on an amalgamated fix?
> >>
> >> Christian
> >
> > Hi Christian
> >
> > Beside the bitmap stuck problem, the other thread has a new problem.
> > But it looks like you don't have the new problem because you already
> > ran without failure for 2 days. I'll send patches against 6.13 and
> > 6.11.
>
> Great, thanks!
>
> What do I need to do to get patches towards 6.6?

Hi

This patch can apply to 6.6 cleanly. You can have a try on 6.6 with
this patch to see if it works.

Regards
Xiao
>
> Christian
>
> --
> Christian Theune =C2=B7 ct@flyingcircus.io =C2=B7 +49 345 219401 0
> Flying Circus Internet Operations GmbH =C2=B7 https://flyingcircus.io
> Leipziger Str. 70/71 =C2=B7 06108 Halle (Saale) =C2=B7 Deutschland
> HR Stendal HRB 21169 =C2=B7 Gesch=C3=A4ftsf=C3=BChrer: Christian Theune, =
Christian Zagrodnick
>

