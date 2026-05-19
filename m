Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 204C03E1233
	for <linux-raid@vger.kernel.org>; Tue, 19 May 2026 08:18:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779178734; cv=none; b=Itv7DZjfKccfpwx/UTHoGvCWRf29ELh6iXi1IC0V5/Njl8fXrLc4s9vYTjWs/Cyr5oSRWBQSUm9uBJ6E7rvSqcBB1EHBH9JICtCdy4zzd1g3Mwh9QmbiUFYwfiRzJlFpvDD/L3zXEc2E/JUbj8pYFYn/0OV2LDqQ9ujeT6MDp4Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779178734; c=relaxed/simple;
	bh=8fXiL4RTeWVZYsrGG/bkXs064Df9xgPDGhz2R/guQms=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=PsI0vMVb4JFT+4L6nJq6LoxGNgUW1ADbBbV/rkwuesOlfnU4UvCqYtePPLnbJ+UliuCDFAZy4Vz/oJfNLTGgkh2PemkezJWWARfCArHzdPafSB1KY1g5JYVF63mr+HN6KHUmf8MzGSgk/cnN7wBsHKKcvuP/0oCG00g5H43MeTY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NWJblqp/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NWJblqp/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D50FCC2BCFA
	for <linux-raid@vger.kernel.org>; Tue, 19 May 2026 08:18:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1779178733;
	bh=8fXiL4RTeWVZYsrGG/bkXs064Df9xgPDGhz2R/guQms=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=NWJblqp/IUjtVnqRyW3mC7EhoFkgpkisgZwExQ1GX3t8iRXwLx5T6QyfMEla9doBE
	 ASjJkFTXYSBzhjSwrzQFAO1wW1ArZ89Wl7eTcL0MLML94L3R6NzuyMGaBotCk7j3A0
	 ONR23/sDsNpHO4WOshzey73BKXMMFeaiir3quWajDMNBUs6NRb4S69wNuaQHPu/LjB
	 WSldok59GX8N73RbOFiFk/CCkipE9bL/t28sbBAi3OK6it52kLYi0VzagUs4OswfB6
	 vvbrVLwhJHaOGZg/Mmzwq8dKkhwKRbKmYBIA/L1TaBYIicvjHUWWhV20zDsSkVhpBa
	 I8gioJJ90xNOQ==
Received: by mail-qt1-f174.google.com with SMTP id d75a77b69052e-51306c9f2e1so42663011cf.0
        for <linux-raid@vger.kernel.org>; Tue, 19 May 2026 01:18:53 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ8VE1S4lZtwOxI2cO32OjgYafLCc8dQ4aqEPH3jallRE3yY4JGYASL+dmQcaqRz9h9VWAJyS3n/xUqn@vger.kernel.org
X-Gm-Message-State: AOJu0Yz3LXR+EIwTe+LT6pN2lDpHAeOGI+O80liKa8XC2nKo+v4qelYe
	2SgCtmfLfgzOwaR2+E3UOlXA3rc7V9Pv8cckXhQdUnemhQORbCE9zk2r4MuvMsV7SGkpwnceGUc
	+7mkrOudoWH4N7wwIHHmT8w2uN+fM7A==
X-Received: by 2002:a05:622a:1b90:b0:50d:82db:773e with SMTP id
 d75a77b69052e-5165a22f61amr264607311cf.47.1779178733205; Tue, 19 May 2026
 01:18:53 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260501114652.590037-1-abd.masalkhi@gmail.com> <20260501114652.590037-4-abd.masalkhi@gmail.com>
In-Reply-To: <20260501114652.590037-4-abd.masalkhi@gmail.com>
From: Xiao Ni <xiao@kernel.org>
Date: Tue, 19 May 2026 16:18:41 +0800
X-Gmail-Original-Message-ID: <CAF-RUYVrsoNToB-pxCe0VeOwmWVk+3qE_35PjA_GA-_AsSf6wA@mail.gmail.com>
X-Gm-Features: AVHnY4I_ciWctFQDCff2saNKLW7iKmKmzX6JCgueOyBttXHS3z0ZfJhXz7SP_DA
Message-ID: <CAF-RUYVrsoNToB-pxCe0VeOwmWVk+3qE_35PjA_GA-_AsSf6wA@mail.gmail.com>
Subject: Re: [PATCH v2 3/3] md/raid1,raid10: fix bio accounting for split md
 cloned bios
