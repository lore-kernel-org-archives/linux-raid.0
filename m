Received: from forward100a.mail.yandex.net (forward100a.mail.yandex.net [178.154.239.83])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73FE913D538;
	Fri, 12 Jul 2024 06:53:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.154.239.83
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720767209; cv=none; b=WLyZrzHBtEAXoc57ybxvkvpATPfc8fvjQ6cPHlAKKZz9iwL1nzKuZnqhWQARYNiOSu7kvDBP3KdLA+cjQa7TzbE31YipsUztendTzRj5ltuB/JbNIERTUeOPsW3FIQ1CaDIpJvPU5gbcXAISpB+OyDLTeAH6+afpfJFCX5n1Xgs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720767209; c=relaxed/simple;
	bh=lQr3zTV4Hs4Qve7Qg4aH4x9tajKv/zU8LjRs62XLFJU=;
	h=Message-ID:Subject:From:To:Date:Content-Type:MIME-Version; b=cTMgXqob3MvHBq0S+2IUuEn6q5F19wYmqgyNxF60JQqDPdM2u07BjIuJQTpgyUYbfUI6Eatrrc58TQ1fUoniAvHLKxJUbUbn3HgTG6KdedxELKvVyKmy9UqndqHiNhI81LKnTAKpC46yLIa4Y1jHjvEF9EVsFhsSSvlm++gFDCQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex.ru; spf=pass smtp.mailfrom=yandex.ru; dkim=pass (1024-bit key) header.d=yandex.ru header.i=@yandex.ru header.b=AipPJD7b; arc=none smtp.client-ip=178.154.239.83
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yandex.ru
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=yandex.ru header.i=@yandex.ru header.b="AipPJD7b"
Received: from mail-nwsmtp-smtp-production-main-74.vla.yp-c.yandex.net (mail-nwsmtp-smtp-production-main-74.vla.yp-c.yandex.net [IPv6:2a02:6b8:c1f:610c:0:640:1005:0])
	by forward100a.mail.yandex.net (Yandex) with ESMTPS id 868A146DDF;
	Fri, 12 Jul 2024 09:53:16 +0300 (MSK)
Received: by mail-nwsmtp-smtp-production-main-74.vla.yp-c.yandex.net (smtp/Yandex) with ESMTPSA id ErZAAk8r94Y0-BFVgIa0Q;
	Fri, 12 Jul 2024 09:53:15 +0300
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex.ru; s=mail;
	t=1720767195; bh=s0W+M7SwbaRwDy5FEB7++51ukOT+SMdA/kwv36UdyZA=;
	h=Date:To:From:Subject:Message-ID;
	b=AipPJD7b8v/04bB12hqVsVe0cnQQcT6S62HPJ9WjyYdfkKVABl6iBwKfxQ+0jCv0L
	 TJMk/1crh2btfkrh5yGeJbON6tcc3f2JLOJj7LNzeg49LzF5EzdrrJLLt3YZWEfkhy
	 gclio198T/ZpjQdKiHsk+9g2wDbhOJEiWoHC2Miw=
Authentication-Results: mail-nwsmtp-smtp-production-main-74.vla.yp-c.yandex.net; dkim=pass header.i=@yandex.ru
Message-ID: <a6d068a26a90057fb3cdaa59f9d57a2af41a6b22.camel@yandex.ru>
Subject: Lockup of (raid5 or raid6) + vdo after taking out a disk under load
From: Konstantin Kharlamov <Hi-Angel@yandex.ru>
To: Song Liu <song@kernel.org>, Yu Kuai <yukuai3@huawei.com>, 
	linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Fri, 12 Jul 2024 09:53:14 +0300
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.52.3 
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

(this is a dup of yesterday's bugzilla bug 219030 as some maintainers
prefer bugreporting over bugzilla some over ML, and the cases are
indistinguishable)

