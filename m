Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16D1915E8B;
	Wed,  8 Jan 2025 21:43:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736372613; cv=none; b=aQISMxtDif384knZQaaXNf1bZVa5rN4ULdlapEVaX8QcsPuvQjYx0gTLSP3l8Y4cH7OBl7jpXJCAV7d8LMHXx+HPATQgOHMV6q9wpHFKQZHa0VIYqWG5U3h6SuRbGznCMvew47m0eYDXVcc+cYoaN5K5i8zaNJNMzNSrhsmnC1s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736372613; c=relaxed/simple;
	bh=fPV/XJLjDdtmqj6SdSUvYj0dgwYxBA35ptm/39Jsw7c=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=qmz1C4kZeYHM34NFMzONOBUXPzXzOIxoZF7n4wNCRrYxYAvtRt2jj3AZTt0+Y6IVdz78+udEZOs3P0HuBAXT+1HD0FHCk3X+XDMURGntMeFn2TDBuI03OiXxJC29wqkx3D9S9HDKPl460yIP8bJuHUScZe//watVgdMwPQViIq8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SbPs3/zI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SbPs3/zI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 956C1C4CEE2;
	Wed,  8 Jan 2025 21:43:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1736372612;
	bh=fPV/XJLjDdtmqj6SdSUvYj0dgwYxBA35ptm/39Jsw7c=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=SbPs3/zIc8fezWnwB9vJIldFnYCFX8Np3Y7FER3w2uLREK4jYlNPvgDzlVFtz5Xdc
	 9UN7E5frTiPZLlcvp2oxM5w+sQgUcjzY24wBX6UM/mqoDd0dQ+cTPtfREaR1M8RgAQ
	 w1VYHsJ2/UaPUl/PAQC6bBc5fLIz5L0rUkjnE/VqvvkUEFcsnIdhY4j5qWc9d97/sv
	 q0I+RK7HmAiRz7pCVsr0j/eG82h95vOrTOicr1a1idISMCoOnSqw7ZSINjwcGQ9SE7
	 6W8Q3YqqcDNoQ7CSHaxEYKbTDln32yNkBDgq+7grX+MCTX904uOv036+qdm10xls7i
	 taJst9bpphGbg==
Received: by mail-il1-f175.google.com with SMTP id e9e14a558f8ab-3a9caa3726fso980775ab.1;
        Wed, 08 Jan 2025 13:43:32 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCUCYDwRKwsrbXgR9PJVGG3iEzuja70N5JiWqvRI7yWRLWEzAm2+5FmuvCYnMAOGGRK9cILIhgml11+zxUo=@vger.kernel.org, AJvYcCVBlxRtiGHQT+3KrsLdG48gLXMrcMOo7IBp33yXk0l8dyjKITJcZyg+fSvbOQQftzh7pTaTQU55D9N4aw==@vger.kernel.org
X-Gm-Message-State: AOJu0YxjUEX1s4Wjou2Eo3hOYjNkIoYswGVbQcqEInHzULdkdD8u4Y21
	Y+H04rW6xMTg34H0u8kx16gZDv2+SVcljvAkraQQmmZW/vmMub9zcUIHEyvRsetXekZ2Kf2pvlm
	zmxn4GEuml2wgSlFFooq7ZkLr5ZI=
X-Google-Smtp-Source: AGHT+IF6Vf/BhSnk3/vE8VIP0qjyX4htcVi3BrzZ1j2MoAREepUSH/oEq/bWxboOe5WtjWKCJlxldjhXgXcloWLLWKw=
X-Received: by 2002:a05:6e02:1ca9:b0:3cd:e9a0:3c3d with SMTP id
 e9e14a558f8ab-3ce475340b7mr8090975ab.2.1736372611979; Wed, 08 Jan 2025
 13:43:31 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250108192131.46843-1-me@davidreaver.com>
In-Reply-To: <20250108192131.46843-1-me@davidreaver.com>
From: Song Liu <song@kernel.org>
Date: Wed, 8 Jan 2025 13:43:20 -0800
X-Gmail-Original-Message-ID: <CAPhsuW6y=KrncO1HMQwC-fL5qLi-BiLBuHix-Zq_yh-h06FV6A@mail.gmail.com>
X-Gm-Features: AbW1kvbZxv1l04DmtfpDl_Uufpv0TyecpkDdTaDeZHVxlO0YhxInQqoVk2ExowM
Message-ID: <CAPhsuW6y=KrncO1HMQwC-fL5qLi-BiLBuHix-Zq_yh-h06FV6A@mail.gmail.com>
Subject: Re: [PATCH] md: Replace deprecated kmap_atomic() with kmap_local_page()
To: me@davidreaver.com
Cc: Yu Kuai <yukuai3@huawei.com>, linux-raid@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Krister Johansen <kjlx@templeofstupid.com>, 
	Ira Weiny <ira.weiny@intel.com>, Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jan 8, 2025 at 11:23=E2=80=AFAM David Reaver <me@davidreaver.com> w=
rote:
>
> kmap_atomic() is deprecated and should be replaced with kmap_local_page()
> [1][2]. kmap_local_page() is faster in kernels with HIGHMEM enabled, can
> take page faults, and allows preemption.
>
> According to [2], this is safe as long as the code between kmap_atomic()
> and kunmap_atomic() does not implicitly depend on disabling page faults o=
r
> preemption. It appears to me that none of the call sites in this patch
> depend on disabling page faults or preemption; they are all mapping a pag=
e
> to simply extract some information from it or print some debug info.
>
> [1] https://lwn.net/Articles/836144/
> [2] https://docs.kernel.org/mm/highmem.html#temporary-virtual-mappings
>
> Signed-off-by: David Reaver <me@davidreaver.com>

LGTM. Applied to md-6.14.

Thanks for the patch!

Song
