Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com [209.85.218.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C27F33F44CD
	for <linux-raid@vger.kernel.org>; Fri,  7 Aug 2026 08:55:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.218.49
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786092927; cv=pass; b=PBVXyxW+nwG+FCdfDWIaSftBKgMytJTlCEHsCFVkLPKo/ua7RxTXdzMmWbkFvmBjHYZb+Gl7WzFkRcv2DzGD8xhLiU5QdN4aDv4Vmq3QyjI0q7OxaLYtWI53aUqWF0h2ep5/x4BAWCktegJRKRFbYPhXUhGVOv97d23RaW5JuxI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786092927; c=relaxed/simple;
	bh=JG1m7gZUP+Mi6LNZnayXplxCZt4V17/q3rUGL+QqqCI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=pQJfshFiCaUw9vyjlUzcwKZrf4JK6MY0kILeQquTPaYWdgeMTjPA9O/hPxIlVnJW8xWY+G6/zqSpfw/esdjQ8T1bN+ln598h4OARoa66QirZuqaM4BDdetBpHuToPnBzYBv28/EWN2eagD5M7WK6oMbTIMlaTD2uP4PGMZhERDc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ZtRd0hg6; arc=pass smtp.client-ip=209.85.218.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZtRd0hg6"
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-c1c4c7ddaf6so495540766b.3
        for <linux-raid@vger.kernel.org>; Fri, 07 Aug 2026 01:55:25 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1786092924; cv=none;
        d=google.com; s=arc-20260327;
        b=eJ9hmdYGRrDbcwFSfmD67TyoGeokMRWRffkr05DhmgUlHrLoAvoKKTc+OzD3nB+WFO
         nrdjof3FJak6PlQZIEHZdmSJ8A4Vr61Hs4U7YWSo8x+efJyYZEYpXktxuIn+VbalnzVk
         u92UHsn7rY83yMMP7vtJdMZ3joEhdMVwvVcIT9/t7ei95aVIDRkOu3dHi1hXBmTNIp0t
         FKvJUe9/QoHd6P6reeqWnwUKks+C9yff39Im0JgdMAsloNTrXVAPyaaLBzzUqn35/fIM
         psS/rtBthCivYOZIPK+KMpjnqZeLPSoRH2YzmqgWdSs0LDsPw0UF8uPQZuU2OLBo+H4O
         Zr6g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=BPAgHBWPlEhA1Yqf7+9Wm2Catab7SOXiHm4SvlTtyuA=;
        fh=VBdy3hdc5ZVl763eAMS0N49p3X4c733EDjs8zEko4FE=;
        b=ibMgEDE0lKLwciiRntwsQJYVHmxzMvT0kXoFjDpAzMMSk2clfjA1p+CnD0sxfjN9Tx
         nynzhPRR50GtyYCmUfvHUCZL+RHtVNX2TLXTeziSbTRTWW3Jgju2apO2yxS84oqQqPsK
         UcuaW+0QpAk5mv2J6HXd3HsbHTdzaBW18Phj4WP7csX/0Ve/FHslr9d8mrN+l4wc9SCf
         QuK9GOi+qhN3KT7IFAzUx86KrzvL9juK54ln0w9uAw8o3VqxxbTGS4uzKOzKMQ4lEqWf
         DJrGpSSsYW4ytnPZD5c5U70/JMQXMc+wv+DgH6Z4ciibQDdLNsWKFLMH8LPDMOri/Eg/
         O0lw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786092924; x=1786697724; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=BPAgHBWPlEhA1Yqf7+9Wm2Catab7SOXiHm4SvlTtyuA=;
        b=ZtRd0hg6szEyRKM91D83Zs9kuG3MqOJ0CPIiUezkMAZukCjjbsfGSs91YvSWsixzAE
         dD+X+4PtQHxyTvCOXXGgGiYOAta+vfW+64qDRDHVmDSbqHdvo1u2ib8+3hX787jQ9LdC
         6B9M7PUrRyO5x2jRAkUjD6D5Ch6NHEfymEVQ1nddhjNXTISJ/yWtUFxPWG3ERruVcW3Z
         nbS7pQ/OfjzaCyIbUXXhUWSkltZWa1392p6MhlaQbSaWaGSp2oxNeBhC8E1R0lJ8OfpC
         /kjgVezUIuUHbeHmS0tolDXpXCYCYULtc5hWmhkPvQnzqAlYPQ8Tsob1YThpfDgHULWP
         MH2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786092924; x=1786697724;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=BPAgHBWPlEhA1Yqf7+9Wm2Catab7SOXiHm4SvlTtyuA=;
        b=D8iL330hPIbcwEqNgUGLaAnFXH8f9uUlsR/dEnviwiZMx0kVH2fqsORoJeptXp6uHf
         bbzYmVmqKW9196VKyFCrU+Zsh/wKbPTwchBs+Lpjwt9YuILu6tQk0srq3Zw4URVAGE4E
         t4b7fUEFSO3QHRHSdjFlJLxrfZWxpbkL1+SphBjCLMmAPLcXpiHla7iXoZW9K5QrzjW0
         fHQELZxVdJEjbN58YOzxf1Nz1LFR6wLQvqKmzTK8UdYb6C2v2/gXzQ1ZFjqZzd0rbTtu
         QT8+2RO1PxzygHFVKvrepeehm2Q67UoqQ4W7vHorWK5PTW6cEOLU5IxV1pqak2cJpzJj
         hx6Q==
X-Forwarded-Encrypted: i=1; AHgh+RquZwm7XZAhh1hAWAImpAzeXt4QIniaW8I1P7T4/c+mcXOz0GcifaD5VVDZ2ZjP7FGd44gK+qR3iFGt@vger.kernel.org
X-Gm-Message-State: AOJu0Ywnzw5qF4Ck5kBNnVSPXKw8UFXzQUKILA4FpBRprWq4/sHcqgQm
	OglssKmRGfIwLQu0ytXugC9A6EdmT+uHk10L+7o9POgyKBsnVTelpz1exfEJhQW6yTOfrTNt9Gk
	g5QwDFHcpCdKOdqKqSIwxga6yZXDy+Z4=
X-Gm-Gg: AR+sD12JF5RkwxVWn9A7LtKDfrPy+htuOw93wlE3AaqYCK05NMN5xUzA+7WEdz8pHKM
	WkDXOqF6PwjhpLo4ppKFD8fg8PoAUXQlP5S3dn8pdssp5VB+7e9MZidCppyJXESSt67AZ25Xtfg
	zD8h86d7Q3YLCSCFwPYnuO6aLlqd4m5vmmyjtaEEOczg50B+l2FjzULe/8vWFl3BepExQuDFbLe
	LlrzJ5MxZgWl/363wpdJF443Adfk/r1q35UcFyJMq4qzO0aoBT3czHEiWSybxzQqA5/t8EtxPXF
	ZdWweRza65Diev2Iq9V4gF3HunncVXX1Mh6LNGvxg7zW
X-Received: by 2002:a17:907:7ba5:b0:c1c:2c32:1163 with SMTP id
 a640c23a62f3a-c2039f3d9c8mr1069951966b.25.1786092923688; Fri, 07 Aug 2026
 01:55:23 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260731074729.1885314-1-wale.zhang.ftd@gmail.com> <0dfc39a8-6ed6-49c9-acfd-6dc722f008e1@fygo.io>
In-Reply-To: <0dfc39a8-6ed6-49c9-acfd-6dc722f008e1@fygo.io>
From: wale zhang <wale.zhang.ftd@gmail.com>
Date: Fri, 7 Aug 2026 16:55:12 +0800
X-Gm-Features: AUfX_mxr1i-f2CZ9Bqem_XRmB9N3cB2BWLy4j4_KXlRequ1TugM3hSFUClxqHK8
Message-ID: <CAHrEdet=CHHFZuY-AUg0Fu1vJ4msL1BXR+C=fVicm9y+Maj2JA@mail.gmail.com>
Subject: Re: [PATCH 1/1] md: skip discard on unsupported member devices
To: yukuai@fygo.io
Cc: song@kernel.org, magiclinan@didiglobal.com, xiao@kernel.org, 
	linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

OK. Thanks!

On Fri, Aug 7, 2026 at 4:35=E2=80=AFPM yu kuai <yukuai@fygo.io> wrote:
>
> =E5=9C=A8 2026/7/31 15:47, Wale Zhang =E5=86=99=E9=81=93:
>
> > blk_stack_limits() uses min_not_zero() when stacking discard limits.
> > Thus an array containing devices with different discard capabilities ca=
n
> > expose discard support as long as at least one member has a non-zero
> > discard limit.
> >
> > raid0 and raid10 use md_submit_discard_bio() to submit a discard bio to
> > each member covered by the request.  The helper currently also submits
> > bios to members whose max_discard_sectors is zero.  The block layer
> > completes these bios with BLK_STS_NOTSUPP, and bio chaining propagates
> > that status to the original discard request.
> >
> > Discard is optional, so skip members which do not support it.  Members =
that
> > do support discard continue to receive their portion of the request.
> >
> > Signed-off-by: Wale Zhang<wale.zhang.ftd@gmail.com>
> > ---
> >   drivers/md/md.c | 4 ++++
> >   1 file changed, 4 insertions(+)
> Applied to md-7.3
>
> --
> Thanks,
> Kuai
