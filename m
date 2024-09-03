Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E30A9A32
	for <linux-raid@vger.kernel.org>; Tue,  3 Sep 2024 00:33:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725323594; cv=none; b=hAe/u10O3k1KFXNdiG2lCZUJmr5BicOmW49FT+rIbJNEuSEXfH70ikAGBntOIpOz2G9rset9DMLjtE/EYj5eU63FJ6ou72KEvxIGqGCZjiLtTNmZdH8gHgtPF5vuW+H8sYNvDcIAoRo3tzYQxdFKs+gNgWUU2i4pA7SFulFHpRw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725323594; c=relaxed/simple;
	bh=8BZmYZ3gkeVKLQiMRD3pWOGEx9NJ7ierClKEeCH1LTU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=j9x3eFYAZtFW9Cej+S2hSd54cpMVyonMzzT7/Ue5qV6dIu5j41HCrxq/u/AWMWGRJPyQNQ8eS6Hg4krXSPkBjOIykIlqRLnT2JaWMgQyUmbSXnc4pQEI8JcurnF5Hmt+Z83A77KwDfVEEDCqLoAEfwOztHcjMk0rrAnudfb7KR8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=DPU3fXeI; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DPU3fXeI"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1725323591;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2o84GJvtGtYBNcYewa4GllIZ/XSy9Gcf41tlrFYtxhY=;
	b=DPU3fXeISAU4xjZCFRtZ6VuXu9oRm5dA7Iyn8aAZTYYixnVRNQmMd1a009NJBSWbVIKmPE
	uKszV4+ZtGJIzq66glzOwr4JceB/2+MXmAkjqh8n26eiq1mlqxegwlpcXobHhXeIC0faa0
	b1vOJi5kX4a+O/VXFxuqoNOg2lKyp8I=
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com
 [209.85.216.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-196-sXSUFHIhM2acuaERTTL8bg-1; Mon, 02 Sep 2024 20:33:10 -0400
X-MC-Unique: sXSUFHIhM2acuaERTTL8bg-1
Received: by mail-pj1-f71.google.com with SMTP id 98e67ed59e1d1-2da511a99e1so667516a91.2
        for <linux-raid@vger.kernel.org>; Mon, 02 Sep 2024 17:33:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725323589; x=1725928389;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2o84GJvtGtYBNcYewa4GllIZ/XSy9Gcf41tlrFYtxhY=;
        b=UUyOx/mBvpTenwAEMPLVmld89L1MTaTiOtI29ePXbfSuS5sepx9l8JvK8c60Z/k/DY
         bBw8pQqEjhSs1Y540cbLMrOwz4bgPy5K/YtzxrZI+Cp+wpQmKgc/rPjEhQnV+LNZ2boC
         Os0yySfcZrJK1aZDKUGVYk2KAGddJ9uIATDc7isBneVEs2mvVC1hO06MHSfU2JWQxjFw
         2XTgDn2SG1M/bBeLnYoz3QyZ9hOG4HX41t1wGGKh+SzNow5lRGCUto5SbFbgpdDArmpb
         VQBciv5TDvy4sB5rJqvFZnMcbVJFWmYFzuzsBHCiPHw1Jgl9+kZIM9X8xl4EJAgY5x8r
         D5Eg==
X-Forwarded-Encrypted: i=1; AJvYcCXc1o8zqZ9ofemOtO8S0sAdMrHIF6mrMFeov9jfV7PFjnnC6ULARxS//Pq25VxElPXc6LSaqIsUbd6a@vger.kernel.org
X-Gm-Message-State: AOJu0YxHWn/yHkuku8II3i5U88rRgNbvUouJls4QCJkSoCB96yLEHCDe
	xwPsp6SjuOAr1OwBpuhB+0J13HFW4O/fG9EIBHJs6WWyyx8GliS+ALwdT3ZMCTjx6iyCvP0MIMr
	EN0/yekW3WZLAhOjNDekhFmEU8mAJKm8LrZK5XlL+epacdzaSFyxIfsvre43iKbZmQYf+Phlnor
	Iah+hJrwe2FQKh+B/1iXD2KMzpamhXw7KgxQ==
X-Received: by 2002:a17:90b:3e83:b0:2d3:bd5c:4ac8 with SMTP id 98e67ed59e1d1-2d856383ff8mr17741324a91.27.1725323589322;
        Mon, 02 Sep 2024 17:33:09 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEpFA33yAG2jH2WrLzmPOQF0ZqKzxixzJ/pXS5bXtq1CwymJFTdViBKl6mGU+q4999I+nRATj5wmIscwPkeWQc=
X-Received: by 2002:a17:90b:3e83:b0:2d3:bd5c:4ac8 with SMTP id
 98e67ed59e1d1-2d856383ff8mr17741304a91.27.1725323588792; Mon, 02 Sep 2024
 17:33:08 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240828021150.63240-1-xni@redhat.com> <20240828021150.63240-2-xni@redhat.com>
 <20240902115013.00006343@linux.intel.com>
In-Reply-To: <20240902115013.00006343@linux.intel.com>
From: Xiao Ni <xni@redhat.com>
Date: Tue, 3 Sep 2024 08:32:57 +0800
Message-ID: <CALTww282fzATvOE2zY56vr_4X4Hxt3PWr87nDZqNsQBTWsHNTw@mail.gmail.com>
Subject: Re: [PATCH 01/10] mdadm/Grow: Update new level when starting reshape
To: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
Cc: ncroxon@redhat.com, linux-raid@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 2, 2024 at 5:50=E2=80=AFPM Mariusz Tkaczyk
<mariusz.tkaczyk@linux.intel.com> wrote:
>
> Hi Xiao,
> Thanks for patches.
>
> On Wed, 28 Aug 2024 10:11:41 +0800
> Xiao Ni <xni@redhat.com> wrote:
>
> > Reshape needs to specify a backup file when it can't update data offset
> > of member disks. For this situation, first, it starts reshape and then
> > it kicks off mdadm-grow-continue service which does backup job and
> > monitors the reshape process. The service is a new process, so it needs
> > to read superblock from member disks to get information.
>
Hi Mariusz

> Looks like kernel is fine with reset the same level so I don't see a risk=
 in
> this change for other scenarios but please mention that.

impose_level can't be called if the new level is the same as the old
level. It already checks it before calling impose_level.

>
> >
> > But in the first step, it doesn't update new level in superblock. So
> > it can't change level after reshape finishes, because the new level is
> > not right. So records the new level in the first step.
>
> >
> > Signed-off-by: Xiao Ni <xni@redhat.com>
> > ---
> >  Grow.c | 3 +++
> >  1 file changed, 3 insertions(+)
> >
> > diff --git a/Grow.c b/Grow.c
> > index 5810b128aa99..97e48d86a33f 100644
> > --- a/Grow.c
> > +++ b/Grow.c
> > @@ -2946,6 +2946,9 @@ static int impose_reshape(struct mdinfo *sra,
> >               if (!err && sysfs_set_num(sra, NULL, "layout",
> >                                         reshape->after.layout) < 0)
> >                       err =3D errno;
> > +             if (!err && sysfs_set_num(sra, NULL, "new_level",
> > +                                     info->new_level) < 0)
> > +                     err =3D errno;
>
> Please add empty line before and after and please merge if statement to o=
ne
> line (we support up to 100).

Ok
>
>
> >               if (!err && subarray_set_num(container, sra, "raid_disks"=
,
> >                                            reshape->after.data_disks +
> >                                            reshape->parity) < 0)
>
>
> Thanks,
> Mariusz
>

