Received: from smtp161.vfemail.net (smtp161.vfemail.net [146.59.185.161])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 199C41922DD
	for <linux-raid@vger.kernel.org>; Tue,  5 Aug 2025 02:27:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=146.59.185.161
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754360870; cv=none; b=YN1wqx6luE0z48tE9KINfsymmfMLeXFHkBYeeVBQ6K26ufZHld1PBBkwfn9kI4NT4moq2jfkhzw2cn7TItvQjhMuewEvG1Qda8LQ/7BVB+6jnKDX8fo/J+ctS1WytkyneqgVwxqUgyTS4QAcAPyZtk03auJBTjlq2t4wx4Xl398=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754360870; c=relaxed/simple;
	bh=1ig714B//j1jEmMSife6B9hkGrotf1YNIMm0xg3qxHE=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type; b=AAbcxITi1PA79Tc9VfJeI0cSU3c8d+eQ2hKz4w2B9gDls6zEbbhX2slGC0DAP4WywX0Rf8mwKTTcVlLDSrF4STp+xi2B2sWv/cr8Nj3OKANEkiLS13RQlrjERz6yZpP3lW7S46vFJat31iTBKv4PgfqycRhTZn8lemJhO7oa6Sk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vfemail.net; spf=pass smtp.mailfrom=vfemail.net; dkim=pass (1024-bit key) header.d=vfemail.net header.i=@vfemail.net header.b=eni1B7Gr; arc=none smtp.client-ip=146.59.185.161
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vfemail.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vfemail.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=vfemail.net header.i=@vfemail.net header.b="eni1B7Gr"
Received: (qmail 26918 invoked from network); 5 Aug 2025 02:19:21 +0000
Received: from localhost (HELO nl101-3.vfemail.net) ()
  by smtpout.vfemail.net with SMTP; 5 Aug 2025 02:19:21 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=simple; d=vfemail.net; h=date:from
	:to:subject:message-id:mime-version:content-type
	:content-transfer-encoding; s=2018; bh=1ig714B//j1jEmMSife6B9hkG
	rotf1YNIMm0xg3qxHE=; b=eni1B7GrhpQiv1AiCVCRVEf+iR/e+H6/DT4iA5/TQ
	RuemRH8E7jadFgb6iNMOEIiGOTKBM5Qk7Tcb1cWorULdXqXRKwM7tQoedj3658Fw
	t3x04p/LX7sMjPkk1MO7c5/zTQ9743wFPDwlbrVhjey48nToFHo1/q5NCIHQPQGv
	bc=
Received: (qmail 75460 invoked from network); 4 Aug 2025 21:21:04 -0500
Received: by simscan 1.4.0 ppid: 75445, pid: 75454, t: 0.3138s
         scanners:none
Received: from unknown (HELO bmwxMDEudmZlbWFpbC5uZXQ=) (aGdudGt3aXNAdmZlbWFpbC5uZXQ=@MTkyLjE2OC4xLjE5Mg==)
  by nl101.vfemail.net with ESMTPA; 5 Aug 2025 02:21:04 -0000
Date: Mon, 4 Aug 2025 22:21:02 -0400
From: David Niklas <simd@vfemail.net>
To: Linux RAID <linux-raid@vger.kernel.org>
Subject: Ran ./test on mdadm source before running raid6check. Now array is
 borked.
Message-ID: <20250804222102.467e1315@Zen-II-x12>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

Hello,
I managed to find the raid6check utility here:
https://salsa.debian.org/debian/mdadm

I downloaded and compiled the code, ran mdadm --stop on my array, and
ran ./test . Many of the tests failed, but more concerning is that I
cannot restart my array.

# mdadm --verbose --assemble /dev/md0
mdadm: looking for devices for /dev/md0
mdadm: /dev/sda has wrong uuid.
mdadm: No super block found on /dev/sdb (Expected magic a92b4efc, got
00000000) mdadm: no RAID superblock on /dev/sdb
mdadm: No super block found on /dev/sdc (Expected magic a92b4efc, got
00000000) mdadm: no RAID superblock on /dev/sdc
mdadm: No super block found on /dev/sdd (Expected magic a92b4efc, got
00000000) mdadm: no RAID superblock on /dev/sdd
mdadm: No super block found on /dev/sde (Expected magic a92b4efc, got
00000000) mdadm: no RAID superblock on /dev/sde

What do I do now?
If the test utility is so dangerous, why is there no warning to pull your
HDDs before you run ./test? Like, make test normally doesn't bork
anything.

Thanks!
