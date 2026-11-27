Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.127.231.16
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795773490;
	b=U4dbdOtc92RrWjnT2OzPMK7US+7SKbwvMkEctKl1hx4PMq27KxI4jl5Dofs1t9B6594M
	 A6mpL2exyUdn8laC8maNZ0WhRG4/wAAmAPHUjAl09BBbtXauXY3LA7FPIJ1G22PsoRsUD
	 HiNGmfOlUDnjxxtEtfFD5mIEfmMEoicED8zBzbxgZf9672UpbdVOcNXUZOX+/9137QYXm
	 yW0qY0mZXs62wv7cMfueD7xGw+fkaH2l77ivWmrmISxGdLPpoHz69/pyX8Y+2jEs1M1Is
	 97W96OVYhEakiwqwhslwGs+851Q4YiAzEsKXg+OsxJUWhKuTtA2PYfQtdcnkuO35OGg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795773490;
	h=DMARC-Filter:DKIM-Signature:Content-Transfer-Encoding:
	 X-Original-From:Content-Type:Cc:Mime-Version:Received:X-Mailer:To:
	 From:Subject:Date:Message-Id:X-Lms-Return-Path;
	bh=r97hwU4N17SfwVsqc3YaeybiabS3NKCnaokufXXj/3U=;
	b=3xthSCu68XhU/96cZcwmMoV9b0GENRoPBC7ao4+dLdF1mB25lQmMVPLOnmb2aREE0axR
	 7bKYTfv199Hyv4vWPjt8bc1KT6chtBEOxKXnRtE3TVHNc7kdCvrxCejds76guHQcVHYZ9
	 M2WejCM0e5vARAI/5ISIHk2j2bfkW/9MK4i7mjj8F3VJNtQEKPg5WojSndXOQl4+9HZgq
	 +LPny/E3UScbMwIaEXhQqKi3g3TYBgc8p6Hb5sitb0XuqzjEc2zr0g7G4F3eOPX1/dmGG
	 gzcOBy8ChNwq3qjO2Dmrg9COqK4ICWKhPORTaIXrIgOYcXl7zLaoPaZpP2bv0hdsplw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=fygo.io;
	spf=pass smtp.mailfrom=fygo.io;
	dkim=pass header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.a=rsa-sha256 header.s=s1 header.b=o7k3suyj;
	arc=none smtp.remote-ip=209.127.231.16
Received: from va-2-16.ptr.blmpb.com (va-2-16.ptr.blmpb.com [209.127.231.16])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CB09606A33C
	for <linux-raid@vger.kernel.org>; Fri, 27 Nov 2026 09:58:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3CB09606A33C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fygo.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.a=rsa-sha256 header.s=s1 header.b=o7k3suyj
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fygo-io.20200929.dkim.larksuite.com; t=1795773484;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=r97hwU4N17SfwVsqc3YaeybiabS3NKCnaokufXXj/3U=;
 b=o7k3suyjnUih+3gbnb0VwvDL05Tf68toxWCVUb+SLWjJaj0oIK4hhZHAwDDvyCuy13UubE
 qywyzJJ/6aRTrY/KrM5UyTcooonvLYiAX7TET+epaQYmxGQ9ibjQwmN+AyJFWhLROsF6YH
 rMNeHPDo45gesLyr+eK+9Yv7WaPyn2KHQV87RT2/q+EvjRpfKxja4CD0Ef0kOLBAQ3x2uq
 iZytp3S6CjMikUuV1Qk7sgk0FSDsuGVJnzmkPRuEG7OV1rS+oW1UdoXTAmfJnLzE7Cu1Of
 OcqkO5kYuqB89HUhzuGGU0Xl0l/R1eL0a3HiPvP2ScABCE681EJ/Mf1IYO7j3A==
Content-Transfer-Encoding: 7bit
X-Original-From: Ni Xiao <nixiao@fygo.io>
Content-Type: text/plain; charset=UTF-8
Cc: <linux-raid@vger.kernel.org>, <linux-kernel@vger.kernel.org>, 
	<song@kernel.org>, <pmenzel@molgen.mpg.de>
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Post: <mailto:linux-raid@vger.kernel.org>
List-Help: <mailto:linux-raid+help@vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-raid+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
Received: from localhost.localdomain ([183.34.163.136]) by smtp.larksuite.com with ESMTPS; Fri, 27 Nov 2026 09:58:03 +0000
X-Mailer: git-send-email 2.50.1
To: <yukuai@fygo.io>
From: "Ni Xiao" <nixiao@fygo.io>
Subject: [PATCH v2 1/1] MAINTAINERS: Update Ni Xiao's email address
Date: Fri, 27 Nov 2026 17:57:50 +0800
Message-Id: <20261127095801.79633-1-nixiao@fygo.io>
X-Lms-Return-Path: <lba+26b09542c+89e27a+vger.kernel.org+nixiao@fygo.io>

Use the new email address.

Signed-off-by: Ni Xiao <nixiao@fygo.io>
Acked-by: Paul Menzel <pmenzel@molgen.mpg.de>
---
v2: change title name
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
