Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=109.224.244.108
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794696483;
	b=IFVmX+N5BevtfKfVSgSSFgU204/PE+xfyMpRyGXedWuefiLftHJEgZhPQagz5uyl5nZ8
	 m1B0Ngmi8TnsMy/chVV4TR5vAZ9kl989772Xey4WWHGtQ/jlEubBBr+o8uMCiJE1YjgLz
	 HDTuUHYYQZQ3UDOh0QkuW5ADc6sBZ3N45z2aAjFzVd+/as1gwCxj0n11nldW+MQSoKVJB
	 9LjpHxXQKC5GiUfnOzS+OCEV95i2Udnncu6WpOHVRKHJ+NBVGoicJW1kJnpcaqd0fKVpr
	 yESXugb7DhndKXoADE/Q2P+laIC0T0fnHgFIBhGw6jNqyuogn/WnHbDySzmKSDdN7KA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794696483;
	h=DMARC-Filter:DKIM-Signature:X-Pm-Submission-Id:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=oJnvjAQjEbs1xzocyvMCNt5rh/BsK7Lbd+Sv8sEk4wo=;
	b=jbmVRvhfdHw69zIE3/SACcOm++AOMELKfLjV59cm24CoEJ5X74cbcoNe69Bx39X9gWCf
	 4oxsUyXYmLciiVnWAHvXdZrX1R/cI5t8cegN/InocTBmzSYdCZwLmsjzhjTT885MxBjjZ
	 ggABfGOXE3BiqwDVHhFja8a7tr0awf4iu3i9IhOIsC7ZVSTfb7S+qk1rnhzdftTWjT+Up
	 YPZH6LGj+ykxV9dfqjKoa6GDnaHmL9rWMdg3yJF2jFiF9SLEp7uG2Wx2xMSmn+RKvwM8R
	 AYfMAHWNxF/C7Wa/vb0a06goEoJCJv3TkCi2EqrhtIxyLCL2ogTdpp7aqX8g9Reigwg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=raidlab.org;
	spf=pass smtp.mailfrom=raidlab.org;
	dkim=pass header.d=raidlab.org header.i=@raidlab.org header.a=rsa-sha256 header.s=protonmail header.b=Euk0LrgY;
	arc=none smtp.remote-ip=109.224.244.108
Received: from mail-244108.protonmail.ch (mail-244108.protonmail.ch [109.224.244.108])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32041606A327;
	Sat, 14 Nov 2026 22:48:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 32041606A327
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=raidlab.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=raidlab.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=raidlab.org header.i=@raidlab.org header.a=rsa-sha256 header.s=protonmail header.b=Euk0LrgY
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=raidlab.org;
	s=protonmail; t=1794696477; x=1794955677;
	bh=oJnvjAQjEbs1xzocyvMCNt5rh/BsK7Lbd+Sv8sEk4wo=;
	h=From:To:Cc:Subject:Date:Message-ID:From:To:Cc:Date:Subject:
	 Reply-To:Feedback-ID:Message-ID:BIMI-Selector;
	b=Euk0LrgYoBdBXSbOskn8ilfM0VOiLLi5nCdY4wL/yQEYU6yx3xi3X4RLeagd+Lo83
	 s5OAIKmOGyKQbSgFYyvi6g5+71vt5WO2QIC8tR6RR0joklDMBr2S5kFDI96Be+/0Gd
	 kjapWoqdKyuauMH5IGitrcqAOOkuT5x/BWdYjzVAIRca95MOluZTweUzcV9gbGzswK
	 txFA8p6hgwMdejFw+d6ZL7gxp8DRfhfSpclHp3IJ2Vk1U+1qsQpvjv0xw58N/YGFUa
	 +fYQLb4BQreQASHrTgDh0Lb/hqxXi0DbY1Z6k69Z2vIIPaaC3p433o7MvMKIYZLk5k
	 Tkx1ePQlLMWUA==
X-Pm-Submission-Id: 4jRq5h3lt6z1DDXR
From: Miroslav Cimerman <mc@raidlab.org>
To: Song Liu <song@kernel.org>,
	Yu Kuai <yukuai@fygo.io>
Cc: Li Nan <magiclinan@didiglobal.com>,
	Xiao Ni <xiao@kernel.org>,
	Tejun Heo <tj@kernel.org>,
	NeilBrown <neil@brown.name>,
	linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Anton Gavriliuk <antosha20xx@gmail.com>
Subject: [PATCH] md/raid5: fix write stalls when a write is queued during a drain
Date: Sat, 14 Nov 2026 22:46:36 +0000
Message-ID: <20261114224636.34362-1-mc@raidlab.org>
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

With continuous O_DIRECT writes to a RAID-5/6 array that uses
read-modify-writes, a few 4k writes can take seconds to complete, up
to the length of the run.

