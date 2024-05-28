Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EA1713AD0E
	for <linux-raid@vger.kernel.org>; Tue, 28 May 2024 07:57:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716883069; cv=none; b=hwkwUCyQe0AxhGLpBYMPRZiotAzQ2+TJOd5W/NC8Se7eKlYFiuvWrU1annV9BJisPEuSNzGLfTxOuFws/hywcsAobe3+Tvkqr2ZxoSeQaYzj9lrMTl58GKpU77jjdBbvLlmMs69LbJHDHXGqAMYjFsx7RaH4ae9LXVVbTZ1uKeo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716883069; c=relaxed/simple;
	bh=R5PoABHURjn7x9zC32zIbn7kacEnfOLsPC73neCTRQ8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=mTHAXBkhb3evOzv/WH2qoPsMeQ36AYUy+4tL3D8BbFbJUqEH8sf4fQcynIoS+yQ09iI96a5H/EOYP2/my5P6S77YCB0uLzZmxkV5ebWtVOStN1X3YPOjgt/UvtLG7amFEzA4HSeE1xRhPxDZRQ0HergS//uMdWdnqJIGDYZ05Vg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=dSnykw7U; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="dSnykw7U"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1716883066;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wdwp2hEanc6t4lXqSld2bRmasChapPNvDTtzIQxonKQ=;
	b=dSnykw7UNxv5PDIyjPS/D5kjq67igykEOwaYTBHjoeLqFx7niC3wmgh1ff0s/dLR++GmY3
	h/aKuBZG7O3ChlGvSc9gHSU0XnovYw8M3T1Ubog4lxb5gUDAjzQfYq/FFbTfyLZ5tl//gS
	GPKnZcG+s2+uNybScK7D5eNwEQNL+do=
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com
 [209.85.216.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-416-PhzAfmoMOhejDM-btEiXaQ-1; Tue, 28 May 2024 03:57:45 -0400
X-MC-Unique: PhzAfmoMOhejDM-btEiXaQ-1
Received: by mail-pj1-f70.google.com with SMTP id 98e67ed59e1d1-2bdb1490ac1so532903a91.3
        for <linux-raid@vger.kernel.org>; Tue, 28 May 2024 00:57:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716883064; x=1717487864;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wdwp2hEanc6t4lXqSld2bRmasChapPNvDTtzIQxonKQ=;
        b=q4ZBDr0YMYQUnlK0rCEfkPFyKrKXftun/DWc/InG189G3YqUXiiPtljeNgJ6f2VT0V
         qGlbtj1U7ivKamOPxmotX/JvnOkFN5DuWL3TcbOyR9M2MYoJLe2cbdxHxQa7HneNnLIi
         ulPpfD/4G3oTMgBP4DBYL9MHO97p5HvF2z5S5NN/LTABEWo18xY9W4nRPcceL5CYll3X
         9qLXNkTsjwUhgOMPETYVQeQ0TGP6vfCmYxwB0xge4a/s+tV1FmyjE28p1LOhXIi8/UfB
         0T+6QrgOlT0ysobb0kh3qzutfxRgmFs+5cJb567JVIr8nG7J82OuS6SrnKS5J5xXlXfB
         eDtg==
X-Forwarded-Encrypted: i=1; AJvYcCW9jHqk8a+ToS3uZNvg9PfQhR7dHAsh8NBmwWNVHluD+2+c9sFdYy+Rg9DLoNpCrKdroQoe9wn87HgPU1GEuV6LKJyODhs8vZiHNA==
X-Gm-Message-State: AOJu0YyggU4+Or8GffnO6mmM0e0rBdxpf08/XaRUitzc5Bf8WrnrWURw
	ZSe3pR7aAb9sfjl3Ni1ADi03iypLtd3FEsIh62FsmP2XQureSPFP4k/Hxc98AV7ogdoTDQmPNjw
	5tHEdK0cxc4Ir+qP5TKy+eaDOJYNr1qgy6ZQvY9lcSyNM3ziXJW/Gd80EDu9tizw+CpPy0p52JT
	xD0mYjQHJl8rizmKD8bUQHWSCDRO5oJshX5w==
X-Received: by 2002:a17:90b:3144:b0:2bd:ef6b:c33b with SMTP id 98e67ed59e1d1-2bf5e098717mr11747634a91.0.1716883063948;
        Tue, 28 May 2024 00:57:43 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHodTRA3aZWPT0M1Bs+T80UoNoltNUidEQEHrUXkoMQc6yuHKDYXwNNsDma//Ctj7JCJKyFo2yXOoCqeWKJmqs=
X-Received: by 2002:a17:90b:3144:b0:2bd:ef6b:c33b with SMTP id
 98e67ed59e1d1-2bf5e098717mr11747622a91.0.1716883063488; Tue, 28 May 2024
 00:57:43 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240528022903.20039-1-xni@redhat.com> <20240528090935.00002526@linux.intel.com>
 <CALTww28fH49J7oDw-JAVzDemRPYxBcj63pgf13ZAK+b0687LTw@mail.gmail.com>
In-Reply-To: <CALTww28fH49J7oDw-JAVzDemRPYxBcj63pgf13ZAK+b0687LTw@mail.gmail.com>
From: Xiao Ni <xni@redhat.com>
Date: Tue, 28 May 2024 15:57:31 +0800
Message-ID: <CALTww2-=XFdx6Y=crh1Y3RC6ZiVSbxBL3GDr5Mkv0AQNUPa-GQ@mail.gmail.com>
Subject: Re: [PATCH 1/1] mdadm/platform-intel: Fix buffer overflow
To: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
Cc: blazej.kucman@intel.com, linux-raid@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, May 28, 2024 at 3:41=E2=80=AFPM Xiao Ni <xni@redhat.com> wrote:
>
> On Tue, May 28, 2024 at 3:09=E2=80=AFPM Mariusz Tkaczyk
> <mariusz.tkaczyk@linux.intel.com> wrote:
> >
> > On Tue, 28 May 2024 10:29:03 +0800
> > Xiao Ni <xni@redhat.com> wrote:
> >
> > > It reports buffer overflow detected when creating raid with big
> > > nvme devices. In my test, the size of the nvme device is 1.5T.
> > > It can't reproduce this with nvme device which size is smaller
> > > than 1T.
> >
> > Hi Xiao,
> >
> > Size of disks should have nothing to do with this. We are just parsing =
sysfs.
> > Weird..
>
> Maybe you're right. The test shows the size affect the result.
> >
> > >
> > > In function get_nvme_multipath_dev_hw_path it allocs memory in a for
> > > loop and the size it allocs is big. So if the iteration number is
> > > large, it has a risk that the stack space is larger than the limit.
> > > So move the memory allocation at the biginning of the funtion.
> >
> > I would expect that memory is deallocated after each loop but the fix
> > is correct and I'm willing to take this because obviously it is a fix f=
or
> > something.
>
> If the memory is deallocated after each loop. The comments in this
> patch are not right.

Hi all

After talking, I tried this way and it can fix the problem. So it
looks like it's caused by api sprintf. After switching sprintf with
snprintf, the problem can be fixed. It looks like it depends on the
glibc or something else related with building.

diff --git a/platform-intel.c b/platform-intel.c
index 15a9fa5a..0e083812 100644
--- a/platform-intel.c
+++ b/platform-intel.c
@@ -907,14 +907,15 @@ char *get_nvme_multipath_dev_hw_path(const char *dev_=
path)
                return NULL;

        for (ent =3D readdir(dir); ent; ent =3D readdir(dir)) {
-               char buf[strlen(dev_path) + strlen(ent->d_name) + 1];
+               int len =3D strlen(dev_path) + strlen(ent->d_name) + 1;
+               char buf[len];

                /* Check if dir is a controller, ignore namespaces*/
                if (!(strncmp(ent->d_name, "nvme", 4) =3D=3D 0) ||
                    (strrchr(ent->d_name, 'n') !=3D &ent->d_name[0]))
                        continue;

-               sprintf(buf, "%s/%s", dev_path, ent->d_name);
+               snprintf(buf, len, "%s/%s", dev_path, ent->d_name);
                rp =3D realpath(buf, NULL);
                break;
        }

Best Regards
Xiao
>
> >
> > I don't understand the problem but I trust you. Maybe varied size stack=
 array is
> > a problem?
>
> Let me explain more in detail. It's a strange problem. It only can
> happen with the mdadm rpm package which is built already. If I install
> src.rpm and build it locally, the problem can't happen. So I added
> logs to narrow the problem. Finally, it prints the log in the loop and
> doesn't print log when is before returning from this function. So the
> memory allocation is suspicious and I tried with the patch and it can
> fix this problem.
>
> >
> > Probably, enough would be to just replace [strlen(dev_path) +
> > strlen(ent->d_name) + 1] by [PATH_MAX] but I'm quite confused why it is=
 an
> > issue at all.
> >
> > LGTM. Please fix typos raised by Paul and I will merge it.
>
> Ok, I'll wait for a bit to give more time to talk about this problem.
>
> Best Regards
> Xiao
> >
> > Thanks,
> > Mariusz
> >
> > >
> > > Fixes: d835518b6b53 ('imsm: nvme multipath support')
> > > Reported-by: Guang Wu <guazhang@redhat.com>
> > > Signed-off-by: Xiao Ni <xni@redhat.com>
> > > ---
> > >  platform-intel.c | 4 ++--
> > >  1 file changed, 2 insertions(+), 2 deletions(-)
> > >
> > > diff --git a/platform-intel.c b/platform-intel.c
> > > index 15a9fa5a..0732af2b 100644
> > > --- a/platform-intel.c
> > > +++ b/platform-intel.c
> > > @@ -898,6 +898,7 @@ char *get_nvme_multipath_dev_hw_path(const char *=
dev_path)
> > >       DIR *dir;
> > >       struct dirent *ent;
> > >       char *rp =3D NULL;
> > > +     char buf[PATH_MAX];
> > >
> > >       if (strncmp(dev_path, NVME_SUBSYS_PATH, strlen(NVME_SUBSYS_PATH=
)) !=3D
> > > 0) return NULL;
> > > @@ -907,14 +908,13 @@ char *get_nvme_multipath_dev_hw_path(const char
> > > *dev_path) return NULL;
> > >
> > >       for (ent =3D readdir(dir); ent; ent =3D readdir(dir)) {
> > > -             char buf[strlen(dev_path) + strlen(ent->d_name) + 1];
> > >
> > >               /* Check if dir is a controller, ignore namespaces*/
> > >               if (!(strncmp(ent->d_name, "nvme", 4) =3D=3D 0) ||
> > >                   (strrchr(ent->d_name, 'n') !=3D &ent->d_name[0]))
> > >                       continue;
> > >
> > > -             sprintf(buf, "%s/%s", dev_path, ent->d_name);
> > > +             snprintf(buf, PATH_MAX, "%s/%s", dev_path, ent->d_name)=
;
> >
> > >               rp =3D realpath(buf, NULL);
> > >               break;
> > >       }
> >

