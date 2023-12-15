Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBA5418ECD
	for <linux-raid@vger.kernel.org>; Fri, 15 Dec 2023 23:30:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mRmd7gye"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42252C433C8
	for <linux-raid@vger.kernel.org>; Fri, 15 Dec 2023 23:30:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1702683024;
	bh=QeVfjK/QwUqDJW4CHMTfA0w2mXg4so8Dlgx5Hcqz9gg=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=mRmd7gye8lbhpNHxPArxFg+ZB/GhouHvKE+Tcy/i5e+7njmsh6AOS50qDPEYeybXL
	 V5D7Rp1d/u/O4JXDWsZzW5UAOskBDpMHR6oJjQgj0pI9zE8hEiieixUelpB+DRZ2s+
	 T2VRwlv8MkPv3w1auw1tRbDe9+YibFLGBT9eHC+VBwZ9q+D1P/GRpcMZO9ghlhIAga
	 3zyxQq1Wwa33V5sZ2vIqcuBaWvWkQUrRhndXy615t8M5Q4nxD4LQF1pXq/oIqZPyl6
	 0HMpjpmt2PfoLmrbG0r4FJ/ooqi9FWXNlmeXoOWhVNz4Egjuv32M3sKTdVZKxP9Awg
	 5XYxVcxD7sGaw==
Received: by mail-lf1-f45.google.com with SMTP id 2adb3069b0e04-50e0d1f9fe6so1443199e87.1
        for <linux-raid@vger.kernel.org>; Fri, 15 Dec 2023 15:30:24 -0800 (PST)
X-Gm-Message-State: AOJu0YxAx7ofDvGF/AXlm1WRzQfVP2AmwwTx68t+FFenv1pfFwoT9JCT
	L0MtVs2J0bbjBwIb+lGOyqSvveOGTFo/gEvEK/E=
X-Google-Smtp-Source: AGHT+IHBPJaejZoDBeNbRfiSrLAL1xoyvtXu7GvdI+xBdRcLFizYOxlCxalNgSvZ0icqu3Lq/vN/611sR/B5cOIvGq8=
X-Received: by 2002:a05:6512:3604:b0:50d:2f84:759c with SMTP id
 f4-20020a056512360400b0050d2f84759cmr3980554lfs.103.1702683022518; Fri, 15
 Dec 2023 15:30:22 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <1702470271-16073-1-git-send-email-alex.lyakas@zadara.com>
In-Reply-To: <1702470271-16073-1-git-send-email-alex.lyakas@zadara.com>
From: Song Liu <song@kernel.org>
Date: Fri, 15 Dec 2023 15:30:11 -0800
X-Gmail-Original-Message-ID: <CAPhsuW4C9qzDSoPjNWSK70y0jGcFU6h+LXGvXyyNmQNLmmqbHQ@mail.gmail.com>
Message-ID: <CAPhsuW4C9qzDSoPjNWSK70y0jGcFU6h+LXGvXyyNmQNLmmqbHQ@mail.gmail.com>
Subject: Re: [PATCH v2] md: upon assembling the array, consult the superblock
 of the freshest device
To: Alex Lyakas <alex.lyakas@zadara.com>
Cc: linux-raid@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Dec 13, 2023 at 4:31=E2=80=AFAM Alex Lyakas <alex.lyakas@zadara.com=
> wrote:
>
> Upon assembling the array, both kernel and mdadm allow the devices to hav=
e event
> counter difference of 1, and still consider them as up-to-date.
> However, a device whose event count is behind by 1, may in fact not be up=
-to-date,
> and array resync with such a device may cause data corruption.
> To avoid this, consult the superblock of the freshest device about the st=
atus
> of a device, whose event counter is behind by 1.
>
> Signed-off-by: Alex Lyakas <alex.lyakas@zadara.com>

Applied to md-next with some minor changes (format, commit log). Thanks!

Song
