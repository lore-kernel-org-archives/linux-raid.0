Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEAA516F90C
	for <linux-raid@vger.kernel.org>; Fri, 12 Jul 2024 15:09:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720796968; cv=none; b=CkC57F+9CzAn8CzoBXGFas9PBLgl38YdxWr2Vdea9QlzMRmOcoemHpZ51byIH4jOe6RvyHfahO7Figyy6j/CQZOihatJS7gBCA2hj3HrOPGycC3Vo+0VWB3O6mXh5NpsKq4caLFozl8vH376PtKcyxWa3uNNn6WkyphW5zKlxpU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720796968; c=relaxed/simple;
	bh=QRKun14IVd2v8MkzeBY+OYatbunAIezaOKrbxeg6WRM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=iqPF8YGluEizwahsXvGAo6wRZrnoFsSAL1Z7P1PuwR84oDp4GmweZwaa+XH+2AtGvZVvTHu22tRNn6imm5lXD2V1Ug8XqkybnklMFLMzy7widBjWU44OvtY4P0S//YTyoKJbpDBDXfI0kC6ywZVbw3bwVwwpfviOK6mpXDahFwQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jrw2N7+d; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jrw2N7+d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BDC2C32782
	for <linux-raid@vger.kernel.org>; Fri, 12 Jul 2024 15:09:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1720796968;
	bh=QRKun14IVd2v8MkzeBY+OYatbunAIezaOKrbxeg6WRM=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=jrw2N7+d6Jv4bLgy+lm/YkuAnHrVno+WSJkEMYjJESet9HxiWLy8w93CrDX34/Hba
	 8hr/2Fk0SQhbAdn0Mf0Cf6k7sQeaDwj6xNCzWGOpZ5ZAqJ+jId3UtJj850El3r7gcP
	 T0SSG4YVxDX0wEb6w63Fb9+bWw51c84hRsHyxREJ3mAB+S2yRHLksmhs0ltCXMME2+
	 JzMMm/+63S//J4L6GAQKkuTbeM+MeZy4Q1S0Ix1IayYF3acSz1tOuEglYpFSkiDdc6
	 t2oSyf8/8PGL62iKFqSMYfaa+5khybf0MwYRM2i+FW+OAF5l07LPDHITuLRvqEblYK
	 Il+bZVDLQ/fug==
Received: by mail-lf1-f46.google.com with SMTP id 2adb3069b0e04-52e9f863c46so2301787e87.1
        for <linux-raid@vger.kernel.org>; Fri, 12 Jul 2024 08:09:28 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCVTeqhycqOXZU2F6rRvTfLLuiDwv83nfOrH1NbbRyx4qtRsQRKGO4i4oRuisNd/YGZUUzMxxEADqDbjGJNYXM4qDNc3tPZcXC+0HA==
X-Gm-Message-State: AOJu0Yz33ShbQTTixWv6cuQy+FirYST+c2PWPgT3VCVf35A4h0CmRyvG
	KDSAjgnv8Q0Zc2vvQf/qqYr2jaC7N/IE7hAA89lSgFTCzJgkMytCnyOqv9q2bAXTEuoLGYxds7W
	dYasSqNLPZJdkqx1X1xJxFDvgJCY=
X-Google-Smtp-Source: AGHT+IHj8O0KtUQjnMzKPbmqlCwJPzaDdNKyJEVGk9nLl1sOsYv7Qj0XeHbLDwg2C0I8YrEehKYW5DtL/NMJoaS757k=
X-Received: by 2002:a05:6512:304f:b0:52e:6da6:f94 with SMTP id
 2adb3069b0e04-52eb99d4d11mr8364623e87.60.1720796966535; Fri, 12 Jul 2024
 08:09:26 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240709104120.22243-1-heming.zhao@suse.com> <dedf52bc-5a64-1dd0-9f38-2843ad73a696@huaweicloud.com>
In-Reply-To: <dedf52bc-5a64-1dd0-9f38-2843ad73a696@huaweicloud.com>
From: Song Liu <song@kernel.org>
Date: Fri, 12 Jul 2024 23:09:14 +0800
X-Gmail-Original-Message-ID: <CAPhsuW4ssLyqkXK=Pb2-HrkhDfWTFxZ0TCiPUHDdGaw+FASubg@mail.gmail.com>
Message-ID: <CAPhsuW4ssLyqkXK=Pb2-HrkhDfWTFxZ0TCiPUHDdGaw+FASubg@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] md-cluster: fix hanging issue while a new disk adding
To: Yu Kuai <yukuai1@huaweicloud.com>
Cc: Heming Zhao <heming.zhao@suse.com>, xni@redhat.com, glass.su@suse.com, 
	linux-raid@vger.kernel.org, "yukuai (C)" <yukuai3@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 9, 2024 at 7:06=E2=80=AFPM Yu Kuai <yukuai1@huaweicloud.com> wr=
ote:
>
> =E5=9C=A8 2024/07/09 18:41, Heming Zhao =E5=86=99=E9=81=93:
> > The commit 1bbe254e4336 ("md-cluster: check for timeout while a
> > new disk adding") is correct in terms of code syntax but not
> > suite real clustered code logic.
> >
> > When a timeout occurs while adding a new disk, if recv_daemon()
> > bypasses the unlock for ack_lockres:CR, another node will be waiting
> > to grab EX lock. This will cause the cluster to hang indefinitely.
> >
> > How to fix:
> >
> > 1. In dlm_lock_sync(), change the wait behaviour from forever to a
> >     timeout, This could avoid the hanging issue when another node
> >     fails to handle cluster msg. Another result of this change is
> >     that if another node receives an unknown msg (e.g. a new msg_type),
> >     the old code will hang, whereas the new code will timeout and fail.
> >     This could help cluster_md handle new msg_type from different
> >     nodes with different kernel/module versions (e.g. The user only
> >     updates one leg's kernel and monitors the stability of the new
> >     kernel).
> > 2. The old code for __sendmsg() always returns 0 (success) under the
> >     design (must successfully unlock ->message_lockres). This commit
> >     makes this function return an error number when an error occurs.
> >
> > Fixes: 1bbe254e4336 ("md-cluster: check for timeout while a new disk ad=
ding")
> > Signed-off-by: Heming Zhao <heming.zhao@suse.com>
> > Reviewed-by: Su Yue <glass.su@suse.com>
>
> Thanks for the patch.
>
> Acked-by: Yu Kuai <yukuai3@huawei.com>

Applied to md-6.11. Thanks!

Song
