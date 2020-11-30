Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D7F0C64E7B
	for <linux-raid@archiver.kernel.org>; Mon, 30 Nov 2020 13:17:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A068E20727
	for <linux-raid@archiver.kernel.org>; Mon, 30 Nov 2020 13:17:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726640AbgK3NRb (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 30 Nov 2020 08:17:31 -0500
Received: from mail.thelounge.net ([91.118.73.15]:19737 "EHLO
        mail.thelounge.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726289AbgK3NRb (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 30 Nov 2020 08:17:31 -0500
Received: from srv-rhsoft.rhsoft.net (rh.vpn.thelounge.net [10.10.10.2])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-256) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: h.reindl@thelounge.net)
        by mail.thelounge.net (THELOUNGE MTA) with ESMTPSA id 4Cl5Nd0nw1zXW2;
        Mon, 30 Nov 2020 14:16:49 +0100 (CET)
To:     antlists <antlists@youngman.org.uk>, linux-raid@vger.kernel.org
References: <e6b7a61d16a25c433438c670fa4c0b4f@posteo.de>
 <bc15926a-8bf4-14ae-bd67-ae14d915d4c0@youngman.org.uk>
 <0fd4f7e5-b71d-0c53-baca-d483d7872981@thelounge.net>
 <5FC4DEED.9030802@youngman.org.uk>
 <832e1194-cc76-b8f8-cb59-2e6bedaeb4dc@thelounge.net>
 <a5288edf-0f77-d813-2f68-995dc4be2ca5@youngman.org.uk>
From:   Reindl Harald <h.reindl@thelounge.net>
Organization: the lounge interactive design
Subject: =?UTF-8?Q?Re=3a_=e2=80=9croot_account_locked=e2=80=9d_after_removin?=
 =?UTF-8?Q?g_one_RAID1_hard_disc?=
Message-ID: <2fbc2ed0-9d0b-cbd1-7ec9-435633131d7d@thelounge.net>
Date:   Mon, 30 Nov 2020 14:16:48 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <a5288edf-0f77-d813-2f68-995dc4be2ca5@youngman.org.uk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



Am 30.11.20 um 14:11 schrieb antlists:
> On 30/11/2020 12:13, Reindl Harald wrote:
>> but i fail to see the difference and to understand why reality and 
>> superblock disagree,
> 
> In YOUR case the array was degraded BEFORE shutdown. In the OP's case, 
> the array was degraded AFTER shutdown

no, no and no again!

* the array is full opertional
* smartd fires a warning
* the machine is shut down
* after that the drive is replaced
* so the array get degraded AFTER shutdown
* at power-on RAID partitions are missing

