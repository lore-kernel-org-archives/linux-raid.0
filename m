Received: from smtp161.vfemail.net (smtp161.vfemail.net [146.59.185.161])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 047B623EAA1
	for <linux-raid@vger.kernel.org>; Mon, 16 Feb 2026 03:10:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=146.59.185.161
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771211443; cv=none; b=uUhvq+jhFh0KwTmVYQ66BrBg3CrVcfEXpy5qZslvS2eT7RHp4WHjs+rDN2kRTMlXXcnsq2qV8Fs9P+smm9AOoYwJHCIma3Mhm20FJI5I5o5UqsimArpGmhDK8xYo3xVLg1uGop2XZ8eP672AMnt4aIp0gWfGZf3EYdwu6Bt1FZE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771211443; c=relaxed/simple;
	bh=gbgml3uKK8s8i6dhgne1cbY0GkVzgmf6hOrAMm4yd3s=;
	h=Date:From:To:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=UjiuCHg9cB5uUqYM/qWonXrsa6y7HwIO6Oblsp5I6hIzSBgkwxp3Qj4uLFOPVjGjgpKnXszVGNnQR9il81RCsSxWOgxwayEymZpQDc0dWEAfqm/Ma9bw+g82sRtHE9TOzo5AklPxw0QUWI/yiK/LXW67acgXhPKv65Mgc2Om67A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vfemail.net; spf=pass smtp.mailfrom=vfemail.net; dkim=pass (1024-bit key) header.d=vfemail.net header.i=@vfemail.net header.b=JPfJpGzy; arc=none smtp.client-ip=146.59.185.161
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vfemail.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vfemail.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=vfemail.net header.i=@vfemail.net header.b="JPfJpGzy"
Received: (qmail 12217 invoked from network); 16 Feb 2026 03:10:40 +0000
Received: from localhost (HELO nl101-3.vfemail.net) ()
  by smtpout.vfemail.net with SMTP; 16 Feb 2026 03:10:40 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=simple; d=vfemail.net; h=date:from
	:to:subject:message-id:in-reply-to:references:mime-version
	:content-type:content-transfer-encoding; s=2018; bh=gbgml3uKK8s8
	i6dhgne1cbY0GkVzgmf6hOrAMm4yd3s=; b=JPfJpGzydsshApIvfTUv2uvq5Qb5
	v6hNPucPhWtdqrQdwpBwUIcmAlDbaTs6pWs7VxNT4RotmuiGzXy33ZFq19K7yde2
	6FA131Kizbj7HSyUyOY5wJ5Yp3EfbtoW7WaFbOlA9zuAj7BjMcTibd3izozMp1zx
	mMp/eWSBsFv9GHU=
Received: (qmail 91036 invoked from network); 15 Feb 2026 21:10:39 -0600
Received: by simscan 1.4.0 ppid: 91028, pid: 91032, t: 0.3213s
         scanners:none
Received: from unknown (HELO bmwxMDEudmZlbWFpbC5uZXQ=) (aGdudGt3aXNAdmZlbWFpbC5uZXQ=@MjE3LjE4Mi4yMDYuNjY=)
  by nl101.vfemail.net with ESMTPA; 16 Feb 2026 03:10:39 -0000
Date: Sun, 15 Feb 2026 22:10:37 -0500
From: David Niklas <simd@vfemail.net>
To: <linux-kernel@vger.kernel.org>, Linux RAID <linux-raid@vger.kernel.org>
Subject: Re: Cannot change RAID array check speed
Message-ID: <20260215221037.0081c98a@Core-Ultra-2-x20>
In-Reply-To: <20260215220843.6b28e632@Core-Ultra-2-x20>
References: <20260215220843.6b28e632@Core-Ultra-2-x20>
X-Mailer: Claws Mail 4.3.1 (GTK 3.24.38; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

I forgot to mention that I also tested with Kernel version 6.14. It has
the same problem.

Thanks again,
David

On Sun, 15 Feb 2026 22:08:43 -0500
David Niklas <simd@vfemail.net> wrote:
> Hello,
> I upgraded my kernel from 6.9 to 6.17. They're both the "same" custom
> config. I tried:
> 
> # echo 200000 > /sys/devices/virtual/block/md7/md/sync_speed
> bash: /sys/devices/virtual/block/md7/md/sync_speed: Permission denied
> # id
> uid=0(root) gid=0(root) groups=0(root)
> 
> This used to work. Any ideas as to what I could have set wrong? I
> haven't a clue!
> 
> Is there a security debugging tool or a log-file I could use to trace
> this down?
> 
> Thanks,
> David

