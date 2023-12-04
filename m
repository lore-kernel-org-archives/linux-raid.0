Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 653E515A4
	for <linux-raid@vger.kernel.org>; Mon,  4 Dec 2023 01:56:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iX1VuX09"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCDA1C433C9
	for <linux-raid@vger.kernel.org>; Mon,  4 Dec 2023 01:56:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1701654986;
	bh=tKFv07EM4AuF3Ym3N/y3nEtlRtiV1d7ZdPSVZqcp25M=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=iX1VuX091zLvOJ0JZ/XdnuVwwMn+cBQxy49zJm2aQneGV4rR0eUGGdj0/nqF9dOF3
	 Bl4jjnG8U6r/0x2hk9QXIfa6Rs8/kMvAq6opbGSDcDQNAy7vqFQllVCrlbygzivoTL
	 xJkFTTl1mUWkLrMxF7JoWPjxXgiENi9ntHKSrlziuDY3fi8bLdqPrwOb47EstelzF6
	 te86LtCWu53379FCPx4KMe6pR8feKkicLjUNdf7c6QqfqrsX4qBlq8I7UJSFQAokBu
	 2ilswawF8Li4kdsH5rG+CH02CscQS1Mbg2K/sVX/4VMNR0M0DrO0BE6omtoIwuVPFU
	 FrCC5UPEH1cNQ==
Received: by mail-lj1-f169.google.com with SMTP id 38308e7fff4ca-2c9c18e7990so52721611fa.2
        for <linux-raid@vger.kernel.org>; Sun, 03 Dec 2023 17:56:26 -0800 (PST)
X-Gm-Message-State: AOJu0YxufqLWq0YrZRrkSXmY0z9FwD1X+ttq6+U4Frf+9FrxK+NqFF+Q
	6RO1XUYwj811vEkyUDx6UrCRAavuphATPIeLl6M=
X-Google-Smtp-Source: AGHT+IEyEjKqeUWgQihFoe9yw8LGSUHthUftsirT5Qbl5snKaCdNaYu4PIqQy0C0sPxm3y7NoPFqkG7bjAsTPAQOAAQ=
X-Received: by 2002:a2e:9f42:0:b0:2c9:fb7a:a25d with SMTP id
 v2-20020a2e9f42000000b002c9fb7aa25dmr619000ljk.44.1701654985086; Sun, 03 Dec
 2023 17:56:25 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAGRgLy5E3cb=MS8eSMH03fa27tgFnZp0hwrrobyQMuUU_Axiag@mail.gmail.com>
 <CAPhsuW4z7U-Aq=YemQjFKtcaB7k9x+T_=zM8oBkR3aK2fRzo=A@mail.gmail.com>
 <CAGRgLy6KH9WfqHzN2OkFg5tb49Y=wKnBqQCdWifoFV13aD17Dg@mail.gmail.com>
 <CAPhsuW6AT5_=d9ibfwBedsd-aVrdM1tfBnJpYD=hoiOeKMCpAw@mail.gmail.com>
 <CAGRgLy6H0q+VEGBeG5bqs-=826cZyGZYVq9_7ZG453n+XXJBcQ@mail.gmail.com>
 <CAPhsuW64xuwxJzbz+KHbot1_gJyM2bSMmT8R+HQwhhCpc0WC5g@mail.gmail.com> <CAGRgLy7KGmX4zG_9CZ8NrFp4RKoN6CwFNTCKo8E+5iff790m8Q@mail.gmail.com>
In-Reply-To: <CAGRgLy7KGmX4zG_9CZ8NrFp4RKoN6CwFNTCKo8E+5iff790m8Q@mail.gmail.com>
From: Song Liu <song@kernel.org>
Date: Sun, 3 Dec 2023 17:56:13 -0800
X-Gmail-Original-Message-ID: <CAPhsuW5+qa6OThetkmtJpVFcpqCB30rb04GxDj+sTRY=MCeCRg@mail.gmail.com>
Message-ID: <CAPhsuW5+qa6OThetkmtJpVFcpqCB30rb04GxDj+sTRY=MCeCRg@mail.gmail.com>
Subject: Re: raid6 corruption after assembling with event counter difference
 of 1
To: Alexander Lyakas <alex.bolshoy@gmail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Alexander,

On Sun, Dec 3, 2023 at 4:16=E2=80=AFAM Alexander Lyakas <alex.bolshoy@gmail=
.com> wrote:
>
> Hi Song,
>
> Thank you for your comments. I will address them. How do you want to
> proceed? Do you want me to send a formal patch to the list (with
> proper formatting this time)? As mentioned, I am not able to test this
> fix on one of the latest kernels, but only on 4.14.99.

Yes, please proceed with a formal patch. If you are not able to test it on
latest kernel, please explain what tests are done.

Thanks,
Song
