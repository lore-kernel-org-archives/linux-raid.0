Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 577CFEB64DD
	for <linux-raid@archiver.kernel.org>; Sun, 25 Jun 2023 22:34:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229558AbjFYWb4 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sun, 25 Jun 2023 18:31:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229452AbjFYWbz (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sun, 25 Jun 2023 18:31:55 -0400
Received: from mail-il1-x12f.google.com (mail-il1-x12f.google.com [IPv6:2607:f8b0:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 498D5BB
        for <linux-raid@vger.kernel.org>; Sun, 25 Jun 2023 15:31:54 -0700 (PDT)
Received: by mail-il1-x12f.google.com with SMTP id e9e14a558f8ab-3422d37d316so11502985ab.3
        for <linux-raid@vger.kernel.org>; Sun, 25 Jun 2023 15:31:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1687732313; x=1690324313;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qswVKjk/0iWBx0AKoAD00ukfxGx83GcL0uO/EGetD/4=;
        b=fBiu9ar9D5fVPhj7wxMvNReDcFRudM0Y6AP4wdiv1c81aa5oEgGBzjICdihaDFoq3n
         oVqOURT+Vwe7nXcYwLHTz7Eg7JGB/Rn0nmLg05yoV3Rgo6zhOsuc2JKG0WJWrq8KjG7I
         +2g5KjFgrj+i4VbQg9313j1g8hyRUMUgxrQYLmHeYWlvjDiTIoH7p5LryE/B2a1tn9ir
         aTVbBO13z9W+tYsSMnhaOVaC5xGPhmGjEt5Azg6ATcJALfM17TnOyiD4XRIgFXZ1MNWr
         JCNIXyzzoQ9U9kb6dOEjo036fUb2Xk/IcvC5mQskfXVfrTG/4OB6bvFwkzm3hq8ir5yD
         Yr5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687732313; x=1690324313;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qswVKjk/0iWBx0AKoAD00ukfxGx83GcL0uO/EGetD/4=;
        b=SEeX4r5hIkSReJC5U1Y5bJZgWCZTE4YtDAEvgdQyRblnFNtYT2LFeBZDNDSlJV9fr9
         xLGzeRdZ5bFrfAk9ZkohzjVDSmIoeRr4vWYYrUwdgfc+t9T7bJRYUDo5N50c22HwtNAj
         09L+oFS+cea1aPRf+qDjtevzFwnTlfw095VqdcyYzo7tPHtkiyoOnHghArG4BuzhDYiV
         lY1OohNAZMzRjm5YWL5dvAHGriQ6NDRCCXHlf/ZuIHYsDns+1Nwf4FbjBkqfxgEBqjSL
         wfAOzSmaZMD8+peI+QWjZm5Xa1QOuDQhj4lsg0j2dC+kMeRCYIxC1SAQul0J1O8Q/ba5
         qlcQ==
X-Gm-Message-State: AC+VfDyMOIMGjWXG19Lw8CUNoF3TizykYUl3+rzRFVzxV2paXtmlx9Sq
        IHTvBccm7AcYpFDtx5nQ+22ULCez1nIndn5XK18=
X-Google-Smtp-Source: ACHHUZ42dm9Q7klf7g5QAI5z8YEixhDDBlwr35aFw7bDuz7m7JzWxoBieoQnTBfFRzF2qywT7QVlR478muxRbK9hJfc=
X-Received: by 2002:a92:d2c8:0:b0:345:7e1d:ab9d with SMTP id
 w8-20020a92d2c8000000b003457e1dab9dmr3361544ilg.24.1687732313344; Sun, 25 Jun
 2023 15:31:53 -0700 (PDT)
MIME-Version: 1.0
References: <CAO2ABipzbw6QL5eNa44CQHjiVa-LTvS696Mh9QaTw+qsUKFUCw@mail.gmail.com>
 <6fcbab2f-8211-774a-7aa9-883ed5d74168@huaweicloud.com> <CAO2ABiq5bB0cD7c+cS1Vw2PqSZNadyXUgonfEH6Gwsz8d9OiTQ@mail.gmail.com>
 <04036a22-c0b0-8ca1-0220-a531c47a1e25@huaweicloud.com> <CAO2ABioUC9Wy=7FaPAP+AUmd5S-Xanj2d9JJYkqU4BL8DxW5Bg@mail.gmail.com>
 <b1252ee9-4309-a1a9-d2c4-3e278a3e70b6@huaweicloud.com> <CAO2ABioXHT9c4qPx5S4dKsMZLyE0xLGBzST5tSTu8YPmX4FxYQ@mail.gmail.com>
 <51a28406-f850-5f4e-1d2d-87c06df75a9d@huaweicloud.com> <CAO2ABiqEoi4iB__b7KdYu_jQqmeB8joh5xurHNeXj9583mcjjA@mail.gmail.com>
 <1392b816-bdaf-da5f-acc8-b6677aa71e3b@huaweicloud.com> <CAO2ABiqkg7HobNvXRWrid36+uYwZ3yHqLmbft_FQwzD9-B7mRg@mail.gmail.com>
 <CAAMCDec_qt0wsfQ6d1CWc4e3hYtzXabw_sK9ChjMUSkA0cPxXg@mail.gmail.com>
 <d32a481b-4160-da34-8a1e-303c44d835f7@huaweicloud.com> <CAO2ABipBVa3c6v72TG32Ggf+FX+Zm5B5cniNgP_PPvDyaS9OZA@mail.gmail.com>
In-Reply-To: <CAO2ABipBVa3c6v72TG32Ggf+FX+Zm5B5cniNgP_PPvDyaS9OZA@mail.gmail.com>
From:   Roger Heflin <rogerheflin@gmail.com>
Date:   Sun, 25 Jun 2023 17:31:42 -0500
Message-ID: <CAAMCDeeXDViojSiSYsnkdeVseziyBcUcx1PfBOuH8Ndc2hKgbA@mail.gmail.com>
Subject: Re: mdadm grow raid 5 to 6 failure (crash)
To:     David Gilmour <dgilmour76@gmail.com>
Cc:     Yu Kuai <yukuai1@huaweicloud.com>, linux-raid@vger.kernel.org,
        Song Liu <song@kernel.org>, "yukuai (C)" <yukuai3@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

I won't buy a marvell.    I had some sort of 92xx variant (2 pci-e
lanes) and it had a bad habit of stopping working under load and
causing all 4 ports to go offline.   Board maker blamed the driver
except the driver is/was the generic AHCI so unlikely to be the issue
since all other ports were also AHCI and were just fine.

Best luck is a used LSI SAS controller.   You can get 8 ports off of
one, but you may need a breakout cable to use for 4 sata devices.

On Fri, Jun 23, 2023 at 2:17=E2=80=AFPM David Gilmour <dgilmour76@gmail.com=
> wrote:
>
> I wanted to provide an update on this thread. First of all thank you
> for all the insights and recommendations. I finally found a way to
> recover my data and wanted to pass what the fix was in the event
> someone stumbles across this exact scenario. Summary below
>  - I believe there is some kind of problem with kernel or module in
> 5.14.0-319.el9.x86_64 for my controller (ASMedia ASM1064 chipset)
> which I believe was responsible for the drives attached to it
> disappearing while my grow from raid 5 to raid 6 was taking place
>  - After the above event (and rebooting) whenever I tried to assemble
> the raid to kick off resuming the rebuild mdadm would hang as
> previously described in this thread.
>  - After Yu pointed me to a patch that might of bypass the issue I
> decided to first boot the system on a rescue disk with an older kernel
> (3.x) and mdadm version
>  - Fortunately, my assemble succeeded and the grow resumed and the
> slow rebuild of my 30TB array completed 17 days later
>  - My ASMedia ASM1064 chipset controller was 100% stable for the 17
> days of rebuild on the old kernel
>  - As soon as I went back to my 5.14.0-319.el9.x86_64 kernel my
> ASMedia ASM1064 controller started showing ata timeout errors and
> drives disappearing again
>  - I ended up just purchasing another controller with a different
> chipset (Marvell 88SE9215) out of desperation and the system is
> finally stable and my data is all intact!
>
> Again thank you everyone for the help!
>
> --David
>
>
> On Mon, May 8, 2023 at 8:33=E2=80=AFPM Yu Kuai <yukuai1@huaweicloud.com> =
wrote:
> >
> > Hi,
> >
> > =E5=9C=A8 2023/05/09 6:53, Roger Heflin =E5=86=99=E9=81=93:
> > > On Mon, May 8, 2023 at 6:57=E2=80=AFAM David Gilmour <dgilmour76@gmai=
l.com> wrote:
> > >>
> > >> Ok, well I'm willing to try anything at this point. Do you need
> > >> anything from me for a patch? Here is my current kernel details:
> > >
> > > grep -i mdadm /etc/udev/rules.d/* /lib/udev/rules.d/*
> > >
> > > If you can find a udev rule that starts up the monitor then move that
> > > rule out of the directory, so that on the next assemble try it does
> > > not get started.
> > >
> > > If this is the recent bug that is being discussed then anything
> > > accessing the array after the reshape will deadlock the array and the
> > > reshape.
> >
> > It's not anything accessing the array, in fact, it's only the io accros=
s
> > reshape position can trigger the deadlock.
> >
> > I just posted a fix patch in the other thread by failing such io while
> > reshape can't make progress. However, I'm not sure for now if this will
> > break mdadm, for example, will mdadm must read something from array to
> > make progress?
> >
> > Thanks,
> > Kuai
> > > .
> > >
> >
