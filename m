Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D29AC433F5
	for <linux-raid@archiver.kernel.org>; Thu, 16 Dec 2021 21:50:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233997AbhLPVuy (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 16 Dec 2021 16:50:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229840AbhLPVuy (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 16 Dec 2021 16:50:54 -0500
Received: from mail-qt1-x831.google.com (mail-qt1-x831.google.com [IPv6:2607:f8b0:4864:20::831])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1FAEC061574
        for <linux-raid@vger.kernel.org>; Thu, 16 Dec 2021 13:50:53 -0800 (PST)
Received: by mail-qt1-x831.google.com with SMTP id q14so671924qtx.10
        for <linux-raid@vger.kernel.org>; Thu, 16 Dec 2021 13:50:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=4ZfnGiW50KmrZS3xbZz941JMbee24yVU4Ss55mrruSQ=;
        b=a2fbEPPL1o5BcXJ4lfGDBbgjdPenChS5gmsDgeTza6hHFT1I18RoWXcTXa0f/l+1at
         d87rZnLUL4uAXrH5H1B0CJfmS6vz04hd5bUzT4Jy0Wp11+iDyd79xWQ8jF3Z5RF0HsAx
         q6iuawln0wstO2qSSVkn24vlyky0u9AuPzbneG8J2GsOOexxBLejsD/IXxX97A2DuLse
         067oCrY25MkdJVvp5Ga8DxGqorkVhw3CUDhOo381hCZhRCTRIPk2aFiDPqOBPYrhgHDI
         rzd3lBwqrx86B8hTo5M8YKjpgtw9Bc1dSO4Boy0cJG6kF6FjwFL4LZVAIKmnhGQARLXU
         so9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4ZfnGiW50KmrZS3xbZz941JMbee24yVU4Ss55mrruSQ=;
        b=mrihJDN/y8Jy3ex7QOErVhBQX4IWMK4bftVpl2Cx37wCqVD5v1CaSDrDEGUbG8onGT
         nG683nW/zKPhYz6vX1l/pGCVmNLp3mQnKQhkqqbswclFGweUIRROKvfYVWIPrQVcu5UV
         dNUHxsfY0FQWqxqpv7Ra6bX6txALb1K8zQkmvgGOsVgMXBEE/3z228WXMUOltvgxpWel
         8dORzScfuYv9R5DoCoE8AyhKRFzGIv6DZ01lyQj1isjUEd5zMGsmGFWeLcuvLggDPxUQ
         edd6WIW5e0BV3DvLMV7AXjRBIuW29MkyRA5xGCddUfVbZvTxAyr+iXynuBkzbfKUcy/1
         mkOA==
X-Gm-Message-State: AOAM532KAowlG69AOcaosKQp2aYEnaJccWrQ2TW+Gru8QemEXEbXVtHy
        i2WOeXSnuYfRc7Br58aSorQfiRCmTtEvHZwvZ+6cLZsF
X-Google-Smtp-Source: ABdhPJxCAKl5fZqpxHxYw+mwlvZZiEdL4BWgMWPqiE+3HjPEW8Y6AJPNeWBEvOqkgeqLrTRvRdJwhwaSbMteJfdEj2Q=
X-Received: by 2002:a05:622a:a:: with SMTP id x10mr18711584qtw.516.1639691453090;
 Thu, 16 Dec 2021 13:50:53 -0800 (PST)
MIME-Version: 1.0
References: <d8a0d8c9-f8cc-a70a-03a0-aae2fd6c68c2@youngman.org.uk>
 <CAAMCDeekr+a6e7BwyF9b=n49X6YgqUWBc8UtAyZkjFcHBnbyRQ@mail.gmail.com>
 <cbfc2f45-96d8-4ee7-a12b-5a24bd2f2159@youngman.org.uk> <CAAMCDeemZO2u_4WW8pHVP2qOxz0HdHQTy2Gsa=zgY-7g4ptw7w@mail.gmail.com>
 <25019.45839.872620.235430@quad.stoffel.home>
In-Reply-To: <25019.45839.872620.235430@quad.stoffel.home>
From:   Roger Heflin <rogerheflin@gmail.com>
Date:   Thu, 16 Dec 2021 15:50:40 -0600
Message-ID: <CAAMCDedKxvcXMzeBRjfU6mqLyZSFz=bMzZtJpPeHaLQUFgq48g@mail.gmail.com>
Subject: Re: Debugging system hangs
To:     John Stoffel <john@stoffel.org>
Cc:     Wol <antlists@youngman.org.uk>,
        linux-raid <linux-raid@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

If the power supply cannot handle it the node will flat out crash.

There is no mechanism for the cpu/memory/mb to deal with a power
supply unable to supply enough.

The load going up will likely be something else, I have never seen hw
show as that.

On Thu, Dec 16, 2021 at 3:43 PM John Stoffel <john@stoffel.org> wrote:
>
>
> Another thing that struck me is maybe it's time to boot into a small
> stress testing image and see if it's more of a hardware issue.  It
> might also be a power supply issue, where as the load goes up, your
> power supply can't keep the voltage up and the system fails that way?
>
> There's the 'stress-ng' package for beating on systems.  And I think
> I've used 'sysrecue' in the past to boot up systems and run stress
> tests.
>
> Getting the regular OS out of the way with something lower level and
> simpler to stress test the hardware is a good idea.
>
> https://www.stresslinux.org/sl/
>
> Might be another good option.
>
> Good luck!
> John
