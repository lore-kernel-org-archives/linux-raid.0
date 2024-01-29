Received: from smtp161.vfemail.net (smtp161.vfemail.net [146.59.185.161])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC40145954
	for <linux-raid@vger.kernel.org>; Mon, 29 Jan 2024 05:21:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=146.59.185.161
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706505697; cv=none; b=KbsXCZILenqd7CxpHs8hYRrriJXnC7DI3r7T41abaML2UZw1b6EGZ09HOejHdIjtV2zwOtCd6/miBVcXDSpQiFV9ESfl24bpLWdpErw7Af5k6nToVKCSxDUQ+MzKbclL70IFArecTt+1U9wqauYusdF4j1Vm6Q3DZwSU4wfkyfU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706505697; c=relaxed/simple;
	bh=SXfHU0FYlnOkSohPLdf20zVevYWWeI9IVj+8NSu1UJY=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type; b=J6qXPRs0O9xc5BOiEAbSIHjsig1hLlcIDuBLTUkPrg2VahdRd1nC//zr30IejimS1aNDYvlVRhdDHyagPvOK16wuh0YXgR3vO+M0BXywRN/7nDAABnrPHlh1bKWhgDyeleqlfPlEbwg0ZMQ+LB7xi0sXoZ48Ybd5ZWnuxKmW8UA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vfemail.net; spf=pass smtp.mailfrom=vfemail.net; dkim=pass (1024-bit key) header.d=vfemail.net header.i=@vfemail.net header.b=SZWwTFiT; arc=none smtp.client-ip=146.59.185.161
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vfemail.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vfemail.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=vfemail.net header.i=@vfemail.net header.b="SZWwTFiT"
Received: (qmail 20860 invoked from network); 29 Jan 2024 05:21:28 +0000
Received: from localhost (HELO nl101-3.vfemail.net) ()
  by smtpout.vfemail.net with ESMTPS (ECDHE-RSA-AES256-GCM-SHA384 encrypted); 29 Jan 2024 05:21:28 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=simple; d=vfemail.net; h=date:from
	:to:subject:message-id:mime-version:content-type
	:content-transfer-encoding; s=2018; bh=SXfHU0FYlnOkSohPLdf20zVev
	YWWeI9IVj+8NSu1UJY=; b=SZWwTFiTVSfSXiw95mUIZzoHtonQvt9Aa3oDdeo2P
	vd28Ag3vr2vRWx7pC8cqFeJ82wD6pBy2E38HOZl7YQnYcA8OOcwhkWbJtIQ5HVnj
	By0wmpVc8jl1yf7lzvClMkoKTxAI9O9n4qQFrYj2iubCX3PEUTX1hsK8mqbaDKIF
	74=
Received: (qmail 72881 invoked from network); 29 Jan 2024 05:21:27 -0000
Received: by simscan 1.4.0 ppid: 72866, pid: 72878, t: 0.3519s
         scanners:none
Received: from unknown (HELO bmwxMDEudmZlbWFpbC5uZXQ=) (aGdudGt3aXNAdmZlbWFpbC5uZXQ=@MTkyLjE2OC4xLjE5Mg==)
  by nl101.vfemail.net with ESMTPA; 29 Jan 2024 05:21:27 -0000
Date: Mon, 29 Jan 2024 00:21:24 -0500
From: David Niklas <simd@vfemail.net>
To: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
Subject: And then they sent my defective CPU back to me...
Message-ID: <20240129002124.36e1a1b5@firefly>
X-Mailer: Claws Mail 3.13.2 (GTK+ 2.24.30; aarch64-unknown-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

Hello,

### Background (for the curious.)

Much like the rest of you, I have a RAID array on my PC.

I've just come out of the tail end of a PC repair nightmare where you
send your parts in for warranty and they're still broken when you get
them back.

During this trying process of testing my array "decided" to resync itself.
I tried to idle it, but that failed. Granted, I might have copied the
data I wanted off of it, but I didn't think about it at the time and it
was the array which seemed to really trigger the bug.

The problem I was seeing was silent data corruption. I've done some
tests, and the system seems stable now that I've replaced my CPU, but I
can't prove it as this bug has a history of being hard to detect.

And how did I find it? I was running a check of my array before backing
up my data to cold storage... My PC kept crashing. I then replaced,
unplugged, or warrantied out each and every part. But the bug was still
there. Thus I purchased some a new CPU, lower performance CPU, and an
identical MB, which were the only parts I didn't have spares for.

And then ata12 decided to act up... so that's one drive I probably have
to warranty...

And then when booting fsck "decided" to fix the file system... which
would ordinarily be mounted ro as I knew I had problems.
I killed fsck as fast as I could.
### end background



As things stand, I have an array which has some errors in it. Like 100
reports of mismatches worth of errors.

It's a RAID 60 array. Why 60? Because I had read that only 4 drives
could be used in a RAID 6 array in my CompTIA book and my drives are over
6TB so RAID 5 won't work right. I'm beginning to suspect that limitation
doesn't exist for md raid.

Now last time I had a problem with mismatched sectors, I used this
article here to help me find the affected files:
https://unix.stackexchange.com/questions/730307/find-files-contained-in-sector-of-a-raid-array

Last time, I could easily replace the affected files. So I just resynced.
Then, out of curiosity, I compared the originals to the damaged ones and
they were identical. So, is the above answer the way to find damaged
files?

Is there a way to isolate the array so that I can see the different
"versions", if you will, of the affected files/file system?

Thanks,
David
