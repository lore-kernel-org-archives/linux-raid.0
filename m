Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D834C48BE5
	for <linux-raid@archiver.kernel.org>; Thu, 17 Jun 2021 18:25:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 67A4B613F3
	for <linux-raid@archiver.kernel.org>; Thu, 17 Jun 2021 18:25:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233736AbhFQS1S (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 17 Jun 2021 14:27:18 -0400
Received: from smtp.hosts.co.uk ([85.233.160.19]:23402 "EHLO smtp.hosts.co.uk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233571AbhFQS0j (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Thu, 17 Jun 2021 14:26:39 -0400
Received: from host86-157-72-169.range86-157.btcentralplus.com ([86.157.72.169] helo=[192.168.1.64])
        by smtp.hosts.co.uk with esmtpa (Exim)
        (envelope-from <antlists@youngman.org.uk>)
        id 1ltwgl-0008Hh-FY; Thu, 17 Jun 2021 19:24:28 +0100
Subject: Re: Recovering RAID-1
To:     H <agents@meddatainc.com>
References: <e6940ac5-9c2a-35bb-04fe-c80fe2a95405@meddatainc.com>
 <b7f88b0e-9941-19c5-bd94-8a79896906f2@youngman.org.uk>
 <ae2589bb-43e9-863d-32f4-86d949f530bd@meddatainc.com>
 <YMo8sEn3BltAfzQM@lazy.lzy>
 <cce5ebf1-6ab5-b448-4312-0ae07d335ac9@meddatainc.com>
Cc:     Linux RAID Mailing List <linux-raid@vger.kernel.org>
From:   Wols Lists <antlists@youngman.org.uk>
X-Enigmail-Draft-Status: N1110
Message-ID: <60CB92D2.1030508@youngman.org.uk>
Date:   Thu, 17 Jun 2021 19:22:10 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:38.0) Gecko/20100101
 Thunderbird/38.7.0
MIME-Version: 1.0
In-Reply-To: <cce5ebf1-6ab5-b448-4312-0ae07d335ac9@meddatainc.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 17/06/21 18:37, H wrote:
> I see. I do recollect that at one time I had /dev/md127 and /dev/md128 show up in gparted. Could they have been created by the Intel fake RAID?
> 
> If there are no signs of a remaining mdadm RAID installation and I have to install fresh, I do have a couple of questions. Naturally I need to make backups of the partitions before doing anything but:
> 
> - Since the system seems to be booting from sdc1 and sdc2 while using sdb3 for the data partition, I would think that any restoration should be from backups of sdc1, sdc2 and sdb3, correct?

Yes. What you could do is create your new array(s) using sdb1, sdb2, and
sdc3, using the "missing" option to create single-disk mirrors. You then
dd the contents of sdc1, sdc2 and sdb3 across, make sure you can/are
booting cleanly from the mirrors, and then add sdc1, sdc2 and sdb3 to
the mirrors.

I'd probably happily do this on a test system for the hell of it, but on
a live system I'd make sure I had backups and be rather careful...
> 
> - Is there anyway to do a dry-run of a fresh mdadm installation to see if it might install on the disks as currently partitioned and not disturb sdc1, sdc2 and sdb3? I do have this minimal partition of ca 4 MiB at the end of both disks which, if I understand correctly, might be used by a mdadm 0.90 scheme?

As above, you could dry-run on the apparently unused partitions, but
BACKUP BACKUP BACKUP!

And no, that little partition at the end will not be where the md
metadata is stored. You're correct, v0.9 (and v1.0) store their metadata
at the end, but at the end of the raid partition, not in a separate
partition.

And you're better off using the recommended 1.2 metadata, because 0.9 is
deprecated, and 1.0 and 1.1 are considered vulnerable to being stomped
on by other utilities that don't know about raid. Even 1.2 is
vulnerable, there've been a couple of cases recently where it seems that
other software (the BIOS, even?) "helpfully" writes a GPT on an
apparently blank disk - RIGHT WHERE MDADM PUT ITS SUPERBLOCK. And these
utilities don't ask permission! Windows of course is notorious for this,
although it seems that it no longer does it regardless it just assumes
that if the user invokes the disk management software then the user must
know what they're doing ... do they ever?

Cheers,
Wol
