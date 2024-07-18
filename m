Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B48DA27713
	for <linux-raid@vger.kernel.org>; Thu, 18 Jul 2024 02:30:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721269809; cv=none; b=Veygtg2PgfQdFU1S11GSt+4ozlqbTTMeGjbBMw76fK1za49KaZRBPWErSmnZYm4ZDuLYDxL7pnsb1/dPR5TwgZ9DXTJISyztU1edpLDeesHSV07L0E2sqR0GKQhJNRHCu/UbKMn/unasRDYnXTQ2QG+fhxN4WrUWutEDzPx6NlI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721269809; c=relaxed/simple;
	bh=Z2SHoQeX3UOvnUlB1+BfJye2BB4R9tDZ1PIMhijFujk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=VR7GEfbn8b18ZlRZny+nWeBBSNLRRAf3Sv4rWO8/O1RWQdnWrpGiM7U8XCXDnj26qv1JmVzhqoTrMoujaqSnCNpM7b1eAXXr1d7HMqYAF9Yn8S8LOXG8xIZ1m6WzpzaB4fpfbbRUTXNWgFJKVHthX4uBBF5SxPRsGCb55QOR8wI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ONUHe5Or; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ONUHe5Or"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1721269806;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=D47CrgJmPe+BdjUgvVU2FehXXLOOt7G5rgsPcJmHfSg=;
	b=ONUHe5Orxvu0C7yB3R8rWS0SxhQkRitTSa05jxgOb0SF/MfN4Qw8XJ8474WxUIV/XQ0KM3
	gAshOM8h2Aws6k1IPg9NeggxWIvRVeptt4zCW8nhVyUXcxEnk1TaHh/mYaUTc0aPlQ90dV
	bwhLuQ0vnlDckC9t4B0CpZajbP5yx1k=
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com
 [209.85.216.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-614-cdxsWGGTP_GkmbP0u0soZw-1; Wed, 17 Jul 2024 22:30:04 -0400
X-MC-Unique: cdxsWGGTP_GkmbP0u0soZw-1
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-2cb50fbebd9so510100a91.0
        for <linux-raid@vger.kernel.org>; Wed, 17 Jul 2024 19:30:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721269803; x=1721874603;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=D47CrgJmPe+BdjUgvVU2FehXXLOOt7G5rgsPcJmHfSg=;
        b=DvTJL93nRcktd2QTXxBLK2Uk0HuyVeaE4InyllYxGIAPY1jbwTHIOjoGHH6HoQzYEK
         HRkw7kzBot+OS1h+4cyz5QlOn6+GOQZ7iZ3YY+/P/zG7m/lEmzDuJj6H5N/CFCyvqREl
         Rj8Ic+DHwYVhXHpNeeZLM8YfRjslZrhyEenPhhQp3Hr9htgDB1FtB25pt+fWkhRgGvJB
         lOE7LHCVh3elP+NbCeVgZFDyj3e740gclMIoUv2eaFGQNzw5ndi4WmSOlWbJlz9Z3uG7
         g3ZBehJJrAR6a7PPOrtjpa82w04v0KDww5j9iVSUtYz3NTriSCk5pK6onb0h8YMBcBBK
         ZK2A==
X-Forwarded-Encrypted: i=1; AJvYcCVTdz+mwdRDFpScAjPvQCORO1EJJeyC14vTcIy4i/9WvMYv94zimQjDTQKnlynL7z18x+zC66crqNUSVw5t225NCSVA+dbbWbAYww==
X-Gm-Message-State: AOJu0YxLtR6RRimfdCSY6QepNfAFssnqCuSlEQAfqCbif72Fsa7ntmug
	jQAs5q1kxps925dI4Dx9QPyvQCTYJEHHOaMQDRGdGR6TgdpzoKGXkfMtW9Y07CR0jMoUlS0dfj7
	nFYTBpGauHyEhvwp5zd38Cx3F4YyhT8xm/Wcl+/sQH2ogpbpv6T/tZ4uyFrKOLG6h7O7ICu+PB+
	WuSw3Eg4NWIXcJeKWBlPuUdWsGcKu5Bw6r/Lcr4kydOCLG
X-Received: by 2002:a17:90b:ed5:b0:2c9:7fba:d895 with SMTP id 98e67ed59e1d1-2cb529510dfmr2871650a91.38.1721269802769;
        Wed, 17 Jul 2024 19:30:02 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHWEyxbQdoUonte5Z1k88D/NcLs3HxFx0B+roLyv9LSbx0vPBG9cmDDzJ9HBSXbrWHM6KUgsopYinlcN0Z4xSs=
X-Received: by 2002:a17:90b:ed5:b0:2c9:7fba:d895 with SMTP id
 98e67ed59e1d1-2cb529510dfmr2871645a91.38.1721269802331; Wed, 17 Jul 2024
 19:30:02 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240715073604.30307-1-xni@redhat.com> <20240715073604.30307-3-xni@redhat.com>
 <20240717113315.00002fd3@linux.intel.com>
In-Reply-To: <20240717113315.00002fd3@linux.intel.com>
From: Xiao Ni <xni@redhat.com>
Date: Thu, 18 Jul 2024 10:29:50 +0800
Message-ID: <CALTww2-UHvkCC-r-YS3DD=T79woc+kPvNrubDyfSMJOkZxd+KQ@mail.gmail.com>
Subject: Re: [PATCH 02/15] mdadm/Grow: fix coverity issue CHECKED_RETURN
To: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
Cc: ncroxon@redhat.com, linux-raid@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 17, 2024 at 5:33=E2=80=AFPM Mariusz Tkaczyk
<mariusz.tkaczyk@linux.intel.com> wrote:
>
> On Mon, 15 Jul 2024 15:35:51 +0800
> Xiao Ni <xni@redhat.com> wrote:
>
> > Signed-off-by: Xiao Ni <xni@redhat.com>
> > ---
> >  Grow.c | 43 ++++++++++++++++++++++++++++++++++++-------
> >  1 file changed, 36 insertions(+), 7 deletions(-)
> >
> > diff --git a/Grow.c b/Grow.c
> > index b135930d05b8..7ae967bda067 100644
> > --- a/Grow.c
> > +++ b/Grow.c
> > @@ -3261,7 +3261,12 @@ static int reshape_array(char *container, int fd=
, char
> > *devname, /* This is a spare that wants to
> >                                        * be part of the array.
> >                                        */
> > -                                     add_disk(fd, st, info2, d);
> > +                                     if (add_disk(fd, st, info2, d) < =
0) {
> > +                                             pr_err("Can not add disk
> > %s\n",
> > +                                                             d->sys_na=
me);
> > +                                             free(info2);
> > +                                             goto release;
> > +                                     }
> >                               }
> >                       }
> >                       sysfs_free(info2);
> > @@ -4413,7 +4418,10 @@ static void validate(int afd, int bfd, unsigned =
long
> > long offset) */
> >       if (afd < 0)
> >               return;
> > -     lseek64(bfd, offset - 4096, 0);
> > +     if (lseek64(bfd, offset - 4096, 0) < 0) {
> > +             pr_err("lseek64 fails %d:%s\n", errno, strerror(errno));
>
> You are using same error message in many places, shouldn't we propose som=
ething
> like:
>
> __off64_t lseek64_log_err (int __fd, __off64_t __offset, int __whence)
> {
>     __off64_t ret =3D lseek64(fd, __offset, __whence);
>     if (ret < 0)
>          pr_err("lseek64 fails %d:%s\n", errno, strerror(errno));
>
>     return ret;
>
> }
>
> lseek64 errors are unusual, they are exceptional, and I'm fine with loggi=
ng
> same error message but I would prefer to avoid repeating same message in =
code.
> In case of debug, developer can do some backtracking, starting from this
> function rather than hunt for the particular error message you used multi=
ple
> times.

Hi Mariusz

If we use the above way, pr_err only prints the line of code in the
function lseek64_log_err. We can't know where the error is. pr_err
prints the function name and code line number. We put pr_err in the
place where lseek fails, we can know which function and which lseek
fails. It should be easy for debug. Is it right?
>
> > +             return;
>
>
> > +     }
> >       if (read(bfd, &bsb2, 512) !=3D 512)
> >               fail("cannot read bsb");
> >       if (bsb2.sb_csum !=3D bsb_csum((char*)&bsb2,
> > @@ -4444,12 +4452,19 @@ static void validate(int afd, int bfd, unsigned=
 long
> > long offset) }
> >               }
> >
> > -             lseek64(bfd, offset, 0);
> > +             if (lseek64(bfd, offset, 0) < 0) {
> > +                     pr_err("lseek64 fails %d:%s\n", errno,
> > strerror(errno));
>
> > +                     goto out;
> > +             }
> >               if ((unsigned long long)read(bfd, bbuf, len) !=3D len) {
> >                       //printf("len %llu\n", len);
> >                       fail("read first backup failed");
> >               }
> > -             lseek64(afd, __le64_to_cpu(bsb2.arraystart)*512, 0);
> > +
> > +             if (lseek64(afd, __le64_to_cpu(bsb2.arraystart)*512, 0) <=
 0)
