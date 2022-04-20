Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61497C433F5
	for <linux-raid@archiver.kernel.org>; Wed, 20 Apr 2022 12:07:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345710AbiDTMKi (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 20 Apr 2022 08:10:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352716AbiDTMKh (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 20 Apr 2022 08:10:37 -0400
Received: from mallaury.nerim.net (smtp-103-wednesday.noc.nerim.net [178.132.17.103])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 726A527FDF
        for <linux-raid@vger.kernel.org>; Wed, 20 Apr 2022 05:07:48 -0700 (PDT)
Received: from [192.168.0.252] (plouf.fr.eu.org [213.41.155.166])
        by mallaury.nerim.net (Postfix) with ESMTP id DF896DB17C;
        Wed, 20 Apr 2022 14:07:45 +0200 (CEST)
Message-ID: <11e5dc60-1c00-4cfa-8b4e-ab0839a5fd9f@plouf.fr.eu.org>
Date:   Wed, 20 Apr 2022 14:07:43 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: Need to move RAID1 with mounted partition
Content-Language: en-US
To:     Linux RAID <linux-raid@vger.kernel.org>,
        Leslie Rhorer <lesrhorer@att.net>
References: <CAKRnqN+_=U58dT5bvgWJ1DgyEuhjsbmCuDL+xOLxmcuG1ML4qg@mail.gmail.com>
 <e3573002-05f3-3110-62a6-e704385f877f@youngman.org.uk>
 <CAKRnqNLjsX9nVLrLedo4tfxtg0ZBz=6XJu=-z_Ebw6Auh+oz-Q@mail.gmail.com>
 <8c2148d0-fa97-d0ef-10cc-11f79d7da5e5@youngman.org.uk>
 <CAKRnqN+21BZT1eufn962xiEDvnrBtk68dTBSLT1mx7+Ac2kJ+w@mail.gmail.com>
 <CAKRnqN+6wAFPf5AGNEf948NunA97MJ9Gy5eFzLCfX+WfHY72Pg@mail.gmail.com>
 <b5c0e119-0159-8566-1c6e-6d13b65b2f89@att.net>
 <20220420110810.x2ydoqhyeuocnrwy@bitfolk.com>
From:   Pascal Hambourg <pascal@plouf.fr.eu.org>
Organization: Plouf !
In-Reply-To: <20220420110810.x2ydoqhyeuocnrwy@bitfolk.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Le 20/04/2022 à 13:08, Andy Smith wrote:
> 
> On Wed, Apr 20, 2022 at 03:40:12AM -0500, Leslie Rhorer wrote:
>> The third partition on each drive is assigned as swap, and of
>> course it was easy to resize those partitions, leaving an
>> additional 512MB between the second and third partitions on each
>> drive.  All I need to do is move the second partition on each
>> drive up by 512MB.
> 
> I'd be tempted to just make these two new 512M spaces into new
> partitions for a RAID-1 and move your /boot to that, abandoning the
> RAID-1 you have for the /boot that is using the partitions at the
> start of the disk.

I agree, unless the BIOS cannot read sectors at that offset.

Or you could create a RAID10 array with the 4 partitions if they have 
similar sizes.

Or you could move /boot back into the / filesystem.

In either case, the BIOS restriction applies and you may need to 
reinstall the boot loader on both drives.

Or you could try to reduce the required space in /boot :
- remove old kernels
- reduce initramfs size with MODULES=dep instead of MODULES=most in 
/etc/initramfs-tools/initramfs.conf
- remove plymouth if installed

> You could do away with the swap partitions entirely and use swap
> files instead.

Swap files are an ugly hack and not all filesystems support them.
