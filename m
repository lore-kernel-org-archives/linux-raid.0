Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAC12BA4A
	for <linux-raid@vger.kernel.org>; Fri,  8 Nov 2024 01:41:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731030080; cv=none; b=Qeaj2b3qV9BHfmPbKSymeeY8BUXNmeyZyMUlty1tF+1szLwgRp3geEV1vLzV+gMQpsdGjrfQE1hrWayMGxZgQ9NGmy0dlxIQNiuTA/FIYHbXBePc5z8plGgD17lIyb9DYYbtBTKY+TLd4mvNB7vrmPNHhYZ+hYqrtrzVkxct6TM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731030080; c=relaxed/simple;
	bh=2VU2ZCCjAr9a1/6J1uwbSCqwFiscZE4kT6fdXV79MiY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Sz3BeEzZieaPnbNMYd+dnIBKDr98yfalO79CD7n2elmqWUN4nLhyxDmYpcB50kJKQlXZ9L7ELIQqux3uXKXMaJ4NwJuR3pqDoDw6nxNwxt/NtDy0Zh7T0AKrCgpfLRESAvRo2ECgBAEZaY279/6B87XnWDyVdrJyyyA3D3Cr43s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aW6UV8Rp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aW6UV8Rp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB738C4CECC;
	Fri,  8 Nov 2024 01:41:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1731030080;
	bh=2VU2ZCCjAr9a1/6J1uwbSCqwFiscZE4kT6fdXV79MiY=;
	h=From:To:Cc:Subject:Date:From;
	b=aW6UV8RpJctEjVAUAlfsegC6rs4S13uHwjKUPOkMcGRdwzbIMTir06JSBPH4Tcpss
	 rI4BvQW0YkqZGTXycfVmmODOPAGX/CicrfexdsgGlwmNEoyMLYRcKKIqBUABL12aeH
	 seg2g3aWUeZjnuHQC7hztB7IcOyeI4mAVnNBKiZwT0E60P0KacufN0hdVmpDGos2Gj
	 iEtfzjDpAVGzmakpjz1MZgCrFVc/8iTvMmoX5rFfgsnBAgBT8aj7ct3YLrmaD94P9u
	 qgBJSAsBsaJCbwK+CdumScqyprcLMtmc5vUWiwMo+IfWZ19VjnAWfJXYjqaMdGyOvU
	 g5Ibq9U7qjI+Q==
From: Song Liu <song@kernel.org>
To: linux-raid@vger.kernel.org
Cc: yukuai3@huawei.com,
	yukuai1@huaweicloud.com,
	Song Liu <song@kernel.org>
Subject: [PATCH] MAINTAINERS: Make Yu Kuai co-maintainer of md/raid subsystem
Date: Thu,  7 Nov 2024 17:41:12 -0800
Message-ID: <20241108014112.2098079-1-song@kernel.org>
X-Mailer: git-send-email 2.43.5
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In the past couple years, Yu Kuai has been making solid contributions
to md/raid subsystem. Make Yu Kuai a co-maintainer.

Signed-off-by: Song Liu <song@kernel.org>
---
 MAINTAINERS | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index e9659a5a7fb3..eeaa9f59dfe3 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -21303,7 +21303,7 @@ F:	include/linux/property.h
 
 SOFTWARE RAID (Multiple Disks) SUPPORT
 M:	Song Liu <song@kernel.org>
-R:	Yu Kuai <yukuai3@huawei.com>
+M:	Yu Kuai <yukuai3@huawei.com>
 L:	linux-raid@vger.kernel.org
 S:	Supported
 Q:	https://patchwork.kernel.org/project/linux-raid/list/
-- 
2.43.5

