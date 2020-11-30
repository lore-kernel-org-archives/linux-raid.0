Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17CDCC5519F
	for <linux-raid@archiver.kernel.org>; Mon, 30 Nov 2020 08:46:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 08FD02076E
	for <linux-raid@archiver.kernel.org>; Mon, 30 Nov 2020 08:46:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=posteo.jp header.i=@posteo.jp header.b="MtRteo3q"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727266AbgK3Ipc (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 30 Nov 2020 03:45:32 -0500
Received: from mout01.posteo.de ([185.67.36.65]:51120 "EHLO mout01.posteo.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726298AbgK3Ipc (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Mon, 30 Nov 2020 03:45:32 -0500
Received: from submission (posteo.de [89.146.220.130]) 
        by mout01.posteo.de (Postfix) with ESMTPS id 962DF160061
        for <linux-raid@vger.kernel.org>; Mon, 30 Nov 2020 09:44:34 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=posteo.jp; s=2017;
        t=1606725874; bh=SUo1PPOMTvsFgVguDcSOiX/1cJEZ9eEVb2oenL20J1I=;
        h=Date:From:To:Subject:From;
        b=MtRteo3qTsjlonxMh+VKxYEytNR/lO7QaxYc/whXkcH74bPNx6P+no2Tgz3NyRZ8/
         vTtzg6pvDFMPi8jiWfMaKdCnPo0NX1+0DmauS9zEmtP4RplwVavAOFSMDsaSMmXMML
         +lnurPTpoDTFC/Qn5p8r3/DT7UYFwZtS/mWHJlk1vTYVETnmo/fOl50lJvQxV/VvT0
         ChVEZrZHWrKPX8NZo46k+Nb3BKozjSPt8bWG0XVdgYu/ykwByyfcT9S27TVRGM2wMr
         I7DC1qi3Hw3xRnBLskzzfl4Gtg+rItjOlssT+r6P7W0nQN9dPMXo8U4hVcbuJ7N8Ue
         vwRk3D5yTBIRg==
Received: from customer (localhost [127.0.0.1])
        by submission (posteo.de) with ESMTPSA id 4CkzLV0Htwz9rxT
        for <linux-raid@vger.kernel.org>; Mon, 30 Nov 2020 09:44:33 +0100 (CET)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Mon, 30 Nov 2020 09:44:33 +0100
From:   c.buhtz@posteo.jp
To:     linux-raid@vger.kernel.org
Subject: =?UTF-8?Q?=E2=80=9Croot=20account=20locked=E2=80=9D=20after=20rem?=
 =?UTF-8?Q?oving=20one=20RAID=31=20hard=20disc?=
Mail-Followup-To: linux-raid@vger.kernel.org
Message-ID: <e6b7a61d16a25c433438c670fa4c0b4f@posteo.de>
X-Sender: c.buhtz@posteo.jp
User-Agent: Posteo Webmail
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

X-Post: https://serverfault.com/q/1044339/374973

I tried this out in a VirtualMachine to hope I can learn something.

**Problem**

The RAID1 does not containt any systmem relevant data - the OS is on 
another drive. My Debian 10 does not boot anymore and tells me that I am 
in emergency mode and "Cannot open access to console, the root account 
is locked.". I removed one of the two RAID1 devices before.

And systemd tells me while booting "A start job is running for 
/dev/md127".

**Details***

The virtual machine contains three hard disks. /dev/sda1 use the full 
size of the disc and containts the Debian 10. /dev/sdb and /dev/sdc (as 
discs without partitions) are configured as RAID1 /dev/md127 and 
formated with ext4 and mounted to /Daten. I can read and write without 
any problems to the RAID.

I regualr shutdown and then removed /dev/sdc. After that the system does 
not boot anymore and shows me the error about the locked root account.

**Question 1**

Why is the system so sensible about one RAID device that does not 
contain essential data for the boot process. I would I understand if 
there is a error messages somewhere. But blocking the whole boot process 
is to much in my understanding.

**Question 2**

I read that a single RAID1 device (the second is missing) can be 
accessed without any problems. How can I do that?

**More details**

Here is the output of my fdisk -l. Interesting here is that /dv/md127 is 
shown but without its filesysxtem.

> Disk /dev/sda: 128 GiB, 137438953472 bytes, 268435456 sectors
> Disk model: VBOX HARDDISK
> Disklabel type: dos
> Disk identifier: 0xe3add51d
> 
> Device     Boot Start       End   Sectors  Size Id Type
> /dev/sda1  *     2048 266338303 266336256  127G 83 Linux
> 
> 
> Disk /dev/sdb: 8 GiB, 8589934592 bytes, 16777216 sectors
> Disk model: VBOX HARDDISK
> 
> Disk /dev/sdc: 8 GiB, 8589934592 bytes, 16777216 sectors
> Disk model: VBOX HARDDISK
> 
> Disk /dev/md127: 8 GiB, 8580497408 bytes, 16758784 sectors
> Units: sectors of 1 * 512 = 512 bytes
> Sector size (logical/physical): 512 bytes / 512 bytes
> I/O size (minimum/optimal): 512 bytes / 512 bytes

Here is mount output:

> sysfs on /sys type sysfs (rw,nosuid,nodev,noexec,relatime)
> /dev/sda1 on / type ext4 (rw,relatime,errors=remount-ro)
> /dev/md127 on /Daten type ext4 (rw,relatime)

This is /etc/fstab:

> # <file system> <mount point>   <type>  <options>       <dump>  <pass>
> # / was on /dev/sda1 during installation
> UUID=65ec95df-f83f-454e-b7bd-7008d8055d23 /               ext4    
> errors=remount-ro 0       1
> 
> /dev/md127  /Daten      ext4    defaults    0   0


