Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77DFBC433EF
	for <linux-raid@archiver.kernel.org>; Wed, 15 Dec 2021 12:08:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242290AbhLOMIb (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 15 Dec 2021 07:08:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237093AbhLOMIa (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 15 Dec 2021 07:08:30 -0500
Received: from mail-lj1-x234.google.com (mail-lj1-x234.google.com [IPv6:2a00:1450:4864:20::234])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59054C061574
        for <linux-raid@vger.kernel.org>; Wed, 15 Dec 2021 04:08:30 -0800 (PST)
Received: by mail-lj1-x234.google.com with SMTP id b19so31173061ljr.12
        for <linux-raid@vger.kernel.org>; Wed, 15 Dec 2021 04:08:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=LqIZ6yoHv3euTG1nJq0CX4Dw+St6+Yye08ENVpFqEks=;
        b=YyUTS9o55Sunh2lS9hT6ATHxnEw2qRR6YtR+ViOheyzpekjoXSgu1gAzDpT6LPLEse
         nDKZ7L6uLqBGWXt5Zu8KXYZ0s4zvAxb6KnI3kHOa3nApiOCn9b/6X5hg4VnOEMM8fvDx
         SbMeMWCEwm01qhTP98iWID7v3E9BmkacGunn902FYDba6bNssJiD6x8LVeGWNG/l67eT
         iFoTQEj5bfwAtu0QVAlH5WGBx4W5/D2rYsNPOGWngM1sQm03qUC21Dcbh/tPGUGZI33a
         5n0j0AuDKLuBU8yjemxKnFdvpOhETluZdfOiifJw/M2W7sJoAE05y3RcTIy1jzHRBxJN
         wViA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=LqIZ6yoHv3euTG1nJq0CX4Dw+St6+Yye08ENVpFqEks=;
        b=jjEb8EhnB7KbtZb+7C9DhLKvGgoQh7tVP7TokABwCqz6jZfbyvqcb1CLs7DU4+Txgc
         6QqZNaBl5RiFt9WtCaF50eEFVb8mkrDlI1wJdhJ1C2qWDbyPdLNtB0M1/AncUTgXWSlI
         O3AD2uH98Gkkx5zPkj3wj9ju1C1b74qtdnwX2bmooKTZIK8d0x0CP36//D+qPutdhGYB
         Tl2Py/lLuJTlexjTn06wThaQOrYYcDLJdW69NbSU8I6NMp7KWi3FE/1kG39SnrPa/9OR
         FCgXtFStlL+BNKf6zxxgpgzI5eeAQKymkGpo9agtagZzo0SirzJ0PaI9hxVn+WFpR/cO
         bBHg==
X-Gm-Message-State: AOAM530mHRddyjVETQBNC9Jetk1PFYToZ2AhFsN+PjEpm4Qe7+EKNr4V
        pRHddPeNeFRGBWOW0rpjwhriuB/iLA0b5H/+conN1uiWn9Ga6w==
X-Google-Smtp-Source: ABdhPJwQJ0APLAxJlrIkDmAMMaZ9np9gQue9ijM3j1Mu7HTKmjANGdUWuuc7+PoRcG7fxG3eUeJ7FkTGXuD9fnFs5L4=
X-Received: by 2002:a2e:a4aa:: with SMTP id g10mr9845130ljm.529.1639570108686;
 Wed, 15 Dec 2021 04:08:28 -0800 (PST)
MIME-Version: 1.0
References: <d8a0d8c9-f8cc-a70a-03a0-aae2fd6c68c2@youngman.org.uk>
In-Reply-To: <d8a0d8c9-f8cc-a70a-03a0-aae2fd6c68c2@youngman.org.uk>
From:   o1bigtenor <o1bigtenor@gmail.com>
Date:   Wed, 15 Dec 2021 06:07:52 -0600
Message-ID: <CAPpdf5_+QgEfxNtQCd6Sm8dB6XVN-85351Jc4DDkpdV7xPiG_Q@mail.gmail.com>
Subject: Re: Debugging system hangs
To:     Wols Lists <antlists@youngman.org.uk>
Cc:     linux-raid <linux-raid@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Wed, Dec 15, 2021 at 3:51 AM Wols Lists <antlists@youngman.org.uk> wrote:
>
> Don't know if this is off-topic or not, seeing as my system is very much
> reliant on raid ...
>
> But basically I'm seeing the system just stop responding. Typically it's
> in screensaver mode, I've got a blank screen, and it won't wake up. (I
> used to think it was something to do with Thunderbird, it mostly
> happened while TB was hammering the system, but no ...)
>
> Today, I had it happen while the system was idle but not in screensaver,
> I run xosview, and everything was clearly frozen - including xosview.
>
 I have issues similar to yours but mine are related to using nouveau
drivers on nvidia gpus. I'm running a complicated graphics system so
dunno if that's your issue root.

If you are running nouveau, well - - - then I have some ideas for your
delectation.

Please advise.

Regards
