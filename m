Received: from mail-wr2-f35.google.com (mail-wr2-f35.google.com [74.125.225.99])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C656E3C1412
	for <linux-raid@vger.kernel.org>; Thu, 24 Sep 2026 17:59:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.99
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790272780; cv=none; b=nlPFK4ODluz+EJ6z1Q+0Bh7GHB5T12lu4+eSN0aGNI5+wM8MvIm3F+LI4MRgrv8B5RfeVeaO5tWhpASO7Pf8QAbOkooVnBXwKuHxxmFhWO3Osyy0AbZm0DSlLwE6aSWgGmbg3JQBL4q7q2BPwYwByAtaoTDXj1Gdjdw4r7JA+vU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790272780; c=relaxed/simple;
	bh=fF74laipFT1G5TeJZYe/ceejQjOAN0pdO5e1WUdrC+4=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=eauhbIEK0gOCcPvBTRRsQqkh1qClXXBAk2Xk4HzVJ1R/BrTiJP7sUWFOHHL8uOl3lIql33Ug0WiheniF06Jo9jhZb5eTnrCK7tea9PaDbqufemx/+r6YdecOa1Lr4AspjaL0X1lGA1Zcjp+CAxejQRJiObFu3Lf43uD4WmEoY7E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=ZlI1WnEz; arc=none smtp.client-ip=74.125.225.99
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="ZlI1WnEz"
Received: by mail-wr2-f35.google.com with SMTP id ffacd0b85a97d-482f63546c5so59208f8f.2
        for <linux-raid@vger.kernel.org>; Thu, 24 Sep 2026 10:59:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1790272777; x=1790877577; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=fF74laipFT1G5TeJZYe/ceejQjOAN0pdO5e1WUdrC+4=;
        b=ZlI1WnEzdSYptk+mAVhQZISGuKovacqzAeRQqKIYSOT1UjuAVULZWWI7sPLZY38POK
         /GfDnUHRJi5+ioySuM4JkAXnAufphvQRp+ztdMxfwmOgkRf552Tk6ASON8ch7jHfGynC
         xPSuvx1s6LqPQkMNWkTe1rLzt1zilFeM1IRGHE+a8pmcN4/zNex3RgGjXG7lV+8jy0oI
         003SS8s67pgPPTUkmUFN7zpOKBC8RatHAS4OH5hrNEFn/hc4UF4N7lx5WR5iKIyp1HUE
         voke+yTt7QmPDLl49gPOvZOJOQwnwSTZOikO5ddQ3cKVL7I3lxYKTPiTlNOlZd1JzbNE
         yW+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790272777; x=1790877577;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=fF74laipFT1G5TeJZYe/ceejQjOAN0pdO5e1WUdrC+4=;
        b=QUt21qBkFYMwgP16f0QGXswWtggQoQiX3UCTIuS2KgYgl6+rHk8VPNwddmeIqOE/P1
         JyoxEkG9L+VFJ6AccXlHBzyh/o9dJNkIkmQGi1aETxG+YfUnZXFk83JKYNtwQz2mDTIY
         qFDHgXOwcHfTjOfCkwTHRnYAQ6N1Onncqd6+X6LOh8fkFd/jj/c1/+22niAviHV0TQAs
         pLAoJ2Kw/mypkO0YEWN58u7scwYRS9KnwE5psb4iiZt86VHg4gymnJRtznSgoGrW1WyA
         Z2msttu+uVUWbkP/T/kj+qsjFTauy59GxAyoeqU4Jt05MwkmUMc5mmlIp4EcaYXGcYTA
         GxYg==
X-Gm-Message-State: AFuF++mkAcTQWfCj/ZPN42HByK+te+1mHTDm29QYZtYow7SCPzQPWKse
	DzVWGgyk64mxe6wxxZpQBAkPpmtcuBU8idUJF55t2otC5urAXgq61kUBySM0yNyNSZ8=
