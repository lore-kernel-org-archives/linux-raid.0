Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7179CC433ED
	for <linux-raid@archiver.kernel.org>; Mon, 17 May 2021 09:32:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 50A666101E
	for <linux-raid@archiver.kernel.org>; Mon, 17 May 2021 09:32:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236032AbhEQJdU (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 17 May 2021 05:33:20 -0400
Received: from smtp.hosts.co.uk ([85.233.160.19]:15572 "EHLO smtp.hosts.co.uk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235863AbhEQJdT (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Mon, 17 May 2021 05:33:19 -0400
Received: from host109-154-217-227.range109-154.btcentralplus.com ([109.154.217.227] helo=[192.168.1.64])
        by smtp.hosts.co.uk with esmtpa (Exim)
        (envelope-from <antlists@youngman.org.uk>)
        id 1liZbW-0009fy-7k; Mon, 17 May 2021 10:32:02 +0100
Subject: Re: My superblocks have gone missing, can't reassemble raid5
To:     Roman Mamedov <rm@romanrm.net>,
        Christopher Thomas <youkai@earthlink.net>
References: <CA+o1gzBcQF_JeiC7Nv_zEBmJU2ypwQ_+RkbcZOOt0qOK1MkQww@mail.gmail.com>
 <20210517112844.388d2270@natsu>
Cc:     linux-raid@vger.kernel.org
From:   Wols Lists <antlists@youngman.org.uk>
X-Enigmail-Draft-Status: N1110
Message-ID: <60A237A5.9020602@youngman.org.uk>
Date:   Mon, 17 May 2021 10:30:13 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:38.0) Gecko/20100101
 Thunderbird/38.7.0
MIME-Version: 1.0
In-Reply-To: <20210517112844.388d2270@natsu>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 17/05/21 07:28, Roman Mamedov wrote:
> As for recovery, you really might need to play with --create; to prevent the
> chance of data loss, there's a way to experiment using "overlays", keeping the
> original drives untouched; see [2] for more background on that, and [3]
> provides steps for your actual situation. Don't forget to use "--assume-clean"
> and "--readonly".

Firstly, what I'd do is a hexdump of the fifth kb of each disk (ie
hopefully where the superblock is/was). Post that here and see if anyone
can decode it. It does look like something has created a gpt, so mdadm
is no longer looking at the raw disk for the array.

There MIGHT be enough information lying around for someone to tell you
what --create command to use. Another thing - are those the original
disks used to create the array? Have you modified the array in any way?
If you haven't modified the array, then a plain create using the same
version of mdadm that created the array should just put things back the
way they were. The reason you mustn't just use --create willy nilly is
that any modification of the array might move the data offset, and
different versions of mdadm may have different default settings.

The other option is BACK UP YOUR HARD DRIVES, delete the new gpt, and
then see if it will assemble.

I know I've seen this before, but I've a nasty feeling the previous time
the user had used partitions and the GPT had been trashed so it's not
quite the same. Still, you might well be lucky ...

Cheers,
Wol
