Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,HK_RANDOM_FROM,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 390D8C2D0A3
	for <linux-raid@archiver.kernel.org>; Mon,  9 Nov 2020 15:35:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CB237206C0
	for <linux-raid@archiver.kernel.org>; Mon,  9 Nov 2020 15:35:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729776AbgKIPfo (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 9 Nov 2020 10:35:44 -0500
Received: from air.basealt.ru ([194.107.17.39]:53526 "EHLO air.basealt.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727077AbgKIPfo (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Mon, 9 Nov 2020 10:35:44 -0500
Received: by air.basealt.ru (Postfix, from userid 490)
        id 9E2B958941D; Mon,  9 Nov 2020 15:35:38 +0000 (UTC)
Received: from [192.168.1.209] (unknown [195.112.109.163])
        by air.basealt.ru (Postfix) with ESMTPSA id BAC0658941A
        for <linux-raid@vger.kernel.org>; Mon,  9 Nov 2020 15:35:36 +0000 (UTC)
Subject: deadlock while close() after ioctl STOP_ARRAY
References: <55e9b4d4-5a80-e862-6cc4-0e389239017e@basealt.ru>
To:     linux-raid@vger.kernel.org
From:   Slava Aseev <nullptrnine@basealt.ru>
X-Forwarded-Message-Id: <55e9b4d4-5a80-e862-6cc4-0e389239017e@basealt.ru>
Message-ID: <e07df955-ec50-ebaa-635f-bca0f9e4ecae@basealt.ru>
Date:   Mon, 9 Nov 2020 18:35:36 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <55e9b4d4-5a80-e862-6cc4-0e389239017e@basealt.ru>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hello!

Recently I found a bug that occurs a deadlock in the 5.4.48 <= kernel <=
5.4.75.
Test code is pretty simple:

#include <stdio.h>
#include <stdlib.h>
#include <sys/ioctl.h>
#include <linux/raid/md_u.h>
#include <fcntl.h>
#include <unistd.h>

#define MD_MAJOR 9

int main(int argc, char* argv[]) {
if (argc < 2) {
fprintf(stderr, "Missing raid name\n");
return EXIT_FAILURE;
}

int fd = open(argv[1], O_RDWR);
if (fd <= 0) {
fprintf(stderr, "Can't open raid at '%s'\n", argv[1]);
return EXIT_FAILURE;
}

int rc = ioctl(fd, STOP_ARRAY, NULL);
if (rc) {
fprintf(stderr, "ioctl STOP_ARRAY failed for device '%s' rc = %d\n",
argv[1], rc);
close(fd);
return EXIT_FAILURE;
}

/* Deadlock?! */
close(fd);

return EXIT_SUCCESS;
}

When I run this with "/dev/md0" argument (superblock 1.2, raid 1, 2
nodes) I got freezing systemd-udevd process and this:

...
[ +11.638855] md0: detected capacity change from 1071644672 to 0
[ +0.000136] md: md0 stopped.
[ +15.303036] [drm:drm_atomic_helper_wait_for_dependencies
[drm_kms_helper]] *ERROR* [CRTC:38:crtc-0] flip_done timed out
[Nov 3 13:15] watchdog: BUG: soft lockup - CPU#1 stuck for 22s!
[systemd-udevd:2439]
[ +0.000003] Modules linked in: af_packet(E) rfkill(E) hid_generic(E)
usbhid(E) hid(E) raid1(E) nls_utf8(E) nls_cp866(E) vfat(E) fat(E)
intel_rapl_msr(E) intel_rapl_common(E) pktcdvd(E) ohci_pci(E)
ehci_pci(E) intel_pmc_core_pltdrv(E) ohci_hcd(E) intel_pmc_core(E)
crct10dif_pclmul(E) crc32_pclmul(E) ehci_hcd(E) video(E)
ghash_clmulni_intel(E) aesni_intel(E) usbcore(E) sr_mod(E) e1000(E)
crypto_simd(E) usb_common(E) snd_intel8x0(E) cdrom(E) snd_ac97_codec(E)
cryptd(E) snd_pcm(E) glue_helper(E) i2c_piix4(E) ac97_bus(E) joydev(E)
psmouse(E) ac(E) pcspkr(E) battery(E) sch_fq_codel(E) vboxsf(OE)
vboxguest(OE) snd_seq_midi(E) snd_seq_midi_event(E) snd_seq(E)
snd_rawmidi(E) snd_seq_device(E) snd_timer(E) snd(E) soundcore(E)
button(E) ip_tables(E) x_tables(E) ext4(E) crc32c_generic(E) crc16(E)
mbcache(E) jbd2(E) ipv6(E) crc_ccitt(E) sd_mod(E) ata_generic(E)
pata_acpi(E) crc32c_intel(E) evdev(E) input_leds(E) vmwgfx(E)
serio_raw(E) drm_kms_helper(E) ata_piix(E) ttm(E) libata(E) drm(E)
scsi_mod(E)
[ +0.000029] intel_agp(E) intel_gtt(E) autofs4(E)
[ +0.000003] CPU: 1 PID: 2439 Comm: systemd-udevd Tainted: G OE
5.4.74-std-def-alt1 #1
[ +0.000001] Hardware name: innotek GmbH VirtualBox/VirtualBox, BIOS
VirtualBox 12/01/2006
[ +0.000010] RIP: 0010:md_open+0x16/0xd0
[ +0.000002] Code: bf ff e9 9b fe ff ff 0f 0b 0f 0b 0f 0b 0f 1f 80 00 00
00 00 0f 1f 44 00 00 41 56 41 55 41 54 49 89 fc 55 8b 3f e8 6a fd ff ff
<48> 85 c0 0f 84 a4 00 00 00 48 89 c5 49 8b 84 24 80 00 00 00 48 39
[ +0.000001] RSP: 0018:ffffc9000019bc10 EFLAGS: 00000287 ORIG_RAX:
ffffffffffffff13
[ +0.000002] RAX: ffff88807b521000 RBX: ffff88807bb7f6c0 RCX:
0000000000000000
[ +0.000000] RDX: ffff88807b5213d8 RSI: 000000000800005d RDI:
0000000000000000
[ +0.000001] RBP: ffff88807bb7f6d8 R08: 0000000000000001 R09:
ffff88807b521000
[ +0.000001] R10: 0000000000000001 R11: 0000000000000000 R12:
ffff88807bb7f6c0
[ +0.000000] R13: 000000000800005d R14: 0000000000000001 R15:
ffff88807b5ac800
[ +0.000002] FS: 00007fb2b99938c0(0000) GS:ffff88807db00000(0000)
knlGS:0000000000000000
[ +0.000000] CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ +0.000001] CR2: 000056264c0219a0 CR3: 000000007adaa001 CR4:
00000000000606e0
[ +0.000002] Call Trace:
[ +0.000014] __blkdev_get+0xe1/0x550
[ +0.000006] ? blkdev_get_by_dev+0x50/0x50
[ +0.000001] blkdev_get+0x38/0x130
[ +0.000001] ? bd_acquire+0xbc/0xf0
[ +0.000001] ? blkdev_get_by_dev+0x50/0x50
[ +0.000002] do_dentry_open+0x13d/0x3a0
[ +0.000004] path_openat+0x570/0x1630
[ +0.000003] do_filp_open+0x91/0x100
[ +0.000002] ? kmem_cache_alloc+0x1ca/0x580
[ +0.000001] ? __check_object_size+0x130/0x141
[ +0.000002] do_sys_open+0x184/0x220
[ +0.000003] do_syscall_64+0x5c/0x140
[ +0.000019] entry_SYSCALL_64_after_hwframe+0x44/0xa9
[ +0.000004] RIP: 0033:0x7fb2b9eb35f7
[ +0.000002] Code: 25 00 00 41 00 3d 00 00 41 00 74 47 64 8b 04 25 18 00
00 00 85 c0 75 6b 44 89 e2 48 89 ee bf 9c ff ff ff b8 01 01 00 00 0f 05
<48> 3d 00 f0 ff ff 0f 87 95 00 00 00 48 8b 4c 24 28 64 48 33 0c 25
[ +0.000000] RSP: 002b:00007ffd6fe55e90 EFLAGS: 00000246 ORIG_RAX:
0000000000000101
[ +0.000001] RAX: ffffffffffffffda RBX: 00007ffd6fe55fa0 RCX:
00007fb2b9eb35f7
[ +0.000001] RDX: 00000000000a0800 RSI: 000056264bfe6bb0 RDI:
00000000ffffff9c
[ +0.000001] RBP: 000056264bfe6bb0 R08: 000056264a2e1bb0 R09:
000056264be38010
[ +0.000000] R10: 0000000000000000 R11: 0000000000000246 R12:
00000000000a0800
[ +0.000001] R13: 000056264a2c777a R14: 000056264c03e910 R15:
00007ffd6fe55f68
[ +0.108262] [drm:drm_atomic_helper_wait_for_dependencies
[drm_kms_helper]] *ERROR* [PLANE:34:plane-0] flip_done timed out
[ +27.888719] watchdog: BUG: soft lockup - CPU#1 stuck for 22s!
[systemd-udevd:2439]
...

Kernel with debug options shows this in dmesg:

|[ +0.000001] WARNING: possible recursive locking detected [ +0.000002]
5.4.72-std-debug-alt1 #1 Tainted: G E [ +0.000001]
-------------------------------------------- [ +0.000001]
systemd-udevd/2480 is trying to acquire lock: [ +0.000001]
ffff88803f2f7088 (&bdev->bd_mutex){+.+.}, at: __blkdev_get+0x7a/0x590 [
+0.000009] but task is already holding lock: [ +0.000001]
ffff888077107708 (&bdev->bd_mutex){+.+.}, at: __blkdev_get+0x7a/0x590 [
+0.000002] other info that might help us debug this: [ +0.000001]
Possible unsafe locking scenario: [ +0.000001] CPU0 [ +0.000001] ---- [
+0.000001] lock(&bdev->bd_mutex); [ +0.000001] lock(&bdev->bd_mutex); [
+0.000001] *** DEADLOCK *** [ +0.000001] May be due to missing lock
nesting notation [ +0.000001] 3 locks held by systemd-udevd/2480: [
+0.000001] #0: ffff888077107708 (&bdev->bd_mutex){+.+.}, at:
__blkdev_get+0x7a/0x590 [ +0.000003] #1: ffffffffa06c74d0
(pktcdvd_mutex){+.+.}, at: pkt_open+0x37/0x4c0 [pktcdvd] [ +0.000004]
#2: ffffffffa06c7fd0 (&ctl_mutex#2){+.+.}, at: pkt_open+0x45/0x4c0
[pktcdvd] [ +0.000003] stack backtrace: [ +0.000002] CPU: 0 PID: 2480
Comm: systemd-udevd Tainted: G E 5.4.72-std-debug-alt1 #1 [ +0.000002]
Hardware name: innotek GmbH VirtualBox/VirtualBox, BIOS VirtualBox
12/01/2006 [ +0.000001] Call Trace: [ +0.000005] dump_stack+0xac/0xec [
+0.000006] __lock_acquire.cold+0x121/0x1f5 [ +0.000003]
lock_acquire+0xbb/0x1e0 [ +0.000002] ? __blkdev_get+0x7a/0x590 [
+0.000004] __mutex_lock+0xa7/0x990 [ +0.000001] ?
__blkdev_get+0x7a/0x590 [ +0.000002] ? mark_held_locks+0x50/0x80 [
+0.000003] ? kvm_sched_clock_read+0x14/0x30 [ +0.000002] ?
sched_clock+0xf/0x20 [ +0.000002] ? sched_clock_cpu+0xc/0xc0 [
+0.000002] ? __blkdev_get+0x7a/0x590 [ +0.000003] ?
__blkdev_get+0x7a/0x590 [ +0.000001] __blkdev_get+0x7a/0x590 [
+0.000002] blkdev_get+0x85/0x150 [ +0.000003] pkt_open+0x120/0x4c0
[pktcdvd] [ +0.000003] __blkdev_get+0xed/0x590 [ +0.000002] ?
blkdev_get_by_dev+0x50/0x50 [ +0.000002] blkdev_get+0x38/0x150 [
+0.000002] ? blkdev_get_by_dev+0x50/0x50 [ +0.000002]
do_dentry_open+0x14c/0x3e0 [ +0.000002] path_openat+0x509/0xc60 [
+0.000003] do_filp_open+0x91/0x100 [ +0.000003] ?
do_raw_spin_unlock+0x55/0xd0 [ +0.000001] ? _raw_spin_unlock+0x24/0x30 [
+0.000003] ? __alloc_fd+0xe9/0x1d0 [ +0.000002] do_sys_open+0x184/0x220
[ +0.000005] do_syscall_64+0x64/0x200 [ +0.000002]
entry_SYSCALL_64_after_hwframe+0x49/0xbe|

This bug appears after this commit:

https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/commit/?h=v5.4.74&id=cd4013947eae450d93ec02f39c552ad73186a80f

After reverting this commit (or in 5.4.47) all works fine, but I don't
understand how this commit could have affect.

This bug may not be reproduced after first try (and maybe after 100th)
but its never reproduces after reverting this commit (~= 2-3K attempts
were made) Also mdadm -S /dev/md0 works without problems.

Call trace is different every "soft-lockup print iteration", looks like
dmesg prints random call trace of the problem process every 20s. Maybe
it is endless restart here:
https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/tree/fs/block_dev.c?h=v5.4.74#n1577
due to -ERESTARTSYS from here:
https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/tree/drivers/md/md.c?h=v5.4.74#n7593

So, I can't understand, why this happens, and need a help.

https://bugzilla.kernel.org/show_bug.cgi?id=210019

-- 
Best regards,
Slava Aseev


