Received: from smtp161.vfemail.net (smtp161.vfemail.net [146.59.185.161])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A0AA17A309
	for <linux-raid@vger.kernel.org>; Sat,  1 Nov 2025 15:53:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=146.59.185.161
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762012437; cv=none; b=RRhtsb9EUe3e5DhPCUgQJeUjGR2fYJk2jPw/uXNROnVqgMwfJIyBD9JRa1p3t1fVHL3jPvPcgxwS2tv8gvx9J4621sKF8b/X0UXNhYCB9e+j18lpyFnlxKvNxf+9/rmgZ/bBK0RFZSPO8vuxnRFZpYjwvxQO1MgbWWeUez1U9PQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762012437; c=relaxed/simple;
	bh=5BZbw6CkgNakml/tTTufAjAiZou+ZaipsQ/2pw/5CLY=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type; b=hSX0f1bI4kUCNWVgwX3N+Az9zVw8pqX/Tn2rs9evDMa3y8atwHRg7NbwLci4RVaBKMKpZTsMyRrZzgsVm4VepVKiG8kfyAtiVIieNDV3gjXfGL8m7FjUrHDL8JgykekfJRNXNR6/jTrbb9i+XHImUurSUQC7DeGTWXFQOJWleEU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vfemail.net; spf=pass smtp.mailfrom=vfemail.net; dkim=pass (1024-bit key) header.d=vfemail.net header.i=@vfemail.net header.b=f5vZwV8H; arc=none smtp.client-ip=146.59.185.161
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vfemail.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vfemail.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=vfemail.net header.i=@vfemail.net header.b="f5vZwV8H"
Received: (qmail 7677 invoked from network); 1 Nov 2025 15:44:52 +0000
Received: from localhost (HELO nl101-3.vfemail.net) ()
  by smtpout.vfemail.net with SMTP; 1 Nov 2025 15:44:52 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=simple; d=vfemail.net; h=date:from
	:to:subject:message-id:mime-version:content-type
	:content-transfer-encoding; s=2018; bh=5BZbw6CkgNakml/tTTufAjAiZ
	ou+ZaipsQ/2pw/5CLY=; b=f5vZwV8HqaI7tuNfprIwfvSuiQjlFOjifAPIRc8G0
	hsuquHZDxuDY7l8gD3lMhBDPABZ2MF1CBQGdVO4RA1N8w8E5uPIG2PyIdJbYfNP2
	OT9MQPqArIUsH6KI3qN3lCmhYhZsHHSMf212Xc34PRRCzlqS0zAd5YX0r45+ArMl
	I8=
Received: (qmail 33539 invoked from network); 1 Nov 2025 10:47:12 -0500
Received: by simscan 1.4.0 ppid: 33492, pid: 33499, t: 0.3100s
         scanners:none
Received: from unknown (HELO bmwxMDEudmZlbWFpbC5uZXQ=) (aGdudGt3aXNAdmZlbWFpbC5uZXQ=@MTkyLjE2OC4xLjE5Mg==)
  by nl101.vfemail.net with ESMTPA; 1 Nov 2025 15:47:11 -0000
Date: Sat, 1 Nov 2025 11:47:09 -0400
From: David Niklas <simd@vfemail.net>
To: Linux RAID <linux-raid@vger.kernel.org>
Subject: How do I determine the amount of stripes my array has?
Message-ID: <20251101114709.0a48e865@Core-Ultra-2-x20>
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
I've been using the raid6check program to recover my array. It's been
going now for several weeks and I wanted to estimate how long it would
take. I can tell where it is based on where it's finding errors, but I
don't know how many stripes my array has.

How do I determine the amount of stripes my array has?

Thanks!
