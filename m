Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39084C4332F
	for <linux-raid@archiver.kernel.org>; Sat, 23 Oct 2021 19:35:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0D66C60EBD
	for <linux-raid@archiver.kernel.org>; Sat, 23 Oct 2021 19:35:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230512AbhJWThp (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sat, 23 Oct 2021 15:37:45 -0400
Received: from SMTP.sabi.co.UK ([185.17.255.29]:47192 "EHLO sabi.co.uk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230379AbhJWTho (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Sat, 23 Oct 2021 15:37:44 -0400
X-Greylist: delayed 1011 seconds by postgrey-1.27 at vger.kernel.org; Sat, 23 Oct 2021 15:37:43 EDT
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=root.for.sabi.co.uk; s=dkim-00; h=From:References:In-Reply-To:Subject:To:
        Content-Transfer-Encoding:Content-Type:MIME-Version:Date:Message-ID:Sender:
        Reply-To:Cc:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=DVf9c7aC0DrM+2dCjnjVxZPiW7dweqP3rwQlraoF0JE=; b=kN3N+m8/5ojiov4lO6GPRbyHbR
        FEDn2Xi3Jwc7r0xlIKa0xgJEJPZFrNUbqJOEcIFThHycH0r7NGfHfE+2wBHw8rufwwSd4xj0UPZ7A
        S2OB7cO7e4RHW8h3q7HBExZrYJuHx1zzXd4y29veJZCaB8xvPJmO1IBALHVM0Wo9OEQUmZlWgZ0Iv
        ErDUG5Luo2SzrgQaiUOM4BitjTfvm+Gp192lpNdL6I/aTQE+dLzLNK3NvDD0Qo4oxRZ65Vl3TiWmw
        cx8HaQDCVCGEjfOWZW4iWDBUPV/RwYTnanCKJMKm8hsaP/Cy1a8sYeYqt2Svd4dwbahUq380gZdtv
        UxDC3rSQ==;
Received: from p4fcfee0a.dip0.t-ipconnect.de ([79.207.238.10] helo=sabi.co.uk)
        by sabi.co.uk with esmtpsa(Cipher TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)(Exim 4.93 id 1meMXI-00C2dd-Ag   id 1meMXI-00C2dd-Agby authid <sabity>with cram
        for <linux-raid@vger.kernel.org>; Sat, 23 Oct 2021 19:18:32 +0000
Received: from [127.0.0.1] (helo=cyme.ty.sabi.co.uk)
        by sabi.co.uk with esmtp(Exim 4.93 5)
        id 1meMXC-001VBL-G4
        for <linux-raid@vger.kernel.org>; Sat, 23 Oct 2021 21:18:26 +0200
Message-ID: <24948.24578.330988.759209@cyme.ty.sabi.co.uk>
Date:   Sat, 23 Oct 2021 21:18:26 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Face: SMJE]JPYVBO-9UR%/8d'mG.F!@.,l@c[f'[%S8'BZIcbQc3/">GrXDwb#;fTRGNmHr^JFb
 SAptvwWc,0+z+~p~"Gdr4H$(|N(yF(wwCM2bW0~U?HPEE^fkPGx^u[*[yV.gyB!hDOli}EF[\cW*S
 H<GG"+i\3#fp@@EeWZWBv;]LA5n1pS2VO%Vv[yH?kY'lEWr30WfIU?%>&spRGFL}{`bj1TaD^l/"[
 msn( /TH#THs{Hpj>)]f><W}Ck9%2?H"AEM)+9<@D;3Kv=^?4$1/+#Qs:-aSsBTUS]iJ$6
To:     list Linux RAID <linux-raid@vger.kernel.org>
Subject: Re: Inconsistent device numbers after reboot
In-Reply-To: <d2daf328-69ab-c540-aaf3-97e4a6ea4355@cas.homelinux.org>
References: <d2daf328-69ab-c540-aaf3-97e4a6ea4355@cas.homelinux.org>
X-Mailer: VM 8.2.0b under 26.3 (x86_64-pc-linux-gnu)
From:   pg@mdraid.list.sabi.co.UK (Peter Grandi)
X-Disclaimer: This message contains only personal opinions
X-Blacklisted-At: 
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

> The device ID of my partition containing my home directory
> changes (sometimes) when I reboot

This is an intrinsic behaviour of the Linux kernel, and it is
futile to fight it (it also depends on enumeration order). Note
that is the id of the special device file which has no intrinsic
significance, unlike that disk id in the label, or the partition
id (for GPT), or the filesystem id (for most filesystems), so
using it to uniquely identify archived files is "dubious".

> Changing device ID's causes havoc with tar incremental backups
> - tar consider all files are new.

For that reason there is a specific option in recent versions of
GNU 'tar':

       "--no-check-device
              Do not check device numbers when creating incremental archives."
