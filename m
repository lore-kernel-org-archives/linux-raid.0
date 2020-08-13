Return-Path: <SRS0=qvga=BX=vger.kernel.org=linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A296C433DF
	for <linux-raid@archiver.kernel.org>; Thu, 13 Aug 2020 12:14:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9A43D20774
	for <linux-raid@archiver.kernel.org>; Thu, 13 Aug 2020 12:14:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=karlsbakk.net header.i=@karlsbakk.net header.b="Fl6ZdLd/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726627AbgHMMOf (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 13 Aug 2020 08:14:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726587AbgHMMOa (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 13 Aug 2020 08:14:30 -0400
Received: from zimbra.karlsbakk.net (zimbra.karlsbakk.net [IPv6:2a0a:51c0:0:1f:4ca5::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79DFEC061757
        for <linux-raid@vger.kernel.org>; Thu, 13 Aug 2020 05:14:30 -0700 (PDT)
Received: from localhost (localhost.localdomain [IPv6:::1])
        by zimbra.karlsbakk.net (Postfix) with ESMTP id E1C043C2767
        for <linux-raid@vger.kernel.org>; Thu, 13 Aug 2020 14:14:27 +0200 (CEST)
Received: from zimbra.karlsbakk.net ([IPv6:::1])
        by localhost (zimbra.karlsbakk.net [IPv6:::1]) (amavisd-new, port 10032)
        with ESMTP id VK4MOqX-a8fq for <linux-raid@vger.kernel.org>;
        Thu, 13 Aug 2020 14:14:26 +0200 (CEST)
Received: from localhost (localhost.localdomain [IPv6:::1])
        by zimbra.karlsbakk.net (Postfix) with ESMTP id 789033C27A0
        for <linux-raid@vger.kernel.org>; Thu, 13 Aug 2020 14:14:26 +0200 (CEST)
DKIM-Filter: OpenDKIM Filter v2.10.3 zimbra.karlsbakk.net 789033C27A0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=karlsbakk.net;
        s=1DC131FE-D37A-11E7-BD32-3AD4DFE620DF; t=1597320866;
        bh=QIPy7QxI/nONpOX/sGFsna3JlraMgkeVoTCuZ6NRtvg=;
        h=Date:From:To:Message-ID:MIME-Version;
        b=Fl6ZdLd/1OnOziR4c2px5m8F6EAoazYrHu6MkvLOBYayQniDLpYdjJPDHlKN4Hpmn
         tE5guombcjZIvpdrYS4E+CfiUwJx1pifCVcw3RY5IP5IAfjwDFRGCaFUKbkx6AEgJh
         aXOtw0YQ9bb5/OS9gh6y72blWvIBQ3TDJjc75eK2PnaE+hlZQQyB5Yxj7hncTd/Q5v
         2kC0HIs0cbjIOQLW3I9yxREZrCDrwVCJ2gV7JFGFj6OG8hF1TX88bWK+U7+Qa7o98S
         bYFato3rdj5uzy+hFRCOSn72kIXMtGz6yWap+G+z4tyygyJApOiEK2ZVpTV9BCv8qd
         9Vhvz78cd4l9g==
X-Virus-Scanned: amavisd-new at zimbra.karlsbakk.net
Received: from zimbra.karlsbakk.net ([IPv6:::1])
        by localhost (zimbra.karlsbakk.net [IPv6:::1]) (amavisd-new, port 10026)
        with ESMTP id QXJX4_nRnWb1 for <linux-raid@vger.kernel.org>;
        Thu, 13 Aug 2020 14:14:26 +0200 (CEST)
Received: from zimbra.karlsbakk.net (localhost.localdomain [127.0.0.1])
        by zimbra.karlsbakk.net (Postfix) with ESMTP id 5F5D13C2767
        for <linux-raid@vger.kernel.org>; Thu, 13 Aug 2020 14:14:26 +0200 (CEST)
Date:   Thu, 13 Aug 2020 14:14:26 +0200 (CEST)
From:   Roy Sigurd Karlsbakk <roy@karlsbakk.net>
To:     Linux RAID Mailing List <linux-raid@vger.kernel.org>
Message-ID: <511683715.22423223.1597320866233.JavaMail.zimbra@karlsbakk.net>
Subject: Confusing output of --examine-badblocks1 message
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Originating-IP: [::ffff:51.175.216.121]
X-Mailer: Zimbra 8.8.10_GA_3801 (ZimbraWebClient - FF79 (Mac)/8.8.10_GA_3786)
Thread-Index: 6fFysasCZBtSZ6hKL7EEKs2k82fW0w==
Thread-Topic: Confusing output of --examine-badblocks1 message
Sender: linux-raid-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi all

Iterating over my drives, I ran mdadm --examine-badblocks to look for clues=
 for an issue where XFS reports

Aug 12 23:29:30 hostname kernel: [548754.725102] XFS (dm-6): metadata I/O e=
rror in "xfs_buf_iodone_callback_error" at daddr 0x3a85f3430 len 16 error 5

apparently repeating the same sector number over and over again. The XFS FS=
 is on top of LVM, placed on a RAID-6, currently consisting of nine 2TB dri=
ves with two spares. The drives are of various makes and models. Running wt=
h --examine-badblocks, it spits out a blocklist for some of the drives. I f=
ind it a bit unclear why, since none of them have anything bad reported in =
smart data. Well, ok, something it might be (silent errors etc). There are =
also no I/O errors in the kernel log when this happens.

However, back to --examine-badblocks. It seems it's reporting the same sect=
or numbers in the list for several (up to eight) drives. If I understand th=
is correctly, something strange has hit and damanged all drives on fixed se=
ctor numbers, such as this

Bad-blocks on /dev/sdm:
           436362944 for 128 sectors

It doesn't seem very likely, to be honest, that a lot of drives suddenly da=
mage the same sector at once. I can see the same occur on a friend's server=
 - sectors with identical 'bad' sector numbers been listed on individual dr=
ives.

So I just wonder:
1. How can this happen? Does it replicate the list if a drive has recorded =
badblocks on it?
2. Is it possible to somehow reset the list and rather do a full scan again=
? Something smells fishy here

There's some talk about it here, https://raid.wiki.kernel.org/index.php/The=
_Badblocks_controversy, and I also wonder if this is still enabled by defau=
lt. It doesn't make much sense=E2=80=A6

Vennlig hilsen

roy
--
Roy Sigurd Karlsbakk
(+47) 98013356
http://blogg.karlsbakk.net/
GPG Public key: http://karlsbakk.net/roysigurdkarlsbakk.pubkey.txt
--
Hi=C3=B0 g=C3=B3=C3=B0a skaltu =C3=AD stein h=C3=B6ggva, hi=C3=B0 illa =C3=
=AD snj=C3=B3 rita.
