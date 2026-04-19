Received: from mail-dl1-f52.google.com (mail-dl1-f52.google.com [74.125.82.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1826271A9A
	for <linux-raid@vger.kernel.org>; Sun, 19 Apr 2026 06:01:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.82.52
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776578485; cv=pass; b=GtNfuo908DelUtlr8MkXCOlR8fm+hXKvsaObhvKHK4y5dDgDgbRMu3/xxUTM1YcGtubod2/B9eSqEYis2pHnm1v1EkDidWO4TsgUpZu5O3Y1inVNlTpZ72QFw6t36LEtdrtdXWKj0Nf8123OlbsZ8tDt76lI4EI6pP+AdJ8g9Eo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776578485; c=relaxed/simple;
	bh=d56nFxj1OEEy39F5pNR83gTlNRPndNRmNBfo9C84aoM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=HI9ajorLpQhiICuoMtZP7ua6rPNEyYqFPnXkyAaQp4C9lqSSJtlYNH5XwC1N/LzGW/UYnwWc4I1jydDjvAQS5gBmp0S9ZG2JdY0H2Mh+Tpa8ja8tX89H2IJaALgolAj8dt3nLcrqjaIBen+fuvmIcEGBil3zzWmZS6mQQdWneBs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=JbHbGZUU; arc=pass smtp.client-ip=74.125.82.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JbHbGZUU"
Received: by mail-dl1-f52.google.com with SMTP id a92af1059eb24-12c726c30efso1776728c88.1
        for <linux-raid@vger.kernel.org>; Sat, 18 Apr 2026 23:01:23 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1776578483; cv=none;
        d=google.com; s=arc-20240605;
        b=OZ2l3S6Q6qDZ2ozdDJrxZrOm9gzQ26SI48kaCsdS+5D7eumw4Faet56r1zw8J/cXR2
         SshGYQVvHGd0Ck45oGLLbK3LDXjZPx16j/Pcg3XvQus7FYw0n0QXTIMDYUwVShyWn288
         KkBw8yyeeNliUdiwIUo2NQi10wRoERZo9dsBJkIb+1lMDWN4pH3s4KZOwC01AEDYH1Cl
         kFdIm3UFpxpgDHAL8fhAtpi/B4L+WWx+XpImZrxtau9jRHbcN3TRIOTY413majeQlLaZ
         t6jnxxNqRqYFehtllmKLX+fJbQDGtvu+Dx6ZCK/decpfraIYbx6ieOWA4JK/KKWzf6CV
         B6VQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=qnhQK5ByAky3Pfxls7vffmaT8Yl8W5R9qQ6SoWstULU=;
        fh=w6Xh9O8D8A9sYNv0/4Y3O8yar6LOdVix5h9+cz8wRcI=;
        b=DqLuinyBmU/QdKZrtboyordcPHToH4raXyHjlq/ZIvffMYQn6OtaYNf7gt82CWwTVm
         ZgUiXpGXn9K0Y2rkwjH9i5p8d8W+TUONDJhEOyz7BI7xEL9oKBT9UpbqgzPY6suDCqQY
         n1sSg/1vgc37V1gnCH86QwgFJSvFmj0pxx6Z1COcxIh63WGEMoTw851kgKl1r+CZSPLp
         zDNyAqUSPvtBPNs1D6EVu62lXI74EabvNao8ORtSEGYj+NLpK0et5UoJNw611AWfx+9m
         N+ACQ5K5gusiDpsP3E4IvyK1b7Wol5SoZDlNfIqbFCAZBryEo9vF5aLJiCdN8x22OI3+
         vO7A==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776578483; x=1777183283; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qnhQK5ByAky3Pfxls7vffmaT8Yl8W5R9qQ6SoWstULU=;
        b=JbHbGZUUvgQ++jCW1lsHWbqex7yZTxLk955yXc0c0LODRTdamQ0Gaa8aOWOFE1uiFn
         Kb5RsNL8UmTi1QUpt0ZJEkKOgMPNukKbDSDJlc3KzM2nJwubwqvY7bfToLWdxbFb8c1V
         /VX1nhIb6/n+cx7TaZ94/C6/0kVOpZu0mAv9br00PYn+UEZDbIpOu/Mx9744waJgqWR6
         3d1IbIorvqXxBjSNtL5B4LMgY5jazbYF3ZGUmt8aGtHIa/kVtfJwCkL6gvh85LwxicgL
         Z+Ut/wBWAlavVWtV6NW+6JkHjz0quSf/zarGaqZlaLkmw10LrXzSTe03Vm6fknt67NcT
         bgUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776578483; x=1777183283;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=qnhQK5ByAky3Pfxls7vffmaT8Yl8W5R9qQ6SoWstULU=;
        b=hh5NDLm43PE/W9Lx6du8eCfyKOYXMJkFNyrF5VaiCzXAUNZDBZKbvuVyWWAfVgKgpS
         JOV++lEHeAL6rS29BrDtTFtwpGt6aaiDABSr7CWSceVYrbHmfr/K/YyEoGSG8MDXvUlk
         n8v0wahexa5kZFfNigsm/to6sk1XnK9LiNnLXI3g5CmpTkEgv7gQamkoudXKDL6Yrh5z
         fkmOGzZXWw0Mll89Hu03HuM0vArtOyvrBMA0fTGpjBixD9w1kaauRXTWKQnPSosVUhgW
         n+u47G3It4O9aehmXeU/3l3NZbghEKMhxYJoKgAD/m9GTUG5tjssLVBkUGBMWcLkv2yg
         FIaw==
X-Forwarded-Encrypted: i=1; AFNElJ+e8vbycGFwHFgDi7Ptg3UOVjRAhb0QhpRtqbFbliQX8D/nk+AwkizBJvElQwqqPJqwOBpA81npD6Gj@vger.kernel.org
X-Gm-Message-State: AOJu0Yw/HTvjVSXzLaEZAyFqrtoR4DX+QQKut/gifLpAunWhsrdw/xA9
	rC1+K+pGLh1O6Z0s0pL9ZsgatqQOV40At6xQAIxtpEiRly+MqoOzBJy8nIV3J//Gr4zNHB/BNwe
	pORuEZaDbmzjbM31ivlixdV0v+pRRmJQ=
X-Gm-Gg: AeBDiesenMfsgVHtwvLFQAwdmWwAln3LiPfFkDARUvq6/fZo1u9dPMbY6sRrGjcmtz7
	RCzl1EgFMFj3zS7B49bfHFw1otJRQ1sm8oCW6Se2+Dj7dL1WgdB+gmQBFB4TaKoOdksuH76ssvy
	EN4cD26tlLli6JgyZTHd4NoESCelPUSbTSmVEuX+Fi0xm5Waci9yEaRUrMA45uqKqdHuEZ9JOdc
	c0h1+Yei/ZqYwW/JzsqVLlcPjGDbjuBbWwdWktGHkdOndUIj0T1yorB0x2q6Cfl6qznJs6ZKobQ
	Fs6NucL1JS2RjmNp88QtDn49/Vw4OJAa8dL0hXntTDHmM9jj+w==
X-Received: by 2002:a05:7022:6b8d:b0:12a:6a64:81d9 with SMTP id
 a92af1059eb24-12c73f723aamr4145769c88.13.1776578483008; Sat, 18 Apr 2026
 23:01:23 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <SYBPR01MB7881A5E2556806CC1D318582AF232@SYBPR01MB7881.ausprd01.prod.outlook.com>
 <beca1657-0180-4f9b-8de1-ca7776c9614a@fnnas.com>
In-Reply-To: <beca1657-0180-4f9b-8de1-ca7776c9614a@fnnas.com>
From: Yuhao Jiang <danisjiang@gmail.com>
Date: Sun, 19 Apr 2026 01:01:12 -0500
X-Gm-Features: AQROBzDQnuuVEq1d1mA8mMvGyABGnSmWWnn8TcqeJbrCApmUyEZjtQBRIXzxsxI
Message-ID: <CAHYQsXTsX8S52pSbSHAN315nRrNNQxrY2bH80c7dPfhSoS4uww@mail.gmail.com>
Subject: Re: [PATCH] md/raid10: fix divide-by-zero in setup_geo() with zero far_copies
To: yukuai@fnnas.com
Cc: Junrui Luo <moonafterrain@outlook.com>, Song Liu <song@kernel.org>, 
	Li Nan <linan122@huawei.com>, NeilBrown <neil@brown.name>, 
	Jonathan Brassow <jbrassow@redhat.com>, linux-raid@vger.kernel.org, 
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Kuai,

This report was reported by me, so Junrui added me as Reported-by.

Thanks,


On Sun, Apr 19, 2026 at 12:43=E2=80=AFAM Yu Kuai <yukuai@fnnas.com> wrote:
>
> Hi,
>
> =E5=9C=A8 2026/4/16 11:39, Junrui Luo =E5=86=99=E9=81=93:
> > setup_geo() extracts near_copies (nc) and far_copies (fc) from the
> > user-provided layout parameter without checking for zero. When fc=3D0
> > with the "improved" far set layout selected, 'geo->far_set_size =3D
> > disks / fc' triggers a divide-by-zero.
> >
> > Validate nc and fc immediately after extraction, returning -1 if
> > either is zero.
> >
> > Fixes: 475901aff158 ("MD RAID10: Improve redundancy for 'far' and 'offs=
et' algorithms (part 1)")
> > Reported-by: Yuhao Jiang<danisjiang@gmail.com>
>
> So again I can't find a report, and Reported-by usually should be followe=
d
> by a Closes link to the original report.
>
> Applied with Reported-by tag removed.
>
> > Cc:stable@vger.kernel.org
> > Signed-off-by: Junrui Luo<moonafterrain@outlook.com>
> > ---
> >   drivers/md/raid10.c | 2 ++
> >   1 file changed, 2 insertions(+)
>
> --
> Thansk,
> Kuai



--=20
Yuhao Jiang
