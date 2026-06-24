Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2915F331222
	for <linux-raid@vger.kernel.org>; Wed, 24 Jun 2026 16:53:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.214.177
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782320002; cv=pass; b=jfu8i9P0Q/78sTlMGzDnfDtJd34CkDiT0Xlw1RmhLuQQOKF1xuWsunU88gx4aEezWdi8lhP2e8jqlizfy8aLLAShT2ZDQiNdPfv2KSGFHR6Ux5cjKHFrKdCMKf0Z8hMcAPp0ww9ydz6jqt8y7d50Af9FHJ4A5l5aTQOot3RLfTw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782320002; c=relaxed/simple;
	bh=1YKOn6iykGR+PpfgAmVKfnTkua3jmSo3nJ/j1AVT4Gk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=FmV//ZHazZsCsxSGi1EO3nKxAEcT8t/A8wC6ib9onnzlreXPuECGc5dDklIJZnl+e25u+mHqU6olJV+A80neBPMqHEVzgALu1wzQlTh0aTsyEYmO2pXBOg4cgmapdn3g6ofMo8XJFGHpLiaelm9xui3kzVKXGlyGzru84iRY3Bg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Xu2u8d0E; arc=pass smtp.client-ip=209.85.214.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Xu2u8d0E"
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-2c7f385883cso1764455ad.2
        for <linux-raid@vger.kernel.org>; Wed, 24 Jun 2026 09:53:20 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1782320000; cv=none;
        d=google.com; s=arc-20240605;
        b=IIVO8+ksf4/SYY2oW5ED8QWKv+9xhT1sxOQi4lY6gbBTpWIyq6aiJPHg0ugIHtbJPS
         6taKzvnSl1ChtvhxZ56G0i//lLXJ3GPTOjb+OrNdh9KR69RItrDlGhCwNfzFVyZ+UPN7
         bgSp9jWQK5xe/lLbg3br5jNMpADBUV7CjCzicw93b7+cpWzKdMpnpGNnLgzqqh1tXXNc
         OBQv4xqyD3yYQhN2XseYN9pzpQ4JeJFyvngisaV/53pciM9G9D+zw4bSozlM9wgnLj+r
         pW9Nc5/EmjQrIBH/xFQ04ivrIPHJtshBEuKhlRh6lBpTW05Z6w7RSzfGp1KIHqu0D+XM
         VF8w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=8BIRn0WlxcOKwd3gT1ODjWCiP9As9Dq4sSxam8CvvJo=;
        fh=mTP6TkWV1IhQRgyhsEpYqIpiXvhDlZKdHAfNRdOTDjk=;
        b=HhTT1mI3X9BXzE+sP0+X6EjOmgoIi+I+bcfUrmf7PPrwZyK9nrN9v/wFXy/gf2VLHl
         OFN3PSNrL20sLAf0F+ljFUguNvXNy0t0goyE6OQgAglIV5gGkw7wdpcgA7Qh3NY/61jw
         fxw/ledbq2Ocvv/+BQMsMq7G7qezHHTE/kN//k+Ps1/WPw1EfUWA1d9/1/ATgk0KHcji
         0X++Ovcoq38NtSGZLV4QKM1BErT7TopwMgT+jjD7NLXOOgz0mXVRlvemJMAgKA5WVJxh
         pzlDWRiRN4iA/STnrswH81teVF5MInmxIbzyQcG6tOyeHsDK45lsH+5M0n/jp+we7c6a
         4kKg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782320000; x=1782924800; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8BIRn0WlxcOKwd3gT1ODjWCiP9As9Dq4sSxam8CvvJo=;
        b=Xu2u8d0E6j8thnTmh64JmOMxtdLkNR8Y6tAI+Gbn+WeejKPPo0wuxzWqOqeRZ7gx1A
         QR+4dnGwtSDVIwP/k0OmNPWK+ZAyKT/R2hr4/T3+VLNBV0Tj2XZy+IsCrQmYLICYp3Ij
         HlVovOitTdi/Sc7XiOlqb0EzFGm6a1Dm2lXuknAqAy8KHLZ0rocfCrUJPWHK85VcRhTo
         qoP3HN3V5WL0AfhnZOyj0OMNe9OzDWjsl14PzolQz7Bl974aKzCXJJQjhiAImFKQLQwj
         ckEebG06A0RP7sXiuBveoPs7JxdBlQ28+ZDsSstDlcF9iPcN15hJa5NxpLgmlNMgFV9Z
         0mdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782320000; x=1782924800;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=8BIRn0WlxcOKwd3gT1ODjWCiP9As9Dq4sSxam8CvvJo=;
        b=bbVQsqe1sNbyEaiOiox4wtmdVB83rGVRpCc+RkGJiWttxIdSroS62crC1XazDUxAzo
         vHJi7+tX0soQ2vTZUQhOyXrMNVk9QtG2EGQecghCEDCdfuCeJ6/0psK3AWdtDNL6NYtA
         cOT4t4SlyZMruaNMv8HtSsfF15cQtuzuio9n4K622/LYOHoWG56NYc4BusMH9XgHplDp
         Xi1vKNmOW0+R4iFOlwDYlsvuKVlklMlMXXK8Oi87pACi2TvrIczcjv2fDAeu/5Ujjjql
         zxBhvuD090Vp0v2ELLyDrL2mR9ZaJuWwth6TFOKUesBT+hsjsXf0V+1meWrTQfpgzLpV
         qPvg==
