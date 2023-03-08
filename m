Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8B7AC678D5
	for <linux-raid@archiver.kernel.org>; Wed,  8 Mar 2023 02:41:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229662AbjCHClG (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 7 Mar 2023 21:41:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229477AbjCHClF (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 7 Mar 2023 21:41:05 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D27A1A80F2
        for <linux-raid@vger.kernel.org>; Tue,  7 Mar 2023 18:40:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1678243219;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/PV6gTkl8fcF3ysfWxidnYxZRygObaEZiWEssu9qg/o=;
        b=T/1DBOBjJGu/yPXbaRfIiy/6SnCMlbbOWawE8Ve7lE8CfDt788FPc8C2eMwmnxfz27N6PJ
        DL9ETJGctdpXEqFvj8MNSb86NlKp8hwdFAUVqQjo0fPEKznyExs0Rr3LX4x8MZ699RfqIc
        6wEweDcIVX0KQvEyZCUwEsFPfmcYNJw=
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com
 [209.85.216.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-380-6CiafahsN-eajIxvNo10XQ-1; Tue, 07 Mar 2023 21:40:17 -0500
X-MC-Unique: 6CiafahsN-eajIxvNo10XQ-1
Received: by mail-pj1-f69.google.com with SMTP id gf1-20020a17090ac7c100b002369bf87b7aso288920pjb.8
        for <linux-raid@vger.kernel.org>; Tue, 07 Mar 2023 18:40:17 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678243216;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/PV6gTkl8fcF3ysfWxidnYxZRygObaEZiWEssu9qg/o=;
        b=JULBYwLFo9zVJ/Tjj89VQn7O4T5CwOpkbzqtL0nHKTa8rYYSiy8Yv7GylWKggrbneh
         1PArZAc0/NWxf3JC6k5vmmuQZ0KhNBLWWo9QexBpSrGoN5e+pCELFaDXm1AMEVB4CAAK
         NZEjZUcrg8VhXbg1LZIYnALtaMpjl28V2DesSNCIBpHKq9KVf2zeh0qnm27d7qdXkQMz
         j9AWD5EmvJL+WCWVDFj3jiF8U5CgkT8WAtQX13WFAxRU9L3K0GJ6L53NhjpCjGwzbU09
         6zIH7621yDzK7oPbwJzer4WViSTSO7drRO1DrfrWQgu36m5lmnKzgrbdVIihkQLHShtq
         4htg==
X-Gm-Message-State: AO0yUKUzwKIht0EKlcxySCcQMUGYMsp+VH2yKpQzqJjgVFAaxap+PSGB
        PQcDxhdTKLy2pQOnpPfJ2PuDZihy40DZgOy+5HuUUeuK9m41Xx7QxQoE2s6IBllGiN/3buQe03o
        RuiQdmklY+lONL4tr4ncYuxlk5ySEujKPGKYTvoMyTwD8YxL4
X-Received: by 2002:a63:2959:0:b0:503:7bcd:89e9 with SMTP id bu25-20020a632959000000b005037bcd89e9mr6008004pgb.1.1678243216566;
        Tue, 07 Mar 2023 18:40:16 -0800 (PST)
X-Google-Smtp-Source: AK7set81db2O3MjvrBkMme259gijKeFag4sZCqqVVX9CpeX088pcw5RqkOLD+6QAOamczKm3XM7MbKHVpD0SgVsFswc=
X-Received: by 2002:a63:2959:0:b0:503:7bcd:89e9 with SMTP id
 bu25-20020a632959000000b005037bcd89e9mr6007997pgb.1.1678243216153; Tue, 07
 Mar 2023 18:40:16 -0800 (PST)
MIME-Version: 1.0
References: <CALTww2-1B08z+BgPKqoBMnGQ-PhB9Yr=bA7YR7HyzGX0K127MQ@mail.gmail.com>
 <2b52d846-054b-6265-21dc-b091b39b0ee9@demonlair.co.uk>
In-Reply-To: <2b52d846-054b-6265-21dc-b091b39b0ee9@demonlair.co.uk>
From:   Xiao Ni <xni@redhat.com>
Date:   Wed, 8 Mar 2023 10:40:04 +0800
Message-ID: <CALTww2-7O2Fj3E8gmLDb_XPb0NGARqvHXp3oJaDMeWFue_=yGQ@mail.gmail.com>
Subject: Re: What's the usage of md-autodetect.c
To:     Geoff Back <geoff@demonlair.co.uk>
Cc:     linux-raid <linux-raid@vger.kernel.org>,
        Nigel Croxon <ncroxon@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Tue, Mar 7, 2023 at 7:00=E2=80=AFPM Geoff Back <geoff@demonlair.co.uk> w=
rote:
>
> Hello,
>
> MD Autodetect allows for the assembly of raid-1 mirror filesystems
> in-kernel before userspace starts, without requiring the complexity and
> fragility of using an initrd and switch-root.
> It is still in widespread use and given that it has a wide use case in
> any system that wants fully resilient boot/root devices (which can be
> done even on EFI) is likely to remain essential.  While the various
> high-profile general purpose Linux distributions such as Red Hat and
> Ubuntu may use initrd by default, there are innumerable scenarios,
> particularly in embedded space, where initrd is never used but RAID may
> be and hence auto-detect is used to assemble the actual root file system.

Hi Geoff

Thanks for the explanation.

>
> Removing it would be a major regression in 'md' functionality.
>
> Yes, it requires CONFIG_MD and the appropriate RAID personality
> (typically CONFIG_MD_RAID1) to be set to 'y' in Kconfig.  It doesn't

raid1 can be loaded automatically. So it doesn't need to set
CONFIG_MD_RAID1 to y.

> (IIRC) get built if CONFIG_MD is set to M.  Changing the default for
> CONFIG_MD should not have any impact on this so long as the ability to
> set CONFIG_MD=3Dy does not get disabled (which would also be a regression=
).

I'm a little confused here. If I understand right, for the os that
doesn't use initrd
and we still have the ability to set CONFIG_MD=3Dy, so we can set it to
y and rebuild
the kernel. So the raid1 can be assembled by md auto-detect, right?

>
> If auto-detect were to be considered for removal then IMO it needs to go
> through the full kernel feature deprecation/removal life cycle - i.e.
> first it gets marked as deprecated in KConfig, then after a decent time
> interval (years?) the default for the option is changed, and only after
> that has all happened without causing problems, the code gets considered
> for removal.

Thanks for this information

Regards
Xiao

>
> Regards,
>
> Geoff.
>
> Geoff Back
> What if we're all just characters in someone's nightmares?
>
> On 07/03/2023 03:04, Xiao Ni wrote:
> > From the code of md-autodetect.c, it looks like it's used to create
> > the raid device
> > during boot. Now we use udev rules to assemble the raid. Do we still ne=
ed it?
> > What's the usage of md-autodetect?
> >
> > And in Kconfig, it depends on md-raid as Y when building a kernel. If w=
e change
> > the default to M, md-autodetect will not work anymore, right?
> >
> > Best Regards
> > Xiao
> >
>

