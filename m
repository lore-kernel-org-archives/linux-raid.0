Return-Path: <SRS0=vpcD=DH=vger.kernel.org=linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01AF0C4727C
	for <linux-raid@archiver.kernel.org>; Wed, 30 Sep 2020 18:58:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 45597206DC
	for <linux-raid@archiver.kernel.org>; Wed, 30 Sep 2020 18:58:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=madore.org header.i=@madore.org header.b="HFw13qaY"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730964AbgI3S6e (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 30 Sep 2020 14:58:34 -0400
Received: from achernar.gro-tsen.net ([163.172.93.86]:42410 "EHLO
        achernar.gro-tsen.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730949AbgI3S60 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 30 Sep 2020 14:58:26 -0400
Received: by achernar.gro-tsen.net (Postfix, from userid 500)
        id 7E84F21402D9; Wed, 30 Sep 2020 20:58:24 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=madore.org;
        s=achernar; t=1601492304;
        bh=R5MFgmavzfSr5sJb9q9mCl5LbOhnRNm+QfmRyoLO/Rw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=HFw13qaYMJizqq+tviX8nOc9qO3l3O5nY9KaNmZME59SEK6ag/Ms9hqZ9LO2eiTRR
         W04+clzwx4LSB9wypXMDFE24hIynaVYKvSCM3TCIKONmH4jy/XpysTdRu6sHNhimFI
         v8aHf9fuXgFdV/jcjfwy63bWzb/VFTPK87LlQifE=
Date:   Wed, 30 Sep 2020 20:58:24 +0200
From:   David Madore <david+ml@madore.org>
To:     antlists <antlists@youngman.org.uk>
Cc:     Linux RAID mailing-list <linux-raid@vger.kernel.org>
Subject: Re: RAID5->RAID6 reshape remains stuck at 0% (does nothing, not even
 start)
Message-ID: <20200930185824.q6dphu2axpfcjjly@achernar.gro-tsen.net>
References: <20200930014032.pd4csjwu3m7uihin@achernar.gro-tsen.net>
 <5F740390.7050005@youngman.org.uk>
 <20200930090031.6lzrs336fr4inpz4@achernar.gro-tsen.net>
 <90338e5b-9ed4-c86e-fa35-8acdd6768ca7@youngman.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <90338e5b-9ed4-c86e-fa35-8acdd6768ca7@youngman.org.uk>
User-Agent: NeoMutt/20170113 (1.7.2)
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Wed, Sep 30, 2020 at 03:09:05PM +0100, antlists wrote:
> So my guess was spot on :-)
> 
> You'll guess that this is a common problem, with a well-known solution...
> 
> https://raid.wiki.kernel.org/index.php/Easy_Fixes#Debian_9_and_Ubuntu

OK, I've just retried with a new version of mdadm,

mdadm - v4.1 - 2018-10-01

- which I think is roughly contemporaneous to the kernel version I'm
using.  But the problem still persists (with the exact same symptoms
and details).

I have one additional piece of information which might be relevant:
when the mdadm --grow command is run, the kernel thread "md112_raid5"
(where md112 is, of course, the md device number in my case) is
replaced by two new ones, "md112_raid6" and "md112_reshape".  Both
remain in 'S' state.  Looking into /proc/$pid/wchan, the former is in
md_thread while the latter is in md_do_sync.

Cheers,

-- 
     David A. Madore
   ( http://www.madore.org/~david/ )
