Return-Path: <SRS0=h+Ja=DI=vger.kernel.org=linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 635ECC4727E
	for <linux-raid@archiver.kernel.org>; Thu,  1 Oct 2020 18:41:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 19EDC20796
	for <linux-raid@archiver.kernel.org>; Thu,  1 Oct 2020 18:41:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730008AbgJASlx (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 1 Oct 2020 14:41:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729047AbgJASlx (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 1 Oct 2020 14:41:53 -0400
X-Greylist: delayed 1204 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 01 Oct 2020 11:41:53 PDT
Received: from hermes.turmel.org (hermes.turmel.org [IPv6:2604:180:f1::1e9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82350C0613D0
        for <linux-raid@vger.kernel.org>; Thu,  1 Oct 2020 11:41:53 -0700 (PDT)
Received: from c-98-192-104-236.hsd1.ga.comcast.net ([98.192.104.236] helo=[192.168.19.160])
        by hermes.turmel.org with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.90_1)
        (envelope-from <philip@turmel.org>)
        id 1kO3D8-0005CV-Kt; Thu, 01 Oct 2020 18:21:46 +0000
Subject: Re: RAID5->RAID6 reshape remains stuck at 0% (does nothing, not even
 start)
To:     David Madore <david+ml@madore.org>,
        Wols Lists <antlists@youngman.org.uk>
Cc:     Linux RAID mailing-list <linux-raid@vger.kernel.org>
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
 <20201001150410.acfchskzpr335cdp@achernar.gro-tsen.net>
From:   Phil Turmel <philip@turmel.org>
Message-ID: <8038cb98-13a4-c2b3-eee6-7a3a9b6173ec@turmel.org>
Date:   Thu, 1 Oct 2020 14:21:46 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201001150410.acfchskzpr335cdp@achernar.gro-tsen.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi David,

Let me add some history from my memory:

On 10/1/20 11:04 AM, David Madore wrote:
> On Thu, Oct 01, 2020 at 03:10:21PM +0100, Wols Lists wrote:
>> Except is this the problem? If the reshape fails to start, I don't quite
>> see how the restart service-file can be to blame?
> 
> I'm confident this is the problem.  I've changed the service file and
> the reshape now works fine for loopback devices on my system (I even
> tried it on a few small partitions to make sure).

Yes, but see below.

> As far as I understand it, here's what happens: when mdadm is given a
> reshape command on a system with systemd (and unless
> MDADM_NO_SYSTEMCTL is set), instead of handling the reshape itself, it
> calls (via the continue_via_systemd() function in Grow.c) "systemctl
> restart mdadm-grow-continue@${device}.service" (where ${device} is the
> md device base name).  This is defined via a systemd template file
> distributed by mdadm, namely
> /lib/systemd/system/mdadm-grow-continue@.service which itself calls
> (ExecStart) "/sbin/mdadm --grow --continue /dev/%I" (where %I is,
> again, the md device base name).  This does not pass a --backup-file
> parameter so, when the initial call needed one, this service
> immediately terminates with an error message, which is lost because
> standard input/output/error are redirected to /dev/null by the service
> file.  So the reshape never starts.

The original problem that service file attempts to solve is that mdmadm 
doesn't ever do the reshape itself.  In the absence of systemd, mdadm 
always forked a process to do the reshape in the background, passing 
everything necessary.  Systemd likes to kill off child processes when a 
main process ends, so *poof*, no reshape.

> I think the way to fix this would be to rewrite the systemd service
> file so that it first checks the existence of
> /run/mdadm/backup_file-%I and, if it exists, adds it as --backup-file
> parameter.  (I don't know how to do this.  For my own system I wrote a
> quick fix which assumes that --backup-file will always be present,
> which is just as wrong as assuming that it will always be absent.)

Meanwhile, at the time this was fixed, mdadm's defaults pretty much 
ensure that a backup file is never needed.  The temporary space provided 
by the backup file is now only needed when there isn't any leeway in the 
data offsets of the member devices.  Avoiding the backup file is also 
twice as fast.  So the systemd hack service was created without 
allowance for a backup file.

However, your solution to use the ram-backed /run directory is another 
disaster in the making, as that folder is destroyed on shutdown, totally 
breaking the whole point of the backup file.  It needs to go somewhere 
else, outside of the raid being reshaped and persistent through system 
crashes/shutdown.

> But I have no idea whose responsability it is to maintain this file,
> or indeed where it came from.  If you know where I should bug-report,
> or if you can pass the information to whoever is in charge, I'd be
> grateful.

Well, this list is the development list for MD and mdadm, so you're in 
the right place.  I think we've narrowed down what needs fixing.

>> Oh - and as for backup files - newer arrays by default don't need or use
>> them. So that again could be part of the problem ...

Well, the metadata versions with superblock at the end still need them, 
as they have to maintain data offset == 0.

> How do newer arrays get around the need for a backup file when doing a
> RAID5 -> RAID6 (with N -> N+1 disks) reshape?

Move the data offsets.  The background task maintains a boundary line 
within the array during reshape--as stripes are moved and reshaped, the 
boundary is moved.  One stripe at a time is frozen..

Phil