To: Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>
Cc: song@kernel.org, yukuai@fnnas.com, xni@redhat.com, neilb@suse.com, 
	shli@fb.com, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, May 1, 2026 at 7:48=E2=80=AFPM Abd-Alrhman Masalkhi
<abd.masalkhi@gmail.com> wrote:
>
> Use md_cloned_bio() to control bio accounting instead of relying
> on r1bio_existed in raid1 or the io_accounting flag in raid10.
>
> The previous logic does not reliably reflect whether a bio is an
> md cloned bio. When a failed bio is split and resubmitted via
> bio_submit_split_bioset() on the error path, this can lead to either
> double accounting for md cloned bios, or missing accounting for bios
> returned from bio_submit_split_bioset()
>
> Fix this by using md_cloned_bio() to detect md cloned bios and
> skip accounting accordingly.
>
> Fixes: bb2a9acefaf9 ("md/raid1: switch to use md_account_bio() for io acc=
ounting")
> Fixes: 820455238366 ("md/raid10: switch to use md_account_bio() for io ac=
counting")
> Signed-off-by: Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>
> ---
> This patch depends on patch 1.
>
> Changes in v2:
>  - New patch.
> ---
>  drivers/md/raid1.c  | 2 +-
>  drivers/md/raid10.c | 8 ++++----
>  2 files changed, 5 insertions(+), 5 deletions(-)
>
> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
> index c52ecd38c163..dfaf34141325 100644
> --- a/drivers/md/raid1.c
> +++ b/drivers/md/raid1.c
> @@ -1396,7 +1396,7 @@ static void raid1_read_request(struct mddev *mddev,=
 struct bio *bio,
>         }
>
>         r1_bio->read_disk =3D rdisk;
> -       if (!r1bio_existed) {
> +       if (likely(!md_cloned_bio(mddev, bio))) {
>                 md_account_bio(mddev, &bio);
>                 r1_bio->master_bio =3D bio;
>         }
> diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
> index 8c6fc398260e..93af7bbc9005 100644
> --- a/drivers/md/raid10.c
> +++ b/drivers/md/raid10.c
> @@ -1146,7 +1146,7 @@ static bool regular_request_wait(struct mddev *mdde=
v, struct r10conf *conf,
>  }
>
>  static void raid10_read_request(struct mddev *mddev, struct bio *bio,
> -                               struct r10bio *r10_bio, bool io_accountin=
g)
> +                               struct r10bio *r10_bio)
>  {
>         struct r10conf *conf =3D mddev->private;
>         struct bio *read_bio;
> @@ -1226,7 +1226,7 @@ static void raid10_read_request(struct mddev *mddev=
, struct bio *bio,
>         }
>         slot =3D r10_bio->read_slot;
>
> -       if (io_accounting) {
> +       if (likely(!md_cloned_bio(mddev, bio))) {
>                 md_account_bio(mddev, &bio);
>                 r10_bio->master_bio =3D bio;
>         }
> @@ -1552,7 +1552,7 @@ static void __make_request(struct mddev *mddev, str=
uct bio *bio, int sectors)
>                         conf->geo.raid_disks);
>
>         if (bio_data_dir(bio) =3D=3D READ)
> -               raid10_read_request(mddev, bio, r10_bio, true);
> +               raid10_read_request(mddev, bio, r10_bio);
>         else
>                 raid10_write_request(mddev, bio, r10_bio);
>  }
> @@ -2872,7 +2872,7 @@ static void handle_read_error(struct mddev *mddev, =
struct r10bio *r10_bio)
>
>         rdev_dec_pending(rdev, mddev);
>         r10_bio->state =3D 0;
> -       raid10_read_request(mddev, r10_bio->master_bio, r10_bio, false);
> +       raid10_read_request(mddev, r10_bio->master_bio, r10_bio);
>         /*
>          * allow_barrier after re-submit to ensure no sync io
>          * can be issued while regular io pending.
> --
> 2.43.0
>
>

This patch looks good to me.
Reviewed-by: Xiao Ni <xiao@kernel.org>
