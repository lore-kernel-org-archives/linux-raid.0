Received: from va-2-37.ptr.blmpb.com (va-2-37.ptr.blmpb.com [209.127.231.37])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DEA13B3894
	for <linux-raid@vger.kernel.org>; Mon, 21 Sep 2026 07:17:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.37
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789975040; cv=none; b=ltKxGtFc3jmVJoY7zeEpQRW4dTm0oJjNVJd5dDNo9mEzML/hCDH1eTFbLaRH+drF/l2gHQ/BAV/Wr7Wx5lnPGqchdF0OTw8wN67QHiKMW2qLg2Ya0m+ACvd27DX+WAGi60Z5g95LvhKJkw1XHYpGb85m44diwQzHC8SUE+yKNo0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789975040; c=relaxed/simple;
	bh=AdLtWh1z6QO3Ome46MxIlyBvHsFvQEEZMU/S5jcXNn0=;
	h=Mime-Version:Subject:Date:To:From:Content-Type:Cc:Message-Id; b=X6rgMO3+4tAzgWGe5Hjh2vhFLGKK2u/L3icDDl9xws4W9QjbSCztGIgO1UufTkRFYI2Lu8ogVTKXJTlhqAOrDtCc6Vks9h3j9RZ2DMXuRpPE2oPbvT3vpnIHxG3LKjBXpqZaFEL++KqY9dDT4RY28+LDIcPROkW5zTlqPuAhnb4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com; spf=pass smtp.mailfrom=fnnas.com; dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b=BfoNdHa4; arc=none smtp.client-ip=209.127.231.37
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fnnas.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b="BfoNdHa4"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fnnas-com.20200927.dkim.feishu.cn; t=1789975026;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=0g4OXxO3C65RzGyL+t5rsMRD15HoHvHc91bAoNov68E=;
 b=BfoNdHa4nTFTQTg5h2/zYrRT3Tdgh5F5a3u5pOcdJrvHM9nJ/t5eTU/7caA+S+zxO02Ll9
 B5LS3rJ+gorrrtO0FjOHC7EVr3Nx2G2NJAMEZ5CH5PnkYARr6aGSucz5N52x6JlMbqoAeW
 hb9XuSq8B2xcJkOuPMul5mM7BEH7lMLyXGx5KzGE3+VV/envJw0bo53fC5LDgMiLNreV6p
 JyngyKgN+qtDg3+LWxS5YjvVEhKPesmBaoSgWbW4nUj9uSex6T9xU/qBVPOgUKjPc43MLl
 /edmbc5+iXPKyMdigKJdZdJej0yFjlLd18Btrb8QY/LFyTJQY6fBybgF/2s/6w==
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH v2 0/2] md/raid5: validate disk count before reshape assembly
Date: Mon, 21 Sep 2026 15:16:51 +0800
Received: from fedora ([183.34.169.232]) by smtp.feishu.cn with ESMTPS; Mon, 21 Sep 2026 15:17:03 +0800
X-Lms-Return-Path: <lba+26ab0d9f0+f68e7c+vger.kernel.org+chencheng@fnnas.com>
To: <yukuai@fygo.io>, <nixiao@fygo.io>, <linux-raid@vger.kernel.org>
From: "Chen Cheng" <chencheng@fnnas.com>
Content-Type: text/plain; charset=UTF-8
Cc: <chencheng@fnnas.com>
X-Original-From: chencheng@fnnas.com
Message-Id: <cover.1789974245.git.chencheng@fnnas.com>
X-Mailer: git-send-email 2.55.0

From: Chen Cheng <chencheng@fnnas.com>

The previous patch rejects raid4/5 arrays with too few disks in
setup_conf(). During reshape assembly, raid5_run() still divides by the
data-disk count before that check, so a crafted superblock can hit
division by zero.

Extract min_raid_disks() and reject invalid reshape geometries in
raid5_run() first.

v1 -> v2:
- Added Link

Chen Cheng (2):
  md/raid5: extract min_raid_disks()
  md/raid5: reject invalid reshape disks in raid5_run()

 drivers/md/raid5.c | 28 ++++++++++++++++++----------
 1 file changed, 18 insertions(+), 10 deletions(-)

-- 
2.55.0
