Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95D87E7D0A2
	for <linux-raid@archiver.kernel.org>; Thu, 21 Sep 2023 19:59:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229846AbjIUT76 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 21 Sep 2023 15:59:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231408AbjIUT7f (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 21 Sep 2023 15:59:35 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C49326B6C
        for <linux-raid@vger.kernel.org>; Thu, 21 Sep 2023 10:12:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1695316322;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=s0o7MpV+4rqwsWqVoseHPuG7bnqJWbFP8wvb8G89HBY=;
        b=aTzd+cuIoxKj3VreS3vjmyQfyLwrBAgApUlaCxNrgawiyypf+6s7eONRcp9YLioNFjtL2L
        38Z+DZHQpZXVglQmbDSJsBDkP9ZVeE0JrCoh+OR2F+oi5AO6RacwGpJh+uB2KGeIwkW5ER
        nVB1MAkPyb6R45vJJbZAWAG0ICN4YsY=
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com
 [209.85.216.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-517-O4C8xiiIMISP5tmc3TpeqA-1; Thu, 21 Sep 2023 08:53:19 -0400
X-MC-Unique: O4C8xiiIMISP5tmc3TpeqA-1
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-2766101a6b4so1699149a91.0
        for <linux-raid@vger.kernel.org>; Thu, 21 Sep 2023 05:53:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695300798; x=1695905598;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=s0o7MpV+4rqwsWqVoseHPuG7bnqJWbFP8wvb8G89HBY=;
        b=YzdWJaEgZM/gJJkmmToxrf34Xjki/YlLha8yJzodRZ3hSkaYOmwZmiCMEe2ojbYJsD
         xTKqGMpPGqaCEV7GlsY0pQiWTJXZPjazBmrmE56Nnm9eyPiH6iTngqR5etssFKXegGaZ
         0Fz8n3iVMtiyU0zn2+/mGqdpo8G9Axh1TGmP7sg0TxuIRAEDPA0gkCekMzRxq0rrMyUW
         ALvIHVJJ19s92WcN2FSgvvsQkP43GE5qcXLVjOeji7HlU76MdFJUAi/FELGFkGoC4CuM
         WvojjUjK9TSJfyHyhcVsM16K+Kg9IlYEL/hcoIcgmiOkNcATXKPx4Xvw/vbDtNYkU1XB
         9fmA==
X-Gm-Message-State: AOJu0YxN/ZS1TEo2+hhY2Z5zRh+0oGM/xOfk9NW1dBz26eG/z7L99YG+
        cGnpNa8PSFrQdMvUrKXGpMypnUI9lYI+YRhtsJ7RHx00LXVP01JUrT28h19JZRuZ3EVBrQYs2hR
        9OUfcro3O1KA92yYWkWEhpaWABe3ZkDHRo+/dYal5WGtGB/px
X-Received: by 2002:a17:90b:e8e:b0:274:9be9:7ee3 with SMTP id fv14-20020a17090b0e8e00b002749be97ee3mr7762673pjb.8.1695300797981;
        Thu, 21 Sep 2023 05:53:17 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEpeq7ZgHh4EKyqGAIt2eynJWL2FnzMSCZ+3slvWXbFculAAOmJPy4ol8HyKDA9Z+W1geH+xss+ichCN3aW/Fo=
X-Received: by 2002:a17:90b:e8e:b0:274:9be9:7ee3 with SMTP id
 fv14-20020a17090b0e8e00b002749be97ee3mr7762657pjb.8.1695300797663; Thu, 21
 Sep 2023 05:53:17 -0700 (PDT)
MIME-Version: 1.0
References: <9b21efef0bc1457c89250761b2b6cf2c@TW-EX2013-MBX1.supermicro.com>
In-Reply-To: <9b21efef0bc1457c89250761b2b6cf2c@TW-EX2013-MBX1.supermicro.com>
From:   Xiao Ni <xni@redhat.com>
Date:   Thu, 21 Sep 2023 20:53:06 +0800
Message-ID: <CALTww29MWS9GY+kc+0nTJywBZVk=aNnzujbNXkPHAjKoO5ZJDw@mail.gmail.com>
Subject: Re: bblog overlap internal bitmap?
To:     Stan Liao <StanL@supermicro.com>
Cc:     "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Thu, Sep 21, 2023 at 11:22=E2=80=AFAM Stan Liao <StanL@supermicro.com> w=
rote:
>
> Hi,
> A md-raid (level 1) is created with 5 nvme drives and the metadata versio=
n is specified as 1.2. The following command is used.
> sudo mdadm --create /dev/md0 --level=3D1 --raid-devices=3D5 /dev/nvme{1,2=
,3,4}n1 /dev/nvme4n2 --metadata=3D1.2
> The capacities of nvme{1,2,3,4}n1 and nvme4n2 are 3.2TB, 1.92TB, 3.2TB, 5=
12GB, and 512GB.
> OS: 20.04.1-Ubuntu
> mdadm version: v4.1 - 2018-10-01
> After creation, we found that the size of the bitmap_super_t and internal=
 bitmap is 16KB (this is concluded by observing FF value is filled from aro=
und byte offset 0x100 of LBA 0x10 to byte offset 0x1FF of LBA 0x1F), but th=
e mdp_superblock_1.bblog_offset value is 0x10. As a result, the mdp_superbl=
ock_1 occupies LBA 0x08 ~ 0x0F; bitmap_super_t and internal bitmap occupy L=
BA 0x10 ~ 0x20; bblog occupies LBA 0x18 ~ 0x20.
> If bblog and bitmap do overlap, I would like to know the size value used =
to calculate bitmap size and bblog_offset. The size value used to calculate=
 bitmap size and bblog_offset is mdp_superblock_1.size or mdp_superblock_1.=
data_size? Thanks a lot.
>

Hi

For super1.2 the layout should be:
|    4KB    |    4KB    |    bitmap space    |    head room    |   data |

The first 4KB is empty from the beginning of the disk. The second 4KB
is for md superblock. Then is bitmap suerblock. So if you want to see
the content of bitmap_super_t, the offset should be 0x2000?

Regards
Xiao

