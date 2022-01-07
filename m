Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B060C433EF
	for <linux-raid@archiver.kernel.org>; Fri,  7 Jan 2022 22:31:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230326AbiAGWbK (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 7 Jan 2022 17:31:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230133AbiAGWbK (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 7 Jan 2022 17:31:10 -0500
Received: from mail-qt1-x833.google.com (mail-qt1-x833.google.com [IPv6:2607:f8b0:4864:20::833])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA346C061574
        for <linux-raid@vger.kernel.org>; Fri,  7 Jan 2022 14:31:09 -0800 (PST)
Received: by mail-qt1-x833.google.com with SMTP id b11so73408qtk.12
        for <linux-raid@vger.kernel.org>; Fri, 07 Jan 2022 14:31:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to;
        bh=Kb8c1cdP7QPTjkFkJ3GNv1MEH+tgW1n0ox6jGaSiIew=;
        b=nMCj9cvVLpOgROfWNxv1FrUIJDVqJ1MCihMCp71vJ4VpltaOO4uuBROHjbeuGSXJWy
         1/r8I2md7zajnhFEHBHBoWi1TXSPsU4ZI0WbeYv8dB+vazRVzw4hsmfFgcVFP0K3w9yB
         TBatOEg30Z7tjzvDrvVcFz10H4teqdoFup/e0WuW4YWkXm9qlCz9+asFJGB/Hylzaxai
         KWY1T/KgOVM69W6aTypitfly7T2QIJ3RmXxKD+2dzpIg1/52867t1brEmp1jb6Yoq1rn
         Ulf6DaHjv3/HbN905G3vy5tWq1M5752QB3jCS3nG00s4L6+H4XTePxkqhc7wQwi/BVDL
         18yw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=Kb8c1cdP7QPTjkFkJ3GNv1MEH+tgW1n0ox6jGaSiIew=;
        b=EuIJ2qXtMWh3vtb6kHyU5rP58hC58n6cW1QGI+4z9xEV1oMB1kUwAr6r1Wa09rFpp3
         Q5QoFLCJpiMMYs3BziaJ3UbbXXgb2d49hQhmqT4xWwTax54WbMsRFD+D1OznZ/tf3pJR
         6f9J8a4wJ8n8fcugK13MMEA6X2TmhRG7Bape28LWHTrLPFYD23aHsGlvy0mVSBXUT9OL
         AarA3Q0SpP7SSZWz/7xzH/BETi4CTguDb9WRnRuAj8AKJxaftOod3n89uqmE+eEwlanE
         mV/32K4vTgS1vwlozbyQf74/+Q4pUeMV7Iee2uWnmjP2CPfN6tjPR0jcVPtTy0hpz59g
         83Nw==
X-Gm-Message-State: AOAM530rN/NTaze6kpq8DCWjvsOkDlIpLCEjxcsxzy9UAAUrzt9TNyfv
        1JaLPouLlWo1QiTMxQDCOEFpohcsNgWica3Cne97WoQnMbI=
X-Google-Smtp-Source: ABdhPJzKCj5rb/bwNGX9htvYBsuWRSin5xv2du2DdhFIocNuaj1hB1VkcWsz5djwwVsa7QKFOrH/faMfzXJyi0gHubk=
X-Received: by 2002:a05:622a:1389:: with SMTP id o9mr58439845qtk.109.1641594667989;
 Fri, 07 Jan 2022 14:31:07 -0800 (PST)
MIME-Version: 1.0
From:   Aidan Walton <aidan.walton@gmail.com>
Date:   Fri, 7 Jan 2022 23:30:31 +0100
Message-ID: <CAPx-8MP0+C9M9ysigF-gfaUBE8nv7nzbm4HO06yC_z5i3U3D=Q@mail.gmail.com>
Subject: md device remains active even when all supporting disks have failed
 and been disabled by the kernel.
To:     linux-raid@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi,
I have a system running:
Ubuntu Server 20.04.3 LTS on a 5.4.0-92-generic kernel.

On the motherboard is a:
SATA controller: JMicron Technology Corp. JMB363 SATA/IDE Controller (rev 02)

Connected to this I have:
2x Western Digital - WDC WD5001AALS-00L3B2, BIOS :01.03B01 500Gb drives

Each drive has a single partition and is part of a RAID1 array:
/dev/md90:
.....
    Number   Major   Minor   RaidDevice State
       0       8       33        0      active sync   /dev/sdc1
       2       8       49        1      active sync   /dev/sdd1

On top of this I have a single LVM VG and LV. (Probably not important)

I have noticed some strange behaviour and upon investigation I find
the md device in the following state:
/dev/md90:
....

    Number   Major   Minor   RaidDevice State
       0       8       33        0      active sync   /dev/sdc1
       -       0        0        1      removed

       2       8       49        -      faulty   /dev/sdd1


In fact neither /dev/sdc1 or /dev/sdd1 are available. In fact neither
are /dev/sdc or /dev/sdd, the physical drives, as they both been
disconnected by the kernel:
/dev/sdc is attached to ata7:00  and  /dev/sdd is attached to ata.8:00
This is the log of the kernel events:


Jan 07 22:09:03 mx kernel: ata7.00: exception Emask 0x32 SAct 0x0 SErr
0x0 action 0xe frozen
Jan 07 22:09:03 mx kernel: ata7.00: irq_stat 0xffffffff, unknown FIS
00000000 00000000 00000000 00000000, host bus
Jan 07 22:09:03 mx kernel: ata7.00: failed command: READ DMA
Jan 07 22:09:03 mx kernel: ata7.00: cmd
c8/00:00:00:cf:26/00:00:00:00:00/e0 tag 18 dma 131072 in
Jan 07 22:09:03 mx kernel: ata7.00: status: { DRDY }
Jan 07 22:09:03 mx kernel: ata7: hard resetting link
Jan 07 22:09:03 mx kernel: ata7: SATA link up 1.5 Gbps (SStatus 113
SControl 310)
Jan 07 22:09:09 mx kernel: ata7.00: qc timeout (cmd 0xec)
Jan 07 22:09:09 mx kernel: ata7.00: failed to IDENTIFY (I/O error, err_mask=0x4)
Jan 07 22:09:09 mx kernel: ata7.00: revalidation failed (errno=-5)
Jan 07 22:09:09 mx kernel: ata7: hard resetting link
Jan 07 22:09:19 mx kernel: ata7: softreset failed (1st FIS failed)
Jan 07 22:09:19 mx kernel: ata7: hard resetting link
Jan 07 22:09:29 mx kernel: ata7: softreset failed (1st FIS failed)
Jan 07 22:09:29 mx kernel: ata7: hard resetting link
Jan 07 22:09:35 mx kernel: ata8.00: exception Emask 0x40 SAct 0x0 SErr
0x800 action 0x6 frozen
Jan 07 22:09:35 mx kernel: ata8: SError: { HostInt }
Jan 07 22:09:35 mx kernel: ata8.00: failed command: READ DMA
Jan 07 22:09:35 mx kernel: ata8.00: cmd
c8/00:00:00:64:4a/00:00:00:00:00/e0 tag 2 dma 131072 in
Jan 07 22:09:35 mx kernel: ata8.00: status: { DRDY }
Jan 07 22:09:35 mx kernel: ata8: hard resetting link
Jan 07 22:09:45 mx kernel: ata8: softreset failed (1st FIS failed)
Jan 07 22:09:45 mx kernel: ata8: hard resetting link
Jan 07 22:09:55 mx kernel: ata8: softreset failed (1st FIS failed)
Jan 07 22:09:55 mx kernel: ata8: hard resetting link
Jan 07 22:10:04 mx kernel: ata7: softreset failed (1st FIS failed)
Jan 07 22:10:04 mx kernel: ata7: hard resetting link
Jan 07 22:10:09 mx kernel: ata7: softreset failed (1st FIS failed)
Jan 07 22:10:09 mx kernel: ata7: reset failed, giving up
Jan 07 22:10:09 mx kernel: ata7.00: disabled
Jan 07 22:10:09 mx kernel: ata7: EH complete
Jan 07 22:10:30 mx kernel: ata8: softreset failed (1st FIS failed)
Jan 07 22:10:30 mx kernel: ata8: hard resetting link
Jan 07 22:10:35 mx kernel: ata8: softreset failed (1st FIS failed)
Jan 07 22:10:35 mx kernel: ata8: reset failed, giving up
Jan 07 22:10:35 mx kernel: ata8.00: disabled
Jan 07 22:10:35 mx kernel: ata8: EH complete

This is happening because of some issue with the SATA controller on
the motherboard. This has not been resolved and probably never will
be, I see many others through google search complaining of similar
issues with the SATA controller.
This failure only occurs when the SATA controller is placed under very
heavy load, I have minimised the impact of the problem by not using
NCQ, this helps, but it still occurs. Ironically the biggest issue I
have is that mdadm "checkarray" is running because of a systemd
background process every week or so, and this hammers the disk into
failure. Most of the normal daily usage never generates the link
resets.
Naturally I have changed SATA cables and moved drives around onto
different controllers, but alas, it does seem to be the hardware on
the motherboard.
However as a workaround I was hoping to accept the occasional failure
and then using some scripting and 'setpci' I can get the kernel to
hard reset the chipset and attach the drives again. I have the process
working in terms of getting the kernel to re-attach the drives,
but.......

Unfortunately mdraid will not let go of them, I can not stop the
arrays, and therefore can't rebuild them. If I simply allow the kernel
to re-attach the drives the kernel names are swapped over, as
something (mdraid) is stopping the kernel re-using the same device
names. Anyway being dependent on the same kernel device names is not a
great plan anyway, so I was simply trying to get mdadm to reassemble
the array as soon as the 'workaround' script gets the drives back in
contact with libata (kernel).

Plan:
1. Detecting the problem. (mdadm state)
2. Stop the array totally (can NOT do it)
3. reset the chipset across the PCI bus.
4. allow kernel to re-attach drives.
5. re-assemble the md device with mdadm
6. restart, if necessary higher layer services...

So why is mdraid holding on to the array:

# mdadm --stop /dev/md90
mdadm: Cannot get exclusive access to /dev/md90:Perhaps a running
process, mounted filesystem or active volume group?

I can not be 100% sure that something else is using the device, but I
can't think of anything that is and I stopped every process I can
think of..... Plus why is the array still shown as 'active' when none
of its member devices even exist anymore?

What I do know is that device mapper (coming down from LVM)  still has
an entry in /dev/mapper. But then probably no surprise as /dev/md90
the failed array is still an active device node. If you attempt to
write to it, I receive I/O errors from the kernel. In fact as far as
any higher layer services are concerned md90 and the LVM LV on top of
it are still active and working when in reality, they are not. It
causes very strange NFS errors and such.

mdraid does actually attempt to iteratively remove both partitions
when the kernel signals the disable state, but only 1 of them
succeeds.
I did an strace of the same iterative 'fail:remove' process that
mdraid attempts when the kernel issues -- kernel: ata7.00: disabled

eg:
/sbin/mdadm -If sdc1 --path pci-0000:02:00.0-ata-1
mdadm: set device faulty failed for sdc1:  Device or resource busy

The only clue is perhaps this line from the strace:
openat(AT_FDCWD, "/sys/block/md90/md/dev-sdc1/block/dev", O_RDWR) = -1
EACCES (Permission denied)    What is the mdadm command doing that
results in a permission problem?

So the only way I can get rid of this md raid array is a reboot. Damn!!!


Any help is much appreciated.
Aidan





I include a truncated dump of "strace /sbin/mdadm -If sdc1 --path
pci-0000:02:00.0-ata-1"   below. Hoping not to clutter too much


strace /sbin/mdadm -If sdc1 --path pci-0000:02:00.0-ata-1
execve("/sbin/mdadm", ["/sbin/mdadm", "-If", "sdc1", "--path",
"pci-0000:02:00.0-ata-1"], 0x7ffea5512340 /* 24 vars */) = 0
brk(NULL)                               = 0x55a104817000
arch_prctl(0x3001 /* ARCH_??? */, 0x7ffd2e463570) = -1 EINVAL (Invalid argument)
access("/etc/ld.so.preload", R_OK)      = -1 ENOENT (No such file or directory)
openat(AT_FDCWD, "/etc/ld.so.cache", O_RDONLY|O_CLOEXEC) = 3
fstat(3, {st_mode=S_IFREG|0644, st_size=62948, ...}) = 0
mmap(NULL, 62948, PROT_READ, MAP_PRIVATE, 3, 0) = 0x7f3e1985f000
close(3)                                = 0
openat(AT_FDCWD, "/lib/x86_64-linux-gnu/libdl.so.2", O_RDONLY|O_CLOEXEC) = 3
read(3, "\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0>\0\1\0\0\0
\22\0\0\0\0\0\0"..., 832) = 832
fstat(3, {st_mode=S_IFREG|0644, st_size=18816, ...}) = 0
mmap(NULL, 8192, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1,
0) = 0x7f3e1985d000
mmap(NULL, 20752, PROT_READ, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0x7f3e19857000
mmap(0x7f3e19858000, 8192, PROT_READ|PROT_EXEC,
MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x1000) = 0x7f3e19858000
mmap(0x7f3e1985a000, 4096, PROT_READ,
MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x3000) = 0x7f3e1985a000
mmap(0x7f3e1985b000, 8192, PROT_READ|PROT_WRITE,
MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x3000) = 0x7f3e1985b000
close(3)                                = 0
openat(AT_FDCWD, "/lib/x86_64-linux-gnu/libc.so.6", O_RDONLY|O_CLOEXEC) = 3
read(3, "\177ELF\2\1\1\3\0\0\0\0\0\0\0\0\3\0>\0\1\0\0\0\360q\2\0\0\0\0\0"...,
832) = 832
pread64(3, "\6\0\0\0\4\0\0\0@\0\0\0\0\0\0\0@\0\0\0\0\0\0\0@\0\0\0\0\0\0\0"...,
784, 64) = 784
pread64(3, "\4\0\0\0\20\0\0\0\5\0\0\0GNU\0\2\0\0\300\4\0\0\0\3\0\0\0\0\0\0\0",
32, 848) = 32
pread64(3, "\4\0\0\0\24\0\0\0\3\0\0\0GNU\0\t\233\222%\274\260\320\31\331\326\10\204\276X>\263"...,
68, 880) = 68
fstat(3, {st_mode=S_IFREG|0755, st_size=2029224, ...}) = 0
pread64(3, "\6\0\0\0\4\0\0\0@\0\0\0\0\0\0\0@\0\0\0\0\0\0\0@\0\0\0\0\0\0\0"...,
784, 64) = 784
pread64(3, "\4\0\0\0\20\0\0\0\5\0\0\0GNU\0\2\0\0\300\4\0\0\0\3\0\0\0\0\0\0\0",
32, 848) = 32
pread64(3, "\4\0\0\0\24\0\0\0\3\0\0\0GNU\0\t\233\222%\274\260\320\31\331\326\10\204\276X>\263"...,
68, 880) = 68
mmap(NULL, 2036952, PROT_READ, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0x7f3e19665000
mprotect(0x7f3e1968a000, 1847296, PROT_NONE) = 0
mmap(0x7f3e1968a000, 1540096, PROT_READ|PROT_EXEC,
MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x25000) = 0x7f3e1968a000
mmap(0x7f3e19802000, 303104, PROT_READ,
MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x19d000) = 0x7f3e19802000
mmap(0x7f3e1984d000, 24576, PROT_READ|PROT_WRITE,
MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x1e7000) = 0x7f3e1984d000
mmap(0x7f3e19853000, 13528, PROT_READ|PROT_WRITE,
MAP_PRIVATE|MAP_FIXED|MAP_ANONYMOUS, -1, 0) = 0x7f3e19853000
close(3)                                = 0
mmap(NULL, 12288, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1,
0) = 0x7f3e19662000
arch_prctl(ARCH_SET_FS, 0x7f3e19662740) = 0
mprotect(0x7f3e1984d000, 12288, PROT_READ) = 0
mprotect(0x7f3e1985b000, 4096, PROT_READ) = 0
mprotect(0x55a103364000, 4096, PROT_READ) = 0
mprotect(0x7f3e1989c000, 4096, PROT_READ) = 0
munmap(0x7f3e1985f000, 62948)           = 0
getpid()                                = 44041
uname({sysname="Linux", nodename="mx", ...}) = 0
brk(NULL)                               = 0x55a104817000
brk(0x55a104838000)                     = 0x55a104838000
openat(AT_FDCWD, "/etc/mdadm/mdadm.conf", O_RDONLY) = 3
fstat(3, {st_mode=S_IFREG|0644, st_size=949, ...}) = 0
fstat(3, {st_mode=S_IFREG|0644, st_size=949, ...}) = 0
read(3, "# mdadm.conf\n#\n# !NB! Run update"..., 4096) = 949
read(3, "", 4096)                       = 0
fstat(3, {st_mode=S_IFREG|0644, st_size=949, ...}) = 0
close(3)                                = 0
openat(AT_FDCWD, "/etc/mdadm/mdadm.conf.d", O_RDONLY) = -1 ENOENT (No
such file or directory)
uname({sysname="Linux", nodename="mx", ...}) = 0
openat(AT_FDCWD, "/etc/ld.so.cache", O_RDONLY|O_CLOEXEC) = 3
fstat(3, {st_mode=S_IFREG|0644, st_size=62948, ...}) = 0
mmap(NULL, 62948, PROT_READ, MAP_PRIVATE, 3, 0) = 0x7f3e1985f000
close(3)                                = 0
openat(AT_FDCWD,
"/lib/x86_64-linux-gnu/tls/x86_64/x86_64/libdlm_lt.so.3",
O_RDONLY|O_CLOEXEC) = -1 ENOENT (No such file or directory)
stat("/lib/x86_64-linux-gnu/tls/x86_64/x86_64", 0x7ffd2e462630) = -1
ENOENT (No such file or directory)
openat(AT_FDCWD, "/lib/x86_64-linux-gnu/tls/x86_64/libdlm_lt.so.3",
O_RDONLY|O_CLOEXEC) = -1 ENOENT (No such file or directory)
stat("/lib/x86_64-linux-gnu/tls/x86_64", 0x7ffd2e462630) = -1 ENOENT
(No such file or directory)
openat(AT_FDCWD, "/lib/x86_64-linux-gnu/tls/x86_64/libdlm_lt.so.3",
O_RDONLY|O_CLOEXEC) = -1 ENOENT (No such file or directory)
stat("/lib/x86_64-linux-gnu/tls/x86_64", 0x7ffd2e462630) = -1 ENOENT
(No such file or directory)
openat(AT_FDCWD, "/lib/x86_64-linux-gnu/tls/libdlm_lt.so.3",
O_RDONLY|O_CLOEXEC) = -1 ENOENT (No such file or directory)
stat("/lib/x86_64-linux-gnu/tls", 0x7ffd2e462630) = -1 ENOENT (No such
file or directory)
openat(AT_FDCWD, "/lib/x86_64-linux-gnu/x86_64/x86_64/libdlm_lt.so.3",
O_RDONLY|O_CLOEXEC) = -1 ENOENT (No such file or directory)
stat("/lib/x86_64-linux-gnu/x86_64/x86_64", 0x7ffd2e462630) = -1
ENOENT (No such file or directory)
openat(AT_FDCWD, "/lib/x86_64-linux-gnu/x86_64/libdlm_lt.so.3",
O_RDONLY|O_CLOEXEC) = -1 ENOENT (No such file or directory)
stat("/lib/x86_64-linux-gnu/x86_64", 0x7ffd2e462630) = -1 ENOENT (No
such file or directory)
openat(AT_FDCWD, "/lib/x86_64-linux-gnu/x86_64/libdlm_lt.so.3",
O_RDONLY|O_CLOEXEC) = -1 ENOENT (No such file or directory)
stat("/lib/x86_64-linux-gnu/x86_64", 0x7ffd2e462630) = -1 ENOENT (No
such file or directory)
openat(AT_FDCWD, "/lib/x86_64-linux-gnu/libdlm_lt.so.3",
O_RDONLY|O_CLOEXEC) = -1 ENOENT (No such file or directory)
stat("/lib/x86_64-linux-gnu", {st_mode=S_IFDIR|0755, st_size=20480, ...}) = 0
openat(AT_FDCWD,
"/usr/lib/x86_64-linux-gnu/tls/x86_64/x86_64/libdlm_lt.so.3",
O_RDONLY|O_CLOEXEC) = -1 ENOENT (No such file or directory)
stat("/usr/lib/x86_64-linux-gnu/tls/x86_64/x86_64", 0x7ffd2e462630) =
-1 ENOENT (No such file or directory)
openat(AT_FDCWD,
"/usr/lib/x86_64-linux-gnu/tls/x86_64/libdlm_lt.so.3",
O_RDONLY|O_CLOEXEC) = -1 ENOENT (No such file or directory)
stat("/usr/lib/x86_64-linux-gnu/tls/x86_64", 0x7ffd2e462630) = -1
ENOENT (No such file or directory)
openat(AT_FDCWD,
"/usr/lib/x86_64-linux-gnu/tls/x86_64/libdlm_lt.so.3",
O_RDONLY|O_CLOEXEC) = -1 ENOENT (No such file or directory)
stat("/usr/lib/x86_64-linux-gnu/tls/x86_64", 0x7ffd2e462630) = -1
ENOENT (No such file or directory)
openat(AT_FDCWD, "/usr/lib/x86_64-linux-gnu/tls/libdlm_lt.so.3",
O_RDONLY|O_CLOEXEC) = -1 ENOENT (No such file or directory)
stat("/usr/lib/x86_64-linux-gnu/tls", 0x7ffd2e462630) = -1 ENOENT (No
such file or directory)
openat(AT_FDCWD,
"/usr/lib/x86_64-linux-gnu/x86_64/x86_64/libdlm_lt.so.3",
O_RDONLY|O_CLOEXEC) = -1 ENOENT (No such file or directory)
stat("/usr/lib/x86_64-linux-gnu/x86_64/x86_64", 0x7ffd2e462630) = -1
ENOENT (No such file or directory)
openat(AT_FDCWD, "/usr/lib/x86_64-linux-gnu/x86_64/libdlm_lt.so.3",
O_RDONLY|O_CLOEXEC) = -1 ENOENT (No such file or directory)
stat("/usr/lib/x86_64-linux-gnu/x86_64", 0x7ffd2e462630) = -1 ENOENT
(No such file or directory)
openat(AT_FDCWD, "/usr/lib/x86_64-linux-gnu/x86_64/libdlm_lt.so.3",
O_RDONLY|O_CLOEXEC) = -1 ENOENT (No such file or directory)
stat("/usr/lib/x86_64-linux-gnu/x86_64", 0x7ffd2e462630) = -1 ENOENT
(No such file or directory)
openat(AT_FDCWD, "/usr/lib/x86_64-linux-gnu/libdlm_lt.so.3",
O_RDONLY|O_CLOEXEC) = -1 ENOENT (No such file or directory)
stat("/usr/lib/x86_64-linux-gnu", {st_mode=S_IFDIR|0755,
st_size=65536, ...}) = 0
openat(AT_FDCWD, "/lib/tls/x86_64/x86_64/libdlm_lt.so.3",
O_RDONLY|O_CLOEXEC) = -1 ENOENT (No such file or directory)
stat("/lib/tls/x86_64/x86_64", 0x7ffd2e462630) = -1 ENOENT (No such
file or directory)
openat(AT_FDCWD, "/lib/tls/x86_64/libdlm_lt.so.3", O_RDONLY|O_CLOEXEC)
= -1 ENOENT (No such file or directory)
stat("/lib/tls/x86_64", 0x7ffd2e462630) = -1 ENOENT (No such file or directory)
openat(AT_FDCWD, "/lib/tls/x86_64/libdlm_lt.so.3", O_RDONLY|O_CLOEXEC)
= -1 ENOENT (No such file or directory)
stat("/lib/tls/x86_64", 0x7ffd2e462630) = -1 ENOENT (No such file or directory)
openat(AT_FDCWD, "/lib/tls/libdlm_lt.so.3", O_RDONLY|O_CLOEXEC) = -1
ENOENT (No such file or directory)
stat("/lib/tls", 0x7ffd2e462630)        = -1 ENOENT (No such file or directory)
openat(AT_FDCWD, "/lib/x86_64/x86_64/libdlm_lt.so.3",
O_RDONLY|O_CLOEXEC) = -1 ENOENT (No such file or directory)
stat("/lib/x86_64/x86_64", 0x7ffd2e462630) = -1 ENOENT (No such file
or directory)
openat(AT_FDCWD, "/lib/x86_64/libdlm_lt.so.3", O_RDONLY|O_CLOEXEC) =
-1 ENOENT (No such file or directory)
stat("/lib/x86_64", 0x7ffd2e462630)     = -1 ENOENT (No such file or directory)
openat(AT_FDCWD, "/lib/x86_64/libdlm_lt.so.3", O_RDONLY|O_CLOEXEC) =
-1 ENOENT (No such file or directory)
stat("/lib/x86_64", 0x7ffd2e462630)     = -1 ENOENT (No such file or directory)
openat(AT_FDCWD, "/lib/libdlm_lt.so.3", O_RDONLY|O_CLOEXEC) = -1
ENOENT (No such file or directory)
stat("/lib", {st_mode=S_IFDIR|0755, st_size=4096, ...}) = 0
openat(AT_FDCWD, "/usr/lib/tls/x86_64/x86_64/libdlm_lt.so.3",
O_RDONLY|O_CLOEXEC) = -1 ENOENT (No such file or directory)
stat("/usr/lib/tls/x86_64/x86_64", 0x7ffd2e462630) = -1 ENOENT (No
such file or directory)
openat(AT_FDCWD, "/usr/lib/tls/x86_64/libdlm_lt.so.3",
O_RDONLY|O_CLOEXEC) = -1 ENOENT (No such file or directory)
stat("/usr/lib/tls/x86_64", 0x7ffd2e462630) = -1 ENOENT (No such file
or directory)
openat(AT_FDCWD, "/usr/lib/tls/x86_64/libdlm_lt.so.3",
O_RDONLY|O_CLOEXEC) = -1 ENOENT (No such file or directory)
stat("/usr/lib/tls/x86_64", 0x7ffd2e462630) = -1 ENOENT (No such file
or directory)
openat(AT_FDCWD, "/usr/lib/tls/libdlm_lt.so.3", O_RDONLY|O_CLOEXEC) =
-1 ENOENT (No such file or directory)
stat("/usr/lib/tls", 0x7ffd2e462630)    = -1 ENOENT (No such file or directory)
openat(AT_FDCWD, "/usr/lib/x86_64/x86_64/libdlm_lt.so.3",
O_RDONLY|O_CLOEXEC) = -1 ENOENT (No such file or directory)
stat("/usr/lib/x86_64/x86_64", 0x7ffd2e462630) = -1 ENOENT (No such
file or directory)
openat(AT_FDCWD, "/usr/lib/x86_64/libdlm_lt.so.3", O_RDONLY|O_CLOEXEC)
= -1 ENOENT (No such file or directory)
stat("/usr/lib/x86_64", 0x7ffd2e462630) = -1 ENOENT (No such file or directory)
openat(AT_FDCWD, "/usr/lib/x86_64/libdlm_lt.so.3", O_RDONLY|O_CLOEXEC)
= -1 ENOENT (No such file or directory)
stat("/usr/lib/x86_64", 0x7ffd2e462630) = -1 ENOENT (No such file or directory)
openat(AT_FDCWD, "/usr/lib/libdlm_lt.so.3", O_RDONLY|O_CLOEXEC) = -1
ENOENT (No such file or directory)
stat("/usr/lib", {st_mode=S_IFDIR|0755, st_size=4096, ...}) = 0
munmap(0x7f3e1985f000, 62948)           = 0
openat(AT_FDCWD, "/etc/ld.so.cache", O_RDONLY|O_CLOEXEC) = 3
fstat(3, {st_mode=S_IFREG|0644, st_size=62948, ...}) = 0
mmap(NULL, 62948, PROT_READ, MAP_PRIVATE, 3, 0) = 0x7f3e1985f000
close(3)                                = 0
openat(AT_FDCWD, "/lib/x86_64-linux-gnu/libcmap.so.4",
O_RDONLY|O_CLOEXEC) = -1 ENOENT (No such file or directory)
openat(AT_FDCWD, "/usr/lib/x86_64-linux-gnu/libcmap.so.4",
O_RDONLY|O_CLOEXEC) = -1 ENOENT (No such file or directory)
openat(AT_FDCWD, "/lib/libcmap.so.4", O_RDONLY|O_CLOEXEC) = -1 ENOENT
(No such file or directory)
openat(AT_FDCWD, "/usr/lib/libcmap.so.4", O_RDONLY|O_CLOEXEC) = -1
ENOENT (No such file or directory)
munmap(0x7f3e1985f000, 62948)           = 0
geteuid()                               = 0
ioctl(-1, GET_ARRAY_INFO, 0x7ffd2e463050) = -1 EBADF (Bad file descriptor)
openat(AT_FDCWD, "/proc/mdstat", O_RDONLY) = 3
fcntl(3, F_SETFD, FD_CLOEXEC)           = 0
fstat(3, {st_mode=S_IFREG|0444, st_size=0, ...}) = 0
read(3, "Personalities : [raid1] [linear]"..., 1024) = 449
read(3, "", 1024)                       = 0
close(3)                                = 0
stat("/sys/block/md90/md", {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
openat(AT_FDCWD, "/sys/block/md90/dev", O_RDONLY) = 3
read(3, "9:90\n", 20)                   = 5
close(3)                                = 0
getpid()                                = 44041
mknod("/dev/.tmp.md.44041:9:90", S_IFBLK|0600, makedev(0x9, 0x5a)) = 0
openat(AT_FDCWD, "/dev/.tmp.md.44041:9:90", O_RDWR|O_EXCL|O_DIRECT) =
-1 EBUSY (Device or resource busy)
unlink("/dev/.tmp.md.44041:9:90")       = 0
getpid()                                = 44041
mknod("/tmp/.tmp.md.44041:9:90", S_IFBLK|0600, makedev(0x9, 0x5a)) = 0
openat(AT_FDCWD, "/tmp/.tmp.md.44041:9:90", O_RDWR|O_EXCL|O_DIRECT) =
-1 EBUSY (Device or resource busy)
unlink("/tmp/.tmp.md.44041:9:90")       = 0
clock_nanosleep(CLOCK_REALTIME, 0, {tv_sec=0, tv_nsec=1000000}, NULL) = 0
getpid()                                = 44041
mknod("/dev/.tmp.md.44041:9:90", S_IFBLK|0600, makedev(0x9, 0x5a)) = 0
openat(AT_FDCWD, "/dev/.tmp.md.44041:9:90", O_RDWR|O_EXCL|O_DIRECT) =
-1 EBUSY (Device or resource busy)
unlink("/dev/.tmp.md.44041:9:90")       = 0
getpid()                                = 44041
mknod("/tmp/.tmp.md.44041:9:90", S_IFBLK|0600, makedev(0x9, 0x5a)) = 0
openat(AT_FDCWD, "/tmp/.tmp.md.44041:9:90", O_RDWR|O_EXCL|O_DIRECT) =
-1 EBUSY (Device or resource busy)
unlink("/tmp/.tmp.md.44041:9:90")       = 0
clock_nanosleep(CLOCK_REALTIME, 0, {tv_sec=0, tv_nsec=2000000}, NULL) = 0
getpid()                                = 44041
mknod("/dev/.tmp.md.44041:9:90", S_IFBLK|0600, makedev(0x9, 0x5a)) = 0
openat(AT_FDCWD, "/dev/.tmp.md.44041:9:90", O_RDWR|O_EXCL|O_DIRECT) =
-1 EBUSY (Device or resource busy)
unlink("/dev/.tmp.md.44041:9:90")       = 0
getpid()                                = 44041
mknod("/tmp/.tmp.md.44041:9:90", S_IFBLK|0600, makedev(0x9, 0x5a)) = 0
openat(AT_FDCWD, "/tmp/.tmp.md.44041:9:90", O_RDWR|O_EXCL|O_DIRECT) =
-1 EBUSY (Device or resource busy)
unlink("/tmp/.tmp.md.44041:9:90")       = 0
clock_nanosleep(CLOCK_REALTIME, 0, {tv_sec=0, tv_nsec=4000000}, NULL) = 0
getpid()                                = 44041
mknod("/dev/.tmp.md.44041:9:90", S_IFBLK|0600, makedev(0x9, 0x5a)) = 0
openat(AT_FDCWD, "/dev/.tmp.md.44041:9:90", O_RDWR|O_EXCL|O_DIRECT) =
-1 EBUSY (Device or resource busy)
unlink("/dev/.tmp.md.44041:9:90")       = 0
getpid()                                = 44041
mknod("/tmp/.tmp.md.44041:9:90", S_IFBLK|0600, makedev(0x9, 0x5a)) = 0
openat(AT_FDCWD, "/tmp/.tmp.md.44041:9:90", O_RDWR|O_EXCL|O_DIRECT) =
-1 EBUSY (Device or resource busy)
unlink("/tmp/.tmp.md.44041:9:90")       = 0
clock_nanosleep(CLOCK_REALTIME, 0, {tv_sec=0, tv_nsec=8000000}, NULL) = 0
getpid()                                = 44041
mknod("/dev/.tmp.md.44041:9:90", S_IFBLK|0600, makedev(0x9, 0x5a)) = 0
openat(AT_FDCWD, "/dev/.tmp.md.44041:9:90", O_RDWR|O_EXCL|O_DIRECT) =
-1 EBUSY (Device or resource busy)
unlink("/dev/.tmp.md.44041:9:90")       = 0
getpid()                                = 44041
mknod("/tmp/.tmp.md.44041:9:90", S_IFBLK|0600, makedev(0x9, 0x5a)) = 0
openat(AT_FDCWD, "/tmp/.tmp.md.44041:9:90", O_RDWR|O_EXCL|O_DIRECT) =
-1 EBUSY (Device or resource busy)
unlink("/tmp/.tmp.md.44041:9:90")       = 0
clock_nanosleep(CLOCK_REALTIME, 0, {tv_sec=0, tv_nsec=16000000}, NULL) = 0
getpid()                                = 44041
mknod("/dev/.tmp.md.44041:9:90", S_IFBLK|0600, makedev(0x9, 0x5a)) = 0
openat(AT_FDCWD, "/dev/.tmp.md.44041:9:90", O_RDWR|O_EXCL|O_DIRECT) =
-1 EBUSY (Device or resource busy)
unlink("/dev/.tmp.md.44041:9:90")       = 0
getpid()                                = 44041
mknod("/tmp/.tmp.md.44041:9:90", S_IFBLK|0600, makedev(0x9, 0x5a)) = 0
openat(AT_FDCWD, "/tmp/.tmp.md.44041:9:90", O_RDWR|O_EXCL|O_DIRECT) =
-1 EBUSY (Device or resource busy)
unlink("/tmp/.tmp.md.44041:9:90")       = 0
clock_nanosleep(CLOCK_REALTIME, 0, {tv_sec=0, tv_nsec=32000000}, NULL) = 0
getpid()                                = 44041
mknod("/dev/.tmp.md.44041:9:90", S_IFBLK|0600, makedev(0x9, 0x5a)) = 0
openat(AT_FDCWD, "/dev/.tmp.md.44041:9:90", O_RDWR|O_EXCL|O_DIRECT) =
-1 EBUSY (Device or resource busy)
unlink("/dev/.tmp.md.44041:9:90")       = 0
getpid()                                = 44041
mknod("/tmp/.tmp.md.44041:9:90", S_IFBLK|0600, makedev(0x9, 0x5a)) = 0
openat(AT_FDCWD, "/tmp/.tmp.md.44041:9:90", O_RDWR|O_EXCL|O_DIRECT) =
-1 EBUSY (Device or resource busy)
unlink("/tmp/.tmp.md.44041:9:90")       = 0
clock_nanosleep(CLOCK_REALTIME, 0, {tv_sec=0, tv_nsec=64000000}, NULL) = 0
getpid()                                = 44041
mknod("/dev/.tmp.md.44041:9:90", S_IFBLK|0600, makedev(0x9, 0x5a)) = 0
openat(AT_FDCWD, "/dev/.tmp.md.44041:9:90", O_RDWR|O_EXCL|O_DIRECT) =
-1 EBUSY (Device or resource busy)
unlink("/dev/.tmp.md.44041:9:90")       = 0
getpid()                                = 44041
mknod("/tmp/.tmp.md.44041:9:90", S_IFBLK|0600, makedev(0x9, 0x5a)) = 0
openat(AT_FDCWD, "/tmp/.tmp.md.44041:9:90", O_RDWR|O_EXCL|O_DIRECT) =
-1 EBUSY (Device or resource busy)
unlink("/tmp/.tmp.md.44041:9:90")       = 0
clock_nanosleep(CLOCK_REALTIME, 0, {tv_sec=0, tv_nsec=128000000}, NULL) = 0
getpid()                                = 44041
mknod("/dev/.tmp.md.44041:9:90", S_IFBLK|0600, makedev(0x9, 0x5a)) = 0
openat(AT_FDCWD, "/dev/.tmp.md.44041:9:90", O_RDWR|O_EXCL|O_DIRECT) =
-1 EBUSY (Device or resource busy)
unlink("/dev/.tmp.md.44041:9:90")       = 0
getpid()                                = 44041
mknod("/tmp/.tmp.md.44041:9:90", S_IFBLK|0600, makedev(0x9, 0x5a)) = 0
openat(AT_FDCWD, "/tmp/.tmp.md.44041:9:90", O_RDWR|O_EXCL|O_DIRECT) =
-1 EBUSY (Device or resource busy)
unlink("/tmp/.tmp.md.44041:9:90")       = 0
clock_nanosleep(CLOCK_REALTIME, 0, {tv_sec=0, tv_nsec=256000000}, NULL) = 0
getpid()                                = 44041
mknod("/dev/.tmp.md.44041:9:90", S_IFBLK|0600, makedev(0x9, 0x5a)) = 0
openat(AT_FDCWD, "/dev/.tmp.md.44041:9:90", O_RDWR|O_EXCL|O_DIRECT) =
-1 EBUSY (Device or resource busy)
unlink("/dev/.tmp.md.44041:9:90")       = 0
getpid()                                = 44041
mknod("/tmp/.tmp.md.44041:9:90", S_IFBLK|0600, makedev(0x9, 0x5a)) = 0
openat(AT_FDCWD, "/tmp/.tmp.md.44041:9:90", O_RDWR|O_EXCL|O_DIRECT) =
-1 EBUSY (Device or resource busy)
unlink("/tmp/.tmp.md.44041:9:90")       = 0
clock_nanosleep(CLOCK_REALTIME, 0, {tv_sec=0, tv_nsec=256000000}, NULL) = 0
getpid()                                = 44041
mknod("/dev/.tmp.md.44041:9:90", S_IFBLK|0600, makedev(0x9, 0x5a)) = 0
openat(AT_FDCWD, "/dev/.tmp.md.44041:9:90", O_RDWR|O_EXCL|O_DIRECT) =
-1 EBUSY (Device or resource busy)
unlink("/dev/.tmp.md.44041:9:90")       = 0
getpid()                                = 44041
mknod("/tmp/.tmp.md.44041:9:90", S_IFBLK|0600, makedev(0x9, 0x5a)) = 0
openat(AT_FDCWD, "/tmp/.tmp.md.44041:9:90", O_RDWR|O_EXCL|O_DIRECT) =
-1 EBUSY (Device or resource busy)
unlink("/tmp/.tmp.md.44041:9:90")       = 0
clock_nanosleep(CLOCK_REALTIME, 0, {tv_sec=0, tv_nsec=256000000}, NULL) = 0
getpid()                                = 44041
mknod("/dev/.tmp.md.44041:9:90", S_IFBLK|0600, makedev(0x9, 0x5a)) = 0
openat(AT_FDCWD, "/dev/.tmp.md.44041:9:90", O_RDWR|O_EXCL|O_DIRECT) =
-1 EBUSY (Device or resource busy)
unlink("/dev/.tmp.md.44041:9:90")       = 0
getpid()                                = 44041
mknod("/tmp/.tmp.md.44041:9:90", S_IFBLK|0600, makedev(0x9, 0x5a)) = 0
openat(AT_FDCWD, "/tmp/.tmp.md.44041:9:90", O_RDWR|O_EXCL|O_DIRECT) =
-1 EBUSY (Device or resource busy)
unlink("/tmp/.tmp.md.44041:9:90")       = 0
clock_nanosleep(CLOCK_REALTIME, 0, {tv_sec=0, tv_nsec=256000000}, NULL) = 0
getpid()                                = 44041
mknod("/dev/.tmp.md.44041:9:90", S_IFBLK|0600, makedev(0x9, 0x5a)) = 0
openat(AT_FDCWD, "/dev/.tmp.md.44041:9:90", O_RDWR|O_EXCL|O_DIRECT) =
-1 EBUSY (Device or resource busy)
unlink("/dev/.tmp.md.44041:9:90")       = 0
getpid()                                = 44041
mknod("/tmp/.tmp.md.44041:9:90", S_IFBLK|0600, makedev(0x9, 0x5a)) = 0
openat(AT_FDCWD, "/tmp/.tmp.md.44041:9:90", O_RDWR|O_EXCL|O_DIRECT) =
-1 EBUSY (Device or resource busy)
unlink("/tmp/.tmp.md.44041:9:90")       = 0
clock_nanosleep(CLOCK_REALTIME, 0, {tv_sec=0, tv_nsec=256000000}, NULL) = 0
getpid()                                = 44041
mknod("/dev/.tmp.md.44041:9:90", S_IFBLK|0600, makedev(0x9, 0x5a)) = 0
openat(AT_FDCWD, "/dev/.tmp.md.44041:9:90", O_RDWR|O_EXCL|O_DIRECT) =
-1 EBUSY (Device or resource busy)
unlink("/dev/.tmp.md.44041:9:90")       = 0
getpid()                                = 44041
mknod("/tmp/.tmp.md.44041:9:90", S_IFBLK|0600, makedev(0x9, 0x5a)) = 0
openat(AT_FDCWD, "/tmp/.tmp.md.44041:9:90", O_RDWR|O_EXCL|O_DIRECT) =
-1 EBUSY (Device or resource busy)
unlink("/tmp/.tmp.md.44041:9:90")       = 0
clock_nanosleep(CLOCK_REALTIME, 0, {tv_sec=0, tv_nsec=256000000}, NULL) = 0
getpid()                                = 44041
mknod("/dev/.tmp.md.44041:9:90", S_IFBLK|0600, makedev(0x9, 0x5a)) = 0
openat(AT_FDCWD, "/dev/.tmp.md.44041:9:90", O_RDWR|O_EXCL|O_DIRECT) =
-1 EBUSY (Device or resource busy)
unlink("/dev/.tmp.md.44041:9:90")       = 0
getpid()                                = 44041
mknod("/tmp/.tmp.md.44041:9:90", S_IFBLK|0600, makedev(0x9, 0x5a)) = 0
openat(AT_FDCWD, "/tmp/.tmp.md.44041:9:90", O_RDWR|O_EXCL|O_DIRECT) =
-1 EBUSY (Device or resource busy)
unlink("/tmp/.tmp.md.44041:9:90")       = 0
clock_nanosleep(CLOCK_REALTIME, 0, {tv_sec=0, tv_nsec=256000000}, NULL) = 0
getpid()                                = 44041
mknod("/dev/.tmp.md.44041:9:90", S_IFBLK|0600, makedev(0x9, 0x5a)) = 0
openat(AT_FDCWD, "/dev/.tmp.md.44041:9:90", O_RDWR|O_EXCL|O_DIRECT) =
-1 EBUSY (Device or resource busy)
unlink("/dev/.tmp.md.44041:9:90")       = 0
getpid()                                = 44041
mknod("/tmp/.tmp.md.44041:9:90", S_IFBLK|0600, makedev(0x9, 0x5a)) = 0
openat(AT_FDCWD, "/tmp/.tmp.md.44041:9:90", O_RDWR|O_EXCL|O_DIRECT) =
-1 EBUSY (Device or resource busy)
unlink("/tmp/.tmp.md.44041:9:90")       = 0
clock_nanosleep(CLOCK_REALTIME, 0, {tv_sec=0, tv_nsec=256000000}, NULL) = 0
getpid()                                = 44041
mknod("/dev/.tmp.md.44041:9:90", S_IFBLK|0600, makedev(0x9, 0x5a)) = 0
openat(AT_FDCWD, "/dev/.tmp.md.44041:9:90", O_RDWR|O_EXCL|O_DIRECT) =
-1 EBUSY (Device or resource busy)
unlink("/dev/.tmp.md.44041:9:90")       = 0
getpid()                                = 44041
mknod("/tmp/.tmp.md.44041:9:90", S_IFBLK|0600, makedev(0x9, 0x5a)) = 0
openat(AT_FDCWD, "/tmp/.tmp.md.44041:9:90", O_RDWR|O_EXCL|O_DIRECT) =
-1 EBUSY (Device or resource busy)
unlink("/tmp/.tmp.md.44041:9:90")       = 0
clock_nanosleep(CLOCK_REALTIME, 0, {tv_sec=0, tv_nsec=256000000}, NULL) = 0
getpid()                                = 44041
mknod("/dev/.tmp.md.44041:9:90", S_IFBLK|0600, makedev(0x9, 0x5a)) = 0
openat(AT_FDCWD, "/dev/.tmp.md.44041:9:90", O_RDWR|O_EXCL|O_DIRECT) =
-1 EBUSY (Device or resource busy)
unlink("/dev/.tmp.md.44041:9:90")       = 0
getpid()                                = 44041
mknod("/tmp/.tmp.md.44041:9:90", S_IFBLK|0600, makedev(0x9, 0x5a)) = 0
openat(AT_FDCWD, "/tmp/.tmp.md.44041:9:90", O_RDWR|O_EXCL|O_DIRECT) =
-1 EBUSY (Device or resource busy)
unlink("/tmp/.tmp.md.44041:9:90")       = 0
clock_nanosleep(CLOCK_REALTIME, 0, {tv_sec=0, tv_nsec=256000000}, NULL) = 0
getpid()                                = 44041
mknod("/dev/.tmp.md.44041:9:90", S_IFBLK|0600, makedev(0x9, 0x5a)) = 0
openat(AT_FDCWD, "/dev/.tmp.md.44041:9:90", O_RDWR|O_EXCL|O_DIRECT) =
-1 EBUSY (Device or resource busy)
unlink("/dev/.tmp.md.44041:9:90")       = 0
getpid()                                = 44041
mknod("/tmp/.tmp.md.44041:9:90", S_IFBLK|0600, makedev(0x9, 0x5a)) = 0
openat(AT_FDCWD, "/tmp/.tmp.md.44041:9:90", O_RDWR|O_EXCL|O_DIRECT) =
-1 EBUSY (Device or resource busy)
unlink("/tmp/.tmp.md.44041:9:90")       = 0
clock_nanosleep(CLOCK_REALTIME, 0, {tv_sec=0, tv_nsec=256000000}, NULL) = 0
getpid()                                = 44041
mknod("/dev/.tmp.md.44041:9:90", S_IFBLK|0600, makedev(0x9, 0x5a)) = 0
openat(AT_FDCWD, "/dev/.tmp.md.44041:9:90", O_RDWR|O_EXCL|O_DIRECT) =
-1 EBUSY (Device or resource busy)
unlink("/dev/.tmp.md.44041:9:90")       = 0
getpid()                                = 44041
mknod("/tmp/.tmp.md.44041:9:90", S_IFBLK|0600, makedev(0x9, 0x5a)) = 0
openat(AT_FDCWD, "/tmp/.tmp.md.44041:9:90", O_RDWR|O_EXCL|O_DIRECT) =
-1 EBUSY (Device or resource busy)
unlink("/tmp/.tmp.md.44041:9:90")       = 0
clock_nanosleep(CLOCK_REALTIME, 0, {tv_sec=0, tv_nsec=256000000}, NULL) = 0
getpid()                                = 44041
mknod("/dev/.tmp.md.44041:9:90", S_IFBLK|0600, makedev(0x9, 0x5a)) = 0
openat(AT_FDCWD, "/dev/.tmp.md.44041:9:90", O_RDWR|O_EXCL|O_DIRECT) =
-1 EBUSY (Device or resource busy)
unlink("/dev/.tmp.md.44041:9:90")       = 0
getpid()                                = 44041
mknod("/tmp/.tmp.md.44041:9:90", S_IFBLK|0600, makedev(0x9, 0x5a)) = 0
openat(AT_FDCWD, "/tmp/.tmp.md.44041:9:90", O_RDWR|O_EXCL|O_DIRECT) =
-1 EBUSY (Device or resource busy)
unlink("/tmp/.tmp.md.44041:9:90")       = 0
clock_nanosleep(CLOCK_REALTIME, 0, {tv_sec=0, tv_nsec=256000000}, NULL) = 0
getpid()                                = 44041
mknod("/dev/.tmp.md.44041:9:90", S_IFBLK|0600, makedev(0x9, 0x5a)) = 0
openat(AT_FDCWD, "/dev/.tmp.md.44041:9:90", O_RDWR|O_EXCL|O_DIRECT) =
-1 EBUSY (Device or resource busy)
unlink("/dev/.tmp.md.44041:9:90")       = 0
getpid()                                = 44041
mknod("/tmp/.tmp.md.44041:9:90", S_IFBLK|0600, makedev(0x9, 0x5a)) = 0
openat(AT_FDCWD, "/tmp/.tmp.md.44041:9:90", O_RDWR|O_EXCL|O_DIRECT) =
-1 EBUSY (Device or resource busy)
unlink("/tmp/.tmp.md.44041:9:90")       = 0
clock_nanosleep(CLOCK_REALTIME, 0, {tv_sec=0, tv_nsec=256000000}, NULL) = 0
getpid()                                = 44041
mknod("/dev/.tmp.md.44041:9:90", S_IFBLK|0600, makedev(0x9, 0x5a)) = 0
openat(AT_FDCWD, "/dev/.tmp.md.44041:9:90", O_RDWR|O_EXCL|O_DIRECT) =
-1 EBUSY (Device or resource busy)
unlink("/dev/.tmp.md.44041:9:90")       = 0
getpid()                                = 44041
mknod("/tmp/.tmp.md.44041:9:90", S_IFBLK|0600, makedev(0x9, 0x5a)) = 0
openat(AT_FDCWD, "/tmp/.tmp.md.44041:9:90", O_RDWR|O_EXCL|O_DIRECT) =
-1 EBUSY (Device or resource busy)
unlink("/tmp/.tmp.md.44041:9:90")       = 0
clock_nanosleep(CLOCK_REALTIME, 0, {tv_sec=0, tv_nsec=256000000}, NULL) = 0
getpid()                                = 44041
mknod("/dev/.tmp.md.44041:9:90", S_IFBLK|0600, makedev(0x9, 0x5a)) = 0
openat(AT_FDCWD, "/dev/.tmp.md.44041:9:90", O_RDWR|O_EXCL|O_DIRECT) =
-1 EBUSY (Device or resource busy)
unlink("/dev/.tmp.md.44041:9:90")       = 0
getpid()                                = 44041
mknod("/tmp/.tmp.md.44041:9:90", S_IFBLK|0600, makedev(0x9, 0x5a)) = 0
openat(AT_FDCWD, "/tmp/.tmp.md.44041:9:90", O_RDWR|O_EXCL|O_DIRECT) =
-1 EBUSY (Device or resource busy)
unlink("/tmp/.tmp.md.44041:9:90")       = 0
clock_nanosleep(CLOCK_REALTIME, 0, {tv_sec=0, tv_nsec=256000000}, NULL) = 0
getpid()                                = 44041
mknod("/dev/.tmp.md.44041:9:90", S_IFBLK|0600, makedev(0x9, 0x5a)) = 0
openat(AT_FDCWD, "/dev/.tmp.md.44041:9:90", O_RDWR|O_EXCL|O_DIRECT) =
-1 EBUSY (Device or resource busy)
unlink("/dev/.tmp.md.44041:9:90")       = 0
getpid()                                = 44041
mknod("/tmp/.tmp.md.44041:9:90", S_IFBLK|0600, makedev(0x9, 0x5a)) = 0
openat(AT_FDCWD, "/tmp/.tmp.md.44041:9:90", O_RDWR|O_EXCL|O_DIRECT) =
-1 EBUSY (Device or resource busy)
unlink("/tmp/.tmp.md.44041:9:90")       = 0
clock_nanosleep(CLOCK_REALTIME, 0, {tv_sec=0, tv_nsec=256000000}, NULL) = 0
openat(AT_FDCWD, "/sys/block/md90/dev", O_RDONLY) = 3
read(3, "9:90\n", 20)                   = 5
close(3)                                = 0
getpid()                                = 44041
mknod("/dev/.tmp.md.44041:9:90", S_IFBLK|0600, makedev(0x9, 0x5a)) = 0
openat(AT_FDCWD, "/dev/.tmp.md.44041:9:90", O_RDONLY|O_DIRECT) = 3
unlink("/dev/.tmp.md.44041:9:90")       = 0
openat(AT_FDCWD, "/run/mdadm/map", O_RDONLY) = 4
fcntl(4, F_GETFL)                       = 0x8000 (flags O_RDONLY|O_LARGEFILE)
fstat(4, {st_mode=S_IFREG|0600, st_size=164, ...}) = 0
read(4, "md90 1.2 36ddfdb1:8625d559:73510"..., 4096) = 164
read(4, "", 4096)                       = 0
close(4)                                = 0
openat(AT_FDCWD, "/proc/mdstat", O_RDONLY) = 4
fcntl(4, F_SETFD, FD_CLOEXEC)           = 0
fstat(4, {st_mode=S_IFREG|0444, st_size=0, ...}) = 0
read(4, "Personalities : [raid1] [linear]"..., 1024) = 449
read(4, "", 1024)                       = 0
close(4)                                = 0
mkdir("/run/mdadm/failed-slots", 0700)  = 0
openat(AT_FDCWD, "/run/mdadm/failed-slots/pci-0000:02:00.0-ata-1",
O_WRONLY|O_CREAT|O_TRUNC, 0666) = 4
fstat(4, {st_mode=S_IFREG|0644, st_size=0, ...}) = 0
write(4, "1.2 36ddfdb1:8625d559:73510620:8"..., 40) = 40
close(4)                                = 0
fstat(3, {st_mode=S_IFBLK|0600, st_rdev=makedev(0x9, 0x5a), ...}) = 0
readlink("/sys/dev/block/9:90", "../../devices/virtual/block/md90", 199) = 32
stat("/sys/block/md90/md", {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
ioctl(3, GET_ARRAY_INFO, 0x7ffd2e462600) = 0
fstat(3, {st_mode=S_IFBLK|0600, st_rdev=makedev(0x9, 0x5a), ...}) = 0
readlink("/sys/dev/block/9:90", "../../devices/virtual/block/md90", 199) = 32
openat(AT_FDCWD, "/sys/block/md90/md/component_size", O_RDONLY) = 4
read(4, "488253440\n", 120)             = 10
close(4)                                = 0
fstat(3, {st_mode=S_IFBLK|0600, st_rdev=makedev(0x9, 0x5a), ...}) = 0
readlink("/sys/dev/block/9:90", "../../devices/virtual/block/md90", 199) = 32
stat("/sys/block/md90/md", {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
openat(AT_FDCWD, "/sys/block/md90/md/metadata_version", O_RDONLY) = 4
read(4, "1.2\n", 4096)                  = 4
close(4)                                = 0
fstat(3, {st_mode=S_IFBLK|0600, st_rdev=makedev(0x9, 0x5a), ...}) = 0
readlink("/sys/dev/block/9:90", "../../devices/virtual/block/md90", 199) = 32
fstat(3, {st_mode=S_IFBLK|0600, st_rdev=makedev(0x9, 0x5a), ...}) = 0
readlink("/sys/dev/block/9:90", "../../devices/virtual/block/md90", 199) = 32
openat(AT_FDCWD, "/sys/block/md90/md/dev-sdc1/block/dev", O_RDWR) = -1
EACCES (Permission denied)
openat(AT_FDCWD, "/sys/block/md90/md/dev-sdc1/block/dev", O_RDONLY) = 4
lseek(4, 0, SEEK_SET)                   = 0
read(4, "8:33\n", 20)                   = 5
close(4)                                = 0
ioctl(3, SET_DISK_FAULTY, 0x821)        = -1 EBUSY (Device or resource busy)
write(2, "mdadm: set device faulty failed "..., 67mdadm: set device
faulty failed for sdc1:  Device or resource busy
) = 67
openat(AT_FDCWD, "/sys/block/md90/dev", O_RDONLY) = 4
read(4, "9:90\n", 20)                   = 5
close(4)                                = 0
