Received: from mail-dl1-f47.google.com (mail-dl1-f47.google.com [74.125.82.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D4D539C00B
	for <linux-raid@vger.kernel.org>; Wed, 20 May 2026 16:43:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.82.47
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779295429; cv=pass; b=hH273BqWeIAWMDj5Vv/aZPymCVlwpAYxyc56Km/DxWMye4G7fafck2rMRiBbYO32KM+pqzCmZw5GD1GWZWD/vL+8OTpHHZqDpGjWUxTwJVFhc8LC9M6SHaA/V5OZlsjhNb3W+bWVZwAlgR4FfKZUHlfVroAjbQ9JAwMeQjEh1sA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779295429; c=relaxed/simple;
	bh=K0SmBd3i+Evg01AmybdJImEVnXbgwxW02OAxKC+QiMs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=kCUIHfKjHtnH3SbA7ptYd6PGISuvXue8y8t7mtNPJt1jkskNJCU/WLUtRDcAnLmeScgIDT9+E6tdhseP6Stuils1Izmu8dsHRy630IwVumRs/J3uCriQnYOuxbldZiwNeRtDlytmSN4BRhwiyHfDnmPtJfqxjhHQgZpmyRIGTsQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=XGEVYHYp; arc=pass smtp.client-ip=74.125.82.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XGEVYHYp"
Received: by mail-dl1-f47.google.com with SMTP id a92af1059eb24-12c1a170a50so6446271c88.0
        for <linux-raid@vger.kernel.org>; Wed, 20 May 2026 09:43:47 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1779295426; cv=none;
        d=google.com; s=arc-20240605;
        b=C4MHmCTFRPy/YGBQiVPn7oo3hfCnHpe3iSztZ8qaaF4In63VgjXmw6xh/KqQ5ls7I8
         6dSlqwH0eTRLtUrIVrwSTL3DnHnvFL9ZL1tXRWdkzL7iGiaUQclUhAOVuh+n5Qv3ckRB
         pS8NLKKX3u550SQQeVx+QcTECFxVIMaK5BuVzMwIhQtYO/h/YFmHvmhOklt2lVVlnUM0
         fwN1chhitKOzYtakDvPJQMxIBKn1gSvpNnWAob76zfPPh/NI0lxjnLvXP/Tcg/TRG8Ix
         IEaDMHWlgp4mi8/4ne/7CoZfjWiO+Igkveedv945LeeJ/WKsHum7844ryKZitJr3HrkE
         MpnA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=awmx7wqZavYrfGTB2OHvccP0wAddCGzaOcms0KgYzqw=;
        fh=tmKlnE0QnvEISqtzhl2F8IkqTz4udM0AhiO+XhXT8XE=;
        b=EiQODV0MUfua+gE2/1ElGnjnzMtkLaBq1Zb8RXYD+KHlw7R9BZjNg9nVBd2gDHazGd
         ADnNHXub65EjdBuXmxtoqp8jjaZYN+zNQjLUGBhtXHOv4DytaJpuVLBP0eSop3Nf68HH
         PCJsjbB0rajkSX706K5zNhmfXAHg6A1vJgWj4anTrZ4gC/w7QLhrIZtKXeDq6lAhm143
         POiWeUXqQ/ez3C6lmZVM41apTSMiQKkEcXD5DLgblOrI41/UI3+qcuUWYiimxSlT3HSh
         i4q0ZUXytGMVDYlshGyrxcVDggmx+hryBxMqmk75UNdKi8O9uX+teK0Sz8Q7H+z/y89x
         o32g==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779295426; x=1779900226; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=awmx7wqZavYrfGTB2OHvccP0wAddCGzaOcms0KgYzqw=;
        b=XGEVYHYpEk86uK0aEWdS6+bAG1fijNZQXwmdqVlua5G5j1OIoTFS/OjXfmBzIypqp2
         Wrth8ovNUxl0n1ymgTETqkTlwcKPmWGYxLDpRnmZ6yilRiRUJCqvdiYPFP6CPgNBnbCO
         MKshDq0weY7mpUA1xjx/ldIjyFMRUtoU71GQUiHGmX/GevzzJGBnhGVrq+utrBOP49be
         F9e3f1+d0uu/ZxVJOcyd6ZxpOcTb42vVDeDNj/ug7MyVg8JH0tiNFdfj6Va9vSDazvmD
         AsDDYCk32PBb9ZNo8iF/ONW5OAkt7P0PSCLyVRZDcVZGpFJ3nJTiapTZRbJNBtNLk9Gn
         QLmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779295426; x=1779900226;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=awmx7wqZavYrfGTB2OHvccP0wAddCGzaOcms0KgYzqw=;
        b=Avl+2axXLWivobuOmRX2nQYtpuxcv8wcEXIjcWauWYuXeAkBhSX5ajGnSMK/9pl9KJ
         iEqOTjhJHfHd685z0JdU5sHofoc1oxTnSFuDVlRU2EgE80FrPOJ1UpmU2WM1tPFkxlQa
         oJGc5YVjSWLZjMdCHXeNHl4ehSWHy3l0Y9+BZ4CjU4ZMJZtqqu23Wm9S+yabII5yHEMt
         RBaqC3qvbOQFCUTDoKTtvP04hZrd8rcAm5LDNsQByumdM5lkbysJxr0apJP0RxL8Mpid
         avDfw8nKk5BEUsxMGllGbXeveA9ONf7pRJ/QQSpoTb52/Zixyf4TTqEM4QpGDw6+bmW1
         IZrQ==
X-Forwarded-Encrypted: i=1; AFNElJ8wq0zsiSw/ohx88Qylc9MgWrz//8Tv7gIAbLE8qZKmG89Hp9ioJioF2DW7u1ZXDCSrUTbBS6+GfIqY@vger.kernel.org
X-Gm-Message-State: AOJu0YzFGcqCiDq4P/O0aEu+i1Fa312aOKr46b97pZd1KyZryglG0ToB
	9JlgIhQIu7YZXd7kfHyTDdG6KVphtB/AATLjPslDNrDkSfjMxCqTnaRmD5J9KD9v9f7ZNbLSHjS
	Ymv5RpOiSt7oVaVQWWoR+oGrdIVq3El0=
X-Gm-Gg: Acq92OGleTP9tHLoPHhDEDA86WWRm26N2U0rTndWTZkIClk3rTmN8Orw+h2LOfGMBMO
	9Ai/ncHBwTmnuIT2Eec5/KWDBgf3obatAUdaxHtbtJ+0UzxFx/B7Sc8bThIVER3VbsNSgLfXAQT
	IyGNYK9K6F2eUdb+3ovDdK/MupTWOoIYiWvMJwXymQJBLxCldNWVw5YRiQLwKsMizb6M4vziNqx
	HeVmvazu63Nc7kKumCnzhzGB9PVemy30bm8dwnZ278l7RwaNMMXBQvBq7DAaonddwSb1CLVyIIU
	wbQymYOa3nLQCWwF3Gr2T3YyD3I5ttlGsq76BLg9m7PRzbOvPW0=
X-Received: by 2002:a05:7022:311:b0:12d:b396:eaed with SMTP id
 a92af1059eb24-1350440ae04mr11257475c88.9.1779295426034; Wed, 20 May 2026
 09:43:46 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <SYBPR01MB7881A5E2556806CC1D318582AF232@SYBPR01MB7881.ausprd01.prod.outlook.com>
 <beca1657-0180-4f9b-8de1-ca7776c9614a@fnnas.com> <CAHYQsXRN6uof4yyDR6qGteQ=wZTt86VUx7km6k=LbNAQ3wxGiQ@mail.gmail.com>
 <282278bc-7d71-4049-89f4-a9f3968504dd@fnnas.com> <CAHYQsXQhTn905RGCrw-qeb--VHsRGR2KEWm5X0ZJEW+krTJaNA@mail.gmail.com>
 <6224b47c-9a7e-4bbf-90ce-4b98691ceaa3@fygo.com>
In-Reply-To: <6224b47c-9a7e-4bbf-90ce-4b98691ceaa3@fygo.com>
From: Yuhao Jiang <danisjiang@gmail.com>
Date: Wed, 20 May 2026 11:43:34 -0500
X-Gm-Features: AVHnY4KDm-qnXxJ9KW6U_J1BC5ffsE8cI5knCTNO8d5QEmcndtCLxjNThpU5ufo
Message-ID: <CAHYQsXSy09tmOKok3O-PqJqVKXBFMZB0M4E=s5AQbnbdagCLQg@mail.gmail.com>
Subject: Re: [PATCH] md/raid10: fix divide-by-zero in setup_geo() with zero far_copies
To: yukuai@fygo.com
Cc: yukuai@fnnas.com, Junrui Luo <moonafterrain@outlook.com>, Song Liu <song@kernel.org>, 
	Li Nan <linan122@huawei.com>, NeilBrown <neil@brown.name>, 
	Jonathan Brassow <jbrassow@redhat.com>, linux-raid@vger.kernel.org, 
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Kuai,

So in this case, how should my name be shown on this security patch?
Because I reported this bug. Most maintainers added my name in the
reported-by tag.

Thanks,
Yuhao

On Wed, May 20, 2026 at 6:52=E2=80=AFAM Yu Kuai <yukuai@fnnas.com> wrote:
>
> Hi,
>
> =E5=9C=A8 2026/4/28 16:37, Yuhao Jiang =E5=86=99=E9=81=93:
> > Hi Kuai,
> >
> > Looks like different maintainers have different rules. :(
> > Can you send me the patchwork resource?
>
> Usually just a link to lore url is enough.
>
> >
> > Thanks.
> >
> > On Tue, Apr 28, 2026 at 4:32=E2=80=AFPM Yu Kuai <yukuai@fnnas.com> wrot=
e:
> >> Hi,
> >>
> >> =E5=9C=A8 2026/4/19 13:59, Yuhao Jiang =E5=86=99=E9=81=93:
> >>> Hi Kuai,
> >>>
> >>> This report was reported by me, so Junrui added me as Reported-by.
> >> This is fine, however, please do not add downstream reported-by tag.
> >> If you want to add the reported-by tag, please report the problem to
> >> patchwork first. :)
> >>
> >>> Thanks,
> >>>
> >>> On Sun, Apr 19, 2026 at 12:43=E2=80=AFAM Yu Kuai <yukuai@fnnas.com> w=
rote:
> >>>
> >>>      Hi,
> >>>
> >>>      =E5=9C=A8 2026/4/16 11:39, Junrui Luo =E5=86=99=E9=81=93:
> >>>      > setup_geo() extracts near_copies (nc) and far_copies (fc) from=
 the
> >>>      > user-provided layout parameter without checking for zero. When=
 fc=3D0
> >>>      > with the "improved" far set layout selected, 'geo->far_set_siz=
e =3D
> >>>      > disks / fc' triggers a divide-by-zero.
> >>>      >
> >>>      > Validate nc and fc immediately after extraction, returning -1 =
if
> >>>      > either is zero.
> >>>      >
> >>>      > Fixes: 475901aff158 ("MD RAID10: Improve redundancy for 'far'
> >>>      and 'offset' algorithms (part 1)")
> >>>      > Reported-by: Yuhao Jiang<danisjiang@gmail.com>
> >>>
> >>>      So again I can't find a report, and Reported-by usually should b=
e
> >>>      followed
> >>>      by a Closes link to the original report.
> >>>
> >>>      Applied with Reported-by tag removed.
> >>>
> >>>      > Cc:stable@vger.kernel.org <mailto:Cc%3Astable@vger.kernel.org>
> >>>      > Signed-off-by: Junrui Luo<moonafterrain@outlook.com>
> >>>      > ---
> >>>      >   drivers/md/raid10.c | 2 ++
> >>>      >   1 file changed, 2 insertions(+)
> >>>
> >>>      --
> >>>      Thansk,
> >>>      Kuai
> >>>
> >>>
> >>>
> >>> --
> >>> Yuhao Jiang
> >> --
> >> Thansk,
> >> Kuai
> >
> >
> --
> Thansk,
> Kuai



--=20
Yuhao Jiang
