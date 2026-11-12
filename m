Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.49
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794474937;
	b=0wK7x451t8Wn6gUqc86V7xjRG63vRcxPtXrvMH17wERFjyi4ZfJ+0wa8vnUa3wcNaQVa
	 JQqdHdUw5KzHgqBtBjvmwm2rMKikcUC/tCd/rB9wWPSFs2KWxcZf6DGFPZGM1gS5JdRLE
	 TjuBG9soH4M2Z8eGOLag8XLLboVgZX0i0cxPLhKX9YwHhXUYLorM/equNG62GO1NHY7Z/
	 tgcqIQ+7P7FuMPPM6HlyOY86aZdRKWXwmEuwbLL0v5lSDtSaZp/lbGqJrb7YPxxkwwl0o
	 m/ZE3WJXuxLIA43eNVYQ2aNd98uXt35RqHm4BeV7sTLmIj/SLutOtC9wR/VkUHWVOcg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794474937;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=yusICm5FqFDhqKagzUFQzYsZYok+0ZTBuA+SIPwr+Q8=;
	b=GyK2I3l2smYW+sbaZVoRtwdigyzu1F2r1W53e1TWnffnfec6U9VNtRIRN5UDDDmh/2Ly
	 HczNH3ElWl9ApCB82fJB2N8UYqmXcIPxyUf5rHkN1A4V0Vw/RApdnABsmp2VPRGfJ4UlD
	 lmYRplKlPVxbIEfLN3ZGhmVy72FZsFd93BP+idvcd+hOs9eKXWDqwAf1e1Y1tKhGwG1kv
	 nKxgRgyQ549znXt1x3iolELHDu+PcogU9NdKxvJARwY6Pl0yzzMICTSemw9mitmGkUL7g
	 4mGHWLvwwp8X3+L/tYKVd/Lk1idCwjghleECAMpt/tPKVBQT5ouCDHHSDUal3PQKcyg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=cloud.ionos.com;
	spf=pass smtp.mailfrom=ionos.com;
	dkim=pass header.d=cloud.ionos.com header.i=@cloud.ionos.com header.a=rsa-sha256 header.s=google header.b=SoVQ1BO0;
	arc=none smtp.remote-ip=209.85.128.49
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1ACBE606A333
	for <linux-raid@vger.kernel.org>; Thu, 12 Nov 2026 09:15:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1ACBE606A333
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cloud.ionos.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ionos.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=cloud.ionos.com header.i=@cloud.ionos.com header.a=rsa-sha256 header.s=google header.b=SoVQ1BO0
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-4a56e05568aso3583425e9.1
        for <linux-raid@vger.kernel.org>; Thu, 12 Nov 2026 01:15:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloud.ionos.com; s=google; t=1794474934; x=1795079734; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=yusICm5FqFDhqKagzUFQzYsZYok+0ZTBuA+SIPwr+Q8=;
        b=SoVQ1BO0VAZw4kc4pJVbOYxZKECJAqy7nj67e0EvhxlR7T5lJaoypjMfjhVpyC2fMz
         oX125kayJQ8ipijpQTzBw5Y8NzSJeBbWVp41GFLNZDV95A/h4WKbKaVuK0etStV1JUuz
         QdFtg4qJ+wxbS0Z2vw+glxpCo+Kw1VqFEyBQ2p5lUEh4ZKkCEzJ78ILoZ0qipaU0jiS+
         B7GfEoxpOw/NrxJVmguaeqWdNWDQPLsJ5WXxg1ijeca5HbY0P2P49j6zGVFgDFhH3K6v
         g+WvaOY8CwGRw4T0QO4shn7HmjAJKelf8DP4vC7tK0+0gIWLN8bs+RjwpBSzalZP8d+o
         c8RQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794474934; x=1795079734;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=yusICm5FqFDhqKagzUFQzYsZYok+0ZTBuA+SIPwr+Q8=;
        b=SuQTOZeviRhfhZPxKFqJyI2Iq5Te84/WYjCv9eMZyDMvyYH0ZM3oDkZ40afDPTp3Ur
         FeJY8lUWzqYlwZGOV9lL9B0HO/rKY5VVLODKB+b2cm3XQqwqS6U0vRtCVIo9KJczFmoB
         mn4ehNvldqKFs62YiHOXukQGa22YYjOsPWs1xZt6/DShiOaoG9Vem9CUMmCYMAG01Txk
         3P2NxCaRZ6ZSDB8OYMRMUC70l00D4O5JR+cgBrC48beA75A++OAu2jJParUAnm2WYUAl
         ExHWpfJV14gNVe7t06urjHB+8m+9CCKaBc3KmUzVCVPwj54icqegjWVElU4yA+BJwO6S
         ufxw==
