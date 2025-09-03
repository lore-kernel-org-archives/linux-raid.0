Received: from mail1.g17.pair.com (mail1.g17.pair.com [216.92.2.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C153235C01
	for <linux-raid@vger.kernel.org>; Wed,  3 Sep 2025 21:10:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.92.2.65
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756933828; cv=none; b=WNlPUGTNuwgnwrO4nq+wXhWmNheIu3FFPJAxB1rI/tjWhBoh/pYZ2+tAH54bygSJCf/3/vuctc7AQiAupQO7vwCRNd+p1qVCPSkOXvKhzJcNk1RU9YXBCYh6ctHGqANyV3ku4fDIBHFQuyV/KFRtQin5A1hxt/N5xkmPiau8Bow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756933828; c=relaxed/simple;
	bh=sAqJg9kuwTSoLUpQn3EhON171I4ZtmJ2IbEpWEIltTg=;
	h=To:From:Subject:Date:Message-ID; b=kKq3jHyZ5Uj4TFEqC5TR6+8GvkUkeFKb8qqW6Ygv9Qy2QTJDxxuW3F2qL2e9cYwAL0lqMx0goJELCXdUsmOQ6ZW+zednbu8H05vID8QHSNe02h/T1ZoFYsfDh5jzLFmPlBTmc9bGruNgA8VHNlIPEsdFWpIrjO03f6omFpBOuyI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=cjsa.com; spf=pass smtp.mailfrom=cjsa.com; dkim=pass (2048-bit key) header.d=cjsa.com header.i=@cjsa.com header.b=FwY1ofUE; arc=none smtp.client-ip=216.92.2.65
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=cjsa.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cjsa.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cjsa.com header.i=@cjsa.com header.b="FwY1ofUE"
Received: from mail1.g17.pair.com (localhost [127.0.0.1])
	by mail1.g17.pair.com (Postfix) with ESMTP id 2BD2F1682BE
	for <linux-raid@vger.kernel.org>; Wed,  3 Sep 2025 17:04:50 -0400 (EDT)
Received: from dymaxion.cjsa2.com (c-67-168-59-2.hsd1.wa.comcast.net [67.168.59.2])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mail1.g17.pair.com (Postfix) with ESMTPSA id D95EA1682BC
	for <linux-raid@vger.kernel.org>; Wed,  3 Sep 2025 17:04:49 -0400 (EDT)
Received: from dymaxion.cjsa2.com (localhost.cjsa2.com [127.0.0.1])
	by dymaxion.cjsa2.com (8.18.1/8.18.1/Debian-2) with ESMTPS id 583L4m063370870
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT)
	for <linux-raid@vger.kernel.org>; Wed, 3 Sep 2025 14:04:48 -0700
Received: (from news@localhost)
	by dymaxion.cjsa2.com (8.18.1/8.18.1/Submit) id 583L4miM3370852
	for linux-raid@vger.kernel.org; Wed, 3 Sep 2025 14:04:48 -0700
To: linux-raid@vger.kernel.org
Path: jeff
From: Jeffery Small <jeff@cjsa.com>
Newsgroups: local.linux.raid
Subject: What is the best way to set up RAID-1 on new Ubuntu install
Date: Wed, 3 Sep 2025 21:04:48 -0000 (UTC)
Organization: CJSA LLC
Message-ID: <109aahg$34jlp$1@dymaxion.cjsa2.com>
Keywords: ubuntu raid
User-Agent: nn/6.7.3
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cjsa.com; h=to:from:subject:date:message-id; s=pair-202402141545; bh=JsuvorfA/hEWg9XdseuxsgqnaM/XDt/F/XqVgn7xMb4=; b=FwY1ofUEJKKZ8vUkAh22frpIOE5XyDQli3mGLVK2SM7qT6KnO+6FpyyQToZXHPRhqb8krwaCrPzXShzMMHtlvh8AEdHj3ZGsymNO+Wnk2/k2RmUTZoaFW9QxcVomZUfVpQd1i9ZG9RapXrQgfUWMR8GzF22VgNcwTRqf++d3a4KxC6hkZnjWsMObJRm7h3b+kRdzRY4vf0+Mbl+XnazY78DL+YDiT74NmaFqAFWOXpOaH0Z6H0V0a3DSdt8cRpZvGztEypInfX93mupOSUVBnmmJzxKMWnTdhclogfAJzuXUSfSJJoOtMiDnk225FX7k4aT8owdnIfIzNbO2Q9zqcg==
X-Scanned-By: mailmunge 3.10 on 216.92.2.65
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>


I will be installing Xubuntu 24.04.3 on a newly built system having two
4TB Samsung M.2 SSDs which will be mirrored using RAID-1.  My question is
what is the better way to set up the mirror.  I'll have 128GB of RAM and
will be using a swapfile after installation.

Method #1: After the UEFI partition is created on both disks, create GPT
           /boot, / and /home partitions on each SSD and then create
	   three separate mirrors:

	   md0: /boot

	   md1: /

	   md2: /home

Method #2: After the UEFI partition is created on both disks, mirror md0
	   using the rest of the free space.  Then create GPT partitions
	   directly on the mirror:

	   md0p1: /boot

	   md0p2: /

	   md0p3: /home

This will be a straightforward desktop workstation, with no encryption or
support for multiple OS installs.  Are there advantages or possible pitfalls
with either approach?

I'm also considering eliminating the boot and home partitions and just
using a single root partition which feels strange after using UNIX for over
40 years. From a raid perspective does this also have advantages/pitfalls?

Thanks.
--
Jeffery Small
