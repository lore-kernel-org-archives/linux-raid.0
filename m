Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49AE8C63777
	for <linux-raid@archiver.kernel.org>; Mon, 30 Nov 2020 20:07:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 11633206DF
	for <linux-raid@archiver.kernel.org>; Mon, 30 Nov 2020 20:07:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728963AbgK3UHm (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 30 Nov 2020 15:07:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726400AbgK3UHl (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 30 Nov 2020 15:07:41 -0500
X-Greylist: delayed 76 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 30 Nov 2020 12:07:01 PST
Received: from u17383850.onlinehome-server.com (u17383850.onlinehome-server.com [IPv6:2607:f1c0:83f:ac00::a6:f62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A53CFC0613CF
        for <linux-raid@vger.kernel.org>; Mon, 30 Nov 2020 12:07:01 -0800 (PST)
Received: by u17383850.onlinehome-server.com (Postfix, from userid 5001)
        id B87F87A0; Mon, 30 Nov 2020 15:06:20 -0500 (EST)
Date:   Mon, 30 Nov 2020 15:06:20 -0500
From:   David T-G <davidtg-robot@justpickone.org>
To:     linux-raid@vger.kernel.org
Subject: Re: ???root account locked??? after removing one RAID1 hard disc
Message-ID: <20201130200620.GW1415@justpickone.org>
References: <e6b7a61d16a25c433438c670fa4c0b4f@posteo.de>
 <bc15926a-8bf4-14ae-bd67-ae14d915d4c0@youngman.org.uk>
 <0fd4f7e5-b71d-0c53-baca-d483d7872981@thelounge.net>
 <ef7d7b4c-d7d2-1bff-8b13-2187889162af@grumpydevil.homelinux.org>
 <ed411d06-c343-43dc-04e1-0a17658cb989@thelounge.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ed411d06-c343-43dc-04e1-0a17658cb989@thelounge.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Reindl, et al --

...and then Reindl Harald said...
% 
...
% 
% typically fire up my "raid-repair.sh" telling the script source and
% target disk for cloning partition table, mbr and finally add the new
% partitions to start the rebuild
[snip]

Oooh!  How handy :-)  Share, please!


HAND

:-D
-- 
David T-G
See http://justpickone.org/davidtg/email/
See http://justpickone.org/davidtg/tofu.txt

