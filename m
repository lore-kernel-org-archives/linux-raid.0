Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B2BB2D5932
	for <linux-raid@vger.kernel.org>; Sat, 15 Aug 2026 21:07:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786828063; cv=none; b=a9/O3RFzwhvvnuaB79RoF3kHmfe5Mn5em3Sc4GPjeorwpem+Od60nCEQL1KX6hcOIeJ2uxr3UBErNxpuhMsvrhSI1JFeJhLyWyBjmVqe+P8dDowCoD930+FW0MlkBQaD+G5qQWWxNGpwbvxN9QKkwpbE1xDJRraCHjLa8FG21xg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786828063; c=relaxed/simple;
	bh=q7vFt2DyE40J+ZyPhEgUcAlp43mBRXVQFvW3GYBwt0g=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=K7+ndsp9b9LK4vIkmn7SAVrOIpCmMRxldalU2kUbqvsh8T5zQPMFClTy/TFtfF/hMBtqrtcDODM05s/M0+VB3IFAtMiOZDkG05tiLTrJFuLsHqBgOLq4WWRQeHwn1CRh0nkkBmS9w3QVBbeQlPcDdEMdldhH1Ny1xmmvmmihdvs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Kuv+ErEd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Kuv+ErEd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F40F41F000E9;
	Sat, 15 Aug 2026 21:07:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786828062;
	bh=fwIoCi6Q72Aw5Lm3HQ8RRKjKGnMDwDL/47QoKTGZo7w=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Kuv+ErEdFWxHQlUtQdL4X3DsrQFvwnuhQp7QY01ZP2WUXno7KQQ+L57vtL5reczhc
	 dQFXOjGP1cUXoNtQ34HWncEAo3LKJjZUhtWzovrEr5CUlCBxoODhISB4pZEQuaUMVs
	 IKhxI2TumZOX7URMDFCXeDCbJnTeiRBebnQwO1vNBqJMgjP4KZ7gpTqX06ucwJ+nHv
	 JJCiOXIehIBeCxAwgSO34ljbPaUxjXUOvJCquqggMRS5UOquif0NEOk/OhZPKXOAQe
	 YmqyzKregJe4ut7/2wkpmX5tkFvMs2vhjcgJy7e57hJHk25gAc8LvSsrdrrKMYtNLg
	 d/xxLWllRA9Og==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 2/6] raid6: add missing vzeroupper to AVX2 code
Reply-To: sashiko-reviews@lists.linux.dev
To: "Eric Biggers" <ebiggers@kernel.org>
Cc: linux-raid@vger.kernel.org, yukuai@fygo.io
In-Reply-To: <20260815205750.169336-3-ebiggers@kernel.org>
References: <20260815205750.169336-1-ebiggers@kernel.org>
 <20260815205750.169336-3-ebiggers@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 15 Aug 2026 21:07:41 +0000
Message-Id: <20260815210741.F40F41F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] Missing vzeroupper in AVX-512 RAID6 code leading to severe AVX-SSE=
 transition penalties
--

--- Patch [2]: [PATCH 2/6] raid6: add missing vzeroupper to AVX2 code ---
commit 053e34bcf70317a18a7c9c774075bd7eb1c95140
Author: Eric Biggers <ebiggers@kernel.org>

raid6: add missing vzeroupper to AVX2 code

Since the AVX2 optimized RAID6 code uses YMM registers, execute vzeroupper
before returning from it. This is needed to avoid degrading the performance
of any later SSE code that may happen to be executed.

> diff --git a/lib/raid/raid6/x86/avx2.c b/lib/raid/raid6/x86/avx2.c
> index 7d829c669ea79..3cc2fe7ac42c5 100644
> --- a/lib/raid/raid6/x86/avx2.c
> +++ b/lib/raid/raid6/x86/avx2.c
> @@ -67,6 +67,7 @@ static void raid6_avx21_gen_syndrome(int disks, size_t =
bytes, void **ptrs)
>  	}
> =20
>  	asm volatile("sfence" : : : "memory");
> +	asm volatile("vzeroupper");

[Severity: High]
This is a pre-existing issue, but does the AVX-512 RAID6 code also need this
fix?

Like the AVX2 code, the AVX-512 code uses ZMM registers but returns without
executing vzeroupper before kernel_fpu_end().

For example, in lib/raid/raid6/x86/avx512.c:raid6_avx5121_gen_syndrome():

        asm volatile("sfence" : : : "memory");
        kernel_fpu_end();
}

And similarly in lib/raid/raid6/x86/recov_avx512.c:raid6_2data_recov_avx512=
().

Would omitting vzeroupper here leave the upper bits of ZMM registers dirty
and incur severe AVX-SSE transition penalties if the CPU subsequently
executes legacy SSE code, causing a performance regression?

>  	kernel_fpu_end();
>  }

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260815205750.1693=
36-1-ebiggers@kernel.org?part=3D2
