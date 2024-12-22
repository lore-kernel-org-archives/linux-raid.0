Received: from mail.spoje.net (mail.spoje.net [82.100.58.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FC9613C3CD
	for <linux-raid@vger.kernel.org>; Sun, 22 Dec 2024 09:52:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=82.100.58.2
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734861162; cv=none; b=oSakRStu/VFz1tQ2Vt1VZgVBT3r594Dle7tk+IsmvdyWP/CudwyecYkFzxW+WO4G/riof3DlkkGHQhEmSLTvGNzDYzvHJUc340G+1tDItNVlI/zsqPy3jZEtB4yGWynvWDPdlc5z/kMMjzYlsVFYZJ0+ND/TdXVIemy4cj5nEr8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734861162; c=relaxed/simple;
	bh=eORYPW/0K2zM+cWGJq7IARb1B/RH2qfWK2BIjx2gObQ=;
	h=MIME-Version:Date:From:To:Subject:Message-ID:Content-Type; b=qzw79FjY02kQXv3GtWrZ6Fj6ErhN8X3TW3IkAVqAoL2Wk5hDR0BsdkNd/lTFaoAYp8s00CkLOSYXx7Zyn739DVdFc/oDTfFPlov07L72bqsaZbw7h/I2d1KvtFPZreVlW1NXFrg2/c15iLS3Ev80I9cmWr0MYYk5xuzBFh70TdA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=spoje.net; spf=pass smtp.mailfrom=spoje.net; dkim=pass (1024-bit key) header.d=spoje.net header.i=@spoje.net header.b=ey7FsfYh; dkim=pass (1024-bit key) header.d=spoje.net header.i=@spoje.net header.b=cCr1HSOn; arc=none smtp.client-ip=82.100.58.2
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=spoje.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=spoje.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=spoje.net header.i=@spoje.net header.b="ey7FsfYh";
	dkim=pass (1024-bit key) header.d=spoje.net header.i=@spoje.net header.b="cCr1HSOn"
Received: from localhost (localhost [127.0.0.1])
	by mail.spoje.net (Postfix) with ESMTP id 975A511C5E19
	for <linux-raid@vger.kernel.org>; Sun, 22 Dec 2024 10:45:04 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=spoje.net;
	s=spojemail; t=1734860704;
	bh=eORYPW/0K2zM+cWGJq7IARb1B/RH2qfWK2BIjx2gObQ=;
	h=Date:From:To:Subject:From;
	b=ey7FsfYhnftMBnmSZKbgUHnR2GnkOyaNB2EVyOMXlyxpUtAsWGulF5kvrsKauQCqe
	 1VSAFo/l5oVZdNrQIxkT9ut4RO5SXbpXS+XHyg26l5AFAvU/9rQNfs7GE4mcw+ANG2
	 k4QbCVeOxd7v6mPWpJ+EsQzIBDp+ZVD+yDESzePE=
X-Virus-Scanned: Debian amavisd-new at mail.spoje.net
Authentication-Results: mail.spoje.net (amavisd-new); dkim=pass (1024-bit key)
	header.d=spoje.net
Received: from mail.spoje.net ([127.0.0.1])
	by localhost (mail.spoje.net [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id pB4hA5IV5_J6 for <linux-raid@vger.kernel.org>;
	Sun, 22 Dec 2024 10:45:02 +0100 (CET)
Received: from mail.spoje.net (localhost [127.0.0.1])
	by mail.spoje.net (Postfix) with ESMTP id 371DC11C5E97
	for <linux-raid@vger.kernel.org>; Sun, 22 Dec 2024 10:45:02 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=spoje.net;
	s=spojemail; t=1734860702;
	bh=eORYPW/0K2zM+cWGJq7IARb1B/RH2qfWK2BIjx2gObQ=;
	h=Date:From:To:Subject:From;
	b=cCr1HSOnCgDKMKZlx2hR7oARVv21gcFPRO3Jsmq6Yj2VKI7ZKLdIXjXTkbPB5hQyN
	 09IUAOgslmR6IPjOkCVKYYzt3AeJZ1ixz6CJJFoVA/T5H3rvSxyhJKs4vZRSotV2Gu
	 GTXGfuqthu7+RXyPuLb4cXwrvCCOA8EBJkYLPqSM=
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Sun, 22 Dec 2024 10:45:02 +0100
From: Tomas Mudrunka <mudrunka@spoje.net>
To: linux-raid@vger.kernel.org
Subject: Confused about device counting in MD RAID1
Message-ID: <13b5f0846272587087a82f9953eaf81c@spoje.net>
X-Sender: mudrunka@spoje.net
Organization: SPOJE.NET s.r.o.
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit

Hello,
i am working on implementation of MD RAID1 and i am bit lost regarding 
superblock 1.2 format. Can you please help with following?

I've created RAID1 like this:

DEVICE_COUNT = 1
DEVICE_NUMBER = 0
ROLES: 0x0000

mdadm reports it to be correct, used mdadm to grow it like this:

mdadm --grow /dev/md23 --raid-disks=2 --force
maddm /dev/md23 --add /dev/sdb1

Now i've inspected superblocks of both devices and i have following:

DEVICE_COUNT = 2
DEVICE_NUMBER = 0
ROLES: 0x0000 0xFFFF 0x0100

DEVICE_COUNT = 1
DEVICE_NUMBER = 2
ROLES: 0x0000 0xFFFF 0x0100


First device number is 0, why second device is 2 (while 1 being 
skipped)? Should the count start at 1?
Why are there 3 roles now, when DEVICE_COUNT is 2 ? If count starts at 
1, why would there be roles[0]?
I am bit confused. Obviously i am making some trivial mistake and i 
don't want to keep guessing anymore.
Can you please tell me how to correctly handle this?

Thank you
Happy holidays!

-- 
S pozdravem
Best regards
      Tomáš Mudruňka
