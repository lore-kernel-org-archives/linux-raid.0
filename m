Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06D32CA0ECB
	for <linux-raid@archiver.kernel.org>; Tue, 12 Sep 2023 02:32:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236421AbjILCcb (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 11 Sep 2023 22:32:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239115AbjILCcS (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 11 Sep 2023 22:32:18 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B43CC9031
        for <linux-raid@vger.kernel.org>; Mon, 11 Sep 2023 18:57:25 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50B43C433B9
        for <linux-raid@vger.kernel.org>; Mon, 11 Sep 2023 21:35:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1694468120;
        bh=AbXB0IBtKSZkT6cYIuMcjRGLzokXpK55uELGvv0nNz0=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=JyQDEfMtr36WsUl6CmemafKw7BXdOH06irb9JH3mkDPd+JXTmYMYyPZdXyrLTQf6y
         xRhnn2um6VAICVoaY1+3IsHlIuD1HJgRvBe1jcuJqP0eco6D/amPV8P1pLvaNkRbIr
         B3OXPLWMozw0MH9oIEyA9YAvOXFFp2ADjJ2Wh0P8vZq6aWb+puqckmgHyHYXZVZsgZ
         mjJzece4qt2lfUNqrunxpYukZi+lbBTknisBFcT627qo2jCRYVw1p4TQwGEnQumPJl
         zxlLVP2fQYKpjdTm8TCQ423uv61sgx7Pu7wJxk03JSOTNmkIpTUnDmQbZFYtFhWhgJ
         E/MOnIkVRDMdQ==
Received: by mail-lf1-f54.google.com with SMTP id 2adb3069b0e04-5029e4bfa22so5609441e87.3
        for <linux-raid@vger.kernel.org>; Mon, 11 Sep 2023 14:35:20 -0700 (PDT)
X-Gm-Message-State: AOJu0YwIO7EnmGRwPArjMlO9Xin3LY8R1omyWG1bhZr3fPrTPZFtFKkz
        lbW5Rra8+kqdEHTEIuEQiF/hhjL4qLAolCZgCyA=
X-Google-Smtp-Source: AGHT+IHpusnuiVkSJMGjSWzP4+Z0Qtf87a2BBnl63/lGIr2ZhaexNZ6XVWY3SXbOGWpwAvQVMB/f/T1NMR38wDqtC+w=
X-Received: by 2002:a05:6512:4007:b0:4fd:d9dd:7a1a with SMTP id
 br7-20020a056512400700b004fdd9dd7a1amr10507305lfb.31.1694468118529; Mon, 11
 Sep 2023 14:35:18 -0700 (PDT)
MIME-Version: 1.0
References: <20230911105657.6816-1-mariusz.tkaczyk@linux.intel.com>
In-Reply-To: <20230911105657.6816-1-mariusz.tkaczyk@linux.intel.com>
From:   Song Liu <song@kernel.org>
Date:   Mon, 11 Sep 2023 14:35:06 -0700
X-Gmail-Original-Message-ID: <CAPhsuW42GFkekozN9MuAoZEpDQk-3ChgyGtuVKdN74eqEgZLBA@mail.gmail.com>
Message-ID: <CAPhsuW42GFkekozN9MuAoZEpDQk-3ChgyGtuVKdN74eqEgZLBA@mail.gmail.com>
Subject: Re: [PATCH] md: do not _put wrong device
To:     Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
Cc:     linux-raid@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Mon, Sep 11, 2023 at 3:57=E2=80=AFAM Mariusz Tkaczyk
<mariusz.tkaczyk@linux.intel.com> wrote:
>
> Put the device which has been _get with previous md_seq_next call.
> Add guard for improper mddev_put usage(). It shouldn't be called if
> there are less than 1 for mddev->active.
>
> I didn't convert atomic_t to refcount_t because refcount warns when 0 is
> achieved which is likely to happen for mddev->active.
>
> It fixes [1], I'm unable to reproduce this issue now.
>
> [1]: https://bugzilla.kernel.org/show_bug.cgi?id=3D217798
> Signed-off-by: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>

This patch somehow didn't make it through lore. Please repost and
CC folks so we can test it thoroughly. Also, please add more information
about the failure for future reference.

Thanks,
Song


> ---
>
> There is md_seq cleanup proposed by Yu, this one should be merged
> first, because it is low risk fix for particular regression.
>
> This is not complete fix for the problem, we need to prevent new open
> in the middle of removal, I will propose patchset separately.
>
>  drivers/md/md.c | 9 +++++++--
>  1 file changed, 7 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 0fe7ab6e8ab9..ffae02406175 100644
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
>         if (!atomic_dec_and_lock(&mddev->active, &all_mddevs_lock))
>                 return;
>         if (!mddev->raid_disks && list_empty(&mddev->disks) &&
> @@ -8250,8 +8256,7 @@ static void *md_seq_next(struct seq_file *seq, void=
 *v, loff_t *pos)
>                 next_mddev =3D list_entry(tmp, struct mddev, all_mddevs);
>                 if (mddev_get(next_mddev))
>                         break;
> -               mddev =3D next_mddev;
> -               tmp =3D mddev->all_mddevs.next;
> +               tmp =3D next_mddev->all_mddevs.next;
>         }
>         spin_unlock(&all_mddevs_lock);
>
> --
> 2.26.2
>
