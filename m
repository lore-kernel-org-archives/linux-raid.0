Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4422C433ED
	for <linux-raid@archiver.kernel.org>; Wed, 12 May 2021 10:56:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 618B2613EE
	for <linux-raid@archiver.kernel.org>; Wed, 12 May 2021 10:56:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230211AbhELK5y (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 12 May 2021 06:57:54 -0400
Received: from outbound5c.eu.mailhop.org ([3.125.148.246]:41266 "EHLO
        outbound5c.eu.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230096AbhELK5y (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 12 May 2021 06:57:54 -0400
ARC-Seal: i=1; a=rsa-sha256; t=1620817005; cv=none;
        d=outbound.mailhop.org; s=arc-outbound20181012;
        b=GGVT7jCSQ/Vz6mtot6+wtU81hxuIocu9U4t9cvff8EBjlGG27D+FizFShMHuOSUVXKI8AxXYCk9XT
         szlIjId3QT34M6tFH3+5lbI7/KWc2g9zAOyx+cWYHgeTIBvjMapkE4ts9TW/SZPBpNq3X6eM7pAnW+
         HYS4t1+SmRWTLtNkU2CvJZltk4LYI+GM/vAsdjAUfC3g8/FHegrmqkMVI3o3MhddfJ8U5p7HRG6QLv
         9Da0hmISVlxC30d0yoN6ai4buXLA2R+OgVXta/DRiymTq5FCXivPTIlDvSSWJ6JTjuAl9QpQdoLfro
         qqzzjGwo7vNkLIyJVy07AgIzsXPD0Lw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed;
        d=outbound.mailhop.org; s=arc-outbound20181012;
        h=content-transfer-encoding:content-type:in-reply-to:mime-version:date:
         message-id:from:references:cc:to:subject:dkim-signature:from;
        bh=S85l7ADHExMP/41k5jakmnHtFCBZHELxIBp5oxd2bcM=;
        b=mf/FDD2+F8G7lw+J4P6RXpedKI10emksUJfKmMAoOIky+pv7tbAYH3M1ORBTDrAoPhGdjkLDW+bRF
         0ECt8JivP5wu1pkw+FjchI1bBGAnP6nXTH/w9YP80OC3xSuTwx/qhYzDAIxINGKtznq83p7EtuSW0R
         vV7SSDm57PGa04szo9HNaVJRc9HS0j/ogh9LUkpRzRcCD691Fh+o7tnuKUDk/WeDum0HfN1DhC2Pt1
         sB01OKeymk/lZf0EbdwmbKF+joLLGushOJjwb+vZPKZC1ROyVb9kQ6/9xS7mlgmvlgG3qmx6quWJYx
         +vBqaN6osz8e90nW0zrd2f84js/QDtQ==
ARC-Authentication-Results: i=1; outbound3.eu.mailhop.org;
        spf=pass smtp.mailfrom=demonlair.co.uk smtp.remote-ip=81.143.99.161;
        dmarc=none header.from=demonlair.co.uk;
        arc=none header.oldest-pass=0;
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=outbound.mailhop.org; s=dkim-high;
        h=content-transfer-encoding:content-type:in-reply-to:mime-version:date:
         message-id:from:references:cc:to:subject:from;
        bh=S85l7ADHExMP/41k5jakmnHtFCBZHELxIBp5oxd2bcM=;
        b=d134HkWybGhW/pQUG07M91eH9C1CUxf38aCIFlMDP+1beKR5/rVmloqPow77g0G5MmLoJwlQ36bYT
         unKBvSrdUFsFDLZtuDPDUSKuSuLQg+sOoRMur9AarQ/j7wqoK3PGKB1KinGFCZG7iUg1dwM7kPYPGi
         f9Uj4uh4zqwAcp5k65C/sjuaUNxSOgP33gJ99/pwwR8/SZfPT9Peq7ZWIYcjlQXTThzKp4/mELysNk
         iT6NlZnotL5149Css8IAynonkToPgNlYLj4mTauHbyzxaTPb9bkfBLA1ugx10myG7BsA/v0djse/4h
         S1TWPEtDt57uwIHVjgqPHF1jk2ZASyA==
X-Originating-IP: 81.143.99.161
X-MHO-RoutePath: ZGVtb25sYWly
X-MHO-User: bbdbec46-b310-11eb-a3fe-d17a12b91375
X-Report-Abuse-To: https://support.duocircle.com/support/solutions/articles/5000540958-duocircle-standard-smtp-abuse-information
X-Mail-Handler: DuoCircle Outbound SMTP
Received: from mars.demonlair.co.uk (host81-143-99-161.in-addr.btopenworld.com [81.143.99.161])
        by outbound3.eu.mailhop.org (Halon) with ESMTPA
        id bbdbec46-b310-11eb-a3fe-d17a12b91375;
        Wed, 12 May 2021 10:56:42 +0000 (UTC)
Received: from [10.57.1.96] (mercury.demonlair.co.uk [10.57.1.96])
        by mars.demonlair.co.uk (Postfix) with ESMTP id 8ADDB1FC19E;
        Wed, 12 May 2021 11:56:41 +0100 (BST)
Subject: Re: Patch to fix boot from RAID-1 partitioned arrays
To:     Wols Lists <antlists@youngman.org.uk>, Song Liu <song@kernel.org>
Cc:     linux-raid@vger.kernel.org
References: <d9e1f759-3a11-1d63-f16c-8b999190c633@demonlair.co.uk>
 <609BB707.5030505@youngman.org.uk>
From:   Geoff Back <geoff@demonlair.co.uk>
Message-ID: <3f46a847-3dc4-4f39-5789-f85872e03c43@demonlair.co.uk>
Date:   Wed, 12 May 2021 11:56:41 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <609BB707.5030505@youngman.org.uk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



On 12/05/2021 12:07, Wols Lists wrote:
> On 12/05/21 09:41, Geoff Back wrote:
>> Good morning.
>>
>> I have had problems in all recent kernels with booting directly from MD
>> RAID-1 partitioned arrays (i.e. without using an initrd).
>> All the usual requirements - building md and raid1 into the kernel,
>> correct partition types, etc - are correct.
>>
>> Deep investigation has led me to conclude that the issue is caused by
>> boot-time assembly of the array not reading the partition table, meaning
>> that the partitions are not visible and cannot be mounted as root
>> filesystem.
> 
> The other thing is, what superblock are you using? Sounds to me like
> you're trying to use an unsupported and bit-rotting option.

Yes, I am using 0.9 superblocks, because in-kernel auto detection does
not support the newer 1.x superblock formats.

> 
> Standard procedure today is that you MUST run mdadm to assemble the
> array, which means having a functioning user-space, which I believe
> means initrd or some such to create the array before you can make it root.

Using an initrd would add considerable additional complexity and
resource consumption to a configuration that until recently (some time
since linux 5.5.3) just worked.  Yes, I know that the general approach
for common distros is to use initrd, but for my use case it is not
appropriate.

> 
> You saying that you need to read the partition table even when you have
> a successfully assembled array makes me think something is weird here ...

The problem is not with in-kernel assembly and starting of the array -
that works perfectly well.  However, when the 'md' driver assembles and
runs the partitionable array device (typically /dev/md_d0) it only
causes the array device itself to get registered with the block layer.
The assembled array is not then scanned for partitions until something
accesses the device, at which point the pending GD_NEED_PART_SCAN flag
in the array's block-device structure causes the probe for a partition
table to take place and the partitions to become accessible.

Without my patch, there does not appear to be anything between array
assembly and root mount that will access the array and cause the
partition probe operation.

To be clear, the situation is that the array has been fully assembled
and activated but the partitions it contains remain inaccessible.

> 
> If you can give us a bit more detail, we can then decide whether what
> you're doing is supposed to work or not.
> 
> Basically, as I understand what you're doing, you need a 0.9
> (unsupported) superblock, and also (unsupported) in-kernel raid assembly.

Neither the 0.9 superblock format, nor the in-kernel array detection
process, are marked as deprecated in the kernel Kconfig - indeed
automatic raid detection still defaults to enabled when 'md' is enabled.

My patch is intended as a minimally-invasive fix to a functional
regression - this used to work and the kernel sources/documentation say
it should still work, but in practice (without the patch) it doesn't.

There was a relatively recent change that removed code which
deliberately performed partition probing after assembly in one of the
two code paths, but according to the patch it was only removed on the
basis that it was unclear why the probing was done; I suspect that this
regression may be partly due to that change. My patch effectively
reinstates the same functionality in that code path and adds the same
functionality to the other code path.


> 
> Cheers,
> Wol
> 

Thanks,

Geoff.

-- 
Geoff Back
What if we're all just characters in someone's nightmares?
