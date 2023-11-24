Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08263381BE
	for <linux-raid@vger.kernel.org>; Fri, 24 Nov 2023 17:29:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gq+zegA+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8254EC433C9
	for <linux-raid@vger.kernel.org>; Fri, 24 Nov 2023 17:29:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1700846970;
	bh=iMqDhiSQQ2GZy6dDGVvI9bb6a/sU1ztLX5yB9WRpFOY=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=gq+zegA+JdQXOcm9cfU1hnzsMEt56KwIvl1d44m+Q6WREm4vm7asNVD9A6Leo47QU
	 50CvLPYC4hPktxgLuJXqMFPGDEmoc+r6Cx7kvlyLKBqOQ2NmVw2wZlqZzIkFNHCMeC
	 S0Ah/MsRApb6rIQU9PoobyJBXXvlx3/6X7ux4LnSQM5g6y6sKv0wlyg+RU63KPC6rP
	 PdlPz3egumqB0KE6aS4TJpsoCBONFXjBAE6t+hZILlsxc3QvBbMAKddFKan4eqHQ/c
	 sAgBogblqXsu7N4ORy1M3gHKCCOYr+tU4MEdhu0bdo7YAJk0LRM2F7cgiUP4YRm6S5
	 l9FBJPStPBefA==
Received: by mail-lf1-f54.google.com with SMTP id 2adb3069b0e04-507cd62472dso3314929e87.0
        for <linux-raid@vger.kernel.org>; Fri, 24 Nov 2023 09:29:30 -0800 (PST)
X-Gm-Message-State: AOJu0Yy7rBpgkpVh5wZu91Ns8DNX1QaWIn8a1WJYSH48FV/wq6OVPAlQ
	y4kdOgKV+DyIKHJ8Sfw2hWQiFgqY2nlNWYsgkFg=
X-Google-Smtp-Source: AGHT+IGFh1Vg1fxRNFICppaeYGeqTmtcS7tmxaWesq93cOTysLVaReLT14cA9EOWMzvogLPTCasfUaHMq4ROjYOYDhY=
X-Received: by 2002:a05:6512:31c6:b0:50a:6fb8:a0c0 with SMTP id
 j6-20020a05651231c600b0050a6fb8a0c0mr1360532lfe.19.1700846968757; Fri, 24 Nov
 2023 09:29:28 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20231108182216.73611-1-junxiao.bi@oracle.com> <20231108182216.73611-2-junxiao.bi@oracle.com>
In-Reply-To: <20231108182216.73611-2-junxiao.bi@oracle.com>
From: Song Liu <song@kernel.org>
Date: Fri, 24 Nov 2023 09:29:16 -0800
X-Gmail-Original-Message-ID: <CAPhsuW5HCEbxTciUDiBJ-RkNBbmf76RSZZWvc88ABX172CCsOw@mail.gmail.com>
Message-ID: <CAPhsuW5HCEbxTciUDiBJ-RkNBbmf76RSZZWvc88ABX172CCsOw@mail.gmail.com>
Subject: Re: [PATCH V3 2/2] Revert "md/raid5: Wait for MD_SB_CHANGE_PENDING in raid5d"
To: Junxiao Bi <junxiao.bi@oracle.com>
Cc: linux-raid@vger.kernel.org, logang@deltatee.com, yukuai1@huaweicloud.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 8, 2023 at 10:22=E2=80=AFAM Junxiao Bi <junxiao.bi@oracle.com> =
wrote:
>
> This reverts commit 5e2cf333b7bd5d3e62595a44d598a254c697cd74.
>
> That commit introduced the following race and can cause system hung.
>
>  md_write_start:             raid5d:
>  // mddev->in_sync =3D=3D 1
>  set "MD_SB_CHANGE_PENDING"
>                             // running before md_write_start wakeup it
>                              waiting "MD_SB_CHANGE_PENDING" cleared
>                              >>>>>>>>> hung
>  wakeup mddev->thread
>  ...
>  waiting "MD_SB_CHANGE_PENDING" cleared
>  >>>> hung, raid5d should clear this flag
>  but get hung by same flag.
>
> The issue reverted commit fixing is fixed by last patch in a new way.
>
> Fixes: 5e2cf333b7bd ("md/raid5: Wait for MD_SB_CHANGE_PENDING in raid5d")
> Signed-off-by: Junxiao Bi <junxiao.bi@oracle.com>

The set looks good to me. Thanks!

Quick question: from the earlier thread, the issue was observed in
production. Have you reproduced the issue and thus verified the fix
works as expected?

Thanks,
Song
