Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.46
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793604960;
	b=WquWA4xPTEVLP3S0r/XMSdkAA9t8wLfLHNa1vZTYTqr+7XF/Yc8bo5j0kAuzchLDKS1y
	 cJKto1GSTCOWfwKeNQh9DXVxNukjA+JUJ8R8YLT8j0XGlEXsXGesxLTJJUpR9vywKXoUo
	 iw9L72Ewsar/WrktDdu/VOUA+OpsO9cXBbT9ApxwJpAPBVJdvUmrtBU8AHXx4HYkGQhcA
	 Dg/U1+6nuzSOv0MangUceoITsnXYxyBf9/hB/syIin5QgGl9kTnt2Tqrg9y911w9QuCa+
	 hR6o7G7n+lfcTQDqa5fdyq5qtZ6tSA7rKFyO73bR7Ei+y1z5IaUhaEOYytSmFykPMUg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793604960;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=tgeRDsuy5w8yKpx9FEg0UTJK5z2DUghOSJu6TemiYLc=;
	b=sjhyMgX3so/2OhZmZ2KY8aMz5llIopVxRXJIjdJ+TZ0qyEXtjn0DzAE1LDHPtgq71LgC
	 72uM8vFWlM0sWD0K/wSvtKRrqye0MskLDjYDB/ncRFGrXvwYgWEdY1ys9vCx9ShILTnvo
	 Pm4Qhnj3F5ZYypuGE8zei/7PPc6XbN7JBEhpJK9Eb2h0GEhudRMNT0ie7BweF1uyXJpH1
	 Nus9P+gSTa5c5zkm4sYb1WK6sP6jgRyA+gPpSR+2n82E9xjafCOuTeClHQJWzrU82n52S
	 OzBn0IKMMpfIl0SV3Ionsf6tC1lVKmzpBFt8FY/9l2MGf/QnCGqPtlOKHGYahQgxLKQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=ionos.com;
	spf=pass smtp.mailfrom=ionos.com;
	dkim=pass header.d=ionos.com header.i=@ionos.com header.a=rsa-sha256 header.s=google header.b=eL9FLDwT;
	arc=none smtp.remote-ip=209.85.128.46
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF633606A33F
	for <linux-raid@vger.kernel.org>; Mon,  2 Nov 2026 07:35:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org DF633606A33F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ionos.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ionos.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=ionos.com header.i=@ionos.com header.a=rsa-sha256 header.s=google header.b=eL9FLDwT
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-4a56e05568aso10915555e9.1
        for <linux-raid@vger.kernel.org>; Sun, 01 Nov 2026 23:35:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1793604958; x=1794209758; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=tgeRDsuy5w8yKpx9FEg0UTJK5z2DUghOSJu6TemiYLc=;
        b=eL9FLDwTm7RgAydFwUlBt59URClfd6IDs4z2aAAMigqvsWcEIpNe+qPq3JHzUJHva1
         Oq4s1W810lhJ4XEp1rUF8hFiGGf2ccPPdPJVbRV2A7iusf+caTcUk3uF05h0nIbKDTBE
         peT/BYm859Xro6EcNUKbcpw0jG9ZhtvJG60PUDwQduxemZjTD34WeShHbR1bIYBDOJQ6
         3S4qHJUG1ARNhCFQJSpEV6jZGlzeQ3qOf2V6ecBKDnTcnvmzUCRocO7nPgk3jtzniRP9
         YbYi+gCm929GO0KJ8PPehmhB/o/cOzGKRd3j/ud5PEVE+qFhUlE3f18icD6ZFi8Hh5/5
         9bHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793604958; x=1794209758;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=tgeRDsuy5w8yKpx9FEg0UTJK5z2DUghOSJu6TemiYLc=;
        b=fvTM7l4ZBW+FDuQPchotkrav0lmIL8tqMHVSyX556epAo/OPhGbT4oGRpk0W9RK5BA
         1BrFw+CM+fqBD6K0j0+vnp06GFsPq5I52mgxRsFu7jDzS0axA3YTV1q+P/N/+uq66X2b
         RHi3REpaBGlH9+Wa/VsGQENylep1jvCxXplATx866AN/AnQhHgNfmtoT4ebFFSmO0kld
         tgAVt58S9uxZX9zSg8jm+wQR9YLJVqFzrZLBdybEWcRKTloBoYpmgNJwdwytL9vqz7zF
         c5l8t2QtqQPyRRVr//Da5ruZYvswEt3Yw7lnBgFAhstKG3ijdZvIB10ZqcERx2nMidsq
         nGzg==
