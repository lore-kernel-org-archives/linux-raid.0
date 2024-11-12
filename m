Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 237C31531C4
	for <linux-raid@vger.kernel.org>; Tue, 12 Nov 2024 23:05:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731452755; cv=none; b=cxwnNGWgS356ERf5YgywX/0eatBqB0XGnnUeSlfKzWJFhnIInCbF6I8AqkcTiCPTB4o5p6FEN4n7rd0wbBZp58AzQtCSaQx6mtuI3WSZ6goRRt0brszS3GRKLCnHocgPd44LhSLFxTi2YlbPoHBGnSVJzumwFWIF83xTLY0fofQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731452755; c=relaxed/simple;
	bh=xxScMEmiqGMlbqjW/PTh4ug8ZCqC1bbPhiLmx9z3QMs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=NmO9u+8UkLWc9n59slf6los1IH7BDdyOdLJQrfFxDmkqvswKr+GMMvx8QOX+rSdua7AcQrWayFzn+Nz+cYuF5ex4fF4xw7UZi3WERhLuyhNDew8ZHlMxNscULf4s2CJYEddh/r5T17uM4nLrR6VPRw+CbXrQllILH4Jk/Bwy9oQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YK7mM+b+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YK7mM+b+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B68CEC4CED5
	for <linux-raid@vger.kernel.org>; Tue, 12 Nov 2024 23:05:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1731452754;
	bh=xxScMEmiqGMlbqjW/PTh4ug8ZCqC1bbPhiLmx9z3QMs=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=YK7mM+b+9y0cUaYAl67SRmBObctJAfavMHC8/3hUSuVnw7/hmJH5d4zS1xD5SMR5b
	 bEZtv4k5AiDCZ4T3Re75aMDqRRStng5Pi3t53CaeGOGjBi3IlTQmHy+XWWVweggS3D
	 g31lYqScR1Sws9RgWCo31aaJ9OK78L9SMlLJLmMTzc4CZTNy11LGyFvQ9JyBjTro63
	 dHKHPblhX1pPRKHqZKc6jN8u4pEWal+79qhASUgMNVEWycOF+GumolOb6vyC8f50om
	 4b4YbPLDPGCTZ1RseJ6ECRfFvHAV0tctj67kyVPdlwXfg5X549700g1+tXqwes92zP
	 BafWrFPI38b/g==
Received: by mail-io1-f50.google.com with SMTP id ca18e2360f4ac-83abdaf8a26so237310139f.1
        for <linux-raid@vger.kernel.org>; Tue, 12 Nov 2024 15:05:54 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCU2LaKtFsfnBavdpY2bbc8lBKH7NyYP36ONBMtNhepLJUyWz8EIxPLS7cmIDVEFu/ctggTeTAkBR4L8@vger.kernel.org
X-Gm-Message-State: AOJu0Yw5V6nIBKXwu6bu9xKcT19U+TTRVon6A0ziqblkRAuu+HBJVob1
	ddpFQgLzJXcmw18n4YUjbUR5PlOCv+HA0+b7zWKu8sHfcTwEnkC0EEiQ+Ou70Wj0F+koEfnxnEl
	i8YyMiIaFp7c79B2EfqOm7RoDKrw=
X-Google-Smtp-Source: AGHT+IHWgsq7Ta5wXlhWIJDQ2zxOPG8QVWcZEzzJ80jUkEe+1kQbCPfVtCUy9Fzm1V87Z39J3ujXu1NQsJdSpBw5NMs=
X-Received: by 2002:a05:6e02:b2a:b0:3a6:ca22:7b3c with SMTP id
 e9e14a558f8ab-3a6f19c1ccfmr184981385ab.12.1731452754008; Tue, 12 Nov 2024
 15:05:54 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241112161019.4154616-1-john.g.garry@oracle.com>
 <20241112161019.4154616-2-john.g.garry@oracle.com> <CAPhsuW4JstsuyDnXfWuDocr+uVfq72SnmF82f-6KBy2tu3-XOQ@mail.gmail.com>
 <fcb1399d-d28b-4e89-be9e-d260f05d6c8a@oracle.com>
In-Reply-To: <fcb1399d-d28b-4e89-be9e-d260f05d6c8a@oracle.com>
From: Song Liu <song@kernel.org>
Date: Tue, 12 Nov 2024 15:05:42 -0800
X-Gmail-Original-Message-ID: <CAPhsuW5DC3aP8p3gMWgS0H9eGBzfNwSWOJyNCBK9Syf5Ym2nJg@mail.gmail.com>
Message-ID: <CAPhsuW5DC3aP8p3gMWgS0H9eGBzfNwSWOJyNCBK9Syf5Ym2nJg@mail.gmail.com>
Subject: Re: [PATCH 1/2] md/raid5: Increase r5conf.cache_name size
To: John Garry <john.g.garry@oracle.com>
Cc: yukuai3@huawei.com, linux-raid@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 12, 2024 at 10:09=E2=80=AFAM John Garry <john.g.garry@oracle.co=
m> wrote:
>
> On 12/11/2024 17:42, Song Liu wrote:
> > On Tue, Nov 12, 2024 at 8:10=E2=80=AFAM John Garry<john.g.garry@oracle.=
com> wrote:
> >> For compiling with W=3D1, the following warning can be seen:
> >>
> >> drivers/md/raid5.c: In function =E2=80=98setup_conf=E2=80=99:
> >> drivers/md/raid5.c:2423:12: error: =E2=80=98%s=E2=80=99 directive outp=
ut may be truncated writing up to 31 bytes into a region of size between 16=
 and 26 [-Werror=3Dformat-truncation=3D]
> >>      "raid%d-%s", conf->level, mdname(conf->mddev));
> >>              ^~
> >> drivers/md/raid5.c:2422:3: note: =E2=80=98snprintf=E2=80=99 output bet=
ween 7 and 48 bytes into a destination of size 32
> > This is a bit confusing. Does this mean we actually need 48 bytes?
> > I played with it myself, and 38 bytes is indeed enough to silent the
> > warning. With 38 bytes, we have 4 bytes hole right behind
> > cache_name, so I am thinking we should just use 40.
> >
> > WDYT?
>
> Indeed it is confusing...
> So the string is "raid%d-%s", which is
> 4B for "raid"
> 10B for max int (right?)
> 1B for '-'
> 32B for DISK_NAME_LEN
> 1B for NUL
>
> which totals 48
>
> So I don't know why/how 38 is ok. Maybe there is some auto-padding going
> on, like you hint at.
>
> Maybe just using 48 is better.

Makes sense. I will update the patch to use 48, and apply it to md-6.13.

Thanks,
Song
