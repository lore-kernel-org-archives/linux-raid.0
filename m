Received: from va-2-26.ptr.blmpb.com (va-2-26.ptr.blmpb.com [209.127.231.26])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88C0713AF2
	for <linux-raid@vger.kernel.org>; Fri, 24 Apr 2026 02:11:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.26
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776996700; cv=none; b=SAeWkv98BwXbYvGKhdEU42Azv+BPWKAHkNfAsHAgLrwDmQ1TbWRcHBrKldU6gVVRZZKO7rFoczIBYPYVywEBaYfy8neNNSj5eAJikKZhokvAQZMBloN1TBamZibdD4XHvDUOKF62gAsVAcXJiC/0vyzmx3jmD8n0Z5RGvCv794g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776996700; c=relaxed/simple;
	bh=8BeiSIKftjAqMsTbedJvrAZdtGSjomhEVgAcIXTimhc=;
	h=From:Message-Id:In-Reply-To:References:Content-Type:
	 Content-Disposition:Cc:Subject:Date:To:Mime-Version; b=GqtRIac/RoHiA15mh9kw0qOphX4fbOUcxULjWrYOf0AUeOA758iDeSTUfyjRqDEeTCIeSH71qNMmL0ZYUPvy8rHS+P89Jztz6Nj3KhhbdUFoInM7cdboUAKS/FnOUVGCKw0qb2t9x6BsmRRu/MzIJ525q+GR6pss8RQh2eS5PNs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com; spf=none smtp.mailfrom=fnnas.com; dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b=Gn8nlV3E; arc=none smtp.client-ip=209.127.231.26
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=fnnas.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b="Gn8nlV3E"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fnnas-com.20200927.dkim.feishu.cn; t=1776996686;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=b3AythhQp67R21PdOExFx24M/GF/mchYoydZOIA2mZk=;
 b=Gn8nlV3EX3TxmhMQtI7+RpZqtpD9vivqtLdVeXSC6ruoYTiNpRlxKTvSVncjPeV5oskYs0
 Jp3BwcDayi4urJ8xZuz1PxFrOyV0ZQYOWFoU4f+TJsPHQAy68q100qBe82RGT+zSvLcUuS
 E2jYj6lM9o0d82FCjdNDiI/dNee6aIEUhnSX7LOQtWfmFqOQFVZq4h/bHTN4GAGGr2/K2L
 NJJ4YzEjj8twqosCmGKEflM1ezaGiizmQJ9exsetFbV/1c0NGBC5hsliiCl2ptWYwADuXR
 //5aMwrDI4liIpitO6VJ3OL7nNE4ZK460b6pM5xUNUzist3UIhqCkLXnkow1ew==
From: "Chen Cheng" <chencheng@fnnas.com>
Content-Transfer-Encoding: quoted-printable
X-Original-From: Chen Cheng <chencheng@fnnas.com>
Message-Id: <aerQ-L00v3c-7rNv@fedora>
In-Reply-To: <6e6e4340-2181-4a79-9284-7ed167aab807@molgen.mpg.de>
References: <20260422023317.796326-1-chencheng@fnnas.com> <6e6e4340-2181-4a79-9284-7ed167aab807@molgen.mpg.de>
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Lms-Return-Path: <lba+269ead14c+dd5612+vger.kernel.org+chencheng@fnnas.com>
Cc: <linux-raid@vger.kernel.org>, <yukuai@fnnas.com>, 
	<chenchneg33@gmail.com>
Subject: Re: [PATCH 1/4] md/raid10: prepare per-r10bio dev slot tracking
Date: Fri, 24 Apr 2026 10:11:22 +0800
To: "Paul Menzel" <pmenzel@molgen.mpg.de>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Received: from localhost ([113.111.140.53]) by smtp.feishu.cn with ESMTPS; Fri, 24 Apr 2026 10:11:23 +0800

