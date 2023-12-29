Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4058D63BD
	for <linux-raid@vger.kernel.org>; Fri, 29 Dec 2023 08:12:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Vef+F/Sz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B391BC433C9
	for <linux-raid@vger.kernel.org>; Fri, 29 Dec 2023 08:12:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1703837576;
	bh=w3vA8ZKiLVh1wuF9H5R+MzRlojd03warFYel/GQlPh4=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=Vef+F/SzP1vP1iEUARvT0Bp48yFz88MCVGZbDXFchzB35Jt+bS5YHhr1bfQR77mB3
	 5U/8v1gcldT4BS20dKgbl7G0+P81FtesyaiBeOA4obAoUWbGyNkADZnY3VNGZ+ij48
	 PoNqUoykhG5eqPlC02bj5rrcldYMFnxwnFYktHx14yYKSWoDV9uXVpaAG6ySMbRYD1
	 FJIwksnlNfdja/CLowFz+aUcxEUaSX8ITZYOh90WX3syqdnzuf0DtGc5438SZH79OT
	 n0rEbZL2N2is576aIE971tp4LuWuzuzykYzMr8zqTU9tmLg0hLnWc07qB9iIVvqgbE
	 iNraQmSdB4FXA==
Received: by mail-lf1-f45.google.com with SMTP id 2adb3069b0e04-50e8ca6c76dso1204240e87.3
        for <linux-raid@vger.kernel.org>; Fri, 29 Dec 2023 00:12:56 -0800 (PST)
X-Gm-Message-State: AOJu0YwXm4W+DolyKUOirFh5l4rrsMulyX1zbIltIrn0PFMBvhCOdWpg
	EeM4lOoyu6S3YualQ4FnyhuOrkEgEymT0pli5a8=
X-Google-Smtp-Source: AGHT+IG+R3P8ParxC4+YlV4dsaTJxDsjL4Vh+dDPUgRRRGfk8kK9gzgjyAzm2Ig3jQGcMxC+1evqjkxMOAe0tLF10hs=
X-Received: by 2002:ac2:4882:0:b0:50e:4e6c:ea8f with SMTP id
 x2-20020ac24882000000b0050e4e6cea8fmr4598985lfc.41.1703837574811; Fri, 29 Dec
 2023 00:12:54 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20231221013914.3108026-1-song@kernel.org> <1faa5e2e-e4c6-4f82-9ceb-7440939bc167@linux.intel.com>
In-Reply-To: <1faa5e2e-e4c6-4f82-9ceb-7440939bc167@linux.intel.com>
From: Song Liu <song@kernel.org>
Date: Fri, 29 Dec 2023 00:12:43 -0800
X-Gmail-Original-Message-ID: <CAPhsuW4L_nZwMfUYMzNg9_p5OyePpy2H2sFqC5-cVcHgFh48Sw@mail.gmail.com>
Message-ID: <CAPhsuW4L_nZwMfUYMzNg9_p5OyePpy2H2sFqC5-cVcHgFh48Sw@mail.gmail.com>
Subject: Re: [PATCH mdadm] tests: Gate tests for linear flavor with variable LINEAR
To: Mateusz Kusiak <mateusz.kusiak@linux.intel.com>
Cc: linux-raid@vger.kernel.org, mariusz.tkaczyk@linux.intel.com, 
	jes@trained-monkey.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Dec 28, 2023 at 6:28=E2=80=AFAM Mateusz Kusiak
<mateusz.kusiak@linux.intel.com> wrote:
[...]
>
>  # create a raid0, re-assemble with a different super-minor
> +
> +if [ "$LINEAR" !=3D "yes" ]; then
> +  echo -ne 'skipping... '
> +  exit 0
> +fi
> +
>  mdadm -CR -e 0.90 $md0 -llinear -n3 $dev0 $dev1 $dev2
>  testdev $md0 3 $mdsize0 1
>  minor1=3D`mdadm -E $dev0 | sed -n -e 's/.*Preferred Minor : //p'`
>
> Hi Song, this approach looks a bit dirty to me as it's omitting what's al=
ready in the test suite. I would prefer adding additional param rather than=
 setting environment variable, so test execution flow stays unified (as far=
 as I'm aware we do not use flags for now). Adding param is also a good exc=
use to explain why linear is not tested by default in "--help".

We have something similar to this in tests/00multipath, so I used
this pattern.

Thanks,
Song

>
> Another thing is "--raidtype=3Dlinear" option, is probably redundant now.
>
> Thanks, Mateusz
