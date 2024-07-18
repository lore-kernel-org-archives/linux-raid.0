Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD53B7E8
	for <linux-raid@vger.kernel.org>; Thu, 18 Jul 2024 03:28:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721273288; cv=none; b=UJ2RWrKHgweZOfk6nJTGg1EBnOLdig4JViG4dorNhmC8hcQBxux0zllsr4E/0dTQNSnoBgicEzC0xMEx2R434OCwYFMw8LzRmgpdXqKIpka2qmEUdU0QL7QlX9FSxudgOG7L4zwoHVIHQWpmtWv3bx+T8BXrTXzTKFiLss+A1VM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721273288; c=relaxed/simple;
	bh=hrSdHy0EjfcPkxJXAESzC497jD5iEP5/32dk9uuW/ZM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=mPZJ044X0XUFz5piVaCAu9xCGnalm2HRXAMglU3CJV0AkBmRQawN7o6rCJFpY+aHVn0je5mV/OA2I64wRcE4XQP2XitUW1xz2JuRCKdaHKY8RrBnHY5HK26m8koASed7IF/Qq6dahTU3ct9UGzV3lQh1DByM9qUwOf//Q26RpPE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=QhK9/cqu; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="QhK9/cqu"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1721273284;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=vvv14sOCR1nJCznE9k2LxhtccMSHRXJcH0eBcOVdW0I=;
	b=QhK9/cquZCKPy/ytrQzZSOYctBaJvMyoyoz8kZgNz1zZaMMfzjPekemds/9s1B2ZfUnIwN
	7qOth4hvaoIuw9JR7v1KSLRaaZfmXDxD1WnXlhiJGR9A/nwajROM2U+Q6z1+Cc+ZP5tDLr
	O2cjoziFuEiOhblgfnFyugtigN8Mx/A=
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com
 [209.85.216.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-352-N-ERUFLnPsK_1paoygjN6Q-1; Wed, 17 Jul 2024 23:28:03 -0400
X-MC-Unique: N-ERUFLnPsK_1paoygjN6Q-1
Received: by mail-pj1-f71.google.com with SMTP id 98e67ed59e1d1-2cb685d5987so326291a91.2
        for <linux-raid@vger.kernel.org>; Wed, 17 Jul 2024 20:28:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721273282; x=1721878082;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vvv14sOCR1nJCznE9k2LxhtccMSHRXJcH0eBcOVdW0I=;
        b=HDL3WfVK/yiygQjd7XTUo64B+fg3i6P726yfoYWHztxjnuDXIf2T4CIH3oeR5m3BkB
         Y+15VqcLW8vDbg55pgvjooJTU0uncadZN/RRcm4f4MGFZT679wIa544t1yhRHlelGny4
         qNKVMhiULIzwwBCcellDOfFgvXBCYIIcpNqIkGF9qyGsXhEIY0sETrHeHpiGuOPLZu/x
         L1E3yxnRkg1AUpBI4JcymTNrWyJLb3CADNY9lJwVWWW3b2z6lCZkRipC/mVyD0S2DG1T
         eS6zEMPEQDaCxxCRwlJjqtmJnXp2dkZnVOCZGxlOcEqrzg5K132N7YPUFSDObbpXb17y
         orPw==
X-Forwarded-Encrypted: i=1; AJvYcCUH3bzI+BHEH/+GtbctJdGjVmKvZfyQndfEa/X+mVH5CgMOjyw265fj8LS0z1Z0XV6tBoAInMs3NmNP+lNNBGLe7zYeTLFhPIsG4Q==
X-Gm-Message-State: AOJu0YxiR3IxGr76F/yd76gyIKELpjmA+pJIdEZo8awCcDFgpVfiXk4t
	7vm9nq8JkOJt9qUe62YS/ydKacrVkxvd9igsWrQI3+UDE0EtsZ8BvWFMzOOEusYOGDb1m18e9or
	XMpIFzyhMIEvDOqy7sTUT89OyFBINg9nTZ11ydem93AwEyhDm3OQHrziKYHVTlsDgvW/lV6gWuS
	YRy8lhTDDK0dT+3DUnf95FzXHxpk0IuhQLzkOCsFhtfTG4mG8=
X-Received: by 2002:a17:90a:4d82:b0:2c8:e43b:4015 with SMTP id 98e67ed59e1d1-2cb5245f09emr3173258a91.6.1721273281948;
        Wed, 17 Jul 2024 20:28:01 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IESD31UykOguRLCkWzWsPF3HL9BwyeeGhU2luXTAMMtNSzR/caqrPfyGimYGQaPvn+DzPVbsEvGVbqVizs7l9Q=
X-Received: by 2002:a17:90a:4d82:b0:2c8:e43b:4015 with SMTP id
 98e67ed59e1d1-2cb5245f09emr3173249a91.6.1721273281572; Wed, 17 Jul 2024
 20:28:01 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240715073604.30307-1-xni@redhat.com> <20240715073604.30307-4-xni@redhat.com>
 <20240717132946.00002373@linux.intel.com>
In-Reply-To: <20240717132946.00002373@linux.intel.com>
From: Xiao Ni <xni@redhat.com>
Date: Thu, 18 Jul 2024 11:27:50 +0800
Message-ID: <CALTww283LHH3+-jh=AOgoerbBphpch7+FCJrp3K29rt7dNP72w@mail.gmail.com>
Subject: Re: [PATCH 03/15] mdadm/Grow: fix coverity issue RESOURCE_LEAK
To: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
Cc: ncroxon@redhat.com, linux-raid@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 17, 2024 at 7:29=E2=80=AFPM Mariusz Tkaczyk
<mariusz.tkaczyk@linux.intel.com> wrote:
>
> On Mon, 15 Jul 2024 15:35:52 +0800
> Xiao Ni <xni@redhat.com> wrote:
>
> > Signed-off-by: Xiao Ni <xni@redhat.com>
> > ---
> >  Grow.c | 53 ++++++++++++++++++++++++++++++++++++++++-------------
> >  1 file changed, 40 insertions(+), 13 deletions(-)
> >
> > diff --git a/Grow.c b/Grow.c
> > index 7ae967bda067..632be7db8d38 100644
> > --- a/Grow.c
> > +++ b/Grow.c
> > @@ -485,6 +485,7 @@ int Grow_addbitmap(char *devname, int fd, struct co=
ntext
> > *c, struct shape *s) int bitmap_fd;
> >               int d;
> >               int max_devs =3D st->max_devs;
> > +             int err =3D 0;
> >
> >               /* try to load a superblock */
> >               for (d =3D 0; d < max_devs; d++) {
> > @@ -525,13 +526,14 @@ int Grow_addbitmap(char *devname, int fd, struct
> > context *c, struct shape *s) return 1;
> >               }
> >               if (ioctl(fd, SET_BITMAP_FILE, bitmap_fd) < 0) {
> > -                     int err =3D errno;
> > +                     err =3D errno;
> >                       if (errno =3D=3D EBUSY)
> >                               pr_err("Cannot add bitmap while array is
> > resyncing or reshaping etc.\n"); pr_err("Cannot set bitmap file for %s:=
 %s\n",
> >                               devname, strerror(err));
> > -                     return 1;
> >               }
> > +             close(bitmap_fd);
> > +             return err;
>
> I don't think that we should return errno. I would say that mdadm should =
define
> returned statues for functions, that is why I added mdadm_status_t.
>
> Otherwise, same value may have two meanings. For example, in some cases w=
e are
> fine with particular error code from error might be misleading (it may ma=
tch
> allowed status).
> This is not the case here, it is just an example.
>
> I think that we should not return errno outside if not intended i.e. func=
tion is
> projected to return errno in every case.

Ok, I'll keep the original way.

@@ -530,8 +530,9 @@ int Grow_addbitmap(char *devname, int fd, struct
context *c, struct shape *s)
                                pr_err("Cannot add bitmap while array
is resyncing or reshaping etc.\n");
                        pr_err("Cannot set bitmap file for %s: %s\n",
                                devname, strerror(err));
-                       return 1;
                }
+               close(bitmap_fd);
+               return 1;
        }


