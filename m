Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84441133987;
	Fri, 18 Oct 2024 16:00:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729267249; cv=none; b=bpH+Lz7qOik5TwP6Z4wZzv8W9EprfKUrmpcMNSaghDuMMIeNRjLF2LUSw+MQFOrXunmSljtz0xRr9GqCu8Nj6i0sFCOGU3mO+DJHv/WXAk/T5+P9hcy5k0qj2ErEnRpytuy4++qHmlWaHl6Kd+KxCszDxhRk+kEXR23syVv8jQ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729267249; c=relaxed/simple;
	bh=zpANFnWRoD/eiFZ7gwBmD53a0CBzxsDQACKvAdJxOQc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=o0sB9KPnpvbn4SNCODn/Pwa3utX89meaStvAj7QEwGfJ7KvbfRYolI7cRHtvCTvL//3L9AwerdJqm0KQox+MMQ7hyTiuSoTHa6PGMnL1vGMjKAcaIqCKlvBd5ZYWxoZ+zIzbj3wy7gfTLq2H5ojk51ayk1A/OKGiZRLcIAHWvCs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LGIivg4N; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LGIivg4N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F41AC4CEC3;
	Fri, 18 Oct 2024 16:00:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729267249;
	bh=zpANFnWRoD/eiFZ7gwBmD53a0CBzxsDQACKvAdJxOQc=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=LGIivg4N8xOI7/UzmnLo/36YZfk+O1ZFXx0sUzJxiUuN3MZIjKswB37/Gag4a6ghp
	 wt+/Y2fQhiA07gdSwtICiWJEXZlhSJmdlex4U9pWma5+YV/CI/iQCDzMzZ0T0iUIi/
	 N4WEZY5bbPWfpbmD9I9Efcw57/qT+3RNxW+RJQgFAZByNdCCugInx/Bxd/lLV6XqoF
	 uJFioGWO8KxdBiIuR6YkDYTM+BSO+zm9mGUp6BxG34I2Xdg6OwvGBWj+JejMcjR/5j
	 mwJ9GHmrk5ya1Q7LqczXMUnhL5ap0GZxUd2mQ0uaBlx/Yp7skp79lprS2X322zpX49
	 bg9TT91CM8g3g==
Received: by mail-il1-f180.google.com with SMTP id e9e14a558f8ab-3a3bb6a020dso8730885ab.2;
        Fri, 18 Oct 2024 09:00:49 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCViKggKbG6j/Xudkg+zI3oF1tPnmv1YaKKqhrAs2sm6gadNRUsBaClCDzf8FlV9q/mWxxDUMHb1p/ZAlBs=@vger.kernel.org, AJvYcCWzhVsw4n2ytCyhT0F5F6TGzK8nso0A3nWf/p56Ueo1Q/JWdEtYJBILhT9X5YoQ7O5oZwL1FXEcdUL+wQ==@vger.kernel.org
X-Gm-Message-State: AOJu0Yy11ilYjD+FlgE/0jmBsm4kM/szMAXDmr7A9WlNCYz4chs97Gin
	sAggekIKReMMD5dIQtwiac2ktb7SDSOidIyRZYGmyWWRT1NKFsf7m+riahgswbcqa/VvoJMolIv
	VaERJ9uzkrR81W8IO4ChEfWPepoI=
X-Google-Smtp-Source: AGHT+IFlrNh+N+VKMRzqF1ezmRpKwU3q8j91DjeGUAArWFVU8LBtk5jcETATAn4F4d+fyxp0gY8wP++PUX1UbYJZNBM=
X-Received: by 2002:a05:6e02:1caf:b0:3a0:92b1:ec3c with SMTP id
 e9e14a558f8ab-3a3f405085cmr35023505ab.4.1729267248737; Fri, 18 Oct 2024
 09:00:48 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241007084831.48067-1-ubizjak@gmail.com> <27983c29-dbf0-4105-8176-739971a071b4@intel.com>
In-Reply-To: <27983c29-dbf0-4105-8176-739971a071b4@intel.com>
From: Song Liu <song@kernel.org>
Date: Fri, 18 Oct 2024 09:00:37 -0700
X-Gmail-Original-Message-ID: <CAPhsuW6VKssKDCLCbxYMzbt2GBuxMfJp1AbSDRX-TwDBRu0h_A@mail.gmail.com>
Message-ID: <CAPhsuW6VKssKDCLCbxYMzbt2GBuxMfJp1AbSDRX-TwDBRu0h_A@mail.gmail.com>
Subject: Re: [PATCH] md/raid5-ppl: Use atomic64_inc_return() in ppl_new_iounit()
To: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
Cc: Uros Bizjak <ubizjak@gmail.com>, linux-raid@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Yu Kuai <yukuai3@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Oct 8, 2024 at 12:38=E2=80=AFAM Artur Paszkiewicz
<artur.paszkiewicz@intel.com> wrote:
>
> On 10/7/24 10:48, Uros Bizjak wrote:
> > Use atomic64_inc_return(&ref) instead of atomic64_add_return(1, &ref)
> > to use optimized implementation and ease register pressure around
> > the primitive for targets that implement optimized variant.
> >
> > Signed-off-by: Uros Bizjak <ubizjak@gmail.com>
> > Cc: Song Liu <song@kernel.org>
> > Cc: Yu Kuai <yukuai3@huawei.com>
>
> Reviewed-by: Artur Paszkiewicz <artur.paszkiewicz@intel.com>

Applied to md-6.13. Thanks for the patch!

Song
