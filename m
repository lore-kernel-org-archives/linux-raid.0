Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67BD4C7EE2E
	for <linux-raid@archiver.kernel.org>; Mon, 29 May 2023 13:52:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229909AbjE2Nwz (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 29 May 2023 09:52:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229955AbjE2Nwh (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 29 May 2023 09:52:37 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C68BC9
        for <linux-raid@vger.kernel.org>; Mon, 29 May 2023 06:51:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1685368310;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=pCSVq5dGCcWOYq8IYHh6gjj3yVkuHYXp9V2U4/sAQwQ=;
        b=FlQQIA0X0vaknpsqaUkw0D+CaXvGA/4XI8Nn9/yrreWpOCEmhXeBFSau9VyQhbjbMe/M/+
        /dgk9f9PDA3F4qrX4PIeQ8wOmgWdTNuPD5xKEHonb8BRIklx6uQ6DND2F935G+vxKpxmyr
        mHAndS2cpQ74fcN7LGRxTQa04nzL3Go=
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com
 [209.85.214.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-489-O7gVOoPpOyCfOW4GixWAdg-1; Mon, 29 May 2023 09:51:49 -0400
X-MC-Unique: O7gVOoPpOyCfOW4GixWAdg-1
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-1b03ae23cf7so8211785ad.3
        for <linux-raid@vger.kernel.org>; Mon, 29 May 2023 06:51:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685368308; x=1687960308;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pCSVq5dGCcWOYq8IYHh6gjj3yVkuHYXp9V2U4/sAQwQ=;
        b=ldt4c7NxtrXcUFPDpoacty5Vi3iU5DnH+XvjyWTePkmkZj9lTyR/Ix4IDiClzcnfk/
         /vbmWC5AgQaI20gKn6ae6RbxfutvgiBqywPBvqZMd+i4anMIl9p1+5fFWMHVccucs9vk
         iJb4mX5OhFqqUY+rYLISImpFkl8l81HSRmW3L0uqlpD68/49AypynYYZkn82xyxYmh4Y
         boy7cOhG1uxvh3xqezTm67pTOVk1ZkJ+Q6nErjI3Zv5EWJeQFjIXsjLm/5rg1RZbhQHJ
         yCJBR5zKlry8G4pDZsf8t5TKrHXw/5AaVd56AIC5UnMjIrrEXua598EatYGhaXS7Q1b6
         BteQ==
X-Gm-Message-State: AC+VfDyzi6fwwwOAkvRjdndiDPjZCj0Cz4/F+QBViGcMPP6dyP7J3eyH
        cFR6jo3DukpvMrwuYxkyYxomL7QPUD1sV2KpwgHRpn9h5+Y5HOMb6bYzJ4tXqIrovE/wFYkcR5P
        x6KnL26BtkmE5WNXqczKIE1mYO8YpdDOc2aWnbQ==
X-Received: by 2002:a17:902:e888:b0:1b0:48e9:cddc with SMTP id w8-20020a170902e88800b001b048e9cddcmr2412951plg.28.1685368308286;
        Mon, 29 May 2023 06:51:48 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ6D53Ql0cBEvzyIf2klJxlAe3cVlZPPXvI4ZhhG9LAlpl+s5XoAB2QdszbpkNZCL79ZhRSZjSu0SnmrIK5pUs0=
X-Received: by 2002:a17:902:e888:b0:1b0:48e9:cddc with SMTP id
 w8-20020a170902e88800b001b048e9cddcmr2412933plg.28.1685368308009; Mon, 29 May
 2023 06:51:48 -0700 (PDT)
MIME-Version: 1.0
References: <CALTww28aV5CGXQAu46Rkc=fG1jK=ARzCT8VGoVyje8kQdqEXMg@mail.gmail.com>
 <ebe7fa31-2e9a-74da-bbbd-3d5238590a7c@linux.dev> <CALTww2_ks+Ac0hHkVS0mBaKi_E2r=Jq-7g2iubtCcKoVsZEbXQ@mail.gmail.com>
 <7e9fd8ba-aacd-3697-15fe-dc0b292bd177@linux.dev> <CALTww297Q+FAFMVBQd-1dT7neYrMjC-UZnAw8Q3UeuEoOCy6Yg@mail.gmail.com>
 <f4bff813-343f-6601-b2f8-c1c54fa1e5a1@linux.dev>
In-Reply-To: <f4bff813-343f-6601-b2f8-c1c54fa1e5a1@linux.dev>
From:   Xiao Ni <xni@redhat.com>
Date:   Mon, 29 May 2023 21:51:36 +0800
Message-ID: <CALTww29N5-WFKH9JG8yzcYyHy5v+5D-NR2jd=fe5fG6tAF2_-w@mail.gmail.com>
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

I can reproduce this after setting /sys/block/md126/queue/iostats to
0. But if I comment md_account_bio, this can't be reproduced. If
setting iostats to 0, md_account_bio only checks the bit
QUEUE_FLAG_IO_STAT of the request queue of md126. In
chunk_aligned_read, it can split the original bio and returns the
split bio if it can't do the align read. Are there problems in this
case?

Regards
Xiao
>
> And I can still see relevant log from the terminal which runs 01-test.sh
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

