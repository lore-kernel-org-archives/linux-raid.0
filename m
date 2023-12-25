Received: from SMTP.sabi.co.uk (SMTP.sabi.co.UK [185.17.255.29])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFC8451007
	for <linux-raid@vger.kernel.org>; Mon, 25 Dec 2023 10:57:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mdraid.list.sabi.co.UK
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=root.for.sabi.co.uk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=root.for.sabi.co.uk header.i=@root.for.sabi.co.uk header.b="Bth1fno1"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=root.for.sabi.co.uk; s=dkim-00; h=From:Subject:To:Date:Message-ID:
	Content-Transfer-Encoding:Content-Type:MIME-Version;
	bh=w/uXvpWnfP1IqeI4V3QJfGHCsoRFP2uxty5b+CotNh4=; b=Bth1fno1ftdT/gvCu1TkzwuEnk
	4X2oKRwAJ/w9mLUvfgYOjQQnSZa+SlWvUPx15ZjXu2BUjASTX+/z3TAf7SBTKJYIA8mfsKbCy0eRz
	v3ps8xJGvB224fIKza+dtFKxjA35pp1nXWlDP5fTP1uyQf3/yl97mQCGolPjrlpAh9/AFxa08R3N8
	Ck0dVovIOVvSHXYPrpCOq+7WhGSrK7ijKAU4FzfciAGe8w7+Ra1XZTXjZoNkbbji4X3mZAqdDEy6g
	C1HOVil4RNe9kRjxTecP4iDDLO+dXJ4MLBqq5HglrwX3KkWbM8jZbhXLadiAUbH3Gle9ortRMn230
	jewUHdAg==;
Received: from [87.254.0.157] (helo=petal.ty.sabi.co.uk)
	by SMTP.sabi.co.uk with esmtpsa(Cipher TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)Exim 4.93
	id 1rHhzV-007GMr-H7by authid <sabity>with cram
	for <linux-raid@vger.kernel.org>; Mon, 25 Dec 2023 10:15:21 +0000
Received: from localhost ([127.0.0.1] helo=petal.ty.sabi.co.uk)
	by petal.ty.sabi.co.uk with esmtps(Cipher TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)Exim 4.93
	id 1rHhzQ-007130-Da
	for <linux-raid@vger.kernel.org>; Mon, 25 Dec 2023 10:15:16 +0000
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <25993.22068.153385.970347@petal.ty.sabi.co.uk>
Date: Mon, 25 Dec 2023 10:15:16 +0000
Precedence: air-mail
To: list Linux RAID <linux-raid@vger.kernel.org>
Subject: Re: parity raid and ext4 get stuck in writes
In-Reply-To: <ed52f171-646f-47ff-ad3b-be8bef48d813@gmail.com>
References: <ZYX2AS8isUHtbMXe@fisica.ufpr.br>
	<ed52f171-646f-47ff-ad3b-be8bef48d813@gmail.com>
X-Mailer: VM 8.2.0b under 26.3 (x86_64-pc-linux-gnu)
From: pg@mdraid.list.sabi.co.UK (Peter Grandi)
X-Disclaimer: This message contains only personal opinions

>> [...] a long standing problem. When lots of writes to many
>> files are sent in a short time the kernel gets stuck and
>> stops sending write requests to the disks. [...] A simple way
>> to reproduce: expand a kernel source tree, like xzcat
>> linux-6.5.tar.xz | tar x -f -

That is a well known (ideally...) consequence of misconfiguring
both physical storage and the Linux flusher cache so there is a
high chance of post-saturation congestion under load.

https://www.sabi.co.uk/blog/anno05-4th.html?051105#051105

> [...] I had two arrays with it, one on SSDs and one on HDDs.
> The HDD array exhibited the problem almost exclusively [...]

If an HDD set is misconfigured so that it reaches post
saturation congestion of IOPS much sooner than problems with
that and the consequences of flusher cache misconfiguration will
happen much more frequently. Usually to sustain the same number
of workload IOPS one needs at least 10 times more HDDs than
SSDs.
