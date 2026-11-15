Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=109.224.244.108
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794746337;
	b=nMDx0ivZzQy7oGQkSJbJbvINPNCU27c4M7xKnrZap1dHedO9atr5hhn08PFT4L1Nw1oa
	 XBsap828rcGmWwmpnyqhciWflspzPPD97vwfmmVAKIg1khQ1Aqo+/MA8GhIwM0I6E22Hp
	 sQWw/pWDDaXkwsTGNyYkf4ZEjLCT9jbtnDttfoWuSTCQujuOpeStjd+X6VzZFg2GzeUMk
	 m+UUC0hbzU3hYS2mNS1pI0QgAyXXvcNZ2FxrrVSTH28DlbULet0FWEdJweciEchEGITvo
	 D6wEaCuirERU10be17DH6sNcw9oVo44K6KBfQ43C2Ed13NyB8IIc8kOVn+j6Wo/cKyw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794746337;
	h=DMARC-Filter:DKIM-Signature:X-Pm-Submission-Id:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=GV5q5oyXG7o+6/jvs0rBK3bgCf4MVUtphWiCoyitBwU=;
	b=IxkKLJSvMKKK7D9w2LA+AncV6HiVb+V1Pd1LXyIz+w2IiiCyZMBpATfKxGoScoxmG9SW
	 DAdPRIiKv2ciJau0FysvdrLt0JNCNLI/21t0dqCxsWlKFvL4DtA7dnaXXdHuQN1crwMzg
	 Eqkmo3SFTXhoC2f81abdWr+VbzFy6Xc5ulx7lkm75EnfSdGmgRm7+6FaZFMTZp0RQYWNp
	 l78qMZZo7nxix3NNARwDh6a0Iv0eZfK24cnb0saE7M2hu3l5LHAIwxY+WQCUZTgOXfuME
	 hn6Ge26QiKasp99JuT8BQJfhij2WU4RdBVIXolzKwrDkZ/iqZzYMOltSq9XZXx7O8GA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=raidlab.org;
	spf=pass smtp.mailfrom=raidlab.org;
	dkim=pass header.d=raidlab.org header.i=@raidlab.org header.a=rsa-sha256 header.s=protonmail header.b=w1jUf+GB;
	arc=none smtp.remote-ip=109.224.244.108
Received: from mail-244108.protonmail.ch (mail-244108.protonmail.ch [109.224.244.108])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5439606A33B
	for <linux-raid@vger.kernel.org>; Sun, 15 Nov 2026 12:38:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D5439606A33B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=raidlab.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=raidlab.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=raidlab.org header.i=@raidlab.org header.a=rsa-sha256 header.s=protonmail header.b=w1jUf+GB
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=raidlab.org;
	s=protonmail; t=1794746333; x=1795005533;
	bh=GV5q5oyXG7o+6/jvs0rBK3bgCf4MVUtphWiCoyitBwU=;
	h=From:To:Cc:Subject:Date:Message-ID:From:To:Cc:Date:Subject:
	 Reply-To:Feedback-ID:Message-ID:BIMI-Selector;
	b=w1jUf+GBRM0NAa9ars55BdD+jwPqQGhMfMnzBXZblYRn1jX1EffQiP0X1WQgxMYB0
	 lD1JRh3BiQ0n8YzFMQfhkO6dp9loWacpCUi0IEJbeg8kL6zuaV+EeIStBhMwH88CAg
	 8qPsRlBwM7MI2CS5e2mTeip0a7NkAzBBxQsniOatABnzbi4mFlcZrD6lgZLncbiRIO
	 CtO5IlIDoWUBnuQPNN7X/p4EAzshpLtQj3SnWw2HPZ45ZLYwPXcU8k69ctYDyzube+
	 +oQBPAN9XuGxt4E8P8PaKjYmM0Y+IqVEF9DdiqT12T+1Tq31q+qQURrSO7rVdkAZhS
	 04rk1o2I2gM6Q==
X-Pm-Submission-Id: 4jS9XT5PKSz1DDXX
From: Miroslav Cimerman <mc@raidlab.org>
To: Song Liu <song@kernel.org>,
	Yu Kuai <yukuai@fygo.io>
Cc: Li Nan <magiclinan@didiglobal.com>,
	Xiao Ni <xiao@kernel.org>,
	NeilBrown <neil@brown.name>,
	Namhyung Kim <namhyung@kernel.org>,
	linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] md/raid5: fix wrong read data on RAID-4/5 with two failed devices
Date: Sun, 15 Nov 2026 12:38:17 +0000
Message-ID: <20261115123817.48388-1-mc@raidlab.org>
X-Mailer: git-send-email 2.53.0
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

On RAID-4/5, a read of a block on a working member can return wrong
data, without reading the member, when the stripe has two failed
devices: the array has failed (MD_BROKEN only stops writes), or it is
degraded and another member has a bad block in the stripe, for
example after a write to it failed.

