Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3175C64E8A
	for <linux-raid@archiver.kernel.org>; Mon, 30 Nov 2020 12:01:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8BD17206D8
	for <linux-raid@archiver.kernel.org>; Mon, 30 Nov 2020 12:01:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729166AbgK3MBi (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 30 Nov 2020 07:01:38 -0500
Received: from smtp.hosts.co.uk ([85.233.160.19]:50182 "EHLO smtp.hosts.co.uk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725976AbgK3MBi (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Mon, 30 Nov 2020 07:01:38 -0500
Received: from host86-149-69-253.range86-149.btcentralplus.com ([86.149.69.253] helo=[192.168.1.64])
        by smtp.hosts.co.uk with esmtpa (Exim)
        (envelope-from <antlists@youngman.org.uk>)
        id 1kjhrU-0002Hv-A6; Mon, 30 Nov 2020 12:00:56 +0000
Subject: =?UTF-8?Q?Re:_=e2=80=9croot_account_locked=e2=80=9d_after_removing_?=
 =?UTF-8?Q?one_RAID1_hard_disc?=
To:     Reindl Harald <h.reindl@thelounge.net>, linux-raid@vger.kernel.org
References: <e6b7a61d16a25c433438c670fa4c0b4f@posteo.de>
 <bc15926a-8bf4-14ae-bd67-ae14d915d4c0@youngman.org.uk>
 <0fd4f7e5-b71d-0c53-baca-d483d7872981@thelounge.net>
From:   Wols Lists <antlists@youngman.org.uk>
X-Enigmail-Draft-Status: N1110
Message-ID: <5FC4DEED.9030802@youngman.org.uk>
Date:   Mon, 30 Nov 2020 12:00:45 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:38.0) Gecko/20100101
 Thunderbird/38.7.0
MIME-Version: 1.0
In-Reply-To: <0fd4f7e5-b71d-0c53-baca-d483d7872981@thelounge.net>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 30/11/20 10:31, Reindl Harald wrote:
> since when is it broken that way?
> 
> from where should that commandlien come from when the operating system
> itself is on the for no vali dreason not assembling RAID?
> 
> luckily the past few years no disks died but on the office server 300
> kilometers from here with /boot, os and /data on RAID1 this was not true
> at least 10 years
> 
> * disk died
> * boss replaced it and made sure
>   the remaining is on the first SATA
>   port
> * power on
> * machine booted
> * me partitioned and added the new drive
> 
> hell it's and ordinary situation for a RAID that a disk disappears
> without warning because they tend to die from one moment to the next
> 
> hell it's expected behavior to boot from the remaining disks, no matter
> RAID1, RAID10, RAID5 as long as there are enough present for the whole
> dataset
> 
> the only thing i expect in that case is that it takes a little longer to
> boot when soemthing tries to wait until a timeout for the missing device
> / componenzt
> 
So what happened? The disk failed, you shut down the server, the boss
replaced it, and you rebooted?

In that case I would EXPECT the system to come back - the superblock
matches the disks, the system says "everything is as it was", and your
degraded array boots fine.

EXCEPT THAT'S NOT WHAT IS HAPPENING HERE.

The - fully functional - array is shut down.

A disk is removed.

On boot, reality and the superblock DISAGREE. In which case the system
takes the only sensible route, screams "help!", and waits for MANUAL
INTERVENTION.

That's why you only have to force a degraded array to boot once - once
the disks and superblock are back in sync, the system assumes the ops
know about it.

Cheers,
Wol
