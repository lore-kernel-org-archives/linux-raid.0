Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE41EC77B7A
	for <linux-raid@archiver.kernel.org>; Fri, 26 May 2023 07:24:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241979AbjEZHY6 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 26 May 2023 03:24:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229681AbjEZHY4 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 26 May 2023 03:24:56 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87AF799
        for <linux-raid@vger.kernel.org>; Fri, 26 May 2023 00:24:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1685085852;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0aPfW/ijupAZdbBKiLpPc2szk8MTC7v/4jO/Wvb70Js=;
        b=b1DQC5LolcJUCvzl13MLz7S52o1P7fM1USD0AvDHj1+NVriwhiQDMZXtfePvUl3n70MGTv
        /tlvBkdGDeYh6G8T7LhLqA25qhR4ng9L8iuW8WSRC8gc6TN20NjmRx8IC+Ntg1TjDoFcFW
        hFr9/Pv93+l6VpV0GEFifHkMCet6o1A=
Received: from mail-pg1-f198.google.com (mail-pg1-f198.google.com
 [209.85.215.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-145-mQR8PPrLMZ6DgeUARVFRcQ-1; Fri, 26 May 2023 03:24:11 -0400
X-MC-Unique: mQR8PPrLMZ6DgeUARVFRcQ-1
Received: by mail-pg1-f198.google.com with SMTP id 41be03b00d2f7-52857fc23b1so552056a12.2
        for <linux-raid@vger.kernel.org>; Fri, 26 May 2023 00:24:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685085850; x=1687677850;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0aPfW/ijupAZdbBKiLpPc2szk8MTC7v/4jO/Wvb70Js=;
        b=QPpIq0ND2oi8wDdRc62RbV2o4vILeloLGJCTjk1wPxdjKdGzCClZSpg6pOWFB7/jN4
         n5NRLGm7V6X6DuEJBvCuPJ7YpKnOEmBkd9Z4Fp75pYTWEpJcOgEAC1yOZLBTsb46yNHE
         IAeRjR9Zx5ZKXB08apa7Qt9hWR/SODdQIkG49Uc+R5l9Gzv2qie2sOFhM5NjeaFs3l4a
         brvfouftHc5njtDqrbd2+bsAGlluoXBwpF+cpGyxVpvzKThi+DTed1aFjku5edIMLAxw
         IB6HANpmlf5LB/qpy6cJjsGUgomrd4aH+t/bapeAc75202rym8rM+TSpcl5nrMPGIMzh
         HDlQ==
X-Gm-Message-State: AC+VfDzyH3CUu0RlLyTrLloiws5EMJ1lVuVoPweyvn0DbZXKcHhWXYlq
        jRgInSNC29Q6Q01nniz3TDF7YOo4wTKmi3g5rKOwQXqKJFX0PCBCFOrWPKY8mH6H7Trf4IlBgy2
        AA7I+OABJ0ZloGhRUmHZWLftfHEzxqXHlFrr3kg==
X-Received: by 2002:a05:6a20:12c6:b0:10b:97c8:2e12 with SMTP id v6-20020a056a2012c600b0010b97c82e12mr1155865pzg.60.1685085850171;
        Fri, 26 May 2023 00:24:10 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ6LSw1ZL/01feUzWp9jfLaA/GywCgZeSnpcpTZC1/0KE5JF1OiEo1IBtjSTt1hSzRnnsCuaQALNuLSrCRefJG4=
X-Received: by 2002:a05:6a20:12c6:b0:10b:97c8:2e12 with SMTP id
 v6-20020a056a2012c600b0010b97c82e12mr1155843pzg.60.1685085849927; Fri, 26 May
 2023 00:24:09 -0700 (PDT)
MIME-Version: 1.0
References: <CALTww28aV5CGXQAu46Rkc=fG1jK=ARzCT8VGoVyje8kQdqEXMg@mail.gmail.com>
 <ebe7fa31-2e9a-74da-bbbd-3d5238590a7c@linux.dev> <CALTww2_ks+Ac0hHkVS0mBaKi_E2r=Jq-7g2iubtCcKoVsZEbXQ@mail.gmail.com>
 <7e9fd8ba-aacd-3697-15fe-dc0b292bd177@linux.dev>
In-Reply-To: <7e9fd8ba-aacd-3697-15fe-dc0b292bd177@linux.dev>
From:   Xiao Ni <xni@redhat.com>
Date:   Fri, 26 May 2023 15:23:58 +0800
Message-ID: <CALTww297Q+FAFMVBQd-1dT7neYrMjC-UZnAw8Q3UeuEoOCy6Yg@mail.gmail.com>
Subject: Re: The read data is wrong from raid5 when recovery happens
To:     Guoqing Jiang <guoqing.jiang@linux.dev>,
        "Tkaczyk, Mariusz" <mariusz.tkaczyk@intel.com>
Cc:     Song Liu <song@kernel.org>,
        linux-raid <linux-raid@vger.kernel.org>,
        Heinz Mauelshagen <heinzm@redhat.com>,
        Nigel Croxon <ncroxon@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Fri, May 26, 2023 at 3:12=E2=80=AFPM Guoqing Jiang <guoqing.jiang@linux.=
dev> wrote:
>
>
>
> On 5/26/23 14:45, Xiao Ni wrote:
> > On Fri, May 26, 2023 at 11:09=E2=80=AFAM Guoqing Jiang <guoqing.jiang@l=
inux.dev> wrote:
> >>
> >>
> >> On 5/26/23 09:49, Xiao Ni wrote:
> >>> Hi all
> >>>
> >>> We found a problem recently. The read data is wrong when recovery hap=
pens.
> >>> Now we've found it's introduced by patch 10764815f (md: add io accoun=
ting
> >>> for raid0 and raid5). I can reproduce this 100%. This problem exists =
in
> >>> upstream. The test steps are like this:
> >>>
> >>> 1. mdadm -CR $devname -l5 -n4 /dev/sd[b-e] --force --assume-clean
> >>> 2. mkfs.ext4 -F $devname
> >>> 3. mount $devname $mount_point
> >>> 4. mdadm --incremental --fail sdd
> >>> 5. dd if=3D/dev/zero of=3D/tmp/pythontest/file1 bs=3D1M count=3D10000=
0 status=3Dprogress
>
> I suppose /tmp is the mount point.

/tmp/pythontest is the mount point

>
> >>> 6. mdadm /dev/md126 --add /dev/sdd
> >>> 7. create 31 processes that writes and reads. It compares the content=
 with
> >>> md5sum. The test will go on until the recovery stops
>
> Could you share the test code/script for step 7? Will try it from my side=
.

The test scripts are written by people from intel.
Hi, Mariusz. Can I share the test scripts here?

>
> >>> 8. wait for about 10 minutes, we can see some processes report checks=
um is
> >>> wrong. But if it re-read the data again, the checksum will be good.
>
> So it is interim, I guess it appeared before recover was finished.

Yes, it appears before recovery finishes. The test will finish once
the recovery finishes.

>
> >>> I tried to narrow this problem like this:
> >>>
> >>> -       md_account_bio(mddev, &bi);
> >>> +       if (rw =3D=3D WRITE)
> >>> +               md_account_bio(mddev, &bi);
> >>> If it only do account for write requests, the problem can disappear.
> >>>
> >>> -       if (rw =3D=3D READ && mddev->degraded =3D=3D 0 &&
> >>> -           mddev->reshape_position =3D=3D MaxSector) {
> >>> -               bi =3D chunk_aligned_read(mddev, bi);
> >>> -               if (!bi)
> >>> -                       return true;
> >>> -       }
> >>> +       //if (rw =3D=3D READ && mddev->degraded =3D=3D 0 &&
> >>> +       //    mddev->reshape_position =3D=3D MaxSector) {
> >>> +       //      bi =3D chunk_aligned_read(mddev, bi);
> >>> +       //      if (!bi)
> >>> +       //              return true;
> >>> +       //}
> >>>
> >>>           if (unlikely(bio_op(bi) =3D=3D REQ_OP_DISCARD)) {
> >>>                   make_discard_request(mddev, bi);
> >>> @@ -6180,7 +6180,8 @@ static bool raid5_make_request(struct mddev *md=
dev,
> >>> struct bio * bi)
> >>>                           md_write_end(mddev);
> >>>                   return true;
> >>>           }
> >>> -       md_account_bio(mddev, &bi);
> >>> +       if (rw =3D=3D READ)
> >>> +               md_account_bio(mddev, &bi);
> >>>
> >>> I comment the chunk_aligned_read out and only account for read reques=
ts,
> >>> this problem can be reproduced.
> >> After a quick look,raid5_read_one_chunk clones bio by itself, so no ne=
ed to
> >> do it for the chunk aligned readcase. Could you pls try this?
>
> [...]
>
> >> Hi Guoqing
> >>
> >> When chunk_aligned_read runs successfully, it just returns. In this
> >> case, it does the account by itself. If it fails to execute, it still
> >> needs run md_account_bio in raid5_make_request. So now the logic
> >> should be right.
>
> Hmm, I was confused.

Which part?
>
> Thanks,
> Guoqing
>


--=20
Best Regards
Xiao Ni

