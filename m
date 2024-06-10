Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 066C84D8B6;
	Mon, 10 Jun 2024 20:52:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718052779; cv=none; b=qmsBw1pTAH612Oc480vD8SWzf5X6+gvMPDG4Bxvvd1VoW13SWNIp/5NLGTU2b131EgWASQTUF/fMxcTWSnlMxAP1G6QGo3+9SecxRizJTLO8dNJ4Yd0Sa3T6vKRJTPbpuHoFk2ICDHNNOTuTz+8CNraAil9S8MaCQSbNFpyPLdc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718052779; c=relaxed/simple;
	bh=7l5yLkxz8BSgeKvH9nDET9QOXi/H2lDfBJ/EnmhvCzE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=lzk/iwMwD+7NsVwY7pLCKffX0ZnmSvuhs2eY2KT7rQhMAe7K28ZmUd12ymVKNXT+eqxYQqhwuwO3vyCBcNzvsIEaI8ACW9YSaY/9tpU1qUO+Ee83IrOTn3z2OUVnN1f3zxfyQg3LhvIzjzL47kWzAELn6vFIfL7qBfiqp8gdyk4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XRBzSEIe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XRBzSEIe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7035EC4AF48;
	Mon, 10 Jun 2024 20:52:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718052778;
	bh=7l5yLkxz8BSgeKvH9nDET9QOXi/H2lDfBJ/EnmhvCzE=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=XRBzSEIeY0ZmEfe0I4hEBa4Dh2j0TK3l0xriXHJOAdYuiefZIid2KAJMkDXLGMMAY
	 5h88SYeH3TApLbjfMSNtkvlrLokAVkPgngoi9iRtPcVg7QeJTo44NtuRH328gSLdsG
	 OlQHwfyKiEJfsebjSHF83+LKZdb5Viz3IO5jGCs//C5/E+WDR40IIjEBLN93Hu+YJf
	 hnySrBv0XzaHDMXOGnqGWMH/LIemTgc4nwzg5m2KYnj8HQhp+FjEcpyKXreX85cVqa
	 00MZbd0PntRkIgUlYrxY3RJfGKmJwwBlKJCLhqkIqFyhNx8fYIXoEJqquyIBzrG/6K
	 soYtJ5v5ciyjQ==
Received: by mail-lj1-f170.google.com with SMTP id 38308e7fff4ca-2eae2d4daf0so2846711fa.2;
        Mon, 10 Jun 2024 13:52:58 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCUwUEAOjJr3xzIU9rUb4VmkRa7uZdLzojvjzBGzNXdBaRR6xxMoQ8SSoYzFQrFfdyt1lAqvguGydktDTTp0TtmjY77FeYcZ2k8IZGfm0xOBR+5Z0sk+ZJTZ+lIRCM35RresUNAtbwGNrQ==
X-Gm-Message-State: AOJu0YxRqJt/in78k65Yp5lZOcnePP7YoKK0HnBDxkXiin7j/kRQTHwP
	J3uXU3WK5LZ+IBtZS3ABzz+34BvrIqsYDUhn/MlUJEizsPYT8VymH1wwld1MAlzo81d97WGMYEa
	HtU2Hijoy4XSmH/RKY97jgQsnsFs=
X-Google-Smtp-Source: AGHT+IF+Zrxwmuo76ESmzqFvmwfhI24X1pF1nj2XAnVbiD6douQSG4Z/YuD3VpaG788P900SP8U0tUKdpziXMkdEz5w=
X-Received: by 2002:a2e:780b:0:b0:2ea:e9f9:6ac2 with SMTP id
 38308e7fff4ca-2eae9f96be4mr60071641fa.8.1718052776684; Mon, 10 Jun 2024
 13:52:56 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240525185257.3896201-1-linan666@huaweicloud.com>
In-Reply-To: <20240525185257.3896201-1-linan666@huaweicloud.com>
From: Song Liu <song@kernel.org>
Date: Mon, 10 Jun 2024 13:52:44 -0700
X-Gmail-Original-Message-ID: <CAPhsuW7csG=nHVe725NL7Q1N5cGtu+AD-S+KWO2hRmUJZ+69Tw@mail.gmail.com>
Message-ID: <CAPhsuW7csG=nHVe725NL7Q1N5cGtu+AD-S+KWO2hRmUJZ+69Tw@mail.gmail.com>
Subject: Re: [PATCH 0/2] md: flush deadlock bugfix
To: linan666@huaweicloud.com
Cc: yukuai3@huawei.com, linux-raid@vger.kernel.org, 
	linux-kernel@vger.kernel.org, yi.zhang@huawei.com, houtao1@huawei.com, 
	yangerkun@huawei.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, May 25, 2024 at 4:00=E2=80=AFAM <linan666@huaweicloud.com> wrote:
>
> From: Li Nan <linan122@huawei.com>
>
> I recently identified a flush deadlock issue, which can be resolved
> by this patch set. After testing for a day in an environment where the
> problem can be easily reproduced, I did not encounter the issue again.
>
> Before a complete overwrite of the md flush, first fix the issue with
> this patch set.
>
> Li Nan (2):
>   md: change the return value type of md_write_start to void
>   md: fix deadlock between mddev_suspend and flush bio

Applied the set to md-6.11. Thanks!

Song
