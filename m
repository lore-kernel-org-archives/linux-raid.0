Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02FD9C433ED
	for <linux-raid@archiver.kernel.org>; Sat,  1 May 2021 10:09:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D0541613AD
	for <linux-raid@archiver.kernel.org>; Sat,  1 May 2021 10:09:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231867AbhEAKJz (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sat, 1 May 2021 06:09:55 -0400
Received: from smtp.hosts.co.uk ([85.233.160.19]:33135 "EHLO smtp.hosts.co.uk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231252AbhEAKJy (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Sat, 1 May 2021 06:09:54 -0400
Received: from host86-152-228-242.range86-152.btcentralplus.com ([86.152.228.242] helo=[192.168.1.64])
        by smtp.hosts.co.uk with esmtpa (Exim)
        (envelope-from <antlists@youngman.org.uk>)
        id 1lcmYZ-000A8O-80; Sat, 01 May 2021 11:09:03 +0100
Subject: Re: add new disk with dd
To:     d tbsky <tbskyd@gmail.com>
References: <CAC6SzHLDYhQDtfQMYozN6EBYB=nsKvB77hmyByZNr9uTpQH+KQ@mail.gmail.com>
 <7903054.T7Z3S40VBb@matkor-hp>
 <CAC6SzH+JM9EWiB9kQNPaSm8prX-hK3N7D7yzB3Po3nS43fZJ3A@mail.gmail.com>
Cc:     list Linux RAID <linux-raid@vger.kernel.org>
From:   Wols Lists <antlists@youngman.org.uk>
X-Enigmail-Draft-Status: N1110
Message-ID: <608D2862.9090306@youngman.org.uk>
Date:   Sat, 1 May 2021 11:07:30 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:38.0) Gecko/20100101
 Thunderbird/38.7.0
MIME-Version: 1.0
In-Reply-To: <CAC6SzH+JM9EWiB9kQNPaSm8prX-hK3N7D7yzB3Po3nS43fZJ3A@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 29/04/21 16:32, d tbsky wrote:
> Mateusz <mateusz-lists@ant.gliwice.pl>
>> Should in most cases [1], but IMHO it's good idea to
>> mdadm --zero-superblock /dev/YOU_ARE_SURE_IS_ONE_YOU_WANT_TO_ADD
>> before adding disk already used somewhere else.
> 
>    "madam --zero-superblock" is great.  I will add it to my procedure.
>    thanks a lot for the hint!
> 
>> BTW,  IMHO it's better to clone partition layout, and than install bootloaders
>> instead of dding disk.
> 
>    yes. but sometimes dd is easy, especially for mbr layout.
> anyway I think your suggestion "--zero-superblock" make things safe
> with new and old disks.
> 
I notice you said mbr ... because with GPT it will give you a broken
partition table.

Note also it will copy all your guids, so you don't EVER want those two
disks to be in the same system at the same time ...

I'd do what the others have suggested - copy the partition table,
re-install grub or whatever (you have got it documented what to do? :-)
It should be easy), and simply add your replacement partition.

Oh - and did you say it was raid-5? You've just busted your redundancy
during the most dangerous period of an array's life - the rebuild. If
you add the new disk to your system then do a --replace before removing
the old, your array is fully protected at all times and the only two
disks being hammered are the old one that's not working properly anyway,
and the new one that should be able to take it.

(The other thing about doing a proper rebuild, is you can use a larger
disk, and a larger partition, ready to upgrade the other disks and grow
your array.)

Cheers,
Wol
