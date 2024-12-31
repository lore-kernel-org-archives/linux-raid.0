Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B658410F1;
	Tue, 31 Dec 2024 08:59:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735635589; cv=none; b=jtWaO68VG4mg/aNA/8auPpTeFFH5HSfkAnGtvovqsWzYM1fMnuW/4V92WOsv0PwOTJkDUi8qS74pClp1DVW6w03PB7+TG48gscWkoMkTjVUhV2nRpG+JnOIeCk1LKTpFYfsXgqTiItBJuxcz6hMkryiRfieLZf0h/s4GLFF4Bts=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735635589; c=relaxed/simple;
	bh=hYCNJnq/siNv0gtdOfXH38htKXoC2roSgjOTWIcCmBM=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=uhzZ+UETE+3H5onygE+15MqZKF5abE+VaYCYo2CSmxmLHKAsQv4bKxS/BWaUZMoI7PDNKAZofFVnliJtGKAgoHJ787Wq7fEvS9GXWoF3zkRwmp5YwTSVfEL5dAZH4irj1iBioZHrONf+WGy6Zfrib9O6eyzKiPWx/Ktnfgk9onU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: from mtkaczyk-private-dev (unknown [31.7.42.13])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPSA id 1C4B4C4CED6;
	Tue, 31 Dec 2024 08:59:46 +0000 (UTC)
Date: Tue, 31 Dec 2024 09:59:42 +0100
From: Mariusz Tkaczyk <mtkaczyk@kernel.org>
To: Yu Kuai <yukuai1@huaweicloud.com>
Cc: Tomas Mudrunka <tomas.mudrunka@gmail.com>, Song Liu <song@kernel.org>,
 linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, "yukuai (C)"
 <yukuai3@huawei.com>
Subject: Re: [PATCH] Export MDRAID bitmap on disk structure in UAPI header
 file
Message-ID: <20241231095942.446f4d4a@mtkaczyk-private-dev>
In-Reply-To: <ebbec264-7669-03fd-7ffd-3c728168cdd5@huaweicloud.com>
References: <20241231030929.246059-1-tomas.mudrunka@gmail.com>
	<ebbec264-7669-03fd-7ffd-3c728168cdd5@huaweicloud.com>
Organization: Linux development
X-Mailer: Claws Mail 4.0.0 (GTK+ 3.24.34; x86_64-suse-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Tue, 31 Dec 2024 11:47:23 +0800
Yu Kuai <yukuai1@huaweicloud.com> wrote:

> Hi,
>=20
> =E5=9C=A8 2024/12/31 11:09, Tomas Mudrunka =E5=86=99=E9=81=93:
> > When working on software that manages MD RAID disks from
> > userspace. Currently provided headers only contain MD superblock.
> > That is not enough to fully populate MD RAID metadata.
> > Therefore this patch adds bitmap superblock as well.
> >  =20
>=20
> Thanks for the patch, however, Why do you want to directly manipulate
> the metadata instead of using mdadm? You must first provide an
> explanation to convince us that what you're doing makes sense, and
> it's best to show your work.
>=20
> Thanks,
> Kuai

I'm with Kuai here. I would also add that for such purposes you can use
externally managed metadata, not native. External management was
proposed to address your problem however over the years it turned out
to not be good conception (kernel driver relies on userspace daemon
which is not secure).

Thanks,
Mariusz
