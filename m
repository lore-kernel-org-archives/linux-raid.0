From: Luzipher McLeod <luziphermcleod@yahoo.ie>
Subject: Kernel BUG (fs/bio.c:1499) when copying more files to an encrypted device
Date: Wed, 25 Jan 2012 10:10:43 +0000 (GMT)
Message-ID: <1327486243.22537.YahooMailClassic@web24108.mail.ird.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: mbroz@redhat.com
List-Id: linux-raid.ids

Hi :-)

A few days ago I encountered a kernel bug while copying files to an encrypted filesystem. The specific stack for the filesystem is: btrfs-on-crypt-on-mdraid. Vasts amounts of data copied without problems (about 6.3TB with 1.1 TB remaining), but when copying a certain directory, the kernel bug surfaces. I repeatedly deleted the affected directory and tried to re-copy it, but it always fails at the same point (or close to that). More recent test showed that I could copy a few more files to the filesystem to a different directory, but it very quickly failed there as well (a few megabytes later).
After talking to the btrfs devs on freenode (as btrfs is the most experimental thing in the stack, they came to the conclusion that it's most probably the crypto layer.
After sending a mail to the dm-crypt list, they pointed me to the linux-raid list. Probably I should also mention that I used the linear raid target, as it was the simplest approach for me. I do not intend to keep the linear raid around for long, it's merely a buffer to backup my files before reformatting the original (source) raid5 device.

Some details:
gentoo kernel 3.2.1 (custom config and ubuntu config)
mdraid: linear, 4 disks, each 2TB (total 8TB)
crypt: setup via cryptsetup -c aes-xts-plain64 -h plain -s 512 -d - create tempraid /dev/md/tempraid_lin

I'd appreciate any help with this and would be happy to test patches or provide more debug info.

Thanks and Regards,
Luzipher




The kernel bug output retrieved by netconsole (also at http://pastebin.com/sjJy7QE4 ):
    [  294.538422] netconsole: local port 6666
    [  333.423583] SysRq : Changing Loglevel
    [  333.423609] Loglevel set to 9
    [  424.248405] ------------[ cut here ]------------
    [  424.248447] kernel BUG at fs/bio.c:1499!
    [  424.248476] invalid opcode: 0000 [#1] SMP DEBUG_PAGEALLOC
    [  424.248558] CPU 3
    [  424.248577] Modules linked in: netconsole configfs reiserfs f71882fg coretemp raid456 async_pq async_xor xor async_memcpy async_raid6_recov raid6_pq async_tx linear i915 snd_pcm snd_timer mpt2sas snd drm_kms_helper firewire_ohci soundcore usblp snd_page_alloc tpm_tis drm firewire_core scsi_transport_sas pcspkr crc_itu_t pata_jmicron raid_class iTCO_wdt r8169 iTCO_vendor_support i2c_i801 i2c_algo_bit mei(C) video
    [  424.250095]
    [  424.250119] Pid: 18, comm: kworker/3:0 Tainted: G         C   3.2.1-gentoo #9 MSI MS-7637/H55-GD65 (MS-7637) 
    [  424.250202] RIP: 0010:[<ffffffff811b114f>]  [<ffffffff811b114f>] bio_split+0x2bf/0x2d0
    [  424.250254] RSP: 0018:ffff88022e305c20  EFLAGS: 00010206
    [  424.250282] RAX: ffff88022b7f19e0 RBX: ffff88009fbb2200 RCX: 000000010027000e
    [  424.250313] RDX: ffff8800a77416f8 RSI: 0000000000000001 RDI: 0000000000000282
    [  424.250344] RBP: ffff88022e305c70 R08: ffff8800a77465b8 R09: ffff880233007640
    [  424.250375] R10: ffffea00029dd020 R11: 00000000000000ff R12: 0000000000000080
    [  424.250407] R13: ffff8800a77416f8 R14: 0000000000000001 R15: ffffea0002b0bfc0
    [  424.250438] FS:  0000000000000000(0000) GS:ffff88023bcc0000(0000) knlGS:0000000000000000
    [  424.250475] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
    [  424.250502] CR2: 0000000001df3000 CR3: 0000000001c05000 CR4: 00000000000006e0
    [  424.250533] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
    [  424.250564] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
    [  424.250595] Process kworker/3:0 (pid: 18, threadinfo ffff88022e304000, task ffff88022e2fb040)
    [  424.250629] Stack:
    [  424.250647]  ffff880219905050 0000000000001000 ffff88022b7f19e0 baa1821019905070
    [  424.250729]  0003120200001000 ffff88009fbb2200 ffff88022a524f38 000000000001f000
    [  424.250813]  0000000000000001 ffffea0002b0bfc0 ffff88022e305cd0 ffffffffa006e626
    [  424.250896] Call Trace:
    [  424.250918]  [<ffffffffa006e626>] linear_make_request+0x106/0x190 [linear]
    [  424.250953]  [<ffffffff8137576b>] ? generic_make_request_checks+0x1eb/0x370
    [  424.250988]  [<ffffffff815637e6>] md_make_request+0xc6/0x200
    [  424.251017]  [<ffffffff813759b7>] generic_make_request+0xc7/0x100
    [  424.251050]  [<ffffffff8157ebe4>] kcryptd_crypt_write_io_submit+0x44/0xc0
    [  424.251082]  [<ffffffff8157f160>] kcryptd_crypt+0x280/0x3d0
    [  424.251112]  [<ffffffff8157eee0>] ? crypt_convert_init.isra.17+0x60/0x60
    [  424.251146]  [<ffffffff8108dfda>] process_one_work+0x11a/0x480
    [  424.251176]  [<ffffffff8108ed64>] worker_thread+0x164/0x370
    [  424.251205]  [<ffffffff8108ec00>] ? manage_workers.isra.30+0x230/0x230
    [  424.251889]  [<ffffffff810934dc>] kthread+0x8c/0xa0
    [  424.251977]  [<ffffffff816d8e34>] kernel_thread_helper+0x4/0x10
    [  424.252009]  [<ffffffff81093450>] ? flush_kthread_worker+0xa0/0xa0
    [  424.252040]  [<ffffffff816d8e30>] ? gs_change+0x13/0x13
    [  424.252068] Code: 48 89 da 49 83 c6 10 8b 4d cc 48 8b 75 c0 ff d0 48 8b 55 b8 4c 89 f0 4c 29 f8 48 8b 44 02 f0 48 85 c0 75 d8 e9 9f fd ff ff 0f 0b <0f> 0b 66 66 66 66 66 66 2e 0f 1f 84 00 00 00 00 00 55 48 89 e5
    [  424.253585] RIP  [<ffffffff811b114f>] bio_split+0x2bf/0x2d0
    [  424.253626]  RSP <ffff88022e305c20>
    [  424.312992] ---[ end trace c8048857547cd8da ]---
    [  424.313134] BUG: unable to handle kernel paging request at fffffffffffffff8
    [  424.313225] IP: [<ffffffff81093971>] kthread_data+0x11/0x20
    [  424.313279] PGD 1c07067 PUD 1c08067 PMD 0
    [  424.313357] Oops: 0000 [#2] SMP DEBUG_PAGEALLOC
    [  424.313437] CPU 3
    [  424.313459] Modules linked in: netconsole configfs reiserfs f71882fg coretemp raid456 async_pq async_xor xor async_memcpy async_raid6_recov raid6_pq async_tx linear i915 snd_pcm snd_timer mpt2sas snd drm_kms_helper firewire_ohci soundcore usblp snd_page_alloc tpm_tis drm firewire_core scsi_transport_sas pcspkr crc_itu_t pata_jmicron


