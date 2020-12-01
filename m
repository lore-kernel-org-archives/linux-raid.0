Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0175C64E7A
	for <linux-raid@archiver.kernel.org>; Tue,  1 Dec 2020 17:16:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3CB5D206E0
	for <linux-raid@archiver.kernel.org>; Tue,  1 Dec 2020 17:16:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="i/F79BKr"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727368AbgLARP5 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 1 Dec 2020 12:15:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726303AbgLARP5 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 1 Dec 2020 12:15:57 -0500
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0604AC0613CF
        for <linux-raid@vger.kernel.org>; Tue,  1 Dec 2020 09:15:17 -0800 (PST)
Received: by mail-pf1-x42f.google.com with SMTP id o9so1489422pfd.10
        for <linux-raid@vger.kernel.org>; Tue, 01 Dec 2020 09:15:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=29zfBxrQwQ8rQUpG3tZv6vL4AyfNWnrokBrm0t8G+8w=;
        b=i/F79BKrnRcGI5x9/6o3T6AsmIGL5n/yke8yU0VpeMOxUp1dXN0gd5U0OsiQo4vdiT
         PIsjHK5zRZcz7cifzv8p5GNKe8s8r1Br8jbDwRtwZ8LnGTMSHuGABXKK21PAKBIY8VXb
         XhloHmVoxqfmfNuWRo28MBICwfTeHla3fFLeDC3ULWQWmEqnIyevzsCrKZ5A7WF67OrB
         irk1MxfP5STcaYWi86UnLmI0+cplspHbLkpJs66KO0s/lrhN1twypnpRMqdyVuiGAypV
         OMgIXqUNkyGtpSLczSEMtzYjO21SgP4dc5DFy3bclUxhn9w6fyYi5omtErrTr7+1t2V2
         9OZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=29zfBxrQwQ8rQUpG3tZv6vL4AyfNWnrokBrm0t8G+8w=;
        b=fDzuyPdoLBUr0X8Qg+TsakiTkxNW+yHi9DmdJ4O3Mhsd+VE6OqiY66LkyrursLqSOi
         bHzi1DlD5g5982o8INUjLjBxQpweTqMET072t60gDn8w3+LnTmTOihHnt/kGNHIBfuNw
         +rdpln/VIl/0Zs5vGzVO/tvsps4jXz4CC+Ayy+EDuTcBA+y7dN43Q8DX1ocCxbOnHPlg
         5d18BXJ+UO70mlCT0Mv7QVQzbZrQ4xodL1GfGcglyGOUfypp/m/jthO3lk8thX0Yh7xU
         id+P8ddT/eg3p0dxmrjyAMTEWAujsI/p8jX/x4es+tMp3JOHtZlYtMwd84gLsYctB528
         vOHw==
X-Gm-Message-State: AOAM533aNOicxXD7UsKooHUwEyXRkzrNE0qdgK7ho8biRAVAUmHrkuaD
        J1Enqs99AgSL404Qk5ngXSbkwuct1x/ElTbeJ5oGnFvexo8=
X-Google-Smtp-Source: ABdhPJxxmep3Utx+NYgcTTobTzRoDN9PWRVpxxcdjOgebV9uAxs9N0jkKNLfjWnlAB7XbZ29ux0ywEcz+FCW7tDytbI=
X-Received: by 2002:a62:293:0:b029:197:96c2:bef6 with SMTP id
 141-20020a6202930000b029019796c2bef6mr3495692pfc.62.1606842916555; Tue, 01
 Dec 2020 09:15:16 -0800 (PST)
MIME-Version: 1.0
References: <CAJH6TXjsg+OE5rUpK+RqeFJRxBiZJ94ToOdUD5ajjwXzYft9Vw@mail.gmail.com>
 <CAJH6TXgED_UGRcLNVU+-1p8BVMapJkRmvZMndLYAKjX_j6f7iw@mail.gmail.com>
 <5FC62A4F.9000100@youngman.org.uk> <CAAMCDefErBEP22cVqLNO3P1fGpXkih=9nFW1OMVQZEAorgB88Q@mail.gmail.com>
In-Reply-To: <CAAMCDefErBEP22cVqLNO3P1fGpXkih=9nFW1OMVQZEAorgB88Q@mail.gmail.com>
From:   Gandalf Corvotempesta <gandalf.corvotempesta@gmail.com>
Date:   Tue, 1 Dec 2020 18:15:05 +0100
Message-ID: <CAJH6TXjLCuG41-YSkibAMHumoEOXApEQbxFqc47YicTyp3uzTQ@mail.gmail.com>
Subject: Re: Fwd: [OT][X-POST] RAID-6 hw rebuild speed
To:     Roger Heflin <rogerheflin@gmail.com>
Cc:     Wols Lists <antlists@youngman.org.uk>,
        "General discussion - ask questions, receive answers and advice from
        other ZFS users" <zfs-discuss@list.zfsonlinux.org>,
        Linux RAID Mailing List <linux-raid@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Il giorno mar 1 dic 2020 alle ore 14:01 Roger Heflin
<rogerheflin@gmail.com> ha scritto:
> So what is the model of each disk and how big is the partition used
> for the array on each of the 8 disks?

Old disk: Seagate ST3600057SS 3.5''
New disk: Seagate ST600MP0006 2.5''

One huge virtual disk, 3271G
