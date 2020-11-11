Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5728C388F9
	for <linux-raid@archiver.kernel.org>; Wed, 11 Nov 2020 15:30:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 665F5206A1
	for <linux-raid@archiver.kernel.org>; Wed, 11 Nov 2020 15:30:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726456AbgKKPak (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 11 Nov 2020 10:30:40 -0500
Received: from smtp.hosts.co.uk ([85.233.160.19]:37729 "EHLO smtp.hosts.co.uk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726136AbgKKPaj (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Wed, 11 Nov 2020 10:30:39 -0500
Received: from host86-155-135-57.range86-155.btcentralplus.com ([86.155.135.57] helo=[192.168.1.65])
        by smtp.hosts.co.uk with esmtpa (Exim)
        (envelope-from <antlists@youngman.org.uk>)
        id 1kcs4u-000AF6-Aq; Wed, 11 Nov 2020 15:30:32 +0000
Subject: Re: How mdadm react with disk corruption during check?
To:     Aymeric <mulx@aplu.fr>, linux-raid@vger.kernel.org
References: <ec374580-6b69-85df-0342-27d42c5e515e@aplu.fr>
From:   antlists <antlists@youngman.org.uk>
Message-ID: <83ad5c50-fc7d-75af-5919-3867ac263798@youngman.org.uk>
Date:   Wed, 11 Nov 2020 15:30:33 +0000
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.2
MIME-Version: 1.0
In-Reply-To: <ec374580-6b69-85df-0342-27d42c5e515e@aplu.fr>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 11/11/2020 10:39, Aymeric wrote:
> Hello,
> 
> I've searched a bit on the wiki but didn't find any clear answer.
> 
> So let assume we have a raid 1 with two disks : sda and sdb.
> You can read and write on both disks without I/O error, so no drive are
> going to be kicked out the array.
> The only stuff is that sda will not read what has been written on some
> sectors.
> 
> I know that mdadm can not detect integrity during normal usage, and as
> read on the array will be performed by chunck randomly on the two disks
> you get a partial corrupted reading.

md-raid is not meant to protect against corruption - it protects against 
disk failure.
> 
> Now, during checkarray command, mdadm is reading the whole disk, it will
> detect that sda and sdb does not contain the same data (at least I hope
> that checkarray is comparing data on both disks).
> 
> How does it decide which drive (sda or sdb) have correct data to write
> it back the other disks?

It just assumes that sda is correct ...

> Is there any messages available in such case?
> 
> And I've the same question with raid 1 on 3 disks and same behavior on sda.
> 
I'm pretty the certain it's the same.


When I get it working ... famous last words ... the system I'm building 
has md-raid on top of dm-integrity. So if you do get corruption, the dm 
layer should return a read error and trigger a clean-up write. And once 
that's sorted I'll be trying to integrate it into md-raid as an option.

Cheers,
Wol
