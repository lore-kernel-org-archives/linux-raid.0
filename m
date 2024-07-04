Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38BAA1849C6
	for <linux-raid@vger.kernel.org>; Thu,  4 Jul 2024 07:10:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720077024; cv=none; b=PAKEDe09UoBdc+Qd2pjLAtSccM5w1EZLKSstbxQ/wUsfx1Q4BgqVQWF33V+jIUGu2IW2fH1+5HhlQ+7WmCTEsZWL2WvZvdJ7cAsF0wnLfN7JGDgOw5c+Cj4qMm+RQK00RF8BZ6BPSWgeTxiUv3f+ThKf7mcVwR6GfhwxCmZTxF0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720077024; c=relaxed/simple;
	bh=SlkikQIQeCSwRaoNM8jknTQ1lgyl9HQ+du/mY60xtwk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=h5pdD7C/oG/H8XlANf6Kb/xrWGVYKD64hZdcOWsqK99qr5Iox0Q5V8rwanYIIuVokvvfDL8UciPfE96qcD153Bus2S9NmECZgvkywHaDSplEuifacqP7dwuvXFl/J9d4eoSMOfLnzEI3SAHuEMlyQUNNRfOMjmIt8zPWe1jyc8Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=vF0ckMr4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="vF0ckMr4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8BE1C4AF0B
	for <linux-raid@vger.kernel.org>; Thu,  4 Jul 2024 07:10:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1720077023;
	bh=SlkikQIQeCSwRaoNM8jknTQ1lgyl9HQ+du/mY60xtwk=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=vF0ckMr4TUhJJA8V6zRLcSFeGbmTXe9R6fkybu/PgwDWV5i29gERVYzJIOntP5JNa
	 QLlYN75T4nnS7YkItDPVcirWFQBlvzmYbv14q0lCwo07D5agesWOs3GR2b6KIhOqm0
	 2V7uBwRKHOnjB9wdBskDK2JBQhqkKhKmckxvDrp6BEkeVFXEr/XQamTabG4vBmTl0w
	 vQMd/W8X1jEqPH63cZDNGQfvSuFj2Ap/W9w6qz/u7FgULgnd2iehKqb3pId3YXfBc7
	 V7+HVl+kaDQfggC6gUjLEYBbcrxOd+Hzju5LLB52aPzQETv+kXprQJvlRIo5hAH7ut
	 z3x5B6qN2hYig==
Received: by mail-lf1-f54.google.com with SMTP id 2adb3069b0e04-52e93d1432fso372570e87.0
        for <linux-raid@vger.kernel.org>; Thu, 04 Jul 2024 00:10:23 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCUEZrOlysp9yoLCGqkMW32gq7ld5BaMWkX9+YNm60MW9+ZttWQwzJijXC4OfZBsZRJIPVy7TwBn+BAXTf8xYthxkFHEUDnvUe4snQ==
X-Gm-Message-State: AOJu0Yw7nohWdiDiZmPHIX47bFSPFc53uN3WZE5jp5RPVMCnHD7Tv5Tr
	4QTqpNI47kgWRz68s2LYIe30RCmhCZ2jJ9d86h4UhSbTfUghsNW5VN82WX9/oH5x2RlrUviKMfN
	DQIwejZL6L0wmvmEBbq+ZPOip/hg=
X-Google-Smtp-Source: AGHT+IGpZJ96G1sxPZTOnkPQWQHT28hcB2Rhe8Ai+F1+x58jGWwz7GnH8TxVo6VD/DgWn2/olVVxe6MoOM/zwkShtkI=
X-Received: by 2002:a05:6512:706:b0:52b:bf8e:ffea with SMTP id
 2adb3069b0e04-52ea063f7f7mr474287e87.40.1720077022029; Thu, 04 Jul 2024
 00:10:22 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240702151802.1632010-1-bmarzins@redhat.com>
In-Reply-To: <20240702151802.1632010-1-bmarzins@redhat.com>
From: Song Liu <song@kernel.org>
Date: Thu, 4 Jul 2024 15:10:09 +0800
X-Gmail-Original-Message-ID: <CAPhsuW4fQjrEmO0_kDcGVn7zq-Xr92gRxjTviE8JWXiJYZgMtw@mail.gmail.com>
Message-ID: <CAPhsuW4fQjrEmO0_kDcGVn7zq-Xr92gRxjTviE8JWXiJYZgMtw@mail.gmail.com>
Subject: Re: [PATCH v2] md/raid5: recheck if reshape has finished with
 device_lock held
To: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Yu Kuai <yukuai3@huawei.com>, Heinz Mauelshagen <heinzm@redhat.com>, Xiao Ni <xni@redhat.com>, 
	linux-raid@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 2, 2024 at 11:18=E2=80=AFPM Benjamin Marzinski <bmarzins@redhat=
.com> wrote:
>
> When handling an IO request, MD checks if a reshape is currently
> happening, and if so, where the IO sector is in relation to the reshape
> progress. MD uses conf->reshape_progress for both of these tasks.  When
> the reshape finishes, conf->reshape_progress is set to MaxSector.  If
> this occurs after MD checks if the reshape is currently happening but
> before it calls ahead_of_reshape(), then ahead_of_reshape() will end up
> comparing the IO sector against MaxSector. During a backwards reshape,
> this will make MD think the IO sector is in the area not yet reshaped,
> causing it to use the previous configuration, and map the IO to the
> sector where that data was before the reshape.
>
> This bug can be triggered by running the lvm2
> lvconvert-raid-reshape-linear_to_raid6-single-type.sh test in a loop,
> although it's very hard to reproduce.
>
> Fix this by factoring the code that checks where the IO sector is in
> relation to the reshape out to a helper called get_reshape_loc(),
> which reads reshape_progress and reshape_safe while holding the
> device_lock, and then rechecks if the reshape has finished before
> calling ahead_of_reshape with the saved values.
>
> Also use the helper during the REQ_NOWAIT check to see if the location
> is inside of the reshape region.
>
> Fixes: fef9c61fdfabf ("md/raid5: change reshape-progress measurement to c=
ope with reshaping backwards.")
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>

Applied to md-6.11. Thanks!

Song
