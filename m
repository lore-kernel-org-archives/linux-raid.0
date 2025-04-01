Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 454812D05E
	for <linux-raid@vger.kernel.org>; Tue,  1 Apr 2025 02:29:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743474570; cv=none; b=VWWvjqGbTsl9dKBJMkqjgXlEp3bN7ODXdFA4Lbi0DUkYOoZvQFgd3kkj+CDzA+jq6yMKpt2Dvxl2JnG7g9aP5HcWS6gdUiDQ/uHavkeiLWm2jyJHNiMjWZ4wMeNN/3OJLwwDrLQwphcMGFLcHLl8N6oJrJ/y8HRrLHeFdPk+hIY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743474570; c=relaxed/simple;
	bh=jOj3UdLa08eT0eyl7xKLMB3Ecm1D/oqyRgF9kAFs+rY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=aIoBGtsMANWgfbs8bUEXa55JN9b36NlEZ2N9IIduiIzpFhp1nOLrfvoLkSuEMNQtf/uZegx5asFR+KHXAUP9EyoVxtXMa7KX2DpGn79yhjohsN10W4nnO/nZSjfTdN9u7XcLy4cMQORdeITVzs6NRgkHIAILncB2Zlp5LIYR57M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=AUMlMzBy; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="AUMlMzBy"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1743474567;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=el19HGbJ9IzcP/0pnD8zJC3EP/PESgp4RhxITN/TWkI=;
	b=AUMlMzByBfrgSFJvpcEn14Ho4XTkDXLvXuAnGRPVn1KwJQBRHaoNaDOml0jwK4xLq/Jj0t
	p+EnxzDZaa5scXRCvqfQoR/WGaNw57AahYNl7XD6UkGzgdC6bIDhdfcqCQCBeyLPUfQkU5
	SB177sjL43A0hZ9VZYbfuKniySCVg4o=
