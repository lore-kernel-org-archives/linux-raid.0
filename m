Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=162.62.57.137
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794819557;
	b=DvNLrYgVpDF2LuDm9HG9UTKndCtJC6Chb25/5UinkgYq72N0SB+KXSG0j/RlygeDIQzV
	 Paj9lXgZeUOFpKlyRY02jmt/p2fe5/Z49jsq3QLqFJEENSiq7w1xEaRJPYblu53pFAG6j
	 DQvHqroiBRvug76pkz1JHbOOXps+3Ps1BZHiv4VYPoZf+Ax5+ny6I15Nctz786uoeiq6n
	 ShlfznTi6kGTN4TouC9oRDrEMDaa/G5833PDHGLvkV/2NUEN0InBsc0LP0+zaLcUJRMr+
	 w+yrKr783gwRYJ4Z3V1dfWeTgL7cWaTYtkrmZLZXR0oU+YvfQ3UQvgR6rEETA3ntNoQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794819557;
	h=DMARC-Filter:DKIM-Signature:Received:X-QQ-mid:Message-ID:
	 X-QQ-XMAILINFO:X-QQ-XMRINFO:From:To:Cc:Subject:Date:X-OQ-MSGID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=/dvIB4eCT65NW90Kjn4J4IQ988fOX5w1fXpawpMmbjI=;
	b=qfxDEVvRq6KxSGcZCRg0wmQ189Tr7AeCMQtfwSohkEfPVfIjje2M3eIu5yfUZXZCrwFN
	 pu7rD6bsyHhumVC2zgZx6ASGocMNbuHtw11uX4bzhw/udTgjfUi5UgrN0TqWJPMzdUJwH
	 XPlXxHgtmL5iEjSfqnoS5D0NKLYXWeQG/ZCCz4RfhJNsR4Y6dl6PNJU6xyDQ+2zvSCkeO
	 MS6UomC5h9BQSW7FI1u7R7IDAy06JLPLcI6HMWG4bp9IogdmHsX2Vynt7nuXCAbSY3PzC
	 Kg0XcYREyCK2s2RvVniV1wxdveWLj/bxk3kuHvyFmPMZ2WQNrQO4MFLohT/umMVUmfA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=qq.com;
	spf=pass smtp.mailfrom=qq.com;
	dkim=pass header.d=qq.com header.i=@qq.com header.a=rsa-sha256 header.s=s201512 header.b=peEHWOMl;
	arc=none smtp.remote-ip=162.62.57.137
Received: from out162-62-57-137.mail.qq.com (out162-62-57-137.mail.qq.com [162.62.57.137])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FD8F606A882;
	Mon, 16 Nov 2026 08:59:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0FD8F606A882
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qq.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.a=rsa-sha256 header.s=s201512 header.b=peEHWOMl
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1794819547; bh=/dvIB4eCT65NW90Kjn4J4IQ988fOX5w1fXpawpMmbjI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=peEHWOMlToaFBuaTLh6em9M6qR4m5ErZizJjYtQiVoQWLNanOk30BnxpExzDo3kmp
	 3IRlx9KpulDgqTGdlokXgUgr2sMacFFY4gF3nzR1dyTRi13k2jIUK0u4KMNKw2Jm3b
	 pyFjLjp3pAQ05TcukyxQzIJGViF7ZRGRdafMlBKM=
Received: from shuai-VMware-Virtual-Platform.. ([117.158.156.199])
	by newxmesmtplogicsvrsza63-0.qq.com (NewEsmtp) with SMTP
	id EC40F80D; Mon, 16 Nov 2026 16:59:04 +0800
X-QQ-mid: xmsmtpt1794819544tj0nn1keq
Message-ID: <tencent_FEF23D4D4FB8FD625C136CEE6ED2092C9E08@qq.com>
X-QQ-XMAILINFO: MzVGNhsCLlFKMFEt6x/QY7Ju2K3buoUBPqsqjH6W019wGi/TGLBLW8jlci1+SG
	 mGdvSLbtvkjyj4/E3VpLf6x/GSZb2FztxY/elAt0BPr35LEl0tvBLJL65pYeTsHq8Zqy6U9FokCy
	 TYWD6OaCc/2F9ssQa8jC89NpD+boi6kQzozugmwMapv/mtGec62JpWbP2l/75CMz0ya08FOUsyCa
	 fZNk1PnKjJA6GT7uvtHf3KYgY8466wvuiynLrXbtPShAZWQSfzzpD/zu2BXw84fwbGxyUVGIwWxF
	 yQVJt7Bub3Sl64Xq0yRD3gQgfrjXeuRktXhfeTzwQHMbeuyKMG8uioKf2Cn+sUJr8H3TrZFIzCre
	 ROdhZW6wPZXk7ybfdj6d/Pb5CDTP06lBpv5fJNvBDAzK1jrBGgpnV6QyzzOW5EDPIWvkAbceg2XA
	 MxjXthBkqH1uCiT9rjAZSDP97F1jvqBHomQUu+RXzoDIwHy6wqr2lDyi4eLIW7DQygJtydrNYKYy
	 5UvoeaQk3LZo1tClapij+0QTRzWwbuPpv98XhImXq1XowwF28Ap3z7CZARs4p7tsYxbH7PtT1s0W
	 gJ1ywMCGRCD/4iTQ/2NqDK+FTV+J2v8R3PDF2QG7x4yl0booqKLRUXd8WkXGuTJOhMMq2KKum7F+
	 iXCqxUQW6dgco+MgtwnByfniwYCzLqSsdl5N7iPsw5Yuk9l6GqM7LtkycM9iZ1X2XPFcPCIjhTf7
	 GVRXipPtQTL2Q88aOWGShXaSakX5aHUs8/IBSuvHdagmQeLe04cZkFoMZzY4pBLa3lM1B6DhFUgz
	 iUKaMCzKDEHSxFo7cr86J7G0SP7WZHZ4N+yelI3BP7oP5/2aZoykTYP5KUHkYCAUdsgOMKTcQyFZ
	 wfg6ZKC7JMVxLIypBVb/kJllEQFhxaYs5lC3FptNyzO7yRRsMcA/hWuzXq2GoVOk5BPW5Ql7SE6y
	 yOJjiSbi7P5iAFQ247bGzDl7GBhXr6treOk/oqw45mhI+cZT09DoqTC4Q9Nx7svrvV3r0279mpVU
	 qk1cBW4VjM2jiOPErM/Ha+guPqJAux6ctva3E9EbYFbaX93Rp4+PkCg3ThkqMWvc90SIoSbZl4gj
	 +uLGeaqcWA7ZmYKu24IpM27Ztm1M1HdECGJazBL4GVyU0XtUMm2TcgFZkRte9L4fj0PWIY
