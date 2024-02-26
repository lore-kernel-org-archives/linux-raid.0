Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 827A0131727
	for <linux-raid@vger.kernel.org>; Mon, 26 Feb 2024 21:44:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708983849; cv=none; b=ipxAqsmAzoS+X26NBQp224eV2uOXIDBu83EO1dSNm/qbdeiX4CoUF8xdZoeUH/ZlQg10zfiMurwG+FgRVOD7tLFa/zgY5mnDORIiUOGQ2eXGKAPXxYnlF7i1oI+lpgoPAJveNOz3Uam8vRX6YuRkL42ShzlrEczOKTMbsHNEoj8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708983849; c=relaxed/simple;
	bh=zpJBjtfhoTKgEjpGijNErIsEtkTpdJfMp2mLvcaKJVI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=r7aimyYK4b1tp2y6ssTj/ah5dUHapafJB2apwN6D0Tf5SjEEDpg5ULMzXgjx85gxbHRpc7gJm6/jALyGIeHkRP0XbOKgmICMEglAc+Gfd2f0QYH+aDTay7bq13GXDQpqShZjsbpSGPb1LrrsyuH16vHAb6NahcAzyIe1OkHlAks=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=C+WWpTPb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="C+WWpTPb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B4A7C433F1
	for <linux-raid@vger.kernel.org>; Mon, 26 Feb 2024 21:44:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1708983848;
	bh=zpJBjtfhoTKgEjpGijNErIsEtkTpdJfMp2mLvcaKJVI=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=C+WWpTPbL0KTWHnSUz7J0w6R+3RaWt4699B/qL3fgi8KS0piCgd+KaV5CuGHfnT+Q
	 TdNz4FjRjNbJFDKeaVaJDEMrvhLPoIKif8v8kjFlFT6iJHMGvCVczxo8bVu7K24jBc
	 GKleaujsQ0+XoC+1EAHgUSUmdZunAr6Ir6lGzZGRrYWbjlPC9DD8VTohIHnbDw/dUp
	 X1R86prG/wCPc/LqEWlB8s2xEG2xWHtEs/iAipms5Kjk3FtEEnO3OFP8Mkt8w4fu94
	 zntr/30CwMVXnt0iCS2MzQvVHZGhouuvHc79A1A02ZX2Qt0MNqSMHiu2ESoHOu2avo
	 Id8D3fbsQV04A==
Received: by mail-lj1-f178.google.com with SMTP id 38308e7fff4ca-2d26227d508so40169951fa.2
        for <linux-raid@vger.kernel.org>; Mon, 26 Feb 2024 13:44:07 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCXne6tNvTI+pEpTKTDTnNQq0QRcCG0PYRRuK+2qhIMSj44NetB+ruGnk62XJNxwUa7dEbcc3ve///1cZCFzw4T9rYdnZzSruDsK+w==
X-Gm-Message-State: AOJu0YzrguQqMGsbNPbSJNhhrz5zXVyKqgnGH/obFHLmfHszFsjmgOhA
	dVSh751vK0I1zCfdKnQyHbEbmQ3wb6nznb8OeMAL0PwG1WgkGLsYngFLELUnwM6Plz/cKi6/Mly
	vzXH6ZRMo46rzl90O7sOocmh0VwI=
X-Google-Smtp-Source: AGHT+IF+paRABOu8/jJ40b/HDuMSNBZZFMJjf9VAz413+Wa8NNC/ZeJUn+3Rs4f37kH0O5BEtgJDOP1wremfvnimMyo=
X-Received: by 2002:ac2:4563:0:b0:513:43e:9aeb with SMTP id
 k3-20020ac24563000000b00513043e9aebmr128716lfm.15.1708983846270; Mon, 26 Feb
 2024 13:44:06 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240223121128.28985-1-heming.zhao@suse.com>
In-Reply-To: <20240223121128.28985-1-heming.zhao@suse.com>
From: Song Liu <song@kernel.org>
Date: Mon, 26 Feb 2024 13:43:54 -0800
X-Gmail-Original-Message-ID: <CAPhsuW5OhnzahJE3eiEsU3SEtARYoTux1tDQh1qcfu1EeSKRJA@mail.gmail.com>
Message-ID: <CAPhsuW5OhnzahJE3eiEsU3SEtARYoTux1tDQh1qcfu1EeSKRJA@mail.gmail.com>
Subject: Re: [PATCH] md/md-bitmap: fix incorrect usage for sb_index
To: Heming Zhao <heming.zhao@suse.com>
Cc: guoqing.jiang@linux.dev, hch@lst.de, linux-raid@vger.kernel.org, 
	colyli@suse.de, hare@suse.de
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Feb 23, 2024 at 4:11=E2=80=AFAM Heming Zhao <heming.zhao@suse.com> =
wrote:
>
> Commit d7038f951828 ("md-bitmap: don't use ->index for pages backing the
> bitmap file") removed page->index from bitmap code, but left wrong code
> logic for clustered-md. current code never set slot offset for cluster
> nodes, will sometimes cause crash in clustered env.
>
> Call trace (partly):
>  md_bitmap_file_set_bit+0x110/0x1d8 [md_mod]
>  md_bitmap_startwrite+0x13c/0x240 [md_mod]
>  raid1_make_request+0x6b0/0x1c08 [raid1]
>  md_handle_request+0x1dc/0x368 [md_mod]
>  md_submit_bio+0x80/0xf8 [md_mod]
>  __submit_bio+0x178/0x300
>  submit_bio_noacct_nocheck+0x11c/0x338
>  submit_bio_noacct+0x134/0x614
>  submit_bio+0x28/0xdc
>  submit_bh_wbc+0x130/0x1cc
>  submit_bh+0x1c/0x28
>
> Fixes: d7038f951828 ("md-bitmap: don't use ->index for pages backing the =
bitmap file")
> Signed-off-by: Heming Zhao <heming.zhao@suse.com>

Applied to md-6.9 branch.

Thanks,
Song