X-Forwarded-Encrypted: i=1; AL+hErFLFj4lWyXDb7zqAU5vee4vbrK0rnIEs5/C9RZdR28aHo1iCuTi78QcG4NknFv8ECnpJzpCCzzM43rI@vger.kernel.org
X-Gm-Message-State: APuU4Z9cWctu+MzYw7PxJ3JojHtDDUHfKaJ2UUSppi2uGs0PfGXCVxnp
	udrS9cnaaev/3er9xrpJak7DwNL61qfxSJbf+3JK3dYzVDdtnJv9zRuwn6+Ba5Qpujg=
X-Gm-Gg: AYBFou0TDUe9J0G6A8Bt164fShaXNqJyKAsyCVh4TLEoOVPyagN6VWCtm/04I34FAhW
	eKjpaIwruxlgHidYVEnakBGZrG96kQnvPL13kR/bwRW9FWKv8GpzSCuz2DOo4Zi3gSaACHu405T
	6OeZECYzjrVfpTZbZAQatzHye68HQw1Z1F06GzKOhgxBjc7/HBiiMn8PdHzOYrAQbQfFkmUs7oH
	1O1DveqQxOxFxw0nMeuEPTK3WRr4J5fbtOmmWDjeD6QD3Cr/UO+TQOAebOXTk1/lNHKerYWZyer
	F1siOJmg6/jUCYpnk6PUkcNBh7cnPenjt48SNhvk4gOFNIaz5PQ089fySSor19NJ4I4LO+nkQ3G
	Q6QY9b4Rum6WM+ZmwxYr9DeBsI6UbVYxVjZltbzRumExXBNP8x7WHi4yQ1hiiDItTFbqp1wlMZj
	Rc0K80VdFZWkPdQKXEdinlmHofHdPVK14FrD3w+mYZlbrbVDb/k/aLwxNYn79bvL+YZR5GfxIei
	xCYbvy5JBIQQvqgXYOQ/+15uyhXRilhPZr3bbBLf7NuJTP8H4xFpfR0rNI6hg0n8v/mamnuANdh
	Z3NezOS9wUXKCW0HSI5FOGM5skeebw5c+K/9f5jIDvjOwuGXKeDGXU+8aXq3/PzWlnEWzkHOT9d
	tn2Hza1ECdYObAA3dOfNSyWcaFmw=
X-Received: by 2002:a05:600c:4189:b0:4a2:417:7db5 with SMTP id 5b1f17b1804b1-4ba0935d28amr54148265e9.2.1794474934375;
        Thu, 12 Nov 2026 01:15:34 -0800 (PST)
Received: from jwang-ThinkPad-T14-Gen-6.fkb.profitbricks.net ([212.227.34.98])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb4e29daa5sm58129935e9.12.2026.11.12.01.15.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Nov 2026 01:15:34 -0800 (PST)
From: Jack Wang <jinpu.wang@cloud.ionos.com>
To: Song Liu <song@kernel.org>,
	Yu Kuai <yukuai@fygo.io>
Cc: Li Nan <magiclinan@didiglobal.com>,
	Xiao Ni <xiao@kernel.org>,
	linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v4] md: don't leak MD_CLOSING when array_state write is interrupted
Date: Thu, 12 Nov 2026 10:15:33 +0100
Message-ID: <20261112091533.145342-1-jinpu.wang@cloud.ionos.com>
X-Mailer: git-send-email 2.43.0
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

