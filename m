Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6AB7BC77B7C
	for <linux-raid@archiver.kernel.org>; Fri, 26 May 2023 06:47:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241882AbjEZGrS (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 26 May 2023 02:47:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236735AbjEZGrR (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 26 May 2023 02:47:17 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 238CCBC
        for <linux-raid@vger.kernel.org>; Thu, 25 May 2023 23:46:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1685083595;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hGQZioCBRpks7iAcNZVQj4STYY/lTiOJKPxRagejLtA=;
        b=STYcs+oBSIKTfrR9G/E9OWgK+yigLvpumY6GNlORgKwSL6e/bTz/7freu9R4MVViR5AHLt
        kGtOMvYqp7nmloOuZvfL1WlyhbjhdAuZemtbqs8WbU9sPR5iIBNoI2xOLTBuRgNRcAFFmQ
        VuFqhayOc1+4aIJQjQN3SGxO9dDgB7Y=
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com
 [209.85.214.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-67-dKUichOfMUCMaXyt3LsAGw-1; Fri, 26 May 2023 02:46:01 -0400
X-MC-Unique: dKUichOfMUCMaXyt3LsAGw-1
Received: by mail-pl1-f200.google.com with SMTP id d9443c01a7336-1ae437c2b32so3224635ad.2
        for <linux-raid@vger.kernel.org>; Thu, 25 May 2023 23:46:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685083560; x=1687675560;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hGQZioCBRpks7iAcNZVQj4STYY/lTiOJKPxRagejLtA=;
        b=hhDccMD575NcvZzn+BobVxGIxmpsw5ice2g3uCUeb0uAp9KomPbxjPDH60lykMIU2q
         4WHCMjB+AN04bHWhShwMZvIhBbSCT9u9KPdpkeDktVetIu7xDiFAyIMDEcITA9ooYZ6E
         zZwrlIzx8roj1AfCX5nvM6y8h7ife+8NB9AYARwiDDYiDeN31Y0VfuwSz3yJcUqbcqc6
         OirbR5JNYcLFTcgKMnoznUI1lziuJU6gD7Y5/ssDEbizjchqDEeC6CnMUFzqgQgSF3Am
         9Y8bD2Rn74MsR3CX5fwEMkZaH1HAVE9FusFrncjRwcgHlY38Rz/BO0HN89+CLfScYWvR
         IaSw==
X-Gm-Message-State: AC+VfDzbtO5W+/5TxX0kEYOqHpLy/NStHustYtYBeaB9l1pssVmBs0vr
        caczV53XZVBOeT0qMM26P2HB+SVdT0TYFkGNZEDsjDUYy2s/0GKM/cu+w/TZKw7FvV9asmLx8rK
        21iCZ9/j1uF76iqA5DchGBdX8KDhXR5kbHlWkEw==
X-Received: by 2002:a17:902:6a82:b0:1ae:4ee3:e3e6 with SMTP id n2-20020a1709026a8200b001ae4ee3e3e6mr1251796plk.32.1685083560143;
        Thu, 25 May 2023 23:46:00 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ4oUCfsZpbz6pMDENnI/3nizoycTiLeYphULZpWOHeJIz4Oy0JUoKqtP65NqdXTIN77FjH9/7MIgSiSIjWFd/4=
X-Received: by 2002:a17:902:6a82:b0:1ae:4ee3:e3e6 with SMTP id
 n2-20020a1709026a8200b001ae4ee3e3e6mr1251782plk.32.1685083559832; Thu, 25 May
 2023 23:45:59 -0700 (PDT)
MIME-Version: 1.0
References: <CALTww28aV5CGXQAu46Rkc=fG1jK=ARzCT8VGoVyje8kQdqEXMg@mail.gmail.com>
 <ebe7fa31-2e9a-74da-bbbd-3d5238590a7c@linux.dev>
In-Reply-To: <ebe7fa31-2e9a-74da-bbbd-3d5238590a7c@linux.dev>
From:   Xiao Ni <xni@redhat.com>
Date:   Fri, 26 May 2023 14:45:48 +0800
Message-ID: <CALTww2_ks+Ac0hHkVS0mBaKi_E2r=Jq-7g2iubtCcKoVsZEbXQ@mail.gmail.com>
Subject: Re: The read data is wrong from raid5 when recovery happens
To:     Guoqing Jiang <guoqing.jiang@linux.dev>
Cc:     Song Liu <song@kernel.org>,
        linux-raid <linux-raid@vger.kernel.org>,
        Heinz Mauelshagen <heinzm@redhat.com>,
        Nigel Croxon <ncroxon@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Fri, May 26, 2023 at 11:09=E2=80=AFAM Guoqing Jiang <guoqing.jiang@linux=
.dev> wrote:
>
>
>
> On 5/26/23 09:49, Xiao Ni wrote:
> > Hi all
> >
> > We found a problem recently. The read data is wrong when recovery happe=
ns.
> > Now we've found it's introduced by patch 10764815f (md: add io accounti=
ng
> > for raid0 and raid5). I can reproduce this 100%. This problem exists in
> > upstream. The test steps are like this:
> >
> > 1. mdadm -CR $devname -l5 -n4 /dev/sd[b-e] --force --assume-clean
> > 2. mkfs.ext4 -F $devname
> > 3. mount $devname $mount_point
> > 4. mdadm --incremental --fail sdd
> > 5. dd if=3D/dev/zero of=3D/tmp/pythontest/file1 bs=3D1M count=3D100000
> > status=3Dprogress
> > 6. mdadm /dev/md126 --add /dev/sdd
> > 7. create 31 processes that writes and reads. It compares the content w=
ith
> > md5sum. The test will go on until the recovery stops
> > 8. wait for about 10 minutes, we can see some processes report checksum=
 is
> > wrong. But if it re-read the data again, the checksum will be good.
> >
> > I tried to narrow this problem like this:
> >
> > -       md_account_bio(mddev, &bi);
> > +       if (rw =3D=3D WRITE)
> > +               md_account_bio(mddev, &bi);
> > If it only do account for write requests, the problem can disappear.
> >
> > -       if (rw =3D=3D READ && mddev->degraded =3D=3D 0 &&
> > -           mddev->reshape_position =3D=3D MaxSector) {
> > -               bi =3D chunk_aligned_read(mddev, bi);
> > -               if (!bi)
> > -                       return true;
> > -       }
> > +       //if (rw =3D=3D READ && mddev->degraded =3D=3D 0 &&
> > +       //    mddev->reshape_position =3D=3D MaxSector) {
> > +       //      bi =3D chunk_aligned_read(mddev, bi);
> > +       //      if (!bi)
> > +       //              return true;
> > +       //}
> >
> >          if (unlikely(bio_op(bi) =3D=3D REQ_OP_DISCARD)) {
> >                  make_discard_request(mddev, bi);
> > @@ -6180,7 +6180,8 @@ static bool raid5_make_request(struct mddev *mdde=
v,
> > struct bio * bi)
> >                          md_write_end(mddev);
> >                  return true;
> >          }
> > -       md_account_bio(mddev, &bi);
> > +       if (rw =3D=3D READ)
> > +               md_account_bio(mddev, &bi);
> >
> > I comment the chunk_aligned_read out and only account for read requests=
,
> > this problem can be reproduced.
>
> After a quick look,raid5_read_one_chunk clones bio by itself, so no need =
to
> do it for the chunk aligned readcase. Could you pls try this?
>
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -6120,6 +6120,7 @@static bool raid5_make_request(struct mddev *mddev,
> struct bio * bi)
>         const int rw =3D bio_data_dir(bi);
>         enum stripe_result res;
>         int s, stripe_cnt;
> +bool account_bio =3D true;
>
>         if (unlikely(bi->bi_opf & REQ_PREFLUSH)) {
>                 int ret =3D log_handle_flush_request(conf, bi);
> @@ -6148,6 +6149,7 @@static bool raid5_make_request(struct mddev *mddev,
> struct bio * bi)
>         if (rw =3D=3D READ && mddev->degraded =3D=3D 0 &&
>             mddev->reshape_position =3D=3D MaxSector) {
>                 bi =3D chunk_aligned_read(mddev, bi);
> +account_bio =3D false;
>                 if (!bi)
>                         return true;
>         }
> @@ -6180,7 +6182,8 @@static bool raid5_make_request(struct mddev *mddev,
> struct bio * bi)
>                         md_write_end(mddev);
>                 return true;
>         }
> -       md_account_bio(mddev, &bi);
> +if (account_bio)
> +md_account_bio(mddev, &bi);
>
>
> Thanks,
> Guoqing
>

Hi Guoqing

When chunk_aligned_read runs successfully, it just returns. In this
case, it does the account by itself. If it fails to execute, it still
needs run md_account_bio in raid5_make_request. So now the logic
should be right.

And by the way, in the original email, as mentioned, I commented the
chunk aligned read codes out, and it still can be reproduced.


--=20
Best Regards
Xiao Ni