On Wed, Apr 22, 2026 at 08:40:42AM +0200, Paul Menzel wrote:

Hi Paul,

> Dear Cheng,
>
>
> Am 22.04.26 um 04:33 schrieb Chen Cheng:
> > From: Chen Cheng <chencheng@fnnas.com>
> >
> > raid10 reuses r10bio objects from both r10bio_pool and r10buf_pool. Tra=
ck
> > the number of devs[] slots used by each request in the r10bio itself an=
d
> > initialize it whenever one of these objects is reused.
> >
> > No functional change yet. A later patch will use this width when reshap=
e
> > changes conf->geo.raid_disks.
>
> Your Signed-off-by: line is missing.

Yes, i missed it, thanks for point-out;

>
> > ---
> >   drivers/md/raid10.c | 4 ++++
> >   drivers/md/raid10.h | 1 +
> >   2 files changed, 5 insertions(+)
> >
> > diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
> > index 0653b5d8545a..e93933632893 100644
> > --- a/drivers/md/raid10.c
> > +++ b/drivers/md/raid10.c
> > @@ -1540,6 +1540,7 @@ static void __make_request(struct mddev *mddev, s=
truct bio *bio, int sectors)
> >     r10_bio->sector =3D bio->bi_iter.bi_sector;
> >     r10_bio->state =3D 0;
> >     r10_bio->read_slot =3D -1;
> > +   r10_bio->used_nr_devs =3D conf->geo.raid_disks;
> >     memset(r10_bio->devs, 0, sizeof(r10_bio->devs[0]) *
> >                     conf->geo.raid_disks);
> > @@ -1727,6 +1728,7 @@ static int raid10_handle_discard(struct mddev *md=
dev, struct bio *bio)
> >     r10_bio->mddev =3D mddev;
> >     r10_bio->state =3D 0;
> >     r10_bio->sectors =3D 0;
> > +   r10_bio->used_nr_devs =3D geo->raid_disks;
> >     memset(r10_bio->devs, 0, sizeof(r10_bio->devs[0]) * geo->raid_disks=
);
> >     wait_blocked_dev(mddev, r10_bio);
> > @@ -3061,6 +3063,8 @@ static struct r10bio *raid10_alloc_init_r10buf(st=
ruct r10conf *conf)
> >     else
> >             nalloc =3D 2; /* recovery */
> > +   r10bio->used_nr_devs =3D nalloc;
> > +
> >     for (i =3D 0; i < nalloc; i++) {
> >             bio =3D r10bio->devs[i].bio;
> >             rp =3D bio->bi_private;
> > diff --git a/drivers/md/raid10.h b/drivers/md/raid10.h
> > index ec79d87fb92f..92e8743023e6 100644
> > --- a/drivers/md/raid10.h
> > +++ b/drivers/md/raid10.h
> > @@ -127,6 +127,7 @@ struct r10bio {
> >      * if the IO is in READ direction, then this is where we read
> >      */
> >     int                     read_slot;
> > +   unsigned int            used_nr_devs;
>
> Most entries have a comment describing the use. Maybe add one too, or at
> least a blank line, so it=E2=80=99s clear that the existing comment is ju=
st for
> `read_slot`?

Agreed.

>
> >     struct list_head        retry_list;
> >     /*
>
> From a performance and resource usage point of view, will increasing the
> struct have a negative impact?

On 64-bit platform, doesn't have negative resource usage impact,
the new field fits into the existing padding after read_slot, so
offsetof(struct r10bio, devs) stays unchanged;

On 32-bit platform, may increase by 4 bytes per r10bio, but that's
negligible compared with the bios/pages allocated for each request;


No negative performance impact, cause bottleneck is IO, and
the IO path has no changed;

>
> The diff looks good.
>
> Reviewed-by: Paul Menzel <pmenzel@molgen.mpg.de>
>

Thanks for review;

>
> Kind regards,
>
> Paul


Thanks,
Cheng
