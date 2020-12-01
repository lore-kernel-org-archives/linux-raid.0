Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6CD5C64E7A
	for <linux-raid@archiver.kernel.org>; Tue,  1 Dec 2020 10:01:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4786F206C0
	for <linux-raid@archiver.kernel.org>; Tue,  1 Dec 2020 10:01:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726440AbgLAKB2 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 1 Dec 2020 05:01:28 -0500
Received: from smtp.hosts.co.uk ([85.233.160.19]:9397 "EHLO smtp.hosts.co.uk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725967AbgLAKB2 (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Tue, 1 Dec 2020 05:01:28 -0500
Received: from host86-149-69-253.range86-149.btcentralplus.com ([86.149.69.253] helo=[192.168.1.64])
        by smtp.hosts.co.uk with esmtpa (Exim)
        (envelope-from <antlists@youngman.org.uk>)
        id 1kk2Sk-00012X-6y; Tue, 01 Dec 2020 10:00:46 +0000
Subject: Re: partitions & filesystems (was "Re: ???root account locked???
 after removing one RAID1 hard disc")
To:     c.buhtz@posteo.jp
References: <e6b7a61d16a25c433438c670fa4c0b4f@posteo.de>
 <20201130200503.GV1415@justpickone.org>
 <01a571de-8ae8-3d9e-6f3d-16555ad93ea3@youngman.org.uk>
 <1914ec9a6f74130a8e6399c08edefdc1@posteo.de>
Cc:     David T-G <davidtg-robot@justpickone.org>,
        linux-raid@vger.kernel.org
From:   Wols Lists <antlists@youngman.org.uk>
Message-ID: <5FC6144D.40208@youngman.org.uk>
Date:   Tue, 1 Dec 2020 10:00:45 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:38.0) Gecko/20100101
 Thunderbird/38.7.0
MIME-Version: 1.0
In-Reply-To: <1914ec9a6f74130a8e6399c08edefdc1@posteo.de>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 01/12/20 08:45, c.buhtz@posteo.jp wrote:
> I think my missunderstand depends also on my bad english?
> 
> Am 30.11.2020 21:51 schrieb antlists:
>> On 30/11/2020 20:05, David T-G wrote:
>>> You don't see any "filesystem" or, more correctly, partition in your
>>>
>>>    fdisk -l
>>>
>>> output because you have apparently created your filesystem on the entire
>>> device (hey, I didn't know one could do that!).
>>
>> That, actually, is the norm. It is NOT normal to partition a raid array.
> 
> In my understanding you are contradicting yourself here.
> Is there a difference between
>   "create filesystem on the entire device"
> and
>   "partition a raid array"
> ?
Yes.

Creating a raid array on an entire device means

"mdadm --create --devices sda sdb"

partioning a raid array means

"fdisk /dev/md127"

Remember linux doesn't care what a block device is, it's a block device.
So you can put a raid array directly on top of physical disks, and you
can put a GPT on top of a raid array.

Neither are recommended.

Cheers,
Wol
