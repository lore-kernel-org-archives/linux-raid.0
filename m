Received: from dione.uberspace.de (dione.uberspace.de [185.26.156.222])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 249803D3BE
	for <linux-raid@vger.kernel.org>; Mon,  4 Mar 2024 13:19:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.26.156.222
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709558377; cv=none; b=VO14GR8l7PSBMssrwuUdResbizc+UqvgAerRGySmKJFoQ1Yg309u/ewAcIejWiaPDwYMQ/eP/Bb5Qm4FToCNlrn9Goi3Xjz/ZFwXx6FazcgpDPOv/bya9fy+Ivv7ciuCCscq1KYbSzy7Arh7Lwqlwwg2sJBokaF7LfAKV6ja33I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709558377; c=relaxed/simple;
	bh=9hFB4RtiLRaF6sH76RSMsr+INiFK56DEUvqmtKR3JkU=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=NMOUWZhEa2hKOzvAMA9lFGvKwaqLBOTyVLvEi9Sk4rNNwIMzhDCoKfTnkibQnEWJjXgf9XfpLVZ8tZUg/Xx5G8yr7F8Wd9WW28iZv3k9z8nL5BEBVbUOn7d1DREMYxPnfEDvB7wvEVzodSSIteWmBJpj/ngV3qmEYfkIrQ0bgRE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=metamorpher.de; spf=pass smtp.mailfrom=metamorpher.de; dkim=pass (4096-bit key) header.d=metamorpher.de header.i=@metamorpher.de header.b=kNWvtiA+; arc=none smtp.client-ip=185.26.156.222
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=metamorpher.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=metamorpher.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=metamorpher.de header.i=@metamorpher.de header.b="kNWvtiA+"
Received: (qmail 2084 invoked by uid 989); 4 Mar 2024 13:19:29 -0000
Authentication-Results: dione.uberspace.de;
	auth=pass (plain)
Received: from unknown (HELO unkown) (::1)
	by dione.uberspace.de (Haraka/3.0.1) with ESMTPSA; Mon, 04 Mar 2024 14:19:29 +0100
Date: Mon, 4 Mar 2024 14:19:29 +0100
From: Andreas Klauer <Andreas.Klauer@metamorpher.de>
To: linux-raid@vger.kernel.org
Cc: Andreas Klauer <Andreas.Klauer@metamorpher.de>
Subject: mdadm 4.3 rejects /dev/md128 and larger numbers
Message-ID: <ZeXKYbxagk7SD0UH@metamorpher.de>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Bar: /
X-Rspamd-Report: BAYES_HAM(-0.022393) MIME_GOOD(-0.1)
X-Rspamd-Score: -0.122393
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
	d=metamorpher.de; s=uberspace;
	h=from:to:cc:subject:date;
	bh=9hFB4RtiLRaF6sH76RSMsr+INiFK56DEUvqmtKR3JkU=;
	b=kNWvtiA+tyQEnLxMWutIx8w6tYSQuAvtJIUxnXD1N2ba8SPKSwPcS58wHiithwc0wZWcIH8qmV
	LnqKNY37wY6auPSVxqppnX+QYQZyJfg94phLiO6niD6+7IT/xPqKAyAEllQwWHoYSVChpavRgdcl
	Jd8afYn/VvUrcUGE9m/txChGGikfaNH+UIGVIjenDKKXm/D0ZwZeyXC8BF3YcT34F6ReHdiNUh48
	MmhEcthlRLEvevSpbQp4IUZnuMs798zuuSCn6S5sR+VtLzBm72fzcWI8iMwXtV0EDM9bOI6YDoxK
	PHJw9CjhhonfcU7FV18xEZcpQSLDVF5YFZCQ2ZWBixCWXOmY+EpO+YaWXgDAnKIqmmGboWHXmEbg
	xlLdRfOyqJWpfyPaEVk4qecXugo+pWHVILkj/veMDVowCabnfos9Yu8gjNU413MmW1jKMyJ8tYOq
	LxyWR9CCGFkz8UPFAwbwMyIsSG1a9mb/7GMm85LGQKhvsrK7sNoePdawi9YOXNAF0O0S78Kcjn4S
	vBA56JFjXhZiyTN4V0z7zXz1qp1QLsvFY8Rpa5g6AdyrURaKmbLQhQi6f5c08W8TPiboTDUsHNlE
	nEWxIvSgmID/06oOxTvpGQcP+TGiYhKnTyNF232Yn9pI5BF11qYw6GGPmpUUP3cbopwLylQ7KnKh
	0=

Hello,

since mdadm 4.3, trying to use numbers larger than 127 results in:

  mdadm: Value "/dev/md3032" cannot be set as devname. 
  Reason: Not POSIX compatible. Value ignored.

Because in util.c :: is_devname_numbered() (commit 25aa73291):

  if (val > 127)
    return false;

The kernel seems to be fine with MINORMASK (2^20 - 1).
If so, instead of 127, the limit here should be 1048575?

I don't need a million arrays. But I do have more arrays than 
average because I use partitions instead of one big array 
for everything. And some flexibility in using distinct number 
ranges per group of arrays makes /proc/mdstat easier to read.

Regards,
Andreas Klauer
