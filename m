Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B36414E2E2
	for <linux-raid@vger.kernel.org>; Thu, 17 Jul 2025 14:32:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752762734; cv=none; b=X2AwrLspp88pOhq1cNBEOeUGVfVBlhWVIsFb3suHS/jEBNH1TBSkipjbhODwzHc2o9nQRsiRIntPweiR6MH949q0nu2+Ri8ewriwLCV9TIuCurwQ9qRlfYmS3wiMMPyqbzgPe15Cujxq2tuRxwQxFGZC4qpySe+v2ktfov7K3cc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752762734; c=relaxed/simple;
	bh=BpKvTGSzcGxYqR26tI4+GLZNjRei4vvrs43ux7EVVbU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=OONXhnpKi8EKBOln36F84bwuFUSdrjZUBxlNKSAENf4dLkJNk5XKFaimZgTuM7UlAXj+ZwpHUkwiQbzQnW4IelIV2OlE+ISDmsFCFj9e6ulW4aIXv2APxLfWYIhKshQR8L4hhSecAle9h0F5RXk+5whSe9RnFnEAmrLMyOryIfs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=bAF+9lkD; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="bAF+9lkD"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1752762731;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4FA0ONGYpZe5LNmkbnmUH+TqjZUs1MQRrjuF3bYicL8=;
	b=bAF+9lkD3wdJ4rc7U8AcEpTfGAZY9Yd3ypH0bO83JihEr8rusdl8TxbaBdb8VZo9GkxTsn
	E3Y9jKdT2KSUEsBEiN5HNXBb72O6af0T4ZFtwjN9ipm4hph0g50+vdTeTxAh8VjEV0aswJ
	nKnGMc1S8xrh3cR43egxknVm31gldtA=
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com
 [209.85.216.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-460-0_5Cj3mOOPCG8YstBbu1yQ-1; Thu, 17 Jul 2025 10:32:09 -0400
X-MC-Unique: 0_5Cj3mOOPCG8YstBbu1yQ-1
X-Mimecast-MFC-AGG-ID: 0_5Cj3mOOPCG8YstBbu1yQ_1752762729
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-313f8835f29so1512135a91.3
        for <linux-raid@vger.kernel.org>; Thu, 17 Jul 2025 07:32:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752762727; x=1753367527;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4FA0ONGYpZe5LNmkbnmUH+TqjZUs1MQRrjuF3bYicL8=;
        b=BS9K3M/F+vjoSbH/9rz0ffo/qBQQPRN64e432+w7RYbRBjNZ9b+Fy7nZ5LVXnIIxz6
         pEjpOkwfHi63qRuUvplnIoobPdjSp0jUmMHz4pphd9Sz6eojxDcpJS9ODjSp+oDN2leX
         JqM5VPl4W3JJmSN7JO6Om5WhEcDlvMVpEEx2c9Ts+78KSd3cj6oiPeBsmX7TSiek5YbD
         ddPuPSHbnIHLsn+JKJQD20sBBU+jENQYY2hTfb345G7+7GtigBiSGWIEidNUVDsPjFqN
         NmuhRQ0ssw4XkCoB80In9JIeVF5F8RTgxvFy2chInGOb03uFXUsHXabQOvsqH651zgez
         +YOQ==
X-Gm-Message-State: AOJu0YyQL4TOMXyFCZr6vFmN124lsS88TPAdVi24KWW4TTa4/RiYbXk7
	+rj2/A6e6lqiyGLRm/TD9HGXCYSsvx5lEi46iGqR7MWtcZYkl3g8jy170Ltdjzmujjk25bH2FwL
	Zzi61oGXtKpIhf2fOvECcVJCbG+U0dmlhGhy/AJK5hTRPmdZbR3uFFCVbLT/6JABPjaz2WS2Cj+
	z8VuWec/b+81VcB7QL0uA424N0Uxv8nnIP/fKOgMN7CGNAmA==
X-Gm-Gg: ASbGnct4U46V/V+3+3OgrKx62IucaDxoiX/Y74Qwo0cWNWYWAgvlpsbRAGCZKs25tjn
	h4asJlo49x3X7Qtj0Gg7h+0qWMtyHJvpPbMdaEWdNS5pxf1UIKVbTmuewaAewE1isrQSyrUahro
	VGT74i0+3lrpEf8pclnj4jng==
X-Received: by 2002:a17:90b:4d11:b0:311:f05b:869a with SMTP id 98e67ed59e1d1-31c9f3fbc53mr10281086a91.8.1752762726579;
        Thu, 17 Jul 2025 07:32:06 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFQUUCc3pM4Lu5no+Q5BLA2dXohC4lCNgxZo/MbUSKCn/toalxZgxeSFOGednPIk8W8hlu7LcflGG9xEg+XeU8=
X-Received: by 2002:a17:90b:4d11:b0:311:f05b:869a with SMTP id
 98e67ed59e1d1-31c9f3fbc53mr10281048a91.8.1752762726191; Thu, 17 Jul 2025
 07:32:06 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAHj4cs9wqRvxxTVMYxPcaCQoedeRNn6CHJ_K5GsqS6YKMHeXiA@mail.gmail.com>
 <CALTww2_+3zTsbSxr36iscO6q0iV4VYLRE-PNKZ_aCRS5TDCwBw@mail.gmail.com>
In-Reply-To: <CALTww2_+3zTsbSxr36iscO6q0iV4VYLRE-PNKZ_aCRS5TDCwBw@mail.gmail.com>
From: Yi Zhang <yi.zhang@redhat.com>
Date: Thu, 17 Jul 2025 22:31:51 +0800
X-Gm-Features: Ac12FXyMbln4vaRFu624g2b2ZajluZDKzvbBmLj9p1rqnqb5RfhE77c_AxsPVPA
Message-ID: <CAHj4cs-dvYWvMQ=ojvz6Chsy-tA7gogXnfVikixVyUzrG3jzVQ@mail.gmail.com>
Subject: Re: [bug report] blktests md/001 failed with "buffer overflow detected"
To: Xiao Ni <xni@redhat.com>
Cc: linux-raid@vger.kernel.org, 
	Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>, linux-block <linux-block@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 17, 2025 at 5:33=E2=80=AFPM Xiao Ni <xni@redhat.com> wrote:
>
> Hi Yi
>
> Is it possible to use the latest mdadm
> https://github.com/md-raid-utilities/mdadm for testing? This problem
> should already be fixed.

Yes, the issue cannot be reproduced now with the latest upstream
mdadm, thanks for the update.


>
> Best Regards
> Xiao
>
>
>
> On Thu, Jul 17, 2025 at 3:21=E2=80=AFPM Yi Zhang <yi.zhang@redhat.com> wr=
ote:
> >
> > Hi
> > I reproduced this failure on the latest linux-block/for-next, please
> > help check it and let me know if you need any infor/test, thanks.
> >
> > Environment:
> > mdadm-4.3-7.fc43.x86_64
> > linux-block/for-next: 522390782310 (HEAD -> for-next, origin/for-next)
> > Merge branch 'for-6.17/io_uring' into for-next
> >
> > Reproducer steps
> > # ./check md/001
> > md/001 (Raid with bitmap on tcp nvmet with opt-io-size over bitmap
> > size) [failed]
> >     runtime  3.511s  ...  5.924s
> >     --- tests/md/001.out 2025-07-15 06:27:41.496610277 -0400
> >     +++ /root/blktests/results/nodev/md/001.out.bad 2025-07-17
> > 03:10:50.718820367 -0400
> >     @@ -1,3 +1,9 @@
> >      Running md/001
> >     ++ mdadm --quiet --create /dev/md/blktests_md --level=3D1
> > --bitmap=3Dinternal --bitmap-chunk=3D1024K --assume-clean --run
> > --raid-devices=3D2 /dev/nvme0n1 missing
> >     +*** buffer overflow detected ***: terminated
> >     +tests/md/001: line 69:  1835 Aborted                 (core
> > dumped) mdadm --quiet --create /dev/md/blktests_md --level=3D1
> > --bitmap=3Dinternal --bitmap-chunk=3D1024K --assume-clean --run
> > --raid-devices=3D2 /dev/"${ns}" missing
> >     ++ mdadm --quiet --stop /dev/md/blktests_md
> >     +mdadm: error opening /dev/md/blktests_md: No such file or director=
y
> >     ++ set +x
> >     ...
> >     (Run 'diff -u tests/md/001.out
> > /root/blktests/results/nodev/md/001.out.bad' to see the entire diff)
> >
> > --
> > Best Regards,
> >   Yi Zhang
> >
> >
>


--=20
Best Regards,
  Yi Zhang

