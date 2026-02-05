Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DB2813A244
	for <linux-raid@vger.kernel.org>; Thu,  5 Feb 2026 00:34:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=170.10.129.124
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770251680; cv=pass; b=KhK9vIlrsHVi5LfgqeRmCeZSDeEAApb/VcfRi4whc6mukfbjoQHc+p7ovu6e9u4taDCVXrnDBg0d8HGBvmziwUSu6CU/cMPVxHnCEqi5WKpkUmg8XLgsvsXR4KmYqa4njGgfdMuQf1+oSdrteDC6oxQtQaW7qxfgW+7Jekzv0ZU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770251680; c=relaxed/simple;
	bh=4oOrEWUDFlAPCOAjegTvblhs1rVJJRMfj0800pcI0i0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=jovBS2btJCQIZT6M+YRDTHYbbGdujOLJRtF3haiZgZ3iXXOJ6IVr9aKH+Rq1a7lwoGMVWEIlR1XiOpijrRWpqaykMYtXEK84s5t7/pIbI1nQxJD7oPYXnDNEixO/2bI9oVUDowx3d6XIdc5yXCNBBsKW3UiHBmgvGgdHL6ibvoU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=BAst9qNJ; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=qAVjoF5h; arc=pass smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="BAst9qNJ";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="qAVjoF5h"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1770251679;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=NbH6xOmLFDqaGnI5+XI7irWa16RL5oAMq6cgsVy/eHw=;
	b=BAst9qNJDS0Cu1Og+rIkEZsQhuisukbMnLhXHKTAhXJNI1Sgba8fRl+fL/uIOpaowK6wUB
	+pn+YmVwxo3JSdiSuBDY4uqv93+MpUZebdfJ8Q95ruIgoM5sxL/FEba0wT84o+HMJJvydi
	QfnTzOpfGdXjWpglDLUJ4vHraNPx3fs=