> > {
> > +                     pr_err("lseek64 fails %d:%s\n", errno,
> > strerror(errno));
> > +                     goto out;
> > +             }
> >               if ((unsigned long long)read(afd, abuf, len) !=3D len)
> >                       fail("read first from array failed");
> >               if (memcmp(bbuf, abuf, len) !=3D 0)
> > @@ -4466,15 +4481,25 @@ static void validate(int afd, int bfd, unsigned=
 long
> > long offset) bbuf =3D xmalloc(abuflen);
> >               }
> >
> > -             lseek64(bfd, offset+__le64_to_cpu(bsb2.devstart2)*512, 0)=
;
> > +             if (lseek64(bfd, offset+__le64_to_cpu(bsb2.devstart2)*512=
,
> > 0) < 0) {
> > +                     pr_err("lseek64 fails %d:%s\n", errno,
> > strerror(errno));
> > +                     goto out;
> > +             }
> >               if ((unsigned long long)read(bfd, bbuf, len) !=3D len)
> >                       fail("read second backup failed");
> > -             lseek64(afd, __le64_to_cpu(bsb2.arraystart2)*512, 0);
> > +             if (lseek64(afd, __le64_to_cpu(bsb2.arraystart2)*512, 0) =
<
> > 0) {
> > +                     pr_err("lseek64 fails %d:%s\n", errno,
> > strerror(errno));
> > +                     goto out;
> > +             }
> >               if ((unsigned long long)read(afd, abuf, len) !=3D len)
> >                       fail("read second from array failed");
> >               if (memcmp(bbuf, abuf, len) !=3D 0)
> >                       fail("data2 compare failed");
> >       }
> > +out:
> > +     free(abuf);
> > +     free(bbuf);
> > +     return;
> >  }
> >
> >  int child_monitor(int afd, struct mdinfo *sra, struct reshape *reshape=
,
> > @@ -5033,7 +5058,11 @@ int Grow_continue_command(char *devname, int fd,
> > struct context *c) goto Grow_continue_command_exit;
> >               }
> >               content =3D &array;
> > -             sysfs_init(content, fd, NULL);
> > +             if (sysfs_init(content, fd, NULL) < 0) {
> > +                     pr_err("sysfs_init fails\n");
>
> Better error message is:
> pr_err("failed to initialize sysfs.\n");
> or
> pr_err("unable to initialize sysfs for %s\n",st->devnm);
>
> It is more user friendly.

Yes, it makes sense.
>
> It is already used multiple times so perhaps we can consider similar appr=
oach
> to proposed in for lseek, we can move move printing error to sysfs_init()=
.
>
> What do you think?

It depends on the above answer you'll give.

Best Regards
Xiao
>
> Thanks,
> Mariusz
>

