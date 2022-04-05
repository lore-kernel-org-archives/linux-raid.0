Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04628C433EF
	for <linux-raid@archiver.kernel.org>; Tue,  5 Apr 2022 02:55:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230495AbiDEC5c (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 4 Apr 2022 22:57:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230265AbiDEC5Y (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 4 Apr 2022 22:57:24 -0400
X-Greylist: delayed 3706 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 04 Apr 2022 19:19:03 PDT
Received: from zimbra.karlsbakk.net (zimbra.karlsbakk.net [IPv6:2a0a:51c0:0:1f:4ca5::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72E104EF41
        for <linux-raid@vger.kernel.org>; Mon,  4 Apr 2022 19:19:03 -0700 (PDT)
Received: from localhost (localhost.localdomain [IPv6:::1])
        by zimbra.karlsbakk.net (Postfix) with ESMTP id 0D6DC3C033C;
        Tue,  5 Apr 2022 02:29:08 +0200 (CEST)
Received: from zimbra.karlsbakk.net ([IPv6:::1])
        by localhost (zimbra.karlsbakk.net [IPv6:::1]) (amavisd-new, port 10032)
        with ESMTP id HQxLUP1aHlB6; Tue,  5 Apr 2022 02:29:06 +0200 (CEST)
Received: from localhost (localhost.localdomain [IPv6:::1])
        by zimbra.karlsbakk.net (Postfix) with ESMTP id 0EB4D3C1211;
        Tue,  5 Apr 2022 02:29:06 +0200 (CEST)
DKIM-Filter: OpenDKIM Filter v2.10.3 zimbra.karlsbakk.net 0EB4D3C1211
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=karlsbakk.net;
        s=1DC131FE-D37A-11E7-BD32-3AD4DFE620DF; t=1649118546;
        bh=oXUKOgHcYQeoJcXDVpZjm7u7IbMR0M2ezVZdXj9LBGo=;
        h=Date:From:To:Message-ID:MIME-Version;
        b=WUv5f/2UMpaaS3IMeOW26xfCKGfGKa+og/w1pDMl2fwDfpyXULJnaXb64x0qp5c3J
         a11PSNp3CiWrhnIkJ844gonhYiOQrhABmvxtxMftmjZ28cbjZCEmISSniFou6YVuHM
         BIPIfwg9V1vltjfWS44RZnWZ94s+JEmAnBrUezDWQDCZa+RXmJzvMs8EFuGSEjm1V9
         KA+iydFmB6srfSpm/U7VQqXLw8S/8ZdWxRnB4sOTS2VTh4GMjf8g0aGfGyJENSq5G8
         P1Iu1wV2Sq8IdIBsyUcRCvc8Wac/Z6KTatltFiKxdcCcOrrOVq4bKVSan8hmAWmc5P
         6eiRKQluXaI0w==
X-Virus-Scanned: amavisd-new at zimbra.karlsbakk.net
Received: from zimbra.karlsbakk.net ([IPv6:::1])
        by localhost (zimbra.karlsbakk.net [IPv6:::1]) (amavisd-new, port 10026)
        with ESMTP id CbcBbWlX2AwF; Tue,  5 Apr 2022 02:29:05 +0200 (CEST)
Received: from zimbra.karlsbakk.net (localhost.localdomain [127.0.0.1])
        by zimbra.karlsbakk.net (Postfix) with ESMTP id 769FE3C033C;
        Tue,  5 Apr 2022 02:29:05 +0200 (CEST)
Date:   Tue, 5 Apr 2022 02:29:03 +0200 (CEST)
From:   Roy Sigurd Karlsbakk <roy@karlsbakk.net>
To:     Jorge Nunes <jorgebnunes@gmail.com>
Cc:     Linux Raid <linux-raid@vger.kernel.org>
Message-ID: <987997234.3307867.1649118543055.JavaMail.zimbra@karlsbakk.net>
In-Reply-To: <CANDfL1au6kdEkR3bmLAHTdGV-Rb==8Jy1ZnwNFjvjNq7drC1XA@mail.gmail.com>
References: <CANDfL1au6kdEkR3bmLAHTdGV-Rb==8Jy1ZnwNFjvjNq7drC1XA@mail.gmail.com>
Subject: Re: RAID 1 to RAID 5 failure
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Originating-IP: [2001:700:700:403::8:10d2]
X-Mailer: Zimbra 8.8.10_GA_3801 (ZimbraWebClient - FF98 (Mac)/8.8.10_GA_3786)
Thread-Topic: RAID 1 to RAID 5 failure
Thread-Index: zbJcSRc3ib4HoPi+/Se2lY7m8Hjiig==
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

> Didn't do a backup :-(

First mistake=E2=80=A6 *Always* keep a backup (or three)

>=20
> Unmount everything:

No need - what you should have done, was just to grow the array by

Partition the new drives exactly like the old ones
mdadm --add /dev/md0 /dev/sd[cd]1 # note that sd[cd] means sdc and sdd, but=
 can be written this way on the commandline
mdadm --grow --level=3D5 --raid-devices=3D4

This would have grown and converted the array to raid5 without any data los=
s.

> $ sudo mdadm --create /dev/md0 -a yes -l 5 -n 2 /dev/sda /dev/sdd

As earlier mentioned, this is to create a new array, not a conversion.

> So, my question is: Is there a chance to redo the array correctly
> without losing the information inside? Is it possible to recover the
> 'lost' partition that existed on RAID 1 to be able to do a convenient
> backup? Or the only chance is to have a correct disk alignment inside
> the array to be able to use photorec to recover the files correctly?

As mentioned, it doesn't look promising, but there are a few things that ca=
n be tried.

Your data may still reside on the sda1 and sdd1, but since it was converted=
 to RAID-5, the data would have been distributed among the two drives and n=
ot being the same on both. Further growing the raid, would move the data ar=
ound to the other disks. I did a small test here on some vdisks to see if t=
his could be reversed somehow and see if I could find the original filesyst=
em. I could - but it was terribly corrupted, so not a single file remained.

If this was valuable data, there might be a way to rescue them, but I fear =
a lot is overwritten already. Others in here (or other places) may know mor=
e about how to fix this, though. If you find out how, please tell. It'd be =
interesting to learn :)

PS: I have my personal notebook for technical stuff at https://wiki.karlsba=
kk.net/index.php/Roy's_notes in case you might find that interesting. There=
's quite a bit about storage there. Simply growing a raid is apparently for=
gotten, since I thought that was too simple. I'll add it.

So hope you didn't lose too much valuable data

Vennlig hilsen / Best regards

roy
--
Roy Sigurd Karlsbakk
(+47) 98013356
--
I all pedagogikk er det essensielt at pensum presenteres intelligibelt. Det=
 er et element=C3=A6rt imperativ for alle pedagoger =C3=A5 unng=C3=A5 ekses=
siv anvendelse av idiomer med xenotyp etymologi. I de fleste tilfeller eksi=
sterer adekvate og relevante synonymer p=C3=A5 norsk.
