Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B590CC433F5
	for <linux-raid@archiver.kernel.org>; Mon, 10 Jan 2022 09:47:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243214AbiAJJrn (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 10 Jan 2022 04:47:43 -0500
Received: from mga12.intel.com ([192.55.52.136]:6209 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243074AbiAJJrk (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Mon, 10 Jan 2022 04:47:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1641808060; x=1673344060;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=oeUd9JbtKodUodxpOGhVCkVDC3jFljTKBOjYO+Xd0Q0=;
  b=l0k+RPBWARYWPW/EBWNBRWerEh9XAYqeptZAG8oUdlP3s9PyOAN89jjW
   AuL3J3l0aC85/LLECtGv7vUwUFY0ZFRNSJT2lgVjuBaRTUdREqi1P8xsj
   GHxxp3vQ81gc9Q7IpQdWlbh6ON4S9ntyT+oW4D0RFHIUpq4XeE/b+K2uX
   71yMa/V/W43/S+qB5dclAgdfr/GPcMLfv1Zzc5x7zifDZxTwRGMv2l6Jn
   /PGstdeYO/0OFpXUaSns0NnXjedZrRjGpIXJySdLfVGXpWVpLYayShlI+
   Fvglsm/4gOdzvBlJMMumu5g+32t31hJrju/3kMpvCXRTArJzKoy8/oqM3
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10222"; a="223174335"
X-IronPort-AV: E=Sophos;i="5.88,276,1635231600"; 
   d="scan'208";a="223174335"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jan 2022 01:47:39 -0800
X-IronPort-AV: E=Sophos;i="5.88,276,1635231600"; 
   d="scan'208";a="528209320"
Received: from mtkaczyk-mobl1.ger.corp.intel.com (HELO localhost) ([10.213.1.54])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jan 2022 01:47:38 -0800
Date:   Mon, 10 Jan 2022 10:47:33 +0100
From:   Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To:     Aidan Walton <aidan.walton@gmail.com>
Cc:     linux-raid@vger.kernel.org
Subject: Re: md device remains active even when all supporting disks have
 failed and been disabled by the kernel.
Message-ID: <20220110104733.00001048@linux.intel.com>
In-Reply-To: <CAPx-8MP0+C9M9ysigF-gfaUBE8nv7nzbm4HO06yC_z5i3U3D=Q@mail.gmail.com>
References: <CAPx-8MP0+C9M9ysigF-gfaUBE8nv7nzbm4HO06yC_z5i3U3D=Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Fri, 7 Jan 2022 23:30:31 +0100
Aidan Walton <aidan.walton@gmail.com> wrote:

> Hi,
> I have a system running:
> Ubuntu Server 20.04.3 LTS on a 5.4.0-92-generic kernel.
> 
> On the motherboard is a:
> SATA controller: JMicron Technology Corp. JMB363 SATA/IDE Controller
> (rev 02)
> 
> Connected to this I have:
> 2x Western Digital - WDC WD5001AALS-00L3B2, BIOS :01.03B01 500Gb
> drives
> 
> Each drive has a single partition and is part of a RAID1 array:
> /dev/md90:
> .....
>     Number   Major   Minor   RaidDevice State
>        0       8       33        0      active sync   /dev/sdc1
>        2       8       49        1      active sync   /dev/sdd1
> 
> On top of this I have a single LVM VG and LV. (Probably not important)
> 
> I have noticed some strange behaviour and upon investigation I find
> the md device in the following state:
> /dev/md90:
> ....
> 
>     Number   Major   Minor   RaidDevice State
>        0       8       33        0      active sync   /dev/sdc1
>        -       0        0        1      removed
> 
>        2       8       49        -      faulty   /dev/sdd1
> 
> 
> In fact neither /dev/sdc1 or /dev/sdd1 are available. In fact neither
> are /dev/sdc or /dev/sdd, the physical drives, as they both been
> disconnected by the kernel:
> /dev/sdc is attached to ata7:00  and  /dev/sdd is attached to ata.8:00
> This is the log of the kernel events:
> 
> 
> Jan 07 22:09:03 mx kernel: ata7.00: exception Emask 0x32 SAct 0x0 SErr
> 0x0 action 0xe frozen
> Jan 07 22:09:03 mx kernel: ata7.00: irq_stat 0xffffffff, unknown FIS
> 00000000 00000000 00000000 00000000, host bus
> Jan 07 22:09:03 mx kernel: ata7.00: failed command: READ DMA
> Jan 07 22:09:03 mx kernel: ata7.00: cmd
> c8/00:00:00:cf:26/00:00:00:00:00/e0 tag 18 dma 131072 in
> Jan 07 22:09:03 mx kernel: ata7.00: status: { DRDY }
> Jan 07 22:09:03 mx kernel: ata7: hard resetting link
> Jan 07 22:09:03 mx kernel: ata7: SATA link up 1.5 Gbps (SStatus 113
> SControl 310)
> Jan 07 22:09:09 mx kernel: ata7.00: qc timeout (cmd 0xec)
> Jan 07 22:09:09 mx kernel: ata7.00: failed to IDENTIFY (I/O error,
> err_mask=0x4) Jan 07 22:09:09 mx kernel: ata7.00: revalidation failed
> (errno=-5) Jan 07 22:09:09 mx kernel: ata7: hard resetting link
> Jan 07 22:09:19 mx kernel: ata7: softreset failed (1st FIS failed)
> Jan 07 22:09:19 mx kernel: ata7: hard resetting link
> Jan 07 22:09:29 mx kernel: ata7: softreset failed (1st FIS failed)
> Jan 07 22:09:29 mx kernel: ata7: hard resetting link
> Jan 07 22:09:35 mx kernel: ata8.00: exception Emask 0x40 SAct 0x0 SErr
> 0x800 action 0x6 frozen
> Jan 07 22:09:35 mx kernel: ata8: SError: { HostInt }
> Jan 07 22:09:35 mx kernel: ata8.00: failed command: READ DMA
> Jan 07 22:09:35 mx kernel: ata8.00: cmd
> c8/00:00:00:64:4a/00:00:00:00:00/e0 tag 2 dma 131072 in
> Jan 07 22:09:35 mx kernel: ata8.00: status: { DRDY }
> Jan 07 22:09:35 mx kernel: ata8: hard resetting link
> Jan 07 22:09:45 mx kernel: ata8: softreset failed (1st FIS failed)
> Jan 07 22:09:45 mx kernel: ata8: hard resetting link
> Jan 07 22:09:55 mx kernel: ata8: softreset failed (1st FIS failed)
> Jan 07 22:09:55 mx kernel: ata8: hard resetting link
> Jan 07 22:10:04 mx kernel: ata7: softreset failed (1st FIS failed)
> Jan 07 22:10:04 mx kernel: ata7: hard resetting link
> Jan 07 22:10:09 mx kernel: ata7: softreset failed (1st FIS failed)
> Jan 07 22:10:09 mx kernel: ata7: reset failed, giving up
> Jan 07 22:10:09 mx kernel: ata7.00: disabled
> Jan 07 22:10:09 mx kernel: ata7: EH complete
> Jan 07 22:10:30 mx kernel: ata8: softreset failed (1st FIS failed)
> Jan 07 22:10:30 mx kernel: ata8: hard resetting link
> Jan 07 22:10:35 mx kernel: ata8: softreset failed (1st FIS failed)
> Jan 07 22:10:35 mx kernel: ata8: reset failed, giving up
> Jan 07 22:10:35 mx kernel: ata8.00: disabled
> Jan 07 22:10:35 mx kernel: ata8: EH complete
> 
> This is happening because of some issue with the SATA controller on
> the motherboard. This has not been resolved and probably never will
> be, I see many others through google search complaining of similar
> issues with the SATA controller.
> This failure only occurs when the SATA controller is placed under very
> heavy load, I have minimised the impact of the problem by not using
> NCQ, this helps, but it still occurs. Ironically the biggest issue I
> have is that mdadm "checkarray" is running because of a systemd
> background process every week or so, and this hammers the disk into
> failure. Most of the normal daily usage never generates the link
> resets.
> Naturally I have changed SATA cables and moved drives around onto
> different controllers, but alas, it does seem to be the hardware on
> the motherboard.
> However as a workaround I was hoping to accept the occasional failure
> and then using some scripting and 'setpci' I can get the kernel to
> hard reset the chipset and attach the drives again. I have the process
> working in terms of getting the kernel to re-attach the drives,
> but.......
> 
> Unfortunately mdraid will not let go of them, I can not stop the
> arrays, and therefore can't rebuild them. If I simply allow the kernel
> to re-attach the drives the kernel names are swapped over, as
> something (mdraid) is stopping the kernel re-using the same device
> names. Anyway being dependent on the same kernel device names is not a
> great plan anyway, so I was simply trying to get mdadm to reassemble
> the array as soon as the 'workaround' script gets the drives back in
> contact with libata (kernel).
> 
> Plan:
> 1. Detecting the problem. (mdadm state)
> 2. Stop the array totally (can NOT do it)
> 3. reset the chipset across the PCI bus.
> 4. allow kernel to re-attach drives.
> 5. re-assemble the md device with mdadm
> 6. restart, if necessary higher layer services...
> 
> So why is mdraid holding on to the array:
> 
> # mdadm --stop /dev/md90
> mdadm: Cannot get exclusive access to /dev/md90:Perhaps a running
> process, mounted filesystem or active volume group?
> 
> I can not be 100% sure that something else is using the device, but I
> can't think of anything that is and I stopped every process I can
> think of..... Plus why is the array still shown as 'active' when none
> of its member devices even exist anymore?
> 
> What I do know is that device mapper (coming down from LVM)  still has
> an entry in /dev/mapper. But then probably no surprise as /dev/md90
> the failed array is still an active device node. If you attempt to
> write to it, I receive I/O errors from the kernel. In fact as far as
> any higher layer services are concerned md90 and the LVM LV on top of
> it are still active and working when in reality, they are not. It
> causes very strange NFS errors and such.
> 
> mdraid does actually attempt to iteratively remove both partitions
> when the kernel signals the disable state, but only 1 of them
> succeeds.
> I did an strace of the same iterative 'fail:remove' process that
> mdraid attempts when the kernel issues -- kernel: ata7.00: disabled
> 
> eg:
> /sbin/mdadm -If sdc1 --path pci-0000:02:00.0-ata-1
> mdadm: set device faulty failed for sdc1:  Device or resource busy
> 
> The only clue is perhaps this line from the strace:
> openat(AT_FDCWD, "/sys/block/md90/md/dev-sdc1/block/dev", O_RDWR) = -1
> EACCES (Permission denied)    What is the mdadm command doing that
> results in a permission problem?
> 
> So the only way I can get rid of this md raid array is a reboot.
> Damn!!!
> 
> 
> Any help is much appreciated.
> Aidan
> 
> 
> 
Hi Aidan,
This is how it is implemented. Drive is not removed if array failure
will cause array failed. Please see:
https://git.kernel.org/pub/scm/linux/kernel/git/song/md.git/commit/?id=9a567843f7ce0037bfd4d5fdc58a09d0a527b28b

For RAID1 you can use solution proposed in patch below but IMO it is
not your problem. Please stop LVM and then try to stop array. To stop
array it needs to be "free" (all upper handlers are down).

Thanks,
Mariusz
