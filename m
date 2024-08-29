Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31F2F1494AF
	for <linux-raid@vger.kernel.org>; Thu, 29 Aug 2024 18:24:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724955890; cv=none; b=e05v6g7mz1PSbaV0lXiMwllp/FqpK2RIoN1OPvvhIFKxLA8dNiixyPZ0yNJIyOpQeBMiNxOdA1iDFmY0YMLpP9k3eQEGLx5SA/QEOhcc3J3eH9lbc0XQpgYFpdvqMZwhxDn3xXIaznXG1YELmhumNh/vJ1BJ/d3+uEdAwoncHFo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724955890; c=relaxed/simple;
	bh=BfDWc5XyegfjhDzpKKQPHY2j/Fedv815NJvnYqjee1Q=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=jH02PiqnuMgKlaUHzO1lEdegZsjfjRpr/O6Qwjt3qEBvvn8J7YKzLCiNJk6BjgF5t84jCk4Nrl+1IyRTDCX68If/t+y6RBUNpmWAjoxqF5nd3gu7oynZ2bqoRsP0TpXA5fLgWZPJGNBAIgOGD2VcEk7niH7SQr7N2JYosvMy5ZE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nW9Q0CB4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nW9Q0CB4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B591DC4CEC5
	for <linux-raid@vger.kernel.org>; Thu, 29 Aug 2024 18:24:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724955889;
	bh=BfDWc5XyegfjhDzpKKQPHY2j/Fedv815NJvnYqjee1Q=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=nW9Q0CB4gWd/7kyixoodvzuBoCiXpJnTKrv1hGutqcjM3trN6KtxU4MxOoJHmCtHI
	 k3Myv6RZiM+CoU4yx7urWntA+6iWwdqxTrRhQ9TCsmU+W+jynX7RS95A1yIQ6SVstx
	 Gl9D9KoXfmb/G0TD0TaThri9pERB7N0vxZF4Pp62vC1w/3SRyvH+wtOtDjTJy7aLaf
	 WQpgAdWvFevncFw5i0rUmo8rBwSAovkjvW2BQL+RxC9OrNyiEX23uf4hCQ9LwCmo3F
	 LXDuGRGsu7w82EN3dX7o04TuLoVyFTdcKZZWD+qOYVD+UHQT9BQaoBJH8WLz+adfVK
	 w+Oz/2t1QBfSA==
Received: by mail-io1-f50.google.com with SMTP id ca18e2360f4ac-82a238e0a9cso11967039f.3
        for <linux-raid@vger.kernel.org>; Thu, 29 Aug 2024 11:24:49 -0700 (PDT)
X-Gm-Message-State: AOJu0Yw5AouOLU9fqVJCgDBVxW2bXWdw17AmY7DrbK4HaBUzTk2zgj9T
	e2gMEOVm5HkLsqxy/VimiRngDXgDiAdtOdUou0Yjl1t75pTAVURCaZh6UyteLeFo6MduMI8JjS5
	1Ata357z1d9pNNYxzakw9oLitEvA=
X-Google-Smtp-Source: AGHT+IH+SZtuk8t271gst+mzBdMOsapWdVDugjbGV748QCCOKlimIx141Z10NoJjwHYeMB9OLVvqudr0o3LjTOpwq1A=
X-Received: by 2002:a05:6e02:1d9b:b0:39d:10e7:3a81 with SMTP id
 e9e14a558f8ab-39f3786be66mr44526575ab.18.1724955889055; Thu, 29 Aug 2024
 11:24:49 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240827153536.6743-1-artur.paszkiewicz@intel.com>
In-Reply-To: <20240827153536.6743-1-artur.paszkiewicz@intel.com>
From: Song Liu <song@kernel.org>
Date: Thu, 29 Aug 2024 11:24:37 -0700
X-Gmail-Original-Message-ID: <CAPhsuW7k1NLVT_UM3UgctMBPBf3uJ5wj5BFHYRJjkEif2kHe5A@mail.gmail.com>
Message-ID: <CAPhsuW7k1NLVT_UM3UgctMBPBf3uJ5wj5BFHYRJjkEif2kHe5A@mail.gmail.com>
Subject: Re: [PATCH 0/3] Optimize wait_for_overlap
To: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
Cc: linux-raid@vger.kernel.org, paul.e.luse@intel.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 27, 2024 at 8:35=E2=80=AFAM Artur Paszkiewicz
<artur.paszkiewicz@intel.com> wrote:
>
> The wait_for_overlap wait queue is currently used in two cases, which
> are not really related:
>  - waiting for actual overlapping bios, which uses R5_Overlap bit,
>  - waiting for events related to reshape.
>
> Handling every write request in raid5_make_request() involves adding to
> and removing from this wait queue, which uses a spinlock. With fast
> storage and multiple submitting threads the contention on this lock is
> noticeable.
>
> This patch series aims to resolve this by separating the two cases
> mentioned above and using this wait queue only when reshape is in
> progress.
>
> The results when testing 4k random writes on raid5 with null_blk
> (8 jobs, qd=3D64, group_thread_cnt=3D8):
> before: 463k IOPS
> after:  523k IOPS
>
> The improvement is not huge with this series alone but it is just one of
> the bottlenecks. When applied onto some other changes I'm working on, it
> allowed to go from 845k IOPS to 975k IOPS on the same test.
>
> Artur Paszkiewicz (3):
>   md/raid5: use wait_on_bit() for R5_Overlap
>   md/raid5: only add to wait queue if reshape is in progress
>   md/raid5: rename wait_for_overlap to wait_for_reshape

Thanks for the optimization! Applied the set to md-6.12 branch.

Song
