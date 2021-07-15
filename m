Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3479EC07E96
	for <linux-raid@archiver.kernel.org>; Thu, 15 Jul 2021 04:58:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0E6F661360
	for <linux-raid@archiver.kernel.org>; Thu, 15 Jul 2021 04:58:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235558AbhGOFBe (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 15 Jul 2021 01:01:34 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:38184 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229675AbhGOFBe (ORCPT
        <rfc822;linux-raid@vger.kernel.org>);
        Thu, 15 Jul 2021 01:01:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1626325121;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=COds9K+NxmNv6863RyV9fW364z2ubpGoZud4SamLxc4=;
        b=Ov9P23V76pt+5IWACBrGhz0wnDSkuE9dJTJqPZnYk5hisv7c444ANo/ieix/AwzpCNBtBC
        88xrGlWOKlzPjNw8fkzNmJD2pUC8pPO9Fogi2n0da/E+t+v3zehd0rBCKHqdNZ2oALI1KV
        KWzGlfEJ/Xh2zAHEpAnrji8uxgWWAjs=
Received: from mail-yb1-f200.google.com (mail-yb1-f200.google.com
 [209.85.219.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-517-2jZ6xRGGPYaVYDjHQNfRQQ-1; Thu, 15 Jul 2021 00:58:39 -0400
X-MC-Unique: 2jZ6xRGGPYaVYDjHQNfRQQ-1
Received: by mail-yb1-f200.google.com with SMTP id x5-20020a0569021025b029055b9b68cd3eso6116979ybt.8
        for <linux-raid@vger.kernel.org>; Wed, 14 Jul 2021 21:58:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=COds9K+NxmNv6863RyV9fW364z2ubpGoZud4SamLxc4=;
        b=CvZnWpkN2Q0VEzM+iOLnEvj8GjkiAsmzu4whUxsPRsn6T4ThvIybNLfZp3LxAQvSJ8
         aY5oNFmuiiw3W0IT9ObOBVuh1II46MijEcgj45Ivvk8IWLxt3ZCtNRyNKrdn7/Jkp10I
         mLvcIEoeSTSbgMvMsqbkIcRQWIPEJNnFKccL3d1Jp9RpoJu2X284lMMBnmaGewXM1Erh
         HbofbcaFAdCew35W7r3O/YVXoBXLRFEW/bH+bskM2RzFGASisiwEhE5oHc6UQ1E2sTc0
         54gZW3hY7h0ADYQY8TbX2VlfjJblc/GLeuuyzNFjtgKwgl8Lcr+C2IGb5D5EEis2JV4L
         X43g==
X-Gm-Message-State: AOAM532FA80K5VO3BIYwHHP50Qx64KSpzhMQHMjiBVhk5qOTod/KEvyv
        DhlKcoMnXimemdmVdWE/oWCNiTdfcCDRkrLWNbFWWXhaeAy7JGtkvMARNWsOuDIGD49kLgPRbiz
        Zhc5A+3EO0kj+th1SG96hCCLsC85CvEvAGMThWQ==
X-Received: by 2002:a25:aa30:: with SMTP id s45mr2618645ybi.69.1626325119232;
        Wed, 14 Jul 2021 21:58:39 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwiT4XDYizJanhVex0DAQN677LmxcrNEzxZsns5lkZPzLocGSDgGSUEv/8KB0O+NXODWDefX8Ep2kh1W9fsz8o=
X-Received: by 2002:a25:aa30:: with SMTP id s45mr2618617ybi.69.1626325118979;
 Wed, 14 Jul 2021 21:58:38 -0700 (PDT)
MIME-Version: 1.0
References: <C3C9F935-DD1C-409C-8C9D-56F97B13B676@gmail.com> <60EBF4AE.7080205@youngman.org.uk>
In-Reply-To: <60EBF4AE.7080205@youngman.org.uk>
From:   Fine Fan <ffan@redhat.com>
Date:   Thu, 15 Jul 2021 12:59:13 +0800
Message-ID: <CAOaDVC5BzK6uXmFMTYseUEz=Qq95EOPb_15pCwNbEyh4y4mapA@mail.gmail.com>
Subject: Re: RAID5 now recognized as RAID1
To:     Wols Lists <antlists@youngman.org.uk>
Cc:     Nicolas Martin <nicolas.martin.3d@gmail.com>,
        linux-raid@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi Nicolas Martin,

I just got my new disk and plugged it into the NAS waiting it finish
RAID 5 rebuild.
Here is what I found:
* The OS itself will create 4 RAID1 to used for the OS , and the RAID5
of your data  it should be  /dev/md1

Here is the diagram in text version:  (You may need to copy them into
a txt to make it looks normal.)


  +---------+        +---------+        +---------+
  |         |        |         |        |         |  /dev/md9  RAID1
 /mnt/HDA_ROOT
  |   1     |        |   1     |        |   1     |      sda1
  |    543MB|        |    543MB|        |    543MB|      sdb1
  -----------        -----------        -----------      sdc1
  |         |        |         |        |         |
  |   2     |        |   2     |        |   2     |  /dev/md256 RAID1
  |    543MB|        |    543MB|        |    543MB|      sda2
  -----------        -----------        -----------      sdb2
  |         |        |         |        |         |      sdc2
  |         |        |         |        |         |
  |         |        |         |        |         |
  |         |        |         |        |         |
  |         |        |         |        |         |
  |         |        |         |        |         |  /dev/md1 RAID5
LV: lv1    1.78T
  |         |        |         |        |         |       sda3
 lv544  18.54G
  |         |        |         |        |         |       sdb3
  |         |        |         |        |         |       sdc3       VG: vg=
288
  |         |        |         |        |         |
PV: /dev/md1
  |         |        |         |        |         |
  |   3     |        |   3     |        |   3     |
  |    990GB|        |    990GB|        |    990GB|
  |         |        |         |        |         |
  |         |        |         |        |         |
  |         |        |         |        |         |
  |         |        |         |        |         |
  |         |        |         |        |         |
  |         |        |         |        |         |
  |         |        |         |        |         |
  |         |        |         |        |         |
  |         |        |         |        |         |
  |         |        |         |        |         |
  -----------        -----------        -----------
  |         |        |         |        |         |  /dev/md13 RAID1
  /mnt/ext
  |   4     |        |   4     |        |   4     |       sda4
  |    543MB|        |    543MB|        |    543MB|       sdb4
  -----------        -----------        -----------       sdc4
  |         |        |         |        |         |
  |   5     |        |   5     |        |   5     |
  |  8544MB |        |  8544MB |        |  8544MB |  /dev/md322 RAID1
  |         |        |         |        |         |       sda5
  +---------+        +---------+        +---------+       sdb5
     sda                sdb                sdc            sdc6


Table Summary:
/dev/md9     RAID1    (sda1 sdb1 sdc1 ;543MB each)  /mnt/HDA_ROOT
/dev/md256 RAID1    (sda2 sdb2 sdc2 ;543MB each)
/dev/md1     RAID5    (sda3 sdb3 sdc3 ;990GB each)  PV:/dev/md1
VG:vg288   LV:lv1
/dev/md13   RAID1   (sda4 sdb4 sdc4 ;543MB each)  /mnt/ext
/dev/md322 RAID1   (sda5 sdb5 sdc5 ;8544MB each)

As you could see ,  my data is under  /dev/md1 RAID5 , for others they
are the RAID1.

Hope these could help you a little.


On Mon, Jul 12, 2021 at 4:29 PM Wols Lists <antlists@youngman.org.uk> wrote=
:
>
> On 08/07/21 11:07, Nicolas Martin wrote:
> > So, I don=E2=80=99t know how this could happen ? I looked up on the FAQ=
, but I can=E2=80=99t seem to see what could explain this, nor how I can re=
cover from this ?
>
> https://raid.wiki.kernel.org/index.php/Asking_for_help
>
> Cheers,
> Wol
>


--=20




Fine Fan

Kernel Storage QE

ffan@redhat.com

T: 8388117
M: (+86)-15901470329

