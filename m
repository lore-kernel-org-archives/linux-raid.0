Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F9C8C61DA4
	for <linux-raid@archiver.kernel.org>; Fri,  3 Mar 2023 23:05:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233068AbjCCXFx (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 3 Mar 2023 18:05:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233396AbjCCXFj (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 3 Mar 2023 18:05:39 -0500
X-Greylist: delayed 1475 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 03 Mar 2023 15:05:22 PST
Received: from mail.mifritscher.de (mifritscher.de [188.40.170.105])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E564EB46
        for <linux-raid@vger.kernel.org>; Fri,  3 Mar 2023 15:05:22 -0800 (PST)
Received: from localhost (localhost.localdomain [127.0.0.1])
        by mail.mifritscher.de (Postfix) with ESMTP id 896693AB370;
        Fri,  3 Mar 2023 23:39:27 +0100 (CET)
X-Virus-Scanned: Debian amavisd-new at mifritscher.vserverkompetenz.de
Received: from mail.mifritscher.de ([127.0.0.1])
        by localhost (mail.mifritscher.vserverkompetenz.de [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id rODCEFyH-Uiw; Fri,  3 Mar 2023 23:39:26 +0100 (CET)
Received: from [192.168.99.235] (ppp-93-104-110-173.dynamic.mnet-online.de [93.104.110.173])
        by mail.mifritscher.de (Postfix) with ESMTPSA id B4EA63A1D97;
        Fri,  3 Mar 2023 23:39:26 +0100 (CET)
Message-ID: <d78d528f-d0fa-c04c-6bdd-0b48fc159671@fritscher.net>
Date:   Fri, 3 Mar 2023 23:39:26 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: Why isn't the "Support Intel AHCI remapped NVMe devices" in
 mainline?
Content-Language: de-DE
To:     "David F." <df7729@gmail.com>, Andrew R <junkbustr@gmail.com>
Cc:     "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
References: <CAGRSmLsh0aqJMuFzMMhm6fYjsCL-MNXR=t04cGj9FNvG0EENTQ@mail.gmail.com>
 <CAB-xnyD+iWsbuemirPyHqEG9DnbBb1unjj6D-21ZmBbjp9eAmA@mail.gmail.com>
 <CAGRSmLs1nVWHVEv5FXzDCbsC7otzsVr_HceXXruKDO228zM5Eg@mail.gmail.com>
From:   Michael Fritscher <michael@fritscher.net>
In-Reply-To: <CAGRSmLs1nVWHVEv5FXzDCbsC7otzsVr_HceXXruKDO228zM5Eg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Good evening,

you mean https://lkml.org/lkml/2019/6/20/27 /
https://lore.kernel.org/linux-pci/20190620061038.GA20564@lst.de/T/ ,
right? And yes, I have this problem as well. On a Toshiba z20t-c, and
this device has no option to switch this off. And even if has, there is
the problem that this device has no "normal" NVMe driver in the uefi it
seems, so it could not boot from...

Best regards,
Michael Fritscher

Am 31.12.19 um 18:26 schrieb David F.:
> Was actually referring to the "Intel AHCI remapped NVMe devices Patch"
> that exists but now out of date because of updates to NVMe/PCI driver.
> The latest was based on 5.2 I believe.
> 
> On Sun, Dec 15, 2019 at 7:57 AM Andrew R <junkbustr@gmail.com> wrote:
>>
>>
>> On Fri, Dec 13, 2019, 20:15 David F. <df7729@gmail.com> wrote:
>>>
>>> Hi,
>>>
>>> Despite not liking what Intel did, there isn't any reason Linux
>>> shouldn't support these devices in RAID mode..   The main support
>>> issues with our Linux based product is now this problem with no hard
>>> drives listed in Linux.   Get a couple everyday.  Some people can't
>>> change to AHCI mode, such as some Lenovo machines.
>>>
>>> If the patch simply adds support for this mode without affecting
>>> anything when not in that mode then why wouldn't you mainline it?
>>> This problem is widespread.
>>>
>>> TIA
>>
>>
>> Not sure if this is your issue, but had a similar issue with an HP machine that I bought with mirrored 512gb NVME drives configured from the factory. They were configured with the Intel Rapidstore embedded raid on the motherboard. In this configuration, the drives are not detected by the kernel.
>>
>> I had to go into the RAID configuration menu in the bios and release the drives from the raid (deleting Windows) at which point Linux could see the drives.
>>
>> In my particular case I was not installing Linux on this machine but was using Linux to create image backups of the Windows install using imaging tools from the Clonezilla distro.
>>
>> After destroying the RAID, I used the HP system recovery to create a base install and then setup drive mirroring in Windows Disk Manager (*not* Storage Spaces!). NB this requires Windows Professional...
>>
>> HTH.

