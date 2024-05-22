Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2CC946522
	for <linux-raid@vger.kernel.org>; Wed, 22 May 2024 08:46:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716367583; cv=none; b=Zxls36Y1uCrD388r1m8Igc0+fyK+fawa+2KarV3/w49VDeNCHw5r6sjF0i1heQX8VB+hIJOyjGzUOm/hiL4HyF0JY1CF8Rxq9+IwPc5P3nRF7odmlyfFS1sul0XSswHh8AE5I4qHNeZRc7/fiopVQ4PjMBpKhPJbF6HLPiKWrLY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716367583; c=relaxed/simple;
	bh=zSqDNoX4OPj7GLuKCHNfeMosRZq8/vV0OK4tte9RsJA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=byTYbgZI3GQrRnx5SWC4oVi4rpuK2RGeTM01rg43FUMszcLWMygVp4EiwbeNW6ghXw82oeQNrIB+sWGo4aWb/wlPpkwx4k0hyJwOYC9csJ9kuM69khORdLtN3mSZIgw4HOcBpMYmwzTeYkiSWJ/7CEgwlrHjBGJ2yQBPvHHQlHY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=CXZqnvwY; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="CXZqnvwY"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1716367580;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+qSPOOZ7rBCOjLN8c4mkzHZWpPS2PvfmOFViWeryUMM=;
	b=CXZqnvwYHlKZLhP1InJ4t2zd0yd+qnKNkJoy+B7r8vSOS3f0cLJ3veDJQo70Eifq4LxuyP
	N8TWFjZmPunrgWjkegeJ7QNIm/owssY+uDmDqcwmWUPuzSHGDJzx/9CquFWgFq6zbyUX1J
	OpocXBoiiK22akq0KU8Tk3R5kvqxhgI=
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com
 [209.85.216.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-587-MuwQiwuLPBKeyP0JiJUHeQ-1; Wed, 22 May 2024 04:46:19 -0400
X-MC-Unique: MuwQiwuLPBKeyP0JiJUHeQ-1
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-2bd5f87a0e1so3946715a91.0
        for <linux-raid@vger.kernel.org>; Wed, 22 May 2024 01:46:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716367577; x=1716972377;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+qSPOOZ7rBCOjLN8c4mkzHZWpPS2PvfmOFViWeryUMM=;
        b=Y9kP0XKYboVzqdGMvavE4CZeG8GNQD1s2lWpFLzB8Gsy+4Qsxw+wOhxuANIMpIef4e
         jqQqNEuw6GFkTLDsVygkW+8YWKYl943agZneu/rOUL+hj06Nk+dr4TGN+9AJKXENcKZS
         7s4D9a94q0O0MaIANEBY3jX4Jvy0E2xLf2Du7D7qYP1hUdcg+wOMLE9bzzlmo+/FFyNm
         aZdipU2A75I0YTXu7XgB3WvcCG+Z4nMhA+w1AvpbMmh6fcw2p1Ll2JjzMhwUKgw44KHu
         i+CewtN3A7gC5heUGONEfIzMi9JKgqDkXS6rPrTTWSscnKBWzs3SyohLqi777KLG86hK
         TITQ==
X-Gm-Message-State: AOJu0Yw3ETUqtTPYC+PG062yeMcnCFWnASdU0CC8/huH6RIAWMQsIVdf
	lq4O6eFX6I5xCNRiPSxGmEb+FzqRYC2p2p8afFI4lLfkpFxxIv4wUcdB1AqS8Ty/TUphgmsL1Dp
	1/Y3iQ1ZGufMYIWOsyN2eaL9cVhKf2bf3NZ1ATi1+WJE1vgieWnva6MquwOpVtUTPxLfzlnIghp
	G9+nrVH+Q4v4vPO6wnoHTOtSpjw/HHJuOVM7GHH0jOF1OJb6P9tw==
X-Received: by 2002:a17:90a:cc08:b0:2ad:af1c:4fc with SMTP id 98e67ed59e1d1-2bd9f48fc15mr1482549a91.25.1716367577351;
        Wed, 22 May 2024 01:46:17 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IG/7CknAv9oPt3OOszUckSed6WClIl6tCXQcKSHGIjux6v+6v9xc7lQ+JA/lZqwsG3kf3U3L2AWqDtV01qSeLA=
X-Received: by 2002:a17:90a:cc08:b0:2ad:af1c:4fc with SMTP id
 98e67ed59e1d1-2bd9f48fc15mr1482536a91.25.1716367576923; Wed, 22 May 2024
 01:46:16 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CALTww28qp4d=mvdXvLqHPTrt0FAJihdMOQMrAyL44urstSdznQ@mail.gmail.com>
 <25ea3a8d-6331-476c-8fb4-8932185b3113@deltatee.com>
In-Reply-To: <25ea3a8d-6331-476c-8fb4-8932185b3113@deltatee.com>
From: Xiao Ni <xni@redhat.com>
Date: Wed, 22 May 2024 16:46:05 +0800
Message-ID: <CALTww2-Rm=ORd0QtuWru6qz8VaTY3D-EnjJVQ48uf8gPTSG6Uw@mail.gmail.com>
Subject: Re: mdadm/Create wait_for_zero_forks is stuck
To: Logan Gunthorpe <logang@deltatee.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Logan

Thanks for your suggestion. I tried to create signalfd before fork()
but it still can't work. And I call sleep(2) before child exits, the
problem still can happen sometimes. This is what I tried. If you have
time to have a look, it's great. It's not a hurry thing.

diff --git a/Create.c b/Create.c
index d94253b1..a40ed027 100644
--- a/Create.c
+++ b/Create.c
@@ -168,15 +168,16 @@ static pid_t write_zeroes_fork(int fd, struct
shape *s, struct supertype *st,
                size_bytes -=3D sz;
        }

+       printf("sleeping 2 seconds\n");
+       sleep(2);
        exit(ret);
 }

