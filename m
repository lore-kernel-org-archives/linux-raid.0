Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F4EC6F623
	for <linux-raid@vger.kernel.org>; Wed,  6 Dec 2023 20:39:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GACbAINA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88B1EC433C8
	for <linux-raid@vger.kernel.org>; Wed,  6 Dec 2023 20:39:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1701895145;
	bh=ZIWSEcH/7tJjnsrAwxDzkOc7qnzvry2pa9PcGX3OwHw=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=GACbAINAoTp2vgAp59SBRu0mukXPbmMfBGnhT9R0OYRd49wT+SE/DhewMJ7q+QPOg
	 JMjQBLfmwOHY2oLaN6kRiBUxVZKTp94qMtEU7cH6YldeSQLfBLHobxYnt/o2cascNr
	 7qBZxc/gCLe7DYx9tKfUwvQqUEnxFBEHFMk8DMS03dSswhKb8RMqfD7R2QP8zOFhgR
	 mvZQUonumCMYlmsbrqVCxjzuPL585dwOnGfHW1gowOZcxTDVZFTPjKvdgO4EkVluTk
	 lspXgJ15ss73KG25jEEIYdi/R1XkuY6t+4mdqyreWSS2DFEXgiESdzmTNfCgnw/nK8
	 LJGkh3I+ZX1hw==
Received: by mail-lj1-f171.google.com with SMTP id 38308e7fff4ca-2ca0715f0faso2884171fa.0
        for <linux-raid@vger.kernel.org>; Wed, 06 Dec 2023 12:39:05 -0800 (PST)
X-Gm-Message-State: AOJu0YzgeFqNvUClCpLY9Oc+iSZTznZSY2lKhugm4zssGfWEUU2Sk1ud
	Jea/3T80sW1ivVX4iVq/Bj08r1ueTCiaiUBvVoo=
X-Google-Smtp-Source: AGHT+IHaSGtC4NGSH3C9OJJ/MsSVStv3e4X2Vfr9n49FoqotGaqMgwgmBvCSAMVRTZ5SENinH4Sfy0sZrOVxY8GfPjo=
X-Received: by 2002:a2e:361a:0:b0:2c9:f49b:d4b1 with SMTP id
 d26-20020a2e361a000000b002c9f49bd4b1mr897983lja.96.1701895143761; Wed, 06 Dec
 2023 12:39:03 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20231206083356.9796-1-fujita.yuya-00@fujitsu.com>
In-Reply-To: <20231206083356.9796-1-fujita.yuya-00@fujitsu.com>
From: Song Liu <song@kernel.org>
Date: Wed, 6 Dec 2023 12:38:51 -0800
X-Gmail-Original-Message-ID: <CAPhsuW7WE8p+ijAx3rJEeafJV8-EtJ+KOaZayUap0G6JpFpdGg@mail.gmail.com>
Message-ID: <CAPhsuW7WE8p+ijAx3rJEeafJV8-EtJ+KOaZayUap0G6JpFpdGg@mail.gmail.com>
Subject: Re: [PATCH] md: Do not unlock all_mddevs_lock in md_seq_show()
To: Yuya Fujita <fujita.yuya-00@fujitsu.com>
Cc: yukuai3@huawei.com, mariusz.tkaczyk@linux.intel.com, 
	linux-raid@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Dec 6, 2023 at 12:37=E2=80=AFAM Yuya Fujita <fujita.yuya-00@fujitsu=
.com> wrote:
>
> Do not unlock all_mddevs_lock in md_seq_show() and keep the lock until
> md_seq_stop().
>
> The list of all_mddevs may be deleted in md_seq_show() because
> all_mddevs_lock is temporarily unlocked.
> The list should not be deleted while iterating over all_mddevs.
> (Just as the list should not be deleted during list_for_each_entry().)
>
> Fixes: cf1b6d4441ff ("md: simplify md_seq_ops")
> Signed-off-by: Yuya Fujita <fujita.yuya-00@fujitsu.com>

Looks reasonable to me.

Yu Kuai, what do you think about this?

Thanks,
Song
> ---
>  drivers/md/md.c | 2 --
>  1 file changed, 2 deletions(-)
>
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index c94373d64f2c..97ef08608848 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -8293,7 +8293,6 @@ static int md_seq_show(struct seq_file *seq, void *=
v)
>         if (!mddev_get(mddev))
>                 return 0;
>
> -       spin_unlock(&all_mddevs_lock);
>         spin_lock(&mddev->lock);
>         if (mddev->pers || mddev->raid_disks || !list_empty(&mddev->disks=
)) {
>                 seq_printf(seq, "%s : %sactive", mdname(mddev),
> @@ -8364,7 +8363,6 @@ static int md_seq_show(struct seq_file *seq, void *=
v)
>                 seq_printf(seq, "\n");
>         }
>         spin_unlock(&mddev->lock);
> -       spin_lock(&all_mddevs_lock);
>         if (atomic_dec_and_test(&mddev->active))
>                 __mddev_put(mddev);
>
> --
> 2.31.1
>
>
