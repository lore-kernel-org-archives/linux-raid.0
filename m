Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1F31C4743C
	for <linux-raid@archiver.kernel.org>; Mon, 21 Jun 2021 21:11:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7C0BA6124B
	for <linux-raid@archiver.kernel.org>; Mon, 21 Jun 2021 21:11:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231226AbhFUVN1 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 21 Jun 2021 17:13:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230102AbhFUVN0 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 21 Jun 2021 17:13:26 -0400
Received: from mail-qt1-x829.google.com (mail-qt1-x829.google.com [IPv6:2607:f8b0:4864:20::829])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B134C061574
        for <linux-raid@vger.kernel.org>; Mon, 21 Jun 2021 14:11:11 -0700 (PDT)
Received: by mail-qt1-x829.google.com with SMTP id j12so80027qtv.11
        for <linux-raid@vger.kernel.org>; Mon, 21 Jun 2021 14:11:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:from:subject:message-id:date:user-agent:mime-version
         :content-transfer-encoding;
        bh=WGykWfce6Zf1SmTYBALMbIjxA0BGdTgsMulCan5GJbo=;
        b=gPho26NN+fYtf92tbgtVmJF06HDwvpMQidetorhTtmymUYFpeLnBO1uK0ugmxfsuMk
         ZJFSYus752HBlmT+Ero5oe3ydBGhYzxzda/ULC3kqWpH53GKofXDnmI1m+4wZNxpAzgs
         jSpk2T7JmrOEYE0ysxizRZhwdgUv1x3/a59RTNIIPq3lNn0RTQW+HqPHGs6oGZ9CWPHh
         BpjIw28oP3BScpK6LYlyKbT0vJZmBgR8O6Qh87+FhJVIukWI74oclPil9Hh0jIz655Ok
         nZmmZYaauABaIk190pHI4/Hn7wPQ9Q7VeltAjzWJkwqSubwg56Rb9JtwGiCWCrx3P+wH
         6c0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:from:subject:message-id:date:user-agent
         :mime-version:content-transfer-encoding;
        bh=WGykWfce6Zf1SmTYBALMbIjxA0BGdTgsMulCan5GJbo=;
        b=WtzVJZ0q4hMJeeii9jkQrBbmz8/GfcUo3BFTJGyOk1RiC2zCqw7/M8+ekz0piBxroW
         O4SQCCIj1qJRK/jx0XCGMe0oI9GR870t/2vZicAsu2hFias9Ghft667zPrc0TdLhFB8s
         viMdwDLnVZPQFAH0RLjMG0Dym/hcitW3qDV3Gb4dqrdNqYCEwFQobYI1rsSmELrvfYi5
         dHY5VCrOth9QeHePTISfg6fwSX/Kkq0G8YB9JkdoREQYTPmMIbFJWneUh5vbDP+S35W2
         8nnMfQd2TaB57o0FYJ4ZnTuUeP7XFIb6PtKqkSgEaXYXNZUlRXDBCk0JlCa18asV/hKr
         mUVQ==
X-Gm-Message-State: AOAM531SRoxOXa7GqXsUbXnt6G4MSUSNV009MfvBwuGjXnOQNRhy7Wra
        DsrmXz79OlPseBABJHwBVDFMNfeRRGY=
X-Google-Smtp-Source: ABdhPJxw8TduZ/TS7JdlEJcKT5jOw55z8qdCO7US2se2X/ZvaLvOGeszq2Wyml8OaeDMWMLk0TZ8Yg==
X-Received: by 2002:ac8:544:: with SMTP id c4mr479112qth.299.1624309870304;
        Mon, 21 Jun 2021 14:11:10 -0700 (PDT)
Received: from hera.hudaceks.home (158-247-72-95.car1-wispds4-pool60.amplex.net. [158.247.72.95])
        by smtp.gmail.com with ESMTPSA id z3sm9811803qki.73.2021.06.21.14.11.09
        for <linux-raid@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 21 Jun 2021 14:11:09 -0700 (PDT)
To:     mdraid <linux-raid@vger.kernel.org>
From:   Bill Hudacek <bill.hudacek@gmail.com>
Subject: Question: RAID cabinet for home use
Message-ID: <03ca5974-60ed-d596-7eff-cac44f4a6d62@gmail.com>
Date:   Mon, 21 Jun 2021 17:11:08 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

My 2021 Sans Digital TR5UT+B held 5 SATA disks. I had an eSATA=20
connection to the host box. It went belly-up a few weeks ago.

After some careful searching, a good replacement seemed to be the Oyen=20
Digital Mobius 3R5-EB3-M. Found it for about $300USD.

It was plug-and-play replace. Drives were being addressed by UUID in=20
Fedora so no issues at all. It came right up.

However, smart reporting looks horrible even compared to the TR5UT+B=20
(which had its own issues).

Here's what the TR5UT+B (old cabinet) reported for one disk in the=20
unit (just the header section of smartctl -a):

=3D=3D=3D START OF INFORMATION SECTION =3D=3D=3D
Model Family:=C2=A0=C2=A0=C2=A0=C2=A0 Western Digital Red
Device Model:=C2=A0=C2=A0=C2=A0=C2=A0 WDC WD20EFRX-68EUZN0
Serial Number:=C2=A0=C2=A0=C2=A0 WD-WCC4M6HX8XCR
Firmware Version: 0957
User Capacity:=C2=A0=C2=A0=C2=A0 2,000,398,934,016 bytes [2.00 TB]
Sector Size:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 512 bytes logical/physical
Device is:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 In smartctl database=
 [for details use: -P show]

Here's what the Mobius reports now for the same disk:

=3D=3D=3D START OF INFORMATION SECTION =3D=3D=3D
Device Model:=C2=A0=C2=A0=C2=A0=C2=A0 Mobius=C2=A0 DISK1
Serial Number:=C2=A0=C2=A0=C2=A0 WD-WCC4M6HX8XCR
Firmware Version: 0962
User Capacity:=C2=A0=C2=A0=C2=A0 2,000,398,934,016 bytes [2.00 TB]
Sector Size:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 512 bytes logical/physical
Device is:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Not in smartctl data=
base [for details use: -P showall]

The disk model is gone. The firmware version is wrong (cabinet instead=20
of disk?!). I imagine firmware updates are impossible here.

The rest of it is unimpressive, too. No SCT (TLER) at all - not just=20
ERC, but SCT Status, SCT Feature Control, SCT Data Table are all=20
missing too.

All the disks in the cabinet are WD20EFRX-68EUZN0. So I believe they=20
have SCT/TLER.

What RAID cabinets would be a better alternative? I have 5 drives but=20
an 8-bay cabinet would work too.

Obviously, SMART pass-through would be 'nice'. But so would SCT (ERC).

--=20

Kind Regards,

Bill Hudacek
IT Architect
Currently Un-Attached, free & independent


