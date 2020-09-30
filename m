Return-Path: <SRS0=vpcD=DH=vger.kernel.org=linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26E8EC4727C
	for <linux-raid@archiver.kernel.org>; Wed, 30 Sep 2020 19:03:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DA31F2084C
	for <linux-raid@archiver.kernel.org>; Wed, 30 Sep 2020 19:03:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730239AbgI3TDf (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 30 Sep 2020 15:03:35 -0400
Received: from smtp.hosts.co.uk ([85.233.160.19]:43792 "EHLO smtp.hosts.co.uk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729556AbgI3TDf (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Wed, 30 Sep 2020 15:03:35 -0400
Received: from host86-157-96-171.range86-157.btcentralplus.com ([86.157.96.171] helo=[192.168.1.64])
        by smtp.hosts.co.uk with esmtpa (Exim)
        (envelope-from <antlists@youngman.org.uk>)
        id 1kNhO1-00021b-9x; Wed, 30 Sep 2020 20:03:33 +0100
Subject: Re: RAID5->RAID6 reshape remains stuck at 0% (does nothing, not even
 start)
To:     David Madore <david+ml@madore.org>
References: <20200930014032.pd4csjwu3m7uihin@achernar.gro-tsen.net>
 <5F740390.7050005@youngman.org.uk>
 <20200930090031.6lzrs336fr4inpz4@achernar.gro-tsen.net>
 <90338e5b-9ed4-c86e-fa35-8acdd6768ca7@youngman.org.uk>
 <20200930185824.q6dphu2axpfcjjly@achernar.gro-tsen.net>
Cc:     Linux RAID mailing-list <linux-raid@vger.kernel.org>
From:   Wols Lists <antlists@youngman.org.uk>
Message-ID: <5F74D684.8020005@youngman.org.uk>
Date:   Wed, 30 Sep 2020 20:03:32 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:38.0) Gecko/20100101
 Thunderbird/38.7.0
MIME-Version: 1.0
In-Reply-To: <20200930185824.q6dphu2axpfcjjly@achernar.gro-tsen.net>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 30/09/20 19:58, David Madore wrote:
> On Wed, Sep 30, 2020 at 03:09:05PM +0100, antlists wrote:
>> > So my guess was spot on :-)
>> > 
>> > You'll guess that this is a common problem, with a well-known solution...
>> > 
>> > https://raid.wiki.kernel.org/index.php/Easy_Fixes#Debian_9_and_Ubuntu
> OK, I've just retried with a new version of mdadm,
> 
> mdadm - v4.1 - 2018-10-01
> 
> - which I think is roughly contemporaneous to the kernel version I'm
> using.  But the problem still persists (with the exact same symptoms
> and details).

Except that mdadm is NOT the problem. The problem is that the kernel and
mdadm are not matched date-wise, and because the kernel is a
franken-kernel you need to use a different kernel.

Use a rescue disk!!! That way, you get a kernel and an mdadm that are
the same approximate date. As it stands, your frankenkernel is too new
for mdadm 3.4, but too ancient for a modern kernel.

Cheers,
Wol
