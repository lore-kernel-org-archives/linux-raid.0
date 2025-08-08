Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE1E31C84BD
	for <linux-raid@vger.kernel.org>; Fri,  8 Aug 2025 05:29:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754630942; cv=none; b=QRH/IFiYwte9AKhUo8zKu0Fgn9fKhbU8F0vXIG8/nvJQDuqRLzCslJ3pieUwGC9uU134BAwPDZ50yVvL63Ih+vGNfkObLyKzcyn7yEwPgb5sMOkijNJmr7GxqBXj7NFVdd9j/a/g1sOOMO53/hDY+7b10HbvtN3M1a4C0JQ9wOA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754630942; c=relaxed/simple;
	bh=vWj/d81z/Kjvo33244atbdl5vxvzWU9cVbFWgG3z7Gw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=M/lXfFstqOEnBcXbViFsnD0DVLZeaBv2QA3TXRrTMQ2Yl+mtEH0sm3pnUcPTCQ0DXBqKsMVwJ1rhWMx+4RBr0Fa8mvJyTVlx8lBXgC6B87zA+TtUMV8xW8clzJAC+c1yYhGJTJ6nugeChuwzzLgoS+Sf84MNYW2j66awkSnGSyY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=NMTVWusC; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="NMTVWusC"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1754630939;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=vWj/d81z/Kjvo33244atbdl5vxvzWU9cVbFWgG3z7Gw=;
	b=NMTVWusCs3gepFAMIZAq4iIPkwq1hmb6Whd0ksHYV0mfYW0HIlOvy5aTl55urzZPNzpWfH
	0eDPv1l4bKkfcGtuz3DZ9lLCNRqkZqYUz8daIFFHNdmckteXweW937TZVGecUsleixdd5y
	KCL05YNP7FkmTCVA5obtWxLxBE0RkdQ=
