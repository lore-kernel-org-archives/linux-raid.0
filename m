Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA6E11A01B8;
	Thu,  4 Jul 2024 07:08:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720076884; cv=none; b=R+JlhXxU+xAlAlD3Q3gVw0710JB9UPTghL/JgkdjA3XOXUKQSnY6FoVChB5qazKVpZaHtY+cu5V1bFwIKfnZOfdqvmPVdvuCPDofX9fbqewEdGCi4/nKUX9tQcWmKmLnPHllkJx+NDRZr4hmkosUxmASFNX9wau5Cz5MIDVnN+A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720076884; c=relaxed/simple;
	bh=beE8qyS6id19OTmayM3RapJclxp80MYplB370wW4Z2M=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ZxgL5HnN8piQTQvNgVr+ETm5kN5m5kzNVIS60xV++4DaQIjwjwXAjma8fTiMnB015bzr/h9L6UOSajPwpJqy313gp8HvkCqkoEsqbs4xYweZJTn50caS1C6rSXHEnXHFkmQTC6cbUJK5N1zpQSwu399y+Uz61qxbD2836TGZFUc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FcvvSj8j; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FcvvSj8j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90E6CC3277B;
	Thu,  4 Jul 2024 07:08:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1720076883;
	bh=beE8qyS6id19OTmayM3RapJclxp80MYplB370wW4Z2M=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=FcvvSj8j/h5g8AZHZeMnJs89FLtc/qBGttkwFQVIMfGKpgNvI6zrj67QFpgZ5XJN6
	 XElwNLBPznxK/EaPLMFhJOQSdjJr085xoT8xe7YZaZu0QUPR4AShFOA0/QjFxTG8bS
	 ebri7yz7FZ7VsdpeNsGZ3cXQwCAQoOeKOXyflcQ6oakKYqIMg8nS/Ht3QJptvJzdaI
	 Hgk7hcj4N/KCQk/nfWxkcdMNNcnjctofot79cZG6vuwv9/LpITxmv0xQGXG2wqA0/h
	 f/yP6n2j/+/fL3d787wIun9SOBqizZDHBuGUKBGW9OGlv9tQXKmyjonrd5c0rYE3at
	 1zlZcGDfRn0Zw==
Received: by mail-lf1-f50.google.com with SMTP id 2adb3069b0e04-52ea1a69624so140975e87.1;
        Thu, 04 Jul 2024 00:08:03 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCWDG6ya3ogSSPlZIhf3wB/hT50Nm5u16yzdLs1irzkc7Dug9hAKbIxijp3pLfqwqCLy2oO0TnnDee4L8rGVhYD1gZ3Ie6ioi6RZeryT0eSsXQ5mAwBVvHlWPUVZef95RsiM1ixuixE9owQk2qz0hzKJDt6A7L35YCnX7me6H2nC7bnTQiTZFAla1Q==
X-Gm-Message-State: AOJu0YzN+V4nvcFn+n+Ple2csh5F4w2FEwx1pea3pWNq6BUYifOIll0X
	U+otI+c2MNA1ifOPBvtq+302RU1QG8pxQbujH1DOszBjcELa4WsrIlTNBAfkmXr3NFryOHtPmSQ
	bDFkblugVjjk4ixPwfJqy0o5/Fxs=
X-Google-Smtp-Source: AGHT+IGh6+P+1EiIoM58zfZVkEca2e7u3b68XGi1cyEf6GxHfJUbwvlYuhpttGC7c4v/TpT1nlDVYxqDa+2eLeP0N4M=
X-Received: by 2002:a05:6512:3aa:b0:52c:8fd7:2252 with SMTP id
 2adb3069b0e04-52ea061f61emr424036e87.11.1720076881971; Thu, 04 Jul 2024
 00:08:01 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <3727f3ce9693cae4e62ae6778ea13971df805479.1719173852.git.christophe.jaillet@wanadoo.fr>
In-Reply-To: <3727f3ce9693cae4e62ae6778ea13971df805479.1719173852.git.christophe.jaillet@wanadoo.fr>
From: Song Liu <song@kernel.org>
Date: Thu, 4 Jul 2024 15:07:49 +0800
X-Gmail-Original-Message-ID: <CAPhsuW5=sZTm2Uwmz7dZ-4v2vqPbS=RygDeZ535ef7yk4NCjsg@mail.gmail.com>
Message-ID: <CAPhsuW5=sZTm2Uwmz7dZ-4v2vqPbS=RygDeZ535ef7yk4NCjsg@mail.gmail.com>
Subject: Re: [PATCH] md-cluster: Constify struct md_cluster_operations
To: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc: Yu Kuai <yukuai3@huawei.com>, linux-kernel@vger.kernel.org, 
	kernel-janitors@vger.kernel.org, linux-raid@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jun 24, 2024 at 4:18=E2=80=AFAM Christophe JAILLET
<christophe.jaillet@wanadoo.fr> wrote:
>
> 'struct md_cluster_operations' is not modified in this driver.
>
> Constifying this structure moves some data to a read-only section, so
> increase overall security.
>
> On a x86_64, with allmodconfig, as an example:
> Before:
> =3D=3D=3D=3D=3D=3D
>    text    data     bss     dec     hex filename
>   51941    1442      80   53463    d0d7 drivers/md/md-cluster.o
>
> After:
> =3D=3D=3D=3D=3D
>    text    data     bss     dec     hex filename
>   52133    1246      80   53459    d0d3 drivers/md/md-cluster.o
>
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

Applied to md-6.11. Thanks!

Song
