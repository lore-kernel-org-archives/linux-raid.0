Received: from out203-205-221-221.mail.qq.com (out203-205-221-221.mail.qq.com [203.205.221.221])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30AAC35C1B1;
	Fri,  8 May 2026 09:55:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.205.221.221
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778234124; cv=none; b=YxhPvaYxdNf76SCHDrc29+sQrvEmEOypDrxo9FrMV3I3VeiRlR2RvZdefs7giiLJkg050TIWbkMZulnvXPQjvJ6e93CxMJj6wBMYVbvlQkqegU6wtE58KRTGoE0fs1ugrYHRbVD/dM2O0J7UaIWXKqk55zGk+TsikzB0bukBSmk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778234124; c=relaxed/simple;
	bh=VEIo+a9bH1FvnLtjwwcjrS9rWhkyMy3s8kSYBdTK6cs=;
	h=Message-ID:From:To:Cc:Subject:Date:MIME-Version; b=cVrp32E1wmQHGCcK+sgmr9IoVZuuVGS6o3SqDzdM/d9xcx0t4Ql6CA/qw6jvs+nOsC/H5Kfr9V7He9RvAjknL1+G2qq75aGWeV1eIs0YZ/ofyEdXfcLnEwIIIzgJnIRBjsD1t5DIpSXKW0We959W+cAbEbA9CzjeKipfYBAtCRM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=foxmail.com; spf=pass smtp.mailfrom=foxmail.com; dkim=pass (1024-bit key) header.d=foxmail.com header.i=@foxmail.com header.b=tWgQ0p9r; arc=none smtp.client-ip=203.205.221.221
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=foxmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=foxmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=foxmail.com header.i=@foxmail.com header.b="tWgQ0p9r"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=foxmail.com;
	s=s201512; t=1778234116;
	bh=sBHRkGOPB1wtVMmwNJhx8RKcr5TsnMv+aslzWn4G3Ac=;
	h=From:To:Cc:Subject:Date;
	b=tWgQ0p9rmBh1UTqxGxWj7Qr7VvqcgwzSn/+y81RZaAO+OAFqTLW+GUd2F8vxqdE9N
	 SNuzjL70+wL3xWVi6tiR4PFDmCq2+7veJ8dYXkOg01AMlaUYWu4dQL5LbAbRo/mGF1
	 urt6LbLl3kzIJsoU3HlTKapm9HoEfaIERe+Q7854=
Received: from localhost.localdomain ([183.134.211.52])
	by newxmesmtplogicsvrszc56-0.qq.com (NewEsmtp) with SMTP
	id DCDA4884; Fri, 08 May 2026 17:55:13 +0800
X-QQ-mid: xmsmtpt1778234113tm4udyc07
Message-ID: <tencent_8F8173BEDF20E98550D5429DF802F34A7108@qq.com>
X-QQ-XMAILINFO: NZwiJlOqZeNMt79RYoTCOiQpWucZ35jznKSwDxF9HBe5ojw+zdg9mbpFs2aqig
	 eaOGivOiRxTtLySPyZOYBQSeE2P/SLcYNEdwRSZWOxpQ4AQEz/LsnmEzDYavM+eoyPrkgbn4a5Yd
	 akw9KxSUc0yKneZql8OLDDM9onuuYlJDPdWNSo95Vm9RR/EUq3wR79tmwW576c746bxnnSnNdrsf
	 Xtj0ilahD0APbyE5HgGGsYWvjsCXlWmEBAXCuKOqGGaD3GTK7WJmJOzuatBaRQszMn4tpaT8j2Uc
	 QxVKvUXha3C1cWN7V/KkOkSo8at0uywqHfuQdKHKVaTuZnmzzN3la9cN4KqtUQBfTArWN3CfxZov
	 Q4js4VPVyuP+r+Dt/2Kfr7EtUMwOE57sPwPFOHUFjG8uJjqmaPSIvVG/dK/rdM47iXFIvxZdCUYy
	 orQEbt2xsCzn13+bmQwShrcRO8w7GLWPFZT5E1/9Ozcyi0b7GMDKAI0ft9+abs0dkLyf3dDoaYCb
	 +5SrInCTWHX24GhMTuaaZgXoAqZtnVvCUo6XmMvZ7DFq7lXaEwusRSOmVQxAiL86oLmbnm5Es07i
	 SuIMb/TLbL077fge4Zgrdy7tBSRcsD19T2ehIw6V8q0Oz+jAZCiFcy5f7NCWSYsiKu7Yz0gJRuMp
	 TUdurGqZS34OOPkleor2jZjcoQ4F8e1Lm+nGJsSco7JxVFIn6FqgUr1vi5hB/+Uhs1fdTj4XMQdJ
	 tZS+wLE+rzFFixrQ29hgcwroZeBIy85sfBhbGegWPyXiByCLQCmW9mWhNr4Pl89QjwkTMK+ynytc
	 nW6S0yxJAxkGSLhJU8BFOsHxXdJ1W1rG2PbgxHJtuokGDF9maEexg8frmB73P1Z+84gLi5uScufq
	 qMwUKbfC/zrAIkd0DJyYKoIJ0SHnMWAmUwBrQxl/D9cjzlpYL+F4XeVgfGHiISGOwmNWAjHP5936
	 eoMeESkJGjDkVBz3fKU5By8lA2USArgsSODHa1g06coRNH500NX/hRdGOL/MMeuPMvjZCz4wWLFv
	 I9qE3q4hK7tClPgyzZC4xxCym3Rf96VwspjB6X9NTsfjuaP//nuCWE7SyKeDEL+O1Yq9mmFithu2
	 SmuxbCZgNmMY4HwmOCwuWni0I8gsOia4XpJJ9fg35gUAMAe/oVo1z953KXKOpgfKojIuMR
X-QQ-XMRINFO: M/715EihBoGS47X28/vv4NpnfpeBLnr4Qg==
From: Li Nan <magiclinan@foxmail.com>
To: song@kernel.org,
	yukuai@fnnas.com
Cc: zhangtonghao@didiglobal.com,
	linux-kernel@vger.kernel.org,
	linux-raid@vger.kernel.org,
	xiao@kernel.org,
	magiclinan@didiglobal.com
Subject: [PATCH RESEND] MAINTAINERS: Update Li Nan's E-mail address
Date: Fri,  8 May 2026 17:55:13 +0800
X-OQ-MSGID: <20260508095513.94980-1-magiclinan@foxmail.com>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Li Nan <magiclinan@didiglobal.com>

Change to my new email address on didiglobal.com.

Signed-off-by: Li Nan <magiclinan@didiglobal.com>
---
add cc linux-raid

 MAINTAINERS | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 06c00e40999f..96702de58cc1 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -24763,7 +24763,7 @@ F:	include/linux/property.h
 SOFTWARE RAID (Multiple Disks) SUPPORT
 M:	Song Liu <song@kernel.org>
 M:	Yu Kuai <yukuai@fnnas.com>
-R:	Li Nan <linan122@huawei.com>
+R:	Li Nan <magiclinan@didiglobal.com>
 R:	Xiao Ni <xiao@kernel.org>
 L:	linux-raid@vger.kernel.org
 S:	Supported
-- 
2.50.1 (Apple Git-155)

