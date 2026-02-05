Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 210A023ABB9
	for <linux-raid@vger.kernel.org>; Thu,  5 Feb 2026 01:07:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=170.10.129.124
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770253626; cv=pass; b=nqd5td9RFmsX9YOPWfKIWMJ1PVe/nxfzXQMt/UIfS9Qk46dHAc4E/b9yzebJq4ayI0dDI6bMfWoBtKGZsddjUIqEsuOC3mUx04nvOikL2BHMdW2L32OD/QEuNAFt2EHuKFioA9MbRNgcqJkDmZYQSMq+xDxIH4uPrt/tOS4/W4U=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770253626; c=relaxed/simple;
	bh=zhVDgQD6xAHcaqRYA43yYTZbbZFjX5kytG840C69W0U=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ssdHSyR4bkOPGSaMNER6GKrG2JvXz4+oIsD/ILIbXcs3SHRbD/zQnxFXDZVjRf0ODl70zdDEA1k7Nz42MCpb4bJG3U5FZ6xY+qYfgZBVfRiACPyY8RmVAEjHfdVQVTWOVUinsWXK8JilBk0rVeVxXc9xvLAXI8cXLFXIY1IkDnc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=DHK1nOk0; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=UuqwEmHb; arc=pass smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DHK1nOk0";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="UuqwEmHb"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1770253625;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Ub7hSbT61PMK1MPGkG6Qy4gd1KdLH7elgnBinsmj/zg=;
	b=DHK1nOk05EOdvZ3Vh2vMw9NCJwMjQGd5eoT20vxjJXgMMGzZJwCTffutKDFfb9sIdpuSsg
	7g5951ziHeXdfEBppqn1sN2Qk3zBRDz5bwchEW2+SQTwDTBHjkMukeQPG9NK12YULwW4zB
	2FAbyufnIEhVUXPPL5/nhKLSynscaDg=
