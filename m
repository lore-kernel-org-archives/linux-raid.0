Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=162.62.57.64
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794817970;
	b=rfy7Upex+x1CDW1yMz1C9q1w/IoWW5kVyj0jfyp0P5V+nK55GwvBwxW9q4TZ75eMFPs6
	 zKaNjq4vtr5PosuWC/H/TQVNCek/OZ75/gO0zNfvmfqhywKelfqm3Aa82DHlpbw1ZEvPj
	 ujk9etjk1Gc9YmjHmRycxvC4wMS2C3/cJMytsTLChMmjK+2NFfPuauWrWUpvCRWPw0Ws9
	 0X0Kn07h24m4djlIXY6rIC3AQmo5gt4IeEeNPp1vp53zoBOjHSZ0LHg5/iUepTdIr7jro
	 7CA14D638wVLkvrK+fX7m7K/qzZOW0tH8Wi07rcPjFpTrfqilzCRXTgEHotkB9ke3Lw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794817970;
	h=DMARC-Filter:DKIM-Signature:Received:X-QQ-mid:Message-ID:
	 X-QQ-XMAILINFO:X-QQ-XMRINFO:From:To:Cc:Subject:Date:X-OQ-MSGID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=ClAYz7KmIaVzUSN+CO4vNEiBYG0UC9ArQ3+ATSLvZ3c=;
	b=0amePuWe3YMVOotsBRzdry6cvFLqSo5fmlvYkmu07v64ac30gh3vOM19p6DHk21OUTaN
	 AvMD3tPKipKqtJzd+4Q9v3IBGXVsqTJH3SqVh7KayfxSVjwVbtcRH9+bNxfj7j2/QL9hU
	 t/ZowILNrZcQci3/ezpeqrVz75rNIrXKDG+sPYGNf3E/VgG/CXh+Ntsa7d3wzK8Emg+ad
	 TVA/UbGVIuEY4LpJNjsOSAWbjlOE1RGl3nz3SNUVWTQEZhJdcWJ/4du2T0hZYXwg7f5tc
	 tgzyAlcnazJ9cThhUxrlgl9I4AshVxCzNHAyN67PVrZvbAKUKpBDIcLpIT8lPfxt24g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=qq.com;
	spf=pass smtp.mailfrom=qq.com;
	dkim=pass header.d=qq.com header.i=@qq.com header.a=rsa-sha256 header.s=s201512 header.b=fjGxOQtk;
	arc=none smtp.remote-ip=162.62.57.64
Received: from out162-62-57-64.mail.qq.com (out162-62-57-64.mail.qq.com [162.62.57.64])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46119606A31C;
	Mon, 16 Nov 2026 08:32:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 46119606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qq.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=qq.com header.i=@qq.com header.a=rsa-sha256 header.s=s201512 header.b=fjGxOQtk
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1794817964; bh=ClAYz7KmIaVzUSN+CO4vNEiBYG0UC9ArQ3+ATSLvZ3c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fjGxOQtkskK8dXEJI/Q8iwYkMZzJhC+WNDyhAQ2A962WTBY8G+Rl9dMoAHFQUHDlW
	 G81/IkpWBYl5QklG/ZKMklL86LEdBlDRO5Au+IJEaZEX0ZM7FFd8xYKADhEnAmn7WR
	 7yRjXnx5TQVINiYctbiHT7azelctSYCgE7FdVMJM=
Received: from shuai-VMware-Virtual-Platform.. ([117.158.156.198])
	by newxmesmtplogicsvrsza53-0.qq.com (NewEsmtp) with SMTP
	id 82A36286; Mon, 16 Nov 2026 16:32:42 +0800
