Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEDF4389
	for <linux-raid@vger.kernel.org>; Wed, 10 Jan 2024 00:22:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gZWQBgHI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F626C433F1
	for <linux-raid@vger.kernel.org>; Wed, 10 Jan 2024 00:22:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704846150;
	bh=2sD696vSkacGJqsA8CgzAmALGezMD/I/rEyP9fkpjmI=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=gZWQBgHIkYihJdufjKGnGrOV+ehR3KdNKUnv7x8FN5jHZIUayeh8Zd84IWnvH858v
	 XS2x0A4WBJ29zzd98taztkZvgyaZxwv55JYy1mDFGPEa5GWFCz8vxltq5chLtLdNNy
	 uj82JSfmvnIx9o5oYr8Q7/K+oXu1x79CkW8xIFumy7OaBWGBLPZWvfMhk699tf4yS3
	 kq6ehy3BpoGokvn1u2B6LpmKMQt+Vuoz3uS6EP9yJOhC2N6XxYP7UYUA8+QfOXgcEi
	 NOoAuef6cg2xnZrQEjbcs1VDQWbkztnvzQNnGiWM5o2rTLfUPzYsPC+x3vz7JhydIT
	 BX00teVBpKRFw==
Received: by mail-lf1-f41.google.com with SMTP id 2adb3069b0e04-50eabbc3dccso3775534e87.2
        for <linux-raid@vger.kernel.org>; Tue, 09 Jan 2024 16:22:30 -0800 (PST)
X-Gm-Message-State: AOJu0Yy2TTeRx6s4M1R71n/Aqzm5TvFYfUf/cRVR9L56gcSkkCb0OqiP
	EdnVZyNU74o4guoNdB75urWncW4+d2lh2Q9Nbtc=
X-Google-Smtp-Source: AGHT+IGMPgaRHkDtbx0p7zLuRQfe8RMcYmDzN3+wRoT/bDdGJyUFSFyxTtrK+UhyvwuKSavH1nY0wmcbtBnePR8YX/s=
X-Received: by 2002:ac2:4d18:0:b0:50e:9570:b357 with SMTP id
 r24-20020ac24d18000000b0050e9570b357mr24646lfi.160.1704846148365; Tue, 09 Jan
 2024 16:22:28 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240108001223.23835-1-bvanassche@acm.org>
In-Reply-To: <20240108001223.23835-1-bvanassche@acm.org>
From: Song Liu <song@kernel.org>
Date: Tue, 9 Jan 2024 16:22:16 -0800
X-Gmail-Original-Message-ID: <CAPhsuW50XjawM31mhcDOUu+b54-ZzEvH0s_J9nzwC0f_1OLDhA@mail.gmail.com>
Message-ID: <CAPhsuW50XjawM31mhcDOUu+b54-ZzEvH0s_J9nzwC0f_1OLDhA@mail.gmail.com>
Subject: Re: [PATCH] md/raid1: Use blk_opf_t for read and write operations
To: Bart Van Assche <bvanassche@acm.org>
Cc: linux-raid@vger.kernel.org, Jens Axboe <axboe@kernel.dk>, 
	kernel test robot <lkp@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Jan 7, 2024 at 4:12=E2=80=AFPM Bart Van Assche <bvanassche@acm.org>=
 wrote:
>
> Use the type blk_opf_t for read and write operations instead of int. This
> patch does not affect the generated code but fixes the following sparse
> warning:
>
> drivers/md/raid1.c:1993:60: sparse: sparse: incorrect type in argument 5 =
(different base types)
>      expected restricted blk_opf_t [usertype] opf
>      got int rw
>
> Cc: Song Liu <song@kernel.org>
> Cc: Jens Axboe <axboe@kernel.dk>
> Fixes: 3c5e514db58f ("md/raid1: Use the new blk_opf_t type")
> Reported-by: kernel test robot <lkp@intel.com>
> Closes: https://lore.kernel.org/oe-kbuild-all/202401080657.UjFnvQgX-lkp@i=
ntel.com/
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>

Applied to md-6.8.

Thanks,
Song
