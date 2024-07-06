Received: from mx-out.tlen.pl (mx-out.tlen.pl [193.222.135.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA86D4C3D0
	for <linux-raid@vger.kernel.org>; Sat,  6 Jul 2024 14:38:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.222.135.140
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720276714; cv=none; b=hetyor2zShpn3npCfWWaUEJEVqSlodvYQ2LCIlhrXHt73B3Iay35/Lk+uZ6dm+I9KwLZ/eNhcRoqgz96v6TrGNgTXEcMGYgpSEnF3SFU3r6gxOJ7rJPA1zdcGVAJ7RU15IUGwwUpEPlWNIfQorLTIGD+87BYE8J9MW1acJQcV98=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720276714; c=relaxed/simple;
	bh=p2GeOrOHo+n9M9dSTTMqea/QolyKzoTW2Pva5LRxgNk=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=s5RiKX6g6wdVArSsh+/QAHx0lUr6o/lY1QvE0PJlagBqRZSwHr1+TwSVESCT8I9tARSWlBzmnmKU+K7ePLto495NWc3dFdm44UmKORWYBAQiVmeIiRZsrbdTcKw1GWwvJtOR+mQgD0BM9avDz2lsQY0fXD18eiWM92zvQqEhQ14=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=o2.pl; spf=pass smtp.mailfrom=o2.pl; dkim=pass (1024-bit key) header.d=o2.pl header.i=@o2.pl header.b=vMNmlltV; arc=none smtp.client-ip=193.222.135.140
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=o2.pl
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=o2.pl
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=o2.pl header.i=@o2.pl header.b="vMNmlltV"
Received: (wp-smtpd smtp.tlen.pl 48214 invoked from network); 6 Jul 2024 16:31:49 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=o2.pl; s=1024a;
          t=1720276309; bh=IuYsuspt1XbKreKi8lh7xRLDuGlq7qtj/4aRobGeiQE=;
          h=From:To:Cc:Subject;
          b=vMNmlltVxDVU7d/cGspmApdA8xX7WrjVdQ10sovNoxZ+5Spl6/AGExKD3qYCKgMrn
           aidWGTYd3FG0ye2GW+Lw3MHPd7eUXr83nwnGZOoBMskqIkn7D7MDlArTLSwRi/au6P
           8/whY5oWokqhCU1OQYmRbcgFHnpezlGUG5JfNP4Q=
Received: from aafa129.neoplus.adsl.tpnet.pl (HELO localhost.localdomain) (mat.jonczyk@o2.pl@[83.4.130.129])
          (envelope-sender <mat.jonczyk@o2.pl>)
          by smtp.tlen.pl (WP-SMTPD) with SMTP
          for <linux-raid@vger.kernel.org>; 6 Jul 2024 16:31:49 +0200
From: =?UTF-8?q?Mateusz=20Jo=C5=84czyk?= <mat.jonczyk@o2.pl>
To: linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: regressions@lists.linux.dev,
	Song Liu <song@kernel.org>,
	Yu Kuai <yukuai3@huawei.com>,
	Paul Luse <paul.e.luse@linux.intel.com>,
	Xiao Ni <xni@redhat.com>,
	=?UTF-8?Q?Mateusz_Jo=C5=84czyk?= <mat.jonczyk@o2.pl>
Subject: [REGRESSION] Cannot start degraded RAID1 array with device with write-mostly flag
Date: Sat,  6 Jul 2024 16:30:38 +0200
Message-Id: <20240706143038.7253-1-mat.jonczyk@o2.pl>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-WP-DKIM-Status: good (id: o2.pl)                                                      
X-WP-MailID: 6c84a31a18a04ac81c23c94e77fe954b
X-WP-AV: skaner antywirusowy Poczty o2
X-WP-SPAM: NO 000000A [AVPU]                               

Hello,=0D
=0D
Linux 6.9+ cannot start a degraded RAID1 array when the only remaining=0D
device has the write-mostly flag set. Linux 6.8.0 works fine, as does=0D
6.1.96.=0D
=0D
#regzbot introduced: v6.8.0..v6.9.0=0D
=0D
In my laptop, I used to have two RAID1 arrays on top of NVMe and SATA=0D
SSD drives: /dev/md0 for /boot, /dev/md1 for remaining data. For=0D
performance, I have marked the RAID component devices on the SATA SSD=0D
drive write-mostly, which "means that the 'md' driver will avoid reading=0D
from these devices if at all possible".=0D
=0D
Recently, the NVMe drive started failing, so I removed it from the arrays:=
=0D
=0D
=C2=A0=C2=A0 =C2=A0$ cat /proc/mdstat=0D
=C2=A0=C2=A0 =C2=A0Personalities : [raid1]=0D
=C2=A0=C2=A0 =C2=A0md1 : active raid1 sdb5[1](W)=0D
=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 471727104 blocks super 1.=
2 [2/1] [_U]=0D
=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 bitmap: 4/4 pages [16KB],=
 65536KB chunk=0D
=0D
=C2=A0=C2=A0 =C2=A0md0 : active raid1 sdb4[1](W)=0D
=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 2094080 blocks super 1.2 =
[2/1] [_U]=0D
=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=0D
=C2=A0=C2=A0 =C2=A0unused devices: <none>=0D
=0D
and wiped it. Since then, Linux 6.9+ fails to assemble the arrays on startu=
p=0D
with the following stacktraces in dmesg:=0D
=0D
=C2=A0=C2=A0 =C2=A0md/raid1:md0: active with 1 out of 2 mirrors=0D
=C2=A0=C2=A0 =C2=A0md0: detected capacity change from 0 to 4188160=0D
=C2=A0=C2=A0 =C2=A0------------[ cut here ]------------=0D
=C2=A0=C2=A0 =C2=A0kernel BUG at block/bio.c:1659!=0D
=C2=A0=C2=A0 =C2=A0Oops: invalid opcode: 0000 [#1] PREEMPT SMP PTI=0D
=C2=A0=C2=A0 =C2=A0CPU: 0 PID: 174 Comm: mdadm Not tainted 6.10.0-rc6unif33=
 #493=0D
=C2=A0=C2=A0 =C2=A0Hardware name: HP HP Laptop 17-by0xxx/84CA, BIOS F.72 05=
/31/2024=0D
=C2=A0=C2=A0 =C2=A0RIP: 0010:bio_split+0x96/0xb0=0D
=C2=A0=C2=A0 =C2=A0Code: df ff ff 41 f6 45 14 80 74 08 66 41 81 4c 24 14 80=
 00 5b 4c 89 e0 41 5c 41 5d 5d c3 cc cc cc cc 41 c7 45 28 00 00 00 00 eb d9=
 <0f> 0b 0f 0b 0f 0b 45 31 e4 eb dd 66 66 2e 0f 1f 84 00 00 00 00 00=0D
=C2=A0=C2=A0 =C2=A0RSP: 0018:ffffa7588041b330 EFLAGS: 00010246=0D
=C2=A0=C2=A0 =C2=A0RAX: 0000000000000008 RBX: 0000000000000001 RCX: ffff9f2=
2cb08f938=0D
=C2=A0=C2=A0 =C2=A0RDX: 0000000000000c00 RSI: 0000000000000000 RDI: ffff9f2=
2c1199400=0D
=C2=A0=C2=A0 =C2=A0RBP: ffffa7588041b420 R08: ffff9f22c3587b30 R09: 0000000=
000000001=0D
=C2=A0=C2=A0 =C2=A0R10: 0000000000000000 R11: 0000000000000008 R12: ffff9f2=
2cc9da700=0D
=C2=A0=C2=A0 =C2=A0R13: ffff9f22cb08f800 R14: ffff9f22c6a35fa0 R15: ffff9f2=
2c1846800=0D
=C2=A0=C2=A0 =C2=A0FS:=C2=A0 00007f5f88404740(0000) GS:ffff9f2621e00000(000=
0) knlGS:0000000000000000=0D
=C2=A0=C2=A0 =C2=A0CS:=C2=A0 0010 DS: 0000 ES: 0000 CR0: 0000000080050033=0D
=C2=A0=C2=A0 =C2=A0CR2: 000056299cb95000 CR3: 000000010c82a002 CR4: 0000000=
0003706f0=0D
=C2=A0=C2=A0 =C2=A0Call Trace:=0D
=C2=A0=C2=A0 =C2=A0 <TASK>=0D
=C2=A0=C2=A0 =C2=A0 ? show_regs+0x67/0x70=0D
=C2=A0=C2=A0 =C2=A0 ? __die_body+0x20/0x70=0D
=C2=A0=C2=A0 =C2=A0 ? die+0x3e/0x60=0D
=C2=A0=C2=A0 =C2=A0 ? do_trap+0xd6/0xf0=0D
=C2=A0=C2=A0 =C2=A0 ? do_error_trap+0x71/0x90=0D
=C2=A0=C2=A0 =C2=A0 ? bio_split+0x96/0xb0=0D
=C2=A0=C2=A0 =C2=A0 ? exc_invalid_op+0x53/0x70=0D
=C2=A0=C2=A0 =C2=A0 ? bio_split+0x96/0xb0=0D
=C2=A0=C2=A0 =C2=A0 ? asm_exc_invalid_op+0x1b/0x20=0D
=C2=A0=C2=A0 =C2=A0 ? bio_split+0x96/0xb0=0D
=C2=A0=C2=A0 =C2=A0 ? raid1_read_request+0x890/0xd20=0D
=C2=A0=C2=A0 =C2=A0 ? __call_rcu_common.constprop.0+0x97/0x260=0D
=C2=A0=C2=A0 =C2=A0 raid1_make_request+0x81/0xce0=0D
=C2=A0=C2=A0 =C2=A0 ? __get_random_u32_below+0x17/0x70=C2=A0=C2=A0=C2=A0 //=
 is not present in other stacktraces=0D
=C2=A0=C2=A0 =C2=A0 ? new_slab+0x2b3/0x580=C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=
=C2=A0 =C2=A0=C2=A0=C2=A0 // is not present in other stacktraces=0D
=C2=A0=C2=A0 =C2=A0 md_handle_request+0x77/0x210=0D
=C2=A0=C2=A0 =C2=A0 md_submit_bio+0x62/0xa0=0D
=C2=A0=C2=A0 =C2=A0 __submit_bio+0x17b/0x230=0D
=C2=A0=C2=A0 =C2=A0 submit_bio_noacct_nocheck+0x18e/0x3c0=0D
=C2=A0=C2=A0 =C2=A0 submit_bio_noacct+0x244/0x670=0D
=C2=A0=C2=A0 =C2=A0 submit_bio+0xac/0xe0=0D
=C2=A0=C2=A0 =C2=A0 submit_bh_wbc+0x168/0x190=0D
=C2=A0=C2=A0 =C2=A0 block_read_full_folio+0x203/0x420=0D
=C2=A0=C2=A0 =C2=A0 ? __mod_memcg_lruvec_state+0xcd/0x210=0D
=C2=A0=C2=A0 =C2=A0 ? __pfx_blkdev_get_block+0x10/0x10=0D
=C2=A0=C2=A0 =C2=A0 ? __lruvec_stat_mod_folio+0x63/0xb0=0D
=C2=A0=C2=A0 =C2=A0 ? __filemap_add_folio+0x24d/0x450=0D
=C2=A0=C2=A0 =C2=A0 ? __pfx_blkdev_read_folio+0x10/0x10=0D
=C2=A0=C2=A0 =C2=A0 blkdev_read_folio+0x18/0x20=0D
=C2=A0=C2=A0 =C2=A0 filemap_read_folio+0x45/0x290=0D
=C2=A0=C2=A0 =C2=A0 ? __pfx_workingset_update_node+0x10/0x10=0D
=C2=A0=C2=A0 =C2=A0 ? folio_add_lru+0x5a/0x80=0D
=C2=A0=C2=A0 =C2=A0 ? filemap_add_folio+0xba/0xe0=0D
=C2=A0=C2=A0 =C2=A0 ? __pfx_blkdev_read_folio+0x10/0x10=0D
=C2=A0=C2=A0 =C2=A0 do_read_cache_folio+0x10a/0x3c0=0D
=C2=A0=C2=A0 =C2=A0 read_cache_folio+0x12/0x20=0D
=C2=A0=C2=A0 =C2=A0 read_part_sector+0x36/0xc0=0D
=C2=A0=C2=A0 =C2=A0 read_lba+0x96/0x1b0=0D
=C2=A0=C2=A0 =C2=A0 find_valid_gpt+0xe8/0x770=0D
=C2=A0=C2=A0 =C2=A0 ? get_page_from_freelist+0x615/0x12e0=0D
=C2=A0=C2=A0 =C2=A0 ? __pfx_efi_partition+0x10/0x10=0D
=C2=A0=C2=A0 =C2=A0 efi_partition+0x80/0x4e0=0D
=C2=A0=C2=A0 =C2=A0 ? vsnprintf+0x297/0x4f0=0D
=C2=A0=C2=A0 =C2=A0 ? snprintf+0x49/0x70=0D
=C2=A0=C2=A0 =C2=A0 ? __pfx_efi_partition+0x10/0x10=0D
=C2=A0=C2=A0 =C2=A0 bdev_disk_changed+0x270/0x760=0D
=C2=A0=C2=A0 =C2=A0 blkdev_get_whole+0x8b/0xb0=0D
=C2=A0=C2=A0 =C2=A0 bdev_open+0x2bd/0x390=0D
=C2=A0=C2=A0 =C2=A0 ? __pfx_blkdev_open+0x10/0x10=0D
=C2=A0=C2=A0 =C2=A0 blkdev_open+0x8f/0xc0=0D
=C2=A0=C2=A0 =C2=A0 do_dentry_open+0x174/0x570=0D
=C2=A0=C2=A0 =C2=A0 vfs_open+0x2b/0x40=0D
=C2=A0=C2=A0 =C2=A0 path_openat+0xb20/0x1150=0D
=C2=A0=C2=A0 =C2=A0 do_filp_open+0xa8/0x120=0D
=C2=A0=C2=A0 =C2=A0 ? alloc_fd+0xc2/0x180=0D
=C2=A0=C2=A0 =C2=A0 do_sys_openat2+0x250/0x2a0=0D
=C2=A0=C2=A0 =C2=A0 do_sys_open+0x46/0x80=0D
=C2=A0=C2=A0 =C2=A0 __x64_sys_openat+0x20/0x30=0D
=C2=A0=C2=A0 =C2=A0 x64_sys_call+0xe55/0x20d0=0D
=C2=A0=C2=A0 =C2=A0 do_syscall_64+0x47/0x110=0D
=C2=A0=C2=A0 =C2=A0 entry_SYSCALL_64_after_hwframe+0x76/0x7e=0D
=C2=A0=C2=A0 =C2=A0RIP: 0033:0x7f5f88514f5b=0D
=C2=A0=C2=A0 =C2=A0Code: 25 00 00 41 00 3d 00 00 41 00 74 4b 64 8b 04 25 18=
 00 00 00 85 c0 75 67 44 89 e2 48 89 ee bf 9c ff ff ff b8 01 01 00 00 0f 05=
 <48> 3d 00 f0 ff ff 0f 87 91 00 00 00 48 8b 4c 24 28 64 48 33 0c 25=0D
=C2=A0=C2=A0 =C2=A0RSP: 002b:00007ffd8839cbe0 EFLAGS: 00000246 ORIG_RAX: 00=
00000000000101=0D
=C2=A0=C2=A0 =C2=A0RAX: ffffffffffffffda RBX: 00007ffd8839dbe0 RCX: 00007f5=
f88514f5b=0D
=C2=A0=C2=A0 =C2=A0RDX: 0000000000004000 RSI: 00007ffd8839cc70 RDI: 0000000=
0ffffff9c=0D
=C2=A0=C2=A0 =C2=A0RBP: 00007ffd8839cc70 R08: 0000000000000000 R09: 00007ff=
d8839cae0=0D
=C2=A0=C2=A0 =C2=A0R10: 0000000000000000 R11: 0000000000000246 R12: 0000000=
000004000=0D
=C2=A0=C2=A0 =C2=A0R13: 0000000000004000 R14: 00007ffd8839cc68 R15: 0000559=
42d9dabe0=0D
=C2=A0=C2=A0 =C2=A0 </TASK>=0D
=C2=A0=C2=A0 =C2=A0Modules linked in: crct10dif_pclmul crc32_pclmul ghash_c=
lmulni_intel sha512_ssse3 sha256_ssse3 sha1_ssse3 drm_buddy r8169 i2c_algo_=
bit psmouse i2c_i801 drm_display_helper i2c_mux video i2c_smbus=0D
xhci_pci realtek cec xhci_pci_renesas i2c_hid_acpi i2c_hid hid wmi aesni_in=
tel crypto_simd cryptd=0D
=C2=A0=C2=A0 =C2=A0---[ end trace 0000000000000000 ]---=0D
=0D
which were logged twice (for two arrays).=0D
=0D
The line=0D
=C2=A0=C2=A0 =C2=A0kernel BUG at block/bio.c:1659!=0D
corresponds to=0D
=C2=A0=C2=A0 =C2=A0BUG_ON(sectors <=3D 0);=0D
in bio_split().=0D
=0D
After some investigation, I have determined that the bug is most likely in=
=0D
choose_slow_rdev() in drivers/md/raid1.c, which doesn't set max_sectors=0D
before returning early. A test patch (below) seems to fix this issue (Linux=
=0D
boots and appears to be working correctly with it, but I didn't do any more=
=0D
advanced experiments yet).=0D
=0D
This points to=0D
commit dfa8ecd167c1 ("md/raid1: factor out choose_slow_rdev() from read_bal=
ance()")=0D
as the most likely culprit. However, I was running into other bugs in mdadm=
 when=0D
trying to test this commit directly.=0D
=0D
Distribution: Ubuntu 20.04, hardware: a HP 17-by0001nw laptop.=0D
=0D
Greetings,=0D
=0D
Mateusz=0D
=0D
---------------------------------------------------=0D
=0D
>From e19348bc62eea385459ca1df67bd7c7c2afd7538 Mon Sep 17 00:00:00 2001=0D
From: =3D?UTF-8?q?Mateusz=3D20Jo=3DC5=3D84czyk?=3D <mat.jonczyk@o2.pl>=0D
Date: Sat, 6 Jul 2024 11:21:03 +0200=0D
Subject: [RFC PATCH] md/raid1: fill in max_sectors=0D
=0D
Not yet fully tested or carefully investigated.=0D
=0D
Signed-off-by: Mateusz Jo=C5=84czyk <mat.jonczyk@o2.pl>=0D
=0D
---=0D
 drivers/md/raid1.c | 1 +=0D
 1 file changed, 1 insertion(+)=0D
=0D
diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c=0D
index 7b8a71ca66dd..82f70a4ce6ed 100644=0D
--- a/drivers/md/raid1.c=0D
+++ b/drivers/md/raid1.c=0D
@@ -680,6 +680,7 @@ static int choose_slow_rdev(struct r1conf *conf, struct=
 r1bio *r1_bio,=0D
 		len =3D r1_bio->sectors;=0D
 		read_len =3D raid1_check_read_range(rdev, this_sector, &len);=0D
 		if (read_len =3D=3D r1_bio->sectors) {=0D
+			*max_sectors =3D read_len;=0D
 			update_read_sectors(conf, disk, this_sector, read_len);=0D
 			return disk;=0D
 		}=0D
-- =0D
2.25.1=0D
=0D