X-QQ-mid: xmsmtpt1794817962tgbgkwhio
Message-ID: <tencent_3583131EEE6BD2102C15F21A4DEEB86A6208@qq.com>
X-QQ-XMAILINFO: MyuUxGYaDVWVRY5u6RVPf5RFHGWGsu7Nr52WC6fpRMq2Q/kvEbb7TJkHeK0R8u
	 MDFLbCEbaadqXZ8Qwglq+u/C7VmpxMH/oepEW/kKfAIWrnmTFbKawqPuGnlDELJpybeuLfRAjsWc
	 dDXQcWbOU4srWDQqSSNBldKc5BckR7H9z0az9YSTShLIgnRFOJLAvKAuHwgDnxIEiWVJU6Uyc34X
	 3IapUNcFO5s0IFT2NBn7xXfaRo8+Yzqazzyj3xSYbEUyLR3arhV31TejEkvCAHq3TRD6JZkgqP/e
	 4K/F7QiI6AXHvAONSiztXkm1qOTY5YD2wdqzDkuDNW3XBxUqCe1LBQ23xalqg97Eil0eKh/Aohfj
	 SRJc+t1nTOXTldczaykuR+r6EjEPMjBItGvxFCOqH+2uWjE7Qaa9xc3Yu+i7vpx1t6n/TuZBLa2x
	 NQ8JxEH/ck6XEyAb8Uqk8o+KXo6nQuqQl82yDmMIldYxgDCz1NE26cbmcdVwoA064WoSqxZz3706
	 2LNJ/s10wSKNMivYAyYVL+9MHiD4fuS2pRrIZjQhZMDIuQdW6HlrDniO/iqxuBi55gxSA74MIt3V
	 AwqiVil9I74dPQs/wcf8Lxg/wlWRgUaFxO3CsY5h00x/aciQoxGtN7J202VYKnAxgstko+wKHuXS
	 1JWhmWFU/FVpo4Cn475NcNdnege7L1/WmP8sQEcB6YM4GjOKH6o5LoXRPtB5nw/mWKii045bM6Wg
	 3OfnawBR1K4IWS0pYi4sbk+HiuXyPGRfch57egypv3IbCs0ZWdE9oPe/wDh66RZpblwl5NL19Fjb
	 7sZaW9vtsD3iBz/QW4OMwgSce7qe7bEUjZIwzgFZA+DrHNMMpAnz5h6g1hBL/Lox4yOfbDZj6jyR
	 VfkZ0ohTVhyGsMaq79FdlMw8lj3zBnAqRwsjT/L1cyAupjwjkI05WEtY4FnGLk2YsjmYQ6wfJsBQ
	 lqc2V+W+kFAFZsddy7TPH6EAod/t494/yUExxi8Pap6536GgwQ1SmtdGnlgDd9M4u4+cyrBqLTT/
	 CsRI0k9xu5juKcNch9rxDNRDZdZpnRHVvKE73fnnXEracSk5NTMFavWGqcuVsGp2t3QSxTC7sfCQ
	 Az9heVI5LtoJSj0oTMSBrhBYX0PwndjrXN5+wJ
X-QQ-XMRINFO: OWPUhxQsoeAVwkVaQIEGSKwwgKCxK/fD5g==
From: Shuai Liu <847807867@qq.com>
To: linux-raid@vger.kernel.org
Cc: song@kernel.org,
	yukuai@fygo.io,
	magiclinan@didiglobal.com,
	xiao@kernel.org,
	linux-kernel@vger.kernel.org,
	syzbot+c5969d7e0a934b384fd6@syzkaller.appspotmail.com,
	847807867@qq.com
Subject: [PATCH] md: reject out-of-bounds desc_nr in super_90_validate()
Date: Mon, 16 Nov 2026 16:32:41 +0800
X-OQ-MSGID: <20261116083241.1064311-1-847807867@qq.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <6afa2ce8.920b2b3a.148c65.0040.GAE@google.com>
References: <6afa2ce8.920b2b3a.148c65.0040.GAE@google.com>
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Post: <mailto:linux-raid@vger.kernel.org>
List-Help: <mailto:linux-raid+help@vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-raid+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