X-Gm-Gg: AYBFou15svbxK3GxMc4WYvC/HEpwt5ZLoCGjt523roxo0ZW/cZJPWbHtkpa8nmAf+VE
	MVwNDUCSa6mLjY0Pom0PUKnv3nE1tc7GhXcnFtDeYqLG4oLdQRipzhOrrAjDCuNQlE25UowpNUp
	kJA7BtNIu/tG/bqm26GrRLoycxfHlHf8bithrqOr7bWIZXjRHYatz3OwVe/YW3kIV7A5nqm8yZK
	izf4RpIAEQxgJ6bdoh+GceeYySL+1ZmHpk83+2e2Ug5aK1PYEtwG3SOawaRy+QGUdO6cG3Tso6C
	Efq/61X2saKlrzsEWWcq9GATFG8kyHhzcj+Ttn17lQQ6FBIDFWF4Xs/7zG+cFtibZ1eYvrAlii0
	HoFq3QENCCxL3GY9uWHs5Dwf+zUdRkpYKa0nOqEAbjx61Yo0Q+NifxuA+L4gYDguEy0G+LSeCp/
	SiF2pOVklnOZFs/BETGylobxbBNeYGhB3n0R2OOu2Q27BiOPZgOi8eK3fls7dxoNr5YJBsv2psV
	C5XL3istke0dNrTP/bnWyczmG3llzYfPF5hPRQZQgXO+0HECNfx66SlnK+rllE3cWSbF9NVnmRk
	irDyLz4DmGnPgyz4ll1NClrZ6zRXHo99hAxNGImgKYzb
X-Received: by 2002:a5d:5f07:0:b0:485:8c16:5ef6 with SMTP id ffacd0b85a97d-48871874b3cmr6229087f8f.48.1790272776686;
        Thu, 24 Sep 2026 10:59:36 -0700 (PDT)
Received: from p200300de37172700e7f885d729fa4be7.dip0.t-ipconnect.de (p200300de37172700e7f885d729fa4be7.dip0.t-ipconnect.de. [2003:de:3717:2700:e7f8:85d7:29fa:4be7])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4887a640df9sm668299f8f.24.2026.09.24.10.59.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Sep 2026 10:59:36 -0700 (PDT)
Message-ID: <c1ba66d1bb5c498197559749842b5b470c06f4f2.camel@suse.com>
Subject: Re: [PATCH v6 1/2] md: Don't set MD_BROKEN for RAID1 and RAID10
 when using FailFast
From: Martin Wilck <martin.wilck@suse.com>
To: Kenta Akagi <k@mgml.me>, xiao@kernel.org, magiclinan@didiglobal.com
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org,
 song@kernel.org, 	yukuai@fnnas.com, shli@fb.com, mtkaczyk@kernel.org
Date: Thu, 24 Sep 2026 19:59:35 +0200
In-Reply-To: <010601a0d43e61ad-9dfd0eee-a057-45eb-b5cd-dfe9d892d4cf-000000@ap-northeast-1.amazonses.com>
References: 
	<010601a0d43e61ad-9dfd0eee-a057-45eb-b5cd-dfe9d892d4cf-000000@ap-northeast-1.amazonses.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.60.2 
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Thu, 2026-09-24 at 16:27 +0000, Kenta Akagi wrote:
>=20
>=20
> On 2026/09/23 17:29, Martin Wilck wrote:
> > Hi Kenta,
> >=20
> > On Wed, 2026-09-23 at 04:08 +0000, Kenta Akagi wrote:
> > >=20
> > >=20
> > > Hi Martin,
> > >=20
> > > I have not given up on it, but I have not managed to post v7 yet.
> > > I still think failfast should be usable even in setups like that.
> > >=20
> > > It has been a while, but I intend to resume work on it.
> >=20
> > My thinking is that, in the fastfail case, code to prevent total
> > failure could be placed in the end-IO code code path, e.g. by
> > attempting a retry directly from the md layer when the last rdev
> > fails,
> > instead of setting failing the device. But I haven't thought it
> > through.
>=20
> Hi Martin,
>=20
> I may be misunderstanding your suggestion, but Neil's original
> failfast=20
> implementation already retries a failed failfast I/O to the last
> rdev.=20
> But a later change introduced a regression, which I intend to fix.

Ah OK, I wasn't aware of that.

> So the sequence should be:
>=20
> 1. The failfast bios to all mirrored rdevs fail.
> 2. The first rdev is marked faulty because its bio failed.
> 3. The other rdev is now the last, so it is not marked faulty.
> 4. Since the last rdev remains usable, its bio error handler=20
> =C2=A0=C2=A0 retries the I/O without failfast.

Yes, that makes sense to me.

Martin

--=20
Dr. Martin Wilck <mwilck@suse.com>
SUSE Software Solutions Germany GmbH, Frankenstr. 146, 90461 N=C3=BCrnberg,
Germany
Gesch=C3=A4ftsf=C3=BChrer: Stefan Gaiser, Jochen Jaser, Abhinav Puri (HRB
36809,AG N=C3=BCrnberg)
