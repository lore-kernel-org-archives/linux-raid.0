Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCB9934029C
	for <linux-raid@vger.kernel.org>; Thu,  6 Nov 2025 14:57:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762441039; cv=none; b=sYgYv/8qsTYrsYL+eNFcVoawDNnGR0AmtVymZtghD1CsGMAq3O9Vp5SQy7ZUrvmUzZSXbqPExY2gVbriqha7BHb+7GK5meF1w1l7YugqEzSSoJOVbRhcqdjI5jqpl+oYrwV8hkR0IKdTndBpz+t1NWvlT0DIelAT4IVPyduU9Fs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762441039; c=relaxed/simple;
	bh=RRJi4BWOSt/oUeeiLS+eVgUBIjfhPebchxQneC5M2X4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ANdJN2IJVo3ZgtX9+1iaxueVGJC9v+dmjQRVTpkUh8ViL2wBLH8wkXhOO8G1Kb7Yc6tmiU0WTTW4D63jC0Yx/6kyJIe9impIUUB2dWjzmcKJVT9xVCyT7uOUP7Rpj+fn38SwSAIvLoCBCV3qrJxUurCIdxxElaL4rcMLOd0qBUc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=IXe5+eov; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=ASHsC/KP; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="IXe5+eov";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="ASHsC/KP"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1762441034;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=RRJi4BWOSt/oUeeiLS+eVgUBIjfhPebchxQneC5M2X4=;
	b=IXe5+eov4FZQ1IAyIIaD9lg06UUKYIW990dI6p6uMbiQS0gVyPACE6quat1m5ACoivVs1Q
	VQS6Ae+vb5eur7dtdSI7/jxP2rdJcofWC0V0k3hfuRPwCloHT3ssMUCcsyvXaCCW77H1hr
	kkFbciyp6Xp13FHb+Ty6pwp+ttbearI=
