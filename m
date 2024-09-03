Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6A00A32
	for <linux-raid@vger.kernel.org>; Tue,  3 Sep 2024 00:35:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725323706; cv=none; b=PpjOLzcv4PHWbjQkmyFfhfJL5c3BWA2xwr8kVtiPYXEjDUvQ3oTKguDYmVcdhM6VmeybSNbpbAspODOffR68SN9tvy9sjpzVwB4NQRpZjmmKWbUFjbL45BzMZyhUCiX/Wn+GCL+DF6aK6Wk360i3fxKmJ306wk0Bd3bFONR1JGA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725323706; c=relaxed/simple;
	bh=M7w2cZJWe3Jkc3bb9iRfnjDkm6OsJyjycno5jHye1Uw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=UMKX2XI/tiHRB3ZJDbWg4YMOYzWlive+0O0D2PCUiFHPdzV/6su+zK8V1f6XreEvfe53CVrq7EHnMs77ECrWgZ7T1H6s79JrdpkWJcl5x0hGb1bgdbgOA5VlqWOMqyOc+LYYZIvHSVlFbxLTbFejEhjfwhbeklnmWmRIEjO0re8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=RNIxT9kG; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="RNIxT9kG"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1725323702;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=oduE++E10cXgUEPCYKRFeLD59R7L0bXiemmnKl9R80A=;
	b=RNIxT9kG11Y8pRvbTzc/4FbnMgO9ToFJ+16MswiH0T+GjLNrBJ/TzkIAlBc1cGwWA9H6xB
	rVLt47Cb0ESIA78wNQiD6/cg4xV1RljTlknu4nhcoNkGbMzzycVMwp5wAdvf4oAfUFmlQ/
	cl2wXqj8kRFQgDPL473wzZvL381CWTo=
