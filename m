Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37025C64E7B
	for <linux-raid@archiver.kernel.org>; Mon, 30 Nov 2020 22:06:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D028020709
	for <linux-raid@archiver.kernel.org>; Mon, 30 Nov 2020 22:06:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730377AbgK3WGq (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 30 Nov 2020 17:06:46 -0500
Received: from u17383850.onlinehome-server.com ([74.208.250.170]:54116 "EHLO
        u17383850.onlinehome-server.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730359AbgK3WGq (ORCPT
        <rfc822;linux-raid@vger.kernel.org>);
        Mon, 30 Nov 2020 17:06:46 -0500
Received: by u17383850.onlinehome-server.com (Postfix, from userid 5001)
        id 758BF79C; Mon, 30 Nov 2020 17:06:05 -0500 (EST)
Date:   Mon, 30 Nov 2020 17:06:05 -0500
From:   David T-G <davidtg-robot@justpickone.org>
To:     linux-raid@vger.kernel.org
Subject: Re: RAID repair script (was "Re: ???root account locked??? after
 removing one RAID1 hard disc"
Message-ID: <20201130220605.GZ1415@justpickone.org>
Reply-To: linux-raid@vger.kernel.org
References: <e6b7a61d16a25c433438c670fa4c0b4f@posteo.de>
 <bc15926a-8bf4-14ae-bd67-ae14d915d4c0@youngman.org.uk>
 <0fd4f7e5-b71d-0c53-baca-d483d7872981@thelounge.net>
 <ef7d7b4c-d7d2-1bff-8b13-2187889162af@grumpydevil.homelinux.org>
 <ed411d06-c343-43dc-04e1-0a17658cb989@thelounge.net>
 <20201130200620.GW1415@justpickone.org>
 <e580e980-1842-b505-8159-e921ccd412a8@thelounge.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e580e980-1842-b505-8159-e921ccd412a8@thelounge.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Reindl, et al --

...and then Reindl Harald said...
% 
% Am 30.11.20 um 21:06 schrieb David T-G:
% >
% >Oooh!  How handy :-)  Share, please!
% 
% just make sure GOOD_DISK is one of the remaining and BAD_DISK is the
% repalcement drive before uncomment the "exit"
% 
% and yeah, adjust how many raid-partitions are there
% 
% the first is my homeserver with 3 filesystems (boot, system, data),
% the second one is a RAID10 on a HP microserver with the OS on a
% sd-card
[snip]

Thanks!


HANN

:-D
-- 
David T-G
See http://justpickone.org/davidtg/email/
See http://justpickone.org/davidtg/tofu.txt