Received: from mail-lf1-f70.google.com (mail-lf1-f70.google.com
 [209.85.167.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-201-phRgAnpsOzu-jM2mCqb9Hw-1; Wed, 04 Feb 2026 19:34:37 -0500
X-MC-Unique: phRgAnpsOzu-jM2mCqb9Hw-1
X-Mimecast-MFC-AGG-ID: phRgAnpsOzu-jM2mCqb9Hw_1770251676
Received: by mail-lf1-f70.google.com with SMTP id 2adb3069b0e04-59de4460e35so224096e87.3
        for <linux-raid@vger.kernel.org>; Wed, 04 Feb 2026 16:34:37 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1770251676; cv=none;
        d=google.com; s=arc-20240605;
        b=U1VWcQE59jDQtCMoaUkyN1wZWUas9K7XAJwuCCI4DINZm/SmhXYYBasqmrOhKR724P
         Tvf7irO9HzxmYa98XcFuW5Eln0s83LlgWEkF44GeGq8vU1AMuIPz791mtQT4x4tk97OL
         38TcG8rjoYjrADUmxAvCvPxSgqXSPWA0WaVC7dB+nVMhUKmuhxuT4LZobBLzLyApzes7
         5tLZjWwRJx/uIINozlt1YdMIxkGvOgXJpHMKiggbsknQXGxDbzwEgxFAvDpesS5/1KLk
         VHa2S4iToWTBHihuKymdKChv3jagns22uelfrkAyGj/BAyzMe0E/J57NKHt8tTwbV0np
         /MIA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=NbH6xOmLFDqaGnI5+XI7irWa16RL5oAMq6cgsVy/eHw=;
        fh=Zr0Gmz5K2XVnY7DhlR+Mkq3b//E82H/QrSYkAntOeE0=;
        b=P5anO32WOP6WbouKeTsBuBxMjyycX6A0V1BvWuq+VjjSiU3AMdtI3a/9elSx0vZJpl
         KsVeKCcpQL+yUnTpwh+1Cb96V4E89Ves9IqzsiyoZQeTGog5vgIsKY3/zIzEn2K1zZ6r
         WPNyPiOdFW4JKzDuD0ZfVUjyGToufp2qk/RMo5dK2fkCOk8aoN8tUwc2JlIyqrQ3pSkJ
         0zcr+BstIRPSv0eMGaG7vg6xk+qPjPOn0udrZK3vrjqkP5ZkeCmYZ4AxnD+/Pwp/XM/B
         fZJoryYfNL63f7ZZbTaj0LeJTQCmKhuoe6bg+bQOkbB/C8KeukF4HFVn5gOWtjVSONaI
         maDw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1770251676; x=1770856476; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NbH6xOmLFDqaGnI5+XI7irWa16RL5oAMq6cgsVy/eHw=;
        b=qAVjoF5hU9iZ+WVBkm0YiZDwjWqmeoAEdR9Yf9IGJDpejcpTihQnlDbgsk7CHmq7G9
         HsBmYYQsnX1tr+fiWDtHlIrUjF5G5AfBgx8dQ4mFhCpU24S1y+NN6y7UMCiFWhUf6T+k
         HL3PJeov2Ml/ok6b2Dn0t7KJdS2gxKqtmGGqrQod5wx4wWh7j8tvZyTVqoUniPqGt3A3
         2pBVnFeiV/59X1gGps4QDkb/e6O4oHmamCsfYscF5KkHOYl0BCei+9lHUOKRDzHvaOwc
         rmLpDsfiZXl5tTx+y7kFCp70ok+6g4rQUswIN35aUxHKF/wtv1jF6lSTU5JSTh+wPLwE
         sWbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770251676; x=1770856476;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=NbH6xOmLFDqaGnI5+XI7irWa16RL5oAMq6cgsVy/eHw=;
        b=sxi3mCSmF0thmZPJTuXXQD26OavC1o5cEngE2yCUyqzbygJ3h8aJS639b1LMcxS8UY
         JSMAWmOSeldrORxqLAZNI+khfe7nPcRYMgTzRvqfoizhYbJNtmCzmfafScdZ3dNyPxLW
         t2P+uIiBhuY/MN7IrhAHsBtkZt4Q/nHJ/6vZPQpxlEloMsettdhRsHdSSlnD3mHiV0nX
         Z0+N5DvVAPLMdoblVjdM4QOAHJvnCxVv/fF1UD+GnwBXALdnYHa7CxUbDJPkxZJzH7yW
         wl9CzGbO9R7xtUc3jeHIsqLqB0ImgK8eAdUOOwkXJaKKSMttfi2q5QG9rLP26HrNv8aw
         PZWQ==
X-Gm-Message-State: AOJu0YwM6q9RS9oDlsVzaII2tq/KnTVQcAhO3O3jc3HvPqGSUCNbLIHZ
	+3IN8IDH32lmk+iyfngOMe50IOLTTa3xY1YLUmCaoDS+R3Qb1Fr6m05GP+qpcx6bTcl7e5r55eV
	j0III+jyLsbKHfR21IeJekkH+RBTKW3qw52IhwOkRoBSWJ/eBcP/N6Ti0vvLf66WzFjn/FGw8p/
	3YEFlltwQT4hMrX2A965qS8k3FsS8BrMoKJUSvQA==
X-Gm-Gg: AZuq6aJibctvQNq7n+5Jq6GDXWG66L3ZpZom4qinYkdj8uDd0eMzyk9ARDXNdszFrhY
	O2x3HdRWGiwgSs7U2GEc2bdb5DZmhf2UuAePvJSFKtBKy1fX6sQ0MtFgGCc3KzFeORFxYkiZH1e
	pca+sS/od8Vdzavnd6y8cTo5h2ri+Rn+U2d2oC7vYqeMoIbe5N4zBFFIQ1MQCWL78VLg86vlqPo
	OJSZ+aJw8yRLDvZFzkZnvs3nW2ml0HqI7ArW03lkngGPquDpX6aPMzIPLRfShOTic8wPA==
X-Received: by 2002:a05:6512:124a:b0:59e:1719:4cc with SMTP id 2adb3069b0e04-59e38c0be09mr1788128e87.19.1770251676228;
        Wed, 04 Feb 2026 16:34:36 -0800 (PST)
X-Received: by 2002:a05:6512:124a:b0:59e:1719:4cc with SMTP id
 2adb3069b0e04-59e38c0be09mr1788121e87.19.1770251675788; Wed, 04 Feb 2026
 16:34:35 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260204145912.9463-1-xni@redhat.com> <a058e5a3-e96c-4feb-8f9d-e1135951973c@fnnas.com>
In-Reply-To: <a058e5a3-e96c-4feb-8f9d-e1135951973c@fnnas.com>
From: Xiao Ni <xni@redhat.com>
Date: Thu, 5 Feb 2026 08:34:24 +0800
X-Gm-Features: AZwV_QgYpwXTSa5YaqvmFCIL_Ffq9S29-VBh_6cQolXJwG4RJVzX3fcVQbcPXrc
Message-ID: <CALTww28vHeWNf7kejN_R_-K_nu4JJRig6ieQRBv63N1Xy7FXhw@mail.gmail.com>
Subject: Re: [PATCH RFC 0/3] md/raid1: data corruption with serialization
To: yukuai@fnnas.com
Cc: linux-raid@vger.kernel.org, Guoqing Jiang <guoqing.jiang@linux.dev>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Feb 4, 2026 at 11:58=E2=80=AFPM Yu Kuai <yukuai@fnnas.com> wrote:
>
> Hi,
>
> =E5=9C=A8 2026/2/4 22:58, Xiao Ni =E5=86=99=E9=81=93:
> > A data corruption can happen when using serialization for raid1.
> > Serialization is not enabled by default. But it looks like there
> > is a data corruption risk if serialization is closed. Because the
> > lower driver can't guarantee the sequence which io is written first.
> > So it's possible that different member disks will have different
> > data for nvme devices. This patch set doesn't open serialization
> > by default.
>
> An important idea is that if there are filesystem on top of raid1/10/5, t=
here
> is no need to consider overlap bio. The only case for serialization is Wr=
iteMostly,
> that bio can be returned to user while it's not done for slow disks. And =
that is
> the reason why serialization is for rdev.

I know the reason why it needs serialization for writemostly case. At
first, I asked the same question if we need to handle overlap if a
filesystem is on raid. I got the answer from AI, filesystem can submit
overlap bios simultaneously, maybe it's the reason why
serialize_policy was introduced? And database is another case which
can write to raid1 directly without a filesystem. So I started this
job. If we don't need to consider overlap, why do we need
serialize_policy? cc guoqing who is the author of serialize_policy
also.

>
> We definitely will not enable serialization by default, because there wil=
l
> be huge performance degradation. And I don't think we'll handle the case =
user

Yes, this is the reason why I don't enable it.

> manage data with raw disk, and write to the same area concurrently. At la=
st, if
> there are still problem with WriteMostly case, please rebase and keep ser=
ialization
> for rdev.

The data corruption is:

R1 issued (split into LO and HI)
(LO)                                                              (HI)
R1 write to high-speed disk begins              R1 write to high-speed
disk waits (waits while LO is being written due to an incorrect sector
range)
R1 write to low-speed disk begins
R1 write to high-speed disk completes
High-speed disk wakes up                           R1 write to
high-speed disk begins

R1 write to low-speed disk waits (waits while LO is being written due
to an incorrect sector range)

R1 write to high-speed disk completes
R1 completion notification

R2 issued (split into LO and HI)
R2 write to high-speed disk begins              R2 write to high-speed
disk waits (waits while LO is being written due to an incorrect sector
range)
R2 write to low-speed disk waits (due to R1 being written)
R2 write to high-speed disk completes
High-speed disk wakes up                           R2 write to
high-speed disk begins

R2 write to low-speed disk Wait (R1 is still waiting)

R2 write completed on high-speed disk
R2 completion notification

R1 write completed on slow disk
Slow disk wake-up
R2 write started on slow disk
R2 write completed on slow disk
Slow disk wake-up                                       R2 write
started on slow disk *R2 will be written before R1 here.

R2 write completed on slow disk

Slow disk wake-up

R1 write started on slow disk

Patch03 can fix this problem. But the root cause should be the
sequence getting lock after being woken up. So besides patch03, it is
necessary to ensure that the order of processing I/O matches the order
of adding I/O. If we don't need to consider upper layer can submit
overlap bios simultaneously, I'll fix this based on rdev rathar than
mddev.

Best Regards
Xiao

>
> >
> > Xiao Ni (3):
> >    md: add return value of mddev_create_serial_pool
> >    md/raid1: fix data corruption by moving serialization to mddev level
> >    md/raid1: fix incorrect sector range in serialization
> >
> >   drivers/md/md-bitmap.c |  28 +++++--
> >   drivers/md/md.c        | 171 ++++++++++++++--------------------------=
-
> >   drivers/md/md.h        |  30 ++++----
> >   drivers/md/raid1.c     |  47 ++++++-----
> >   4 files changed, 115 insertions(+), 161 deletions(-)
> >
> --
> Thansk,
> Kuai
>

