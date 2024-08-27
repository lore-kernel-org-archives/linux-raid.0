Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30F6F1C27;
	Tue, 27 Aug 2024 16:58:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724777916; cv=none; b=B5y2vQMtQIJlaCVE5A1XmLyHmL3ArFdVcNuoRRmfy9FLRVqjm5sE4bYA5H0fBcKv7e+ioRGRf610QB+Xk6bAo9cps3clsA9qJPTlAEHXgXlS8zsH6hbtg5hmQ4NX9FbUUEYXQKS/gfvpjINtOWbdFCdfreFOJKC40uV4U6lS/pc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724777916; c=relaxed/simple;
	bh=mUkKYolWoShCFsup0Sx6H4a0XGyESfLcmYxW4bjAv98=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=nvyLswHexVKqCbSWk8U0gvffWfnLBAYnc/D/LmgECdIM1Mf72E58akPYBsqrodcTcDk8Dtc5F2UvJSKKsHK+9wPQc/n2oB9h1HUoO7hiEFg2WmYmiMDqxOY0A4S2dNlgrNmra/Xx6fnTBycmVS7bYePBB+fgpqknAg/kfnmw9fI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Oa1Mz8WM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Oa1Mz8WM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B723AC4DE1F;
	Tue, 27 Aug 2024 16:58:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724777915;
	bh=mUkKYolWoShCFsup0Sx6H4a0XGyESfLcmYxW4bjAv98=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=Oa1Mz8WMDrpW46JRRxDDY3jNaFqvgYjw1SD27kwqr5279CaMexnfsSKaQBm72Y+aa
	 WZ1WStOu9S9ewhpkX+riDYwH0sW15vZTxRma6c2VliYMGyFBrhAnk5pgo3Br9H+fxd
	 mSavzZplBB+k4MAjrxH1519iNQXnR8rxSIxM0TlCAC4qsu+ZFYOdpCeFTJbdQFdUpv
	 3v71UT2SMNpAy25Rz09iTPpyNdZapU1EIk5BwJyt8TLVpfnQ3snCfHmJ9oUtUmGjVE
	 OgwY7cJuQaO50UUz2AqfPnTOWgVCujwuxRX1nOGArNrYloTq9WkiMbPMiCLSjwGdke
	 9x/e0gIVcIkxQ==
Received: by mail-il1-f172.google.com with SMTP id e9e14a558f8ab-39e6a32ae15so1418495ab.3;
        Tue, 27 Aug 2024 09:58:35 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCWQjxn6GJVHwEfQ/svZVtAAnCaH/BENZaUyKrj9rgqZSf7SA//AmN4u6BQzNB67G1tT9M3jiobgZROvZNk=@vger.kernel.org, AJvYcCXbmzgsTGd7vVxVses2yq491wjncP6OV9VzBS0bMbyDlf7PoETusPsaWGyEX5LDqw/g8tnD1jYZfOF26Q==@vger.kernel.org
X-Gm-Message-State: AOJu0YzxKXIz/aN6chQmlF5yXq6B+xZUkYgy+FzybKe6dOVh/tV7J0gl
	lN/rspfX6Wz1OWdChNR60ZeI7IsdBLpptiCBdZay/LNpx0IZP6uCsaqqPcJ/bYmZuzvjePJ6J07
	HYx3/b4W07PsVXHH4E85mAt72dD0=
X-Google-Smtp-Source: AGHT+IEJ7VpB3TpWweXvG08b3VBVVkkA+gu8oNrQWm2dFEpKIcm93UGS0soGHVXfHSs86VAx97evcqfQCM43gUxB+9I=
X-Received: by 2002:a05:6e02:1a4e:b0:396:e8b8:88d with SMTP id
 e9e14a558f8ab-39e3c985fc4mr131107015ab.11.1724777915151; Tue, 27 Aug 2024
 09:58:35 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240801124746.242558-1-yukuai1@huaweicloud.com>
In-Reply-To: <20240801124746.242558-1-yukuai1@huaweicloud.com>
From: Song Liu <song@kernel.org>
Date: Tue, 27 Aug 2024 09:58:23 -0700
X-Gmail-Original-Message-ID: <CAPhsuW4zXj_8p3Kwh7oJt2oHc4u1bEbgbrzPXiNuod+AGW58gA@mail.gmail.com>
Message-ID: <CAPhsuW4zXj_8p3Kwh7oJt2oHc4u1bEbgbrzPXiNuod+AGW58gA@mail.gmail.com>
Subject: Re: [PATCH -next] md: don't flush sync_work in md_write_start()
To: Yu Kuai <yukuai1@huaweicloud.com>
Cc: yukuai3@huawei.com, linux-raid@vger.kernel.org, 
	linux-kernel@vger.kernel.org, yi.zhang@huawei.com, yangerkun@huawei.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Aug 1, 2024 at 5:51=E2=80=AFAM Yu Kuai <yukuai1@huaweicloud.com> wr=
ote:
>
> From: Yu Kuai <yukuai3@huawei.com>
>
> Because flush sync_work may trigger mddev_suspend() if there are spares,
> and this should never be done in IO path because mddev_suspend() is used
> to wait for IO.
>
> This problem is found by code review.
>
> Fixes: bc08041b32ab ("md: suspend array in md_start_sync() if array need =
reconfiguration")
> Signed-off-by: Yu Kuai <yukuai3@huawei.com>

Applied to md-6.12. Thanks!

Song
