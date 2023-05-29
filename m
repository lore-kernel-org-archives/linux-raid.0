Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3965DC7EE23
	for <linux-raid@archiver.kernel.org>; Mon, 29 May 2023 03:42:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230157AbjE2Dmr (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sun, 28 May 2023 23:42:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229958AbjE2Dmq (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sun, 28 May 2023 23:42:46 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1DEEAF
        for <linux-raid@vger.kernel.org>; Sun, 28 May 2023 20:41:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1685331719;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=RUsjTl0ysGV/mmmeIOYMDLaGnRoJDAQEFxAKquf76x0=;
        b=I6cZb4gmwwaXvZ6eaQLYhDM164dPPagLbAGLTA64wz1gjYfDnYP0SS69EcDsDFeM7FHH/q
        ooBb7NV4fTIC0m5q8HPuUrUpkyCk6665l4tHgsK7mkeuZErLIasUXu2BQjlz3H847LAZmd
        v3kHdv3Mj/XM1melynlDOst/5jxGjtY=
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com
 [209.85.214.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-364-dFfGItjFMnG-cq7gdOgJDQ-1; Sun, 28 May 2023 23:41:57 -0400
X-MC-Unique: dFfGItjFMnG-cq7gdOgJDQ-1
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-1b04600cac6so2726495ad.1
        for <linux-raid@vger.kernel.org>; Sun, 28 May 2023 20:41:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685331717; x=1687923717;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=RUsjTl0ysGV/mmmeIOYMDLaGnRoJDAQEFxAKquf76x0=;
        b=WFpn+rpB9fgpDA1V2RZr1wAnH263+H9tBNJKkW5+yflyAgGHo634GcoSWDc3KrcYBa
         /h1F939SRfcvK6zOAE9C/WAcGmfKnS+rcWWuBHUG+ENFv7WI0mwnVjohxwap6frTnC2J
         V6O9HuyBtZKFvlXV1FPEfHlp3je2ATvMhZ9mAljhsxz1SvAiVUPpMWknJwr1jH603k1c
         v+l+OtcGKXgU6efnE5Qr28OgpRIHlK0S75Vba2o8Exr44RHDHQnVch9BJRXhAdJfI99P
         ir0VPLKuTbn9Wu8rd09jBoJB1hitMUTY0o5mB2mg+TERK9VnoLlQbvLFRLdX+RTVcq1m
         NLNQ==
X-Gm-Message-State: AC+VfDz8kA1U2LAiPQH/O/ezfmhjbJDOr1AEQGyFxl3a+2K66vFv6sE3
        UCdp5UZToLN3hih7XRRUzECcZ5/4ni9RleaZCQtsINWVG+l3S4jQNwrWqC1sTT1hHptyuypauKI
        5KzdcxSK0M70i7bTVhVCz4GyBNt4c4/vDBqoEo+aEwcXhU4VL
X-Received: by 2002:a17:903:234f:b0:1ae:3e5b:31b1 with SMTP id c15-20020a170903234f00b001ae3e5b31b1mr12533480plh.9.1685331716710;
        Sun, 28 May 2023 20:41:56 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ7e+2knyJtBH1TBMSTHBSs37mU90hiBedwLMXy2L9ADleEZZTkFnpLJcjE2yVrCNB0tzpFD47AQdvEiG7l34X0=
X-Received: by 2002:a17:903:234f:b0:1ae:3e5b:31b1 with SMTP id
 c15-20020a170903234f00b001ae3e5b31b1mr12533464plh.9.1685331716431; Sun, 28
 May 2023 20:41:56 -0700 (PDT)
MIME-Version: 1.0
References: <CALTww28aV5CGXQAu46Rkc=fG1jK=ARzCT8VGoVyje8kQdqEXMg@mail.gmail.com>
 <ebe7fa31-2e9a-74da-bbbd-3d5238590a7c@linux.dev> <CALTww2_ks+Ac0hHkVS0mBaKi_E2r=Jq-7g2iubtCcKoVsZEbXQ@mail.gmail.com>
 <7e9fd8ba-aacd-3697-15fe-dc0b292bd177@linux.dev> <CALTww297Q+FAFMVBQd-1dT7neYrMjC-UZnAw8Q3UeuEoOCy6Yg@mail.gmail.com>
 <f4bff813-343f-6601-b2f8-c1c54fa1e5a1@linux.dev>
In-Reply-To: <f4bff813-343f-6601-b2f8-c1c54fa1e5a1@linux.dev>
From:   Xiao Ni <xni@redhat.com>
Date:   Mon, 29 May 2023 11:41:45 +0800
Message-ID: <CALTww29ww7sOwLFR=waX4b2bik=ZAiCW7mMEtg8jsoAHqxvHcQ@mail.gmail.com>
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

On Mon, May 29, 2023 at 10:27=E2=80=AFAM Guoqing Jiang <guoqing.jiang@linux=
.dev> wrote:
>
>
>
> On 5/26/23 15:23, Xiao Ni wrote:
> >
> >>>>> 6. mdadm /dev/md126 --add /dev/sdd
> >>>>> 7. create 31 processes that writes and reads. It compares the conte=
nt with
> >>>>> md5sum. The test will go on until the recovery stops
> >> Could you share the test code/script for step 7? Will try it from my s=
ide.
> > The test scripts are written by people from intel.
> > Hi, Mariusz. Can I share the test scripts here?
> >
> >>>>> 8. wait for about 10 minutes, we can see some processes report chec=
ksum is
> >>>>> wrong. But if it re-read the data again, the checksum will be good.
> >> So it is interim, I guess it appeared before recover was finished.
> > Yes, it appears before recovery finishes. The test will finish once
> > the recovery finishes.
> >
> >>>>> I tried to narrow this problem like this:
> >>>>>
> >>>>> -       md_account_bio(mddev, &bi);
> >>>>> +       if (rw =3D=3D WRITE)
> >>>>> +               md_account_bio(mddev, &bi);
> >>>>> If it only do account for write requests, the problem can disappear=
.
> >>>>>
> >>>>> -       if (rw =3D=3D READ && mddev->degraded =3D=3D 0 &&
> >>>>> -           mddev->reshape_position =3D=3D MaxSector) {
> >>>>> -               bi =3D chunk_aligned_read(mddev, bi);
> >>>>> -               if (!bi)
> >>>>> -                       return true;
> >>>>> -       }
> >>>>> +       //if (rw =3D=3D READ && mddev->degraded =3D=3D 0 &&
> >>>>> +       //    mddev->reshape_position =3D=3D MaxSector) {
> >>>>> +       //      bi =3D chunk_aligned_read(mddev, bi);
> >>>>> +       //      if (!bi)
> >>>>> +       //              return true;
> >>>>> +       //}
> >>>>>
> >>>>>            if (unlikely(bio_op(bi) =3D=3D REQ_OP_DISCARD)) {
> >>>>>                    make_discard_request(mddev, bi);
> >>>>> @@ -6180,7 +6180,8 @@ static bool raid5_make_request(struct mddev *=
mddev,
> >>>>> struct bio * bi)
> >>>>>                            md_write_end(mddev);
> >>>>>                    return true;
> >>>>>            }
> >>>>> -       md_account_bio(mddev, &bi);
> >>>>> +       if (rw =3D=3D READ)
> >>>>> +               md_account_bio(mddev, &bi);
> >>>>>
> >>>>> I comment the chunk_aligned_read out and only account for read requ=
ests,
> >>>>> this problem can be reproduced.
>
> Only write bio and non aligned chunk read bio call md_account_bio, and
> only account
> write bio is fine per your test. It means the md5sum didn't match
> because of non aligned
> chunk read bio, so it is not abnormal that data in another chunk could
> be changed with
> the recovery is not finished, right?

That's right, only non aligned read requests can cause this problem.
Good catch. If I understand right, you mean the non aligned read
request reads data from the chunk which hasn't been recovered, right?

>
> BTW, I had run the test with bio accounting disabled by default, and
> seems the result is
> same.
>
> > git tag  --sort=3Dtaggerdate --contain 10764815f |head -1
> v5.14-rc1
>
> localhost:~/readdata #uname -r
> 5.15.0-rc4-59.24-default
> localhost:~/readdata #cat /sys/block/md126/queue/iostats
> 0
>
> And I can still see relevant log from the terminal which runs 01-test.sh

Hmm, thanks for this. I'll have a try again. Which kind of disks do
you use for testing?

Regards
Xiao
>
> file /tmp/pythontest/data.out.nhoBR6 Test failed
> (org_checksum|checksum_to_match) [582df4ccea6f5851462379fe4b17abf6
>   -|d41d8cd98f00b204e9800998ec
> f8427e  -]
> file /tmp/pythontest/data.out.nhoBR6 calculate checksum again:
> d41d8cd98f00b204e9800998ecf8427e  -
>
> file /tmp/pythontest/data.out.srGqF9 Test failed
> (org_checksum|checksum_to_match) [7a85ec35b171e52ce41ebdd5da86f1d9
>   -|d41d8cd98f00b204e9800998ec
> f8427e  -]
> file /tmp/pythontest/data.out.srGqF9 calculate checksum again:
> d41d8cd98f00b204e9800998ecf8427e  -
> ...
>
> file /tmp/pythontest/data.out.q6m1kK Test failed
> (org_checksum|checksum_to_match) [996f5bb5d2a2ddfd378a80a563ab4ad5
>   -|d41d8cd98f00b204e9800998ec
> f8427e  -]
> file /tmp/pythontest/data.out.q6m1kK calculate checksum again:
> d41d8cd98f00b204e9800998ecf8427e  -
>
> Rebuild ended, testing done!
> stresstest end at : Sun May 28 22:23:53 EDT 2023
> Sun May 28 22:23:53 EDT 2023
>
> Thanks,
> Guoqing
>

