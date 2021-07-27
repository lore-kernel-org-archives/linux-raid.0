Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EFE30C4338F
	for <linux-raid@archiver.kernel.org>; Tue, 27 Jul 2021 22:43:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D803760F6D
	for <linux-raid@archiver.kernel.org>; Tue, 27 Jul 2021 22:43:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233023AbhG0WnC (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 27 Jul 2021 18:43:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232986AbhG0WnC (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 27 Jul 2021 18:43:02 -0400
Received: from sabi.co.uk (unknown [IPv6:2002:b911:ff1d::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B9EDC061757
        for <linux-raid@vger.kernel.org>; Tue, 27 Jul 2021 15:43:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=sabi.co.uk;
         s=dkim-00; h=From:References:In-Reply-To:Subject:To:Date:Message-ID:
        Content-Transfer-Encoding:Content-Type:MIME-Version:Sender:Reply-To:Cc:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=7OLfCm19TqvEoIDIfaZv1BDRd8H0cGdgusRLH7dkTlY=; b=u+7Ie0tO5OHkmmdpGEgxiTeePO
        pPrJMPyxYnHzO3lz2c8M+2DWeNilxne3LG2SdG89t/0KbpHfalO9hSVlH+ovXdD7I+EJAdVEK5Py2
        zmRC971BZnj90Kgge8Kde/Xi84U+SQ518sBKdt1T5wRLf4eRDFlZz+g+x+uCfFE8GfzWtaCUWgYV5
        oE7XfcjV6IUYJyG/sl2FeS5L9fAIUS+1kXxuhCh7Jnan2TgcFvIiRbF4tKhNgpUZLx8WdRTnQ+Uvn
        8nlyhEx0O7FkvGvFhAsVbciYB9giKg38CzLaSTo2irYwtjGnyC6hx1x4g+8cJACvtsDK0wvu/RZxj
        RB7wRQ6Q==;
Received: from b2b-37-24-228-251.unitymedia.biz ([37.24.228.251] helo=sabi.co.uk)
        by sabi.co.uk with esmtpsa(Cipher TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)(Exim 4.93 id 1m8Vms-004tJD-VB   id 1m8Vms-004tJD-VBby authid <sabity>with cram
        for <linux-raid@vger.kernel.org>; Tue, 27 Jul 2021 22:42:58 +0000
Received: from [127.0.0.1] (helo=cyme.ty.sabi.co.uk)
        by sabi.co.uk with esmtp(Exim 4.93 5)
        id 1m8Vmh-0040Aj-UW
        for <linux-raid@vger.kernel.org>; Wed, 28 Jul 2021 00:42:47 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <24832.35815.296927.900965@cyme.ty.sabi.co.uk>
Date:   Wed, 28 Jul 2021 00:42:47 +0200
X-Face: SMJE]JPYVBO-9UR%/8d'mG.F!@.,l@c[f'[%S8'BZIcbQc3/">GrXDwb#;fTRGNmHr^JFb
 SAptvwWc,0+z+~p~"Gdr4H$(|N(yF(wwCM2bW0~U?HPEE^fkPGx^u[*[yV.gyB!hDOli}EF[\cW*S
 H<GG"+i\3#fp@@EeWZWBv;]LA5n1pS2VO%Vv[yH?kY'lEWr30WfIU?%>&spRGFL}{`bj1TaD^l/"[
 msn( /TH#THs{Hpj>)]f><W}Ck9%2?H"AEM)+9<@D;3Kv=^?4$1/+#Qs:-aSsBTUS]iJ$6
To:     list Linux RAID <linux-raid@vger.kernel.org>
Subject: Re: Can't get RAID5/RAID6  NVMe randomread  IOPS - AMD ROME what am I missing?????
In-Reply-To: <5EAED86C53DED2479E3E145969315A2385841062@UMECHPA7B.easf.csd.disa.mil>
References: <5EAED86C53DED2479E3E145969315A2385841062@UMECHPA7B.easf.csd.disa.mil>
X-Mailer: VM 8.2.0b under 26.3 (x86_64-pc-linux-gnu)
From:   pg@mdraid.list.sabi.co.UK (Peter Grandi)
X-Disclaimer: This message contains only personal opinions
X-Blacklisted-At: 
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

[...]
> Device            r/s     w/s     rkB/s     wkB/s   rrqm/s   wrqm/s  %rrqm  %wrqm r_await w_await aqu-sz rareq-sz wareq-sz  svctm  %util
> nvme0n1       1317510.00    0.00 5270044.00      0.00     0.00     0.00   0.00   0.00    0.31    0.00 411.95     4.00     0.00   0.00 100.40
[...]
> Device            r/s     w/s     rkB/s     wkB/s   rrqm/s   wrqm/s  %rrqm  %wrqm r_await w_await aqu-sz rareq-sz wareq-sz  svctm  %util
> nvme0n1       114589.00    0.00 458356.00      0.00     0.00     0.00   0.00   0.00    0.29    0.00  33.54     4.00     0.00   0.01 100.00

The obvious difference is the factor of 10 in "aqu-sz" and that
correspond to the factor of 10 in "r/s" and "rkB/s".

I have noticed that the MD RAID is does some weird things to the
queueing, it is not a "normal" block device, and this often
creates bizarrities (happens also with DM/LVM2).

Try to create a filesystem on top of 'md0' and 'md1' and test
that, things may be quite different.