>
> >       }
> >
> >       return 0;
> > @@ -3083,6 +3085,7 @@ static int reshape_array(char *container, int fd,=
 char
> > *devname, int done;
> >       struct mdinfo *sra =3D NULL;
> >       char buf[SYSFS_MAX_BUF_SIZE];
> > +     bool located_backup =3D false;
> >
> >       /* when reshaping a RAID0, the component_size might be zero.
> >        * So try to fix that up.
> > @@ -3165,8 +3168,10 @@ static int reshape_array(char *container, int fd=
, char
> > *devname, goto release;
> >               }
> >
> > -             if (!backup_file)
> > +             if (!backup_file) {
> >                       backup_file =3D locate_backup(sra->sys_name);
> > +                     located_backup =3D true;
> > +             }
> >
> >               goto started;
> >       }
> > @@ -3612,15 +3617,15 @@ started:
> >                       mdstat_wait(30 - (delayed-1) * 25);
> >       } while (delayed);
> >       mdstat_close();
> > -     if (check_env("MDADM_GROW_VERIFY"))
> > -             fd =3D open(devname, O_RDONLY | O_DIRECT);
> > -     else
> > -             fd =3D -1;
> >       mlockall(MCL_FUTURE);
> >
> >       if (signal_s(SIGTERM, catch_term) =3D=3D SIG_ERR)
> >               goto release;
> >
> > +     if (check_env("MDADM_GROW_VERIFY"))
> > +             fd =3D open(devname, O_RDONLY | O_DIRECT);
> > +     else
> > +             fd =3D -1;
>
> close_fd() is used unconditionally on fd few line earlier so it seems tha=
t else
> path is not needed but this code is massive so please double check if I'm=
 right.
>
> We may call close_fd() on the closed resource and then it is not updated =
to -1,
> assuming that close fails with EBADF.

How about this:
-       if (check_env("MDADM_GROW_VERIFY"))
-               fd =3D open(devname, O_RDONLY | O_DIRECT);
-       else
-               fd =3D -1;
        mlockall(MCL_FUTURE);

        if (signal_s(SIGTERM, catch_term) =3D=3D SIG_ERR)
                goto release;

+       if (check_env("MDADM_GROW_VERIFY"))
+               fd =3D open(devname, O_RDONLY | O_DIRECT);
        if (st->ss->external) {
                /* metadata handler takes it from here */
                done =3D st->ss->manage_reshape(
@@ -3632,6 +3634,7 @@ started:
                        fd, sra, &reshape, st, blocks, fdlist, offsets,
                        d - odisks, fdlist + odisks, offsets + odisks);

+       close_fd(&fd);
        free(fdlist);
        free(offsets);
>
> Right way to fix it is to replace all close(fd) by close_fd(fd). It will =
give is
> credibility that double close is not possible.

I'll replace them in the next version. But I think it should depend on
the specific case. Sometimes, we don't need to reset fd to -1, because
we don't use it anymore. So the standard close function is better.

>
>
> >       if (st->ss->external) {
> >               /* metadata handler takes it from here */
> >               done =3D st->ss->manage_reshape(
> > @@ -3632,6 +3637,8 @@ started:
> >                       fd, sra, &reshape, st, blocks, fdlist, offsets,
> >                       d - odisks, fdlist + odisks, offsets + odisks);
> >
> > +     if (fd >=3D 0)
> > +             close(fd);
> >       free(fdlist);
> >       free(offsets);
> >
> > @@ -3701,6 +3708,8 @@ out:
> >       exit(0);
> >
> >  release:
> > +     if (located_backup)
> > +             free(backup_file);
>
> >       free(fdlist);
> >       free(offsets);
> >       if (orig_level !=3D UnSet && sra) {
> > @@ -3839,6 +3848,7 @@ int reshape_container(char *container, char *devn=
ame,
> >                       pr_err("Unable to initialize sysfs for %s\n",
> >                              mdstat->devnm);
> >                       rv =3D 1;
> > +                     close(fd);
> >                       break;
> >               }
> >
> > @@ -4717,6 +4727,7 @@ int Grow_restart(struct supertype *st, struct mdi=
nfo
> > *info, int *fdlist, unsigned long long *offsets;
> >       unsigned long long  nstripe, ostripe;
> >       int ndata, odata;
> > +     int fd, backup_fd =3D -1;
> >
> >       odata =3D info->array.raid_disks - info->delta_disks - 1;
> >       if (info->array.level =3D=3D 6)
> > @@ -4732,9 +4743,18 @@ int Grow_restart(struct supertype *st, struct md=
info
> > *info, int *fdlist,
> >                * been used
> >                */
> >               old_disks =3D cnt;
> > +
> > +     if (backup_file) {
> > +             backup_fd =3D open(backup_file, O_RDONLY);
> > +             if (backup_fd < 0) {
> > +                     pr_err("Can't open backup file %s : %s\n",
> > +                             backup_file, strerror(errno));
> > +                     return -EINVAL;
> > +             }
> > +     }
> > +
> >       for (i=3Dold_disks-(backup_file?1:0); i<cnt; i++) {
> >               struct mdinfo dinfo;
> > -             int fd;
> >               int bsbsize;
> >               char *devname, namebuf[20];
> >               unsigned long long lo, hi;
> > @@ -4747,12 +4767,9 @@ int Grow_restart(struct supertype *st, struct md=
info
> > *info, int *fdlist,
> >                * else restore data and update all superblocks
> >                */
> >               if (i =3D=3D old_disks-1) {
> > -                     fd =3D open(backup_file, O_RDONLY);
> > -                     if (fd<0) {
> > -                             pr_err("backup file %s inaccessible: %s\n=
",
> > -                                     backup_file, strerror(errno));
> > +                     if (backup_fd < 0)
> >                               continue;
>
> You can use is_fd_valid(). Please also review other patches on that.

I searched by command `cat * | grep "< 0"`, this is the only place.
I'll change it. But is it really convenient? if_fd_valid just does the
same thing. Because if_fd_valid is not a standard C api, developers
may not know this api.

>
> > -                     }
> > +                     fd =3D backup_fd;
> >                       devname =3D backup_file;
> >               } else {
> >                       fd =3D fdlist[i];
> > @@ -4907,6 +4924,8 @@ int Grow_restart(struct supertype *st, struct mdi=
nfo
> > *info, int *fdlist, pr_err("Error restoring backup from %s\n",
> >                                       devname);
> >                       free(offsets);
> > +                     if (backup_fd >=3D 0)
> > +                             close(backup_fd);
> we have close_fd() for that.
>
> >                       return 1;
> >               }
> >
> > @@ -4923,6 +4942,8 @@ int Grow_restart(struct supertype *st, struct mdi=
nfo
> > *info, int *fdlist, pr_err("Error restoring second backup from %s\n",
> >                                       devname);
> >                       free(offsets);
> > +                     if (backup_fd >=3D 0)
> > +                             close(backup_fd);
>
> You can use close_fd(). Also please analyze other patches on that.

Ok,  I will do it.

Best Regards
Xiao
>
> >                       return 1;
> >               }
> >
> > @@ -4984,8 +5005,14 @@ int Grow_restart(struct supertype *st, struct md=
info
> > *info, int *fdlist, st->ss->store_super(st, fdlist[j]);
> >                       st->ss->free_super(st);
> >               }
> > +             if (backup_fd >=3D 0)
> > +                     close(backup_fd);
> >               return 0;
> >       }
> > +
> > +     if (backup_fd >=3D 0)
> > +             close(backup_fd);
>
> As above (use close_fd())
> > +
> >       /* Didn't find any backup data, try to see if any
> >        * was needed.
> >        */
>
> Thanks,
> Mariusz
>