X-Forwarded-Encrypted: i=1; AKwUvBzlJHxGt1L1iV2htVpSNUtolHeuEWtHfl2UZo3UQe1FCEdG9buW5EyU5WVj26pdtCIoPDOQDUVWK8ZZ@vger.kernel.org
X-Gm-Message-State: AFq9FYJfGmq/6tJQYsvEI9LfKs/HZjBxwx/LGKBA6uWqqPIeDEd0aJVB
	MNLLoc7SPKPxZRgZejgMfvbT3+PalPjd1/aik579y0U3pv7Kma7bNaxO7c2MyoDaM10=
X-Gm-Gg: AYBFou0xLN2qEhXfkIBupXFvbuaL9UnVA0/886ilPRZhI7Ro1DhNkgqeNE1tMBuO3Pg
	NQNpJ6yniPGzTt1IYJ+zbpQn1bGRuEkYLTQfT2UxAtqsU3nOT1SgEzXYxAIaAoIGPPC8HnBMd7H
	zMc6TEolKB2pgWclo/QX1J/rjVMUVPnAai2d8TKRYe6fZsORXzKxG9b4InCUyY+bBgJ8ZRGpZoy
	yO9CKKe03zBrMss5jcROwqh52tq9XwwIMz6h+g9yemzwv5gorwzFXKTd11q9NrMf/GcoP617f7I
	QWMMQo9yB40IDqkBmdCjBsoy9QQvMctHcXqq6UN5m1I5hoA9m2qvzFAracrRZqkgQpcUJHnnaAM
	X1uTKdIg6+OhydwGttZ/mO+6TWpt0JCt6QG6biou7wtycwwPcmMRyM6+7eXEtjasSaoI+IknfGe
	W7HHcf2tT3I6/hRXra+FfBwSOv6A4qwzmBhmmtnHgUOy8iIhONgrH0pg6ztFsbY6Sc3Sc/38UN8
	32QF0HheiQjsRa0zDb6/l6VfRyve5j1mUtP4L9AZi0SHfelHkcglQvxLptwZnPztOA3nHY1kHxr
	UgQF9+l2ZMz+OafNGfwZlZO2NdW2IIfXT97/7p0cx76ibhlRkNYQQaYlmdTQDg==
X-Received: by 2002:a05:600c:c08c:b0:4a0:1e9f:64f6 with SMTP id 5b1f17b1804b1-4ac12193b17mr168784715e9.0.1793604957868;
        Sun, 01 Nov 2026 23:35:57 -0800 (PST)
Received: from jwang-ThinkPad-T14-Gen-6.fritz.box ([2001:9e8:1447:4f00:35ef:c1f0:6ffd:177c])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48e71baa1b3sm17676058f8f.56.2026.11.01.23.35.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 01 Nov 2026 23:35:56 -0800 (PST)
From: Jack Wang <jinpu.wang@ionos.com>
To: Song Liu <song@kernel.org>,
	Yu Kuai <yukuai@fygo.io>
Cc: Li Nan <magiclinan@didiglobal.com>,
	Xiao Ni <xiao@kernel.org>,
	linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Jack Wang <jinpu.wang@cloud.ionos.com>
Subject: [PATCH v3] md: clear MD_CLOSING when array_state_store() bails on interrupted lock
Date: Mon,  2 Nov 2026 08:35:55 +0100
Message-ID: <20261102073555.53941-1-jinpu.wang@ionos.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <eded31de-2e92-4a3b-9384-03dbebc5e9e7@fygo.io>
References: <eded31de-2e92-4a3b-9384-03dbebc5e9e7@fygo.io>
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

From: Jack Wang <jinpu.wang@cloud.ionos.com>

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
Assisted-by: Claude:claude-opus-4-8 [Claude Code]
Signed-off-by: Jack Wang <jinpu.wang@cloud.ionos.com>
---
v3: (Kuai) clear MD_CLOSING directly at the mddev_lock() failure and
    return, drop the out_clear_closing label; reword the commit message.
    Keep the set_closing guard: the set call is skipped when the array
    is not rdwr or mddev->pers is NULL, so this write may not own the
    flag. Rebased on v7.4-rc1.
v2: guard the clear with set_closing.

 drivers/md/md.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 03e35386a802..f14a31387990 100644
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
@@ -4792,8 +4798,9 @@ array_state_store(struct mddev *mddev, const char *buf, size_t len)
 	}
 	mddev_unlock(mddev);
 
-	if (st == readonly || st == read_auto || st == inactive ||
-	    (err && st == clear))
+	if (set_closing &&
+	    (st == readonly || st == read_auto || st == inactive ||
+	     (err && st == clear)))
 		clear_bit(MD_CLOSING, &mddev->flags);
 
 	return err ?: len;
-- 
2.43.0

