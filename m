Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6206AC4332F
	for <linux-raid@archiver.kernel.org>; Wed,  6 Apr 2022 21:32:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229957AbiDFVeP (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 6 Apr 2022 17:34:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233700AbiDFVeC (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 6 Apr 2022 17:34:02 -0400
Received: from mail-oi1-x22b.google.com (mail-oi1-x22b.google.com [IPv6:2607:f8b0:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D3DDFD6
        for <linux-raid@vger.kernel.org>; Wed,  6 Apr 2022 13:46:22 -0700 (PDT)
Received: by mail-oi1-x22b.google.com with SMTP id i7so3652915oie.7
        for <linux-raid@vger.kernel.org>; Wed, 06 Apr 2022 13:46:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=/x03XR9R8LYu5uiJ9LCdBgh8R8ikiw2fYmzxHFcHQOw=;
        b=Pes/zF1TPfiFXvkC8X6J2wVxM5VFiInJyMFf6sVzbNh53jpoRTVrFhq82uWtYeZAV+
         UtdB4jQbiCflg4zurey5Tl1rxCXXDbw06hzZ980Cn3NVQslBL5/KcJWDXJaBBmPTWv1T
         jSrLs0wNqqI1jW6ow70hNFbFFVSvwCn8NREf7h/qUJvHSlMV4t3sOv55Ycz74T6cAvzT
         KzJjcnOwEf77sbGo2262hbHnTbaBcRZD976neHLcx1OfPgCFk9+4EzQqihrTFYdQzgre
         +C3LeQ289viFaRLRX7ncijE1Bii4D8p3SoEtRFC622LjHw9c1+w0y+UoIgmvU6YfQSTJ
         THlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=/x03XR9R8LYu5uiJ9LCdBgh8R8ikiw2fYmzxHFcHQOw=;
        b=FzZP/QhEkO4ye+VTmecG8sVHopKivSrC79ewkJatkpIH9O+991xAZ7fJ2r5Wp/E+D6
         n7hsaFO35zEBFEsEvqmmbj9BKVqLAiwGL7DlA96GkOyfeadf/5gFWZSnBdhJi4LN6PX3
         i9qqgnfcYdiHaH9fkQinNn4TE3x5m40ah6la7sm4i9/f9W4cxo5dDxaGXNA6XHC6DsCx
         7oS7FrkSxZLJRQDHBBjxcRB8pkwgpCwwxrqM1z6DCqHmwaIGAQuoDaA/s4V11a0DazcS
         R3KMFqRGYpMxKOY9KviS59MXrO+CufcdTkolGggb2udtsRbtBcmrQketWCmiyRXC7N2S
         +ucg==
X-Gm-Message-State: AOAM533WyQ9/FUu8eQcuehugFV2ZC4cuapv7bHOFsmT90pz86nLnTTYw
        Kg8xuTueyXOAokGdUGxu3lYTxtAU8LIwnNw2AVd/FV7xAQ==
X-Google-Smtp-Source: ABdhPJx4fA4V0jEdomRHVaVyyJYnBugz4czUwEiY5yIlb9Z7U0ZuaeHgmVGtacW4IipKisCzfRDnr8i1JUe6WuaVQb8=
X-Received: by 2002:a05:6808:14c2:b0:2f7:43eb:c824 with SMTP id
 f2-20020a05680814c200b002f743ebc824mr4158883oiw.154.1649277981319; Wed, 06
 Apr 2022 13:46:21 -0700 (PDT)
MIME-Version: 1.0
References: <CANDfL1au6kdEkR3bmLAHTdGV-Rb==8Jy1ZnwNFjvjNq7drC1XA@mail.gmail.com>
 <987997234.3307867.1649118543055.JavaMail.zimbra@karlsbakk.net>
 <336816279.3605676.1649150230084.JavaMail.zimbra@karlsbakk.net>
 <CANDfL1YiKq9aeUsrmdZyLb5Fy98Tifjcr_zZJY6a+LxyqKYKkA@mail.gmail.com> <b9f58b50-3f79-4a81-2f47-0f23a6958e10@youngman.org.uk>
In-Reply-To: <b9f58b50-3f79-4a81-2f47-0f23a6958e10@youngman.org.uk>
From:   Jorge Nunes <jorgebnunes@gmail.com>
Date:   Wed, 6 Apr 2022 21:46:10 +0100
Message-ID: <CANDfL1YiDuLXpdh7tzEepFhoir9r3r+CmQypQ4Ywhq5EN0WPjw@mail.gmail.com>
Subject: Re: RAID 1 to RAID 5 failure
To:     Wols Lists <antlists@youngman.org.uk>
Cc:     Roy Sigurd Karlsbakk <roy@karlsbakk.net>,
        Linux Raid <linux-raid@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi again!

Roy: Thank you for your input. This recovery of the misaligned data
takes a lot of time but I'm keeping this task till the end of the
array.

Wol: Then I'll try this but someone has to guide me to do this shrink
and try to get the initial array alignment.

Thank you both!
Best,
Jorge

Wols Lists <antlists@youngman.org.uk> escreveu no dia quarta,
6/04/2022 =C3=A0(s) 20:57:
>
> On 05/04/2022 11:50, Jorge Nunes wrote:
> > Hi roy.
> >
> > Thank you for your time.
> >
> > Now, I'm doing a photorec on /dev/sda and /dev/sdd and I get better
> > results on (some) of the data recovered if I do it on top of /dev/md0.
> > I don't care anymore about recovering the filesystem, I just want to
> > maximize the quality of data recovered with photorec.
>
> Once you've recovered everything you can, if no-one else has chimed in,
> do try shrinking it back to a 2-disk raid-5. It SHOULD restore your
> original filesystem. You've then just got to find out where it starts -
> what filesystem was it?
>
> If it's an ext4 there's probably a signature which will tell you where
> it starts. Then somebody should be able to tell you how to mount it and
> back it up properly ...
>
> I'm sure there will be clues to other file systems, ask on your distro
> list for more information - the more people who see a request for help,
> the more likely you are to get some.
>
> Cheers,
> Wol
