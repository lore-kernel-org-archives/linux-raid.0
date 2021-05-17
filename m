Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2C17C433ED
	for <linux-raid@archiver.kernel.org>; Mon, 17 May 2021 13:19:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B18D6610E9
	for <linux-raid@archiver.kernel.org>; Mon, 17 May 2021 13:19:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235777AbhEQNUZ (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 17 May 2021 09:20:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235733AbhEQNUZ (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 17 May 2021 09:20:25 -0400
Received: from rin.romanrm.net (rin.romanrm.net [IPv6:2001:bc8:2dd2:1000::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C4B8C061573
        for <linux-raid@vger.kernel.org>; Mon, 17 May 2021 06:19:09 -0700 (PDT)
Received: from natsu (natsu2.home.romanrm.net [IPv6:fd39::e99e:8f1b:cfc9:ccb8])
        by rin.romanrm.net (Postfix) with SMTP id 48D316D9;
        Mon, 17 May 2021 13:19:06 +0000 (UTC)
Date:   Mon, 17 May 2021 18:19:05 +0500
From:   Roman Mamedov <rm@romanrm.net>
To:     Roger Heflin <rogerheflin@gmail.com>
Cc:     Christopher Thomas <youkai@earthlink.net>,
        Linux RAID <linux-raid@vger.kernel.org>
Subject: Re: My superblocks have gone missing, can't reassemble raid5
Message-ID: <20210517181905.6f976f1a@natsu>
In-Reply-To: <CAAMCDec=H=6ceP9bKjSnsQyvmZ0LqTAYzJTDmDQoBOHSJV+hDw@mail.gmail.com>
References: <CA+o1gzBcQF_JeiC7Nv_zEBmJU2ypwQ_+RkbcZOOt0qOK1MkQww@mail.gmail.com>
        <20210517112844.388d2270@natsu>
        <CAAMCDec=H=6ceP9bKjSnsQyvmZ0LqTAYzJTDmDQoBOHSJV+hDw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Mon, 17 May 2021 05:36:42 -0500
Roger Heflin <rogerheflin@gmail.com> wrote:

> When I look at my 1.2 block, the mdraid header appears to start at 4k, and
> the gpt partition table starts at 0x0000 and ends before 4k.
> 
> He may be able to simply delete the partition and have it work.

Christopher wrote that he tried:

chris@ursula:~$ sudo /sbin/mdadm --verbose --assemble /dev/md0
/dev/sdb /dev/sdc /dev/sdd
mdadm: looking for devices for /dev/md0
mdadm: Cannot assemble mbr metadata on /dev/sdb
mdadm: /dev/sdb has no superblock - assembly aborted

I would have expected mdadm when passed entire devices (not partitions) to not
even look if there are any partitions, and directly proceed to checking if
there's a superblock at its supposed location. But maybe indeed, from the
messages it looks like it bails before that, on seeing "mbr metadata", i.e.
the enclosing MBR partition table of GPT.

-- 
With respect,
Roman