Received: from mail-pf1-f199.google.com (mail-pf1-f199.google.com
 [209.85.210.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-582-1KTuEIqINWSyi8QFjUFUwQ-1; Mon, 02 Sep 2024 20:35:00 -0400
X-MC-Unique: 1KTuEIqINWSyi8QFjUFUwQ-1
Received: by mail-pf1-f199.google.com with SMTP id d2e1a72fcca58-7143d76d29fso4312469b3a.3
        for <linux-raid@vger.kernel.org>; Mon, 02 Sep 2024 17:35:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725323700; x=1725928500;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=oduE++E10cXgUEPCYKRFeLD59R7L0bXiemmnKl9R80A=;
        b=nC1vEI4zMzu/VyWuiS22rZ/lCgRXcLMNGpvd/iHEQgtW0jWo4+0EHv6a+wWii1v4si
         vw5OCKCCqVWTP6FCnVFNTKtC6Ca9TIXhX43Rol60T9YUEFvxqVX+F4Ds2fLLQrS+sQiT
         4inrqz+EygNI0/Qba0LZ5X1X8LJHsP8F6+tBS6Rh0gd1HHTYhVUBZdlsevyyv+Ai09W9
         eyOaavD3gTEh2Ypyszc8xsTLOJvE9Hp6hsALu49ek6OECF1Ctw5LDjG9UJ7Rf1Fl5yxX
         RskDqsoRMqr84+nVdYDBepf/0XF8JlU5rM7zlzT9AfpH43F/Uob9/cAxcIyjyhlYBDAG
         YIQw==
X-Forwarded-Encrypted: i=1; AJvYcCXmN96Ac3LGUB34AtXNHvVnqcj/L28FwUOo+vfKwmgD8DPHBul45BhwRp5YAQ824kPwBOdrDATWb5qH@vger.kernel.org
X-Gm-Message-State: AOJu0YxZGA1FjsOwtqZSzSGCOCcig8xD2eflXdKo5JJ5D5F7TGyOgGD5
	JOpF7WGWpoRVOFuboBafidMTD2kbLajYufSJw4d08tUWAriYUUNvE+ddWovsb3+p6777w/95zv6
	Rm5elfEs7VRPY6v2qFuadj+wVExrfxnaPbvST23tGT3JN5kSo2n5xCWGJhGREj6QDkyp24MEY/u
	+Rq5olYdzvKcSGGbGNECuD9CWbLzQgvCiKMw==
X-Received: by 2002:a05:6a21:2d0a:b0:1c4:c337:e24e with SMTP id adf61e73a8af0-1cce100b922mr13713771637.17.1725323699707;
        Mon, 02 Sep 2024 17:34:59 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IE89uUImHYA1re6CyJUtKCjPDHy9Fn0ULgsZ+CxHcv5/tvLjJc7y36GHpAsVeCH7jumX/d/nadHaGq5MeZl0VU=
X-Received: by 2002:a05:6a21:2d0a:b0:1c4:c337:e24e with SMTP id
 adf61e73a8af0-1cce100b922mr13713755637.17.1725323699140; Mon, 02 Sep 2024
 17:34:59 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240828021150.63240-1-xni@redhat.com> <20240828021150.63240-2-xni@redhat.com>
 <20240902115013.00006343@linux.intel.com> <20240902121037.000066e9@linux.intel.com>
In-Reply-To: <20240902121037.000066e9@linux.intel.com>
From: Xiao Ni <xni@redhat.com>
Date: Tue, 3 Sep 2024 08:34:46 +0800
Message-ID: <CALTww28fYqzAdmNdx9CmXWL4ozma2f1vx8oPYuDi2Ycds=S7zg@mail.gmail.com>
Subject: Re: [PATCH 01/10] mdadm/Grow: Update new level when starting reshape
To: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
Cc: ncroxon@redhat.com, linux-raid@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 2, 2024 at 6:10=E2=80=AFPM Mariusz Tkaczyk
<mariusz.tkaczyk@linux.intel.com> wrote:
>
> On Mon, 2 Sep 2024 11:50:13 +0200
> Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com> wrote:
>
> > Hi Xiao,
> > Thanks for patches.
> >
> > On Wed, 28 Aug 2024 10:11:41 +0800
> > Xiao Ni <xni@redhat.com> wrote:
> >
> > > Reshape needs to specify a backup file when it can't update data offs=
et
> > > of member disks. For this situation, first, it starts reshape and the=
n
> > > it kicks off mdadm-grow-continue service which does backup job and
> > > monitors the reshape process. The service is a new process, so it nee=
ds
> > > to read superblock from member disks to get information.
> >
> > Looks like kernel is fine with reset the same level so I don't see a ri=
sk in
> > this change for other scenarios but please mention that.
> >
>
> Sorry, I didn't notice that it is new field. We should not update it if i=
t
> doesn't exist. Perhaps, we should print message that kernel patch is need=
ed?

We can merge this patch set after the kernel patch is merged. Because
this change depends on the kernel change. If the kernel patch is
rejected, we need to find another way to fix this problem.

Regards
Xiao
>
> > >
> > > But in the first step, it doesn't update new level in superblock. So
> > > it can't change level after reshape finishes, because the new level i=
s
> > > not right. So records the new level in the first step.
> >
> > >
> > > Signed-off-by: Xiao Ni <xni@redhat.com>
> > > ---
> > >  Grow.c | 3 +++
> > >  1 file changed, 3 insertions(+)
> > >
> > > diff --git a/Grow.c b/Grow.c
> > > index 5810b128aa99..97e48d86a33f 100644
> > > --- a/Grow.c
> > > +++ b/Grow.c
> > > @@ -2946,6 +2946,9 @@ static int impose_reshape(struct mdinfo *sra,
> > >             if (!err && sysfs_set_num(sra, NULL, "layout",
> > >                                       reshape->after.layout) < 0)
> > >                     err =3D errno;
> > > +           if (!err && sysfs_set_num(sra, NULL, "new_level",
> > > +                                   info->new_level) < 0)
> > > +                   err =3D errno;
> >
> > Please add empty line before and after and please merge if statement to=
 one
> > line (we support up to 100).
> >
> >
> > >             if (!err && subarray_set_num(container, sra, "raid_disks"=
,
> > >                                          reshape->after.data_disks +
> > >                                          reshape->parity) < 0)
> >
> >
> > Thanks,
> > Mariusz
> >
>

