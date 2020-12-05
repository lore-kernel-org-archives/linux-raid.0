Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EAC41C433FE
	for <linux-raid@archiver.kernel.org>; Sat,  5 Dec 2020 19:09:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A27C422472
	for <linux-raid@archiver.kernel.org>; Sat,  5 Dec 2020 19:09:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725885AbgLETJ1 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sat, 5 Dec 2020 14:09:27 -0500
Received: from SMTP.sabi.co.UK ([72.249.182.114]:50846 "EHLO sabi.co.UK"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725536AbgLETJ0 (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Sat, 5 Dec 2020 14:09:26 -0500
Received: from [5.147.245.68] (helo=ty.sabi.co.UK)
        by sabi.co.UK with esmtps(Cipher TLS1.2:RSA_AES_256_CBC_SHA1:256)(PeerDN C=GB,ST=Oxfordshire,L=Didcot,O=sabi.co.UK,OU=systems,CN=ty.sabi.co.UK)(Exim 4.82 id 1klcvD-0005j9-Af
        for <linux-raid@vger.kernel.org>; Sat, 05 Dec 2020 19:08:43 +0000
Received: from from [127.0.0.1] (helo=cyme.ty.sabi.co.uk)
        by ty.sabi.co.UK with esmtps(Cipher TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)(Exim 4.93 5)
        id 1klcv0-003Ej3-Lw
        for <linux-raid@vger.kernel.org>; Sat, 05 Dec 2020 20:08:30 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <24523.55982.520696.570767@cyme.ty.sabi.co.uk>
Date:   Sat, 5 Dec 2020 20:08:30 +0100
X-Face: SMJE]JPYVBO-9UR%/8d'mG.F!@.,l@c[f'[%S8'BZIcbQc3/">GrXDwb#;fTRGNmHr^JFb
 SAptvwWc,0+z+~p~"Gdr4H$(|N(yF(wwCM2bW0~U?HPEE^fkPGx^u[*[yV.gyB!hDOli}EF[\cW*S
 H<GG"+i\3#fp@@EeWZWBv;]LA5n1pS2VO%Vv[yH?kY'lEWr30WfIU?%>&spRGFL}{`bj1TaD^l/"[
 msn( /TH#THs{Hpj>)]f><W}Ck9%2?H"AEM)+9<@D;3Kv=^?4$1/+#Qs:-aSsBTUS]iJ$6
To:     list Linux RAID <linux-raid@vger.kernel.org>
Subject: Re: Disk identifiers
In-Reply-To: <3302e569-5ac4-1738-1d9f-9f1db66bfcee@meddatainc.com>
References: <5B155FE8-2761-47FF-BDBA-F5AE3A9BC396@meddatainc.com>
        <24523.11681.86857.449384@cyme.ty.sabi.co.uk>
        <3302e569-5ac4-1738-1d9f-9f1db66bfcee@meddatainc.com>
X-Mailer: VM 8.2.0b under 26.3 (x86_64-pc-linux-gnu)
From:   pg@raid.list.sabi.co.UK (Peter Grandi)
X-Disclaimer: This message contains only personal opinions
X-Blacklisted-At: 
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

[...]

> I was referring to what fdisk -l calls "disk
> identifier". [...]

That's not a very fruitful approach :-). The real disk
identifiers are the serial number or WWN.

What 'fdisk' reports is the identifier of the "label" (called by
'fdisk' "Disklabel", which is a metadata block which usually
contains the partition table, and of which there are several
types).

For MBR/DOS type labels that is a pretty obscure field at offset
0x1B8 on the disk, and it is a 32b field. I personally use it
to store 4 characters, but it can be any 32-bit value.

That value matters a lot more to MS-Windows than to GNU/Linux,
which basically ignores it. I find that value used under
'/dev/disk/by-partuuid/' where it is used to prefix the number
of the partition for DOS/MBR labeled disks. BTW the entries
under '/dev/disk/' seem to me a "legacy" mess.

GPT/EFI labels instead have 128b fields which are usually filled
with UUID-structured random values, and those are not ignored
and usually appear under '/dev/disk/by-uuid'.

For MD raid sets I like to use GPT labels and refer to RAID set
members by partition name, where I give those partitions
meaningful proper-name prefixes. But that's another story.
