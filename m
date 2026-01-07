Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 504BF29CE9
	for <linux-raid@vger.kernel.org>; Wed,  7 Jan 2026 03:36:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767756970; cv=none; b=Wt2sOQYurKr2qFrd9UIoMYrj3lPA4CXuXIVqE7Wi7JX8fENp8Mxw7T9l6avYnOnLDQfhv7Gv7G33bFYwry7EMiIEHommC5V0qM/56s0AWCq3RFyMH6C33/jtHAoiLgIJ86Fe5VqnCFdiriu41VEe12tvxahtAkPrfDXKQQDhQto=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767756970; c=relaxed/simple;
	bh=PMvlm7jwhmcWrQHKZcwlnond0IGD6wei76WSoI+zcfA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=qafy4ClEbjqJ/DBHaqANSByioXiBFU2zuhwp8ta2cp5pkyEc1R8T1B/xlMWMEH0ezQ2u8+Om31QxBeaz16VVjU4aaWkO9I7cUUvzTSHfqa6WQ1fA11eWIJf7N6Q/KFbc5AB2Dg77cX8NY4btsVR4Wekvfv2bJOWAnCkMbVJhLzM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=N25Hb8ad; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=B2ATgfL6; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="N25Hb8ad";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="B2ATgfL6"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1767756964;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wsIH2/Ut48S9VWBe58XDv3dr/sm2ZJE+2buaWbPynBQ=;
	b=N25Hb8adWB6QRXzC4I0dn0YBNIRORX0AQT+0jjUKaVoFc9HwvhYSyFdxdmmq2ZMW5/k2iy
	nawgM5uEaJusmKbnEK2GNgYcD5zveao2QIRL3K7C7x847O2ECfQ6V37RZj7p4eExAdcgyM
	IGUwOLzZ8S+4pyxbMb2FTCcS7WyrQDw=
