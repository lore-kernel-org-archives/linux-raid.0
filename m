Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7EAFC4361A
	for <linux-raid@archiver.kernel.org>; Sat,  5 Dec 2020 07:27:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7ED2122D2B
	for <linux-raid@archiver.kernel.org>; Sat,  5 Dec 2020 07:27:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726841AbgLEH1o (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sat, 5 Dec 2020 02:27:44 -0500
Received: from SMTP.sabi.co.UK ([72.249.182.114]:50194 "EHLO sabi.co.UK"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726234AbgLEH1n (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Sat, 5 Dec 2020 02:27:43 -0500
X-Greylist: delayed 2205 seconds by postgrey-1.27 at vger.kernel.org; Sat, 05 Dec 2020 02:27:43 EST
Received: from [5.147.245.68] (helo=ty.sabi.co.UK)
        by sabi.co.UK with esmtps(Cipher TLS1.2:RSA_AES_256_CBC_SHA1:256)(PeerDN C=GB,ST=Oxfordshire,L=Didcot,O=sabi.co.UK,OU=systems,CN=ty.sabi.co.UK)(Exim 4.82 id 1klROZ-00055v-I1
        for <linux-raid@vger.kernel.org>; Sat, 05 Dec 2020 06:50:15 +0000
Received: from from [127.0.0.1] (helo=cyme.ty.sabi.co.uk)
        by ty.sabi.co.UK with esmtps(Cipher TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)(Exim 4.93 5)
        id 1klROT-0033xe-J2
        for <linux-raid@vger.kernel.org>; Sat, 05 Dec 2020 07:50:09 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <24523.11681.86857.449384@cyme.ty.sabi.co.uk>
Date:   Sat, 5 Dec 2020 07:50:09 +0100
X-Face: SMJE]JPYVBO-9UR%/8d'mG.F!@.,l@c[f'[%S8'BZIcbQc3/">GrXDwb#;fTRGNmHr^JFb
 SAptvwWc,0+z+~p~"Gdr4H$(|N(yF(wwCM2bW0~U?HPEE^fkPGx^u[*[yV.gyB!hDOli}EF[\cW*S
 H<GG"+i\3#fp@@EeWZWBv;]LA5n1pS2VO%Vv[yH?kY'lEWr30WfIU?%>&spRGFL}{`bj1TaD^l/"[
 msn( /TH#THs{Hpj>)]f><W}Ck9%2?H"AEM)+9<@D;3Kv=^?4$1/+#Qs:-aSsBTUS]iJ$6
To:     list Linux RAID <linux-raid@vger.kernel.org>
Subject: Re: Disk identifiers
In-Reply-To: <5B155FE8-2761-47FF-BDBA-F5AE3A9BC396@meddatainc.com>
References: <5B155FE8-2761-47FF-BDBA-F5AE3A9BC396@meddatainc.com>
X-Mailer: VM 8.2.0b under 26.3 (x86_64-pc-linux-gnu)
From:   pg@raid.list.sabi.co.UK (Peter Grandi)
X-Disclaimer: This message contains only personal opinions
X-Blacklisted-At: 
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

> Are disk identifiers important in Linux (CentOS)? [...]  Last,
> googling suggests there is confusion between disk identifiers
> and partition UUIDs. I am specifically asking about the
> former.

That "disk identifiers" is not specific. Which one do you mean
among disk serial numbers, disk WWNs, disk label identifiers?
Also apart from partition identifiers there are also partition
lavbels, MD set identifiers, MD member identifiers, and filetree
labels and identifiers.  Not all of these are present in every
case.

It may be interesting to have a look at the contents of the
'/dev/disk/by-*/' directories.

As to the importance of any of these it depends on which
specific configuration goals you have. Each of them has some
advantages and disadvantages.
