Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F112C2B9F4
	for <linux-raid@archiver.kernel.org>; Tue, 22 Jun 2021 13:56:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 56AD160FF4
	for <linux-raid@archiver.kernel.org>; Tue, 22 Jun 2021 13:56:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231273AbhFVN7C (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 22 Jun 2021 09:59:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229988AbhFVN7B (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 22 Jun 2021 09:59:01 -0400
Received: from mail-qk1-x732.google.com (mail-qk1-x732.google.com [IPv6:2607:f8b0:4864:20::732])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA29EC061574
        for <linux-raid@vger.kernel.org>; Tue, 22 Jun 2021 06:56:45 -0700 (PDT)
Received: by mail-qk1-x732.google.com with SMTP id bj15so37897945qkb.11
        for <linux-raid@vger.kernel.org>; Tue, 22 Jun 2021 06:56:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding;
        bh=zPtZlp22yV3fSEYE3CgjvMgnBPY7El+6w+oNtsb8Qn0=;
        b=dRUzGRA0oqQRyJL8lXDjfqR5iOSLx5MRylxNp5AEmusrz7CmImvrfqd/i9iMtsvgeR
         uJGqbxwxHCYTu2uA6BQOKvqH34bAW2gM0B2EYAPcp2zGrYP+gbIxJc/Hp2a5g5jXcpnr
         Gg2rwkilCNYXM4j2VUab27Z7rfNKguQeOd/+Jz4luxHlBRrIUu/4nVGpbQhlWmIyqlBz
         QuHjERh5BjKi7fYLAmd8mWP0wOlSdLRWESuanrk9W7894hAySWsyOqwKDQl+bfoU/i4Q
         n9oVMd5uTrOZ0eONxcn+LSHi1sc/tUMPcnhPmhCHFDgjRHZXXuDxX93WZG6oFDzocAld
         qeiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding;
        bh=zPtZlp22yV3fSEYE3CgjvMgnBPY7El+6w+oNtsb8Qn0=;
        b=GwxHq2xZn1ijUhW61Jyc9cw1CKqSbkZU0+diaWViAEey5uKGUTwFQBdSzLMUHaUJiw
         161TdZnZaks8ePby+Sy3gKnJ3lyV4TFPn0uQ3ahGQa25QROxHbE+Lf7DBmcKDy9lOq6y
         kb0ylHXzttC5X30TtXD0BoiaSwO94aJxyfQaFidMN3soa5rqVin5u26zKBST/j0S1WYK
         0X8r9Wr48EZsGCuwk6w4zfyIfa30R4aMaU3p2w2TSgMxDEOXwqhQinqxFqWcKknNSLvK
         FXs8XjNqg4JXAUQuQbgcpVrYjLWp7dPejplpZV56PFow6HH8NjXugMzH2wb2iWpyM5BC
         Y7Ug==
X-Gm-Message-State: AOAM531+MCTscveNkU/Fw+fXTsc2JT5Y8frhWkqYn+aKo93G6Gcv04yo
        zZOc1P7ova4xCoeYsoknhvrEUeEi/sU=
X-Google-Smtp-Source: ABdhPJzASk3B9REGGYmeZxC/MgV0yD7R9ZJXEGD9jLc6uZUz107OCB88HVGBKDpJKn95UfZlam2dOg==
X-Received: by 2002:a05:620a:1509:: with SMTP id i9mr4234697qkk.353.1624370203668;
        Tue, 22 Jun 2021 06:56:43 -0700 (PDT)
Received: from hera.hudaceks.home (158-247-72-95.car1-wispds4-pool60.amplex.net. [158.247.72.95])
        by smtp.gmail.com with ESMTPSA id m11sm1676133qtn.81.2021.06.22.06.56.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 22 Jun 2021 06:56:43 -0700 (PDT)
Subject: Re: Question: RAID cabinet for home use (vs "Backplane/Cage/Mobile
 Rack"?)
To:     Roger Heflin <rogerheflin@gmail.com>
Cc:     mdraid <linux-raid@vger.kernel.org>
References: <03ca5974-60ed-d596-7eff-cac44f4a6d62@gmail.com>
 <CAAMCDedp11LuFuqV15NTPWv0wpCSvsp+VHPBBYN0euegm=5_Bg@mail.gmail.com>
From:   Bill Hudacek <bill.hudacek@gmail.com>
Message-ID: <e63d0625-cf75-9a67-df61-23111020e58e@gmail.com>
Date:   Tue, 22 Jun 2021 09:56:42 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.0
MIME-Version: 1.0
In-Reply-To: <CAAMCDedp11LuFuqV15NTPWv0wpCSvsp+VHPBBYN0euegm=5_Bg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Roger Heflin wrote on 6/21/21 8:03 PM:
 > I have been using the 4 drives in to 3x5.25 bays and have a cheap=20
10x5.25 bay case..=C2=A0 These 4 into 3 bay devices are all direct sata=20
connections with minimal electronics and you need 4 sata connections,=20
but less than 4 power connectors.=C2=A0 They are hot swap and usually hav=
e=20
disk activity lights and usually have fans.
 >
 > The brand I have used in the past is IcyDock.
 >
 > There are few components to go wrong so they are really direct sata=20
and/or sas connections. with very limited electronics to go wrong, but=20
you need one port per drive.
 >

I looked at that '4 into 3 bay device' - seems to be intended for=20
internal use, not a cabinet sitting on a shelf.=C2=A0 And - I need five=20
bays to be able to just move my drives rather than redesign my storage.

What is your 'cheap 10x5.25 bay case'? My drives are 3.5 but that=20
manufacturer may offer either drive adapters or a 3.5-based unit.

I found another product from Icy Dock -=20
https://www.amazon.com/ICY-DOCK-MB975SP-B-R1-Tray-less/dp/B06X9P4BYL?th=3D=
1=20
- but that requires an SATA connection for *each drive* (rather than=20
port multiplier). This is more a backplane extender than a RAID cabinet.

I could of course replace the controller that I added-on so long ago -=20
the card in the computer is a pedestrian "Marvell 88SE9123 PCIe SATA=20
6.0 Gb/s controller" (but it has port multiplier, so 1 eSATA=20
connection serves all 5 drives - which is pretty nice).

I've worked with 'octopus' SCSI controllers (in a data center, long=20
time ago) with 8 cables coming out the back. I'm not sure what I would=20
be able to find for a SATA external cabinet like the 'FlexCage' above.=20
Does anyone have any controller suggestions for the FlexCage? With 5=20
or more external 'pure' SATA connectors/ports instead of eSATA?

I'll poke around a bit more. Thanks for the tip - I'd never heard of=20
Icy Dock or a '4 into 3 bay device' (what an awkward phrase :-) .

/Bill

 > On Mon, Jun 21, 2021 at 4:12 PM Bill Hudacek=20
<bill.hudacek@gmail.com> wrote:
 >
 >=C2=A0=C2=A0=C2=A0=C2=A0 My 2021 Sans Digital TR5UT+B held 5 SATA disks=
=2E I had an eSATA
 >=C2=A0=C2=A0=C2=A0=C2=A0 connection to the host box. It went belly-up a=
 few weeks ago.
 >
 >=C2=A0=C2=A0=C2=A0=C2=A0 After some careful searching, a good replaceme=
nt seemed to be=20
the Oyen
 >=C2=A0=C2=A0=C2=A0=C2=A0 Digital Mobius 3R5-EB3-M. Found it for about $=
300USD.
 >
 >=C2=A0=C2=A0=C2=A0=C2=A0 It was plug-and-play replace. Drives were bein=
g addressed by=20
UUID in
 >=C2=A0=C2=A0=C2=A0=C2=A0 Fedora so no issues at all. It came right up.
 >
 >=C2=A0=C2=A0=C2=A0=C2=A0 However, smart reporting looks horrible even c=
ompared to the=20
TR5UT+B
 >=C2=A0=C2=A0=C2=A0=C2=A0 (which had its own issues).
 >
 >=C2=A0=C2=A0=C2=A0=C2=A0 Here's what the TR5UT+B (old cabinet) reported=
 for one disk in the
 >=C2=A0=C2=A0=C2=A0=C2=A0 unit (just the header section of smartctl -a):=

 >
 >=C2=A0=C2=A0=C2=A0=C2=A0 =3D=3D=3D START OF INFORMATION SECTION =3D=3D=3D=

 >=C2=A0=C2=A0=C2=A0=C2=A0 Model Family:=C2=A0=C2=A0=C2=A0=C2=A0 Western =
Digital Red
 >=C2=A0=C2=A0=C2=A0=C2=A0 Device Model:=C2=A0=C2=A0=C2=A0=C2=A0 WDC WD20=
EFRX-68EUZN0
 >=C2=A0=C2=A0=C2=A0=C2=A0 Serial Number:=C2=A0=C2=A0=C2=A0 WD-WCC4M6HX8X=
CR
 >=C2=A0=C2=A0=C2=A0=C2=A0 Firmware Version: 0957
 >=C2=A0=C2=A0=C2=A0=C2=A0 User Capacity:=C2=A0=C2=A0=C2=A0 2,000,398,934=
,016 bytes [2.00 TB]
 >=C2=A0=C2=A0=C2=A0=C2=A0 Sector Size:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 512=
 bytes logical/physical
 >=C2=A0=C2=A0=C2=A0=C2=A0 Device is:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 In smartctl database [for details use: -P show]
 >
 >=C2=A0=C2=A0=C2=A0=C2=A0 Here's what the Mobius reports now for the sam=
e disk:
 >
 >=C2=A0=C2=A0=C2=A0=C2=A0 =3D=3D=3D START OF INFORMATION SECTION =3D=3D=3D=

 >=C2=A0=C2=A0=C2=A0=C2=A0 Device Model:=C2=A0=C2=A0=C2=A0=C2=A0 Mobius=C2=
=A0 DISK1
 >=C2=A0=C2=A0=C2=A0=C2=A0 Serial Number:=C2=A0=C2=A0=C2=A0 WD-WCC4M6HX8X=
CR
 >=C2=A0=C2=A0=C2=A0=C2=A0 Firmware Version: 0962
 >=C2=A0=C2=A0=C2=A0=C2=A0 User Capacity:=C2=A0=C2=A0=C2=A0 2,000,398,934=
,016 bytes [2.00 TB]
 >=C2=A0=C2=A0=C2=A0=C2=A0 Sector Size:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 512=
 bytes logical/physical
 >=C2=A0=C2=A0=C2=A0=C2=A0 Device is:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 Not in smartctl database [for details use: -P=20
showall]
 >
 >=C2=A0=C2=A0=C2=A0=C2=A0 The disk model is gone. The firmware version i=
s wrong (cabinet=20
instead
 >=C2=A0=C2=A0=C2=A0=C2=A0 of disk?!). I imagine firmware updates are imp=
ossible here.
 >
 >=C2=A0=C2=A0=C2=A0=C2=A0 The rest of it is unimpressive, too. No SCT (T=
LER) at all - not=20
just
 >=C2=A0=C2=A0=C2=A0=C2=A0 ERC, but SCT Status, SCT Feature Control, SCT =
Data Table are all
 >=C2=A0=C2=A0=C2=A0=C2=A0 missing too.
 >
 >=C2=A0=C2=A0=C2=A0=C2=A0 All the disks in the cabinet are WD20EFRX-68EU=
ZN0. So I believe=20
they
 >=C2=A0=C2=A0=C2=A0=C2=A0 have SCT/TLER.
 >
 >=C2=A0=C2=A0=C2=A0=C2=A0 What RAID cabinets would be a better alternati=
ve? I have 5=20
drives but
 >=C2=A0=C2=A0=C2=A0=C2=A0 an 8-bay cabinet would work too.
 >
 >=C2=A0=C2=A0=C2=A0=C2=A0 Obviously, SMART pass-through would be 'nice'.=
 But so would SCT=20
(ERC).
 >
 >=C2=A0=C2=A0=C2=A0=C2=A0 --
 >
 >=C2=A0=C2=A0=C2=A0=C2=A0 Kind Regards,
 >
 >=C2=A0=C2=A0=C2=A0=C2=A0 Bill Hudacek
 >=C2=A0=C2=A0=C2=A0=C2=A0 IT Architect
 >=C2=A0=C2=A0=C2=A0=C2=A0 Currently Un-Attached, free & independent
 >
 >

