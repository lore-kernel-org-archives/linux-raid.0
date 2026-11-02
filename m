Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=124.71.93.112
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793609182;
	b=eZQOKdmvffsa3QC8pc6hVmuZ9jfo0cTo/+upVDqzA5KeBGZ2a+vJMyR1s3rbG9mZtlGt
	 t2uSpQ6e9CjRQiMZYaWEb0Pj50Lcdzgak2JhN8l7jlfcluLUgnbNtUPAIpPOgAgjpGJds
	 7Z8QO9BV6uSSR8BNBnzexxGQ1xZ601GF2zdVKFqg6qRwWTUN6quHD+5oNedwFjfIc6LTH
	 NLW9xnBCz40nNzFTRfIVlrL0QCbP429b63xnM9z0vdhhCIcaNzor53eGuQ/22tlBji++q
	 7SYCxvOmVbDarE/4WxLyPbtLgMn5OSBoLdNwLKedqbcC6k1cUwKuZbWDgHsPZ3hsn/A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793609182;
	h=DMARC-Filter:Received:Received:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding:
	 X-CM-TRANSID:X-Coremail-Antispam:X-CM-SenderInfo;
	bh=BeO6JMSP+knyrcPLJCMLZ69Lg3J4opdaoGvgLjlt0kA=;
	b=gX3s2ppZM4N2vYDA4cmXXVxZ3wLucwt/0hAT+0zVChjk7OabNLcUX1LlyWFAUlhDXiEJ
	 ZQGDaeFnSdW0WFBSA1sfCMROFLBEXqU7WIPCiPuaGSEZ0hmG6AybdcScyWZ1ZYiaPJqq4
	 Aq5cVrEXqgz5qey1aWdWrUCbF93+zxhxHhoDIEUkJ4qsYZxqB1y5gKKabbtc7lgpBT2ha
	 gR3DaWeQ2qXOi4JYCA9MNTRQc9KXsKEmCAT7SD3/YwbMXy1Qek7/k40bw49yoGuaBGYhG
	 0/tcO9eZNKpZ0f5JiaFOXjSRg4q6iO3/Ag1OBxncQm5Q0FYGfzcZT78LEy5UxwTJjXA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=huaweicloud.com;
	spf=pass smtp.mailfrom=huaweicloud.com;
	arc=none smtp.remote-ip=124.71.93.112
Received: from dggmsgout12.his.huawei.com (dggmsgout12.his.huawei.com [124.71.93.112])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7E06606A326;
	Mon,  2 Nov 2026 08:46:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C7E06606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.177])
	by dggmsgout12.his.huawei.com (SkyGuard) with ESMTP id 4jJ4zk2NQCz1yXy;
	Mon,  2 Nov 2026 16:45:54 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 8F652405A4;
	Mon,  2 Nov 2026 16:46:16 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.85.155])
	by APP4 (Coremail) with UTF8SMTPSA id gCh0CgAnZvXXTehqaMofCw--.17777S4;
	Mon, 02 Nov 2026 16:46:16 +0800 (CST)
From: Zizhi Wo <wozizhi@huaweicloud.com>
To: song@kernel.org,
	yukuai@fygo.io,
	magiclinan@didiglobal.com,
	xiao@kernel.org,
	linux-raid@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	yangerkun@huawei.com,
	chengzhihao1@huawei.com,
	wozizhi@huawei.com
Subject: [PATCH V3 0/3] md/raid0: fix a takeover BUG and tidy member-size rounding
Date: Mon,  2 Nov 2026 16:38:12 +0800
Message-ID: <20261102083815.127751-1-wozizhi@huaweicloud.com>
X-Mailer: git-send-email 2.52.0
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
X-CM-TRANSID:gCh0CgAnZvXXTehqaMofCw--.17777S4
X-Coremail-Antispam: 1UD129KBjvJXoW7AF15ArWrJw18GF17AF4xZwb_yoW8JFWfpw
	45Ww1Y9rsrGr17Ja9xJay8AayfKr4fGF4UGas7Gw48CrnxZr10krW8KFWUWFWUJws5tryj
	qFn8ua4vkFyq93DanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUkjb4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Gr0_Xr1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26F4UJVW0owA2z4x0Y4vEx4A2jsIEc7
	CjxVAFwI0_GcCE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8C
	rVC2j2WlYx0E2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4
	IE7xkEbVWUJVW8JwACjcxG0xvY0x0EwIxGrwCY1x0262kKe7AKxVWUtVW8ZwCF04k20xvY
	0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I
	0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAI
	cVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Jr0_Gr1lIxAIcV
	CF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIE
	c7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x07UAwIDUUUUU=
X-CM-SenderInfo: pzr2x6tkl6x35dzhxuhorxvhhfrp/

Patch 1 fixes a syzbot BUG() in find_zone(): a takeover can build strip
zones that cover less than the array still advertises, and I/O for the tail
reaches find_zone(), which cannot map it. Reject such a takeover up front.

Patch 2 factors out the "member size rounded down to a chunk" computation.

Patch 3 uses it in raid0_size() in place of a power-of-2 mask, which is not
a round down for a non-power-of-2 chunk, to consistent with how
create_strip_zones() already rounds the members when building the zones.

Changes since v2:
 - Dropped the first three patches; only the last three are kept. The
   changes needed to restore state on a failed takeover, as well as on the
   subsequent error paths in level_store(), are fairly large and are not
   addressed in this patch set for now.

v2:
https://lore.kernel.org/all/20261019010827.2922617-1-wozizhi@huaweicloud.com/

v1:
https://lore.kernel.org/all/20261017005802.2212102-1-wozizhi@huaweicloud.com/

Zizhi Wo (3):
  md/raid0: reject a takeover whose zones cannot cover the array
  md/raid0: factor out raid0_member_sectors()
  md/raid0: round member size in raid0_size() with sector_div()

 drivers/md/raid0.c | 48 +++++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 43 insertions(+), 5 deletions(-)

-- 
2.52.0

