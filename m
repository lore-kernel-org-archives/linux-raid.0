From: Tomasz Chmielewski <tch@virtall.com>
Subject: 4.0.5: WARNING: CPU: 3 PID: 249 at  /home/kernel/COD/linux/mm/backing-dev.c:372 bdi_unregister+0x36/0x40()
Date: Mon, 15 Jun 2015 21:39:03 +0900
Message-ID: <6d6f7bd7a906a79bacf8e622d348efcf@admin.virtall.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Got this after stopping a RAID-1 array:

[  626.694737] md: md3 still in use.
[  626.694946] md: delaying resync of md3 until md2 has finished (they 
share one or more physical units)
[  628.256210] md3: detected capacity change from 3888444473344 to 0
[  628.256372] md: md3 stopped.
[  628.256383] md: unbind<sdb4>
[  628.274852] md: export_rdev(sdb4)
[  628.274909] md: unbind<sda4>
[  628.282856] md: export_rdev(sda4)
[  628.283246] ------------[ cut here ]------------
[  628.283258] WARNING: CPU: 3 PID: 249 at 
/home/kernel/COD/linux/mm/backing-dev.c:372 bdi_unregister+0x36/0x40()
[  628.283261] Modules linked in: intel_rapl iosf_mbi 
x86_pkg_temp_thermal intel_powerclamp coretemp kvm_intel kvm 
crct10dif_pclmul crc32_pclmul ghash_clmulni_intel aesni_intel aes_x86_64 
lrw gf128mul glue_helper ablk_helper eeepc_wmi asus_wmi ppdev 
sparse_keymap parport_pc cryptd video shpchp 8250_fintek lpc_ich lp 
tpm_infineon wmi mac_hid parport serio_raw btrfs pata_acpi raid10 
raid456 async_raid6_recov async_memcpy async_pq async_xor async_tx xor 
raid6_pq raid1 ahci r8169 libahci raid0 mii pata_via multipath linear
[  628.283320] CPU: 3 PID: 249 Comm: kworker/3:1 Not tainted 
4.0.5-040005-generic #201506061639
[  628.283322] Hardware name: System manufacturer System Product 
Name/P8H67-M PRO, BIOS 3904 04/27/2013
[  628.283328] Workqueue: md_misc mddev_delayed_delete
[  628.283341]  0000000000000174 ffff88040867bca8 ffffffff817e4a5d 
0000000000000007
[  628.283347]  0000000000000000 ffff88040867bce8 ffffffff81079227 
ffffffff81adc895
[  628.283352]  ffff880409197c00 0000000000000000 0000000000000000 
ffff88041f2da900
[  628.283365] Call Trace:
[  628.283374]  [<ffffffff817e4a5d>] dump_stack+0x45/0x57
[  628.283381]  [<ffffffff81079227>] warn_slowpath_common+0x97/0xe0
[  628.283386]  [<ffffffff8107928a>] warn_slowpath_null+0x1a/0x20
[  628.283390]  [<ffffffff811a3f16>] bdi_unregister+0x36/0x40
[  628.283397]  [<ffffffff813955f8>] del_gendisk+0x108/0x260
[  628.283402]  [<ffffffff81648eec>] md_free+0x4c/0x70
[  628.283408]  [<ffffffff813b6b62>] kobject_cleanup+0x82/0x1c0
[  628.283413]  [<ffffffff813b69f0>] kobject_put+0x30/0x70
[  628.283417]  [<ffffffff81649c44>] mddev_delayed_delete+0x34/0x40
[  628.283422]  [<ffffffff81092204>] process_one_work+0x144/0x490
[  628.283426]  [<ffffffff81092c6e>] worker_thread+0x11e/0x450
[  628.283431]  [<ffffffff81092b50>] ? create_worker+0x1f0/0x1f0
[  628.283436]  [<ffffffff81098999>] kthread+0xc9/0xe0
[  628.283442]  [<ffffffff810988d0>] ? flush_kthread_worker+0x90/0x90
[  628.283448]  [<ffffffff817f1118>] ret_from_fork+0x58/0x90
[  628.283453]  [<ffffffff810988d0>] ? flush_kthread_worker+0x90/0x90
[  628.283457] ---[ end trace 2c187f15cc11aca4 ]---



-- 
Tomasz Chmielewski
http://wpkg.org

