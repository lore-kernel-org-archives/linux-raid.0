Return-Path: <SRS0=qvga=BX=vger.kernel.org=linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37394C433E1
	for <linux-raid@archiver.kernel.org>; Thu, 13 Aug 2020 12:15:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 103C82078D
	for <linux-raid@archiver.kernel.org>; Thu, 13 Aug 2020 12:15:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=karlsbakk.net header.i=@karlsbakk.net header.b="IDHteBcm"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726664AbgHMMPa (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 13 Aug 2020 08:15:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726467AbgHMMP2 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 13 Aug 2020 08:15:28 -0400
Received: from zimbra.karlsbakk.net (zimbra.karlsbakk.net [IPv6:2a0a:51c0:0:1f:4ca5::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 253FAC061757
        for <linux-raid@vger.kernel.org>; Thu, 13 Aug 2020 05:15:28 -0700 (PDT)
Received: from localhost (localhost.localdomain [IPv6:::1])
        by zimbra.karlsbakk.net (Postfix) with ESMTP id 7EE683C2767
        for <linux-raid@vger.kernel.org>; Thu, 13 Aug 2020 14:15:26 +0200 (CEST)
Received: from zimbra.karlsbakk.net ([IPv6:::1])
        by localhost (zimbra.karlsbakk.net [IPv6:::1]) (amavisd-new, port 10032)
        with ESMTP id dwsXRgKY03O9 for <linux-raid@vger.kernel.org>;
        Thu, 13 Aug 2020 14:15:25 +0200 (CEST)
Received: from localhost (localhost.localdomain [IPv6:::1])
        by zimbra.karlsbakk.net (Postfix) with ESMTP id 471303C27A0
        for <linux-raid@vger.kernel.org>; Thu, 13 Aug 2020 14:15:25 +0200 (CEST)
DKIM-Filter: OpenDKIM Filter v2.10.3 zimbra.karlsbakk.net 471303C27A0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=karlsbakk.net;
        s=1DC131FE-D37A-11E7-BD32-3AD4DFE620DF; t=1597320925;
        bh=skI3ktjnastISFTDcBVnlssMHkxrgKMqo6gPScgz8S0=;
        h=Date:From:To:Message-ID:MIME-Version;
        b=IDHteBcmEeVwKOmBjyxVMf5Dz/dprfO+5ewI8H1Aer+09v0MfYQBU4GojwikjT0Bf
         PZJHWiGsXXGpxy1uAt4uJdOF3lGM+2R/qiujlLvGIZqy5Yn1FPAQleKLRArWHtThhU
         WVhQjFc+AZ7cGxYW0Lt6PUexipz2mKoxdl7LdSqDkbOwPbrYbB9s4dLoLlJqgJdLQT
         3Nl6lXF/5ughkrsdFmyOrcqmkCxTocfp4I1689SJXPYnWOSnQ9CMIaWxXRcmSLl84j
         V8URd7ONM3WM3L0t5zBVcJlZH+0qyFDN5o/dP6ioLoL05R02c40TsJs27wuWpIw80Z
         4Ih8YwaslnY1Q==
X-Virus-Scanned: amavisd-new at zimbra.karlsbakk.net
Received: from zimbra.karlsbakk.net ([IPv6:::1])
        by localhost (zimbra.karlsbakk.net [IPv6:::1]) (amavisd-new, port 10026)
        with ESMTP id GS60emeuoXCk for <linux-raid@vger.kernel.org>;
        Thu, 13 Aug 2020 14:15:25 +0200 (CEST)
Received: from zimbra.karlsbakk.net (localhost.localdomain [127.0.0.1])
        by zimbra.karlsbakk.net (Postfix) with ESMTP id 328DA3C2767
        for <linux-raid@vger.kernel.org>; Thu, 13 Aug 2020 14:15:25 +0200 (CEST)
Date:   Thu, 13 Aug 2020 14:15:25 +0200 (CEST)
From:   Roy Sigurd Karlsbakk <roy@karlsbakk.net>
To:     Linux RAID Mailing List <linux-raid@vger.kernel.org>
Message-ID: <1637821313.22423838.1597320925127.JavaMail.zimbra@karlsbakk.net>
Subject: mdadm development?
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Originating-IP: [::ffff:51.175.216.121]
X-Mailer: Zimbra 8.8.10_GA_3801 (ZimbraWebClient - FF79 (Mac)/8.8.10_GA_3786)
Thread-Index: AYY4f/R7Pcf1/Po2fpSjSseXBjWRxA==
Thread-Topic: mdadm development?
Sender: linux-raid-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi all

Looking around to debug an issue (see previous email about badblocks), I wa=
nted to find the latest version of mdadm. It seems it's 4.1 from october 20=
18. I can't find anything newer. Has development of mdadm halted or is it d=
eclared "perfect" or something?

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
