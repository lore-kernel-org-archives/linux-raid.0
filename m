Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF434C433B4
	for <linux-raid@archiver.kernel.org>; Fri,  7 May 2021 01:28:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 962AE60724
	for <linux-raid@archiver.kernel.org>; Fri,  7 May 2021 01:28:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233640AbhEGB3p (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 6 May 2021 21:29:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231461AbhEGB3o (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 6 May 2021 21:29:44 -0400
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6ECEC061574
        for <linux-raid@vger.kernel.org>; Thu,  6 May 2021 18:28:45 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id n15so3663051edw.8
        for <linux-raid@vger.kernel.org>; Thu, 06 May 2021 18:28:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=BcsBJQkiWDq6N2bDGSL0Kj8lsnu8XZecfrzApPlJeBE=;
        b=QPVhvtI7rg99PhlZJ+/un4Qy7Jfi/bqwQIZCPM6cn6GlxvhiLvSbpIpbdq26Pe9JW2
         ONKyK2R+wSccdD3vqlPNjV/6SpxBq2WIxxubyfHaxzMJxNdx2ukawUC59kAwz7Gd8Xjh
         QZhWnz1pAGeaiMJmAI3DkPLsn2kTWs+QqvkcCxPD3xQFbSU7CF9qul4QHNSQyvjzj309
         lO8jlibqdXytv2DldO2Z23OKKrEmqv+iLPu64Jr+Rweh/OXVDRd5KvnnhiI2AE1lWeO5
         Dso8ltn1s/Sl3JbE4Xn/SwsSNUpVy0oSwfbBXrft8fEB7EezdWFrTMXsvKnOpXeYAEW7
         gZkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=BcsBJQkiWDq6N2bDGSL0Kj8lsnu8XZecfrzApPlJeBE=;
        b=SOjsur+j9HqSNsDuPmocmtrj0LrtyUts6Xc5ejp5rY0QSj/2/jk9IKnWqsPOC6ngKh
         oAz4unlx0FfJ5Yvzr2AFkUG+hXBC3appkIUE+9+/gAeZZ1DqWOgqQJJ98PTZ/I0amrWW
         zdsgl5U90EinBXZLou6XcU/sh4PEJUJlnABlrzf9g+TGFAdAQyJhDwiHtXZRIrGYnW1K
         RPnUCaBiydIvkBOhleyJXEWB6Oip3+yzP9yGmDhoMnkD8z5N7GWHO5CPYEnABzK53ohx
         LKlHNL1alVKf3i+K0NShgE2+oZbuTC/s6r/8eQz7aqwFvZWyilxtLN+lse4+0O8Zbcq4
         n1kA==
X-Gm-Message-State: AOAM5320K9pItzElU/clB8MfVv6GT0cX2WklQfG7qvnSNQZm+MKNQ9C3
        6rIp9Q3dout4kcbJOYmf17XxUpKtippsBCpVIHa9vN8ldJ4=
X-Google-Smtp-Source: ABdhPJwBK8ZoaghijaYwkWLPOsmICQRazhSTGpSJ0iDl/wZCh4bvYMtWRnn7XSk23buw3IGM3KJ6mBl89F+dntUsh/U=
X-Received: by 2002:aa7:dad1:: with SMTP id x17mr8437607eds.47.1620350924566;
 Thu, 06 May 2021 18:28:44 -0700 (PDT)
MIME-Version: 1.0
References: <CAC6SzHJLG=0_URJUsgQshpk-QLh6b8SBJDrfxiNg4wikQw4uyw@mail.gmail.com>
 <8626adeb-696c-7778-2d5e-0718ed6aefdb@redhat.com> <CAC6SzHK1A=4wsbLRaYy9RTFZhda6EZs+2FjuKxahoos_zAd0iw@mail.gmail.com>
 <6db10ef4-e087-3940-4870-e5d9717b853f@thelounge.net>
In-Reply-To: <6db10ef4-e087-3940-4870-e5d9717b853f@thelounge.net>
From:   d tbsky <tbskyd@gmail.com>
Date:   Fri, 7 May 2021 09:28:35 +0800
Message-ID: <CAC6SzH+gZ_WYRdx-vHM6zZxH=kx0YBvV-x2VT9h7EugwdmGcxA@mail.gmail.com>
Subject: Re: raid10 redundancy
To:     Reindl Harald <h.reindl@thelounge.net>
Cc:     list Linux RAID <linux-raid@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Reindl Harald <h.reindl@thelounge.net>
> Am 06.05.21 um 11:57 schrieb d tbsky:
> > if losing two disks will madam find out the raid can be rebuilded safely or not?
>
> it's pretty simple
>
> * if you lose the wrong disks all is gone
> * if you lsoe the right disks no problem

 that's seems reasonable. I will give it a try.
