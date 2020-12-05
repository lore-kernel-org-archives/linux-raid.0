Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E81BC4361B
	for <linux-raid@archiver.kernel.org>; Sat,  5 Dec 2020 22:06:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 066D52310E
	for <linux-raid@archiver.kernel.org>; Sat,  5 Dec 2020 22:06:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725933AbgLEWF5 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sat, 5 Dec 2020 17:05:57 -0500
Received: from SMTP.sabi.co.UK ([72.249.182.114]:51006 "EHLO sabi.co.UK"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725270AbgLEWF5 (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Sat, 5 Dec 2020 17:05:57 -0500
Received: from [5.147.245.68] (helo=ty.sabi.co.UK)
        by sabi.co.UK with esmtps(Cipher TLS1.2:RSA_AES_256_CBC_SHA1:256)(PeerDN C=GB,ST=Oxfordshire,L=Didcot,O=sabi.co.UK,OU=systems,CN=ty.sabi.co.UK)(Exim 4.82 id 1klfg1-0005uw-V4
        for <linux-raid@vger.kernel.org>; Sat, 05 Dec 2020 22:05:14 +0000
Received: from from [127.0.0.1] (helo=cyme.ty.sabi.co.uk)
        by ty.sabi.co.UK with esmtps(Cipher TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)(Exim 4.93 5)
        id 1klfg0-003IX2-ED
        for <linux-raid@vger.kernel.org>; Sat, 05 Dec 2020 23:05:12 +0100
Message-ID: <24524.1048.154814.812624@cyme.ty.sabi.co.uk>
Date:   Sat, 5 Dec 2020 23:05:12 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Face: SMJE]JPYVBO-9UR%/8d'mG.F!@.,l@c[f'[%S8'BZIcbQc3/">GrXDwb#;fTRGNmHr^JFb
 SAptvwWc,0+z+~p~"Gdr4H$(|N(yF(wwCM2bW0~U?HPEE^fkPGx^u[*[yV.gyB!hDOli}EF[\cW*S
 H<GG"+i\3#fp@@EeWZWBv;]LA5n1pS2VO%Vv[yH?kY'lEWr30WfIU?%>&spRGFL}{`bj1TaD^l/"[
 msn( /TH#THs{Hpj>)]f><W}Ck9%2?H"AEM)+9<@D;3Kv=^?4$1/+#Qs:-aSsBTUS]iJ$6
To:     list Linux RAID <linux-raid@vger.kernel.org>
Subject: Re: Disk identifiers
In-Reply-To: <362dc592-d2e4-d8a1-b167-a1e28a22c735@meddatainc.com>
References: <5B155FE8-2761-47FF-BDBA-F5AE3A9BC396@meddatainc.com>
        <24523.11681.86857.449384@cyme.ty.sabi.co.uk>
        <3302e569-5ac4-1738-1d9f-9f1db66bfcee@meddatainc.com>
        <24523.55982.520696.570767@cyme.ty.sabi.co.uk>
        <362dc592-d2e4-d8a1-b167-a1e28a22c735@meddatainc.com>
X-Mailer: VM 8.2.0b under 26.3 (x86_64-pc-linux-gnu)
From:   pg@raid.list.sabi.co.UK (Peter Grandi)
X-Disclaimer: This message contains only personal opinions
X-Blacklisted-At: 
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

>> [...] For MBR/DOS type labels that is a pretty obscure field
>> at offset 0x1B8 on the disk, and it is a 32b field. [...]
>> GPT/EFI labels instead have 128b fields which are usually
>> filled with UUID-structured random values [...]

> This is the output from fdisk -l where it is called "Disk
> identifier":
[...]
> Disk label type: gpt
> Disk identifier: 00000000-0000-0000-0000-000000000000
[...]
> Disk label type: gpt
> Disk identifier: EF1A3010-0A15-5A4B-A6FC-1B0EA869D0A7

Reading carefully the output might help, as well as discovering
that recent versions of 'fdisk' and 'gdisk' handle both DOS and
GPT labels (in different degrees). Using the 'm' command of
'fdisk' show it can handle also other types of labels.
