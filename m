Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2324AC433E6
	for <linux-raid@archiver.kernel.org>; Mon, 11 Jan 2021 17:28:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EE42822B30
	for <linux-raid@archiver.kernel.org>; Mon, 11 Jan 2021 17:28:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389546AbhAKR22 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 11 Jan 2021 12:28:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389425AbhAKR21 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 11 Jan 2021 12:28:27 -0500
Received: from mail.bitfolk.com (mail.bitfolk.com [IPv6:2001:ba8:1f1:f019::25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C94BC061786
        for <linux-raid@vger.kernel.org>; Mon, 11 Jan 2021 09:27:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=bitfolk.com; s=alpha;
        h=In-Reply-To:Content-Transfer-Encoding:Content-Type:MIME-Version:References:Message-ID:Subject:To:From:Date; bh=j2o2jAZ9bHbIPtnP3x1/ZuBJWA1rP+sVGnruGaTThMw=;
        b=PSnOIq5Uxel2+JguwIAGFhtak2ht8otu7ILKslGkCdD6Fb6CcrabWmf94jJlTkWgbu3emeg0LdPPBeZGvgH5SHS1o74wBicQAJAFovExQAVfuO6QIzh6wV17zC6Ex7rj1sFi/qRWJ630bc0y9SPXrd5Q7N6bV38x+NIHsa2SQ+LzxBVTUEIudD232CLHNrwF7+z+4Mo9vgQSBLr4b6v4YkjARktxVz5vfyUCEe+20Smq+tIk3wm2djmYpKdamGVVQ+4jGaiMVhIjvzL/A071+7UPcH5GEshY2V9wytfmoQY4DR59z6dWI4dbCwb/jLAL3Oj3AQ+Ug4tL4TNUn6Zmrg==;
Received: from andy by mail.bitfolk.com with local (Exim 4.84_2)
        (envelope-from <andy@strugglers.net>)
        id 1kz0ym-0007KR-RU
        for linux-raid@vger.kernel.org; Mon, 11 Jan 2021 17:27:44 +0000
Date:   Mon, 11 Jan 2021 17:27:44 +0000
From:   Andy Smith <andy@strugglers.net>
To:     linux-raid@vger.kernel.org
Subject: Re: "md/raid10:md5: sdf: redirecting sector 2979126480 to another
 mirror"
Message-ID: <20210111172744.GH3712@bitfolk.com>
Mail-Followup-To: linux-raid@vger.kernel.org
References: <20210106232716.GY3712@bitfolk.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210106232716.GY3712@bitfolk.com>
OpenPGP: id=BF15490B; url=http://strugglers.net/~andy/pubkey.asc
X-URL:  http://strugglers.net/wiki/User:Andy
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: andy@strugglers.net
X-SA-Exim-Scanned: No (on mail.bitfolk.com); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Wed, Jan 06, 2021 at 11:27:16PM +0000, Andy Smith wrote:
> "md/raid10:md5: sdf: redirecting sector 2979126480 to another
> mirror"

[…]

> So, this messages comes from here:
> 
>     https://github.com/torvalds/linux/blob/v5.8/drivers/md/raid10.c#L1188
> 
> but under what circumstances does it actually happen?

I managed to obtain a stack trace with "perf":

# Line 77 of this function in the raid10 module is where the
# "redirecting sector" message comes from on my kernel, the stock
# Debian buster kernel.
$ sudo perf probe -s ./linux-source-4.19/ -m raid10 --add 'raid10_read_request:77'
Added new events:
  probe:raid10_read_request (on raid10_read_request:77 in raid10)
  probe:raid10_read_request_1 (on raid10_read_request:77 in raid10)
  probe:raid10_read_request_2 (on raid10_read_request:77 in raid10)
  probe:raid10_read_request_3 (on raid10_read_request:77 in raid10)
  probe:raid10_read_request_4 (on raid10_read_request:77 in raid10)

You can now use it in all perf tools, such as:

        perf record -e probe:raid10_read_request_4 -aR sleep 1

# In another window start up a heavy continuous read load on
# /dev/md3.
$ sudo perf record -e probe:raid10_read_request -gaR sleep 120

# In syslog:
Jan 11 17:10:38 hostname kernel: [1318771.689507] md/raid10:md3: nvme1n1p5: redirecting sector 656970992 to another mirror

# "perf record" finishes:
[ perf record: Woken up 2 times to write data ]
[ perf record: Captured and wrote 0.757 MB perf.data (2 samples) ]
$ sudo perf report --stdio
# To display the perf.data header info, please use --header/--header-only options.
#
#
# Total Lost Samples: 0
#
# Samples: 2  of event 'probe:raid10_read_request'
# Event count (approx.): 2
#
# Children      Self  Trace output
# ........  ........  ..................
#
   100.00%   100.00%  (ffffffffc0127e42)
            |
            ---__libc_read
               entry_SYSCALL_64_after_hwframe
               do_syscall_64
               ksys_read
               vfs_read
               new_sync_read
               generic_file_read_iter
               ondemand_readahead
               __do_page_cache_readahead
               read_pages
               mpage_readpages
               submit_bio
               generic_make_request
               md_make_request
               md_handle_request
               raid10_make_request
               raid10_read_request

So I still don't know why this is considered an error and worth
logging about, but at least I don't see any obvious error paths
there.

I will continue to dig in to it ("perf" is all new to me), but if
anyone happens to know why it does this please do put me out of my
misery!

BTW this is a different host to the one I previously saw it on. As I
say I have seen this message occasionally for years now, on multiple
machines and multiple versions of Debian.

Cheers,
Andy
