Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2400C433EF
	for <linux-raid@archiver.kernel.org>; Fri,  6 May 2022 11:55:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1391553AbiEFL7Q (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 6 May 2022 07:59:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1391583AbiEFL7L (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 6 May 2022 07:59:11 -0400
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A323EB7E5
        for <linux-raid@vger.kernel.org>; Fri,  6 May 2022 04:55:26 -0700 (PDT)
Received: by mail-wr1-x42e.google.com with SMTP id x18so9756743wrc.0
        for <linux-raid@vger.kernel.org>; Fri, 06 May 2022 04:55:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=jstephenson-me.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=hqL6uSBLKinvJz8O0Mi1LEtV7LIqOvi5CtnEnlq3zAk=;
        b=Wg46/aqKh81diUOmvqEtkEl4N7lMGANmFsCldPm1ELd3L/nNpgYok66TI7pVgta3bQ
         avbd7GwDBk7u+R+fNuGN1GOinmOAC4VUnYhtHUg1TL08B1p4ZONBPdT9AQB9ZNMiCEa8
         pdSKyL6FXQAGTYtjLXZK7edaVra0BGrrcAN6snZ6BmJWoZgpviYwFJxxjHT62dvVMOtp
         riMDpYsFxY6A8zDsGAf1f0ZPx+RINcVGzqoxpbhYNmkjAQwun/nOwiOEwYzv1pZfJNYA
         YFayR7kq0R7pFffGFBdRR8ammPw++Cei+N4AyN0VLpJW5mq93lOri8S7TOoMU4SRbr+2
         oLDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=hqL6uSBLKinvJz8O0Mi1LEtV7LIqOvi5CtnEnlq3zAk=;
        b=HDbV+/2clXARx11qvruOgzDPrbPUO5V8iboJzKab8Dp0+x3YSZTHnQOzJ21nWA8gZy
         grBpcY3B5axKkZCFcbicORw6EjIv9U2LLf6zLAiAX7I40K19B8U95KexiV0VBagwcreC
         25WveGLsWZJcVUnR/GvOSdUa7zK5nl8K7795DGvZMnMFrHAw+Wh0PukRigMBBpqYd9qt
         yD1WZ0Jk2BzCCB1Bkwfe2Cur4n1BtVWJ/Ybrx7rarZXBjKSsxNIF0rn+MwGMzzObvWSO
         mMTCN/38LkGsk/Ds4BGssC3YbvF135b8Job/p9jAIMZpcFKjCbS/dLX8BzSh4Dg3v73H
         euzg==
X-Gm-Message-State: AOAM53209eqp6Fek2lCgDVTH6OUaanvz2R1wFpX+QikkH3sLW09mxGOb
        4tjrR1j+7pDByCa2C+8CGq0rBaZtL9hVGFFED8n72XVrjbGivQ==
X-Google-Smtp-Source: ABdhPJzRRYmOcqxcxgep5EcuQajbpNY9yP+5VoS2TcO6kYdP99a2fcVqZxAXDwSRvjYl7YoqfzlVcHHNDOBnNqZ+ufQ=
X-Received: by 2002:adf:f187:0:b0:20a:dfb0:766a with SMTP id
 h7-20020adff187000000b0020adfb0766amr2517620wro.517.1651838124974; Fri, 06
 May 2022 04:55:24 -0700 (PDT)
MIME-Version: 1.0
References: <CA+an+MoM_Vb4Z3FSRcTo+ykmFTW5cwh1CQWCN9BMT45CdW_P0g@mail.gmail.com>
 <26c0f640-8801-240c-ce2c-99246b09f2e2@linux.dev>
In-Reply-To: <26c0f640-8801-240c-ce2c-99246b09f2e2@linux.dev>
From:   James Stephenson <inbox@jstephenson.me>
Date:   Fri, 6 May 2022 12:55:13 +0100
Message-ID: <CA+an+Mq8S8hNnbQP3uJCHU_yw_5Fbr+cvWjfmiL9Sa2n-cEpvA@mail.gmail.com>
Subject: Re: Unable to add journal device to RAID 6 array
To:     Guoqing Jiang <guoqing.jiang@linux.dev>
Cc:     linux-raid@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Thank you for your reply. I did check the source and found the same
block, however I=E2=80=99m not familiar enough to understand where I would =
see
this condition indicated?

As of now the array seems perfectly normal:
https://gist.github.com/jstephenson/0b615aab33bb8157a3876471ef50424e

James


On Fri, 6 May 2022 at 12:48, Guoqing Jiang <guoqing.jiang@linux.dev> wrote:
>
>
>
> On 5/6/22 6:42 PM, James Stephenson wrote:
> > Hi,
> >
> > First time using this (and indeed any) mailing list, so apologies if I
> > violate any etiquette I'm not aware of!
> >
> > I'm trying to add a write-back journal device to an existing RAID 6
> > array, and it's proving difficult. Essentially I did this:
> >
> > 1. Put the array in read-only
> > 2. Attempt to add a journal device to the array
> > 3. md said no because the array has a bitmap
> > 4. I tried to remove the bitmap, and it said no: 'md: couldn't update
> > array info. -16'
> > 5. I rebooted
> > 6. The array wouldn't start, and to my surprise was listed as having a
> > journal device. Here's what it looked like:
> > https://gist.github.com/jstephenson/1db2008c4243c2539d029f1f4706dc14
> > 7. It was _very_ unhappy, and refused to do anything: 'md/raid:md126:
> > array cannot have both journal and bitmap'
> > 8. The only thing I could do was to zero the superblock on the journal
> > device, and then fortunately everything assemble again nicely (with
> > bitmap still in place)
> >
> > So, after a bit of messing around the array is back to where I
> > started=E2=80=94RAID 6 with internal bitmap. However, I still cannot re=
move
> > its bitmap.
> >
> > 1. sudo mdadm --grow /dev/md126 --bitmap=3Dnone
> > 2. md: couldn't update array info. -16
>
> -16 means EBUSY, so probably the array needs resync or recovery per
>
> https://elixir.bootlin.com/linux/v5.10.106/source/drivers/md/md.c#L7374
>
> Thanks,
> Guoqing
