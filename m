Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42732C54E94
	for <linux-raid@archiver.kernel.org>; Mon, 23 Jan 2023 04:24:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231302AbjAWEYG (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sun, 22 Jan 2023 23:24:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230168AbjAWEYE (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sun, 22 Jan 2023 23:24:04 -0500
X-Greylist: delayed 2379 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sun, 22 Jan 2023 20:24:02 PST
Received: from ns3.fnarfbargle.com (ns3.fnarfbargle.com [103.4.19.87])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FC021042A
        for <linux-raid@vger.kernel.org>; Sun, 22 Jan 2023 20:24:02 -0800 (PST)
Received: from [10.8.0.1] (helo=srv.home)
        by ns3.fnarfbargle.com with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <lists2009@fnarfbargle.com>)
        id 1pJnko-000144-A0; Mon, 23 Jan 2023 13:44:18 +1000
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=fnarfbargle.com; s=mail; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:From:References:To:Subject:MIME-Version:Date:Message-ID:Sender:
        Reply-To:Cc:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=Q9C308uCyaEfyeroxdILom36r3V8Fbs3reh4HuwCftk=; b=s2wdsBaXgZO/iSKoZ1wv50puIP
        HDKC+sTLXxldU9G5deIhBXI/C9HqDIi/yuUyORhSqvvOzRLEeHrqaJ4C488BllzQKfBRMlPd5W8H2
        u+WeMLpH94wpykBLbci0r6HBMao6Rgf2iGVkSFMQdiCsxdKllqQU81zmpFlL2iV7Xgec=;
Message-ID: <112ee700-9111-0e5f-29d5-150255be874f@fnarfbargle.com>
Date:   Mon, 23 Jan 2023 11:44:17 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.1
Subject: Re: Transferring an existing system from non-RAID disks to RAID1
 disks in the same computer
Content-Language: en-AU
To:     H <agents@meddatainc.com>,
        Linux RAID Mailing List <linux-raid@vger.kernel.org>
References: <273d1fc9-853f-a8fa-bb47-2883ba217820@meddatainc.com>
 <deafcb4a-ed1c-d0b3-c9f9-c0a99867bb7a@meddatainc.com>
 <3CEAC9AB-02FC-43BE-94CF-ED3ECFF6F4F7@meddatainc.com>
From:   Brad Campbell <lists2009@fnarfbargle.com>
In-Reply-To: <3CEAC9AB-02FC-43BE-94CF-ED3ECFF6F4F7@meddatainc.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 22/1/23 13:05, H wrote:

> I am happy to share that my plan as outlined below worked. I now have /boot, /boot/efi and / on separate RAID partitions with the latter managed by LVM and encrypted.  All data from the old disk is now on the new setup and everything seems to be working.
> 
> However, going back to the issue of /boot/efi possibly not being duplicated by CentOS, would not mdadm take care of that automatically? How can I check?
> 


Well, this one has sparked a bit of an argument.

I do the same. /boot and EFI are on RAID-1 0.90 partitions (ext4 and FAT32 respectively) and everything else is encrypted.

I use rEFInd as a bootloader. It *can* write to the EFI partition to record preferences and settings which can see the RAID out of sync, but it's rare I see that.
In practice this doesn't cause an issue and if the monthly raid check indicates a mismatch I just correct it with a "repair".

In my case the RAID for EFI is for availability.
If I drop a disk the system will still boot regardless of the settings in the partition, and as rEFInd reads its config file from /boot there is no need to write to EFI at all save for upgrading the bootloader.

Regards,
Brad
