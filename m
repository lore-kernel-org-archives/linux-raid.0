Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76B9FEE3F3F
	for <linux-raid@archiver.kernel.org>; Tue, 12 Sep 2023 22:49:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233749AbjILWta (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 12 Sep 2023 18:49:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230162AbjILWta (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 12 Sep 2023 18:49:30 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E13D10EB
        for <linux-raid@vger.kernel.org>; Tue, 12 Sep 2023 15:49:26 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13024C433C9
        for <linux-raid@vger.kernel.org>; Tue, 12 Sep 2023 22:49:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1694558966;
        bh=euI/xwwq2k7+5js2Xrdb2y1RsBkSkd4eJfKgKOgxoHc=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=izS6mM4Atbg4cHfRWZmBAXEbHYbz8jJt7/cxCmjLYxN7lCd530LFqKFuTUcrCQ7kV
         Fg2J3kKigYYmxyJ19NuSIQKVrUvAOB8BQRtaK1LseMrNIccYagM1fd+dwY3IlVUdyY
         IxfpFY22LLnBw44mxzUhITqTCHA7XC+ytBjqN46PDI5RmRAbRYgixt1SUtUYBBmcba
         YZpbLPuWskBP4H+KZAqhzrPob3/x4GUa9ZZgUoX7n8/zUGkym48i00mmuR/XXilvjj
         HfjrEa8F5zgR1eL78VJmEGUEnzVQf91thOhFvCu/ZijNkZsZ6+qv4NbBeYLz2mQ6KL
         7RQVfLaQPJFSA==
Received: by mail-lf1-f50.google.com with SMTP id 2adb3069b0e04-502a25ab777so7211123e87.2
        for <linux-raid@vger.kernel.org>; Tue, 12 Sep 2023 15:49:25 -0700 (PDT)
X-Gm-Message-State: AOJu0YzlCocQ+BOA/uE537NYISbr0J7mrRxm48mSQxc4BdC16/5Ws/wX
        fFPV/kKirFVEfY2qpPGpdBCGwcN2195DoYxN6V0=
X-Google-Smtp-Source: AGHT+IF1PWzB6T57DT8YzMIuB0/Kyhft7MewarxiDubv3sipQT+epZ2Q5ZES313SD6724iWcjfmCGQJ+xZ6AtfIk3IE=
X-Received: by 2002:a05:6512:2018:b0:500:799a:9a73 with SMTP id
 a24-20020a056512201800b00500799a9a73mr588478lfb.17.1694558964192; Tue, 12 Sep
 2023 15:49:24 -0700 (PDT)
MIME-Version: 1.0
References: <20230912130124.666-1-mariusz.tkaczyk@linux.intel.com>
In-Reply-To: <20230912130124.666-1-mariusz.tkaczyk@linux.intel.com>
From:   Song Liu <song@kernel.org>
Date:   Tue, 12 Sep 2023 15:49:12 -0700
X-Gmail-Original-Message-ID: <CAPhsuW5BsMP0vQo1nF44qTEtVoo5PaikfVT3jTDui5r94om2_Q@mail.gmail.com>
Message-ID: <CAPhsuW5BsMP0vQo1nF44qTEtVoo5PaikfVT3jTDui5r94om2_Q@mail.gmail.com>
Subject: Re: [PATCH v2] md: do not _put wrong device in md_seq_next
To:     Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
Cc:     linux-raid@vger.kernel.org, Yu Kuai <yukuai3@huawei.com>,
        AceLan Kao <acelan@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Tue, Sep 12, 2023 at 6:02=E2=80=AFAM Mariusz Tkaczyk
<mariusz.tkaczyk@linux.intel.com> wrote:
>
> During working on changes proposed by Kuai [1], I determined that
> mddev->active is continusly decremented for array marked by MD_CLOSING.
> It brought me to md_seq_next() changed by [2]. I determined the regressio=
n
> here, if mddev_get() fails we updated mddev pointer and as a result we
> _put failed device.
>
> I isolated the change in md_seq_next() and tested it- issue is no longer
> reproducible but I don't see the root cause in this scenario. The bug
> is obvious so I proceed with fixing. I will submit MD_CLOSING patches
> separatelly.
>
> Put the device which has been _get with previous md_seq_next() call.
> Add guard for inproper mddev_put usage(). It shouldn't be called if
> there are less than 1 for mddev->active.
>
> I didn't convert atomic_t to refcount_t because refcount warns when 0 is
> achieved which is likely to happen for mddev->active.
>
> [1] https://lore.kernel.org/linux-raid/028a21df-4397-80aa-c2a5-7c754560f5=
95@gmail.com/T/#m6a534677d9654a4236623661c10646d45419ee1b
> [2] https://bugzilla.kernel.org/show_bug.cgi?id=3D217798
>
> Fixes: 12a6caf27324 ("md: only delete entries from all_mddevs when the di=
sk is freed")
> Cc: Yu Kuai <yukuai3@huawei.com>
> Cc: AceLan Kao <acelan@gmail.com>
> Signed-off-by: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
> ---
>  drivers/md/md.c | 20 +++++++++++---------
>  1 file changed, 11 insertions(+), 9 deletions(-)
>
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 0fe7ab6e8ab9..bb654ff62765 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -618,6 +618,12 @@ static void mddev_delayed_delete(struct work_struct =
*ws);
>
>  void mddev_put(struct mddev *mddev)
>  {
> +       /* Guard for ambiguous put. */
> +       if (unlikely(atomic_read(&mddev->active) < 1)) {
> +               pr_warn("%s: active refcount is lower than 1\n", mdname(m=
ddev));
> +               return;
> +       }
> +

Could you please explain why we need this guard? We should probably fix
the caller that causes this.

>         if (!atomic_dec_and_lock(&mddev->active, &all_mddevs_lock))
>                 return;
>         if (!mddev->raid_disks && list_empty(&mddev->disks) &&
> @@ -8227,19 +8233,16 @@ static void *md_seq_next(struct seq_file *seq, vo=
id *v, loff_t *pos)
>  {
>         struct list_head *tmp;
>         struct mddev *next_mddev, *mddev =3D v;
> -       struct mddev *to_put =3D NULL;

IIUC, all we need is the following:

diff --git i/drivers/md/md.c w/drivers/md/md.c
index 73758b754127..a104a025084d 100644
--- i/drivers/md/md.c
+++ w/drivers/md/md.c
@@ -8265,7 +8265,7 @@ static void *md_seq_next(struct seq_file *seq,
void *v, loff_t *pos)
        spin_unlock(&all_mddevs_lock);

        if (to_put)
-               mddev_put(mddev);
+               mddev_put(to_put);
        return next_mddev;

 }

Is this sufficient? If so, how about we ship this first and refactor
the code later
in a separate patch?

Thanks,
Song
