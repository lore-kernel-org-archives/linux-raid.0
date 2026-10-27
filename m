Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.46
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793109567;
	b=SnppQF7EHmwkOd9jINnEOOhR0/HGPyfreSlnl+VPqf4RNEr0XrH9W4aUZ+a5Vk743XYa
	 hbiPrOuT+1ZLaIjohG/OHLkHDDSJ3N/cgu+UpEvAWIscKGEPTxeEzfV+9G32Aqko8QYF1
	 vK+/by5J7JHOl6kWsLMlaF9qkMc/JKOjWMl47XWL0ZEcPnrupqbduQfD6fED5u+AsxF1r
	 yfpHOwPDxv1OEbyaqu9VyOUh40igr4S9J1+w8mOGMgYD15t67KTYlNJMTBuAmm2ksQ+3M
	 s3YEp/d2EHRSP5B/GMRNOPb0zhL26x/rihVRCkEJyKIvFRszSr1+jcDsNN66PSMQR1w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793109567;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=qMPA6MdT3fvfT7Hykt3jqhl1HiM6aAIkHck60WZA4cY=;
	b=XSsxcVy+l2xOt+1TcHaFis/ZhZl6OJJ+HY942QgSnzqf6L3uieH9a1k/0GXRdMr2STim
	 TCdPYhXpM/uYfFLNlDuD2C1MGSoEZi1xIppjmomZnRzfQqFZ6BR8ANnh+f6hMTErGa9qf
	 Bb6WrblQYVZ46actEYKIqYdVA+J2RESU538OeB5uVjYjCcCdq+DIE1XbH1hZ/ChnTnj45
	 PyfqG0Ik0pX3qBovGu8msFEFvIGfy7Gfw5rc0eIsAIBDNB6xj2zO1m9E+ihhAkocH7hYL
	 uj3S2Nk7dVrjZdrM4sjV5JudIf6YdomZrUqwqu0hoUuNZcrtDb3yGSIwJ8EbaQ2ZX0A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=lqXdnZdZ;
	arc=none smtp.remote-ip=209.85.128.46
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51080606A31A
	for <linux-raid@vger.kernel.org>; Tue, 27 Oct 2026 13:59:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 51080606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=lqXdnZdZ
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-4a4d7ae1ae9so24048505e9.1
        for <linux-raid@vger.kernel.org>; Tue, 27 Oct 2026 06:59:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1793109566; x=1793714366; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=qMPA6MdT3fvfT7Hykt3jqhl1HiM6aAIkHck60WZA4cY=;
        b=lqXdnZdZU5j5GhiQPBgqCYifz39n24FnQa211rW/xM8aAuYnhjHDpF8NRLO0Q24enx
         hCiawFrV152ooAFenJgXM0UNv86EJedLt1CUFB5/sWCx8iC/zIC4HMSS6Xe/tti3zbCf
         5W3mqLRXkHIVfaCr+S2qRItTw2KURFKvZIaC74eeRSgTzptYEQW5H1Mpxd+Gso6bcaaY
         pM+u0c6If4uLKnozSd8R1BadUOwfajR58WPnt91KKtZEoyk5NoPDpD9NCva3ZlxCzuLf
         qXn0n3MvoxBJndUQkBMSce+Igx392gYVboGZqrwK5IVY5GwKlyzf5uqUPNur5t3wo0y6
         kJAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793109566; x=1793714366;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=qMPA6MdT3fvfT7Hykt3jqhl1HiM6aAIkHck60WZA4cY=;
        b=iHtVf5uDybV7ii6+kqxImMOVNKvR/EjXJR2eaPEEPVsxRUVlRNuQsbbiLPHPwQ6d3v
         B4CS09RmeSX9hOdWuptOPMT3jHzcVX/2lt1bxYzguVkYfOXRWxGq/kX6pwOHcbZqGAq4
         dz4QGavfyvW7k5GOCf+tHtZScWteLYnMKu4QdFgGgkmz55RYZuSTPawdP3q47Gxygu98
         ZHJMSgeJHFzHm0V9ik1/N+Y82Er4MtQhnU6ckn2engpLLfcgFsHb1YDmq2lP6At20A2M
         z9gMcf1dteH2i1hPvlPOMZSaPxStyufR1bDxQrcwUNnOfOjuZ4ZuCxpDnUhLnblQF78X
         7kVQ==
