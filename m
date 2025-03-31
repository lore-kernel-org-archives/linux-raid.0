Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA3FA86347
	for <linux-raid@vger.kernel.org>; Mon, 31 Mar 2025 16:11:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743437482; cv=none; b=BB4+H6jlpkikdgxpEGGV5bvHVRXf3SmpBaZrbj4Ed84JRsAhvJsrMjLj1rmA8+HNkDaPJY4cctoFFz/DW6GWiv/EshJasGMrPmtOg/SbsrWb2TXLFuDOI0KGY95dTLGwf/zJymkz/AMbbmCzPjyvln8JybQcMy1ESLtrVpXSN9w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743437482; c=relaxed/simple;
	bh=NSlk2WF/9IKvUBdkaF2JJ3G5q/uJssqncsaHKPIHjTA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=cCI2aNxDrWaGLA7himHIw1YSSOCgS1JDUlS/cB03h6RiKQkn8S/sAWLf73bTfyAIJYxsIh14sj07cb4m0Rlq73N31ee908fEofNyAc3PEm1K1JtwVqSn2doFLADo3aCzn0+UPBowMJX+nQC7ZXggRikQsTpY5Q8Q2Cw1m6GX8lY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=EABeZ1s2; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="EABeZ1s2"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1743437479;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=fNurYPvIIZj23Vjr07VuqJV1DpdypzQoqHlMlnfn8rw=;
	b=EABeZ1s2kDGSB4YlWmk3CBZpL65pR439QbjjgZiLgzFyt1RVu7KrI/bm2XJOK4DOWxfJ+x
	DuPo2jfoE3wkPCHaXLMLtA3UTFQVh+7YCGZ7C24t8tdFcjli8Vd/0zqfqZdPjgLxT08iY8
	FVgc+yqTEG3M4VAlQhsTJEW8Uxr0CiI=
