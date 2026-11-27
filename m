Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.127.231.51
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795771235;
	b=SmyD+ccO0vCviEJEK4Kg2EfmDts9h/AwFvuvOX/dokKEYqtoK2uBrxdLVn44iVx3TXL6
	 +ovOiVR1sz9CA7WjwXrKEjR9doVRwRCvI+q4A/vqUD2qFgVhchY0x/s6kjRkiClbPxSP3
	 0DFgwcGHysL5gt/69gSYnT/inB8s2b3j8KmEP1LkPefWmYyXzCPpoYBkP58DFr87C9m2D
	 irOAcN/Jg5DD/WeuN9BKDIvVwkrtWFy1t40f6jtR/P+WhZcl9/G5jNz8Viqq5bozySM7K
	 8XQ+8eQgn+ev9mVnGPdSEXFN202fWwAQKn5/bxttWZ1z7Cx68PzTg4+pxWHlkFre36g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795771235;
	h=DMARC-Filter:DKIM-Signature:To:Cc:Mime-Version:Received:Content-Type:
	 Message-Id:X-Original-From:Date:X-Lms-Return-Path:From:Subject:
	 X-Mailer:Content-Transfer-Encoding;
	bh=NAveHZyPGEK7/TqQmlT5l/nHUt/7+kT2XBefCLptYA8=;
	b=0kK5GoY7z8fF4V1cFnzIxZL3WlmEwmdwGBScc6AuwpjnbzHxUp3dx0NOgV37Moj1UpbB
	 AV5/LV6w+OuZRCFzdqtykLTNoIiI8Vv1Vb0ZsBne3i/YzDtjxrREy76HryDfvjduGDgqB
	 N4RmTKaDCmUNir/CEajeVQOmDJkINIxJgh5mDSWkSvkhpHaPGUWRcJvBh51ugFFRSEfS+
	 GpcXw5hA8ZF2i5ly93Q3EGol5fKdnI7VsCLhcFlPeCnP2FfdHIA+mnGEh0f+FJS97oLlK
	 8UD/l5CesOErjDtvIr4vmxpR8rCYxD6xc3wp82HDu/K9HU6kpRhHPrYAOUF/Yqi9Odg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=fygo.io;
	spf=pass smtp.mailfrom=fygo.io;
	dkim=pass header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.a=rsa-sha256 header.s=s1 header.b=dN4YAOYw;
	arc=none smtp.remote-ip=209.127.231.51
Received: from va-2-51.ptr.blmpb.com (va-2-51.ptr.blmpb.com [209.127.231.51])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0729606A31C
	for <linux-raid@vger.kernel.org>; Fri, 27 Nov 2026 09:20:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E0729606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fygo.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.a=rsa-sha256 header.s=s1 header.b=dN4YAOYw
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fygo-io.20200929.dkim.larksuite.com; t=1795771230;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=NAveHZyPGEK7/TqQmlT5l/nHUt/7+kT2XBefCLptYA8=;
 b=dN4YAOYwkweTlVz3J48UO43lTzZVImGi0Ol3m/AZeZ2o/65i48Oe2FnZX6bmwZj91KDrek
 1ili5RSpwShewe9WUtciLJusEmX5GEsn8D3KkkSexc21018OCBX3L+/HFNz/utB2azlhyG
 TnXYnEo2Hxp6bUqgvar/zp07JFnfSvbd+hqY+6WEEXGIKHwT9VEPk9YKFd73LJ1UcQLHpu
 AXPgKNyvhDthjzgQDuGNIErsBESsM/REKQQMbylNB4K7GnR6QJt9eXyZOT5wdeBfLFPldQ
 0jMAdHXbxLPn8if45dxehEgNattf0kJFT0SQjOIgRakU3dWnywsFcQdhNaJGxQ==
To: <yukuai@fygo.io>
Cc: <linux-raid@vger.kernel.org>, <linux-kernel@vger.kernel.org>, 
	<song@kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Post: <mailto:linux-raid@vger.kernel.org>
List-Help: <mailto:linux-raid+help@vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-raid+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
Received: from localhost.localdomain ([183.34.163.136]) by smtp.larksuite.com with ESMTPS; Fri, 27 Nov 2026 09:20:29 +0000
Content-Type: text/plain; charset=UTF-8
Message-Id: <20261127092024.79116-1-nixiao@fygo.io>
X-Original-From: Ni Xiao <nixiao@fygo.io>
Date: Fri, 27 Nov 2026 17:19:48 +0800
X-Lms-Return-Path: <lba+26b094b5d+a20736+vger.kernel.org+nixiao@fygo.io>
From: "Ni Xiao" <nixiao@fygo.io>
Subject: [PATCH 1/1] MAINTAINERS: Change email address
X-Mailer: git-send-email 2.50.1
Content-Transfer-Encoding: 7bit

Use new email address.

Signed-off-by: Ni Xiao <nixiao@fygo.io>
---
 MAINTAINERS | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index c72a281a8167..6bbee57334b1 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -26061,7 +26061,7 @@ SOFTWARE RAID (Multiple Disks) SUPPORT
 M:	Song Liu <song@kernel.org>
 M:	Yu Kuai <yukuai@fygo.io>
 R:	Li Nan <magiclinan@didiglobal.com>
-R:	Xiao Ni <xiao@kernel.org>
+R:	Ni Xiao <nixiao@fygo.io>
 L:	linux-raid@vger.kernel.org
 S:	Supported
 Q:	https://patchwork.kernel.org/project/linux-raid/list/
-- 
2.50.1 (Apple Git-155)