X-Gm-Message-State: AOJu0YzFdY3cFnPCR975X2alXYjeldUGYCHaaR9xJcxe8G+pqBVwMsaT
	kMRIA9gZA9dhKoq9NOV1KyA35KrONpZpSroA8J5iHbmrAnTc1cbxbltTonsg38xDW0fCsULOLlY
	P/8vTVNdjQVVHEcdE99HOUyfce7Z2inM=
X-Gm-Gg: AfdE7cmRxaueAnnpEvz0BxcqRQ/15JX2R/0SfhRhVYRDaqouPOOCcKMNmdP/UqgKYxa
	YU+z53HzdI0gui8sGQLbvZHm1xuScf360Y5p7lCcS3nxIv9QIejnesayKRSSWjb7fhTjum7HpmI
	F6Jz2cK/BBm7Jx5MSsMISm/yXRmmj0goSAQCBiiAzrO//tmVtiB6E+5pJfvgzYk7FoM/AZG+l0d
	gj/BIQwWpaWrMEi5gwyKANIwxJAtr+ZjcwZA4KFhC5w6+mn/a5DOZfMXPZoLJU8QfvgTr6bkAWs
	rxXm0ARskeCZ0BJ+s1AuCYy68wmR88rMK6C0JxOLtjAqk/LUkaB0GP4fNQo6zxtzgeJhCQqOz9K
	887ZYmM6yxgMjT22KpDF9vTM=
X-Received: by 2002:a17:902:ea12:b0:2c6:a76c:3c6a with SMTP id
 d9443c01a7336-2c7e1465892mr46323745ad.9.1782320000213; Wed, 24 Jun 2026
 09:53:20 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260624155452.211646-1-nishidafmly@gmail.com>
 <20260624155452.211646-7-nishidafmly@gmail.com> <20260624160726.2B9161F000E9@smtp.kernel.org>
In-Reply-To: <20260624160726.2B9161F000E9@smtp.kernel.org>
From: Hiroshi Nishida <nishidafmly@gmail.com>
Date: Wed, 24 Jun 2026 09:53:08 -0700
X-Gm-Features: AVVi8CdzUzUpWfTZUjvJHGvAckn35Sku1BaU2R15oqRJV6Hh0aAtw4sO4uhAZmM
Message-ID: <CAE1ksKTBHgcUqb-qw8N5FYc895sniwNqesW9AsPYJ-xeqe_DkQ@mail.gmail.com>
Subject: Re: [PATCH 6/8] md/raid5: allocate worker groups per NUMA node
To: sashiko-reviews@lists.linux.dev
Cc: linux-raid@vger.kernel.org, yukuai@fygo.io
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

> [High] kzalloc_node(size, GFP_NOIO, i) -- i is a sequential index, not a =
node ID
> [High, pre-existing] worker_groups sized by num_possible_nodes() but inde=
xed
> by node ID -> OOB on sparse NUMA

Both are valid.
The kzalloc_node(..., i) is wrong on sparse NUMA node IDs -- i runs
0..num_possible_nodes()-1, which only equals the node ID when nodes
are dense -- and it rides on the pre-existing assumption that the
worker_groups array (sized by the node *count*) can be indexed by
cpu_to_node().