Writing "clear", "readonly", "inactive" or "read_auto" to array_state
calls mddev_set_closing_and_sync_blockdev(), which sets MD_CLOSING to
keep the array from being reopened while it is torn down. The flag is
only cleared again at the tail of array_state_store() (for readonly /
read_auto / inactive, or the failed-clear case).

Between setting the flag and reaching that tail there is an early return:

	err = mddev_lock(mddev);
	if (err)
		return err;

mddev_lock() is mutex_lock_interruptible() on reconfig_mutex. If the
writing task catches a signal while blocked there, it returns -EINTR and
MD_CLOSING is left set on a still-running array. do_md_stop() /
md_set_readonly() never ran, so the array keeps working internally, but
every subsequent md_open() now returns -ENODEV for all callers - the
device shows up in /proc/mdstat and sysfs is fully populated, yet cannot
be opened, and cannot be recovered without a reboot (all clear paths
either need the device open or re-enter test_and_set_bit(MD_CLOSING) and
bail with -EBUSY before the clear).

The window is easy to hit on a busy host: reconfig_mutex is held for long
stretches by a running resync/recovery, widening the interruptible wait,
and a userspace helper writing to array_state and then being killed or
timed out is enough to leak the flag.

Clear the flag directly in the interrupted-lock exit. Guard the clear
with a set_closing flag that records whether this write actually set
MD_CLOSING: the set call is skipped when the array is not running
read-write (or mddev->pers is NULL), and in that case this write must
not clear a MD_CLOSING it never set. This also tightens the pre-existing
tail clear, which had the same unconditional behaviour.

Fixes: 99b902ac1725 ("md: sync blockdev before stopping raid or setting readonly")
Signed-off-by: Jack Wang <jinpu.wang@cloud.ionos.com>
---
v4: (Kuai) drop the Assisted-by tag, checkpatch does not accept it.
    Keep the set_closing guard at the tail clear but still skip it after a
    successful clear: md_clean() keeps MD_CLOSING set (except for legacy
    async del_gendisk with hold_active), so clearing it here would let the
    stopped array be reopened.
v3: (Kuai) clear MD_CLOSING directly at the mddev_lock() failure and
    return, drop the out_clear_closing label; reword the commit message.
    Keep the set_closing guard: the set call is skipped when the array
    is not rdwr or mddev->pers is NULL, so this write may not own the
    flag. Rebased on v7.4-rc1.
v2: guard the clear with set_closing.

 drivers/md/md.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 03e35386a802..fb9c4d12c4c5 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -4671,6 +4671,7 @@ array_state_store(struct mddev *mddev, const char *buf, size_t len)
 {
 	int err = 0;
 	enum array_state st = match_word(buf, array_states);
+	bool set_closing = false;
 
 	/* No lock dependent actions */
 	switch (st) {
@@ -4691,6 +4692,7 @@ array_state_store(struct mddev *mddev, const char *buf, size_t len)
 		err = mddev_set_closing_and_sync_blockdev(mddev, 0);
 		if (err)
 			return err;
+		set_closing = true;
 		break;
 	default:
 		break;
@@ -4718,8 +4720,12 @@ array_state_store(struct mddev *mddev, const char *buf, size_t len)
 		return err ?: len;
 	}
 	err = mddev_lock(mddev);
-	if (err)
+	if (err) {
+		/* Interrupted before any teardown ran, don't leak MD_CLOSING */
+		if (set_closing)
+			clear_bit(MD_CLOSING, &mddev->flags);
 		return err;
+	}
 
 	switch (st) {
 	case inactive:
@@ -4792,8 +4798,8 @@ array_state_store(struct mddev *mddev, const char *buf, size_t len)
 	}
 	mddev_unlock(mddev);
 
-	if (st == readonly || st == read_auto || st == inactive ||
-	    (err && st == clear))
+	/* A successful clear must keep MD_CLOSING set, see md_clean() */
+	if (set_closing && (st != clear || err))
 		clear_bit(MD_CLOSING, &mddev->flags);
 
 	return err ?: len;
-- 
2.43.0