We're seeing this on both LTS `6.1.97` as well the newest stable
`6.9.8` (note though that VDO was only merged in 6.9, so for upstream
it's probably the only one that matters. Traces below are from 6.9.8).

Creating a raid5 (alternatively raid6) + VDO, then starting a load and
after a minute physically taking out a disk of the VG results in a
lockup stack getting spammed over and over.

Seems unreproducible by removing a disk through software means of
`/sys/block/sdX/device/delete`, i.e. it seem to only happen when either
removing the disk physically or by disabling power on the JBOD slot
with a command like `sg_ses --dev-slot-num=3D9 --set=3D3:4:1 /dev/sg26`.

Also when lockup happens, `reboot -ff` no longer does anything.

When looking at repeating stacktraces, the execution seems to loop
around `raid5_get_active_stripe`, `raid5_compute_sector`,
`raid5_release_stripe`.

# Steps to reproduce

1. Create raid5 LV + VDO by executing a `./mk_lvm_raid5.sh /dev/sdX1
/dev/sdY1 /dev/sdZ1` where `mk_lvm_raid5.sh` has the following content:

    #!/bin/bash

    set -exu

    if [ "$#" -ne 3 ]; then
        echo "Wrong number of parameters.
    Usage: $(basename $0) disk1 disk2 disk3"
        exit 1
    fi

    # create the VG
    pvcreate -f "$1" "$2" "$3"
    vgcreate p_r5 "$1" "$2" "$3"

    # create the LV
    lvcreate --type raid5 -i 2 -L 21474836480b -I 64K -n
vdo_internal_deco_vol p_r5 -y
    lvconvert -y --type vdo-pool --virtualsize 107374182400B -n
deco_vol p_r5/vdo_internal_deco_vol

2. Start load by executing `fio ./fio-30%write.fio` with the `fio-
30%write.fio` having the following content:

    [test IOPS]
    blocksize=3D8k
    filename=3D/dev/p_r5/deco_vol
    filesize=3D100G
    direct=3D1
    buffered=3D0
    ioengine=3Dlibaio
    iodepth=3D32
    rw=3Drandrw
    rwmixwrite=3D30
    numjobs=3D4
    group_reporting
    time_based
    runtime=3D99h
    clat_percentiles=3D0
    unlink=3D1

3. Wait for about a minute
4. Remove a disk of the volume group, either physically, or by turning
off jbod slot's power (DO NOT use /=E2=80=A6/device/delete).
5. Wait 30 seconds

## Expected

`dmesg -w` won't show anything interesting

## Actual

`dmesg -w` starts showing up traces as follows (not sure why the
missing line numbers, I have debug symbols locally, I can decode them
manually with `gdb` if needed):

    [=E2=80=A6]
    [  869.086048] mpt3sas_cm0: log_info(0x31110e05): originator(PL),
code(0x11), sub_code(0x0e05)
    [  869.139959] mpt3sas_cm0: mpt3sas_transport_port_remove: removed:
sas_addr(0x5002538a67b01303)
    [  869.140085] mpt3sas_cm0: removing handle(0x0022),
sas_addr(0x5002538a67b01303)
    [  869.140191] mpt3sas_cm0: enclosure logical
id(0x50015b2140128f7f), slot(12)
    [  869.140293] mpt3sas_cm0: enclosure level(0x0000), connector
name(     )
    [  893.262506] watchdog: BUG: soft lockup - CPU#5 stuck for 26s!
[mdX_raid5:24608]
    [  893.262641] Modules linked in: dm_raid mptctl mptbase bonding
fcoe libfcoe 8021q garp mrp libfc stp llc scsi_transport_fc
sch_fq_codel softdog dm_round_robin scsi_dh_alua intel_rapl_msr
coretemp intel_rapl_common sb_edac x86_pkg_temp_thermal
intel_powerclamp ast kvm_intel drm_shmem_helper drm_kms_helper kvm
crct10dif_pclmul crc32_pclmul ghash_clmulni_intel sha512_ssse3
sha256_ssse3 sha1_ssse3 aesni_intel crypto_simd cryptd rapl
intel_cstate wdat_wdt intel_pch_thermal ipmi_ssif dm_multipath
acpi_ipmi sg ipmi_si ipmi_devintf ipmi_msghandler acpi_pad
acpi_power_meter ramoops reed_solomon efi_pstore drm ip_tables x_tables
autofs4 raid10 raid456 async_raid6_recov async_memcpy async_pq
async_xor xor async_tx raid6_pq libcrc32c raid0 ses enclosure mlx5_ib
ib_core raid1 ixgbe igb mlx5_core mdio_devres xfrm_algo i2c_algo_bit
e1000e mpt3sas hwmon dca mdio i2c_i801 ahci lpc_ich ptp i2c_smbus
mfd_core raid_class libahci pps_core libphy scsi_transport_sas
    [  893.264033] CPU: 5 PID: 24608 Comm: mdX_raid5 Not tainted 6.9.8-
bstrg #3
    [  893.264254] Hardware name: AIC HA401-LB2/LIBRA, BIOS LIBBV071
04/19/2017
    [  893.264479] RIP: 0010:_raw_spin_lock_irqsave+0xe/0x30
    [  893.264714] Code: 48 89 ef 5d e9 13 33 47 ff 0f 1f 00 90 90 90
90 90 90 90 90 90 90 90 90 90 90 90 90 0f 1f 44 00 00 41 54 55 48 89 fd
9c 41 5c <fa> bf 01 00 00 00 e8 07 96 43 ff 48 89 ef e8 df 32 47 ff 4c
89 e0
    [  893.265229] RSP: 0018:ffffbc306091fd70 EFLAGS: 00000246
    [  893.265502] RAX: 0000000000000001 RBX: 0000000000000001 RCX:
0000000000000000
    [  893.265783] RDX: 0000000000000001 RSI: 0000000000000003 RDI:
ffff9fbacf48c430
    [  893.266069] RBP: ffff9fbacf48c430 R08: ffff9fcac1254d58 R09:
00000000ffffffff
    [  893.266366] R10: 0000000000000000 R11: ffffbc306091fe20 R12:
0000000000000246
    [  893.266664] R13: ffff9fcac1254dc0 R14: 0000000000000000 R15:
0000000000739d18
    [  893.266968] FS:  0000000000000000(0000)
GS:ffff9fc9fff40000(0000) knlGS:0000000000000000
    [  893.267282] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
    [  893.267603] CR2: 000055f91452ff88 CR3: 0000000124c74004 CR4:
00000000003706f0
    [  893.267933] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
0000000000000000
    [  893.268268] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7:
0000000000000400
    [  893.268605] Call Trace:
    [  893.268945]  <IRQ>
    [  893.269285]  ? watchdog_timer_fn+0x24b/0x2d0
    [  893.269638]  ? __pfx_watchdog_timer_fn+0x10/0x10
    [  893.269990]  ? __hrtimer_run_queues+0x112/0x2b0
    [  893.270347]  ? hrtimer_interrupt+0x101/0x240
    [  893.270708]  ? __sysvec_apic_timer_interrupt+0x6e/0x180
    [  893.271075]  ? sysvec_apic_timer_interrupt+0x9d/0xd0
    [  893.271448]  </IRQ>
    [  893.271816]  <TASK>
    [  893.272184]  ? asm_sysvec_apic_timer_interrupt+0x16/0x20
    [  893.272568]  ? _raw_spin_lock_irqsave+0xe/0x30
    [  893.272956]  __wake_up+0x1d/0x60
    [  893.273345]  md_wakeup_thread+0x38/0x70
    [  893.273738]  raid5d+0x32a/0x5d0 [raid456]
    [  893.274147]  md_thread+0xc1/0x170
    [  893.274545]  ? __pfx_autoremove_wake_function+0x10/0x10
    [  893.274951]  ? __pfx_md_thread+0x10/0x10
    [  893.275358]  kthread+0xff/0x130
    [  893.275760]  ? __pfx_kthread+0x10/0x10
    [  893.276172]  ret_from_fork+0x30/0x50
    [  893.276568]  ? __pfx_kthread+0x10/0x10
    [  893.276961]  ret_from_fork_asm+0x1a/0x30
    [  893.277351]  </TASK>