Received: from mail-lf1-f72.google.com (mail-lf1-f72.google.com
 [209.85.167.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-685-Uby_wFFUMSary20r8ogGJg-1; Mon, 31 Mar 2025 12:11:18 -0400
X-MC-Unique: Uby_wFFUMSary20r8ogGJg-1
X-Mimecast-MFC-AGG-ID: Uby_wFFUMSary20r8ogGJg_1743437477
Received: by mail-lf1-f72.google.com with SMTP id 2adb3069b0e04-549b3bf4664so1962059e87.1
        for <linux-raid@vger.kernel.org>; Mon, 31 Mar 2025 09:11:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743437476; x=1744042276;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fNurYPvIIZj23Vjr07VuqJV1DpdypzQoqHlMlnfn8rw=;
        b=ZS7IaXbayxEd2g+s7STDaMrQiWWWnZyQwAYJqu5YCAu4VSH6S9CgWTzdNR8hG4qHkr
         JMo18If/yk/SR0Ktpj90XOzJcjwQ5ZLYtmsRzVAsHIMLV/RY8/+6+zv0LhCzBKff40he
         sQMtKlTdWHSfj9deO1KCOT7WOx+1mj7C4SElTx8ZYh12dmdTvka4Mv5vXJyyUNKgONfj
         FKxJer6kb2v/Am6d1zpZv2o8IIYvXXdgHcw3GPhvAEh91OUsR9v6Rybmyfh1RV8kj6v3
         069DN1aUq1OwjtIs2UZP+/Gr6H+2oWOvm1cBoFN+DtqVMcLiNMQi1p0RdOCEmrVNmi2a
         ceqQ==
X-Gm-Message-State: AOJu0YxKpfhYLEFx5nkMRXsWbhI1Yfh60eTWmS7tdO4DtO2ZoBM3Yvl9
	wKutRkn4cM6kPS+bnjNRrHKU2F7T4FKO3I5VeOjj94rvf469FQfm+cykzmwk1r/+0Z6NOA9zRnB
	937ay/qTp5JYeNYbtKwnf+VqcbKr7SDC+t1TgnYsZr2VA+/QoyjhZvpW48HBZ2SZ1Bhuuv4W5oC
	6f7dbrtRZ828sADFMf1D4TGRYmMvSEQpwKPD8ZEhd9pQ==
X-Gm-Gg: ASbGncu9/Ct8au7EJXukF9ilftPaATFl7zkDjG5BM9wteNRVPkCEPQYsnEKTVqLodHX
	GRT4suFLC1ldd19WjMvMBl+p1quPALVh2cThv+Jl5/cQ5uLVicdFLbZo5nEC/B6jkFggkE/GWrg
	==
X-Received: by 2002:a05:6512:3090:b0:545:2ab1:3de with SMTP id 2adb3069b0e04-54b10dc7b75mr2310365e87.13.1743437475617;
        Mon, 31 Mar 2025 09:11:15 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IG90NPprd6/CYUHLpCYLNlYGu46FYNNohCduT1MRnMLxW1gQfvGfcksxE4jjJtd5JyZ22KE+MxHQO1/IVOqT9k=
X-Received: by 2002:a05:6512:3090:b0:545:2ab1:3de with SMTP id
 2adb3069b0e04-54b10dc7b75mr2310358e87.13.1743437475210; Mon, 31 Mar 2025
 09:11:15 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <5fc88c9b-83a7-414c-82da-7cccb1f876f3@dev-mail.net>
In-Reply-To: <5fc88c9b-83a7-414c-82da-7cccb1f876f3@dev-mail.net>
From: Xiao Ni <xni@redhat.com>
Date: Tue, 1 Apr 2025 00:11:02 +0800
X-Gm-Features: AQ5f1JoKJSsS7ZUArL5jSmzN7CnmObUA5xViUsJl3PbG-v2NJOCiHgylXYxYDK4
Message-ID: <CALTww2-=QABMBKatYQVJ+VSAVTXvvhn1jJFUqf8ZZZb3+nx0Mw@mail.gmail.com>
Subject: Re: extreme RAID10 rebuild times reported, but rebuild's progressing ?
To: pgnd@dev-mail.net
Cc: linux-raid@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Mar 30, 2025 at 11:56=E2=80=AFPM pgnd <pgnd@dev-mail.net> wrote:
>
> on
>
>         distro
>                 Name: Fedora Linux 41 (Forty One)
>                 Version: 41
>                 Codename:
>
>         mdadm -V
>                 mdadm - v4.3 - 2024-02-15
>
>         rpm -qa | grep mdadm
>                 mdadm-4.3-4.fc41.x86_64
>
> i have a relatively-new (~1 month) 4x4TB RAID10 array.
>
> after a reboot, one of the drives got kicked
>
>         dmesg
>                 ...
>                 [   15.513443] sd 15:0:7:0: [sdn] Attached SCSI disk
>                 [   15.784537] md: kicking non-fresh sdn1 from array!
>                 ...
>
>         cat proc mdstat
>                 md124 : active raid10 sdm1[1] sdl1[0] sdk1[4]
>                       7813770240 blocks super 1.2 512K chunks 2 near-copi=
es [4/3] [UU_U]
>                       bitmap: 1/59 pages [4KB], 65536KB chunk
>
> smartctl shows no issues; can't yet find a reason for the kick.
>
> re-adding the drive, rebuild starts.
>
> it's progressing with recovery; after ~ 30mins, I see
>
>         md124 : active raid10 sdm1[1] sdn1[2] sdl1[0] sdk1[4]
>               7813770240 blocks super 1.2 512K chunks 2 near-copies [4/3]=
 [UU_U]
>               [=3D=3D=3D=3D=3D=3D=3D=3D=3D>...........]  recovery =3D 49.=
2% (1924016576/3906885120) finish=3D3918230862.4min speed=3D0K/sec
>               bitmap: 1/59 pages [4KB], 65536KB chunk
>
> the values of
>
>         finish=3D3918230862.4min speed=3D0K/sec
>
> appear nonsensical.
>
> is this a bug in my mdadm config, progress reporting & or an actual probl=
em with _function_?
>
>

Hi

Are there some D state progress? And how about `ps auxf | grep md`? Is
there a filesystem on it? If so, can you still read/write data from
it?

Regards
Xiao

