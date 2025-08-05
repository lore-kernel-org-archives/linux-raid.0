Received: from smtp161.vfemail.net (smtp161.vfemail.net [146.59.185.161])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36D3321A424
	for <linux-raid@vger.kernel.org>; Tue,  5 Aug 2025 04:57:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=146.59.185.161
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754369877; cv=none; b=RKcBPDVD4MLhuH3wC3C1v0GQpxmcvrUOuHNdgschQGbhAlDxpw7rQ6hYrPuRg4BVX1NkybXz/mSSpzNQTToSC/cpbKTAnws+ZQN/VCm3qo5stDAKW9SOjM6WCIIsXCgsXc6BMS4laB6xH1rQJILhb5l442qooQwYTAiy2ygL3W0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754369877; c=relaxed/simple;
	bh=uZUmGoc4LFgclUR5aVQyMcNSPC7saeki+GQNJ9wRhhU=;
	h=Date:From:To:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PxIY7FcCaf9da6RfkzyIx01RoGEwRmAcYzdaDhdo9q3qbBpkNcN3acq1vigppyPu0s0Ad2ZrGMw6OYxvcKqOt7C/p9CU8leEscU5GfIxPr7leDPGIJTz22HUlGSjaWmvzfRWiqgLnQyUJZURKwTn8evSmCmjtPNQv7yz0XoBg5Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vfemail.net; spf=pass smtp.mailfrom=vfemail.net; dkim=pass (1024-bit key) header.d=vfemail.net header.i=@vfemail.net header.b=greFJEXU; arc=none smtp.client-ip=146.59.185.161
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vfemail.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vfemail.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=vfemail.net header.i=@vfemail.net header.b="greFJEXU"
Received: (qmail 21975 invoked from network); 5 Aug 2025 04:56:09 +0000
Received: from localhost (HELO nl101-3.vfemail.net) ()
  by smtpout.vfemail.net with SMTP; 5 Aug 2025 04:56:09 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=simple; d=vfemail.net; h=date:from
	:to:subject:message-id:in-reply-to:references:mime-version
	:content-type:content-transfer-encoding; s=2018; bh=uZUmGoc4LFgc
	lUR5aVQyMcNSPC7saeki+GQNJ9wRhhU=; b=greFJEXU7MTFnQ5HtRSzNqhqcCXL
	88O2c+SUgD6AqWDgb9Ik/+4V6WmLCGgZsu4ErLKjHU4vwkLciEdY8gBsko2amSkV
	9zWzK9hQN1JhJEQd0jLFPdRrTEOsD2fyCW+DiRPWn0FSoNz5VvY/780DtVbjEy9Y
	2vQB3jWxFz3+gNY=
Received: (qmail 91473 invoked from network); 4 Aug 2025 23:57:52 -0500
Received: by simscan 1.4.0 ppid: 91464, pid: 91466, t: 0.3190s
         scanners:none
Received: from unknown (HELO bmwxMDEudmZlbWFpbC5uZXQ=) (aGdudGt3aXNAdmZlbWFpbC5uZXQ=@MTkyLjE2OC4xLjE5Mg==)
  by nl101.vfemail.net with ESMTPA; 5 Aug 2025 04:57:52 -0000
Date: Tue, 5 Aug 2025 00:57:50 -0400
From: simd@vfemail.net
To: Linux RAID <linux-raid@vger.kernel.org>
Subject: Re: Ran ./test on mdadm source before running raid6check. Now array
 is borked.
Message-ID: <20250805005750.21740cd9@Zen-II-x12>
In-Reply-To: <20250804222102.467e1315@Zen-II-x12>
References: <20250804222102.467e1315@Zen-II-x12>
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
I think I found out my problem. I have some backup drives in my system,
to backup my data to. For some reason, an AiC I use for my HDDs failed to
post. Therefore, the drives I'm looking at are mostly the backup drives.
Hence why there are are "00000000".

Thanks guys!

On Mon, 4 Aug 2025 22:21:02 -0400
simd@vfemail.net wrote:
> Hello,
> I managed to find the raid6check utility here:
> https://salsa.debian.org/debian/mdadm
> 
> I downloaded and compiled the code, ran mdadm --stop on my array, and
> ran ./test . Many of the tests failed, but more concerning is that I
> cannot restart my array.
> 
> # mdadm --verbose --assemble /dev/md0
> mdadm: looking for devices for /dev/md0
> mdadm: /dev/sda has wrong uuid.
> mdadm: No super block found on /dev/sdb (Expected magic a92b4efc, got
> 00000000) mdadm: no RAID superblock on /dev/sdb
> mdadm: No super block found on /dev/sdc (Expected magic a92b4efc, got
> 00000000) mdadm: no RAID superblock on /dev/sdc
> mdadm: No super block found on /dev/sdd (Expected magic a92b4efc, got
> 00000000) mdadm: no RAID superblock on /dev/sdd
> mdadm: No super block found on /dev/sde (Expected magic a92b4efc, got
> 00000000) mdadm: no RAID superblock on /dev/sde
> 
> What do I do now?
> If the test utility is so dangerous, why is there no warning to pull
> your HDDs before you run ./test? Like, make test normally doesn't bork
> anything.
> 
> Thanks!
> 