super_90_validate() indexes the on-disk disk descriptor array with
rdev->desc_nr without any bounds check:

	desc = sb->disks + rdev->desc_nr;
	if (desc->state & (1<<MD_DISK_FAULTY))
		...

mdp_super_t carries only MD_SB_DISKS (27) descriptors of 128 bytes
each starting at offset 512, so any desc_nr outside [0, MD_SB_DISKS)
reads past the end of the 4KB superblock page.

Such an out-of-range desc_nr is reachable in several ways:

1. On a running non-persistent array, ADD_NEW_DISK with the
   MD_DISK_JOURNAL flag reaches add_bound_rdev(), which calls
   validate_super() unconditionally for journal disks.
   bind_rdev_to_array() auto-assigns desc_nr = mddev->raid_disks to
   a new rdev, and its max_disks check is skipped both for journal
   disks and when mddev->max_disks == 0 (the case for non-persistent
   arrays, which never set it).  With raid_disks > MD_SB_DISKS the
   assigned desc_nr points past the descriptor array.

2. During assembly, rdev->desc_nr comes straight from the on-disk
   sb->this_disk.number, which is fully attacker-controlled fuzz
   input.

syzbot hit path 1: a RAID1 array with raid_disks=35 and
not_persistent=1 plus a hot-added journal disk made
super_90_validate() read sb->disks[35].state at byte offset
512 + 35 * 128 + 16 = 5008, i.e. 912 bytes into the page following
the 4096-byte superblock page:

	BUG: KASAN: use-after-free in super_90_validate+0x178b/0x18c0 drivers/md/md.c:1592
	Read of size 4 at addr ffff888073d36390 by task syz-executor291/6009
	 ...
	 super_90_validate+0x178b/0x18c0 drivers/md/md.c:1592
	 add_bound_rdev+0x274/0x390 drivers/md/md.c:3012
	 md_add_new_disk+0xca1/0x1820 drivers/md/md.c:7666
	 md_ioctl+0x2c1d/0x3700 drivers/md/md.c:8525
	 blkdev_ioctl+0x5ad/0x6f0 block/ioctl.c:798

(The KASAN report shows use-after-free or slab-out-of-bounds
depending on what occupies the neighbouring memory.)

super_1_validate() already bounds desc_nr against sb->max_dev; the
0.90 metadata path has no equivalent check.  Reject desc_nr outside
[0, MD_SB_DISKS) with -EINVAL, which covers both the desc->state
reads in super_90_validate() itself and keeps fuzzed on-disk
sb->this_disk.number values from being used as an array index.

Note that super_90_sync() also writes sb->disks[] indexed by
desc_nr; on a persistent array a journal disk can still bypass the
bind_rdev_to_array() max_disks check and reach that write.  Reaching
it additionally requires a crafted on-disk superblock, so it is left
for follow-up discussion.

Verified with the syzbot reproducer under QEMU with KASAN (7.4-rc3
based config): baseline reproduces the use-after-free on every run,
with this patch the reproducer completes with zero KASAN reports
across repeated runs.

Reported-by: syzbot+c5969d7e0a934b384fd6@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=c5969d7e0a934b384fd6
Signed-off-by: Shuai Liu <847807867@qq.com>
---
 drivers/md/md.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 03e35386a8028..83009b0d84092 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -1495,6 +1495,9 @@ static int super_90_validate(struct mddev *mddev, struct md_rdev *freshest, stru
 	mdp_super_t *sb = page_address(rdev->sb_page);
 	__u64 ev1 = md_event(sb);
 
+	if (rdev->desc_nr < 0 || rdev->desc_nr >= MD_SB_DISKS)
+		return -EINVAL;
+
 	rdev->raid_disk = -1;
 	clear_bit(Faulty, &rdev->flags);
 	clear_bit(In_sync, &rdev->flags);
-- 
2.43.0

