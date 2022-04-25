Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A06DC433F5
	for <linux-raid@archiver.kernel.org>; Mon, 25 Apr 2022 14:57:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242533AbiDYPAa (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 25 Apr 2022 11:00:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235655AbiDYPA3 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 25 Apr 2022 11:00:29 -0400
Received: from mail.stoffel.org (li1843-175.members.linode.com [172.104.24.175])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2520E48396
        for <linux-raid@vger.kernel.org>; Mon, 25 Apr 2022 07:57:24 -0700 (PDT)
Received: from quad.stoffel.org (068-116-170-226.res.spectrum.com [68.116.170.226])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.stoffel.org (Postfix) with ESMTPSA id 552F229E7B;
        Mon, 25 Apr 2022 10:57:23 -0400 (EDT)
Received: by quad.stoffel.org (Postfix, from userid 1000)
        id 9D0ADA7B3D; Mon, 25 Apr 2022 10:57:22 -0400 (EDT)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <25190.46802.519914.353774@quad.stoffel.home>
Date:   Mon, 25 Apr 2022 10:57:22 -0400
From:   "John Stoffel" <john@stoffel.org>
To:     Turritopsis Dohrnii Teo En Ming <teo.en.ming@protonmail.com>
Cc:     John Stoffel <john@stoffel.org>,
        "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>,
        "ceo@teo-en-ming-corp.com" <ceo@teo-en-ming-corp.com>
Subject: Re: arcconf Linux utility for Adaptec AAC-RAID (Rocket) (rev 02) (IBM ServeRAID 8k/8k-l8) unable to query RAID controller
In-Reply-To: <BI8tpiYl62HTeDCz8Bge5mtCTJsyLb3NVNl2W69b6WKm2OSMg6_bUnJroS3ttUFAhT4gxLP36lvRJH0180JbvfB3JVKtXf1JEkLJ5THdcHU=@protonmail.com>
References: <iddAq1G1O5s0ZaXiG770cpphw7qFQJvJxEpC9C6KNBOPlTh3tisL-yqiUeWxokp-rHBqFCovWBDJdDea1B48qzcD1YCeipV3M7sKtGiX21o=@protonmail.com>
        <25189.52847.196112.389335@quad.stoffel.home>
        <BI8tpiYl62HTeDCz8Bge5mtCTJsyLb3NVNl2W69b6WKm2OSMg6_bUnJroS3ttUFAhT4gxLP36lvRJH0180JbvfB3JVKtXf1JEkLJ5THdcHU=@protonmail.com>
X-Mailer: VM 8.2.0b under 27.1 (x86_64-pc-linux-gnu)
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org


Turritopsis> I have executed the following command on my client's
Turritopsis> CentOS 6.10 32-bit Linux server.

Turritopsis> # badblocks -sv /dev/sda

Turritopsis> And found 512 bad blocks.

Yup, you've got a bad array, either one or more disks is going bad.
You need to backup this data ASAP to another disk somewhere else, so
you can then work on repairing or replacing the bad disk in the RAID
array.

Since you say it's RAID5, and only three disks, you don't have much
redundancy, and because you're seeing bad blocks at the level of the
array (not the inidividual disks) then I think it's only a matter of
time before you lose data.

I also strongly encourage you to change the setup of the system to not
use a hardware based RAID controller.  As you can see now, when you
start having problems, unless you have the right vendor tools, then
you might not have any support to make figuring out what has gone
wrong.

Go look at this web page, it might be helpful for you.

https://www.cyberciti.biz/faq/linux-checking-sas-sata-disks-behind-adaptec-raid-controllers/

Or this might help:

https://storage.microsemi.com/en-us/downloads/storage_manager/sm/productid=aar-2820sa&dn=adaptec+serial+ata+ii+raid+2820sa.html

Good luck!
John


Turritopsis> ------- Original Message -------
Turritopsis> On Monday, April 25th, 2022 at 6:25 AM, John Stoffel <john@stoffel.org> wrote:


>> > > > > > "Turritopsis" == Turritopsis Dohrnii Teo En Ming teo.en.ming@protonmail.com writes:
>> 
>> 
Turritopsis> Subject: arcconf Linux utility for Adaptec AAC-RAID
>> 
Turritopsis> (Rocket) (rev 02) (IBM ServeRAID 8k/8k-l8) unable to
>> 
Turritopsis> query RAID controller Good day from Singapore,
>> 
>> 
Turritopsis> Our client has IBM System x3650 server (machine type:
>> 
Turritopsis> 7979). Operating system is CentOS Linux 6.10 (32-bit).
>> 
>> 
>> Ancient... you're running old mdadm code and kernel... and if it's
>> critical enough, you could/might be able to get support from Redhat if
>> you pay them enough... and since it's a hardware RAID controller card,
>> mdadm and Linux Raid isn't doing anything here, so we're really the
>> wrong group to ask for help. But see below...
>> 
Turritopsis> Recently we keep getting the following error messages
>> 
Turritopsis> (output generated by dmesg).
>> 
>> 
>> These errors look to be a bad sector on one of the disks. But since
>> you're also using a hardware RAID controller... I would copy your data
>> off ASAP onto some new media before you lose any thing more.
>> 
>> Just ask them how much it will cost to keep the business running if
>> they complain about the cost of three replacement disks on the
>> system.
>> 
>> But basically, I would:
>> 
>> 0. copy the data somewhere else, especially if it's critical
>> 1. copy the data somewhere else, especially if it's critical.
>> 2. Try running 'badblocks' on /dev/sda to see if you can force it to
>> re-write bad sectors. See man page for flags to use.
>> 3. You can also try to boot the system to the BIOS and see if there's
>> a BIOS screen for the AAC-RAID controller which lets you scrub the
>> array or look for bad blocks.
>> 
>> Good luck,
>> John
>> 
Turritopsis> <CODE>
>> 
>> 
Turritopsis> sd 0:0:0:0: [sda] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
>> 
Turritopsis> sd 0:0:0:0: [sda] Sense Key : Hardware Error [current]
>> 
Turritopsis> sd 0:0:0:0: [sda] Add. Sense: Internal target failure
>> 
Turritopsis> sd 0:0:0:0: [sda] CDB: Write(10): 2a 00 09 2a d1 50 00 02 00 00
>> 
Turritopsis> end_request: critical target error, dev sda, sector 153801040
>> 
Turritopsis> sd 0:0:0:0: [sda] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
>> 
Turritopsis> sd 0:0:0:0: [sda] Sense Key : Hardware Error [current]
>> 
Turritopsis> sd 0:0:0:0: [sda] Add. Sense: Internal target failure
>> 
Turritopsis> sd 0:0:0:0: [sda] CDB: Write(10): 2a 00 09 2a cf 50 00 02 00 00
>> 
Turritopsis> end_request: critical target error, dev sda, sector 153800528
>> 
Turritopsis> sd 0:0:0:0: [sda] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
>> 
Turritopsis> sd 0:0:0:0: [sda] Sense Key : Hardware Error [current]
>> 
Turritopsis> sd 0:0:0:0: [sda] Add. Sense: Internal target failure
>> 
Turritopsis> sd 0:0:0:0: [sda] CDB: Write(10): 2a 00 09 2a d3 50 00 02 00 00
>> 
Turritopsis> end_request: critical target error, dev sda, sector 153801552
>> 
Turritopsis> JBD2: Detected IO errors while flushing file data on dm-0-8
>> 
Turritopsis> JBD2: Detected IO errors while flushing file data on dm-0-8
>> 
Turritopsis> JBD2: Detected IO errors while flushing file data on dm-0-8
>> 
Turritopsis> JBD2: Detected IO errors while flushing file data on dm-0-8
>> 
Turritopsis> JBD2: Detected IO errors while flushing file data on dm-0-8
>> 
Turritopsis> JBD2: Detected IO errors while flushing file data on dm-0-8
>> 
Turritopsis> JBD2: Detected IO errors while flushing file data on dm-0-8
>> 
Turritopsis> JBD2: Detected IO errors while flushing file data on dm-0-8
>> 
Turritopsis> JBD2: Detected IO errors while flushing file data on dm-0-8
>> 
Turritopsis> JBD2: Detected IO errors while flushing file data on dm-0-8
>> 
Turritopsis> JBD2: Detected IO errors while flushing file data on dm-0-8
>> 
Turritopsis> JBD2: Detected IO errors while flushing file data on dm-0-8
>> 
Turritopsis> JBD2: Detected IO errors while flushing file data on dm-0-8
>> 
Turritopsis> JBD2: Detected IO errors while flushing file data on dm-0-8
>> 
Turritopsis> sd 0:0:0:0: [sda] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
>> 
Turritopsis> sd 0:0:0:0: [sda] Sense Key : Hardware Error [current]
>> 
Turritopsis> sd 0:0:0:0: [sda] Add. Sense: Internal target failure
>> 
Turritopsis> sd 0:0:0:0: [sda] CDB: Read(10): 28 00 09 2a cf 38 00 01 00 00
>> 
Turritopsis> end_request: critical target error, dev sda, sector 153800504
>> 
Turritopsis> sd 0:0:0:0: [sda] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
>> 
Turritopsis> sd 0:0:0:0: [sda] Sense Key : Hardware Error [current]
>> 
Turritopsis> sd 0:0:0:0: [sda] Add. Sense: Internal target failure
>> 
Turritopsis> sd 0:0:0:0: [sda] CDB: Read(10): 28 00 09 2a d0 38 00 01 00 00
>> 
Turritopsis> end_request: critical target error, dev sda, sector 153800760
>> 
Turritopsis> sd 0:0:0:0: [sda] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
>> 
Turritopsis> sd 0:0:0:0: [sda] Sense Key : Hardware Error [current]
>> 
Turritopsis> sd 0:0:0:0: [sda] Add. Sense: Internal target failure
>> 
Turritopsis> sd 0:0:0:0: [sda] CDB: Read(10): 28 00 09 2a d0 00 00 00 08 00
>> 
Turritopsis> end_request: critical target error, dev sda, sector 153800704
>> 
>> 
Turritopsis> </CODE>
>> 
>> 
Turritopsis> /dev/sda is a RAID 5 array with 3 harddisks of 136.6 GB capacity each.
>> 
>> 
Turritopsis> <CODE>
>> 
>> 
Turritopsis> [root@teo-en-ming-server ~]# fdisk /dev/sda
>> 
>> 
Turritopsis> WARNING: DOS-compatible mode is deprecated. It's strongly recommended to
>> 
Turritopsis> switch off the mode (command 'c') and change display units to
>> 
Turritopsis> sectors (command 'u').
>> 
>> 
Turritopsis> Command (m for help): p
>> 
>> 
Turritopsis> Disk /dev/sda: 293.4 GB, 293378981888 bytes
>> 
Turritopsis> 255 heads, 63 sectors/track, 35667 cylinders
>> 
Turritopsis> Units = cylinders of 16065 * 512 = 8225280 bytes
>> 
Turritopsis> Sector size (logical/physical): 512 bytes / 512 bytes
>> 
Turritopsis> I/O size (minimum/optimal): 512 bytes / 512 bytes
>> 
Turritopsis> Disk identifier: 0x8b047782
>> 
>> 
Turritopsis> Device Boot Start End Blocks Id System
>> 
Turritopsis> /dev/sda1 * 1 64 512000 83 Linux
>> 
Turritopsis> Partition 1 does not end on cylinder boundary.
>> 
Turritopsis> /dev/sda2 64 35668 285989888 8e Linux LVM
>> 
>> 
Turritopsis> Command (m for help):
>> 
>> 
Turritopsis> </CODE>
>> 
>> 
Turritopsis> We rebooted the server several times. The next morning we still get the same error messages.
>> 
>> 
Turritopsis> <CODE>
>> 
>> 
Turritopsis> sd 0:0:0:0: [sda] 573005824 512-byte logical blocks: (293 GB/273 GiB)
>> 
Turritopsis> sd 0:0:0:0: [sda] Write Protect is off
>> 
Turritopsis> sd 0:0:0:0: [sda] Mode Sense: 06 00 10 00
>> 
Turritopsis> sd 0:0:0:0: [sda] Write cache: disabled, read cache: enabled, supports DPO and FUA
>> 
Turritopsis> sda: sda1 sda2
>> 
Turritopsis> sd 0:0:0:0: [sda] Attached SCSI removable disk
>> 
Turritopsis> dracut: Scanning devices sda2 for LVM logical volumes vg_teo-en-ming-server/lv_swap vg_teo-en-ming-server/lv_root
>> 
Turritopsis> EXT4-fs (sda1): mounted filesystem with ordered data mode. Opts:
>> 
Turritopsis> SELinux: initialized (dev sda1, type ext4), uses xattr
>> 
Turritopsis> sd 0:0:0:0: [sda] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
>> 
Turritopsis> sd 0:0:0:0: [sda] Sense Key : Hardware Error [current]
>> 
Turritopsis> sd 0:0:0:0: [sda] Add. Sense: Internal target failure
>> 
Turritopsis> sd 0:0:0:0: [sda] CDB: Read(10): 28 00 09 2a d0 00 00 00 80 00
>> 
Turritopsis> end_request: critical target error, dev sda, sector 153800704
>> 
Turritopsis> sd 0:0:0:0: [sda] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
>> 
Turritopsis> sd 0:0:0:0: [sda] Sense Key : Hardware Error [current]
>> 
Turritopsis> sd 0:0:0:0: [sda] Add. Sense: Internal target failure
>> 
Turritopsis> sd 0:0:0:0: [sda] CDB: Read(10): 28 00 09 2a d0 00 00 00 08 00
>> 
Turritopsis> end_request: critical target error, dev sda, sector 153800704
>> 
Turritopsis> Buffer I/O error on device sda, logical block 19225088
>> 
Turritopsis> sd 0:0:0:0: [sda] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
>> 
Turritopsis> sd 0:0:0:0: [sda] Sense Key : Hardware Error [current]
>> 
Turritopsis> sd 0:0:0:0: [sda] Add. Sense: Internal target failure
>> 
Turritopsis> sd 0:0:0:0: [sda] CDB: Read(10): 28 00 09 2a d0 00 00 00 08 00
>> 
Turritopsis> end_request: critical target error, dev sda, sector 153800704
>> 
Turritopsis> Buffer I/O error on device sda, logical block 19225088
>> 
Turritopsis> sd 0:0:0:0: [sda] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
>> 
Turritopsis> sd 0:0:0:0: [sda] Sense Key : Hardware Error [current]
>> 
Turritopsis> sd 0:0:0:0: [sda] Add. Sense: Internal target failure
>> 
Turritopsis> sd 0:0:0:0: [sda] CDB: Read(10): 28 00 09 2a d0 00 00 00 08 00
>> 
Turritopsis> end_request: critical target error, dev sda, sector 153800704
>> 
Turritopsis> Buffer I/O error on device sda, logical block 19225088
>> 
Turritopsis> sd 0:0:0:0: [sda] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
>> 
Turritopsis> sd 0:0:0:0: [sda] Sense Key : Hardware Error [current]
>> 
Turritopsis> sd 0:0:0:0: [sda] Add. Sense: Internal target failure
>> 
Turritopsis> sd 0:0:0:0: [sda] CDB: Read(10): 28 00 09 2a d0 00 00 00 08 00
>> 
Turritopsis> end_request: critical target error, dev sda, sector 153800704
>> 
Turritopsis> Buffer I/O error on device sda, logical block 19225088
>> 
Turritopsis> sd 0:0:0:0: [sda] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
>> 
Turritopsis> sd 0:0:0:0: [sda] Sense Key : Hardware Error [current]
>> 
Turritopsis> sd 0:0:0:0: [sda] Add. Sense: Internal target failure
>> 
Turritopsis> sd 0:0:0:0: [sda] CDB: Read(10): 28 00 09 2a d0 08 00 00 08 00
>> 
Turritopsis> end_request: critical target error, dev sda, sector 153800712
>> 
Turritopsis> Buffer I/O error on device sda, logical block 19225089
>> 
Turritopsis> sd 0:0:0:0: [sda] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
>> 
Turritopsis> sd 0:0:0:0: [sda] Sense Key : Hardware Error [current]
>> 
Turritopsis> sd 0:0:0:0: [sda] Add. Sense: Internal target failure
>> 
Turritopsis> sd 0:0:0:0: [sda] CDB: Read(10): 28 00 09 2a d0 08 00 00 08 00
>> 
Turritopsis> end_request: critical target error, dev sda, sector 153800712
>> 
Turritopsis> Buffer I/O error on device sda, logical block 19225089
>> 
Turritopsis> sd 0:0:0:0: [sda] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
>> 
Turritopsis> sd 0:0:0:0: [sda] Sense Key : Hardware Error [current]
>> 
Turritopsis> sd 0:0:0:0: [sda] Add. Sense: Internal target failure
>> 
Turritopsis> sd 0:0:0:0: [sda] CDB: Read(10): 28 00 09 2a d0 08 00 00 08 00
>> 
Turritopsis> end_request: critical target error, dev sda, sector 153800712
>> 
Turritopsis> Buffer I/O error on device sda, logical block 19225089
>> 
Turritopsis> sd 0:0:0:0: [sda] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
>> 
Turritopsis> sd 0:0:0:0: [sda] Sense Key : Hardware Error [current]
>> 
Turritopsis> sd 0:0:0:0: [sda] Add. Sense: Internal target failure
>> 
Turritopsis> sd 0:0:0:0: [sda] CDB: Read(10): 28 00 09 2a d0 08 00 00 08 00
>> 
Turritopsis> end_request: critical target error, dev sda, sector 153800712
>> 
Turritopsis> Buffer I/O error on device sda, logical block 19225089
>> 
Turritopsis> sd 0:0:0:0: [sda] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
>> 
Turritopsis> sd 0:0:0:0: [sda] Sense Key : Hardware Error [current]
>> 
Turritopsis> sd 0:0:0:0: [sda] Add. Sense: Internal target failure
>> 
Turritopsis> sd 0:0:0:0: [sda] CDB: Read(10): 28 00 09 2a d0 10 00 00 08 00
>> 
Turritopsis> end_request: critical target error, dev sda, sector 153800720
>> 
Turritopsis> Buffer I/O error on device sda, logical block 19225090
>> 
Turritopsis> sd 0:0:0:0: [sda] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
>> 
Turritopsis> sd 0:0:0:0: [sda] Sense Key : Hardware Error [current]
>> 
Turritopsis> sd 0:0:0:0: [sda] Add. Sense: Internal target failure
>> 
Turritopsis> sd 0:0:0:0: [sda] CDB: Read(10): 28 00 09 2a d1 10 00 00 08 00
>> 
Turritopsis> end_request: critical target error, dev sda, sector 153800976
>> 
Turritopsis> sd 0:0:0:0: [sda] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
>> 
Turritopsis> sd 0:0:0:0: [sda] Sense Key : Hardware Error [current]
>> 
Turritopsis> sd 0:0:0:0: [sda] Add. Sense: Internal target failure
>> 
Turritopsis> sd 0:0:0:0: [sda] CDB: Read(10): 28 00 09 2a d1 10 00 00 08 00
>> 
Turritopsis> end_request: critical target error, dev sda, sector 153800976
>> 
Turritopsis> Buffer I/O error on device sda, logical block 19225122
>> 
Turritopsis> sd 0:0:0:0: [sda] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
>> 
Turritopsis> sd 0:0:0:0: [sda] Sense Key : Hardware Error [current]
>> 
Turritopsis> sd 0:0:0:0: [sda] Add. Sense: Internal target failure
>> 
Turritopsis> sd 0:0:0:0: [sda] CDB: Read(10): 28 00 09 2a d1 10 00 00 08 00
>> 
Turritopsis> end_request: critical target error, dev sda, sector 153800976
>> 
Turritopsis> Buffer I/O error on device sda, logical block 19225122
>> 
Turritopsis> sd 0:0:0:0: [sda] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
>> 
Turritopsis> sd 0:0:0:0: [sda] Sense Key : Hardware Error [current]
>> 
Turritopsis> sd 0:0:0:0: [sda] Add. Sense: Internal target failure
>> 
Turritopsis> sd 0:0:0:0: [sda] CDB: Read(10): 28 00 09 2a d1 18 00 00 08 00
>> 
Turritopsis> end_request: critical target error, dev sda, sector 153800984
>> 
Turritopsis> Buffer I/O error on device sda, logical block 19225123
>> 
Turritopsis> sd 0:0:0:0: [sda] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
>> 
Turritopsis> sd 0:0:0:0: [sda] Sense Key : Hardware Error [current]
>> 
Turritopsis> sd 0:0:0:0: [sda] Add. Sense: Internal target failure
>> 
Turritopsis> sd 0:0:0:0: [sda] CDB: Read(10): 28 00 09 2a d1 18 00 00 08 00
>> 
Turritopsis> end_request: critical target error, dev sda, sector 153800984
>> 
Turritopsis> Buffer I/O error on device sda, logical block 19225123
>> 
Turritopsis> sd 0:0:0:0: [sda] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
>> 
Turritopsis> sd 0:0:0:0: [sda] Sense Key : Hardware Error [current]
>> 
Turritopsis> sd 0:0:0:0: [sda] Add. Sense: Internal target failure
>> 
Turritopsis> sd 0:0:0:0: [sda] CDB: Read(10): 28 00 09 2a d1 18 00 00 08 00
>> 
Turritopsis> end_request: critical target error, dev sda, sector 153800984
>> 
Turritopsis> Buffer I/O error on device sda, logical block 19225123
>> 
Turritopsis> sd 0:0:0:0: [sda] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
>> 
Turritopsis> sd 0:0:0:0: [sda] Sense Key : Hardware Error [current]
>> 
Turritopsis> sd 0:0:0:0: [sda] Add. Sense: Internal target failure
>> 
Turritopsis> sd 0:0:0:0: [sda] CDB: Read(10): 28 00 09 2a d1 18 00 00 08 00
>> 
Turritopsis> end_request: critical target error, dev sda, sector 153800984
>> 
Turritopsis> Buffer I/O error on device sda, logical block 19225123
>> 
Turritopsis> sd 0:0:0:0: [sda] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
>> 
Turritopsis> sd 0:0:0:0: [sda] Sense Key : Hardware Error [current]
>> 
Turritopsis> sd 0:0:0:0: [sda] Add. Sense: Internal target failure
>> 
Turritopsis> sd 0:0:0:0: [sda] CDB: Read(10): 28 00 09 2a d1 20 00 00 08 00
>> 
Turritopsis> end_request: critical target error, dev sda, sector 153800992
>> 
Turritopsis> Buffer I/O error on device sda, logical block 19225124
>> 
Turritopsis> sd 0:0:0:0: [sda] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
>> 
Turritopsis> sd 0:0:0:0: [sda] Sense Key : Hardware Error [current]
>> 
Turritopsis> sd 0:0:0:0: [sda] Add. Sense: Internal target failure
>> 
Turritopsis> sd 0:0:0:0: [sda] CDB: Read(10): 28 00 09 2a d1 20 00 00 08 00
>> 
Turritopsis> end_request: critical target error, dev sda, sector 153800992
>> 
Turritopsis> Buffer I/O error on device sda, logical block 19225124
>> 
Turritopsis> sd 0:0:0:0: [sda] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
>> 
Turritopsis> sd 0:0:0:0: [sda] Sense Key : Hardware Error [current]
>> 
Turritopsis> sd 0:0:0:0: [sda] Add. Sense: Internal target failure
>> 
Turritopsis> sd 0:0:0:0: [sda] CDB: Read(10): 28 00 09 2a d1 20 00 00 08 00
>> 
Turritopsis> end_request: critical target error, dev sda, sector 153800992
>> 
Turritopsis> Buffer I/O error on device sda, logical block 19225124
>> 
Turritopsis> Buffer I/O error on device sda, logical block 19225124
>> 
Turritopsis> sd 0:0:0:0: [sda] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
>> 
Turritopsis> sd 0:0:0:0: [sda] Sense Key : Hardware Error [current]
>> 
Turritopsis> sd 0:0:0:0: [sda] Add. Sense: Internal target failure
>> 
Turritopsis> sd 0:0:0:0: [sda] CDB: Read(10): 28 00 09 2a d2 28 00 00 08 00
>> 
Turritopsis> end_request: critical target error, dev sda, sector 153801256
>> 
Turritopsis> sd 0:0:0:0: [sda] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
>> 
Turritopsis> sd 0:0:0:0: [sda] Sense Key : Hardware Error [current]
>> 
Turritopsis> sd 0:0:0:0: [sda] Add. Sense: Internal target failure
>> 
Turritopsis> sd 0:0:0:0: [sda] CDB: Read(10): 28 00 09 2a d2 28 00 00 08 00
>> 
Turritopsis> end_request: critical target error, dev sda, sector 153801256
>> 
Turritopsis> Buffer I/O error on device sda, logical block 19225157
>> 
Turritopsis> sd 0:0:0:0: [sda] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
>> 
Turritopsis> sd 0:0:0:0: [sda] Sense Key : Hardware Error [current]
>> 
Turritopsis> sd 0:0:0:0: [sda] Add. Sense: Internal target failure
>> 
Turritopsis> sd 0:0:0:0: [sda] CDB: Read(10): 28 00 09 2a d2 28 00 00 08 00
>> 
Turritopsis> end_request: critical target error, dev sda, sector 153801256
>> 
Turritopsis> Buffer I/O error on device sda, logical block 19225157
>> 
Turritopsis> sd 0:0:0:0: [sda] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
>> 
Turritopsis> sd 0:0:0:0: [sda] Sense Key : Hardware Error [current]
>> 
Turritopsis> sd 0:0:0:0: [sda] Add. Sense: Internal target failure
>> 
Turritopsis> sd 0:0:0:0: [sda] CDB: Read(10): 28 00 09 2a d2 28 00 00 08 00
>> 
Turritopsis> end_request: critical target error, dev sda, sector 153801256
>> 
Turritopsis> Buffer I/O error on device sda, logical block 19225157
>> 
Turritopsis> sd 0:0:0:0: [sda] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
>> 
Turritopsis> sd 0:0:0:0: [sda] Sense Key : Hardware Error [current]
>> 
Turritopsis> sd 0:0:0:0: [sda] Add. Sense: Internal target failure
>> 
Turritopsis> sd 0:0:0:0: [sda] CDB: Read(10): 28 00 09 2a d2 30 00 00 08 00
>> 
Turritopsis> end_request: critical target error, dev sda, sector 153801264
>> 
Turritopsis> Buffer I/O error on device sda, logical block 19225158
>> 
Turritopsis> sd 0:0:0:0: [sda] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
>> 
Turritopsis> sd 0:0:0:0: [sda] Sense Key : Hardware Error [current]
>> 
Turritopsis> sd 0:0:0:0: [sda] Add. Sense: Internal target failure
>> 
Turritopsis> sd 0:0:0:0: [sda] CDB: Read(10): 28 00 09 2a d2 30 00 00 08 00
>> 
Turritopsis> end_request: critical target error, dev sda, sector 153801264
>> 
Turritopsis> Buffer I/O error on device sda, logical block 19225158
>> 
Turritopsis> sd 0:0:0:0: [sda] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
>> 
Turritopsis> sd 0:0:0:0: [sda] Sense Key : Hardware Error [current]
>> 
Turritopsis> sd 0:0:0:0: [sda] Add. Sense: Internal target failure
>> 
Turritopsis> sd 0:0:0:0: [sda] CDB: Read(10): 28 00 09 2a d2 30 00 00 08 00
>> 
Turritopsis> end_request: critical target error, dev sda, sector 153801264
>> 
Turritopsis> Buffer I/O error on device sda, logical block 19225158
>> 
Turritopsis> sd 0:0:0:0: [sda] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
>> 
Turritopsis> sd 0:0:0:0: [sda] Sense Key : Hardware Error [current]
>> 
Turritopsis> sd 0:0:0:0: [sda] Add. Sense: Internal target failure
>> 
Turritopsis> sd 0:0:0:0: [sda] CDB: Read(10): 28 00 09 2a d2 30 00 00 08 00
>> 
Turritopsis> end_request: critical target error, dev sda, sector 153801264
>> 
Turritopsis> Buffer I/O error on device sda, logical block 19225158
>> 
Turritopsis> sd 0:0:0:0: [sda] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
>> 
Turritopsis> sd 0:0:0:0: [sda] Sense Key : Hardware Error [current]
>> 
Turritopsis> sd 0:0:0:0: [sda] Add. Sense: Internal target failure
>> 
Turritopsis> sd 0:0:0:0: [sda] CDB: Read(10): 28 00 09 2a d2 38 00 00 08 00
>> 
Turritopsis> end_request: critical target error, dev sda, sector 153801272
>> 
Turritopsis> Buffer I/O error on device sda, logical block 19225159
>> 
Turritopsis> sd 0:0:0:0: [sda] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
>> 
Turritopsis> sd 0:0:0:0: [sda] Sense Key : Hardware Error [current]
>> 
Turritopsis> sd 0:0:0:0: [sda] Add. Sense: Internal target failure
>> 
Turritopsis> sd 0:0:0:0: [sda] CDB: Read(10): 28 00 09 2a d2 38 00 00 08 00
>> 
Turritopsis> end_request: critical target error, dev sda, sector 153801272
>> 
Turritopsis> Buffer I/O error on device sda, logical block 19225159
>> 
Turritopsis> Buffer I/O error on device sda, logical block 19225159
>> 
Turritopsis> sd 0:0:0:0: [sda] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
>> 
Turritopsis> sd 0:0:0:0: [sda] Sense Key : Hardware Error [current]
>> 
Turritopsis> sd 0:0:0:0: [sda] Add. Sense: Internal target failure
>> 
Turritopsis> sd 0:0:0:0: [sda] CDB: Read(10): 28 00 09 2a d3 30 00 00 08 00
>> 
Turritopsis> end_request: critical target error, dev sda, sector 153801520
>> 
Turritopsis> sd 0:0:0:0: [sda] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
>> 
Turritopsis> sd 0:0:0:0: [sda] Sense Key : Hardware Error [current]
>> 
Turritopsis> sd 0:0:0:0: [sda] Add. Sense: Internal target failure
>> 
Turritopsis> sd 0:0:0:0: [sda] CDB: Read(10): 28 00 09 2a d3 38 00 00 08 00
>> 
Turritopsis> end_request: critical target error, dev sda, sector 153801528
>> 
Turritopsis> sd 0:0:0:0: [sda] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
>> 
Turritopsis> sd 0:0:0:0: [sda] Sense Key : Hardware Error [current]
>> 
Turritopsis> sd 0:0:0:0: [sda] Add. Sense: Internal target failure
>> 
Turritopsis> sd 0:0:0:0: [sda] CDB: Read(10): 28 00 09 2a d3 38 00 00 08 00
>> 
Turritopsis> end_request: critical target error, dev sda, sector 153801528
>> 
Turritopsis> Buffer I/O error on device sda, logical block 19225191
>> 
Turritopsis> sd 0:0:0:0: [sda] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
>> 
Turritopsis> sd 0:0:0:0: [sda] Sense Key : Hardware Error [current]
>> 
Turritopsis> sd 0:0:0:0: [sda] Add. Sense: Internal target failure
>> 
Turritopsis> sd 0:0:0:0: [sda] CDB: Read(10): 28 00 09 2a d3 38 00 00 08 00
>> 
Turritopsis> end_request: critical target error, dev sda, sector 153801528
>> 
Turritopsis> Buffer I/O error on device sda, logical block 19225191
>> 
Turritopsis> sd 0:0:0:0: [sda] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
>> 
Turritopsis> sd 0:0:0:0: [sda] Sense Key : Hardware Error [current]
>> 
Turritopsis> sd 0:0:0:0: [sda] Add. Sense: Internal target failure
>> 
Turritopsis> sd 0:0:0:0: [sda] CDB: Read(10): 28 00 09 2a d3 38 00 00 08 00
>> 
Turritopsis> end_request: critical target error, dev sda, sector 153801528
>> 
Turritopsis> Buffer I/O error on device sda, logical block 19225191
>> 
Turritopsis> sd 0:0:0:0: [sda] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
>> 
Turritopsis> sd 0:0:0:0: [sda] Sense Key : Hardware Error [current]
>> 
Turritopsis> sd 0:0:0:0: [sda] Add. Sense: Internal target failure
>> 
Turritopsis> sd 0:0:0:0: [sda] CDB: Read(10): 28 00 09 2a d3 40 00 00 08 00
>> 
Turritopsis> end_request: critical target error, dev sda, sector 153801536
>> 
Turritopsis> Buffer I/O error on device sda, logical block 19225192
>> 
Turritopsis> sd 0:0:0:0: [sda] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
>> 
Turritopsis> sd 0:0:0:0: [sda] Sense Key : Hardware Error [current]
>> 
Turritopsis> sd 0:0:0:0: [sda] Add. Sense: Internal target failure
>> 
Turritopsis> sd 0:0:0:0: [sda] CDB: Read(10): 28 00 09 2a d3 40 00 00 08 00
>> 
Turritopsis> end_request: critical target error, dev sda, sector 153801536
>> 
Turritopsis> Buffer I/O error on device sda, logical block 19225192
>> 
Turritopsis> sd 0:0:0:0: [sda] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
>> 
Turritopsis> sd 0:0:0:0: [sda] Sense Key : Hardware Error [current]
>> 
Turritopsis> sd 0:0:0:0: [sda] Add. Sense: Internal target failure
>> 
Turritopsis> sd 0:0:0:0: [sda] CDB: Read(10): 28 00 09 2a d3 40 00 00 08 00
>> 
Turritopsis> end_request: critical target error, dev sda, sector 153801536
>> 
Turritopsis> Buffer I/O error on device sda, logical block 19225192
>> 
Turritopsis> sd 0:0:0:0: [sda] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
>> 
Turritopsis> sd 0:0:0:0: [sda] Sense Key : Hardware Error [current]
>> 
Turritopsis> sd 0:0:0:0: [sda] Add. Sense: Internal target failure
>> 
Turritopsis> sd 0:0:0:0: [sda] CDB: Read(10): 28 00 09 2a d3 40 00 00 08 00
>> 
Turritopsis> end_request: critical target error, dev sda, sector 153801536
>> 
Turritopsis> Buffer I/O error on device sda, logical block 19225192
>> 
Turritopsis> sd 0:0:0:0: [sda] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
>> 
Turritopsis> sd 0:0:0:0: [sda] Sense Key : Hardware Error [current]
>> 
Turritopsis> sd 0:0:0:0: [sda] Add. Sense: Internal target failure
>> 
Turritopsis> sd 0:0:0:0: [sda] CDB: Read(10): 28 00 09 2a d3 48 00 00 08 00
>> 
Turritopsis> end_request: critical target error, dev sda, sector 153801544
>> 
Turritopsis> Buffer I/O error on device sda, logical block 19225193
>> 
Turritopsis> Buffer I/O error on device sda, logical block 19225193
>> 
Turritopsis> Buffer I/O error on device sda, logical block 19225193
>> 
>> 
Turritopsis> </CODE>
>> 
>> 
Turritopsis> Based on the following discussion thread, we think that the RAID controller may be failing.
>> 
>> 
Turritopsis> Discussion thread: Which disk is bad in raid6 array
>> 
Turritopsis> Link: https://serverfault.com/questions/384935/which-disk-is-bad-in-raid6-array
>> 
>> 
Turritopsis> I had downloaded 32-bit arcconf Linux utility from the following link.
>> 
>> 
Turritopsis> Link: https://hwraid.le-vert.net/wiki/Adaptec
>> 
>> 
Turritopsis> <CODE>
>> 
>> 
Turritopsis> [root@teo-en-ming-server log]# lspci -vvv | grep RAID
>> 
Turritopsis> 04:00.0 RAID bus controller: Adaptec AAC-RAID (Rocket) (rev 02)
>> 
Turritopsis> Subsystem: IBM ServeRAID 8k/8k-l8
>> 
>> 
Turritopsis> </CODE>
>> 
>> 
Turritopsis> However, we keep getting segmentation fault running arcconf utility.
>> 
>> 
Turritopsis> <CODE>
>> 
>> 
Turritopsis> [root@teo-en-ming-server log]# /usr/local/sbin/arcconf getconfig 1
>> 
Turritopsis> Segmentation fault (core dumped)
>> 
>> 
Turritopsis> </CODE>
>> 
>> 
Turritopsis> These are the Linux Kernel messages.
>> 
>> 
Turritopsis> <CODE>
>> 
>> 
Turritopsis> Apr 22 11:11:33 teo-en-ming-server kernel: aacraid: Host adapter abort request (0,0,0,0)
>> 
Turritopsis> Apr 22 11:11:33 teo-en-ming-server kernel: aacraid: Host adapter reset request. SCSI hang ?
>> 
Turritopsis> Apr 22 11:11:33 teo-en-ming-server kernel: AAC: Host adapter BLINK LED 0x4
>> 
Turritopsis> Apr 22 11:11:33 teo-en-ming-server kernel: AAC0: adapter kernel panic'd 4.
>> 
Turritopsis> Apr 22 11:12:23 teo-en-ming-server kernel: IRQ 17/aacraid: IRQF_DISABLED is not guaranteed on shared IRQs
>> 
Turritopsis> Apr 22 11:14:37 teo-en-ming-server kernel: aacraid: Host adapter abort request (0,0,0,0)
>> 
Turritopsis> Apr 22 11:14:37 teo-en-ming-server kernel: aacraid: Host adapter reset request. SCSI hang ?
>> 
Turritopsis> Apr 22 11:14:37 teo-en-ming-server kernel: AAC: Host adapter BLINK LED 0x4
>> 
Turritopsis> Apr 22 11:14:37 teo-en-ming-server kernel: AAC0: adapter kernel panic'd 4.
>> 
Turritopsis> Apr 22 11:15:28 teo-en-ming-server kernel: IRQ 17/aacraid: IRQF_DISABLED is not guaranteed on shared IRQs
>> 
Turritopsis> Apr 22 11:16:34 teo-en-ming-server kernel: aacraid: Host adapter abort request (0,0,0,0)
>> 
Turritopsis> Apr 22 11:16:34 teo-en-ming-server kernel: aacraid: Host adapter reset request. SCSI hang ?
>> 
Turritopsis> Apr 22 11:16:34 teo-en-ming-server kernel: AAC: Host adapter BLINK LED 0x4
>> 
Turritopsis> Apr 22 11:16:34 teo-en-ming-server kernel: AAC0: adapter kernel panic'd 4.
>> 
>> 
Turritopsis> </CODE>
>> 
>> 
Turritopsis> It seems that I could not query the RAID controller. It keeps saying that the RAID controller adapter has kernel panics.
>> 
>> 
Turritopsis> arcconf is a Linux utility to query the RAID controller.
>> 
>> 
Turritopsis> <CODE>
>> 
>> 
Turritopsis> [root@teo-en-ming-server cmdline]# lspci -nn | grep RAID
>> 
Turritopsis> 04:00.0 RAID bus controller [0104]: Adaptec AAC-RAID (Rocket) [9005:0286] (rev 02)
>> 
>> 
Turritopsis> </CODE>
>> 
>> 
Turritopsis> Do you know why I keep getting segmentation fault running arcconf Linux utility?
>> 
>> 
Turritopsis> Regards,
>> 
>> 
Turritopsis> Mr. Turritopsis Dohrnii Teo En Ming
>> 
Turritopsis> Targeted Individual in Singapore
>> 
Turritopsis> 24 April 2022 Sunday
>> 
>> 
>> 
>> 
>> 
