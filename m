Return-Path: <SRS0=PPQD=CX=vger.kernel.org=linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B5EEC433E2
	for <linux-raid@archiver.kernel.org>; Mon, 14 Sep 2020 08:28:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E28B722204
	for <linux-raid@archiver.kernel.org>; Mon, 14 Sep 2020 08:28:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726190AbgINI2E (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 14 Sep 2020 04:28:04 -0400
Received: from smtp.hosts.co.uk ([85.233.160.19]:36623 "EHLO smtp.hosts.co.uk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726139AbgINI2E (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Mon, 14 Sep 2020 04:28:04 -0400
Received: from host86-136-163-47.range86-136.btcentralplus.com ([86.136.163.47] helo=[192.168.1.65])
        by smtp.hosts.co.uk with esmtpa (Exim)
        (envelope-from <antmbox@youngman.org.uk>)
        id 1kHjqD-0007uc-F6; Mon, 14 Sep 2020 09:28:01 +0100
Subject: Re: [mdadm PATCH 1/2] Check hostname file empty or not when creating
 raid device
To:     Xiao Ni <xni@redhat.com>, jes@trained-monkey.org,
        linux-raid@vger.kernel.org
Cc:     colyli@suse.de, ncroxon@redhat.com
References: <1600061895-16330-1-git-send-email-xni@redhat.com>
 <1600061895-16330-2-git-send-email-xni@redhat.com>
From:   anthony <antmbox@youngman.org.uk>
Message-ID: <5ed15812-1d8d-1c40-6746-36cd801b0166@youngman.org.uk>
Date:   Mon, 14 Sep 2020 09:28:01 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <1600061895-16330-2-git-send-email-xni@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: linux-raid-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 14/09/2020 06:38, Xiao Ni wrote:
> If /etc/hostname is empty and the hostname is decided by DHCP. There is a risk that the raid
> device can't be active after boot. Maybe the network starts after storage. The system can
          ^^^^^

I think you mean "won't" - "the raid device will not be active after boot".

This is a nasty corner case in English Grammar - one verb is "I can, you 
will, he will", the other is "I will, you can, he can" !?!?!?

If you mean it is possible that the array will not be there after boot, 
but that the user can just start it manually (ie there's no real problem 
with it), then it's "the raid device won't be active ..."

Cheers,
Wol
