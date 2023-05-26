Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E436C77B7E
	for <linux-raid@archiver.kernel.org>; Fri, 26 May 2023 02:09:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232877AbjEZCJL (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 25 May 2023 22:09:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230049AbjEZCJK (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 25 May 2023 22:09:10 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77829195
        for <linux-raid@vger.kernel.org>; Thu, 25 May 2023 19:08:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1685066903;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=JQr5uTDo02zAtp27aliOjrl2+aB1h/YA+111dOmh72I=;
        b=cMd3q68H/H4p3cy3wkJf6EoZgoL5YTLxshLMAvikoOltojGHhFT+LDTJn/sgvHJRN1MRau
        X/pO0/PwsarXtFtfQQFNC/Ilejx+dgDf3zeb3G4Ld7aBTnXaUo7M5uE9cj+65rLgYwV8cc
        qE1ca3SryUy9w9qLTdr0xhn/D2h70JQ=
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com
 [209.85.216.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-644-B2-9htEZNdqo3tQxWQZyEw-1; Thu, 25 May 2023 22:08:22 -0400
X-MC-Unique: B2-9htEZNdqo3tQxWQZyEw-1
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-25338b76f79so262920a91.3
        for <linux-raid@vger.kernel.org>; Thu, 25 May 2023 19:08:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685066901; x=1687658901;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JQr5uTDo02zAtp27aliOjrl2+aB1h/YA+111dOmh72I=;
        b=Up8O/DdSG1W9J86/6peFmeb+IT9HIrC5ZexVQ5lncPfG5KkXgqQsJ3xyVX722RIKHa
         ivOm6ZLwFIf/g1SwFPaXygB4GqyfCxML6ayhutn16N5M3RITkAfzWy2oKcpVOy5Qp9OR
         UhjDhoOs+O7ypX8QZNv89cUj5emDVnl7DyUBtjsHMobynas9bp+pgiSRZso2o+l8h9u3
         cuHx1umXHfR0MbhX76XGLvJnv8bUajt+7hHvFA16p05qOLCv4iQ2s+AjE24nTmtN13xP
         IRVqGoqoPqUploaEEGyegRcT4niS7AMY6ovEmnh+TU2TYxp5k8ecLDsB81SE+sb6Y7gs
         PI9A==
X-Gm-Message-State: AC+VfDw6cmXNy37pvk9T1EKwXKiI/R8qGUnYc3uo1HptSIpirsbwmPjx
        YrFZzpDzF14p2yxcf0v2AxbiWxFL7/ex28caHQr5mEjZw8En+OXgJfaWqG2ATek2ALtEYNBUCgr
        n7ubnNGAGPSh0gtPxp2470259REkGYPJR6OElylsfcwb/o+gJ
X-Received: by 2002:a17:902:d4ca:b0:1ae:50cc:45b with SMTP id o10-20020a170902d4ca00b001ae50cc045bmr953199plg.36.1685066901246;
        Thu, 25 May 2023 19:08:21 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ4zQvqbd0HZxa1FpY5z8E7d1yT3tu703w4yQtJQODN87tykK21GX/DSpFphuKiqeVCdMBHAkUuXLCfihyWUm3I=
X-Received: by 2002:a17:902:d4ca:b0:1ae:50cc:45b with SMTP id
 o10-20020a170902d4ca00b001ae50cc045bmr953181plg.36.1685066900955; Thu, 25 May
 2023 19:08:20 -0700 (PDT)
MIME-Version: 1.0
References: <CALTww28aV5CGXQAu46Rkc=fG1jK=ARzCT8VGoVyje8kQdqEXMg@mail.gmail.com>
In-Reply-To: <CALTww28aV5CGXQAu46Rkc=fG1jK=ARzCT8VGoVyje8kQdqEXMg@mail.gmail.com>
From:   Xiao Ni <xni@redhat.com>
Date:   Fri, 26 May 2023 10:08:09 +0800
Message-ID: <CALTww2_4pS=wF6tR0rVejg1ocyGhkTJic0aA=WCcTXDh+cZXQQ@mail.gmail.com>
Subject: Fwd: The read data is wrong from raid5 when recovery happens
To:     linux-raid <linux-raid@vger.kernel.org>,
        Song Liu <song@kernel.org>,
        Guoqing Jiang <guoqing.jiang@linux.dev>,
        Heinz Mauelshagen <heinzm@redhat.com>,
        Nigel Croxon <ncroxon@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

I received an email that this email can't delivered to someone. Resent
it to linux-raid again.

---------- Forwarded message ---------
From: Xiao Ni <xni@redhat.com>
Date: Fri, May 26, 2023 at 9:49=E2=80=AFAM
Subject: The read data is wrong from raid5 when recovery happens
To: Song Liu <song@kernel.org>, Guoqing Jiang <guoqing.jiang@linux.dev>
Cc: linux-raid <linux-raid@vger.kernel.org>, Heinz Mauelshagen
<heinzm@redhat.com>, Nigel Croxon <ncroxon@redhat.com>


Hi all

We found a problem recently. The read data is wrong when recovery
happens. Now we've found it's introduced by patch 10764815f (md: add
io accounting for raid0 and raid5). I can reproduce this 100%. This
problem exists in upstream. The test steps are like this:

1. mdadm -CR $devname -l5 -n4 /dev/sd[b-e] --force --assume-clean
2. mkfs.ext4 -F $devname
3. mount $devname $mount_point
4. mdadm --incremental --fail sdd
5. dd if=3D/dev/zero of=3D/tmp/pythontest/file1 bs=3D1M count=3D100000 stat=
us=3Dprogress
6. mdadm /dev/md126 --add /dev/sdd
7. create 31 processes that writes and reads. It compares the content
with md5sum. The test will go on until the recovery stops
8. wait for about 10 minutes, we can see some processes report
checksum is wrong. But if it re-read the data again, the checksum will
be good.

I tried to narrow this problem like this:

-       md_account_bio(mddev, &bi);
+       if (rw =3D=3D WRITE)
+               md_account_bio(mddev, &bi);
If it only do account for write requests, the problem can disappear.

-       if (rw =3D=3D READ && mddev->degraded =3D=3D 0 &&
-           mddev->reshape_position =3D=3D MaxSector) {
-               bi =3D chunk_aligned_read(mddev, bi);
-               if (!bi)
-                       return true;
-       }
+       //if (rw =3D=3D READ && mddev->degraded =3D=3D 0 &&
+       //    mddev->reshape_position =3D=3D MaxSector) {
+       //      bi =3D chunk_aligned_read(mddev, bi);
+       //      if (!bi)
+       //              return true;
+       //}

        if (unlikely(bio_op(bi) =3D=3D REQ_OP_DISCARD)) {
                make_discard_request(mddev, bi);
@@ -6180,7 +6180,8 @@ static bool raid5_make_request(struct mddev
*mddev, struct bio * bi)
                        md_write_end(mddev);
                return true;
        }
-       md_account_bio(mddev, &bi);
+       if (rw =3D=3D READ)
+               md_account_bio(mddev, &bi);

I comment the chunk_aligned_read out and only account for read
requests, this problem can be reproduced.

--=20
Best Regards
Xiao Ni


--=20
Best Regards
Xiao Ni

