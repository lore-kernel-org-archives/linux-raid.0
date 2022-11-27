Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51C5CC4332F
	for <linux-raid@archiver.kernel.org>; Sun, 27 Nov 2022 14:33:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229504AbiK0Odn (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sun, 27 Nov 2022 09:33:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229469AbiK0Odm (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sun, 27 Nov 2022 09:33:42 -0500
Received: from smtp.hosts.co.uk (smtp.hosts.co.uk [85.233.160.19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 885D8EE06
        for <linux-raid@vger.kernel.org>; Sun, 27 Nov 2022 06:33:40 -0800 (PST)
Received: from host86-138-24-20.range86-138.btcentralplus.com ([86.138.24.20] helo=[192.168.1.65])
        by smtp.hosts.co.uk with esmtpa (Exim)
        (envelope-from <antlists@youngman.org.uk>)
        id 1ozIiw-000CAH-41;
        Sun, 27 Nov 2022 14:33:38 +0000
Message-ID: <fd6a2f41-405a-7ec7-e8f1-c970e32973c4@youngman.org.uk>
Date:   Sun, 27 Nov 2022 14:33:37 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: how do i fix these RAID5 arrays?
To:     Reindl Harald <h.reindl@thelounge.net>,
        John Stoffel <john@stoffel.org>
Cc:     David T-G <davidtg-robot@justpickone.org>,
        Linux RAID list <linux-raid@vger.kernel.org>
References: <20221123220736.GD19721@jpo> <20221124032821.628cd042@nvm>
 <20221124211019.GE19721@jpo>
 <f58964da-4ded-61a8-bd6a-e2391557b38a@youngman.org.uk>
 <25474.28874.952381.412636@quad.stoffel.home>
 <fd543697-14a6-0868-82a1-be61790e07f3@thelounge.net>
 <62b72b4e-8461-e616-1227-4dcef8853143@youngman.org.uk>
 <7316d29a-bab6-b8a2-5c77-803af8de378b@thelounge.net>
Content-Language: en-GB
From:   Wol <antlists@youngman.org.uk>
In-Reply-To: <7316d29a-bab6-b8a2-5c77-803af8de378b@thelounge.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 27/11/2022 12:06, Reindl Harald wrote:
> 
> 
> Am 27.11.22 um 12:52 schrieb Wols Lists:
>> On 27/11/2022 11:46, Reindl Harald wrote:
>>>
>>>
>>> Am 26.11.22 um 21:02 schrieb John Stoffel:
>>>> I call it a failure of the layering model.  If you want RAID, use MD.
>>>> If you want logical volumes, then put LVM on top.  Then put
>>>> filesystems into logical volumes.
>>>>
>>>> So much simpler...
>>>
>>> have you ever replaced a 6 TB drive and waited for the resync of 
>>> mdadm in the hope in all that hours no other drive goes down?
>>>
>>> when your array is 10% used it's braindead
>>> when your array is new and empty it's braindead
>>>
>>> ZFS/BTRFS don't neeed to mirror/restore 90% nulls
>>
>> This is why you have trim. 
> 
> besides that such large disks are typically HDD trim has nothing to do 
> with the fact that after a drive replacement linux raid knows *nothing* 
> about trim and does a full resync
> 
> you are long enough on this list that you should know that

Except (1) I didn't say *H*D*D* trim, and (2) if raid just passes trim 
through to the layer below, THAT'S NOT SUPPORTING TRIM. As far as I'm 
concerned, what happens at the level below is just not relevant!

If raid supports trim, that means it intercepts the trim commands, and 
uses it to keep track of what's being used by the layer above.

In other words, if the filesystem is only using 10% of the disk, 
supporting trim means that raid knows which 10% is being used and only 
bothers syncing that!

Cheers,
Wol
