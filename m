Return-Path: <SRS0=gUE6=CZ=vger.kernel.org=linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	FORGED_MUA_MOZILLA,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CED6CC2D0E3
	for <linux-raid@archiver.kernel.org>; Wed, 16 Sep 2020 00:16:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9D8BC20739
	for <linux-raid@archiver.kernel.org>; Wed, 16 Sep 2020 00:16:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727272AbgIPAQe (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 15 Sep 2020 20:16:34 -0400
Received: from static.214.254.202.116.clients.your-server.de ([116.202.254.214]:34042
        "EHLO ciao.gmane.io" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726359AbgIOOW7 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 15 Sep 2020 10:22:59 -0400
Received: from list by ciao.gmane.io with local (Exim 4.92)
        (envelope-from <linux-raid@m.gmane-mx.org>)
        id 1kIBqz-0003GA-GU
        for linux-raid@vger.kernel.org; Tue, 15 Sep 2020 16:22:41 +0200
X-Injected-Via-Gmane: http://gmane.org/
To:     linux-raid@vger.kernel.org
From:   Ian Pilcher <arequipeno@gmail.com>
Subject: IMSM RAID not recognized after kernel update
Date:   Tue, 15 Sep 2020 09:22:37 -0500
Message-ID: <rjqind$2k0$1@ciao.gmane.io>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
X-Mozilla-News-Host: news://news.gmane.org:119
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

https://bugzilla.redhat.com/show_bug.cgi?id=1878970

After updating my Fedora kernel package this morning, my IMSM RAID is
no longer recognized:

[pilcher@ian system]$ sudo mdadm --examine --verbose /dev/sdc
/dev/sdc:
    MBR Magic : aa55
Partition[0] :       204800 sectors at         2048 (type 07)
Partition[1] :      2048000 sectors at       206848 (type 83)
Partition[2] :     61440000 sectors at      2254848 (type 07)
Partition[3] :   1889824768 sectors at     63694848 (type 05)

If I boot the older kernel, it says:

[pilcher@ian ~]$ sudo mdadm --examine --verbose /dev/sdc
/dev/sdc:
           Magic : Intel Raid ISM Cfg Sig.
             ⋮

Any tips on what might cause this or how to debug further would be
appreciated.

Thanks!

-- 
========================================================================
                  In Soviet Russia, Google searches you!
========================================================================

