Return-Path: <SRS0=ezIp=CY=vger.kernel.org=linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33765C433E2
	for <linux-raid@archiver.kernel.org>; Tue, 15 Sep 2020 10:27:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C60FE21D7B
	for <linux-raid@archiver.kernel.org>; Tue, 15 Sep 2020 10:27:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=bitfolk.com header.i=@bitfolk.com header.b="KTuq6/KR"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726338AbgIOK1r (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 15 Sep 2020 06:27:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726198AbgIOK1p (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 15 Sep 2020 06:27:45 -0400
Received: from mail.bitfolk.com (mail.bitfolk.com [IPv6:2001:ba8:1f1:f019::25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12692C06174A
        for <linux-raid@vger.kernel.org>; Tue, 15 Sep 2020 03:27:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=bitfolk.com; s=alpha;
        h=Content-Transfer-Encoding:Content-Type:MIME-Version:Message-ID:Subject:To:From:Date; bh=Y/47fhppgkA/rSF5f2dlag9rnUslU/p7ofSGhMJjQDs=;
        b=KTuq6/KRFzPir7nD+CDWOWj8nsVcSUA9kpMqLLc6hN9ZraXIIfHedT8e545a9AK2yOpexAvRQpAL02ZQEARDIZiRxWYNKO7NDK49e/8aL1S9Ggx2MQWwVtjLCAFhOlkl5lbgNsj4SgvIzmUxu+bpPVPmQfsJVAiJrwbuaiC/ll8FGsPE7SHgKu+BaI/0gN91bGoDnRBKuRYMjq3sxRNTwuYU68vRy77yH73SueDpB7EU0shOp1X0axivlYLdSq8yAGCKTshglqjcWkQ5pnnFh4R/Y8KobRpROzl6F1er37qgf9zoTWh/w4Wfz3bEQ6ZHDihC1XJku6ff2l30S9xHqg==;
Received: from andy by mail.bitfolk.com with local (Exim 4.84_2)
        (envelope-from <andy@strugglers.net>)
        id 1kI8BU-0005NL-50
        for linux-raid@vger.kernel.org; Tue, 15 Sep 2020 10:27:36 +0000
Date:   Tue, 15 Sep 2020 10:27:36 +0000
From:   Andy Smith <andy@strugglers.net>
To:     linux-raid@vger.kernel.org
Subject: "--re-add for /dev/sdb1 to /dev/md0 is not possible"
Message-ID: <20200915102736.GE13298@bitfolk.com>
Mail-Followup-To: linux-raid@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
OpenPGP: id=BF15490B; url=http://strugglers.net/~andy/pubkey.asc
X-URL:  http://strugglers.net/wiki/User:Andy
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: andy@strugglers.net
X-SA-Exim-Scanned: No (on mail.bitfolk.com); SAEximRunCond expanded to false
Sender: linux-raid-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi,

In my continuing goal to remove the bad blocks log from any of my
arrays and not have one on any new arrays I create, I wrote this
article:

    https://strugglers.net/~andy/blog/2020/09/13/debian-installer-mdadm-configuration-and-the-bad-blocks-controversy

Shortly afterwards someone on Hacker News¹ said that it is possible
to remove the BBL by failing and re-adding devices, like so:

# mdadm /dev/md127 --fail /dev/sda --remove /dev/sda --re-add /dev/sda --update=no-bbl

I tried that on Ubuntu 18.04:

$ mdadm --version
mdadm - v4.1-rc1 - 2018-03-22
$ sudo mdadm --fail /dev/md0 /dev/sdb1 --remove /dev/sdb1 --re-add /dev/sdb1 --update=no-bbl
mdadm: set /dev/sdb1 faulty in /dev/md0
mdadm: hot removed /dev/sdb1 from /dev/md0
mdadm: --re-add for /dev/sdb1 to /dev/md0 is not possible
$ sudo mdadm --add /dev/md0 /dev/sdb1 --update=no-bbl
mdadm: --update in Manage mode only allowed with --re-add.
$ sudo mdadm --add /dev/md0 /dev/sdb1
mdadm: added /dev/sdb1
$ sudo mdadm --examine-badblocks /dev/sdb1
Bad-blocks list is empty in /dev/sdb1

I tried it on Debian buster:

$ mdadm --version
mdadm - v4.1 - 2018-10-01
$ sudo mdadm --fail /dev/md6 /dev/sdb1 --remove /dev/sdb1 --re-add /dev/sdb1 --update=no-bbl
mdadm: set /dev/sdb1 faulty in /dev/md6
mdadm: hot removed /dev/sdb1 from /dev/md6
mdadm: --re-add for /dev/sdb1 to /dev/md6 is not possible

So, is that supposed to work and if so, why doesn't it work for me?

In both cases these are simple two device RAID-1 metadata version
1.2 arrays. Neither has bitmaps.

Thanks,
Andy

¹ https://news.ycombinator.com/item?id=24479235