fetch_block() computes two missing blocks at once when all but two
blocks of the stripe are up to date and two devices have failed. That
needs P and Q, but nothing limits the branch to RAID-6. On RAID-4/5,
ops_run_compute5() computes sh->ops.target as the XOR of all the other
blocks, including the second target, which was never read, and
ops_complete_compute() marks both targets up to date. The read returns
the XOR of the cached blocks and the unread page, and a later read of
the second target returns that page instead of an error. The page is
not cleared, so it can hold data of another block.

Commit 93b3dbce6456 ("md/raid5: unite fetch_block5 and fetch_block6")
brought the branch to RAID-4/5. fetch_block5() computed only one block.

Take the branch on RAID-6 only, with the sh->qd_idx >= 0 test that the
branch above already uses. On RAID-4/5 the block is then read from its
member, and reads of failed members are failed by
handle_failed_stripe() as before.

For example, take a degraded 4-device RAID-5 (left-symmetric, 4 KiB
chunks, device 1 missing) where block v holds the byte 0x10 + v. A
write to block 3, on device 3, does a read-modify-write. Its write to
device 3 fails: md records a bad block, keeps the device and fails the
write. A read of block 4, on device 0, then returns 0x14 ^ 0x15 ^ the
unread page (0x01 if it is zero) instead of 0x14, and a read of block
5 returns the unread page instead of EIO.

Found with FuzzyRAID, a fault-injection tester for RAID.

Fixes: 93b3dbce6456 ("md/raid5: unite fetch_block5 and fetch_block6")
Cc: stable@vger.kernel.org
Signed-off-by: Miroslav Cimerman <mc@raidlab.org>
---
FuzzyRAID is not public yet. The analysis, the fix, the commit message
and the reproducer were written with the help of an LLM. I reviewed
everything and ran the reproducer on md-7.4 with and without this
patch.

Reproducer (needs only standard tools):

#!/bin/bash
# md RAID 5 with two failed devices for a stripe: a read of a block on a
# working member returns wrong data, without reading the member, when exactly
# disks-2 blocks of the stripe are cached.
# Needs root, mdadm, losetup and GNU coreutils; uses /dev/md99 and 3 loop devices.
set -e
D=$(mktemp -d)
for i in 0 2 3; do
        truncate -s 64M $D/m$i
        L[i]=$(losetup -f --show $D/m$i)
done
blk() { head -c 4096 /dev/zero | tr '\0' "\\$(printf %o $1)"; }
for v in $(seq 0 11); do blk $((0x10 + v)); done > $D/pattern   # block v = 0x10+v
blk 0xaa > $D/aa

# degraded 4-device RAID 5, 4 KiB chunks;
# stripe 1: block 3 on m3, block 4 on m0, block 5 on m1 (missing), P on m2
mdadm -C /dev/md99 -R -l5 -n4 -c4 --assume-clean --bitmap=none \
        ${L[0]} missing ${L[2]} ${L[3]}
dd if=$D/pattern of=/dev/md99 bs=48k oflag=direct status=none
mdadm -S /dev/md99                              # empty the stripe cache
mdadm -A -R /dev/md99 ${L[0]} ${L[2]} ${L[3]}

# read-modify-write of block 3: caches block 3 and P only
dd if=$D/aa of=/dev/md99 bs=4k seek=3 oflag=direct status=none
# second failure; md fails m3 and returns EBUSY, the array has failed
echo faulty > /sys/block/md99/md/dev-${L[3]#/dev/}/state 2>/dev/null || true

rd() { dd if=/dev/md99 bs=4k skip=$1 count=1 iflag=direct status=none | od -An -tx1 -N1 | tr -d " "; }
echo "block 4 (m0, working), expected 14: $(rd 4)"
echo "block 5 (m1, missing), expected I/O error: $(rd 5 2>&1)"

mdadm -S /dev/md99
for i in 0 2 3; do losetup -d ${L[i]}; rm $D/m$i; done
rm $D/pattern $D/aa; rmdir $D

 drivers/md/raid5.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index efb4b0d37cb0..f71fb0a265e4 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -4019,9 +4019,11 @@ static int fetch_block(struct stripe_head *sh, struct stripe_head_state *s,
 			 */
 			s->uptodate++;
 			return 1;
-		} else if (s->uptodate == disks-2 && s->failed >= 2) {
+		} else if (s->uptodate == disks - 2 && s->failed >= 2 &&
+			   sh->qd_idx >= 0) {
 			/* Computing 2-failure is *very* expensive; only
-			 * do it if failed >= 2
+			 * do it if failed >= 2. It needs P and Q: RAID-4/5
+			 * computes one block only.
 			 */
 			int other;
 			for (other = disks; other--; ) {

base-commit: 47e1b18f38d74015cb9fd30b5ff2a1eb88e77d31
-- 
2.53.0

