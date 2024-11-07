Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 837921EF923;
	Thu,  7 Nov 2024 23:41:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731022882; cv=none; b=CKLNrOlhNJ4h5xatW0c6ihK3lV9OgraGmVZqz5xtzVM7HbBgaPle+Su2h5dWJ0dqAiBIUGcb2aitJDS5AQpMKJiVLVJd1JmOOeWMgLDguDhMeViScqojJt9e9EH/dRMP1klseb8NNBBjFLwY4tMvBGOYbRiITdFH5/B2K3oBoLs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731022882; c=relaxed/simple;
	bh=la5qB4Z9o5yFsy+2aFB8FSNal6lIqegw1vceMMRCYqQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=qKMfm8S68gUKW9KEvHJjANhFO0U0VhHHrPta2txV8K/QQMmMvO4AWaPjxCeSXfI007ABbHWG0AmgrzdS7UfIT+L1aAhmS4SxmH5L91QKmoOhprPQAFn8Gui5xe5yaphXe6J9XwHUIiqhQOsfPyEC623SyJCy7RElw1mZ5DmSRuo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Xm/f/vck; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Xm/f/vck"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1737BC4CECC;
	Thu,  7 Nov 2024 23:41:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1731022882;
	bh=la5qB4Z9o5yFsy+2aFB8FSNal6lIqegw1vceMMRCYqQ=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=Xm/f/vckjhW8geC9YpmFHZ11FnRevKfzNFT4XuBQ4wwhgclUvtPwnQPqc64UVj6MJ
	 c0KrilEvA6QjLeb3SLtQoqet/B01eEfaO+pW8DcrETJ7z+qtrMzcD5pq/QaZycdv22
	 jDvhNcfV0JiWRL/9b8c7iwCXQqfnpgd5ONwF596MH8zsnsc0F4oMEwBnEizzThWi5R
	 lRPoPJyolwsrWirHpMrBOsPwiR4vkWccoZerR6hBw3aXWjHwSTsf+S6Ovx7L0/54Tg
	 ecwYtrizdi9MIHHFuDcqzx1qnohcBD18nMUA2wwOZalWpIL2qxzMQkDVCxHs0oXGSL
	 +qDDK/Ekx3aPw==
Received: by mail-il1-f176.google.com with SMTP id e9e14a558f8ab-3a3b7442db5so5895535ab.2;
        Thu, 07 Nov 2024 15:41:22 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCXAvBLBUFXbWnODWbmere/iu66b8tlnWpvgBeCuyb+uUKClG4FXrKiPaN5RnxN3UX1BiQY+et7Gq2qH0FM=@vger.kernel.org
X-Gm-Message-State: AOJu0YwnQW37YCzqF2k1cl50lWTk+A7fYS8PrdLSQdcZHRCxQzB5n7KR
	qJmQmNQL4rAonQE4ZtQiRB7K7h30dNMguFZmTeesT/vm0XYODzxo52phVoRSEcJCtqmUYJvLSwy
	QRXIVGK+jwhKmTPzDPtFtPyB56Y4=
X-Google-Smtp-Source: AGHT+IGF5WznfJR/sckqkGLNHsFUT2itHwacfzCaykTLIZeyuyHBx/7nNh52koubVgfLJAEczUVEfPvcHI3YIt6WFug=
X-Received: by 2002:a92:c26d:0:b0:3a5:e1f5:157c with SMTP id
 e9e14a558f8ab-3a6f1a21eadmr12079415ab.15.1731022881528; Thu, 07 Nov 2024
 15:41:21 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241107125911.311347-1-yukuai1@huaweicloud.com>
In-Reply-To: <20241107125911.311347-1-yukuai1@huaweicloud.com>
From: Song Liu <song@kernel.org>
Date: Thu, 7 Nov 2024 15:41:10 -0800
X-Gmail-Original-Message-ID: <CAPhsuW7Ry0iUs6X7P4jL5CX3+8EGfb5uL=g-q_8jVR-g19ummQ@mail.gmail.com>
Message-ID: <CAPhsuW7Ry0iUs6X7P4jL5CX3+8EGfb5uL=g-q_8jVR-g19ummQ@mail.gmail.com>
Subject: Re: [PATCH md-6.13] md: remove bitmap file support
To: Yu Kuai <yukuai1@huaweicloud.com>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, 
	yukuai3@huawei.com, yi.zhang@huawei.com, yangerkun@huawei.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 7, 2024 at 5:02=E2=80=AFAM Yu Kuai <yukuai1@huaweicloud.com> wr=
ote:
>
> From: Yu Kuai <yukuai3@huawei.com>
>
> The bitmap file has been marked as deprecated for more than a year now,
> let's remove it, and we don't need to care about this case in the new
> bitmap.
>
> Signed-off-by: Yu Kuai <yukuai3@huawei.com>

What happens when an old array with bitmap file boots into a kernel
without bitmap file support?

Thanks,
Song
