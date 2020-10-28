Return-Path: <SRS0=Dxgx=ED=vger.kernel.org=linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.0 required=3.0 tests=BAYES_00,DATE_IN_PAST_03_06,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D0DDC388F7
	for <linux-raid@archiver.kernel.org>; Wed, 28 Oct 2020 22:44:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 14F2C20714
	for <linux-raid@archiver.kernel.org>; Wed, 28 Oct 2020 22:44:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="i++16Nos"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389476AbgJ1Wnq (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 28 Oct 2020 18:43:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731710AbgJ1WnD (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 28 Oct 2020 18:43:03 -0400
Received: from mail-lj1-x22c.google.com (mail-lj1-x22c.google.com [IPv6:2a00:1450:4864:20::22c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F27A1C0613CF
        for <linux-raid@vger.kernel.org>; Wed, 28 Oct 2020 15:43:02 -0700 (PDT)
Received: by mail-lj1-x22c.google.com with SMTP id m20so999008ljj.5
        for <linux-raid@vger.kernel.org>; Wed, 28 Oct 2020 15:43:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=JAxqBiv9FAqTcbh8Jcrvr5UifYuflldy0L4UvGJ6V1M=;
        b=i++16NosqanHc+xDEFxOcaQVCVAbk7vAjCbDSXO0Rhdbgbida3P+enir4KzQimPYc3
         2il4YZ2zfXVZiYz+SPvHXCg5xdeDNRWmWM0YTNaIUSMDGe60qMJj3Iace1/48yf9A8yG
         tGlYLEr6mEEBgXKJHzby9LPRJ86Ks2Ztc0hGvOcmk7e9f7wpqW1KT1mUN1ebnkUmowUm
         qb7Ga1GDEGh39dRj1YzP3Q0W2t6zcDUnry68oIoeSGxQmYcuGESf5yzzh16wCHZC9yCy
         ZoX1Qgus4CGkEkryZSONkG4/TRhemhtkS81WIAPFwLhqybf9+puo1R2C5zVj2lCKZBYc
         z+rQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=JAxqBiv9FAqTcbh8Jcrvr5UifYuflldy0L4UvGJ6V1M=;
        b=Ns2RypCMhkayhuE39iGI0EGzon3vsftVchjllML8WvYHF4Fy7Gsdrz3YcX9wQWTbe2
         Fb9DaPiWAF8mNTUTtiaVgCloxya87PgrIH/EJl63nRVoLZZcimiI2nfDiVTQy45kZAdA
         ki4PnxFinVvOhfqIvSHPKV75HMY8LRf6GdL+cBjvIe2kiRAnLx1SEtyvtOEcEI21BmPE
         0fVKI0kiJD05oVewcy2T0ScR/rnWUTXo/eVA9Pl8E9WB2ZLHgunV95mCYFW/jIDNJIdW
         Brx2n2TeWcB6/e/wLVbGvkjxyD9WdiQUEccxKr7ElnolMRSVZ02R24n+1tGm6PRfvLtY
         TE1g==
X-Gm-Message-State: AOAM533vDiQm8xomHJ2IwFWjmDGh6E9xNSP3037DKZq68+Qhjkx0UFg+
        qk51TPPvI9F8e3KWLXS668o0wES65HGR7DqSI22VUHE/
X-Google-Smtp-Source: ABdhPJw50WR+C7kcU0ZfDX3zjWBgDtHGyMosf3mw7PXKGyCALdWUqWUbxDxim/yAQvd6LORNKFrQeY2FlkZMeoX5nlg=
X-Received: by 2002:aa7:de89:: with SMTP id j9mr205106edv.363.1603910353259;
 Wed, 28 Oct 2020 11:39:13 -0700 (PDT)
MIME-Version: 1.0
References: <5EAED86C53DED2479E3E145969315A23856DD0D3@UMECHPA7B.easf.csd.disa.mil>
In-Reply-To: <5EAED86C53DED2479E3E145969315A23856DD0D3@UMECHPA7B.easf.csd.disa.mil>
From:   Vitaly Mayatskih <v.mayatskih@gmail.com>
Date:   Wed, 28 Oct 2020 14:39:02 -0400
Message-ID: <CAGF4SLhGz4mg-ia_KWWt3mrQCry8sHunbBhRNhVod3H19ztaCg@mail.gmail.com>
Subject: Re: Nr_requests mdraid
To:     "Finlayson, James M CIV (USA)" <james.m.finlayson4.civ@mail.mil>
Cc:     "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Thu, Oct 22, 2020 at 2:56 AM Finlayson, James M CIV (USA)
<james.m.finlayson4.civ@mail.mil> wrote:
>
> All,
> I'm working on creating raid5 or raid6 arrays of 800K IOP nvme drives.   =
Each of the drives performs well with a queue depth of 128 and I set to 102=
3 if allowed.   In order for me to try to max out the queue depth on each R=
AID member, so I'd like to set the sysfs nr_requests on the md device to so=
mething greater than 128, like #raid members * 128.   Even though /sys/bloc=
k/md127/queue/nr_requests is mode 644, when I try to change nr_requests in =
any way as root, I get write error: invalid argument.  When I'm hitting the=
 md device with random reads, my nvme drives are 100% utilized, but only do=
ing 160K IOPS because they have no queue depth.
>
> Am I doing something silly?

It only works for blk-mq block devices. MD is not blk-mq.

You can exchange simplicity for performance: instead of creating one
RAID-5/6 array you can partition drives in N equal sized partitions,
create N RAID-5/6 arrays using one partition from every disk, then
stripe them into top-level RAID-0. So that would be RAID-5+0 (or 6+0).

It is awful, but simulates multiqueue and performs better in parallel
loads. Especially for writes (on RAID-5/6).


--=20
wbr, Vitaly
