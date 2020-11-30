Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9106C5519F
	for <linux-raid@archiver.kernel.org>; Mon, 30 Nov 2020 09:27:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 78EE720809
	for <linux-raid@archiver.kernel.org>; Mon, 30 Nov 2020 09:27:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726729AbgK3J16 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 30 Nov 2020 04:27:58 -0500
Received: from smtp.hosts.co.uk ([85.233.160.19]:18766 "EHLO smtp.hosts.co.uk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725972AbgK3J15 (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Mon, 30 Nov 2020 04:27:57 -0500
Received: from host86-149-69-253.range86-149.btcentralplus.com ([86.149.69.253] helo=[192.168.1.65])
        by smtp.hosts.co.uk with esmtpa (Exim)
        (envelope-from <antlists@youngman.org.uk>)
        id 1kjfSi-0001xd-Cr
        for linux-raid@vger.kernel.org; Mon, 30 Nov 2020 09:27:13 +0000
Subject: =?UTF-8?Q?Re=3a_=e2=80=9croot_account_locked=e2=80=9d_after_removin?=
 =?UTF-8?Q?g_one_RAID1_hard_disc?=
To:     linux-raid@vger.kernel.org
References: <e6b7a61d16a25c433438c670fa4c0b4f@posteo.de>
From:   antlists <antlists@youngman.org.uk>
Message-ID: <bc15926a-8bf4-14ae-bd67-ae14d915d4c0@youngman.org.uk>
Date:   Mon, 30 Nov 2020 09:27:15 +0000
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <e6b7a61d16a25c433438c670fa4c0b4f@posteo.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 30/11/2020 08:44, c.buhtz@posteo.jp wrote:
> X-Post: https://serverfault.com/q/1044339/374973
> 
> I tried this out in a VirtualMachine to hope I can learn something.
> 
> **Problem**
> 
> The RAID1 does not containt any systmem relevant data - the OS is on 
> another drive. My Debian 10 does not boot anymore and tells me that I am 
> in emergency mode and "Cannot open access to console, the root account 
> is locked.". I removed one of the two RAID1 devices before.

I don't think this is specific to raid ...
> 
> And systemd tells me while booting "A start job is running for /dev/md127".
> 
> **Details***
> 
> The virtual machine contains three hard disks. /dev/sda1 use the full 
> size of the disc and containts the Debian 10. /dev/sdb and /dev/sdc (as 
> discs without partitions) are configured as RAID1 /dev/md127 and 
> formated with ext4 and mounted to /Daten. I can read and write without 
> any problems to the RAID.
> 
> I regualr shutdown and then removed /dev/sdc. After that the system does 
> not boot anymore and shows me the error about the locked root account.
> 
> **Question 1**
> 
> Why is the system so sensible about one RAID device that does not 
> contain essential data for the boot process. I would I understand if 
> there is a error messages somewhere. But blocking the whole boot process 
> is to much in my understanding.

It's not. It's sensitive to the fact that ANY disk is missing.
> 
> **Question 2**
> 
> I read that a single RAID1 device (the second is missing) can be 
> accessed without any problems. How can I do that?

When a component of a raid disappears without warning, the raid will 
refuse to assemble properly on next boot. You need to get at a command 
line and force-assemble it.
> 
> **More details**
> 
> Here is the output of my fdisk -l. Interesting here is that /dv/md127 is 
> shown but without its filesysxtem.
> 
>> Disk /dev/sda: 128 GiB, 137438953472 bytes, 268435456 sectors
>> Disk model: VBOX HARDDISK
>> Disklabel type: dos
>> Disk identifier: 0xe3add51d
>>
>> Device     Boot Start       End   Sectors  Size Id Type
>> /dev/sda1  *     2048 266338303 266336256  127G 83 Linux
>>
>>
>> Disk /dev/sdb: 8 GiB, 8589934592 bytes, 16777216 sectors
>> Disk model: VBOX HARDDISK
>>
>> Disk /dev/sdc: 8 GiB, 8589934592 bytes, 16777216 sectors
>> Disk model: VBOX HARDDISK
>>
>> Disk /dev/md127: 8 GiB, 8580497408 bytes, 16758784 sectors
>> Units: sectors of 1 * 512 = 512 bytes
>> Sector size (logical/physical): 512 bytes / 512 bytes
>> I/O size (minimum/optimal): 512 bytes / 512 bytes
> 
> Here is mount output:
> 
>> sysfs on /sys type sysfs (rw,nosuid,nodev,noexec,relatime)
>> /dev/sda1 on / type ext4 (rw,relatime,errors=remount-ro)
>> /dev/md127 on /Daten type ext4 (rw,relatime)

And here is at least part of your problem. If the mount fails, systemd 
will halt and chuck you into a recovery console. I had exactly the same 
problem with an NTFS partition on a dual-boot system.
> 
> This is /etc/fstab:
> 
>> # <file system> <mount point>   <type>  <options>       <dump>  <pass>
>> # / was on /dev/sda1 during installation
>> UUID=65ec95df-f83f-454e-b7bd-7008d8055d23 /               ext4 
>> errors=remount-ro 0       1
>>
>> /dev/md127  /Daten      ext4    defaults    0   0
> 
> 
Is root's home on /Daten? It shouldn't be.

Cheers,
Wol