X-QQ-XMRINFO: NS+P29fieYNwqS3WCnRCOn9D1NpZuCnCRA==
From: Shuai Liu <847807867@qq.com>
To: linux-raid@vger.kernel.org
Cc: song@kernel.org,
	yukuai@fygo.io,
	magiclinan@didiglobal.com,
	xiao@kernel.org,
	linux-kernel@vger.kernel.org,
	syzbot+c5969d7e0a934b384fd6@syzkaller.appspotmail.com,
	sashiko-bot@kernel.org,
	847807867@qq.com
Subject: [PATCH v2] md: reject out-of-bounds desc_nr in super_90_validate()
Date: Mon, 16 Nov 2026 16:59:03 +0800
X-OQ-MSGID: <20261116085903.1081772-1-847807867@qq.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <sashiko-outbox-216570@kernel.org>
References: <sashiko-outbox-216570@kernel.org>
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

Both callers of validate_super() in the hot-add path previously
ignored its return value, so a disk with an out-of-bounds desc_nr
would still be accepted onto the array with the invalid state
intact, and a later md_update_sb() would then write
sb->disks[rdev->desc_nr] out of bounds in super_90_sync() as well.
Make add_bound_rdev() and md_add_new_disk() honor the -EINVAL and
reject the disk instead, which closes that write path too.

Verified with the syzbot reproducer under QEMU with KASAN (7.4-rc3
based config): baseline reproduces the use-after-free on every run,
with this patch the reproducer completes with zero KASAN reports
across repeated runs.

Reported-by: syzbot+c5969d7e0a934b384fd6@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=c5969d7e0a934b384fd6
Signed-off-by: Shuai Liu <847807867@qq.com>
---

Changes in v2:
  - make add_bound_rdev() and md_add_new_disk() honor the
    validate_super() return value so a disk with an out-of-bounds
    desc_nr is rejected instead of being hot-added with the invalid
    state intact; this also closes the super_90_sync() OOB write path
    mentioned in v1 (Sashiko)
  - raid1_add_disk() lacking an upper bound on rdev->raid_disk is a
    related pre-existing issue (Sashiko); it is outside the scope of
    this patch and flagged for separate discussion
 drivers/md/md.c | 16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 03e35386a8028..78ee8d932e71a 100644
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
@@ -3009,9 +3012,10 @@ static int add_bound_rdev(struct md_rdev *rdev)
 		 * then added disks for geometry changes,
 		 * and should be added immediately.
 		 */
-		super_types[mddev->major_version].
+		err = super_types[mddev->major_version].
 			validate_super(mddev, NULL/*freshest*/, rdev);
-		err = mddev->pers->hot_add_disk(mddev, rdev);
+		if (!err)
+			err = mddev->pers->hot_add_disk(mddev, rdev);
 		if (err) {
 			md_kick_rdev_from_array(rdev);
 			return err;
@@ -7590,9 +7594,11 @@ int md_add_new_disk(struct mddev *mddev, struct mdu_disk_info_s *info)
 			} else
 				rdev->raid_disk = -1;
 			rdev->saved_raid_disk = rdev->raid_disk;
-		} else
-			super_types[mddev->major_version].
-				validate_super(mddev, NULL/*freshest*/, rdev);
+		} else if (super_types[mddev->major_version].
+			   validate_super(mddev, NULL/*freshest*/, rdev)) {
+			export_rdev(rdev);
+			return -EINVAL;
+		}
 		if ((info->state & (1<<MD_DISK_SYNC)) &&
 		     rdev->raid_disk != info->raid_disk) {
 			/* This was a hot-add request, but events doesn't
-- 
2.43.0

