Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E7C33DC4B3
	for <linux-raid@vger.kernel.org>; Tue, 19 May 2026 07:46:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779176791; cv=none; b=BVBvdubh4ogHHOaY+rjq6BbgDQ+qj83goosu7q2CSjmrXKHs1ERehv66QCh8ZoqJwvkRx6LANpnKsS+r1OOQIGTlTdecyXLdR6c5qCQp798t3Hmy2tJgpsOBQwke0l4Y0C9FCqxGPPE/0ooXlvDYQtG/cGs4sUSbr48WNlFzsmg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779176791; c=relaxed/simple;
	bh=/kki4pUMbbjg/smlR2G3j9ZQHJGTCaNsd9IqOcVwmsE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=FuCKqaQt0FJJJlkrdbLHZ52D5Tld4a248juYndFqLRqFLes8j8zaPIYKnyjD6p9wJ7VgRrLZhw5BbLk+zlUxVlmsBCqJFZ24rph2z/pIBqdPhilZafj/Yb2I7Tdxl7pGMKOY3F3PYdf7MUFU3HKaUrQMjcyrRFHgpQJQijFSCBo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jwlvt3G+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jwlvt3G+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E508C2BCF5
	for <linux-raid@vger.kernel.org>; Tue, 19 May 2026 07:46:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1779176791;
	bh=/kki4pUMbbjg/smlR2G3j9ZQHJGTCaNsd9IqOcVwmsE=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=jwlvt3G+XI+GQQhhQ7pN7fw9XH7pAdlJwvYGxCGfeOczs/co090c2msTYm1EUzPg5
	 i3xDqQ8LjLfAJYa6XbTz1y1W01msIdIz+2Rcl5VjVAzcnqJZwwNNEg4gH1Bjs6aEyO
	 1Kc/4NibKRECE35B4Yh5BovXAts4MA8h7Dkkq2FWQQh1tt+CxOb207lPdxPXG2O8qV
	 5CGKZV7Pg0CQbgZBOAUGckJmy5XpFEeng8/QaKSBRc+v5ro5w878+oBqSN/CgExkMH
	 fiMDhXhjYyHHNQ/6Vfmlk6XHoPsscqWdoyVF/yOTr4H3DhLhfW9Z/LwJII32xscxt2
	 j3gg6RRCkv1eQ==
Received: by mail-qt1-f177.google.com with SMTP id d75a77b69052e-50e63771d91so35479831cf.0
        for <linux-raid@vger.kernel.org>; Tue, 19 May 2026 00:46:31 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ+WcEx7cf2UN+2qMMnBkZQJToc95H+jlmi3woNsjZkOaAO3DSFGonk9waZjIOCMnmQq7Qn7qvi8Pno0@vger.kernel.org
X-Gm-Message-State: AOJu0YyOCSGj77aaAAKnBezngfP6Vif5k1z27P5gc4bnwz65VEXI9dGt
	yov9eYhHEfJrwyejiNgPuxG6BcSbwP3ixTUwa+lDSrNaMX5udG6VXhCTJIe8EBo/fJ0jkiJPE4T
	7bTX/tRosiecGZSyHFLLLvzxPRVewLg==
X-Received: by 2002:ac8:5f14:0:b0:50d:8b5a:1317 with SMTP id
 d75a77b69052e-5165a027da1mr253883421cf.13.1779176790711; Tue, 19 May 2026
 00:46:30 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260501114652.590037-1-abd.masalkhi@gmail.com> <20260501114652.590037-2-abd.masalkhi@gmail.com>
In-Reply-To: <20260501114652.590037-2-abd.masalkhi@gmail.com>
From: Xiao Ni <xiao@kernel.org>
Date: Tue, 19 May 2026 15:46:17 +0800
X-Gmail-Original-Message-ID: <CAF-RUYXNAYhtQsz0e6-zRC4a02+aXn6_mr4+6SSeBrTJ-KZxbA@mail.gmail.com>
X-Gm-Features: AVHnY4KM_3LoUon71YXOXzRnSjkx23F2dSU9JjiJGM-jSehd72UH9VM-4ESGFbM
Message-ID: <CAF-RUYXNAYhtQsz0e6-zRC4a02+aXn6_mr4+6SSeBrTJ-KZxbA@mail.gmail.com>
Subject: Re: [PATCH v2 1/3] md/raid1,raid10: fix deadlock in read error
 recovery path
