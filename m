Received: from smtp161.vfemail.net (smtp161.vfemail.net [146.59.185.161])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C086A1D696
	for <linux-raid@vger.kernel.org>; Sun, 18 Feb 2024 16:30:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=146.59.185.161
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708273838; cv=none; b=fw+f+Gld0nufcKMABVsd2tYa7pabIo0yMfsBlC1YOgDN6UMj6TCfux8dM12HxQ+KX6SYVpXgCMbvL3ulsbu0ZYzZWQyc+1tU3NTsHAGZNb3YfUerqgDTgeyiqOw+o9AP7PrvRLGtxu9OMOSTTmhuaqi+X5F5jPslhPM/1ekGHbU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708273838; c=relaxed/simple;
	bh=rsxVFkTDQNiMx5Dtmt6C06buZ9s4anvHvw1Qd44HWPo=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type; b=kHCXnuJMQzzbxpH4v/BT6gNTabTIvPtWMPLhXeGMMCP4aCZJohS8DgUM4CgwgBgT3RI5YeB0NwZDXhUg4RVNyPvqUn7ICcru/c/lP0bJLqDihVE9dTjfU5jI97KvqC019S4F/tkPqsf/zC13vGT41gnQqCZY7RAoG7W8tmR267I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vfemail.net; spf=pass smtp.mailfrom=vfemail.net; dkim=pass (1024-bit key) header.d=vfemail.net header.i=@vfemail.net header.b=DIn+jf7x; arc=none smtp.client-ip=146.59.185.161
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vfemail.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vfemail.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=vfemail.net header.i=@vfemail.net header.b="DIn+jf7x"
Received: (qmail 9807 invoked from network); 18 Feb 2024 16:23:53 +0000
Received: from localhost (HELO nl101-3.vfemail.net) ()
  by smtpout.vfemail.net with ESMTPS (ECDHE-RSA-AES256-GCM-SHA384 encrypted); 18 Feb 2024 16:23:53 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=simple; d=vfemail.net; h=date:from
	:to:subject:message-id:mime-version:content-type
	:content-transfer-encoding; s=2018; bh=rsxVFkTDQNiMx5Dtmt6C06buZ
	9s4anvHvw1Qd44HWPo=; b=DIn+jf7xcIziI9Km5WASYeo+CSUsNwL/vGuhDuQT0
	9mHQs7V5q6ymTDWixa03i0py7HtoX6w6ZkI7IbAlM6magN/af71lUDa3nnO3x7/B
	N+XwSXOQUEE2W3BGMqIx1ZEmBIGUysTPI5czOt0ERd9hHdPQXaYH2s9Lfdwb7dLj
	Xc=
Received: (qmail 42743 invoked from network); 18 Feb 2024 16:23:53 -0000
Received: by simscan 1.4.0 ppid: 42716, pid: 42729, t: 0.3660s
         scanners:none
Received: from unknown (HELO bmwxMDEudmZlbWFpbC5uZXQ=) (aGdudGt3aXNAdmZlbWFpbC5uZXQ=@MTkyLjE2OC4xLjE5Mg==)
  by nl101.vfemail.net with ESMTPA; 18 Feb 2024 16:23:53 -0000
Date: Sun, 18 Feb 2024 11:23:49 -0500
From: simd@vfemail.net
To: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
Subject: Array will not resync.
Message-ID: <20240218112349.61a97801@firefly>
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

I cannot get my RAID 6 array to resync.

I'm using mdadm version v4.1. I've tried kernels 5.18.X, 6.0.X, and
6.3.X on Devuan (Debian) Linux.

% echo resync > /sys/devices/virtual/block/md127/md/sync_action

Does nothing. 

% mdadm --assemble --update=resync /dev/md127

Does nothing.

I should see a status change to resync with mdadm --detail /dev/md127 and
hear some activity from the drives.

I tried adding the verbose option, but it only lists the recognizing of
the drives and adding them to the array.

The array currently has some mismatches which need to be corrected. It's
currently registering all devices in "active sync" status and says that
it is "clean".

I tried setting the flag, in misc mode, to readonly and then back to
readwrite but that still doesn't allow the array to be resync'd.

In desperation, I tried unplugging one of the drives, it holds most/all
of the mismatches -- the SATA cable was going bad, and then I touch(1)ed a
file on the FS and unmounted the FS. Although the array recognized the
failure of the drive, it did not start resync the array upon adding the
drive back into the array.




Any ideas how to resync the array?

Thanks,
David