The NUMA-locality win here is multi-socket-only and I don't have a
measurement to justify it, so rather than grow this into a sparse-NUMA
correctness fix I'll
drop this patch from v2.
The pre-existing worker_groups sizing/indexing issue is real and
separate; thanks for catching it.

Thanks,


2026=E5=B9=B46=E6=9C=8824=E6=97=A5(=E6=B0=B4) 9:07 <sashiko-bot@kernel.org>=
:
>
> Thank you for your contribution! Sashiko AI review found 2 potential issu=
e(s) to consider:
>
> New issues:
> - [High] The patch incorrectly uses a sequential loop index `i` as the NU=
MA node ID parameter to `kzalloc_node()`.
>
> Pre-existing issues:
> - [High] The `worker_groups` array is sized using `num_possible_nodes()` =
but is indexed by the raw NUMA node ID, leading to out-of-bounds accesses o=
n systems with sparse NUMA node IDs.
> --
>
> commit bce08bf6ce446b00da625ff4028f5782b756e17c
> Author: Hiroshi Nishida <nishidafmly@gmail.com>
>
> md/raid5: allocate worker groups per NUMA node
>
> alloc_thread_groups() previously allocated all r5worker arrays in a
> single kcalloc() block, assigning workers for NUMA node N from node 0
> memory.  On multi-socket systems this causes remote memory traffic on
> every worker->work and worker->temp_inactive_list access.
>
> > diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> > index 8e9edaaca667b..c8787ab7b309c 100644
> > --- a/drivers/md/raid5.c
> > +++ b/drivers/md/raid5.c
> [ ... ]
> > @@ -7336,7 +7340,6 @@ static int alloc_thread_groups(struct r5conf *con=
f, int cnt, int *group_cnt,
> [ ... ]
> >       *group_cnt =3D num_possible_nodes();
> > -     size =3D sizeof(struct r5worker) * cnt;
> > -     workers =3D kcalloc(size, *group_cnt, GFP_NOIO);
> >       *worker_groups =3D kzalloc_objs(struct r5worker_group, *group_cnt=
,
> >                                     GFP_NOIO);
>
> [Severity: High]
> This isn't a bug introduced by this patch, but could this array sizing ca=
use
> an out-of-bounds access on systems with sparse NUMA nodes?
>
> We size the worker_groups array using num_possible_nodes(), which is a co=
unt.
> On systems with sparse NUMA node IDs (for example, nodes 0 and 8), the ar=
ray
> would only have 2 elements. Later, in raid5_wakeup_stripe_thread(), we in=
dex
> into this array using cpu_to_group(cpu) which expands to cpu_to_node(cpu)=
.
> If a CPU belongs to node 8, we would access conf->worker_groups[8], excee=
ding
> the allocated size and corrupting memory.
>
> > -     if (!*worker_groups || !workers) {
> > -             kfree(workers);
> > -             kfree(*worker_groups);
> > +     if (!*worker_groups)
> >               return -ENOMEM;
> > -     }
> >
> > +     size =3D sizeof(struct r5worker) * cnt;
> >       for (i =3D 0; i < *group_cnt; i++) {
> > -             struct r5worker_group *group;
> > +             struct r5worker_group *group =3D &(*worker_groups)[i];
> > +             struct r5worker *workers;
> > +
> > +             workers =3D kzalloc_node(size, GFP_NOIO, i);
>
> [Severity: High]
> Could passing the sequential loop index i directly to kzalloc_node cause =
a
> NULL pointer dereference on systems with sparse NUMA nodes?
>
> Since num_possible_nodes returns a count rather than an upper bound on ID=
s,
> on a system with nodes 0 and 8, i would be evaluated as 1. Passing an
> unpopulated node ID to kzalloc_node without validation can lead to a cras=
h
> when accessing NODE_DATA(nid). Should this loop use
> for_each_node_state(nid, N_MEMORY) or similar to get the actual node ID
> instead of using the loop counter?
>
> > +             if (!workers)
> > +                     goto out_free;
>
> --
> Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260624155452.21=
1646-1-nishidafmly@gmail.com?part=3D6



--=20
Hiroshi Nishida
nishidafmly@gmail.com