Received: from mail-lj1-f197.google.com (mail-lj1-f197.google.com
 [209.85.208.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-423-pvTJ8aZ0MP-RgvWkcfIk6g-1; Mon, 31 Mar 2025 22:29:24 -0400
X-MC-Unique: pvTJ8aZ0MP-RgvWkcfIk6g-1
X-Mimecast-MFC-AGG-ID: pvTJ8aZ0MP-RgvWkcfIk6g_1743474563
Received: by mail-lj1-f197.google.com with SMTP id 38308e7fff4ca-30bfd1faeeaso23106241fa.1
        for <linux-raid@vger.kernel.org>; Mon, 31 Mar 2025 19:29:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743474563; x=1744079363;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=el19HGbJ9IzcP/0pnD8zJC3EP/PESgp4RhxITN/TWkI=;
        b=TUYqXBqWG3Hj2c6i0/Fs7hdaqRsHcIzYj2DfC7MCV0qUrXK/s79Im+DrDvHrOS3pZB
         X/cAr1NbGdRKP3OJEGeMa+YuZxxM76fVeVQqNZMC0szjOYsz2LpNlHD8k7+hNer+bS5K
         mPJ319RBVpzh+4Fs6lfqTAzOu5naGiNXsOi3SaJ6GNJMQSxviE8l8CYfo5u4L7Ex91Hu
         p4oofRzP6S5dIsXOqUWPrCkwqFP74TtQeICdEY/iUZ45GxoGupNPhZxcgQtpAqdtKWnH
         RtUnjM4+mJUj6jLESQYShdkjHwnY+x8QlijB5XlmPKTkrrqtUdjsLekrhWWfp8sKEOx8
         U64A==
X-Gm-Message-State: AOJu0YxrnRq0JJ8RbVMOz0TRPUaGyqNqbqNMVC7n4KrKDT1EVoa1lN5M
	dVnuD6QpMtjslmOB1pGPBuMjKJzgCsl38wiNx0RAY4USRvD6POB+tRXyiEaczpZ0zyMrMLI/zel
	DaIRcwTXMsmYu1nBmQTXrKuPW/Oc0si+0w8dI9j96Lr4sBq5Z7vCynxlpVgKE7e17yiM9BFalE7
	jv/zA4+qLnkjoiCPFc8ECNzF/FfDd6uytXRUW8jSKpsQ==
X-Gm-Gg: ASbGncsibwl5cYtIPkevPajP/JGtcWSINt2FzU7i8VDyoXY6Mq/t8hQVBIE2TKTGdBc
	g518jNANUn0xDzIlXtduGGeT8ujgQen+VBFLQHhFB+PyvG/j4M3jYe8Wo/JUz3RtyjXC2aBk4pA
	==
X-Received: by 2002:a05:651c:1478:b0:30d:b3d1:a71 with SMTP id 38308e7fff4ca-30de0357fcfmr45503681fa.33.1743474562681;
        Mon, 31 Mar 2025 19:29:22 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHvjxYb8yChU2CcRo9/SY05C6Y0KT4XHsEnqx0h01ADslFAAhIc2fe32v9KNup/a4O+0ZPG0NNOQvKyJ/HtQY4=
X-Received: by 2002:a05:651c:1478:b0:30d:b3d1:a71 with SMTP id
 38308e7fff4ca-30de0357fcfmr45503631fa.33.1743474562286; Mon, 31 Mar 2025
 19:29:22 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <5fc88c9b-83a7-414c-82da-7cccb1f876f3@dev-mail.net>
 <CALTww2-=QABMBKatYQVJ+VSAVTXvvhn1jJFUqf8ZZZb3+nx0Mw@mail.gmail.com> <0d9732b1-84c5-4875-ad22-25e546584fbf@dev-mail.net>
In-Reply-To: <0d9732b1-84c5-4875-ad22-25e546584fbf@dev-mail.net>
From: Xiao Ni <xni@redhat.com>
Date: Tue, 1 Apr 2025 10:29:09 +0800
X-Gm-Features: AQ5f1JqHcKzQpFMogAZUqWKdVF8EBlnMe9hY1V1Y_-722rQCk4QEPd7-5jIZLZk
Message-ID: <CALTww2-V8ADxpQ0+to+gyiUO-YELNwc+Fiw0vV+E-HM32L=mng@mail.gmail.com>
Subject: Re: extreme RAID10 rebuild times reported, but rebuild's progressing ?
To: pgnd@dev-mail.net
Cc: linux-raid@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 1, 2025 at 12:36=E2=80=AFAM pgnd <pgnd@dev-mail.net> wrote:
>
> hi.
>
> > Are there some D state progress?
>
> no, there were none.
>
> the rebuild 'completed' in ~ 1hr 15mins ...
> atm, the array's up, passing all tests, and seemingly fully functional

I'm glad to hear this, so everything works well now :)

>
> > And how about `ps auxf | grep md`?
>
> ps auxf | grep md
>         root          97  0.0  0.0      0     0 ?        SN   09:10   0:0=
0  \_ [ksmd]
>         root         107  0.0  0.0      0     0 ?        I<   09:10   0:0=
0  \_ [kworker/R-md]
>         root         108  0.0  0.0      0     0 ?        I<   09:10   0:0=
0  \_ [kworker/R-md_bitmap]
>         root        1049  0.0  0.0      0     0 ?        S    09:10   0:0=
0  \_ [md124_raid10]
>         root        1052  0.0  0.0      0     0 ?        S    09:10   0:0=
0  \_ [md123_raid10]
>         root        1677  0.0  0.0      0     0 ?        S    09:10   0:0=
0  \_ [jbd2/md126-8]
>         root           1  0.0  0.0  24820 15536 ?        Ss   09:10   0:0=
3 /usr/lib/systemd/systemd --switched-root --system --deserialize=3D49 domd=
adm dolvm showopts noquiet
>         root        1308  0.0  0.0  32924  8340 ?        Ss   09:10   0:0=
0 /usr/lib/systemd/systemd-journald
>         root        1368  0.0  0.0  36620 11596 ?        Ss   09:10   0:0=
0 /usr/lib/systemd/systemd-udevd
>         systemd+    1400  0.0  0.0  17564  9160 ?        Ss   09:10   0:0=
0 /usr/lib/systemd/systemd-networkd
>         systemd+    2010  0.0  0.0  15932  7112 ?        Ss   09:11   0:0=
2 /usr/lib/systemd/systemd-oomd
>         root        2029  0.0  0.0   4176  2128 ?        Ss   09:11   0:0=
0 /sbin/mdadm --monitor --scan --syslog -f --pid-file=3D/run/mdadm/mdadm.pi=
d
>         root        2055  0.0  0.0  16648  8012 ?        Ss   09:11   0:0=
0 /usr/lib/systemd/systemd-logind
>         root        2121  0.0  0.0  21176 12288 ?        Ss   09:11   0:0=
0 /usr/lib/systemd/systemd --user
>         root        4105  0.0  0.0 230344  2244 pts/0    S+   12:21   0:0=
0              \_ grep --color=3Dauto md
>         root        2247  0.0  0.0 113000  6236 ?        Ssl  09:11   0:0=
0 /usr/sbin/automount --systemd-service --dont-check-daemon
>
> > there a filesystem on it? If so, can you still read/write data from it?
>
> yes, and yes.
>
> pvs
>    PV         VG         Fmt  Attr PSize  PFree
>    /dev/md123 VG_D1    lvm2 a--   5.45t     0
>    /dev/md124 VG_D1    lvm2 a--   7.27t     0
> vgs
>    VG       #PV #LV #SN Attr   VSize  VFree
>    VG_D1      2   1   0 wz--n- 12.72t     0
> lvs
>    LV             VG         Attr       LSize  Pool Origin Data%  Meta%  =
Move Log Cpy%Sync Convert
>    LV_D1          VG_D1      -wi-ao---- 12.72t
>
> cat /proc/mdstat
>         Personalities : [raid1] [raid10]
>         md123 : active (auto-read-only) raid10 sdg1[3] sdh1[4] sdj1[2] sd=
i1[1]
>               5860265984 blocks super 1.2 512K chunks 2 near-copies [4/4]=
 [UUUU]
>               bitmap: 0/44 pages [0KB], 65536KB chunk
>
>         md124 : active raid10 sdl1[0] sdm1[1] sdn1[2] sdk1[4]
>               7813770240 blocks super 1.2 512K chunks 2 near-copies [4/4]=
 [UUUU]
>               bitmap: 0/59 pages [0KB], 65536KB chunk
>
> lsblk /dev/sdn
>         NAME                  MAJ:MIN RM  SIZE RO TYPE   MOUNTPOINTS
>         sdn                     8:208  0  3.6T  0 disk
>         =E2=94=94=E2=94=80sdn1                  8:209  0  3.6T  0 part
>           =E2=94=94=E2=94=80md124               9:124  0  7.3T  0 raid10
>             =E2=94=94=E2=94=80VG_D1-LV_D1     253:8    0 12.7T  0 lvm    =
/NAS/D1
>
> fdisk -l /dev/sdn
>         Disk /dev/sdn: 3.64 TiB, 4000787030016 bytes, 7814037168 sectors
>         Disk model: WDC WD40EFPX-68C
>         Units: sectors of 1 * 512 =3D 512 bytes
>         Sector size (logical/physical): 512 bytes / 4096 bytes
>         I/O size (minimum/optimal): 4096 bytes / 131072 bytes
>         Disklabel type: gpt
>         Disk identifier: ...
>
>         Device     Start        End    Sectors  Size Type
>         /dev/sdn1   2048 7814037134 7814035087  3.6T Linux RAID
>
> fdisk -l /dev/sdn1
>         Disk /dev/sdn1: 3.64 TiB, 4000785964544 bytes, 7814035087 sectors
>         Units: sectors of 1 * 512 =3D 512 bytes
>         Sector size (logical/physical): 512 bytes / 4096 bytes
>         I/O size (minimum/optimal): 4096 bytes / 131072 bytes
>
> cat /proc/mounts  | grep D1
>         /dev/mapper/VG_D1-LV_D1 /NAS/D1 ext4 rw,relatime,stripe=3D128 0 0
>
>
> touch /NAS/D1/test.file
> stat /NAS/D1/test.file
>           File: /NAS/D1/test.file
>           Size: 0               Blocks: 0          IO Block: 4096   regul=
ar empty file
>         Device: 253,8   Inode: 11          Links: 1
>         Access: (0644/-rw-r--r--)  Uid: (    0/    root)   Gid: (    0/  =
  root)
>         Access: 2025-03-31 12:33:48.110052013 -0400
>         Modify: 2025-03-31 12:33:48.110052013 -0400
>         Change: 2025-03-31 12:33:48.110052013 -0400
>          Birth: 2025-03-31 12:33:07.272309441 -0400
>

Regards
Xiao

