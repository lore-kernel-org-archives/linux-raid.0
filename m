Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com [209.85.218.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39C813D648C
	for <linux-raid@vger.kernel.org>; Tue, 28 Apr 2026 08:37:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.218.46
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777365443; cv=pass; b=YJxPkPKGXcfP3XW6wUxRrB90DKN2objk/nqv6oP3JHGjGdwx4Lq8H72OZ4tnV0W22KWSWY1fuPIrAs8RRClKaCfaEO0W6iDiB+cNy08udmp4+CY5lOWb5uVvWHnAkxUbXozSO/NMPguNYa9vUZydVHjTakStXXX1WlyN/cZJBbE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777365443; c=relaxed/simple;
	bh=hpvgtOg9/72WktrpHYSd2IOOAUVZlL5xFX3l3yMfNhQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=gnZqesrLirK1B9EhGzhhZ2i9ZMaLnRt0etr4EJimkYKckgmMvu+dnjupkRdGFsZN17SwspMFPuzFloTEO1LYh+/70T4YkgRhxTQuG2qtvwqEuzLpFbVIMdjIiIhlu2VEfFN3KvagYrpE8wG2LMTQtWI9p4JCEtd06EhKJ+KP8T8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=DE2oA4l8; arc=pass smtp.client-ip=209.85.218.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DE2oA4l8"
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-ba7a1cc0380so1848871066b.2
        for <linux-raid@vger.kernel.org>; Tue, 28 Apr 2026 01:37:22 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1777365441; cv=none;
        d=google.com; s=arc-20240605;
        b=XsWJ6zbETHxD0z7mst9CRbD+lYZ6gCYYt9aohfDs8Er+ySk72Cj7sJiM6im802V8iM
         YkpNjC1VUZxGr939IqyDLXZFMaJSCOWrMNGGMQ9Bz1Ga03jUyOjnaUwYfRxhDTowVkGp
         gIhbitXmowptyogRKoqmJrQ3j6DqX1h+0CSWLDeolW2k6fS5fQ9gLX9jOjepjpH6g+Jb
         zmxbA7NjXiYUrn5ierZIgMcgFkrplMWIMCUNFilj7NYTRMUTvwmQcCcrLjgD4oHQg3UJ
         3TUg6sSK3EnwmCTK3ug58/ZHOnGpxjSQslClWqacRjcprR73EK5wb0VyPvl7kIJi9IVs
         x+YA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=n6G+qgWYTC+CrZljToWIHCOWqzYHmS+9O6T1Mv+lOQ0=;
        fh=HREnYBgPPKr5DRyMIl127K0kBIfcRgZ5XJtr++sydI0=;
        b=HGDTyYI3kCw9wGP/B3E+GKsKmknk/7RgkjYyuVThycZSQmy+MN6wYP24sH0vefMTxf
         DnS/ty+VtlsKk973C3ImhPCF0NVztL9atLbkl4S6h1DDZyOAB/ZWfxmV5Q8Bg8PBik3J
         mcSO3tSq/i9YGqj15O9OVpzw8VlPWGtAP37ttGV1S+XYCbXX94mNnj9RfQLp2Bp/yFtD
         7aDcu9wFWtqxwh5/PqBBXD3a30Jkg3kf93t3t+vq0xlJUc5gCtjDDc3zd5JoL8HPBhj7
         Sj7nHFbqmP4mA+/L1i1N5MlKD+H2DEkbSg4d/1plv8skxl11yue2BHTY7to1x/I7sQyF
         EKYg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777365441; x=1777970241; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=n6G+qgWYTC+CrZljToWIHCOWqzYHmS+9O6T1Mv+lOQ0=;
        b=DE2oA4l8Nij5hZLXmK6d868tHE+w74wNr2mQV7XYPaKddTT09LpoYmjxvDmJW7xKue
         LecRBeRZCh3hUp5C6aEU2/DqK+Pp1g1aKo9F989pdlspjUncAb+AoZergWvcMdTZeior
         tgeFaosxjvVJrwWAzfQr5H16CyPdTFjXzVrZsy7QlT3Z1mAn/nadBTfp+E1XrlZlWad6
         lPM3tSbmYYVU9iw0Wq8lYmrdH/ncjraPhxiaHQpHBndQ5gTgD9I/nG5V8W5SU8sv/GMf
         sMuFruj/BDmfKJQEyFG6avpjaZscpYz//2IlQNghYA1f1LU0a5VNBgxmkelO6j96u0TZ
         VQyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777365441; x=1777970241;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=n6G+qgWYTC+CrZljToWIHCOWqzYHmS+9O6T1Mv+lOQ0=;
        b=hD+hSleGqtahtUEl3pzqBmZW0FHfyWd/aNHS9IldeFjojsTjch01ZikuxayhNfW5lk
         5ZepKcrwubxW5dwWp2TfIz/mZTazxqhBaSJAjK2V/bIw6sSq+yapIE9kSkXXqINtdBCe
         Qh1CCp6WFLywuQLqXk48Zzo5MdyqauNYbBZc+9gSUlhOuBJSHwyGzSp+z71W7QlH3mC4
         vWW3p2E3RGZrUbQvBwFouefWw1eWNoiOV1nkkewlptmN8cBd6vudslNFYRqMV9vanYP3
         NrqIWpfTNYFRal4OpqBb2/oRvPEAAFZn/NFmjipFH8cZODGGxHoEkrPW2ReWhO7te3Yf
         0ahA==
X-Forwarded-Encrypted: i=1; AFNElJ+IqmgcR8RfLMuI7Sj9ormikm2wVOnqfDeK30lZrXNxvnyM/I4xrYCL01ENaIO5SkDnjon92tBZbwFu@vger.kernel.org
X-Gm-Message-State: AOJu0YzHrSjYkpWxOipyFqA4mLeDhtg/fjHIClWNnDNQqx5lhpdiA+CV
	Wdg0fUI641OUMbRZND3VK0Q2ra2vNz5fNiIAXkoScKah2X7OMaKqHOCNxXQsrXoJFL6QkmWWcKy
	2Klv8td5hlNv4nLYsFpBLVwaM/lwYq50=
X-Gm-Gg: AeBDievf+BnPjWDTTQZ4+IdyXCa6lhxAA3MoEkQZhSXs5TdUydBQFHCdF5ObIdYAYYY
	jKgQ+1F27byVM1f1GSqGUkv90mwZn+We7460nIo5sJiqLK1oDi0gI+NqfLcrgbtUIDUmcUGgnsJ
	Ofdp6fUSHs0SWiGOgc/ZdQje0GykjS20EZNqldc4M/SdWLZ27RJa58JnLguVor0UWLTjPVDXr4L
	NaKq/aQft5MLw7PwqmMxtL3BwvHSOscpv/w3cWxDYBW6bMr7b6LnxwfVlmCEAkd4CBfbOWuW9+C
	zzMouk9oDoMvPV2K31VM/TeUFkC7D6BNLtQ2ukyaL8f3RPBRDeg=
X-Received: by 2002:a17:907:a781:b0:ba6:cfb2:c048 with SMTP id
 a640c23a62f3a-bb80443da14mr129972366b.43.1777365440349; Tue, 28 Apr 2026
 01:37:20 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <SYBPR01MB7881A5E2556806CC1D318582AF232@SYBPR01MB7881.ausprd01.prod.outlook.com>
 <beca1657-0180-4f9b-8de1-ca7776c9614a@fnnas.com> <CAHYQsXRN6uof4yyDR6qGteQ=wZTt86VUx7km6k=LbNAQ3wxGiQ@mail.gmail.com>
 <282278bc-7d71-4049-89f4-a9f3968504dd@fnnas.com>
In-Reply-To: <282278bc-7d71-4049-89f4-a9f3968504dd@fnnas.com>
From: Yuhao Jiang <danisjiang@gmail.com>
Date: Tue, 28 Apr 2026 16:37:06 +0800
X-Gm-Features: AVHnY4KvGt5v1k39WjxDYGhlTLfgOcqclOaOgzkAnTnKKabHIzkk4zX7G2Tvvbk
Message-ID: <CAHYQsXQhTn905RGCrw-qeb--VHsRGR2KEWm5X0ZJEW+krTJaNA@mail.gmail.com>
Subject: Re: [PATCH] md/raid10: fix divide-by-zero in setup_geo() with zero far_copies
To: yukuai@fnnas.com
Cc: Junrui Luo <moonafterrain@outlook.com>, Song Liu <song@kernel.org>, 
	Li Nan <linan122@huawei.com>, NeilBrown <neil@brown.name>, 
	Jonathan Brassow <jbrassow@redhat.com>, linux-raid@vger.kernel.org, 
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Kuai,

Looks like different maintainers have different rules. :(
Can you send me the patchwork resource?

Thanks.

On Tue, Apr 28, 2026 at 4:32=E2=80=AFPM Yu Kuai <yukuai@fnnas.com> wrote:
>
> Hi,
>
> =E5=9C=A8 2026/4/19 13:59, Yuhao Jiang =E5=86=99=E9=81=93:
> > Hi Kuai,
> >
> > This report was reported by me, so Junrui added me as Reported-by.
>
> This is fine, however, please do not add downstream reported-by tag.
> If you want to add the reported-by tag, please report the problem to
> patchwork first. :)
>
> >
> > Thanks,
> >
> > On Sun, Apr 19, 2026 at 12:43=E2=80=AFAM Yu Kuai <yukuai@fnnas.com> wro=
te:
> >
> >     Hi,
> >
> >     =E5=9C=A8 2026/4/16 11:39, Junrui Luo =E5=86=99=E9=81=93:
> >     > setup_geo() extracts near_copies (nc) and far_copies (fc) from th=
e
> >     > user-provided layout parameter without checking for zero. When fc=
=3D0
> >     > with the "improved" far set layout selected, 'geo->far_set_size =
=3D
> >     > disks / fc' triggers a divide-by-zero.
> >     >
> >     > Validate nc and fc immediately after extraction, returning -1 if
> >     > either is zero.
> >     >
> >     > Fixes: 475901aff158 ("MD RAID10: Improve redundancy for 'far'
> >     and 'offset' algorithms (part 1)")
> >     > Reported-by: Yuhao Jiang<danisjiang@gmail.com>
> >
> >     So again I can't find a report, and Reported-by usually should be
> >     followed
> >     by a Closes link to the original report.
> >
> >     Applied with Reported-by tag removed.
> >
> >     > Cc:stable@vger.kernel.org <mailto:Cc%3Astable@vger.kernel.org>
> >     > Signed-off-by: Junrui Luo<moonafterrain@outlook.com>
> >     > ---
> >     >   drivers/md/raid10.c | 2 ++
> >     >   1 file changed, 2 insertions(+)
> >
> >     --
> >     Thansk,
> >     Kuai
> >
> >
> >
> > --
> > Yuhao Jiang
>
> --
> Thansk,
> Kuai



--=20
Yuhao Jiang
