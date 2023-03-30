Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92873C6FD1D
	for <linux-raid@archiver.kernel.org>; Thu, 30 Mar 2023 04:56:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229598AbjC3E4L (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 30 Mar 2023 00:56:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229527AbjC3E4K (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 30 Mar 2023 00:56:10 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F5E540E8
        for <linux-raid@vger.kernel.org>; Wed, 29 Mar 2023 21:55:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680152121;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=AyTbRFMs97cAScAt4h83Kngqndm2W6jMyHVf8nQ7nPc=;
        b=FR3FtfNpHY/W3sHQed6kcOZLNjJtg2TqS6Kjb1i5nNzoZJrD5fJvP3MhVgjjtP3/G7c6gZ
        XTWLAZ+iwehEBY4Rr9MJ6QkXNj218U23xWB7gQdDrUBKUhXH+HLAbDRuKW1hIP2jEPheHS
        SQ9DpOXGGxXQo1/I/YrOWzeDoGnIa2Y=
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com
 [209.85.214.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-608-dg2aaV0qOy2X6lQZ8V9BDw-1; Thu, 30 Mar 2023 00:55:20 -0400
X-MC-Unique: dg2aaV0qOy2X6lQZ8V9BDw-1
Received: by mail-pl1-f200.google.com with SMTP id n13-20020a170902d2cd00b001a22d27406bso8860811plc.13
        for <linux-raid@vger.kernel.org>; Wed, 29 Mar 2023 21:55:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680152119;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=AyTbRFMs97cAScAt4h83Kngqndm2W6jMyHVf8nQ7nPc=;
        b=V0e3SdxhSs59XQ/vrVh6x8GRsyUpBe1pTP8fjGJw/bgQLTyHsaebPl0Msqt2LXzurb
         jXzKN319nPJTzEXeawG38NQ9hKsiJ3l6YKv0CVC5U1Nb15n821Y+6i4d70DVNXMMTKoe
         hY8ZudPN/+UyXsuRJq5aWeeTC9sCWHPdV9Rpyboi1GmfMs3/Q5Pp+ul6YJyFEbcybRjh
         kwKo+A2YvXzJAmqBLOnXd5KcUJiWdBzo+9jF4YJ0jYyLdgItXfzLGdFwifHNxpbIlofD
         mA9ij2HmEMzxt3z38NCurhW9u+6b0aiYWD/Zo3SnVa2pc4oEzTmteN5UESoyLvnUQeQR
         tl1A==
X-Gm-Message-State: AAQBX9fQgtE1PmoGAPOAFfLOFyT5KxKduMcIOTaeevSi63B0dpqfN/PB
        LPUox6ahuVNCpgWRgcXK7JUy/oakGk25Mrca4WkttusyrUmf9+HyWKru3Me0rG9y907b+16lltH
        QxGSKVMQP5OgcuiUYE2sqoQbKsW0ciA3+KKrrVw==
X-Received: by 2002:a17:903:455:b0:1a2:6e4d:782c with SMTP id iw21-20020a170903045500b001a26e4d782cmr1824100plb.13.1680152119327;
        Wed, 29 Mar 2023 21:55:19 -0700 (PDT)
X-Google-Smtp-Source: AKy350ZYn0YlGsE5d5/SvE3Xa4cQ9vWiHdShQwzms32z6+pM0mJhEaSXBrBGrhkAmiD4sB8++tb6bmQuv0Phxtq0AvQ=
X-Received: by 2002:a17:903:455:b0:1a2:6e4d:782c with SMTP id
 iw21-20020a170903045500b001a26e4d782cmr1824087plb.13.1680152118983; Wed, 29
 Mar 2023 21:55:18 -0700 (PDT)
MIME-Version: 1.0
References: <167875238571.8008.9808655454439667586@noble.neil.brown.name>
 <CALTww2916uiO8_ViJQXutO2BPasFmiUJtfz8MxW0HKjDzwGFeQ@mail.gmail.com>
 <167945548970.8008.8910680813298326328@noble.neil.brown.name>
 <168012671413.8106.6812573281942242445@noble.neil.brown.name>
 <CALTww28X1NQecTY3Jbkz_wbHc_N7GOw3hJLEyb2YnxAmQ8PRFw@mail.gmail.com> <168014613094.14629.7292916705339147692@noble.neil.brown.name>
In-Reply-To: <168014613094.14629.7292916705339147692@noble.neil.brown.name>
From:   Xiao Ni <xni@redhat.com>
Date:   Thu, 30 Mar 2023 12:55:07 +0800
Message-ID: <CALTww29CN4iqmneiAG31kZDBubCMop=gg299hdW-TXCNq1c4gQ@mail.gmail.com>
Subject: Re: [PATCH - mdadm] mdopen: always try create_named_array()
To:     NeilBrown <neilb@suse.de>
Cc:     Jes Sorensen <jes@trained-monkey.org>,
        Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>,
        Song Liu <song@kernel.org>,
        Linux regressions mailing list <regressions@lists.linux.dev>,
        linux-raid <linux-raid@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Nikolay Kichukov <hijacker@oldum.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Thu, Mar 30, 2023 at 11:15=E2=80=AFAM NeilBrown <neilb@suse.de> wrote:
>
> On Thu, 30 Mar 2023, Xiao Ni wrote:
> > On Thu, Mar 30, 2023 at 5:52=E2=80=AFAM NeilBrown <neilb@suse.de> wrote=
:
> > >
> > > On Wed, 22 Mar 2023, NeilBrown wrote:
> > > > On Wed, 22 Mar 2023, Xiao Ni wrote:
> > > >
> > > > >
> > > > > Second, are there possibilities that the arguments "dev" and "nam=
e" of
> > > > > function create_mddev
> > > > > are null at the same time?
> > > >
> > > > No.  For Build or Create, dev is never NULL.  For Assemble and
> > > > Incremental, name is never NULL.
> > > >
> > >
> > > I should clarify this a bit.  For Assemble and Incremental, "name" is
> > > never NULL *but* it might be an empty string.
> > > So:
> > >         if (name && name[0] =3D=3D 0)
> > >                 name =3D NULL;
> > >
> > > might cause it to become NULL.  So you cannot assume there is always
> > > either a valid "dev" or a valid "name".  "dev" might be NULL, and "na=
me"
> > > might be "".
> > >
> > > NeilBrown
> > >
> >
> > Hi Neil
> >
> > The input argument name should be the metadata name. For incremental
> > and assemble, why are there possibilities that the metadata name is
> > invalid? A raid device should have a valid metadata name, right?
>
> "should" do, yes.  But you can never completely trust data on disk.  It
> is safest to be prepared for "name" being "".
>
> NeilBrown
>

That's right, thanks for this explanation :)

--=20
Best Regards
Xiao Ni

