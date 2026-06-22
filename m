Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D891439B975
	for <linux-raid@vger.kernel.org>; Mon, 22 Jun 2026 14:25:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782138326; cv=none; b=OMiyFvXoXLyHlGsAIJqnpKcx+Mc6JeyYWX8Q3w7O3pRqKp8o51tL5GAvEZG3gUzEymb8DeIB/C0L0EQHZWH5M2CcCLBkRtYt58X550swrhwBsB7oKCWt/cwXUJqxJFCIKcT1XT+6thShtPXgRQAzOA+4HNnBStye6fQJuL4K0Tg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782138326; c=relaxed/simple;
	bh=6TlC5iKs4oGGtjlQhKrO62YrJ1iR7M1LI24T+DV3aio=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=R6rCudAmjboqISoVwAqTMRjGWmBE4erRDgpiS2m2v5N5sHUBgrT1kmhW1kAn5534AJLdDHrQPhvrIosB7+A4JvYlN1mvVb+RjPJc4EcyovALOUQVzKI7ua4jFV8LBW3CHT7V50nUXVe+k1mXpu4rzD36Vfpbi/3OoI4rn5CjMeY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=YSGATbL9; arc=none smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YSGATbL9"
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-2c0c3546924so34293915ad.3
        for <linux-raid@vger.kernel.org>; Mon, 22 Jun 2026 07:25:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782138324; x=1782743124; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=RpcQYOvswIv41txXTMSElAqSDhX4txnVyyIxDhRgzp8=;
        b=YSGATbL9gzB/mIVjJQH4h/LwvHkEYWP7cI1cQqDCBFyuoaofacyEUb5tH3Ri0yp0qs
         +mdPlZdxQhIR7/ibv+CFOdbBlKwIh/nRQYgSvi8SRR/AJKxenVhKS6jSh0OROIAPMbaa
         ylpRwZfncm0Lkms6GW7jY+U+r9JNOhZnakmQlLvU634FfIyIWKk6GL/eoyyWQEoYGKvN
         IkUFf8QIh8+z2kHbMJqcu62WQt/WNDHLbcfnFD0Db8hl+GalqOnNk54kLRH7gr0p952k
         b+DfuFmGpW43CyyV4R26Wj5AtQU1gVeoPk34Xx4MPR2nEXJ50xQzA/peqgP7tbjAVV7x
         NeDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782138324; x=1782743124;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RpcQYOvswIv41txXTMSElAqSDhX4txnVyyIxDhRgzp8=;
        b=KSa0vHT0sqvoKSDIFCsq99kZx2jCKvXjSA7dBQcNsc0YmABb7a3xD7vqAh5wthz+IZ
         Y1T1B8ZM4ozYPSlqQ1e9e3mFO9TMKlkBNHlQ4NVdmf36Y22L8+cpdHcj4PFE9MbijfU1
         bNt6MQkiBAKH09WcQbFZU1fuidbhVgP/wL7DYLTghdb7d2N8u80VJj7QTdXA2M2oIIX6
         wPMPJRnFtZHd6qRktbW56fXMFzmD4vEC2TxLQMUVPc4qAkw9aSTIW88Z3PAj4KJRmwDb
         NidYgX/kyo7SnrAfUneYZyYnxnbizmOMDokXoW+3abVnQVo8LVDBb9PCfFSYPqnX8QL7
         lJZg==
X-Gm-Message-State: AOJu0YzNl1JPzFyXsSiVSo/uL8+mThILbBY9GHXUbiy9v8+3DExfG4lF
	dtOYwXXOlohqfBljyYuhVODwz/69R0aU1mOSff68WsPWijxR7GHBkA20DeVSrmn6bg0ahQ==
X-Gm-Gg: AfdE7cmY9IHR7P/i27fGGxLFHf/roWRrOmag46KaFLdKmg/iY08jsOMcfLIefbLaQQH
	7Ah0/wINtU6aOEsOe89VUVQA7MyS7mx9hwzN4FajQmqb9Xacr2k4fMUF5ozWvuf+FzBUS+iLXFY
	iUyojSY1URg5rFZH1v+XUd8GXbSaxspbNVh+22PdH3hnbRimSi1LooW02MPzezpkHHLap7Wb3Mm
	YO3NoSlt7ckzXoZUM/27F6ezcL4xnqaEchxSQujJ8diAjfKPLl585jackMm+VTlXbsZ0WgsCK2t
	rNzatklDWPGI0NokzAOplZxN0IzPcvuf4r4X/2tsGJPrEEeWVQfdnXGAk/EjdTydR8P3yalwAI3
	iuIBmiENQu5wJHtx9DbK5jCYqQDmF6nT6pM8zn+lMg7XW2wTxfx4ErdK7+1NBJeufAjnbaQx5O8
	v7IJYNmclh0tTRmI40Qa0vfoii7As=
X-Received: by 2002:a17:902:e84c:b0:2bf:1e59:d99 with SMTP id d9443c01a7336-2c718f1f359mr143907015ad.8.1782138323993;
        Mon, 22 Jun 2026 07:25:23 -0700 (PDT)
Received: from fedora ([2409:40d2:1263:e07c:fd73:765d:e4e1:c1eb])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2c7436af220sm78063345ad.16.2026.06.22.07.25.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Jun 2026 07:25:23 -0700 (PDT)
From: Sajal Gupta <sajal2005gupta@gmail.com>
To: linux-raid@vger.kernel.org,
	song@kernel.org
Cc: yukuai3@huawei.com,
	tomasz.majchrzak@intel.com,
	linux-kernel@vger.kernel.org,
	error27@gmail.com,
	skhan@linuxfoundation.org,
	me@brighamcampbell.com,
	linux-kernel-mentees@lists.linux.dev,
	Sajal Gupta <sajal2005gupta@gmail.com>
Subject: [PATCH v2] md/raid5-ppl: fix use-after-free in ppl_do_flush()
Date: Mon, 22 Jun 2026 19:36:03 +0530
Message-ID: <20260622142146.56637-1-sajal2005gupta@gmail.com>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The loop in ppl_do_flush() continues iterating after calling
ppl_io_unit_finished(), touching io->pending_flushes and leading to a
use-after-free.

Add a break statement to stop the loop once io is freed.

Fixes: 1532d9e87e8b ("raid5-ppl: PPL support for disks with write-back cache enabled")
Reported-by: Dan Carpenter <error27@gmail.com>
Closes: https://lore.kernel.org/all/ajJF2wKYWRk4GGCK@stanley.mountain/
Signed-off-by: Sajal Gupta <sajal2005gupta@gmail.com>
---
Compile tested only.

Changes in v2:
 - drop the refcount_t conversion

v1: https://lore.kernel.org/all/20260622080656.22786-1-sajal2005gupta@gmail.com/

 drivers/md/raid5-ppl.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/md/raid5-ppl.c b/drivers/md/raid5-ppl.c
index a70cbec12ed0..c3cfdd66d8b0 100644
--- a/drivers/md/raid5-ppl.c
+++ b/drivers/md/raid5-ppl.c
@@ -643,8 +643,10 @@ static void ppl_do_flush(struct ppl_io_unit *io)
 	log->disk_flush_bitmap = 0;

 	for (i = flushed_disks ; i < raid_disks; i++) {
-		if (atomic_dec_and_test(&io->pending_flushes))
+		if (atomic_dec_and_test(&io->pending_flushes)) {
 			ppl_io_unit_finished(io);
+			break;
+		}
 	}
 }

--
2.54.0