Received: from mail-lf1-f70.google.com (mail-lf1-f70.google.com
 [209.85.167.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-691-NQZEHeIvNLG6WonB6Ort_A-1; Wed, 04 Feb 2026 20:07:03 -0500
X-MC-Unique: NQZEHeIvNLG6WonB6Ort_A-1
X-Mimecast-MFC-AGG-ID: NQZEHeIvNLG6WonB6Ort_A_1770253622
Received: by mail-lf1-f70.google.com with SMTP id 2adb3069b0e04-59de4460e35so230719e87.3
        for <linux-raid@vger.kernel.org>; Wed, 04 Feb 2026 17:07:03 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1770253622; cv=none;
        d=google.com; s=arc-20240605;
        b=ZqOTArkKSC/2pPLnXOJ6m/LzwR6ZcaIXBX7yjDMCHxjOyMCx4el+iKvNq4ULECRmhv
         q6WUgBz2g9R65kkAeGUzSmgf+UISQkpGVF5ksZamC2K8sislMqozN5oaPejYuoBW+m4a
         OagX9la/2HVLe6m3la/csQExwXEHj+EndxJC7cScwPF6Y45bQZJOEaXb11hIMkD6k1PK
         aYk4RfHpfZL7dayCwLInDNdIBp1jtmvFfHWnBiZioqhD9cD5ieLpANYkAT62cy40Le+h
         6hAAzhQH/zCVSec2MnoLqMTuRjivaahc9YUR3xPi1gMxYsYKpSOWlIT+xMX+cdP0LM56
         o4Fw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Ub7hSbT61PMK1MPGkG6Qy4gd1KdLH7elgnBinsmj/zg=;
        fh=Zr0Gmz5K2XVnY7DhlR+Mkq3b//E82H/QrSYkAntOeE0=;
        b=LkcscnrzoDmkS8r6ARU0TzlPoFYBgE3reorECdeXQy1+9AqINbWgeQFSh06xdMmzZR
         r30AM/7TTeZSjLRSX1Zq+oT3DGuTiGjKrBTK+imvvu4mashF6Zwl+E+ZU0HFz23fCbrc
         jMbmPrAIMj0ZoxwUNb0igMIOJKAn5xIO4C9fUJNtCEwXv56giTlGqCrJMfIyKU4IEBqs
         V3Ye9jtWbOPfuuv6n2GgvdGqyCOZzObHWTqQ3nYWLxAJb2SdUUEhInxd7DoNAi0ZlTCz
         SVQsHEz3uKSGAdhiD7YaWlHLy0BiG+z/hMjl4xb+VIrzO01XWbkJxpp2cypbDvgOeS9t
         ZRYg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1770253622; x=1770858422; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Ub7hSbT61PMK1MPGkG6Qy4gd1KdLH7elgnBinsmj/zg=;
        b=UuqwEmHbPH93HuhLbOl0DhIo+YJ8XaeJY4r4rsnPFEpHKtj7xohvAH5B4fVkj/oNqk
         YMOrIXsrg01PP1RXUHnFj7dFp8n2cso0N+FB7M6S5hnz4DjCBDF/COJyJDP+LvOEs1WR
         6L0NKQk39P9JBeGea+8/XXXSSvjbLBwJ4lkmXCZUyycIUoCpYkJjenFSBlxIDu5LXx5t
         DZhLb0kdkUjSz3e94iasGQFF1BmJw9HcVogOhlTJ8U3jLr7Q+dnzKkgH7j5Hbk0hnf9G
         TyDESRgaSttP7YqlvtW8FtdHwDMrSyQRAWZx3VUEClKk5nia4y6MxtKWtbisBAIMr/Uc
         qqTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770253622; x=1770858422;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Ub7hSbT61PMK1MPGkG6Qy4gd1KdLH7elgnBinsmj/zg=;
        b=AjQQXxQzHgQIoBz7HUF1kH0AjPSklq82tYR8k2UbzxTvmniyCDB5Byq1M7UW/hA0FP
         NgWDUHTxkhZ7o+N1dRIujNKpqCQ77oI1Iha5kBH6SNECfawjZXDENYEfJifwhRKRP1Bs
         A0PNJd3R4AmeJquXr9CXrGdLF1GRwQ803+T91tX1dlopaWIjM64ItxtNCP0DmbBOosys
         SLyJTYdseAEB7YmvbffVZj2xrrvio5mzyIzj5juHQStR7RDDz0qfGTDbl+NpQ30rZQHx
         3iNuyqUXMKtsCo2cqoGHH/PrzkJV3197hABr/dGizoEukH9ZNSQ9JeE5vrYqLO4veI7X
         Wiig==
X-Gm-Message-State: AOJu0YxUgy4H85fkGqnxBiz3mQhhKkx75bqa3ETSJJKEGmOGxpVGBqwl
	vKpX+UdU4vaiprrdz9IEH2SK+tsOjGx79pOlMgMo5iyDUv4Rrb8iCYmUqQJbByiM1g1O/62ocJY
	n7AZ3o1eMYeKGfFrhEZXZl+mzvO/YsW60NOw2OF+pFBSOMPSX/Mzjt5rREC++e12WWi+Vh355X0
	T3I+AagPfBu4/kxF4BjG4vqE3etS392iLVfvGnZw==
X-Gm-Gg: AZuq6aKunsNL6RGP+EPThfv4zb5my8P/mh/nJKrXv5fMm65z1w6V5ZHIB/GIBE2MkiK
	GcjHyZSFlY7gTcBuHCQiElWyJtfVLNVvskAOjkTS2khM51IZLD0IIaZeCAd7zmwsVaAmmDG5NAA
	z1fkk/QcynkOSnp48I+Y5UHYPugRlHKIATGF4saxrMamOfXeWhmB9leZh0ICDqqjYlUGiDrdgdC
	GThPuWmrcBGgY22i3NxMqsm8Uw7/f50pCE1iDxtNEtxR5XmW7GT4IHZAgUM+7wtvF2lXA==
X-Received: by 2002:a05:6512:108c:b0:59b:6ae7:63ee with SMTP id 2adb3069b0e04-59e38c02399mr1717805e87.3.1770253622035;
        Wed, 04 Feb 2026 17:07:02 -0800 (PST)
X-Received: by 2002:a05:6512:108c:b0:59b:6ae7:63ee with SMTP id
 2adb3069b0e04-59e38c02399mr1717796e87.3.1770253621540; Wed, 04 Feb 2026
 17:07:01 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260204145912.9463-1-xni@redhat.com> <a058e5a3-e96c-4feb-8f9d-e1135951973c@fnnas.com>
 <CALTww28vHeWNf7kejN_R_-K_nu4JJRig6ieQRBv63N1Xy7FXhw@mail.gmail.com>
In-Reply-To: <CALTww28vHeWNf7kejN_R_-K_nu4JJRig6ieQRBv63N1Xy7FXhw@mail.gmail.com>
From: Xiao Ni <xni@redhat.com>
Date: Thu, 5 Feb 2026 09:06:49 +0800
X-Gm-Features: AZwV_QhY_CU14Df64T-EFSUYFmt0jbW2_XUtFAWKAeOLqeoKspvVAb3PxonAK9A
Message-ID: <CALTww2_e_49Cy=WLhtZVWWtMK+=v8dErCSvxK9qpB0vmybsGyw@mail.gmail.com>
Subject: Re: [PATCH RFC 0/3] md/raid1: data corruption with serialization
To: yukuai@fnnas.com
Cc: linux-raid@vger.kernel.org, Guoqing Jiang <guoqing.jiang@linux.dev>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Feb 5, 2026 at 8:34=E2=80=AFAM Xiao Ni <xni@redhat.com> wrote:
>
> On Wed, Feb 4, 2026 at 11:58=E2=80=AFPM Yu Kuai <yukuai@fnnas.com> wrote:
> >
> > Hi,
> >
> > =E5=9C=A8 2026/2/4 22:58, Xiao Ni =E5=86=99=E9=81=93:
> > > A data corruption can happen when using serialization for raid1.
> > > Serialization is not enabled by default. But it looks like there
> > > is a data corruption risk if serialization is closed. Because the
> > > lower driver can't guarantee the sequence which io is written first.
> > > So it's possible that different member disks will have different
> > > data for nvme devices. This patch set doesn't open serialization
> > > by default.
> >
> > An important idea is that if there are filesystem on top of raid1/10/5,=
 there
> > is no need to consider overlap bio. The only case for serialization is =
WriteMostly,
> > that bio can be returned to user while it's not done for slow disks. An=
d that is
> > the reason why serialization is for rdev.
>
> I know the reason why it needs serialization for writemostly case. At
> first, I asked the same question if we need to handle overlap if a
> filesystem is on raid. I got the answer from AI, filesystem can submit
> overlap bios simultaneously, maybe it's the reason why
> serialize_policy was introduced? And database is another case which
> can write to raid1 directly without a filesystem. So I started this
> job. If we don't need to consider overlap, why do we need
> serialize_policy? cc guoqing who is the author of serialize_policy
> also.
>
> >
> > We definitely will not enable serialization by default, because there w=
ill
> > be huge performance degradation. And I don't think we'll handle the cas=
e user
>
> Yes, this is the reason why I don't enable it.
>
> > manage data with raw disk, and write to the same area concurrently. At =
last, if
> > there are still problem with WriteMostly case, please rebase and keep s=
erialization
> > for rdev.
>
> The data corruption is:
>
> R1 issued (split into LO and HI)
> (LO)                                                              (HI)
> R1 write to high-speed disk begins              R1 write to high-speed
> disk waits (waits while LO is being written due to an incorrect sector
> range)
> R1 write to low-speed disk begins
> R1 write to high-speed disk completes
> High-speed disk wakes up                           R1 write to
> high-speed disk begins
>
> R1 write to low-speed disk waits (waits while LO is being written due
> to an incorrect sector range)
>
> R1 write to high-speed disk completes
> R1 completion notification
>
> R2 issued (split into LO and HI)
> R2 write to high-speed disk begins              R2 write to high-speed
> disk waits (waits while LO is being written due to an incorrect sector
> range)
> R2 write to low-speed disk waits (due to R1 being written)
> R2 write to high-speed disk completes
> High-speed disk wakes up                           R2 write to
> high-speed disk begins
>
> R2 write to low-speed disk Wait (R1 is still waiting)
>
> R2 write completed on high-speed disk
> R2 completion notification
>
> R1 write completed on slow disk
> Slow disk wake-up
> R2 write started on slow disk
> R2 write completed on slow disk
> Slow disk wake-up                                       R2 write
> started on slow disk *R2 will be written before R1 here.
>
> R2 write completed on slow disk
>
> Slow disk wake-up
>
> R1 write started on slow disk

Sorry the format looks a mess.

And let me change to this:
Setup: RAID1 with one fast disk and one slow disk. Two requests R1 and
R2, each split into LO and HI parts

Step 1-10: Request R1 Processing
  - R1-LO: writes to fast disk =E2=86=92 completes
  - R1-LO: writes to slow disk =E2=86=92 starts (slow)
  - R1-HI: incorrectly waits for R1-LO (wrong sector range check)
  - R1-HI: R1-LO finishes and wakes up serial_io_wait. R1-HI finally
writes to fast disk =E2=86=92 completes
  - R1 completion notified (but R1-LO to slow disk is still handling,
R1-HI still pending on slow disk)

Step 11-19: Request R2 Processing
  - R2-LO: writes to fast disk =E2=86=92 completes
  - R2-LO: waits for R1-LO on slow disk (correct behavior)
  - R2-HI: incorrectly waits for R2-LO (wrong sector range check)
  - R2-HI: writes to fast disk =E2=86=92 completes
  - R2 completion notified

Now, R1-LO is writing to slow disk, R2-LO is pending on slow disk.
R1-HI and R2-HI are pending on slow disk

Step 20-28: Slow Disk Completes (OUT OF ORDER!)
  - R1-LO completes on slow disk
  - R2-LO starts and completes on slow disk
  - R2-HI starts and completes on slow disk =E2=86=90 R2 BEFORE R1!
  - R1-HI finally starts and completes on slow disk

RESULT:
=3D=3D=3D=3D=3D=3D=3D
Fast disk write order:  R1-LO =E2=86=92 R1-HI =E2=86=92 R2-LO =E2=86=92 R2-=
HI  (CORRECT)
Slow disk write order:  R1-LO =E2=86=92 R2-LO =E2=86=92 R2-HI =E2=86=92 R1-=
HI  (WRONG!)

The slow disk has R2-HI written before R1-HI, causing data corruption.

Best Regards
Xiao


>
> Patch03 can fix this problem. But the root cause should be the
> sequence getting lock after being woken up. So besides patch03, it is
> necessary to ensure that the order of processing I/O matches the order
> of adding I/O. If we don't need to consider upper layer can submit
> overlap bios simultaneously, I'll fix this based on rdev rathar than
> mddev.
>
> Best Regards
> Xiao
>
> >
> > >
> > > Xiao Ni (3):
> > >    md: add return value of mddev_create_serial_pool
> > >    md/raid1: fix data corruption by moving serialization to mddev lev=
el
> > >    md/raid1: fix incorrect sector range in serialization
> > >
> > >   drivers/md/md-bitmap.c |  28 +++++--
> > >   drivers/md/md.c        | 171 ++++++++++++++------------------------=
---
> > >   drivers/md/md.h        |  30 ++++----
> > >   drivers/md/raid1.c     |  47 ++++++-----
> > >   4 files changed, 115 insertions(+), 161 deletions(-)
> > >
> > --
> > Thansk,
> > Kuai
> >

