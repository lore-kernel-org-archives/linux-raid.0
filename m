Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC75BC433F5
	for <linux-raid@archiver.kernel.org>; Sun, 17 Oct 2021 22:02:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B6B0D60FED
	for <linux-raid@archiver.kernel.org>; Sun, 17 Oct 2021 22:02:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344735AbhJQWEi (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sun, 17 Oct 2021 18:04:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242831AbhJQWEh (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sun, 17 Oct 2021 18:04:37 -0400
Received: from hermes.turmel.org (hermes.turmel.org [IPv6:2604:180:f1::1e9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B53EC06161C
        for <linux-raid@vger.kernel.org>; Sun, 17 Oct 2021 15:02:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=turmel.org;
         s=a; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:MIME-Version:Date:
        Message-ID:References:To:From:Subject:Sender:Reply-To:Cc:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=ynBYIa52GwSIaxmSKW0zZtsjFsOxH/Z2LxiDCtx3mZQ=; b=QpVaCziMPcSuJ6FHGyIB26nkG9
        D6Ix3C1KJrBDMhD/SS6UyYtXK5c3jN6SfmfsUZy7NmHVhrUQGi0jIaeHEFrchAtdnUplplKANks9A
        LNGkEWa4yKDle3L9IJNjcchOhodmxrqtmxaDyFaupzbMaqzRZBhg3BiGdi1ohnHJpWUyekcOvGQo1
        A/SqBYcYnEPOHjIuijcJVVXKlKeq0OcWE2sbvPTuW4MbQRNQ+rUIwRcJ+cZmg+G9Gm8gS3Pkpwyn/
        MGthZ9O9Ruh3J0YPuIxK0hsFj44Dw8HKluKByzbMtGsRVTXSn3IJV5gEFHxZ1SDdkI0IwGhAKAVI+
        DjC6meIw==;
Received: from c-73-43-58-214.hsd1.ga.comcast.net ([73.43.58.214] helo=[192.168.20.123])
        by hermes.turmel.org with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.90_1)
        (envelope-from <philip@turmel.org>)
        id 1mcEEb-0002Jv-8A; Sun, 17 Oct 2021 22:02:25 +0000
Subject: Re: RAID5 - can't assemble array of 5
From:   Phil Turmel <philip@turmel.org>
To:     Romulo Albuquerque <romulo.albuquerque@gmail.com>,
        linux-raid@vger.kernel.org
References: <CACKE2TBmcQ12tyujnWzPUGCM6fYjzcUhFgmZQCT2usBAHb6MmQ@mail.gmail.com>
 <4f36271f-7355-9aea-6634-51c8d62d05a4@turmel.org>
Message-ID: <16537ec0-1737-f0ae-5fb1-7c64bce8c5df@turmel.org>
Date:   Sun, 17 Oct 2021 18:02:24 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <4f36271f-7355-9aea-6634-51c8d62d05a4@turmel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Shoot, my brain is fried. Three months, not two. /:

On 10/17/21 9:21 AM, Phil Turmel wrote:
> Hi Romulo,
> 
> On 10/16/21 9:11 PM, Romulo Albuquerque wrote:
>> Hi All,
>>
>> I've 5 disks array 3TB each, but one of the disks /dev/sdb can't be 
>> recognized.
>> Using mdadm - v3.4 - 28th January 2016 on Debian GNU/Linux 9.11 
>> (stretch).
>>
>> So, I tried to assemble the array with 4 disks, but it didn't work, 
>> see below >
>> sudo mdadm --assemble --verbose /dev/md0 /dev/sd[acde]
>> mdadm: looking for devices for /dev/md0
>> mdadm: /dev/sda is identified as a member of /dev/md0, slot 0.
>> mdadm: /dev/sdc is identified as a member of /dev/md0, slot 2.
>> mdadm: /dev/sdd is identified as a member of /dev/md0, slot 3.
>> mdadm: /dev/sde is identified as a member of /dev/md0, slot 4.
>> mdadm: ignoring /dev/sdc as it reports /dev/sda as failed
>> mdadm: ignoring /dev/sdd as it reports /dev/sda as failed
>> mdadm: ignoring /dev/sde as it reports /dev/sda as failed
>> mdadm: no uptodate device for slot 1 of /dev/md0
>> mdadm: no uptodate device for slot 2 of /dev/md0
>> mdadm: no uptodate device for slot 3 of /dev/md0
>> mdadm: no uptodate device for slot 4 of /dev/md0
>> mdadm: added /dev/sda to /dev/md0 as 0
>> mdadm: /dev/md0 assembled from 1 drive - not enough to start the array.
> 
> [trim /]
> 
> This didn't work because /dev/sda dropped out of your array back in the 
> middle of July.  You were running degraded for two months before 
> /dev/sdb dropped out.
> 
> If /dev/sdb is totally dead, you will have to use a two-month-old device 
> to revive your array, with data corruption for anything written in the 
> past two months.  Add a --force to your assemble command to do so.
> 
> I recommend trying harder to recover /dev/sdb onto another device.  Then 
> assemble that replacement with the other three, leaving out /dev/sda. 
> Also using --force.
> 
> Finally, investigate why /dev/sda dropped out in July, and why you 
> didn't get an email from mdmon.  (Timeout mismatch for the former, 
> perhaps, and incomplete configuration for the latter, likely.)
> 
> Phil

