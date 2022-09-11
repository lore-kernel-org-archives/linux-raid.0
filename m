Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8B5CECAAD3
	for <linux-raid@archiver.kernel.org>; Sun, 11 Sep 2022 12:21:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230208AbiIKMVC (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sun, 11 Sep 2022 08:21:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230116AbiIKMVB (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sun, 11 Sep 2022 08:21:01 -0400
Received: from mail.thelounge.net (mail.thelounge.net [91.118.73.15])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9623930F67
        for <linux-raid@vger.kernel.org>; Sun, 11 Sep 2022 05:20:56 -0700 (PDT)
Received: from [10.10.10.2] (rh.vpn.thelounge.net [10.10.10.2])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-256) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: h.reindl@thelounge.net)
        by mail.thelounge.net (THELOUNGE MTA) with ESMTPSA id 4MQTN63jmWzXLX;
        Sun, 11 Sep 2022 14:20:54 +0200 (CEST)
Message-ID: <dcef59a2-b8f6-ef8b-2fd6-2c8bfdfba4ad@thelounge.net>
Date:   Sun, 11 Sep 2022 14:20:54 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.1
Subject: Re: 3 way mirror
Content-Language: en-US
To:     Gandalf Corvotempesta <gandalf.corvotempesta@gmail.com>
Cc:     Linux RAID Mailing List <linux-raid@vger.kernel.org>
References: <CAJH6TXj0y_bfJ1q50S7xnTyz_4BSrgNboim9e+zK1nKZX9MR3g@mail.gmail.com>
 <53f5754d-e3e2-a8ba-bedb-07eb2b594595@thelounge.net>
 <CAJH6TXi=pCvV2xcyWcOD4KVDP6BcoPdgdMqhSwyW9BMVEhtzYA@mail.gmail.com>
From:   Reindl Harald <h.reindl@thelounge.net>
Organization: the lounge interactive design
In-Reply-To: <CAJH6TXi=pCvV2xcyWcOD4KVDP6BcoPdgdMqhSwyW9BMVEhtzYA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



Am 11.09.22 um 13:35 schrieb Gandalf Corvotempesta:
> Il giorno dom 11 set 2022 alle ore 12:52 Reindl Harald
> <h.reindl@thelounge.net> ha scritto:
>> just throw it out of the array - on a RAID 1 with two disk you have
>> still redundancy and i won't trust a disk which recognized that it has
>> errors on it's own
> 
> Why ? if it's just a single sector, the rest of the disk could be used
> properly until the replacement.

i simply don't trust drives which have thrown errors
you don't lose anything when you push it out of the array

>> what's the point of "can i delay" when you have no other options? :-)
> 
> The option is: i've ordered the new disk, it should arrive this thursday.
> If i'm still on the safe side, i'll wait, if not, i'll replace with
> the first disk I have here, even if slower

you are clearly on the safe side with 3 mirrors and every rebuild wears 
out the remaining drives, 1 out of the 3 would be enough since they hold 
identical data

----------------------

the only thing one should think of: are all 3 drives identical types 
with identical age - then it's more likely that they fail all within a 
short time

that's why i try to mix different disks in a mirror to avoid failing 
both sides of a mirror due firmware-error or a charge of bad disks

----------------------

as i replaced my HDD to SSD i removed two drives out of my RAID10, as it 
didn't boot exchange two of them

so at that point 1 mirror of each stripe was a HDD and one a new SSD, 
after one year i replaced the remaining two disks

2 x 850 EVO 2TB
2 x 860 EVO 2TB

/dev/sda: GB Written: 72.020
/dev/sdb: GB Written: 69.709
/dev/sdc: GB Written: 91.367
/dev/sdd: GB Written: 94.134

pretty impossible that both sides of the same mirror will fail within a 
few hours


