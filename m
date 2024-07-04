Received: from mr4.vodafonemail.de (mr4.vodafonemail.de [145.253.228.164])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00A834085D
	for <linux-raid@vger.kernel.org>; Thu,  4 Jul 2024 17:50:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=145.253.228.164
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720115410; cv=none; b=LT1oI+9hoVohMcjZTq/ahHPcYlKVCpHmvD4euHfUWCakicipFvIFBR8LWSUKqrPLYS2DN1fYW3wxkb7xF/RdOlEWCHMPRE12JSqbO9t3wPmUoFANnwRCfjI+CC67n7KtoLnEFY+m7g4mbA3hNZ9SJLyg5lrDYektwKmlFsq9s8g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720115410; c=relaxed/simple;
	bh=GK2YQGpPppZ4TTz6Nmd2ZMewLLoTmG9eiJb6RkZmftw=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=u4P6cZ2P0RVNd6a+KhzPxU8ALYxot/KqvCcqT3zXbmMJliyAD67MORl0qnbedup7Tx/4XI8b1gBM8Emxk8e/rUUoCUle7gME/MHB3+jsdPHbRy4pB9AqF6H5uHQsZK+00GWSB1QKmZmsDZPZO7c9nu74s95mS5V4K99B7wgybOA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nexgo.de; spf=pass smtp.mailfrom=nexgo.de; dkim=pass (1024-bit key) header.d=nexgo.de header.i=@nexgo.de header.b=ZUs5IePK; arc=none smtp.client-ip=145.253.228.164
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nexgo.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nexgo.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=nexgo.de header.i=@nexgo.de header.b="ZUs5IePK"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nexgo.de;
	s=vfde-mb-mr2-23sep; t=1720114826;
	bh=akg++9cjLfNvAPXCSK69aKDHGQHx4t8MKFBKibe/lqA=;
	h=Date:From:To:Subject:Message-ID:Content-Type:From;
	b=ZUs5IePKHUXn8XSzLht8kr2XIBQqataOAJgfGA/vAhE5Udv0OO7qFxrXms3TjvCGC
	 e+gwTEqJz/Zu4MshdohDwmT6J6r4boQ5kqOu/0QmCP2fatM8s7sCk/rqe/3D6ogT70
	 UKrPC3mVoJq5Dz+I5uB6rRkREHLlyekWr8kclJIo=
Received: from smtp.vodafone.de (unknown [10.0.0.2])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits))
	(No client certificate requested)
	by mr4.vodafonemail.de (Postfix) with ESMTPS id 4WFP7G6cm4z1y8P
	for <linux-raid@vger.kernel.org>; Thu,  4 Jul 2024 17:40:26 +0000 (UTC)
Received: from lazy.lzy (p579d746a.dip0.t-ipconnect.de [87.157.116.106])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp.vodafone.de (Postfix) with ESMTPSA id 4WFP7B5FPMz9sG6
	for <linux-raid@vger.kernel.org>; Thu,  4 Jul 2024 17:40:19 +0000 (UTC)
Received: from lazy.lzy (localhost [127.0.0.1])
	by lazy.lzy (8.18.1/8.14.5) with ESMTPS id 464HeJt6003859
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO)
	for <linux-raid@vger.kernel.org>; Thu, 4 Jul 2024 19:40:19 +0200
Received: (from red@localhost)
	by lazy.lzy (8.18.1/8.17.2/Submit) id 464HeJVP003858
	for linux-raid@vger.kernel.org; Thu, 4 Jul 2024 19:40:19 +0200
Date: Thu, 4 Jul 2024 19:40:18 +0200
From: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>
To: linux-raid@vger.kernel.org
Subject: RAID-10N2 vs RAID-1 - Simple test
Message-ID: <ZobegsG8eh-_sDAA@lazy.lzy>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-purgate-type: clean
X-purgate: clean
X-purgate-size: 1676
X-purgate-ID: 155817::1720114822-C9FF9B9B-649A6509/0/0

Hi all,

finally I had some time to check the performances,
albeit in a very simple way, between a RAID-10 near 2
and a RAID-1.

The setup had 2 SATA SSD and 2 NVME SSD, delivering
two different storage configurations (2 SATA or 2 NVME).

The test was a simple sequential read from the raw
device (/dev/mdX), with read block size of 1MB.

The RAID-10N2 had chunk size of 512KB (default),
which happens to be exactly 1/2 of the read block
size (not by accident).
This means it would be optimal to read from two
devices, in case of RAID-10N2.

For the RAID-10N2 and the SATA SSDs, I got ~920MB/s
transfer rate, not so stable, but reproducible.
For tha RAID-1 and the SATA SSDs, I got ~480MB/s,
which is in line with the single SSD (raw) device
sequential read.

For the RAID-10N2 and the NVME SSDs, I got 3390MB/s,
extremely stable and reproducible.
For the RAID-1 and the NVME SSDs, I got 2490MB/s,
still extremely stable and reproducible.

In my view it is pretty clear that the RAID-10N2
reads interleaving the two devices (visible by
"iostat -m 5), and saturates whatever bottleneck
is there.
I can imagine that, with HDDs, this will bring
nothing, since the head of the HDD has anyway
to fly over the skipped blocks.
In SSDs, on the other hand, this is not an issue.

For the RAID-1, is also clear that one device is
involved in the transfer (not so visible with
"iostat -m 5).

Of course, as stated at the beginning, this is
a very very simple test, it does not take into
account anything else except raw sequential
read performances.
Nevertheless, this was my initial doubt.

Hope this helps,

bye

-- 

piergiorgio