Received: from mail-lf1-f70.google.com (mail-lf1-f70.google.com
 [209.85.167.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-104-gx7u6G-_PVqJ2g5Q7_IkRA-1; Tue, 06 Jan 2026 22:36:02 -0500
X-MC-Unique: gx7u6G-_PVqJ2g5Q7_IkRA-1
X-Mimecast-MFC-AGG-ID: gx7u6G-_PVqJ2g5Q7_IkRA_1767756961
Received: by mail-lf1-f70.google.com with SMTP id 2adb3069b0e04-59b70088327so167400e87.1
        for <linux-raid@vger.kernel.org>; Tue, 06 Jan 2026 19:36:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1767756961; x=1768361761; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wsIH2/Ut48S9VWBe58XDv3dr/sm2ZJE+2buaWbPynBQ=;
        b=B2ATgfL60sgT9KiwqiVdmF/+b6kDcOdMjv2EjIAfhil2uqP49bDPS9nzMDWtBR684E
         7xE52avaRHWV17Elj7QmxNtd5+qQW3UE33TmSiji2BrAE0K5uUqhuIVDLFQ7QcpTuEFT
         Aod3rNtEXkh9ZoUC02xl+06Bv7YiLschDNEv7qGKAlNipDo8YGd4cUx2pSGDRsoC3qAk
         jRzOWU33pZhCJcoOvd7MI/0FaBz9+dRUsLOHNL3J5VjbmSiyT0jfv1On1sf2O6Ow9HKz
         u9UT7ThBQGFiZWIKwwjJzFIyzBhK0kB1vwOXzGs0xW0u+ZDGTHhmiJkEwjSGWZN2PrWg
         Xrpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767756961; x=1768361761;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=wsIH2/Ut48S9VWBe58XDv3dr/sm2ZJE+2buaWbPynBQ=;
        b=P01+G3ax3+zjneJGOfEHZ2loJEDqbx5O5DYx4dKBB976OOhiUY6jF3dsQqbOV1xxgR
         lMVEJgfD6zBp4C8HXhkLXvkk/b18klk+KZaESkJU7r/TckgWqJvSDu/Nn/mLwb5nMM64
         8jhhAUnsa16nIxn24IyzvZKPBtKiRFShjoQwFnsR6xiZQOUacIpkyyIoH6BPlZfpFJnf
         1gdGXr0jcQ/eBzf8FkEiaGijW2lFuJUmgUGVXC1a+cJu6g3ozj/boc0qA7IAl8I/lbOH
         sBw5YfnmWEEsuB8m0L2B7Q2vAb6l68OH3/qk4taqM7hgeRLvL0NIoZ4+war7MOJ1sxci
         9A3w==
X-Forwarded-Encrypted: i=1; AJvYcCW4XPhbxz/VgXl9FOV/5EIGi7lSxGHStXK53SB8LUXPx5bA69oBIWt6HpFWQxe3PyyrODBaC6Gy4HvV@vger.kernel.org
X-Gm-Message-State: AOJu0YwpjVbkY9/xOCAtjqM3F7f97wmY/JbIgIRPgkrYjlVtJt0FGps2
	02I5V3UAP+SUVTOsSWH5SePKJHMqwBgTmiIzbFuasmEj90ovzlXoCYK9wJaRmKjPlGly+ddX1Qo
	rQXXgBlmnnE8jgZ9jDJmBmsyK7glfJt1LYam4oiMXFchbbboKfI0r2HdCQpebZEDgv0DJ0WNwUC
	f0C1QpK57CegVngIW71WfdzUNG3FXKcL+pewZRcDMMTMW/FC9xIoM=
X-Gm-Gg: AY/fxX4EcBrg/VHm9lkYa5T7cJzoB2I4j+lAf1mMWSE1FFyhJpHkzj1uTXsjNoojMoG
	SJhWZMpgBL7IKqyGGDfzs58678HwI4ok4BiNPzZtwacuSHQMUq9IDqD4OyOKIIQS/PE9DiqfWnU
	uZeAuc54ISmDEVvEA+K/Z/6+NvI/oZYI4RZFPlmc5VYsfOP9jyR5ri10SyamC7fpyg7zMBFlgRo
	59naqsC2pTYgox6CanR3aI1/bwAlKAifkT2retCE+e1ZAP8xordFAS8m+3awwFu4Rke9Q==
X-Received: by 2002:a05:6512:1096:b0:598:eecb:c891 with SMTP id 2adb3069b0e04-59b6f050af1mr273307e87.52.1767756960718;
        Tue, 06 Jan 2026 19:36:00 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGt31tr3Y8iRVU5JpyesdhQS4CNial+7DnGmVdJ2SQ54EAc2j9RkQDY0ERB/c20zK7l5c++KCwCDApOMIazB5w=
X-Received: by 2002:a05:6512:1096:b0:598:eecb:c891 with SMTP id
 2adb3069b0e04-59b6f050af1mr273296e87.52.1767756960282; Tue, 06 Jan 2026
 19:36:00 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <7944a042-2e1e-1487-1b42-529768afbbd0@huaweicloud.com> <0106019b9349bf39-5460c782-3d63-43cb-a56e-e34760ce51cd-000000@ap-northeast-1.amazonses.com>
In-Reply-To: <0106019b9349bf39-5460c782-3d63-43cb-a56e-e34760ce51cd-000000@ap-northeast-1.amazonses.com>
From: Xiao Ni <xni@redhat.com>
Date: Wed, 7 Jan 2026 11:35:47 +0800
X-Gm-Features: AQt7F2oggSjIk7pAGUDVeIEiPzCGoSIzp_xr25dJscysM8ex0_3zyHGejDIGu90
Message-ID: <CALTww282Kyg9ERXeSiY5Thd-O40vEXjAXsD8A2PxEsd-h-Cg3Q@mail.gmail.com>
Subject: Re: [PATCH v6 1/2] md: Don't set MD_BROKEN for RAID1 and RAID10 when
 using FailFast
To: Kenta Akagi <k@mgml.me>
Cc: linan666@huaweicloud.com, linux-raid@vger.kernel.org, 
	linux-kernel@vger.kernel.org, song@kernel.org, yukuai@fnnas.com, shli@fb.com, 
	mtkaczyk@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jan 6, 2026 at 8:30=E2=80=AFPM Kenta Akagi <k@mgml.me> wrote:
>
> Hi,
> Thank you for reviewing.
>
> On 2026/01/06 11:57, Li Nan wrote:
> >
> >
> > =E5=9C=A8 2026/1/5 22:40, Kenta Akagi =E5=86=99=E9=81=93:
> >> After commit 9631abdbf406 ("md: Set MD_BROKEN for RAID1 and RAID10"),
> >> if the error handler is called on the last rdev in RAID1 or RAID10,
> >> the MD_BROKEN flag will be set on that mddev.
> >> When MD_BROKEN is set, write bios to the md will result in an I/O erro=
r.
> >>
> >> This causes a problem when using FailFast.
> >> The current implementation of FailFast expects the array to continue
> >> functioning without issues even after calling md_error for the last
> >> rdev.  Furthermore, due to the nature of its functionality, FailFast m=
ay
> >> call md_error on all rdevs of the md. Even if retrying I/O on an rdev
> >> would succeed, it first calls md_error before retrying.
> >>
> >> To fix this issue, this commit ensures that for RAID1 and RAID10, if t=
he
> >> last In_sync rdev has the FailFast flag set and the mddev's fail_last_=
dev
> >> is off, the MD_BROKEN flag will not be set on that mddev.
> >>
> >> This change impacts userspace. After this commit, If the rdev has the
> >> FailFast flag, the mddev never broken even if the failing bio is not
> >> FailFast. However, it's unlikely that any setup using FailFast expects
> >> the array to halt when md_error is called on the last rdev.
> >>
> >
> > In the current RAID design, when an IO error occurs, RAID ensures fault=
y
> > data is not read via the following actions:
> > 1. Mark the badblocks (no FailFast flag); if this fails,
> > 2. Mark the disk as Faulty.
> >
> > If neither action is taken, and BROKEN is not set to prevent continued =
RAID
> > use, errors on the last remaining disk will be ignored. Subsequent read=
s
> > may return incorrect data. This seems like a more serious issue in my o=
pinion.
>
> I agree that data inconsistency can certainly occur in this scenario.
>
> However, a RAID1 with only one remaining rdev can considered the same as =
a plain
> disk. From that perspective, I do not believe it is the mandatory respons=
ibility
> of md raid to block subsequent writes nor prevent data inconsistency in t=
his situation.
>
> The commit 9631abdbf406 ("md: Set MD_BROKEN for RAID1 and RAID10") that i=
ntroduced
> BROKEN for RAID1/10 also does not seem to have done so for that responsib=
ility.
>
> >
> > In scenarios with a large number of transient IO errors, is FailFast no=
t a
> > suitable configuration? As you mentioned: "retrying I/O on an rdev woul=
d
>
> It seems be right about that. Using FailFast with unstable underlayer is =
not good.
> However, as md raid, which is issuer of FailFast bios,
> I believe it is incorrect to shutdown the array due to the failure of a F=
ailFast bio.

Hi all

I understand @Li Nan 's point now. The badblock can't be recorded in
this situation and the last working device is not set to faulty. To be
frank, I think consistency of data is more important. Users don't
think it's a single disk, they must think raid1 should guarantee the
consistency. But the write request should return an error when calling
raid1_error for the last working device, right? So there is no
consistency problem?

hi, Kenta. I have a question too. What will you do in your environment
after the network connection works again? Add those disks one by one
to do recovery?

Best Regards
Xiao

>
> Thanks,
> Akagi
>
> > succeed".
> >
> > --
> > Thanks,
> > Nan
> >
> >
>

