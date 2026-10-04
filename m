Received: from mail-dl2-f43.google.com (mail-dl2-f43.google.com [74.125.229.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEAEE334688
	for <linux-raid@vger.kernel.org>; Sun,  4 Oct 2026 06:02:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.229.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791093742; cv=none; b=nuwWnOf4bX0ZM6sxictRdW3vWnZgF2mWfRLn5gTFWsoIkxKvXlO9bgxFVh7E+UnmELnVz9yaqfVao0qD30Te67G8CbVAKb6FLT2XxJej01h0sxvecrOFHJU/N5ykDpwcR8xf6m8OMhxjZKHHPWUObVWLRrtV8kG1n54j4xQadFE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791093742; c=relaxed/simple;
	bh=MrZM1fuqy59R1SiQ//tw2gC/QW3wBRMI9xhn7nRK87s=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Cj7HXGJokUm2/SWL145KBGjLaOfJwuieVN7BT5reh+LxnueNTdNYaJyR1ArtscFS3xhVAXeBmji6wug1WTYjlOpHAHnxv6/Hv6XCVAaIZKJolCzXGM+L3jo8gN1QOFToQIW3zWaL4zpZeVlaQqlMY887Me7DKoSTa05kAVifRCc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Hq8txJ/2; arc=none smtp.client-ip=74.125.229.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Hq8txJ/2"
Received: by mail-dl2-f43.google.com with SMTP id a92af1059eb24-142dd04be84so659651c88.3
        for <linux-raid@vger.kernel.org>; Sat, 03 Oct 2026 23:02:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791093740; x=1791698540; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=Zw3spXruW5eAr/BaWFnAydpO0+AS612TDMLy0c5P4Rg=;
        b=Hq8txJ/29AGnohleRIX/g6+wcywCzjrNZlUIqVR2sZnQrdtBTO+YwgA2KyKFDPk7j9
         kkyVfO7CPdu8edwxhdixs3O+NN/VY8su9Bh3E7GTqQrwAC66HkI71bjwNAGUCAqfGE9x
         j+BI25sEK1ccGivZM2wSCYuOLUpxskHrJoyPpxYu0BAJmCQXHlKLXdw0c0Fhc0qp8H8w
         xTdQKit92YQ8EZGZ0C9TeafNxrZOwe4kw3b2XXirwytBdEJt2vpmapuVnZhyfoEDsfCH
         BVeakReLGN0TqjAtH4fBoZ3n/6ESstvOowqLo+7DFU/VdFch6341GDtRNXKZc6tVzxFV
         MLsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791093740; x=1791698540;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Zw3spXruW5eAr/BaWFnAydpO0+AS612TDMLy0c5P4Rg=;
        b=G5oetjejTvli3A8Xz0QfgN8ntWKMjVEN+7QKelXRZfE7RtY9qhN05gQ7LRKJJov0FR
         R5CbnaxmJJrVvltF/Kfr9aTMcd7V7G98ErhL7A+PWEqkMfFq6Y3kM2w0rziBKKqTurGk
         yrc6FMjI1f9pKz12TwXr/mZhgWrFvHSUnSkQ1ydzNVpWtOxcKCZth0x1rkPTCRKmFpO2
         K49Ces2uWO84L70hyLZ+N1ixkzt9xN+IJ7uvyzUBRMUIuzOT6B/+FnuIkaZhvw0skt9h
         0R0/kHrghTYfk8bhSWy7x3lp0eVeh4M2xEE/gWn/fyfeDt2n2DMuJ4FWW8KmkOgn3mqs
         wcaQ==
X-Gm-Message-State: AFuF++ndC+e6EXbFJQelgivSJ5lz8J1KiyvyUXR0GSXs0vhooRvNe0LF
	fsFr2dAVOai8/MXIRnShkqaxdtFoe0phakGh1H8Av34BsqQrBepVQEze1P1PbEie4Ac=
X-Gm-Gg: AYBFou3p0p56+U8+e+XTr6EU7p8of3k4+/8uk52gs9KM2AYnB7YxIRbIx8K3pd7+f+z
	c2MRdlQQO0wDp+JXZmcTKv49qyZxqeGulcJJLmB+YJhqDNssuYb6/TmU+NdBYPh6Bb87SXQZ93I
	sD1W5lX1FlWBKNkRZTIep6l5ze2D3KEWYJmFZz5tOvRDhZaKNtoTd2v5/yU9FzEOYgZ21FZ0bL9
	8hr/Q+vAfLJd/ueBbcglbgb+bAw8HfVF55uT6F6GwJRx2ZRwFhT1MUJpOtHgmE4bBVmID2rbEwZ
	7eg2nWmL63syy+qynjqtvCieVlI8ut+wPvoUk75raOJf/LFbCGbrqhbhV9NDOCcHu5IBQ3O9C1D
	eQoB8/x7c8kH2EGiCgoNa7O0497zz4seCS6lmUH/vznxRm7+QmzjYw5CvBxoWlURTyykXZniOMv
	1wLK0qGRN4GSWZXt6w/6UVBrbTvtG4uIRWwMQaJKeUsgr8ZQTFkKjKEQcuL47cGEXrIXr1zcMCG
	aLmLdgSvTz+FhiQF9D5Y0k=
X-Received: by 2002:a05:7022:b88e:b0:14a:fe37:cdf0 with SMTP id a92af1059eb24-14f5d5b661bmr9362314c88.45.1791093739832;
        Sat, 03 Oct 2026 23:02:19 -0700 (PDT)
Received: from LAPTOP-450UDG4J ([223.185.132.231])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-35128156e6esm1952256eec.20.2026.10.03.23.02.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 03 Oct 2026 23:02:19 -0700 (PDT)
From: Yogesh Gaur <yogeshgaur.83@gmail.com>
To: Song Liu <song@kernel.org>,
	Yu Kuai <yukuai@fygo.io>
Cc: linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Li Nan <magiclinan@didiglobal.com>,
	Xiao Ni <xiao@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Hannes Reinecke <hare@suse.de>,
	Logan Gunthorpe <logang@deltatee.com>,
	Yogesh Gaur <yogeshgaur.83@gmail.com>,
	syzbot+270624bb31d478afe62e@syzkaller.appspotmail.com,
	stable@vger.kernel.org
Subject: [PATCH] md/raid5: set conf->mddev before the first setup_conf() error path
Date: Sun,  4 Oct 2026 11:32:03 +0530
Message-ID: <20261004060203.1379-1-yogeshgaur.83@gmail.com>
X-Mailer: git-send-email 2.55.0.windows.5
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

free_conf() starts with log_exit(), which falls through to
raid5_has_ppl() when conf->log is NULL:

	static inline void log_exit(struct r5conf *conf)
	{
		if (conf->log)
			r5l_exit_log(conf);
		else if (raid5_has_ppl(conf))
			ppl_exit_log(conf);
	}

raid5_has_ppl() reads conf->mddev->flags. setup_conf() only assigns
conf->mddev after bioset_init(), but five of its error paths -- the
pending_data, alloc_thread_groups(), conf->disks, extra_page and
bioset_init() failures -- jump to "abort:" before that, and abort: calls
free_conf(). conf comes from kzalloc, so conf->mddev is still NULL and
free_conf() dereferences it:

	BUG: KASAN: null-ptr-deref in raid5_has_ppl drivers/md/raid5-log.h:54 [inline]
	BUG: KASAN: null-ptr-deref in log_exit drivers/md/raid5-log.h:128 [inline]
	BUG: KASAN: null-ptr-deref in free_conf+0x81/0x5d0 drivers/md/raid5.c:7549
	Read of size 8 at addr 0000000000000028 by task syz.3.20/5681
	Call Trace:
	 <TASK>
	 free_conf+0x81/0x5d0 drivers/md/raid5.c:7549
	 setup_conf+0x1720/0x2ad0 drivers/md/raid5.c:7885
	 raid5_run+0x8cc/0x2560 drivers/md/raid5.c:8129
	 md_run+0xc3d/0x1cd0 drivers/md/md.c:6779
	 do_md_run+0x35/0x720 drivers/md/md.c:6880
	 array_state_store+0x958/0xe90 drivers/md/md.c:-1
	 </TASK>

The faulting address is offsetof(struct mddev, flags).

conf->mddev is a back pointer that is constant for the lifetime of the
conf and does not depend on anything computed in between, so assign it
as soon as the conf is allocated. Nothing between the allocation and the
old assignment reads conf->mddev -- alloc_thread_groups() takes the conf
but never looks at its mddev, and the rdev_for_each() loop walks the
mddev argument directly.

All five paths are allocation failures, so this needs memory pressure or
fault injection to hit, which is how syzbot found it.

Reported-by: syzbot+270624bb31d478afe62e@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=270624bb31d478afe62e
Fixes: ff875738edd4 ("raid5: separate header for log functions")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Signed-off-by: Yogesh Gaur <yogeshgaur.83@gmail.com>
---
 drivers/md/raid5.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index b91545ce090d..f98d3bdd3484 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -7675,6 +7675,9 @@ static struct r5conf *setup_conf(struct mddev *mddev)
 	if (conf == NULL)
 		goto abort;
 
+	/* free_conf() dereferences this, so set it before the first goto */
+	conf->mddev = mddev;
+
 #if PAGE_SIZE != DEFAULT_STRIPE_SIZE
 	conf->stripe_size = DEFAULT_STRIPE_SIZE;
 	conf->stripe_shift = ilog2(DEFAULT_STRIPE_SIZE) - 9;
@@ -7743,7 +7746,6 @@ static struct r5conf *setup_conf(struct mddev *mddev)
 	ret = bioset_init(&conf->bio_split, BIO_POOL_SIZE, 0, 0);
 	if (ret)
 		goto abort;
-	conf->mddev = mddev;
 
 	ret = -ENOMEM;
 	conf->stripe_hashtbl = kzalloc(PAGE_SIZE, GFP_KERNEL);
-- 
2.55.0.windows.5

