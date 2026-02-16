Received: from smtp161.vfemail.net (smtp161.vfemail.net [146.59.185.161])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 699FF2609C5
	for <linux-raid@vger.kernel.org>; Mon, 16 Feb 2026 03:15:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=146.59.185.161
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771211730; cv=none; b=XsNALTYh0vADXrUqNvyhqXIIobFYYZ4s/9X62Rm+8qV6SFSQv0906O+8j8zTTJHxQ+ZQLHjNsZd3uLjziEyYtB0YfE2Lnl2aLwZd4iib9UhsAKUC5AZ6KJ8vLEM/KIjW+io7vRd5GDOFzEdTJAOIfPAx2WWGBJFXdBd3R9F1c+4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771211730; c=relaxed/simple;
	bh=CknI7ppKpv87vbT0ZMFc20vtzcEf4I4lxowMweziTKg=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type; b=BGJ64AyuR7t8rVCRl2K+srZrQZuZQq8WGYy4dlnr+B5Lg6kfnopPKNFZEih0nxoI90aYOHyHvtLAEjJQWO0XjojMRqyIOrum2TG1WsN2xkJrKTGz4B9t+P295Jchg+ZMY2uN37QKb9D9zVIxoqQiDP9c+H0ANcn1fHA3vfRWEBs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vfemail.net; spf=pass smtp.mailfrom=vfemail.net; dkim=pass (1024-bit key) header.d=vfemail.net header.i=@vfemail.net header.b=a2YUpZrw; arc=none smtp.client-ip=146.59.185.161
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vfemail.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vfemail.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=vfemail.net header.i=@vfemail.net header.b="a2YUpZrw"
Received: (qmail 11821 invoked from network); 16 Feb 2026 03:08:46 +0000
Received: from localhost (HELO nl101-3.vfemail.net) ()
  by smtpout.vfemail.net with SMTP; 16 Feb 2026 03:08:46 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=simple; d=vfemail.net; h=date:from
	:to:subject:message-id:mime-version:content-type
	:content-transfer-encoding; s=2018; bh=CknI7ppKpv87vbT0ZMFc20vtz
	cEf4I4lxowMweziTKg=; b=a2YUpZrwSxFVIDlOBLUvUVNrpbwcVycseyzBjXcV0
	alMlJyMEKKLR7ufcwK2nTs1Yw0aHHudWeWzlACezZPy5A91cZiMq70gDzN9h0KdS
	BYc3nTjStQBnMUR+ya0n22ROvYRAKrXoypTwGsQKof/TUR2Iqmvf7Q7lpX0ZST5Q
	pA=
Received: (qmail 88472 invoked from network); 15 Feb 2026 21:08:45 -0600
Received: by simscan 1.4.0 ppid: 88459, pid: 88466, t: 0.2970s
         scanners:none
Received: from unknown (HELO bmwxMDEudmZlbWFpbC5uZXQ=) (aGdudGt3aXNAdmZlbWFpbC5uZXQ=@MjE3LjE4Mi4yMDYuNjY=)
  by nl101.vfemail.net with ESMTPA; 16 Feb 2026 03:08:45 -0000
Date: Sun, 15 Feb 2026 22:08:43 -0500
From: David Niklas <simd@vfemail.net>
To: <linux-kernel@vger.kernel.org>, Linux RAID <linux-raid@vger.kernel.org>
Subject: Cannot change RAID array check speed
Message-ID: <20260215220843.6b28e632@Core-Ultra-2-x20>
X-Mailer: Claws Mail 4.3.1 (GTK 3.24.38; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

Hello,
I upgraded my kernel from 6.9 to 6.17. They're both the "same" custom
config. I tried:

# echo 200000 > /sys/devices/virtual/block/md7/md/sync_speed
bash: /sys/devices/virtual/block/md7/md/sync_speed: Permission denied
# id
uid=0(root) gid=0(root) groups=0(root)

This used to work. Any ideas as to what I could have set wrong? I haven't
a clue!

Is there a security debugging tool or a log-file I could use to trace this
down?

Thanks,
David
