Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB465C433ED
	for <linux-raid@archiver.kernel.org>; Wed, 12 May 2021 09:47:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7ACAB61263
	for <linux-raid@archiver.kernel.org>; Wed, 12 May 2021 09:47:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230185AbhELJs1 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 12 May 2021 05:48:27 -0400
Received: from smtp.hosts.co.uk ([85.233.160.19]:57649 "EHLO smtp.hosts.co.uk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230019AbhELJs0 (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Wed, 12 May 2021 05:48:26 -0400
Received: from host109-154-217-227.range109-154.btcentralplus.com ([109.154.217.227] helo=[192.168.1.64])
        by smtp.hosts.co.uk with esmtpa (Exim)
        (envelope-from <antlists@youngman.org.uk>)
        id 1lglSX-000BFK-3X; Wed, 12 May 2021 10:47:17 +0100
Subject: Re: Patch to fix boot from RAID-1 partitioned arrays
To:     Geoff Back <geoff@demonlair.co.uk>, Song Liu <song@kernel.org>
References: <d9e1f759-3a11-1d63-f16c-8b999190c633@demonlair.co.uk>
Cc:     linux-raid@vger.kernel.org
From:   Wols Lists <antlists@youngman.org.uk>
X-Enigmail-Draft-Status: N1110
Message-ID: <609BB707.5030505@youngman.org.uk>
Date:   Wed, 12 May 2021 12:07:51 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:38.0) Gecko/20100101
 Thunderbird/38.7.0
MIME-Version: 1.0
In-Reply-To: <d9e1f759-3a11-1d63-f16c-8b999190c633@demonlair.co.uk>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 12/05/21 09:41, Geoff Back wrote:
> Good morning.
> 
> I have had problems in all recent kernels with booting directly from MD
> RAID-1 partitioned arrays (i.e. without using an initrd).
> All the usual requirements - building md and raid1 into the kernel,
> correct partition types, etc - are correct.
> 
> Deep investigation has led me to conclude that the issue is caused by
> boot-time assembly of the array not reading the partition table, meaning
> that the partitions are not visible and cannot be mounted as root
> filesystem.

The other thing is, what superblock are you using? Sounds to me like
you're trying to use an unsupported and bit-rotting option.

Standard procedure today is that you MUST run mdadm to assemble the
array, which means having a functioning user-space, which I believe
means initrd or some such to create the array before you can make it root.

You saying that you need to read the partition table even when you have
a successfully assembled array makes me think something is weird here ...

If you can give us a bit more detail, we can then decide whether what
you're doing is supposed to work or not.

Basically, as I understand what you're doing, you need a 0.9
(unsupported) superblock, and also (unsupported) in-kernel raid assembly.

Cheers,
Wol
