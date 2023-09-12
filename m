Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4AC79EE3F22
	for <linux-raid@archiver.kernel.org>; Tue, 12 Sep 2023 20:25:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231858AbjILUZN (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 12 Sep 2023 16:25:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231210AbjILUZM (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 12 Sep 2023 16:25:12 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06176189
        for <linux-raid@vger.kernel.org>; Tue, 12 Sep 2023 13:25:09 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FA54C433CB
        for <linux-raid@vger.kernel.org>; Tue, 12 Sep 2023 20:25:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1694550308;
        bh=9Cx/HX2FjLzGzNDhZnq5Vt6ipXGq4oJlU7qXDRWqAMA=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=M68wqakpFS8ekES7W67MSg6ApFF0wZ92cIOiAHLuKPJtah1/kKReiGJJ3jcxS4AhE
         xMaxoP18On1DUQYLY02fIKcoxhOJdVAtOrpvTH6jJK4qLSQbsPe2lDA57r891vcrsX
         kyTvX5Tm2p6+0PlZs48Xz1lWLnq43jBhhYgQ2yrp5TbXVnbH5viP55LV2vdSLxwHLl
         I3oGsdRS6z9jZij5ub6RI/AhCCQE3exIAIYDRxRSABevEXyPzVuYlOEBhK5d8rNHt+
         bpf6qPW4QmhrRIDmhlQD67M/VeP3RwipTxokb2XlVNMY9nHUVM9XVln7hrEOdLDO5D
         nn9o9aueZ5a1g==
Received: by mail-lf1-f51.google.com with SMTP id 2adb3069b0e04-501b9f27eb2so280203e87.0
        for <linux-raid@vger.kernel.org>; Tue, 12 Sep 2023 13:25:08 -0700 (PDT)
X-Gm-Message-State: AOJu0YzS+6tOnyu5a3TaWFnXTtlyfGxxZlMHdN/u9Q2GH87U0cEQs+Dh
        bZ4zX3uU2JtW/Br3AEu/nksivj4Hp1tfszgVRD4=
X-Google-Smtp-Source: AGHT+IFZlSw9G4TUQE0+HT6kKDIGAVTqzp4Ck7LY1ggjVHHXG6YmQFUVijGKskUxlhxCgVLvVkIqCPOIXjlzg1qZxA8=
X-Received: by 2002:a05:6512:1183:b0:4f8:6253:540 with SMTP id
 g3-20020a056512118300b004f862530540mr195322lfr.19.1694550306786; Tue, 12 Sep
 2023 13:25:06 -0700 (PDT)
MIME-Version: 1.0
References: <20230912130124.666-1-mariusz.tkaczyk@linux.intel.com>
 <5a71d6a0-c971-1e28-110d-a6ad2f81cda0@huaweicloud.com> <20230912154011.00007399@linux.intel.com>
In-Reply-To: <20230912154011.00007399@linux.intel.com>
From:   Song Liu <song@kernel.org>
Date:   Tue, 12 Sep 2023 13:24:54 -0700
X-Gmail-Original-Message-ID: <CAPhsuW40j=UP526yaA3-LOhNxJmhRkqWBZ4HOCDEw1MLscfcTg@mail.gmail.com>
Message-ID: <CAPhsuW40j=UP526yaA3-LOhNxJmhRkqWBZ4HOCDEw1MLscfcTg@mail.gmail.com>
Subject: Re: [PATCH v2] md: do not _put wrong device in md_seq_next
To:     Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
Cc:     Yu Kuai <yukuai1@huaweicloud.com>, linux-raid@vger.kernel.org,
        AceLan Kao <acelan@gmail.com>,
        "yukuai (C)" <yukuai3@huawei.com>,
        "yangerkun@huawei.com" <yangerkun@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi Mariusz,

Thanks for the fix!

On Tue, Sep 12, 2023 at 6:40=E2=80=AFAM Mariusz Tkaczyk
<mariusz.tkaczyk@linux.intel.com> wrote:
>
> On Tue, 12 Sep 2023 21:25:24 +0800
> Yu Kuai <yukuai1@huaweicloud.com> wrote:
>
> > Hi,
> >
> > =E5=9C=A8 2023/09/12 21:01, Mariusz Tkaczyk =E5=86=99=E9=81=93:
> > > During working on changes proposed by Kuai [1], I determined that
> > > mddev->active is continusly decremented for array marked by MD_CLOSIN=
G.
> > > It brought me to md_seq_next() changed by [2]. I determined the regre=
ssion
> > > here, if mddev_get() fails we updated mddev pointer and as a result w=
e
> > > _put failed device.
> >
> > This mddev is decremented while there is another mddev increased, that'=
s
> > why AceLan said that single array can't reporduce the problem.
> >
> > And because mddev->active is leaked, then del_gendisk() will never be
> > called for the mddev while closing the array, that's why user will
> > always see this array, cause infiniate loop open -> stop array -> close
> > for systemd-shutdown.
>
> Ohh, I see the scenario now...
> First array can be successfully stopped. We marked MD_DELETED and proceed
> with scheduling wq but in the middle of that md_seq_next() increased acti=
ve for
> other array and decrement active for the one with MD_DELETED.
> For this next array we are unable to reach active =3D=3D 0 anymore.
>
> Song, let me know if you need description like that in commit message.

Yes, please revise the commit log to include this information.

Also, please add Reported-by: and/or Closes: tags.

Thanks again!
Song
