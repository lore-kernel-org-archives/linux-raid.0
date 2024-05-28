Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 605C12629C
	for <linux-raid@vger.kernel.org>; Tue, 28 May 2024 07:41:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716882084; cv=none; b=khxVZanPrK/USwZfhg3CKw3NbvXRkSSN6HANke5cKgB3iwCHtk+9rDp9gOQPVOwNGg70yAduu8f3tZEqMXfqRDOx8agzUr7wHX3G4qbxrXuS0oKqlrFi78+GJyYX50wSgdiE1Fm6rk8COOdIemfEXN4G7VqJsjzH0JAaIQamLPA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716882084; c=relaxed/simple;
	bh=dkasDBFl1CDTKlqaDSuNS8HGiRqjEmRFp+w09us/E0E=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=IvWer6lZhwyTQnaT/15RjtfBTDowTiheHDdxgQJRFnAuFN3Aldmk7R4R1jkkxbzjzFnZx3uto1li51FK+TVJLX5eiYnrhFpTitLEHbxYSPkAhlSijhT59B0hZ9h7mZmamMLlcW1K5RQgOwtmLeFF/Dz0vJGN5KsVmI6iidSwzUQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=S86rTDZ7; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="S86rTDZ7"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1716882082;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7cs/ZoasGYzFAFOQSLR0pQ93xtfZ+Jjd+aeNVm2B53k=;
	b=S86rTDZ7GVHX2NZSr89Ktx5V065QdQ8//n+hYRhzS0xwTYFWwZyuKE8m4U7a3ydVA96ZxH
	8I3aYPtOX4PTnziWozH2t9WAZ8xZxjCqW+KQiUoJ54v5436Y52wrwdyhfYmX5mFPcqCaR+
	gY2+9q21csmqxipKUgc10FchVl0hmsg=
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com
 [209.85.216.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-594-UUQMkRBUOpOpNVZMQQV7_A-1; Tue, 28 May 2024 03:41:20 -0400
X-MC-Unique: UUQMkRBUOpOpNVZMQQV7_A-1
Received: by mail-pj1-f71.google.com with SMTP id 98e67ed59e1d1-2bf5bba344fso522466a91.2
        for <linux-raid@vger.kernel.org>; Tue, 28 May 2024 00:41:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716882079; x=1717486879;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7cs/ZoasGYzFAFOQSLR0pQ93xtfZ+Jjd+aeNVm2B53k=;
        b=AUqHe7I1Q5FSyDOhuumppIwtX6FhWKeXo89JL1N+W+KF2Snfy0e3hxmymf9QVqhjvk
         6nieiR/47h0NbtVUWab6ZFlVh0YeVD1TNLbmepaHAp7+2+RPP+BHxy62mQ1JfFD/McLD
         tMeFrL3emODB5KZMSGc4kQwksX5L2wNCH+Ey4sib7fn2k1SLXC/SWLmTAPhxIzxTcZUm
         ADkBl6cvUbTbFEeangVBEGa1taggYeFHwBkgAf81dsdb3nPcMNU4WJiU8eg2Gp63VFNk
         GF4XYJCXtAARZwq5RcmmDMC4HSIYhqNZiM5OwWGdxw1Ozu1J7TOs3CgpnucqnksTAjOZ
         ZlLw==
X-Forwarded-Encrypted: i=1; AJvYcCUtNaF6NOKe1t6pxXifRDmfIyW0ggrQqrZsIWpLBH3ifCLNnbXc8c1dwDuDHQn/nrgD0geMwbwzWEjYZfjGC24aytPLe2RBrBDtNQ==
X-Gm-Message-State: AOJu0YxuuWsUGm3sovvEwy8PaWm5MWN1M4AvaNtvJNpi7Lc9FqLfoQQU
	KXFD3ZaG+ASwn+M0yvJif0mJjtz54viCWw3Xpn2lpjaxzfHXjVhEU4TgcKYAfLfxz0bRAa7h/bn
	U4+s7X5gHSzb5DeAd0Gd3fmZTwsPHST8QZAqkSRg3fCK+EVnoDm+noDWQ5+hZc92C8oabF3SBya
	PjZ5dMVfLkWgif5HbDLJTiVzxxpCOOT08T/A==
X-Received: by 2002:a17:90a:c28e:b0:2bd:f24e:aee8 with SMTP id 98e67ed59e1d1-2bf5f208093mr11776989a91.38.1716882079239;
        Tue, 28 May 2024 00:41:19 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IERUWX2eJ3EwtqnKnLYeWQ8av8IKt4bL93HZiPaVi3ZvFr+D5j+pGx1jf/nd6fyU7EKNnh6jvil21OMtgMD6F4=
X-Received: by 2002:a17:90a:c28e:b0:2bd:f24e:aee8 with SMTP id
 98e67ed59e1d1-2bf5f208093mr11776976a91.38.1716882078835; Tue, 28 May 2024
 00:41:18 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240528022903.20039-1-xni@redhat.com> <20240528090935.00002526@linux.intel.com>
In-Reply-To: <20240528090935.00002526@linux.intel.com>
From: Xiao Ni <xni@redhat.com>
Date: Tue, 28 May 2024 15:41:07 +0800
Message-ID: <CALTww28fH49J7oDw-JAVzDemRPYxBcj63pgf13ZAK+b0687LTw@mail.gmail.com>
Subject: Re: [PATCH 1/1] mdadm/platform-intel: Fix buffer overflow
To: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
Cc: blazej.kucman@intel.com, linux-raid@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, May 28, 2024 at 3:09=E2=80=AFPM Mariusz Tkaczyk
<mariusz.tkaczyk@linux.intel.com> wrote:
>
> On Tue, 28 May 2024 10:29:03 +0800
> Xiao Ni <xni@redhat.com> wrote:
>
> > It reports buffer overflow detected when creating raid with big
> > nvme devices. In my test, the size of the nvme device is 1.5T.
> > It can't reproduce this with nvme device which size is smaller
> > than 1T.
>
> Hi Xiao,
>
> Size of disks should have nothing to do with this. We are just parsing sy=
sfs.
> Weird..

Maybe you're right. The test shows the size affect the result.
>
> >
> > In function get_nvme_multipath_dev_hw_path it allocs memory in a for
> > loop and the size it allocs is big. So if the iteration number is
> > large, it has a risk that the stack space is larger than the limit.
> > So move the memory allocation at the biginning of the funtion.
>
> I would expect that memory is deallocated after each loop but the fix
> is correct and I'm willing to take this because obviously it is a fix for
> something.

If the memory is deallocated after each loop. The comments in this
patch are not right.

>
> I don't understand the problem but I trust you. Maybe varied size stack a=
rray is
> a problem?

Let me explain more in detail. It's a strange problem. It only can
happen with the mdadm rpm package which is built already. If I install
src.rpm and build it locally, the problem can't happen. So I added
logs to narrow the problem. Finally, it prints the log in the loop and
doesn't print log when is before returning from this function. So the
memory allocation is suspicious and I tried with the patch and it can
fix this problem.

>
> Probably, enough would be to just replace [strlen(dev_path) +
> strlen(ent->d_name) + 1] by [PATH_MAX] but I'm quite confused why it is a=
n
> issue at all.
>
> LGTM. Please fix typos raised by Paul and I will merge it.

Ok, I'll wait for a bit to give more time to talk about this problem.

Best Regards
Xiao
>
> Thanks,
> Mariusz
>
> >
> > Fixes: d835518b6b53 ('imsm: nvme multipath support')
> > Reported-by: Guang Wu <guazhang@redhat.com>
> > Signed-off-by: Xiao Ni <xni@redhat.com>
> > ---
> >  platform-intel.c | 4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> >
> > diff --git a/platform-intel.c b/platform-intel.c
> > index 15a9fa5a..0732af2b 100644
> > --- a/platform-intel.c
> > +++ b/platform-intel.c
> > @@ -898,6 +898,7 @@ char *get_nvme_multipath_dev_hw_path(const char *de=
v_path)
> >       DIR *dir;
> >       struct dirent *ent;
> >       char *rp =3D NULL;
> > +     char buf[PATH_MAX];
> >
> >       if (strncmp(dev_path, NVME_SUBSYS_PATH, strlen(NVME_SUBSYS_PATH))=
 !=3D
> > 0) return NULL;
> > @@ -907,14 +908,13 @@ char *get_nvme_multipath_dev_hw_path(const char
> > *dev_path) return NULL;
> >
> >       for (ent =3D readdir(dir); ent; ent =3D readdir(dir)) {
> > -             char buf[strlen(dev_path) + strlen(ent->d_name) + 1];
> >
> >               /* Check if dir is a controller, ignore namespaces*/
> >               if (!(strncmp(ent->d_name, "nvme", 4) =3D=3D 0) ||
> >                   (strrchr(ent->d_name, 'n') !=3D &ent->d_name[0]))
> >                       continue;
> >
> > -             sprintf(buf, "%s/%s", dev_path, ent->d_name);
> > +             snprintf(buf, PATH_MAX, "%s/%s", dev_path, ent->d_name);
>
> >               rp =3D realpath(buf, NULL);
> >               break;
> >       }
>

