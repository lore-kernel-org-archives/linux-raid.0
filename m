Return-Path: <SRS0=h+Ja=DI=vger.kernel.org=linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.0 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24F26C4727C
	for <linux-raid@archiver.kernel.org>; Thu,  1 Oct 2020 15:04:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ACDD820780
	for <linux-raid@archiver.kernel.org>; Thu,  1 Oct 2020 15:04:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=madore.org header.i=@madore.org header.b="G1HfZQck"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732600AbgJAPEN (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 1 Oct 2020 11:04:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732426AbgJAPEM (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 1 Oct 2020 11:04:12 -0400
Received: from achernar.gro-tsen.net (achernar6.gro-tsen.net [IPv6:2001:bc8:30e8::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 7B7A4C0613D0
        for <linux-raid@vger.kernel.org>; Thu,  1 Oct 2020 08:04:12 -0700 (PDT)
Received: by achernar.gro-tsen.net (Postfix, from userid 500)
        id 8A67721403BF; Thu,  1 Oct 2020 17:04:10 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=madore.org;
        s=achernar; t=1601564650;
        bh=YnzzIJ5abU+tOSU/nWNjWonWnJM3svhEWJbDDaxV2NU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=G1HfZQckuA3VZ2/jDu+Dw163SSsbOYlyIMCvyusd7zWdvYd73UkhANjYsNCWryvWb
         DNlgiMoVyj5r8msG7E8tu1KJ14eY7xLSSAwYrvCTRueg5MPPCE0XSGTsqtAFTs7dJP
         3Q+qpVr9CN8jFAMpHwYBKLNyyN8r2ookNsIDiMrs=
Date:   Thu, 1 Oct 2020 17:04:10 +0200
From:   David Madore <david+ml@madore.org>
To:     Wols Lists <antlists@youngman.org.uk>
Cc:     Linux RAID mailing-list <linux-raid@vger.kernel.org>
Subject: Re: RAID5->RAID6 reshape remains stuck at 0% (does nothing, not even
 start)
Message-ID: <20201001150410.acfchskzpr335cdp@achernar.gro-tsen.net>
References: <20200930014032.pd4csjwu3m7uihin@achernar.gro-tsen.net>
 <5F740390.7050005@youngman.org.uk>
 <20200930090031.6lzrs336fr4inpz4@achernar.gro-tsen.net>
 <90338e5b-9ed4-c86e-fa35-8acdd6768ca7@youngman.org.uk>
 <20200930185824.q6dphu2axpfcjjly@achernar.gro-tsen.net>
 <5F74D684.8020005@youngman.org.uk>
 <20200930194510.vki7zixjca6sxvin@achernar.gro-tsen.net>
 <bfe9949c-1b46-baa3-1a89-0d994175dc95@youngman.org.uk>
 <20200930222637.mmlphc4patipalng@achernar.gro-tsen.net>
 <5F75E34D.7030207@youngman.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5F75E34D.7030207@youngman.org.uk>
User-Agent: NeoMutt/20170113 (1.7.2)
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Thu, Oct 01, 2020 at 03:10:21PM +0100, Wols Lists wrote:
> Except is this the problem? If the reshape fails to start, I don't quite
> see how the restart service-file can be to blame?

I'm confident this is the problem.  I've changed the service file and
the reshape now works fine for loopback devices on my system (I even
tried it on a few small partitions to make sure).

As far as I understand it, here's what happens: when mdadm is given a
reshape command on a system with systemd (and unless
MDADM_NO_SYSTEMCTL is set), instead of handling the reshape itself, it
calls (via the continue_via_systemd() function in Grow.c) "systemctl
restart mdadm-grow-continue@${device}.service" (where ${device} is the
md device base name).  This is defined via a systemd template file
distributed by mdadm, namely
/lib/systemd/system/mdadm-grow-continue@.service which itself calls
(ExecStart) "/sbin/mdadm --grow --continue /dev/%I" (where %I is,
again, the md device base name).  This does not pass a --backup-file
parameter so, when the initial call needed one, this service
immediately terminates with an error message, which is lost because
standard input/output/error are redirected to /dev/null by the service
file.  So the reshape never starts.

I think the way to fix this would be to rewrite the systemd service
file so that it first checks the existence of
/run/mdadm/backup_file-%I and, if it exists, adds it as --backup-file
parameter.  (I don't know how to do this.  For my own system I wrote a
quick fix which assumes that --backup-file will always be present,
which is just as wrong as assuming that it will always be absent.)

But I have no idea whose responsability it is to maintain this file,
or indeed where it came from.  If you know where I should bug-report,
or if you can pass the information to whoever is in charge, I'd be
grateful.

> Oh - and as for backup files - newer arrays by default don't need or use
> them. So that again could be part of the problem ...

How do newer arrays get around the need for a backup file when doing a
RAID5 -> RAID6 (with N -> N+1 disks) reshape?

Cheers,

-- 
     David A. Madore
   ( http://www.madore.org/~david/ )