Received: from mail-lf1-f69.google.com (mail-lf1-f69.google.com
 [209.85.167.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-62-dbNrHkU3PF2s3DuaNmjWDg-1; Thu, 06 Nov 2025 09:57:13 -0500
X-MC-Unique: dbNrHkU3PF2s3DuaNmjWDg-1
X-Mimecast-MFC-AGG-ID: dbNrHkU3PF2s3DuaNmjWDg_1762441032
Received: by mail-lf1-f69.google.com with SMTP id 2adb3069b0e04-5943838a6d1so547321e87.1
        for <linux-raid@vger.kernel.org>; Thu, 06 Nov 2025 06:57:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1762441032; x=1763045832; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RRJi4BWOSt/oUeeiLS+eVgUBIjfhPebchxQneC5M2X4=;
        b=ASHsC/KPDgfhTXiT0CoVt2G35pSbi1UUL5NaazZqXroPhozIUmumF/2ZRjbP7kESUT
         MzMUcl9oAe8FKn/yLOPG2lMpNDWai/2rhLeh0H3y6qPveSLxenfcZ1Qa8zx8jGaDGSqJ
         LQZT4LhC9is3+6zdmB0rA6qjMW6XIEmGQHV8e5GCO8NZbvhr8KSfxG23K6IBqsiPSlI4
         qVGubdl0+uc8Oh/2+KC2uWmHWQV53+dFsucNu8SbZcEwXOUDK4Cr84krlU735Le02JBm
         +L3oCKCdvDTl1DaUAMUKAT7Z3jOW+fhk1SMX3/KlZphc7/D/8KMpGNycsH6Wb7Td7l3j
         KqYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762441032; x=1763045832;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=RRJi4BWOSt/oUeeiLS+eVgUBIjfhPebchxQneC5M2X4=;
        b=Vz5ctB+OXTdhS0W/s2i7Otewzbe6LH2DMqUZMqYi1bERXv0B/rQB43ComqWXlkkOJA
         6qE3ddVB4GeJ14P0/ik1l+ycg4+53U//5EIi7g+hEH8cfDzYa1R+zUlGbWo2oS+flo5A
         WRl7MuVw9JCuAdWaELOHTmcNj9d1TWNT1fEEqsH2JGPfiCySjoPExTIVexZVCbFCF5fy
         4lGDzIqnjU01MzBojVxJKtXKM2hyJ0smKnHYb5/lrotOEbwmM4HU6n8PHlMYMzJWW2kb
         X/xvBVyRuSz43KDVZY7PzVPSU9AsAorRi0LfZpJ9JirpaPqV1fkoKEgGpW8QYpoh0T14
         /02Q==
X-Forwarded-Encrypted: i=1; AJvYcCXvg1ajzHXEG2Oa8NiH6NseJt0AjDxiADxUkyEWGAsGRysMUm/rV/d4viXksrjJU7CCke6a5miZQwuS@vger.kernel.org
X-Gm-Message-State: AOJu0YxVloLgTW4rHUKvQR4LKrucTB6Il+Hcz/YA24oXG03jDwKkZ4XN
	JT0ebPLG6oj3Po0DpC/gnuMUPtO2l5TbzjSHMrvBxna0U6BJpWUHYHgWRazYEIpmU2ixfbeRQVJ
	wF0Hr9pzqR7zWAA67xV4KTeQJHSHkOzdIFJbYy+APbR1Vit1fNBBwUCQIWADxw3ZTv0FxCauPKN
	Un1A8xaqW0/2HewfJxD59jsDnIivA36IzdFBv0Aw==
X-Gm-Gg: ASbGnctbLukkQAxYB5uc7EL0z6nBgiVEkyWwP7KGRO7am6Mlh2/vgiz9Ecb1k1pFWuw
	/OZ8rOAwc/kOxBXncpXDuhmZjtULQsUbych6iyzYNY6mlBS0pwpK5o67C7EQ4pI7oJtIFVmjX4t
	ut1CrYgjDKltL/ylk200wADt+Utm3elEbbSi/bO8mo4ZjGqFfUXVZrPdk=
X-Received: by 2002:a05:6512:124b:b0:57b:8675:e358 with SMTP id 2adb3069b0e04-5943d7c044cmr2516344e87.21.1762441031656;
        Thu, 06 Nov 2025 06:57:11 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFtNGrDwt4RbOyF6y8CtvYQa56ZITXl4wPjOUbeGGR+zBng+d1yiIB83ABcja7XIQgf5a8pDswEdEPmhr2Khi0=
X-Received: by 2002:a05:6512:124b:b0:57b:8675:e358 with SMTP id
 2adb3069b0e04-5943d7c044cmr2516334e87.21.1762441031201; Thu, 06 Nov 2025
 06:57:11 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251103125757.1405796-1-linan666@huaweicloud.com>
 <20251103125757.1405796-5-linan666@huaweicloud.com> <CALTww29-7U=o=RzS=pfo-zqLYY_O2o+PXw-8PLXqFRf=wdthvQ@mail.gmail.com>
 <a660478f-b146-05ec-a3f4-f86457b096d0@huaweicloud.com> <CALTww29v7kKgDyWqUZnteNqHDEH9_KBRY+HtSMJoquMv0sTwkg@mail.gmail.com>
 <2c1ab8fc-99ac-44fd-892c-2eeedb9581f4@fnnas.com> <CALTww289ZzZP5TmD5qezaYZV0Mnb90abqMqR=OnAzRz3NkmhQQ@mail.gmail.com>
 <5396ce6f-ba67-4f5e-86dc-3c9aebb6dc20@fnnas.com> <CALTww2_MHcXCOjeOPha0+LHNiu8O_9P4jVYP=K5-ea951omfMw@mail.gmail.com>
 <c3124729-4b78-4c45-9b13-b74d59881dba@fnnas.com>
In-Reply-To: <c3124729-4b78-4c45-9b13-b74d59881dba@fnnas.com>
From: Xiao Ni <xni@redhat.com>
Date: Thu, 6 Nov 2025 22:56:59 +0800
X-Gm-Features: AWmQ_bnBMF115EOOjA9vbLZ9uN5wB3kN3ss1NrGOT0tRZSVZHKdKZOidba_fN6I
Message-ID: <CALTww29X5KizukDHpNcdeHS8oQ-vejwqTYrV5RFnOesZbFhYBQ@mail.gmail.com>
Subject: Re: [PATCH v9 4/5] md: add check_new_feature module parameter
To: yukuai@fnnas.com
Cc: Li Nan <linan666@huaweicloud.com>, corbet@lwn.net, song@kernel.org, hare@suse.de, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-raid@vger.kernel.org, yangerkun@huawei.com, yi.zhang@huawei.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 6, 2025 at 9:31=E2=80=AFPM Yu Kuai <yukuai@fnnas.com> wrote:
>
> Hi,
>
> =E5=9C=A8 2025/11/6 21:15, Xiao Ni =E5=86=99=E9=81=93:
> > In patch05, the commit says this:
> >
> > Future mdadm should support setting LBS via metadata field during RAID
> > creation and the new sysfs. Though the kernel allows runtime LBS change=
s,
> > users should avoid modifying it after creating partitions or filesystem=
s
> > to prevent compatibility issues.
> >
> > So it only can specify logical block size when creating an array. In
> > the case you mentioned above, in step3, the array will be assembled in
> > new kernel and the sb->pad3 will not be set, right?
>
> No, lbs will be set to the value array actually use in metadata, otherwis=
e
> data loss problem will not be fixed for the array with different lbs from
> underlying disks, this is what we want to fix in the first place.

But the case you mentioned is to assemble an existing array in a new
kernel. The existing array in the old kernel doesn't set lbs. So the
sb->pad3 will be zero when assembling it in the new kernel.

And as planned, we will not support --lbs (for example) for the `mdadm
--assemble` command.

The original problem should be fixed by specifying lbs when creating
an array (https://www.spinics.net/lists/raid/msg80870.html). Maybe we
should avoid updating lbs when adding a new disk=EF=BC=9F

Regards
Xiao
>
> Thanks,
> Kuai
>

