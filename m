Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73130C77B7C
	for <linux-raid@archiver.kernel.org>; Fri, 26 May 2023 21:13:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237732AbjEZVNv (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 26 May 2023 17:13:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230064AbjEZVNu (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 26 May 2023 17:13:50 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54D77E41
        for <linux-raid@vger.kernel.org>; Fri, 26 May 2023 14:13:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9E942653BC
        for <linux-raid@vger.kernel.org>; Fri, 26 May 2023 21:13:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05569C433EF
        for <linux-raid@vger.kernel.org>; Fri, 26 May 2023 21:13:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685135623;
        bh=wSzSj1sLR2zeeILJbxd5iKR+RJNj7mo9L21cf6xfgX8=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=W8ZHCeBhheoIKKvyMjsJ1tdTybADt082QA9wDR1pBmtQZwphs+Gu3Y4FXgc9/Soa5
         K2pVBSdLxG6aziF+/ZXrnIIftEB4iuo6TMcx5N2SmpyMCPELBNCAWgswlVt0aowoyM
         V5LbiGWcmZ5Cm4N/rHmBNFtHd/VsMt5SODBu5zKK+FdeM+U+vS88FZAz7Xv4Q5H3QM
         JwwUt9yE5bIzCUI0QtHobHhDxfS6f0eVohoDImZ1g4RuxK1zrEHPc87i+EnZbqNDSD
         R4lz7+qh/M4CkAvxWa25aeTwNNID40L+lrU20KyydbmKD6HM5CJ1QV7dbxsqClVgIr
         EN4kk7npTsMyw==
Received: by mail-lf1-f50.google.com with SMTP id 2adb3069b0e04-4f004cc54f4so1355584e87.3
        for <linux-raid@vger.kernel.org>; Fri, 26 May 2023 14:13:42 -0700 (PDT)
X-Gm-Message-State: AC+VfDz0+Pdo4NAE5gsvx2X1JdxOuFfSMajEEcUp+wUNg3Ou4kaPSIJO
        9JyVwn9EuaPEHt3o9PG+1UCPVdPwC+N40a4UEB0=
X-Google-Smtp-Source: ACHHUZ66Bm5tFQ4OYJ4RsKII23iEsgS7xJNsOCBviDJ0KfyC0e9rY5n/qY2fby5JkObXx1eyUF9hxuO0l8fV+b5Y/kE=
X-Received: by 2002:a19:760b:0:b0:4f3:a08b:275e with SMTP id
 c11-20020a19760b000000b004f3a08b275emr1150941lff.53.1685135621039; Fri, 26
 May 2023 14:13:41 -0700 (PDT)
MIME-Version: 1.0
References: <CALTww28aV5CGXQAu46Rkc=fG1jK=ARzCT8VGoVyje8kQdqEXMg@mail.gmail.com>
 <ebe7fa31-2e9a-74da-bbbd-3d5238590a7c@linux.dev> <CALTww2_ks+Ac0hHkVS0mBaKi_E2r=Jq-7g2iubtCcKoVsZEbXQ@mail.gmail.com>
 <7e9fd8ba-aacd-3697-15fe-dc0b292bd177@linux.dev> <CALTww297Q+FAFMVBQd-1dT7neYrMjC-UZnAw8Q3UeuEoOCy6Yg@mail.gmail.com>
 <20230526111312.000065f2@linux.intel.com>
In-Reply-To: <20230526111312.000065f2@linux.intel.com>
From:   Song Liu <song@kernel.org>
Date:   Fri, 26 May 2023 14:13:28 -0700
X-Gmail-Original-Message-ID: <CAPhsuW4XKYDsEJsbJJX7mDdq_hhF1D8YLN5oyBi746EUtYVv8A@mail.gmail.com>
Message-ID: <CAPhsuW4XKYDsEJsbJJX7mDdq_hhF1D8YLN5oyBi746EUtYVv8A@mail.gmail.com>
Subject: Re: The read data is wrong from raid5 when recovery happens
To:     Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
Cc:     Xiao Ni <xni@redhat.com>, Guoqing Jiang <guoqing.jiang@linux.dev>,
        "Tkaczyk, Mariusz" <mariusz.tkaczyk@intel.com>,
        linux-raid <linux-raid@vger.kernel.org>,
        Heinz Mauelshagen <heinzm@redhat.com>,
        Nigel Croxon <ncroxon@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Fri, May 26, 2023 at 2:13=E2=80=AFAM Mariusz Tkaczyk
<mariusz.tkaczyk@linux.intel.com> wrote:
>
> On Fri, 26 May 2023 15:23:58 +0800
> Xiao Ni <xni@redhat.com> wrote:
>
> > On Fri, May 26, 2023 at 3:12=E2=80=AFPM Guoqing Jiang <guoqing.jiang@li=
nux.dev> wrote:
> > >
> > >
> > >
> > > On 5/26/23 14:45, Xiao Ni wrote:
> > > > On Fri, May 26, 2023 at 11:09=E2=80=AFAM Guoqing Jiang <guoqing.jia=
ng@linux.dev>
> > > > wrote:
> > > >>
> > > >>
> > > >> On 5/26/23 09:49, Xiao Ni wrote:
> > > >>> Hi all
> > > >>>
> > > >>> We found a problem recently. The read data is wrong when recovery
> > > >>> happens. Now we've found it's introduced by patch 10764815f (md: =
add io
> > > >>> accounting for raid0 and raid5). I can reproduce this 100%. This
> > > >>> problem exists in upstream. The test steps are like this:
> > > >>>
> > > >>> 1. mdadm -CR $devname -l5 -n4 /dev/sd[b-e] --force --assume-clean
> > > >>> 2. mkfs.ext4 -F $devname
> > > >>> 3. mount $devname $mount_point
> > > >>> 4. mdadm --incremental --fail sdd
> > > >>> 5. dd if=3D/dev/zero of=3D/tmp/pythontest/file1 bs=3D1M count=3D1=
00000
> > > >>> status=3Dprogress
> > >
> > > I suppose /tmp is the mount point.
> >
> > /tmp/pythontest is the mount point
> >
> > >
> > > >>> 6. mdadm /dev/md126 --add /dev/sdd
> > > >>> 7. create 31 processes that writes and reads. It compares the con=
tent
> > > >>> with md5sum. The test will go on until the recovery stops
> > >
> > > Could you share the test code/script for step 7? Will try it from my =
side.
> >
> > The test scripts are written by people from intel.
> > Hi, Mariusz. Can I share the test scripts here?
>
> Yes. Let us know if there is something else we can do to help here.

I tried to reproduce this with fio, but didn't get much luck. Please share
the test scripts.

Thanks,
Song