The pre-read permission (STRIPE_PREREAD_ACTIVE) belongs to a stripe.
A REQ_SYNC write queued while an earlier write on the same stripe is
being drained finds the bit set and gets no count of its own in
preread_active_stripes. handle_stripe() clears the bit when the drain
result is handled, so the queued write gets STRIPE_DELAYED, and the
stripe goes to delayed_list together with the completion of the
drained write. raid5_activate_delayed() only moves it on once
preread_active_stripes is below IO_THRESHOLD, which with other
REQ_SYNC writes in flight may happen until the load stops.

Check for writes queued on the stripe, under stripe_lock, after
clearing the bit, and keep the bit and its count if there are any.
A write queued later tests the bit after the clear and either takes
the permission itself or finds it kept. Do this for any queued write:
a queued buffered write would otherwise hold back the completion of
the drained write the same way.

md-7.4, RAM disks, 4k random writes, io_uring, QD64, 20 s, slowest
write without -> with this patch, md defaults (1 job) and
group_thread_cnt=8 (16 jobs):

  RAID-6 4+2 (rmw_level=2) 18.0 s -> 2.0 ms  19.3 s -> 5.8 ms
  RAID-6 8+2               13.4 s -> 2.2 ms  13.0 s -> 7.0 ms
  RAID-5 5+1               16.9 s -> 1.8 ms  18.3 s -> 4.9 ms
  RAID-5 9+1               17.4 s -> 2.2 ms  12.0 s -> 5.8 ms

IOPS are unchanged with md defaults and within a few percent with 8
workers. Buffered writes are not affected.

Fixes: e9c7469bb4f5 ("md: implment REQ_FLUSH/FUA support")
Cc: stable@vger.kernel.org
Signed-off-by: Miroslav Cimerman <mc@raidlab.org>
---
 drivers/md/raid5.c | 41 +++++++++++++++++++++++++++++++++++++++--
 drivers/md/raid5.h |  4 +++-
 2 files changed, 42 insertions(+), 3 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index efb4b0d37cb0..b103cc8d142a 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -5011,6 +5011,27 @@ static void break_stripe_batch_list(struct stripe_head *head_sh,
 		set_bit(STRIPE_HANDLE, &head_sh->state);
 }
 
+/*
+ * Check if a stripe head has any writes queued. Takes sh->stripe_lock under
+ * which writes are queued.
+ */
+static bool stripe_has_queued_writes(struct stripe_head *sh)
+{
+	bool queued = false;
+	int i;
+
+	spin_lock(&sh->stripe_lock);
+	for (i = 0; i < sh->disks; i++) {
+		if (sh->dev[i].towrite) {
+			queued = true;
+			break;
+		}
+	}
+	spin_unlock(&sh->stripe_lock);
+
+	return queued;
+}
+
 /*
  * handle_stripe - do things to a stripe.
  *
@@ -5165,8 +5186,24 @@ static void handle_stripe(struct stripe_head *sh)
 					set_bit(STRIPE_INSYNC, &sh->state);
 			}
 		}
-		if (test_and_clear_bit(STRIPE_PREREAD_ACTIVE, &sh->state))
-			s.dec_preread_active = 1;
+		if (test_and_clear_bit(STRIPE_PREREAD_ACTIVE, &sh->state)) {
+			/*
+			 * A write queued while the previous one was drained
+			 * has no pre-read permission of its own: a REQ_SYNC
+			 * write or discard found the bit set, other writes
+			 * never take it. Keep the permission for it, or it
+			 * gets STRIPE_DELAYED and the stripe, together with
+			 * the completion of the drained write, may wait on
+			 * delayed_list until preread_active_stripes drops
+			 * below IO_THRESHOLD. A write queued after
+			 * stripe_has_queued_writes() tests the bit after our
+			 * clear, so it takes the permission itself or finds
+			 * it kept.
+			 */
+			if (!stripe_has_queued_writes(sh) ||
+			    test_and_set_bit(STRIPE_PREREAD_ACTIVE, &sh->state))
+				s.dec_preread_active = 1;
+		}
 	}
 
 	/*
diff --git a/drivers/md/raid5.h b/drivers/md/raid5.h
index 1a61b474fc22..c3feb7779dbe 100644
--- a/drivers/md/raid5.h
+++ b/drivers/md/raid5.h
@@ -448,7 +448,9 @@ enum {
  * When preread is initiated on a stripe, we set PREREAD_ACTIVE and add
  * it to the count of prereading stripes.
  * When write is initiated, or the stripe refcnt == 0 (just in case) we
- * clear the PREREAD_ACTIVE flag and decrement the count
+ * clear the PREREAD_ACTIVE flag and decrement the count. When write is
+ * initiated and another write is already queued on the stripe, the flag and
+ * the count are kept for that write (see handle_stripe()).
  * Whenever the 'handle' queue is empty and the device is not plugged, we
  * move any strips from delayed to handle and clear the DELAYED flag and set
  * PREREAD_ACTIVE.

base-commit: 47e1b18f38d74015cb9fd30b5ff2a1eb88e77d31
-- 
2.53.0

