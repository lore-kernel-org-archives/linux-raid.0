Return-Path: <SRS0=BPCQ=CN=vger.kernel.org=linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA898C43461
	for <linux-raid@archiver.kernel.org>; Fri,  4 Sep 2020 08:02:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A0F27206B8
	for <linux-raid@archiver.kernel.org>; Fri,  4 Sep 2020 08:02:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=bitfolk.com header.i=@bitfolk.com header.b="s04LCwjn"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728163AbgIDICK (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 4 Sep 2020 04:02:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726151AbgIDICJ (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 4 Sep 2020 04:02:09 -0400
X-Greylist: delayed 965 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 04 Sep 2020 01:02:09 PDT
Received: from mail.bitfolk.com (mail.bitfolk.com [IPv6:2001:ba8:1f1:f019::25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C1F0C061244
        for <linux-raid@vger.kernel.org>; Fri,  4 Sep 2020 01:02:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=bitfolk.com; s=alpha;
        h=Content-Type:MIME-Version:Message-ID:Subject:To:From:Date; bh=ARxNMSvXvUunAINJmdELEdoAUvLN2Ng8Y8YPwSkD1FI=;
        b=s04LCwjnMrrjalwsJLTeZf59DFkX/RDxvhl0c6IvssKk1uPyNzjSpZ5Rdjr+nYXj2XVnnYLHG3vyOaME/j970YBZov6uenZUSBIhejCmrrsrzdkSBoPTiu0B0Z44eou92MDstx7RTEgTabg0dlssMSjm40dlmKB868PmQN2PGKmjZzujbToir5RPlOCngf5acn8gpbwsgTThHjk6q9lbMGvWkOYVycDYIWC9T3mavTp7+0waWcLf0/4cxsbuoT9T3SVReDQdU+u7rDUloXnIa9olMYX7cfiulGtd0yUiWmaSq56Ab9chvfnceI+P/bXT1VKAuMthAty/4vdRKe7FOw==;
Received: from andy by mail.bitfolk.com with local (Exim 4.84_2)
        (envelope-from <andy@strugglers.net>)
        id 1kE6Q1-0002t6-3P
        for linux-raid@vger.kernel.org; Fri, 04 Sep 2020 07:45:57 +0000
Date:   Fri, 4 Sep 2020 07:45:57 +0000
From:   Andy Smith <andy@strugglers.net>
To:     linux-raid@vger.kernel.org
Subject: Config option for removing bbl on assembly?
Message-ID: <20200904074557.GT13298@bitfolk.com>
Mail-Followup-To: linux-raid@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
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

Could we have a config setting for removing the bad blocks list on
assembly?

I'm aware that one could put:

CREATE bbl=no

in mdadm.conf and then newly created arrays won't have a bad blocks
list. But in many cases, system arrays are created before an
mdadm.conf exists, so they get a bbl.

So, to remove a bbl I know that you have to stop the array and
assemble it like:

# mdadm /dev/mdX --assemble --update=no-bbl

Again, for arrays with the actual system on it this is rather
inconvenient. Even having to have some downtime of the service to do
this is not great.

So how about a config option telling mdadm to remove empty bbl the
next time arrays are assembled? If there is a bbl with entries in it
then it could warn and not remove it (so no force).

Cheers,
Andy