To: Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>
Cc: song@kernel.org, yukuai@fnnas.com, xni@redhat.com, neilb@suse.com, 
	shli@fb.com, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, May 1, 2026 at 7:47=E2=80=AFPM Abd-Alrhman Masalkhi
<abd.masalkhi@gmail.com> wrote:
>
> raid1d and raid10d may resubmit a split md cloned bio while handling
> a read error. In this case, resubmitting the bio can lead to a deadlock
> if the array is suspended before md_handle_request() acquires an
> active_io reference via percpu_ref_tryget_live().
>
> Since the cloned bio already holds an active_io reference,
> trying to acquire another reference via percpu_ref_tryget_live()
> can lead to a deadlock while the array is suspended.
>
> Fix this by using percpu_ref_get() for md cloned bios.
>
> Fixes: bb2a9acefaf9 ("md/raid1: switch to use md_account_bio() for io acc=
ounting")
> Fixes: 820455238366 ("md/raid10: switch to use md_account_bio() for io ac=
counting")
> Signed-off-by: Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>
> ---
> Changes in v2:
>  - Use md_cloned_bio() consistently to detect cloned bios.
>  - Recognize that raid10 has the same issue and fix it in this series
>  - Allow splitting bios.
>  - Handle md cloned bios explicitly in md_handle_request()
>  - Link v1: https://lore.kernel.org/linux-raid/20260427103446.300378-1-ab=
d.masalkhi@gmail.com/
>
> Please let me know if I should add a Suggested-by tag for Yu Kuai,
> as the solution approach was suggested during review.
>
> Link to Yu Kuai' email: https://lore.kernel.org/linux-raid/m2lde74dtw.fsf=
@gmail.com/T/#m714020a38b60fc5f84b9a24f0c46acbe5d7342d6
>
> Thanks
> Abd-alrhman
> ---
>  drivers/md/md.c | 25 ++++++++++++++++---------
>  drivers/md/md.h |  5 +++++
>  2 files changed, 21 insertions(+), 9 deletions(-)
>
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index e926aef9ec43..96db1e7850e9 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -396,17 +396,24 @@ static bool is_suspended(struct mddev *mddev, struc=
t bio *bio)
>  bool md_handle_request(struct mddev *mddev, struct bio *bio)
>  {
>  check_suspended:
> -       if (is_suspended(mddev, bio)) {
> -               /* Bail out if REQ_NOWAIT is set for the bio */
> -               if (bio->bi_opf & REQ_NOWAIT) {
> -                       bio_wouldblock_error(bio);
> -                       return true;
> +       if (unlikely(md_cloned_bio(mddev, bio))) {
> +               /*
> +                * This bio is an MD cloned bio and already holds an
> +                * active_io reference, so percpu_ref_get() is safe here.
> +                */
> +               percpu_ref_get(&mddev->active_io);
> +       } else {
> +               if (is_suspended(mddev, bio)) {
> +                       /* Bail out if REQ_NOWAIT is set for the bio */
> +                       if (bio->bi_opf & REQ_NOWAIT) {
> +                               bio_wouldblock_error(bio);
> +                               return true;
> +                       }
> +                       wait_event(mddev->sb_wait, !is_suspended(mddev, b=
io));
>                 }
> -               wait_event(mddev->sb_wait, !is_suspended(mddev, bio));
> +               if (!percpu_ref_tryget_live(&mddev->active_io))
> +                       goto check_suspended;
>         }
> -       if (!percpu_ref_tryget_live(&mddev->active_io))
> -               goto check_suspended;
> -
>         if (!mddev->pers->make_request(mddev, bio)) {
>                 percpu_ref_put(&mddev->active_io);
>                 if (mddev_is_dm(mddev) && mddev->pers->prepare_suspend)
> diff --git a/drivers/md/md.h b/drivers/md/md.h
> index 3bfbee595156..e44074d30cf9 100644
> --- a/drivers/md/md.h
> +++ b/drivers/md/md.h
> @@ -1038,6 +1038,11 @@ void mddev_update_io_opt(struct mddev *mddev, unsi=
gned int nr_stripes);
>
>  extern const struct block_device_operations md_fops;
>
> +static inline bool md_cloned_bio(struct mddev *mddev, struct bio *bio)
> +{
> +       return bio->bi_pool =3D=3D &mddev->io_clone_set;
> +}
> +
>  /*
>   * MD devices can be used undeneath by DM, in which case ->gendisk is NU=
LL.
>   */
> --
> 2.43.0
>
>

This patch looks good to me.
Reviewed-by: Xiao Ni <xiao@kernel.org>
