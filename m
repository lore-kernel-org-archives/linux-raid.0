Received: from mr3.vodafonemail.de (mr3.vodafonemail.de [145.253.228.163])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13EE114A96
	for <linux-raid@vger.kernel.org>; Tue, 11 Jun 2024 18:40:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=145.253.228.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718131212; cv=none; b=AOKhGH0c3sy4vth7KHCDpPnppEQe5Chfj3tTGgYVrMLD9zj4M4B+LsXKRulvEkieijVFR+dNJoRmwQy4YQhxuaCg6tpRP4IsukYNkiwjlQLubZl8fOmI3eVTzxVQqrh7I/Q85neCZpDxMUBR76rW7bilhkR1kxSrZaxUfYF5dik=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718131212; c=relaxed/simple;
	bh=0InL5nF6lcC/3m/EgY5ywWW5v06Vn4+2JeCHscPOqrE=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=rLfXZ/Ao/+e+qp1TLAHs9cMjF4Bl6lPsHv0p9Sm2iGzVX8GUZhZFdugXod8nzfekLI6gQWd6B+0J927v7C4ZYXo+h99+sX6qB2MIfSSi0sb2D4J6NlJSV2o2nskfp9mc02XFEKNOAs63zrLBaxTZcXkF35q7vyqroCi0eLttd4c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nexgo.de; spf=pass smtp.mailfrom=nexgo.de; dkim=pass (1024-bit key) header.d=nexgo.de header.i=@nexgo.de header.b=shOsa5Ak; arc=none smtp.client-ip=145.253.228.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nexgo.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nexgo.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=nexgo.de header.i=@nexgo.de header.b="shOsa5Ak"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nexgo.de;
	s=vfde-mb-mr2-23sep; t=1718130724;
	bh=fgij0EAN+tpFTRRFMY8MT8v19A8/l4nx5IDpGBM/4ns=;
	h=Date:From:To:Subject:Message-ID:Content-Type:From;
	b=shOsa5AkH2VN49F2hLZl4wp/ae5Ni21iWeii57uaKvXOQcINkbSgjgpTSGiTWrmiX
	 kqg6UbatwbK53RkAMrcpfcDLiSnvt3oVuxbtl1jlb853opOLvCgkBBxh+p73Jzvh/U
	 /wUsapWst/uVglGmPfpPHTrllaGHsHqnBwdY0QCI=
Received: from smtp.vodafone.de (unknown [10.0.0.2])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits))
	(No client certificate requested)
	by mr3.vodafonemail.de (Postfix) with ESMTPS id 4VzHMS51VGz1xwh
	for <linux-raid@vger.kernel.org>; Tue, 11 Jun 2024 18:32:04 +0000 (UTC)
Received: from lazy.lzy (p579d746a.dip0.t-ipconnect.de [87.157.116.106])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp.vodafone.de (Postfix) with ESMTPSA id 4VzHMN3p2wzHnHj
	for <linux-raid@vger.kernel.org>; Tue, 11 Jun 2024 18:31:57 +0000 (UTC)
Received: from lazy.lzy (localhost [127.0.0.1])
	by lazy.lzy (8.18.1/8.14.5) with ESMTPS id 45BIVuKm009807
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO)
	for <linux-raid@vger.kernel.org>; Tue, 11 Jun 2024 20:31:56 +0200
Received: (from red@localhost)
	by lazy.lzy (8.18.1/8.17.2/Submit) id 45BIVuNp009806
	for linux-raid@vger.kernel.org; Tue, 11 Jun 2024 20:31:56 +0200
Date: Tue, 11 Jun 2024 20:31:56 +0200
From: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>
To: linux-raid@vger.kernel.org
Subject: RAID-10 near vs. RAID-1
Message-ID: <ZmiYHFiqK33Y-_91@lazy.lzy>
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
X-purgate-size: 550
X-purgate-ID: 155817::1718130720-956C3A77-FF25BB13/0/0

Hi all,

I'm setting up a system with 2 SSD M.2 (NVME).

I was wondering if would it be better, performace
wise, to have a RAID-10 near layout or a RAID-1.

Looking around I found only one benchmark:

https://strugglers.net/~andy/blog/2019/06/02/exploring-different-linux-raid-10-layouts-with-unbalanced-devices/

Which uses mixed SSD, NVME and SATA.

Does anybody have any suggestions, links, or
ideas on the topic?

BTW, practically speaking, what's the difference,
between the two RAIDs?

Thanks!

bye,

-- 

piergiorgio