Received: from mail-lj1-f200.google.com (mail-lj1-f200.google.com
 [209.85.208.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-456-9_ZLJZn-OCyjneiUY1uEsg-1; Fri, 08 Aug 2025 01:28:57 -0400
X-MC-Unique: 9_ZLJZn-OCyjneiUY1uEsg-1
X-Mimecast-MFC-AGG-ID: 9_ZLJZn-OCyjneiUY1uEsg_1754630936
Received: by mail-lj1-f200.google.com with SMTP id 38308e7fff4ca-3323e8acc19so6870791fa.1
        for <linux-raid@vger.kernel.org>; Thu, 07 Aug 2025 22:28:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754630936; x=1755235736;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vWj/d81z/Kjvo33244atbdl5vxvzWU9cVbFWgG3z7Gw=;
        b=Etp2FWKXeKWHU1cubMMuUws5715exi5yYf/xYQIb0SgQzU/9PKvSMGRJmWgl5xxGit
         Os564p7AD1gyLwf/IweA9wWopTxwUr7kNMrvi4GUWjINXUiAbr8M4Tt6enJ+AxBeU/j9
         U5XmW1PH2irHCAG9LyMcl9VY8JGiroVLy0MUA7y5iOjZG6FGwCZNaeLaA3hRE3A2Myd4
         UQuM7LdBRxZl98o3Y/QFZpUy+K9wzlwxwS2JvsdaCB0fTcZWsUMuy3UANvF0AqXyo2pv
         /V1ZS5DrmNi7YwyUsW/8pv4eDjcLuFc+bCEDXMf/9mmgVGG56y+PgDOe0t04PKJOGPLx
         6qeQ==
X-Forwarded-Encrypted: i=1; AJvYcCXwB9eitoz6yIomBnlFY5YXMzrMvasdvwuFkYdTJcdH8QSqB9hPi8Lj108R2Ey0SOvsvrNCuxDfo0qh@vger.kernel.org
X-Gm-Message-State: AOJu0YzfBIuMQ7Xe7FZCH8SSnDbLSyu0R/rFhoxaeokE/iSwAOXwSm3H
	CkgFe11V6YfeQT/xF8TYq2sEDajkWDhjyKUqQ4pWIn6i3zIc6s32+wW1E29IAPCdsu7WWJnhdLE
	JmKI/9UAOZfRyMrse9Gl1l2oxPk2z0sZT+OkOfO9n8bUO/veNmnNKHSZMHJ5F8tB+80L5StPkmJ
	mQxocWfzqJSrd4Z+pf+6t9EUhZrLsRqVIotWT8vA==
X-Gm-Gg: ASbGnctyQRSA1i3WLJx+H1CRQJjKi1GTJNIMQrOs6LfI81mGeLVkFbyis5ff2pMpC33
	Nc/g1VKSUxm0fB7wLO5OHsm5Gje2LeJMVa6I7r4NinIPPy1TKgtFH223KiGurlvkEoGS3SWS/b2
	tBJFqH5Q9wTwzE2aMqXco9gA==
X-Received: by 2002:a2e:a007:0:b0:32e:525:5141 with SMTP id 38308e7fff4ca-333a2191a95mr2183381fa.16.1754630936140;
        Thu, 07 Aug 2025 22:28:56 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHy+SIPG+5YRJsCxZIwFG5uQKZ4pZ2Jph1bf2Vg348p253kLSIERnXmyrg02qSC8u31q4WGtIq+aM1ruYMC8v8=
X-Received: by 2002:a2e:a007:0:b0:32e:525:5141 with SMTP id
 38308e7fff4ca-333a2191a95mr2183281fa.16.1754630935643; Thu, 07 Aug 2025
 22:28:55 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <f654db67-a5a5-114b-09b8-00db303daab7@redhat.com>
 <CALTww28TpRRTzjqsOXGoUrLHEk=ca85zRcDanGqgTyytA-34ow@mail.gmail.com>
 <CAMw=ZnTosW4OecBCFdVNqiw9VjSL6msUx6yYBE=9vsEn7JeKqA@mail.gmail.com> <8c1bf191-a741-cd7a-29dc-babf24a13777@redhat.com>
In-Reply-To: <8c1bf191-a741-cd7a-29dc-babf24a13777@redhat.com>
From: Xiao Ni <xni@redhat.com>
Date: Fri, 8 Aug 2025 13:28:43 +0800
X-Gm-Features: Ac12FXx_szRnfLvWqVmX7fChDWiRVeMdCUHlwpb89nqhsVr7YPTZIQtRQsfuiDU
Message-ID: <CALTww28y-cuJMAGfWjgVdjhkFB8w-z7SR48nNvdRHM01L0TGow@mail.gmail.com>
Subject: Re: md regression caused by commit 9e59d609763f70a992a8f3808dabcce60f14eb5c
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Luca Boccassi <luca.boccassi@gmail.com>, Yu Kuai <yukuai3@huawei.com>, 
	Song Liu <song@kernel.org>, linux-raid@vger.kernel.org, vkuznets@redhat.com, 
	yuwatana@redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Aug 7, 2025 at 10:18=E2=80=AFPM Mikulas Patocka <mpatocka@redhat.co=
m> wrote:
>
>
>
> On Thu, 7 Aug 2025, Luca Boccassi wrote:
>
> > On Thu, 7 Aug 2025 at 01:04, Xiao Ni <xni@redhat.com> wrote:
> > >
> > > Hi all
> > >
> > > It needs to use the latest upstream mdadm
> > > https://github.com/md-raid-utilities/mdadm/ which has fixed this
> > > problem. And for fedora, it hasn't updated to the latest upstream. So
> > > it has this problem. I'll update fedora mdadm to latest upstream.
> > >
> > > Best Regards
> > > Xiao
> >
> > Thank you for looking into it and providing a solution - however,
> > isn't it against the rules to break existing released userspace
> > components and requiring new versions to be released in order to use a
> > new kernel version? Is there any way this kernel patch could be
> > amended to avoid breaking the existing userspace as it is?
> >
> > Thanks
>
> I also think that the misbehavior should be fixed in the kernel.
>
> We shouldn't use arbitrary timeouts to clean up the sysfs entries, becaus=
e
> it would introduce race conditions.
>
> What about destroying the sysfs entries when the file descriptor is
> closed? (instead of on the STOP_ARRAY ioctl) That wouldn't interfere with
> other code trying to stop the array and it would make it work with the
> buggy mdadm that calls STOP_ARRAY and then tries to find the sysfs entrie=
s
> and then calls SET_ARRAY_INFO.
>
> Mikulas
>

Hi all

The assemble process is:
1. create array
2. stop it (STOP_ARRAY). Before the kernel change, del_gendisk is
called at the last release of mddev rather than in STOP_ARRAY ioctl
3. access /sys/block/md0/md

The kernel change tries to call del_gendisk in STOP_ARRAY. So /dev/md0
can be removed and no one can access it. If not, the array can be
created again because md supports create on open.

After the kernel change, the assemble process is:
1. create array
2. stop it (del_gendisk runs and /sys/block/md0 is removed)
3. acces /sys/block/md0/xx (it fails)

So del_gendisk destroys sysfs entries. If we destroy sysfs entries at
the last release of mddev, it will return to the old state that
/dev/md0 can be opened after stop. I don't want to return back.
Because some customers encounter bugs that shutdown is stuck because
/dev/md0 can't be stopped and the regression test usually fails
because of this too.

I know it's not good to break mdadm by a kernel change. But sometimes
it needs userspace tool and kernel work together to fix a problem,
right?
Sorry for bringing the problem, and thanks for the suggestions. Any
more good suggestions?

Best Regards
Xiao

