Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CB7718A6DF
	for <linux-raid@vger.kernel.org>; Wed, 25 Sep 2024 12:57:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727269064; cv=none; b=b7lWTuAc2tnl1a8sSTBuspQz0oFe+VU0541gjqa99vfHq/3QbGrmnzSc0fVKaVKXQhNt3/LmAqp22ftcoj+VgdxO0XwiB3DiX5SQu1Vo/7p/kU9i73UpKp4W0J0ARl8FQGroT7ZcwiGT7tc7KSnXhpTP52RHYywNYjn/JmvJmj0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727269064; c=relaxed/simple;
	bh=TtoIzFqpb1pvR9CMYd1wvmAtN3aah0rYzipW/lu1JxY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=lOM6bgHNiPbPeh36BoFTnsC1UpMq0N810KVC8UWErsTPCS/17HvfrBxYHtSf83eL87mLfxkXrIhML9YMJD82H9mBzJxU+EJzo5m2k2WIJjnZS+Ssreqq8iwLt38BU8+sXHWRUi7l9PfxDvfUKHj27QbJ8958UP79aysLug+f7KE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=dHGYbOoq; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="dHGYbOoq"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1727269062;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=u0ZdYTHzty+9mIg10Dj6Fy7kAuqy/kTlkiMpZn3TdB8=;
	b=dHGYbOoquNDoPJekhkinxiuVzpJGRQesrY792/KY42M6AHBv+1yb5zzaRhNmv6aEQ4GcVm
	jy+TCjNIebHovlvbSFr3i0HhAfqX0NLrzw2SyMXbdz1SujviMdXOcOi33VMHbM12426HJa
	hGkTuCkMJ5ESJ675+poQSPFP0jAU1Jk=
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com
 [209.85.216.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-130-bUo07Hq8NImVb9IU9ZV90w-1; Wed, 25 Sep 2024 08:57:41 -0400
X-MC-Unique: bUo07Hq8NImVb9IU9ZV90w-1
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-2e080b3097bso341047a91.3
        for <linux-raid@vger.kernel.org>; Wed, 25 Sep 2024 05:57:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727269059; x=1727873859;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=u0ZdYTHzty+9mIg10Dj6Fy7kAuqy/kTlkiMpZn3TdB8=;
        b=bA45Hg0EcgyrO29OLCVKqn4jg1d65XngnW/R05ZWUz0vcahX0+IJjqsbN/eXILHVqW
         BVWQumxMAkP8OnXCCn3gJ7r4+fDmglP6dSrQdGTHFNrJZf74gCb1ZjGjBEnjeBHEzMk4
         o30OvmSOuTIOlH5jO3IrPQI7TRZlIlv3sCc37dDZYv9CnEGqDRtCmtrK9AnmZmVWUHOb
         8xkkMNV7LRSrQ70IgmksyQkTLcbwF1w3ww9uhOOzZdh6u36fOmPMVHdcGmvR4+6klS7Z
         yRBA0oIdvmB5xjwGxND3OCH9dkKviq8wQ/Vpdj2qrN9TDaZpBwuc8kZKfA+PXs3QRyR4
         D14g==
X-Gm-Message-State: AOJu0Yx70N+BxcsZIgREOLly+uC8OqV9TXj8LOLjv35IgemvoFXidfw2
	jGghJ6GjlXJ9cn3/AEU3oJ0CvLc2A2V8wbgULzt+Lmdpiom1MMWL68HnLJJLVWViDJSGWOd5jyM
	O1hEpEvw0Q1Wq8VsmclPEDvSyWxx+p99LTBj59E2L7iI925m/eTTcadfXQd3FK7zojXVM1kcYX6
	h8cMOUnEDW9/Iej8sh9ZXKwxkSWrjLEIb2zw==
X-Received: by 2002:a17:90b:1e09:b0:2c8:65cf:e820 with SMTP id 98e67ed59e1d1-2e06ae2794dmr3087835a91.2.1727269059030;
        Wed, 25 Sep 2024 05:57:39 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IG9BMVRijcb1BFfcInJYeiysxG8GI+FMpWpRx7KFfXi8WvKBsTd4/F4ErnTTWSTw5VPWX61+WtazMIOmjFiMzM=
X-Received: by 2002:a17:90b:1e09:b0:2c8:65cf:e820 with SMTP id
 98e67ed59e1d1-2e06ae2794dmr3087824a91.2.1727269058769; Wed, 25 Sep 2024
 05:57:38 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240911085432.37828-1-xni@redhat.com> <20240911085432.37828-2-xni@redhat.com>
 <20240925095139.0000066e@linux.intel.com>
In-Reply-To: <20240925095139.0000066e@linux.intel.com>
From: Xiao Ni <xni@redhat.com>
Date: Wed, 25 Sep 2024 20:57:27 +0800
Message-ID: <CALTww2-b0yyWWJ-ObN8CN2hUiZ1fqzCV_Cbgas+1WchXP+1qdA@mail.gmail.com>
Subject: Re: [PATCH V2 1/1] mdadm/Grow: Update new level when starting reshape
To: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
Cc: linux-raid@vger.kernel.org, ncroxon@redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 25, 2024 at 3:51=E2=80=AFPM Mariusz Tkaczyk
<mariusz.tkaczyk@linux.intel.com> wrote:
>
> On Wed, 11 Sep 2024 16:54:23 +0800
> Xiao Ni <xni@redhat.com> wrote:
>
> > +
> > +             /* new_level is introduced in kernel 6.12 */
> > +             if (!err && get_linux_version() >=3D 6012000 &&
> > +                             sysfs_set_num(sra, NULL, "new_level",
> > info->new_level) < 0)
> > +                     err =3D errno;
>
> Hi Xiao,
> I realized that we would do this better by checking existence of new_leve=
l
> sysfs file. This way, our solution is limited to kernel > 6.12 so, for ex=
ample
> redhat 9 with kernel 5.14 will never pass the condition. I know that you =
fixed
> test issue but someone still may find this in real life.
>
> I'm not going to rework it myself, I'm fine with current approach until
> someone will report issue about that for older kernel.
>
> If you are going to rework this, please left a comment about kernel versi=
on
> that it was added, to let future maintainers know when the additional
> verification can be removed.


Hi Mariusz

Thanks for pointing this out. You're right. I'll fix it.

Regards
Xiao
>
> Thanks,
> Mariusz
>