X-Gm-Message-State: AFq9FYKG3D+l0VAkxijdXVTGvXAZy6qh6P8o90AgkYjDACKx2wO8DEHe
	yPrZAb6wSeEZJ/tWET19gcp1vWhfGec+TGah8/KX5T/nOUBO34bFjhIF
X-Gm-Gg: AYBFou1lfoMFc12n13PhvrqtMvWR4sSeDhJozNqtBA8kr1V9wrDV1faNblPGKdTA5WJ
	RoqPtMW8cEeEKd9Q/Z6Jah72OWtqSNmtjRqFYJy06Vl7TkKGvI8vN4hoLwIhLw9Oi98/GbAb/PR
	iRpvRgPgCsHsK4Xdq5ek3q0ZSwVn4OTaLs6VjV6ZAYY5nGz2JGZiiUohRubGg08UY2GlKePk34I
	+fQFBED+rKZoA31jjFwDhIgdSgK3y6FQ53IY25+hpJH6z1iAi/vsWjHuUEmB8Mnwqul8rSQamML
	lkQJlu53p1K+QB9JFJdWODAXwFGJhvmDTM+Rd1j3B30yxdkac0JK176/eFrEaRz59XMyoebpLvi
	gk5mA6jI9mQFCdgimlrBYGztGzusMa8cf5ZRfX6JQUn96cbfEU4CALRP4IELt/acPOXnzAKCHje
	Vbd66ZI/sOpD3F+Izy+N3SDWApQtBYo5HsU0oCRYkmUHzNlPFMtxxlhY7LNMsMICrIunpq7AZuo
	fF6Bu8oJDsBn5NEKxQyGLtSyWzGO11gcM4wntOZ41LN5vjt6Q==
X-Received: by 2002:a05:600c:37c4:b0:4a2:ebb:397b with SMTP id 5b1f17b1804b1-4a35ac7f0e8mr178419985e9.11.1793109565490;
        Tue, 27 Oct 2026 06:59:25 -0700 (PDT)
Received: from env.. ([195.72.110.70])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a35a58a0e2sm334493525e9.13.2026.10.27.06.59.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Oct 2026 06:59:24 -0700 (PDT)
From: Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>
To: blazej.kucman@graidtech.com,
	mtkaczyk@kernel.org,
	ncroxon@redhat.com,
	xni@redhat.com,
	song@kernel.org,
	yukuai@kernel.org
Cc: linux-raid@vger.kernel.org,
	Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>
Subject: [PATCH] mdadm: fix hang when fork fails
Date: Tue, 27 Oct 2026 13:58:08 +0000
Message-ID: <20261027135808.243274-1-abd.masalkhi@gmail.com>
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

write_zeroes_fork() may return a negative value if the fork fails.
Currently, this value is stored directly in the zero_pids array,
causing wait_zero_forks() to hang while waiting for a child that
failed to fork.

wait_zero_forks() counts children based on non-zero entries in
zero_pids, so the negative return value is incorrectly treated as
a valid child process.

Fixes: 577fd10486d8 ("mdadm: Add --write-zeros option for Create")
Signed-off-by: Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>
---
 Create.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/Create.c b/Create.c
index 85c23d830272..4b8aac90c0b6 100644
--- a/Create.c
+++ b/Create.c
@@ -304,12 +304,15 @@ static int add_disk_to_super(int mdfd, struct shape *s, struct context *c,
 	st->ss->getinfo_super(st, info, NULL);
 
 	if (fd >= 0 && s->write_zeroes) {
-		*zero_pid = write_zeroes_fork(fd, s, st, dv);
-		if (*zero_pid <= 0) {
+		pid_t pid;
+
+		pid = write_zeroes_fork(fd, s, st, dv);
+		if (pid <= 0) {
 			ioctl(mdfd, STOP_ARRAY, NULL);
 			close(fd);
 			return 1;
 		}
+		*zero_pid = pid;
 	}
 
 	if (have_container && c->verbose > 0)
-- 
2.43.0

