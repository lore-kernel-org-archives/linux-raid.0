Return-Path: <SRS0=ezIp=CY=vger.kernel.org=linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC473C433E2
	for <linux-raid@archiver.kernel.org>; Tue, 15 Sep 2020 18:13:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5603621974
	for <linux-raid@archiver.kernel.org>; Tue, 15 Sep 2020 18:13:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727975AbgIOSNI convert rfc822-to-8bit (ORCPT
        <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 15 Sep 2020 14:13:08 -0400
Received: from li1843-175.members.linode.com ([172.104.24.175]:55964 "EHLO
        mail.stoffel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727972AbgIOSLE (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 15 Sep 2020 14:11:04 -0400
Received: from quad.stoffel.org (066-189-075-104.res.spectrum.com [66.189.75.104])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by mail.stoffel.org (Postfix) with ESMTPSA id 7CE8220EA6;
        Tue, 15 Sep 2020 14:10:06 -0400 (EDT)
Received: by quad.stoffel.org (Postfix, from userid 1000)
        id E3EB1A668B; Tue, 15 Sep 2020 14:10:05 -0400 (EDT)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Message-ID: <24417.893.864001.8749@quad.stoffel.home>
Date:   Tue, 15 Sep 2020 14:10:05 -0400
From:   "John Stoffel" <john@stoffel.org>
To:     Nix <nix@esperi.org.uk>
Cc:     Brian Allen Vanderburg II <brianvanderburg2@aim.com>,
        antlists <antlists@youngman.org.uk>, linux-raid@vger.kernel.org
Subject: Re: Linux raid-like idea
In-Reply-To: <87pn6nz361.fsf@esperi.org.uk>
References: <1cf0d18c-2f63-6bca-9884-9544b0e7c54e.ref@aim.com>
        <1cf0d18c-2f63-6bca-9884-9544b0e7c54e@aim.com>
        <e3cb1bbe-65eb-5b75-8e99-afba72156b6e@youngman.org.uk>
        <ef3719a9-ae53-516e-29ee-36d1cdf91ef1@aim.com>
        <87pn6nz361.fsf@esperi.org.uk>
X-Mailer: VM 8.2.0b under 26.1 (x86_64-pc-linux-gnu)
Sender: linux-raid-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

>>>>> "Nix" == Nix  <nix@esperi.org.uk> writes:

Nix> On 5 Sep 2020, Brian Allen Vanderburg, II verbalised:
>> The idea is actually to be able to use more than two disks, like raid 5
>> or raid 6, except with parity on their own disks instead of distributed
>> across disks, and data kept own their own disks as well.  I've used
>> SnapRaid a bit and was just making some changes to my own setup when I
>> got the idea as to why something similar can't be done in block device
>> level, but keeping one of the advantages of SnapRaid-like systems which
>> is if any data disk is lost beyond recovery, then only the data on that
>> data disk is lost due to the fact that the data on the other data disks
>> are still their own complete filesystem, and providing real-time updates
>> to the parity data.
>> 
>> 
>> So for instance
>> 
>> /dev/sda - may be data disk 1, say 1TB
>> 
>> /dev/sdb - may be data disk 2, 2TB
>> 
>> /dev/sdc - may be data disk 3, 2TB
>> 
>> /dev/sdd - may be parity disk 1 (maybe a raid-5-like setup), 2TB
>> 
>> /dev/sde - may be parity disk 2 (maybe a raid-6-like setup), 2TB

Nix> Why use something as crude as parity? There's *lots* of space
Nix> there. You could store full-blown Reed-Solomon stuff in there in
Nix> much less space than parity would require with far more
Nix> likelihood of repairing even very large errors. A separate
Nix> device-mapper target would seem to be perfect for this: like
Nix> dm-integrity, only with a separate set of "error-correcting
Nix> disks" rather than expanding every sector like dm-integrity does.

The problem with parity only disks is that they become hotspots and
drag down performance.  You need/want to stripe parity/checksums/error
correction data across all disks equally so as to get the best
performance.

There are papers on why no one uses RAID4 because of this.

The big trend now seems to be erasure coding, where the parity is
striped across the entire cluster, with data stored in varying levels
of protection, with some mirrored, some striped, some in varying
levels.

John
