Received: from lf-2-36.ptr.blmpb.com (lf-2-36.ptr.blmpb.com [101.36.218.36])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32ADF469836
	for <linux-raid@vger.kernel.org>; Mon, 14 Sep 2026 12:19:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=101.36.218.36
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789388371; cv=none; b=JAO/lPHXBk9hnHA0SJZfOdjUKTmpX6a6FZ9yMlMRN4P2j6Z6pX2q7J13yu2MEzkeEUGKiw+ad4nDKlJzqL7kP7K/ohSMWvc4CzHwGW1MYCChyBMZlSzCMfVFjBAtzxIfRBrGnibSKY61YSrY/BUu66+zYszzfIGGmxb6AGpOMIE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789388371; c=relaxed/simple;
	bh=hbYulF5G0XpH6vk4F0+8iONPcKXPa6GZc0v7vKbDV0M=;
	h=Date:Message-Id:Content-Type:To:Cc:From:Mime-Version:Subject; b=Ol5vTuZslVpdpQwp6N+FiuK2eBqDDERA0vwJBhLmnFmVzIWgW7ZmKhanCSVyW3q0FfmoaiX7Sg3rOF/Q5DzLgRBYWZQdL1z/IHXcRSoQ8eX7VIYW2/dBZGFmsaRdHarogpyDXaPU1W5ZrHXYwCQHCo0vt1z2hIDHLcF6e54vkTc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com; spf=none smtp.mailfrom=fnnas.com; dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b=S7GFxBwO; arc=none smtp.client-ip=101.36.218.36
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=fnnas.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b="S7GFxBwO"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fnnas-com.20200927.dkim.feishu.cn; t=1789388280;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=G7A7gpVT9wFNI7+T5wV9bi7VlzmAAT52yyMbcA3FgJo=;
 b=S7GFxBwObKOPOwBnrcZQwNiTXHvquldujaKjuXhqIUDuy1RZOuVFqyMftlATJViK0FcCRb
 KuEaeRfdX9dBqp/allfffj6KMXnJdQLAZYhnQb6cpFcPkWj0Z4mnGsqe6jQb2pePfCx5Dh
 76wCV7K0DIjetHIsAlauhpc0EmsEOz4d/xqP7AMDEa0gWth8M4ap435ZNUKwVrfBhWMQLn
 kRxr5q4UNOilW+ZPYxhVl0XvKw6HzVBNWYPvLV9r7/BP62Df5EGXSCL1fRbvls6O16j4On
 YSN19rsWtHxxcKun5qKDhQQg+mA93if2Vr43wCGQolce9HNirsglAp8KB1A/1w==
Date: Mon, 14 Sep 2026 20:17:45 +0800
X-Original-From: chencheng@fnnas.com
X-Lms-Return-Path: <lba+26aa7e5f6+e4fbd6+vger.kernel.org+chencheng@fnnas.com>
Message-Id: <cover.1789387793.git.chencheng@fnnas.com>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
To: <linux-raid@vger.kernel.org>, <yukuai@fygo.io>, <nixiao@fygo.io>
Cc: <chencheng@fnnas.com>, <linux-kernel@vger.kernel.org>
From: "Chen Cheng" <chencheng@fnnas.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.55.0
Subject: [PATCH v1 0/2] md/raid5: validate disk count before reshape assembly
Received: from fedora ([183.34.164.60]) by smtp.feishu.cn with ESMTPS; Mon, 14 Sep 2026 20:17:58 +0800

From: Chen Cheng <chencheng@fnnas.com>

The previous patch rejects raid4/5 arrays with too few disks in
setup_conf(). During reshape assembly, raid5_run() still divides by the
data-disk count before that check, so a crafted superblock can hit
division by zero.

Extract min_raid_disks() and reject invalid reshape geometries in
raid5_run() first.

Chen Cheng (2):
  md/raid5: extract min_raid_disks()
  md/raid5: reject invalid reshape disks in raid5_run()

 drivers/md/raid5.c | 28 ++++++++++++++++++----------
 1 file changed, 18 insertions(+), 10 deletions(-)

-- 
2.55.0