-static int wait_for_zero_forks(int *zero_pids, int count)
+static int wait_for_zero_forks(int *zero_pids, int count, int sfd)
 {
-       int wstatus, ret =3D 0, i, sfd, wait_count =3D 0;
+       int wstatus, ret =3D 0, i, wait_count =3D 0;
        struct signalfd_siginfo fdsi;
        bool interrupted =3D false;
-       sigset_t sigset;
        ssize_t s;

        for (i =3D 0; i < count; i++)
@@ -185,17 +186,6 @@ static int wait_for_zero_forks(int *zero_pids, int cou=
nt)
        if (!wait_count)
                return 0;

-       sigemptyset(&sigset);
-       sigaddset(&sigset, SIGINT);
-       sigaddset(&sigset, SIGCHLD);
-       sigprocmask(SIG_BLOCK, &sigset, NULL);
-
-       sfd =3D signalfd(-1, &sigset, 0);
-       if (sfd < 0) {
-               pr_err("Unable to create signalfd: %s\n", strerror(errno));
-               return 1;
-       }
-
        while (1) {
                s =3D read(sfd, &fdsi, sizeof(fdsi));
                if (s !=3D sizeof(fdsi)) {
@@ -208,10 +198,13 @@ static int wait_for_zero_forks(int *zero_pids, int co=
unt)
                        printf("\n");
                        pr_info("Interrupting zeroing processes,
please wait...\n");
                        interrupted =3D true;
+                       break;
                } else if (fdsi.ssi_signo =3D=3D SIGCHLD) {
+                       printf("SIGCHILD wait count %d\n", wait_count);
                        if (!--wait_count)
                                break;
-               }
+               } else
+                       printf("invalide %d\n", wait_count);
        }

        close(sfd);
@@ -377,6 +370,39 @@ static int update_metadata(int mdfd, struct shape
*s, struct supertype *st,
        return 0;
 }

+static int prepare_write_zeros(struct shape *s, sigset_t *orig_sigset)
+{
+       sigset_t sigset;
+       int sfd =3D -1;
+
+       if (!s->write_zeroes)
+               return 0;
+
+       /*
+        * Block SIGINT so the main thread will always wait for the
+        * zeroing processes when being interrupted. Otherwise the
+        * zeroing processes will finish their work in the background
+        * keeping the disk busy.
+        */
+       sigemptyset(&sigset);
+       sigaddset(&sigset, SIGINT);
+       sigaddset(&sigset, SIGCHLD);
+       sigprocmask(SIG_BLOCK, &sigset, orig_sigset);
+
+       sfd =3D signalfd(-1, &sigset, 0);
+       if (sfd < 0) {
+               pr_err("Unable to create signalfd: %s\n", strerror(errno));
+               return -EACCES;
+       }
+
+       return sfd;
+}
+
+static void restore_sigset(sigset_t *sigset)
+{
+       sigprocmask(SIG_SETMASK, sigset, NULL);
+}
+
 static int add_disks(int mdfd, struct mdinfo *info, struct shape *s,
                     struct context *c, struct supertype *st,
                     struct map_ent **map, struct mddev_dev *devlist,
@@ -388,18 +414,12 @@ static int add_disks(int mdfd, struct mdinfo
*info, struct shape *s,
        int zero_pids[total_slots];
        struct mddev_dev *dv;
        struct mdinfo *infos;
-       sigset_t sigset, orig_sigset;
-       int ret =3D 0;
+       int ret =3D 0, sfd =3D -1;
+       sigset_t orig_sigset;

-       /*
-        * Block SIGINT so the main thread will always wait for the
-        * zeroing processes when being interrupted. Otherwise the
-        * zeroing processes will finish their work in the background
-        * keeping the disk busy.
-        */
-       sigemptyset(&sigset);
-       sigaddset(&sigset, SIGINT);
-       sigprocmask(SIG_BLOCK, &sigset, &orig_sigset);
+       sfd =3D prepare_write_zeros(s, &orig_sigset);
+       if (sfd < 0)
+               return sfd;
        memset(zero_pids, 0, sizeof(zero_pids));

        infos =3D xmalloc(sizeof(*infos) * total_slots);
@@ -461,7 +481,8 @@ static int add_disks(int mdfd, struct mdinfo
*info, struct shape *s,
                }

                if (pass =3D=3D 1) {
-                       ret =3D wait_for_zero_forks(zero_pids, total_slots)=
;
+                       printf("wait for zero forks\n");
+                       ret =3D wait_for_zero_forks(zero_pids, total_slots,=
 sfd);
                        if (ret)
                                goto out;

@@ -474,9 +495,9 @@ static int add_disks(int mdfd, struct mdinfo
*info, struct shape *s,

 out:
        if (ret)
-               wait_for_zero_forks(zero_pids, total_slots);
+               wait_for_zero_forks(zero_pids, total_slots, sfd);
+       restore_sigset(&orig_sigset);
        free(infos);
-       sigprocmask(SIG_SETMASK, &orig_sigset, NULL);
        return ret;
 }

Best Regards
Xiao

On Wed, May 22, 2024 at 12:57=E2=80=AFAM Logan Gunthorpe <logang@deltatee.c=
om> wrote:
>
> Hi Xiao,
>
> I don't have time to dig into this myself, but my guess would be that
> the signal for one of the children come too quickly, before the
> sigprocmask() call in wait_for_zero_forks().
>
> Seems like SIGCHLD should be blocked before the first call to
> write_zeroes_fork(). I'm really not sure why I put in a block to SIGINT
> and then a block to SIGCHLD after the processes started. I suspect
> adding SIGCHLD to the sigprocmask in add_disks() and just removing the
> sigprocmask in write_zeroes_fork() might fix the issue.
>
> Thanks,
>
> Logan
>
>
>
> On 2024-05-21 01:05, Xiao Ni wrote:
> > Hi Logan
> >
> > I'm trying to fix errors of mdadm regression failures. There is a
> > failure in 00raid5-zero sometimes. I added some logs:
> >
> > In function write_zeroes_fork:
> >                 if (fallocate(fd, FALLOC_FL_ZERO_RANGE | FALLOC_FL_KEEP=
_SIZE,
> >                               offset_bytes, sz)) {
> >                         pr_err("zeroing %s failed: %s\n", dv->devname,
> >                                strerror(errno));
> >                         ret =3D 1;
> >                         break;
> >                 } else
> >                         printf("zeroing good\n");
> >
> > In function wait_for_zero_forks:
> >                 if (fdsi.ssi_signo =3D=3D SIGINT) {
> >                         printf("\n");
> >                         pr_info("Interrupting zeroing processes,
> > please wait...\n");
> >                         interrupted =3D true;
> >                         break;
> >                 } else if (fdsi.ssi_signo =3D=3D SIGCHLD) {
> >                         printf("one child finishes, wait count %d\n",
> > wait_count);
> >                         if (!--wait_count)
> >                                 break;
> >                 }
> >
> > while [ 1 ]; do
> >   /usr/sbin/mdadm -CfR /dev/md0 -l 5 -n3 /dev/loop0 /dev/loop1
> > /dev/loop2 --write-zeroes --auto=3Dyes -v
> >   mdadm --wait /dev/md0
> >   mdadm -Ss
> >   sleep 1
> > done
> >
> > zeroing good
> > zeroing good
> > zeroing good
> > one child finishes, wait count 3
> > one child finishes, wait count 2
> >
> > It looks like the farther process misses one child signal.
> >
> > root      174247  0.0  0.0   3628  2552 pts/0    S+   02:52   0:00  |
> >              \_ /usr/sbin/mdadm -CfR /dev/md0 -l 5 -n3 /dev/loop0
> > /dev/loop1 /dev/loop2 --write-zeroes --auto=3Dyes -v
> > root      174248  0.0  0.0      0     0 pts/0    Z+   02:52   0:00  |
> >                  \_ [mdadm] <defunct>
> > root      174249  0.0  0.0      0     0 pts/0    Z+   02:52   0:00  |
> >                  \_ [mdadm] <defunct>
> > root      174250  0.0  0.0      0     0 pts/0    Z+   02:52   0:00  |
> >                  \_ [mdadm] <defunct>
> >
> > ]# cat /proc/174247/stack
> > [<0>] signalfd_dequeue+0x14d/0x170
> > [<0>] signalfd_read_iter+0x7b/0xd0
> > [<0>] vfs_read+0x201/0x330
> > [<0>] ksys_read+0x5f/0xe0
> > [<0>] do_syscall_64+0x7b/0x160
> > [<0>] entry_SYSCALL_64_after_hwframe+0x76/0x7e
> >
> > Any ideas for this?
> >
> > Best Regards
> > Xiao
> >
>

