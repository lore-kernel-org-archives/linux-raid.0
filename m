Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5CE03C77B7A
	for <linux-raid@archiver.kernel.org>; Mon, 29 May 2023 08:41:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231504AbjE2Iln (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 29 May 2023 04:41:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229628AbjE2IlX (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 29 May 2023 04:41:23 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28D2CA4
        for <linux-raid@vger.kernel.org>; Mon, 29 May 2023 01:40:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1685349634;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NKES7g50AXOp3sHX08Y91bYbQIdIEMzdcjfDAmd8YNk=;
        b=ZzxeIwiHxkyZv5Geh8WpGxbmqyC/atDOD+vlCQw55wxGi5NV4RQp9fx6+DF7riRtDa4GM6
        HvVBadXT0qah0ynxej35OC2TDv/Mc19s3YTHNYM9N+iMT1SgSVW2kV6EC3MEyWR/vJz0mM
        Elezt3DaM7NVUw+JdQULIULmUabWF2c=
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com
 [209.85.216.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-184-_NfrQSLFOLmr-CaLdSiM_A-1; Mon, 29 May 2023 04:40:32 -0400
X-MC-Unique: _NfrQSLFOLmr-CaLdSiM_A-1
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-2553b096ddfso2650069a91.1
        for <linux-raid@vger.kernel.org>; Mon, 29 May 2023 01:40:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685349631; x=1687941631;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=NKES7g50AXOp3sHX08Y91bYbQIdIEMzdcjfDAmd8YNk=;
        b=MmZJI3YOiQAglwGiZwfGuW82I0580vyAO0CvLDNJPDeyVHhJeMdkNp6zvZZM5k5Z1n
         AkqbWQy3P/rQNKtCSKbeOC4A5W8FOLLquRL26OzkZNosl+ZuZqJAOweyvVzirCxBEfb+
         3ddf37Bli4TSXSFQnmBmN5gdIBnUQ+Aa1JTmd12h5AVZPbQJ9wGxfWiobwmR8CJNfWo+
         Y7PTckVix1wMDxuqLmX6QXJmkwVuVvfJRa/t+LuB2mwwKQ3/tZLJvRrtAIclGM6EPMLg
         JfZAp06b03CWk3GcgBJhcxSQk4tBSOj/sek1kTUeuOBdgHyU42eVfQzTUPGhVUDq0G05
         9cBA==
X-Gm-Message-State: AC+VfDwuKH07grtCt/DaNusUf/CgZAKbN98+Qbjj6s8pbWkFPim0gSGQ
        up07f7ovTVq/PJJzT/qlk8OJNpo0p5ArcrrlXG8LPkzzuRFdVhJn/Z2Hq1tnB5Ancm++XcHoGT5
        2e0mq9mUayfEqotStmY5EDHcYuNZKvenk21Pr9+WX66HVq9ASNQ8=
X-Received: by 2002:a17:90b:1190:b0:256:6462:e399 with SMTP id gk16-20020a17090b119000b002566462e399mr4983983pjb.5.1685349631573;
        Mon, 29 May 2023 01:40:31 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ6tnl1xS9SCCXRXOTA2WhoEJlLaGtZXsrwl4cIc8uXHR4nRyIj6JJNwR+9OVC9pzIItk54JEN0olU+vfrgIwVE=
X-Received: by 2002:a17:90b:1190:b0:256:6462:e399 with SMTP id
 gk16-20020a17090b119000b002566462e399mr4983966pjb.5.1685349631263; Mon, 29
 May 2023 01:40:31 -0700 (PDT)
MIME-Version: 1.0
References: <CALTww28aV5CGXQAu46Rkc=fG1jK=ARzCT8VGoVyje8kQdqEXMg@mail.gmail.com>
 <ebe7fa31-2e9a-74da-bbbd-3d5238590a7c@linux.dev> <CALTww2_ks+Ac0hHkVS0mBaKi_E2r=Jq-7g2iubtCcKoVsZEbXQ@mail.gmail.com>
 <7e9fd8ba-aacd-3697-15fe-dc0b292bd177@linux.dev> <CALTww297Q+FAFMVBQd-1dT7neYrMjC-UZnAw8Q3UeuEoOCy6Yg@mail.gmail.com>
 <f4bff813-343f-6601-b2f8-c1c54fa1e5a1@linux.dev> <CALTww29ww7sOwLFR=waX4b2bik=ZAiCW7mMEtg8jsoAHqxvHcQ@mail.gmail.com>
 <71c45b69-770a-0c28-3bd2-a4bd1a18bc2d@linux.dev>
In-Reply-To: <71c45b69-770a-0c28-3bd2-a4bd1a18bc2d@linux.dev>
From:   Xiao Ni <xni@redhat.com>
Date:   Mon, 29 May 2023 16:40:20 +0800
Message-ID: <CALTww2_vmryrM1V+Cr8FKj3TRv0qEGjYNzv6nStj=LnM8QKSuw@mail.gmail.com>
Subject: Re: The read data is wrong from raid5 when recovery happens
To:     Guoqing Jiang <guoqing.jiang@linux.dev>
Cc:     "Tkaczyk, Mariusz" <mariusz.tkaczyk@intel.com>,
        Song Liu <song@kernel.org>,
        linux-raid <linux-raid@vger.kernel.org>,
        Heinz Mauelshagen <heinzm@redhat.com>,
        Nigel Croxon <ncroxon@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Mon, May 29, 2023 at 4:34=E2=80=AFPM Guoqing Jiang <guoqing.jiang@linux.=
dev> wrote:
>
>
>
> On 5/29/23 11:41, Xiao Ni wrote:
> > On Mon, May 29, 2023 at 10:27=E2=80=AFAM Guoqing Jiang <guoqing.jiang@l=
inux.dev> wrote:
> >>
> >>
> >> On 5/26/23 15:23, Xiao Ni wrote:
> >>>>>>> 6. mdadm /dev/md126 --add /dev/sdd
> >>>>>>> 7. create 31 processes that writes and reads. It compares the con=
tent with
> >>>>>>> md5sum. The test will go on until the recovery stops
> >>>> Could you share the test code/script for step 7? Will try it from my=
 side.
> >>> The test scripts are written by people from intel.
> >>> Hi, Mariusz. Can I share the test scripts here?
> >>>
> >>>>>>> 8. wait for about 10 minutes, we can see some processes report ch=
ecksum is
> >>>>>>> wrong. But if it re-read the data again, the checksum will be goo=
d.
> >>>> So it is interim, I guess it appeared before recover was finished.
> >>> Yes, it appears before recovery finishes. The test will finish once
> >>> the recovery finishes.
> >>>
> >>>>>>> I tried to narrow this problem like this:
> >>>>>>>
> >>>>>>> -       md_account_bio(mddev, &bi);
> >>>>>>> +       if (rw =3D=3D WRITE)
> >>>>>>> +               md_account_bio(mddev, &bi);
> >>>>>>> If it only do account for write requests, the problem can disappe=
ar.
> >>>>>>>
> >>>>>>> -       if (rw =3D=3D READ && mddev->degraded =3D=3D 0 &&
> >>>>>>> -           mddev->reshape_position =3D=3D MaxSector) {
> >>>>>>> -               bi =3D chunk_aligned_read(mddev, bi);
> >>>>>>> -               if (!bi)
> >>>>>>> -                       return true;
> >>>>>>> -       }
> >>>>>>> +       //if (rw =3D=3D READ && mddev->degraded =3D=3D 0 &&
> >>>>>>> +       //    mddev->reshape_position =3D=3D MaxSector) {
> >>>>>>> +       //      bi =3D chunk_aligned_read(mddev, bi);
> >>>>>>> +       //      if (!bi)
> >>>>>>> +       //              return true;
> >>>>>>> +       //}
> >>>>>>>
> >>>>>>>             if (unlikely(bio_op(bi) =3D=3D REQ_OP_DISCARD)) {
> >>>>>>>                     make_discard_request(mddev, bi);
> >>>>>>> @@ -6180,7 +6180,8 @@ static bool raid5_make_request(struct mddev=
 *mddev,
> >>>>>>> struct bio * bi)
> >>>>>>>                             md_write_end(mddev);
> >>>>>>>                     return true;
> >>>>>>>             }
> >>>>>>> -       md_account_bio(mddev, &bi);
> >>>>>>> +       if (rw =3D=3D READ)
> >>>>>>> +               md_account_bio(mddev, &bi);
> >>>>>>>
> >>>>>>> I comment the chunk_aligned_read out and only account for read re=
quests,
> >>>>>>> this problem can be reproduced.
> >> Only write bio and non aligned chunk read bio call md_account_bio, and
> >> only account write bio is fine per your test. It means the md5sum didn=
't match
> >> because of non aligned chunk read bio, so it is not abnormal that data=
 in another chunk could
> >> be changed with the recovery is not finished, right?
> > That's right, only non aligned read requests can cause this problem.
> > Good catch. If I understand right, you mean the non aligned read
> > request reads data from the chunk which hasn't been recovered, right?
>
> Yes, I don't think compare md5sum for such scenario makes more sense give=
n
> the state is interim. And it also appeared in my test with disable io
> accounting.

It's the data which customers read that can be wrong. So it's a
dangerous thing. Because customers use the data directly. If it's true
it looks like there is a race between non aligned read and recovery
process.

Regards
Xiao

>
> >> BTW, I had run the test with bio accounting disabled by default, and
> >> seems the result is
> >> same.
> >>
> >>> git tag  --sort=3Dtaggerdate --contain 10764815f |head -1
> >> v5.14-rc1
> >>
> >> localhost:~/readdata #uname -r
> >> 5.15.0-rc4-59.24-default
> >> localhost:~/readdata #cat /sys/block/md126/queue/iostats
> >> 0
> >>
> >> And I can still see relevant log from the terminal which runs 01-test.=
sh
> > Hmm, thanks for this. I'll have a try again. Which kind of disks do
> > you use for testing?
>
> Four SCSI disks (1G capacity) inside VM.
>
> Thanks,
> Guoqing
>

