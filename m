Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2655639D6D9
	for <linux-raid@vger.kernel.org>; Sun, 19 Jul 2026 14:44:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784472263; cv=none; b=JBKvuGzcxdtlnnu34Ru5jccljcKy+OZARMTHlR9/R5H1S66X0HNzrvfgnWimngVQiby45xo8VfWX7hdK7WYxSs1KqfVpZW+waSGJapKXQqgpyC18uKV7yAAAqY9pfHnViGXg5BTkWNgnqhRXEsmkXRVpITGzrH+gzts56vMVikI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784472263; c=relaxed/simple;
	bh=A1lUF0TdRV4gp86VJGKxfTwPvbExvR4m89rH3oMJtVs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m6wvUhZ/32b8AKqzne3gP3zAIKXPE8V9rpStu7Xbf6heF/qADmPf/4t/HmT+iIYbPR0Buf+HUNh/SH36pRKIuhWzerIZkoPzEHpiqlpradZOlK9PoOmhS+XSybZrCAzKb40GOQ3qeqFYJgKxRtUx2m8j69522/9KazFvG9xtfWs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meshstor.io; spf=pass smtp.mailfrom=meshstor.io; dkim=pass (2048-bit key) header.d=meshstor.io header.i=@meshstor.io header.b=VAA4r8/w; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meshstor.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meshstor.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meshstor.io header.i=@meshstor.io header.b="VAA4r8/w"
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-49558ce01afso4076215e9.1
        for <linux-raid@vger.kernel.org>; Sun, 19 Jul 2026 07:44:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=meshstor.io; s=google; t=1784472258; x=1785077058; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=07PgFPWCTRuDNrLVBs68Rjs2ic59FL1mErS/bBKr4IE=;
        b=VAA4r8/wvKpFlsLiQHspQMB1QllEIiFNO7DnzO01NwJLENKj+V1LSvn+DZdHWzMG5J
         T1F1cTijsX2LCLdUMiKwCR9+JywJVtdHCpw+EH16+74jRzNHl98mHWdohzFHpTemS8M+
         3/P317V03g7eUSWR50++IasYGX+dDPmP9j8UX2jIXJbcYDbV+7KlMbg1Ogx9xxj2MqnO
         aWJ90pvaxdi79BTHSPHPrt7YDslsGvUawZBb9ip3gsGSVvXeE6o21ZL9LmJNtMl3+b3X
         qyP5vfG7w+2DD4+RGrurS5CC/RIuXH8MlyAdYx7a6QRIfGY0HxIEzLf2IMAej7sYioKL
         GEDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784472258; x=1785077058;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=07PgFPWCTRuDNrLVBs68Rjs2ic59FL1mErS/bBKr4IE=;
        b=PMMioVLflkiZAgP2oIQGVUyN335Cu+yAV9QdllnuBHC5+ZZsUFp2DpXK0+QnWXQsuv
         HNOelDmeOsFtizMiGeVWNnrAc9exjKulRihlKRtwT5cW7Rq1FNuIYeja/iePKtMPkyHi
         c79PeyAaFTIbNl0fsKhyofbFcDob6xODkeI8S+xZiszwZJ9/uMoqH7XntSo2BSxX+3b4
         O1rvsKhw11ctiKyqGAk9TXed2QWe9E5xiVRgc3ETHpIzFvSt37ghw1SZ9xrVq+5VUAOt
         moQiWBQ/KFBghkO8mKjFZVKpmnwiuR3SwpliywS9YPabEG5hNwr03yzD5Gu5tpU75u49
         akJg==
X-Forwarded-Encrypted: i=1; AHgh+RodDwl6qWXiahxhoC7oMm9g4y19EBR/OaGTvqTt2QmewDrm80TAfj8Whet+oL2xKk+K0t2AWkhL78OU@vger.kernel.org
X-Gm-Message-State: AOJu0YwWO9+aEnzApge5iXf+ex231+XZElSpQ/tzyirE2jInVherR6p5
	ho5DymkIp1ahA32gHc8bCXLOJPzwzjd2825j14sZaX0r3RJTQkdLf6AFx6+mDIsaFA==
X-Gm-Gg: AfdE7cnt1JgvLFbhNChIM70i/Cm6fEB1TssKQnqrEEXLrxhd1LTmDE1G/n9hM/+Z8AC
	TlREFQQiZbj+GaaZ+T2F6IZI7HZFi8/IEVXh0tpp2312F7DdWcPbkNmmOmiD/npN7Fw7km7u4En
	srFCLovDIr5fw+OTZAWHj+mZMMh+7sPB5UNuPWAj5aT3f8TIx80jA+DKT5DSN5SWwsPtnQopnpU
	xjvQJ2dPtJIZph7CrWF1/S8eUwtx/XCzHA/qR++4JAU4PyAQUq07U018K+jT3BUTAtUQUCQ5/Gv
	q+PMWxJeBJ/JCIwEsJBOERYk1kH3NTrpWXBXZ0ZQQS9IzM+gkgY5AbzIDvlfSnP+NC5kialV7CW
	89+wbFQ7SoDA/3cyj9YZfHt9uBQleLJqSlFYKGG5NKp9jswuNLyh6WXPdSfgs4uC7hFQhDBWD
X-Received: by 2002:a05:600c:26d4:b0:495:4075:7dfa with SMTP id 5b1f17b1804b1-4954a51e4abmr73523085e9.35.1784472258290;
        Sun, 19 Jul 2026 07:44:18 -0700 (PDT)
Received: from mf-00-01.. ([194.220.239.180])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49549c9c940sm190238905e9.13.2026.07.19.07.44.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 19 Jul 2026 07:44:17 -0700 (PDT)
From: Mykola Marzhan <mykola@meshstor.io>
To: Song Liu <song@kernel.org>,
	Yu Kuai <yukuai@fygo.io>
Cc: Li Nan <magiclinan@didiglobal.com>,
	Xiao Ni <xiao@kernel.org>,
	linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 3/4] md/md-llbitmap: unmap sb page before freeing it
Date: Sun, 19 Jul 2026 14:44:08 +0000
Message-ID: <20260719144409.940492-4-mykola@meshstor.io>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260719144409.940492-1-mykola@meshstor.io>
References: <20260719144409.940492-1-mykola@meshstor.io>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Every path in llbitmap_read_sb() that maps the superblock page ends
at the out_put_page label, which frees the page and only then unmaps
it:

	__free_page(sb_page);
	kunmap_local(sb);

The page comes from alloc_page(GFP_KERNEL), so kunmap_local() is
currently a no-op everywhere except CONFIG_DEBUG_KMAP_LOCAL_FORCE_MAP
builds -- where the page really is freed while a live mapping still
points at it.  Unmap before freeing.

Fixes: 5ab829f1971d ("md/md-llbitmap: introduce new lockless bitmap")
Assisted-by: Claude-Code:claude-opus-4-8
Signed-off-by: Mykola Marzhan <mykola@meshstor.io>
---
 drivers/md/md-llbitmap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/md-llbitmap.c b/drivers/md/md-llbitmap.c
index 0b591124dc63..63ff2c0d8b43 100644
--- a/drivers/md/md-llbitmap.c
+++ b/drivers/md/md-llbitmap.c
@@ -1035,8 +1035,8 @@ static int llbitmap_read_sb(struct llbitmap *llbitmap)
 	ret = llbitmap_cache_pages(llbitmap);
 
 out_put_page:
-	__free_page(sb_page);
 	kunmap_local(sb);
+	__free_page(sb_page);
 	return ret;
 }
 
-- 
2.43.0

