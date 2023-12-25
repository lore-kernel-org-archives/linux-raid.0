Received: from hoggar.fisica.ufpr.br (hoggar.fisica.ufpr.br [200.238.171.242])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E424C51C5B
	for <linux-raid@vger.kernel.org>; Mon, 25 Dec 2023 13:38:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fisica.ufpr.br
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fisica.ufpr.br
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fisica.ufpr.br header.i=@fisica.ufpr.br header.b="Xe2ja9OW"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=fisica.ufpr.br;
	s=201705; t=1703511509;
	bh=ccaHbxwJC0Aor2jVm5uJ1R/jLKuMT/jlJMwbs4QERfc=;
	h=Date:From:To:Subject:References:In-Reply-To:From;
	b=Xe2ja9OWi8QIk47sohxNCSfD41JtGqQLt6PhMxN0fvpE04xYBRBzmnf70G53flxnl
	 aIpWF9EGR/ozhdA6vcBx7Q6EAxXFlySy7p1ANU1aswkvHEr1QmfwlSLJbVX8P/Vorn
	 i3RJOLNP7YZINyOsUuqEo9CE8st5S28kvL9CXghqCDFsRjd9qaGlC2q1Y32BTgjpol
	 wlRtmAcUE6Td+0mxE+WLdnp8w74v3wxvCCfCFus0t4eIUTer7kg3zdA10JcoJTi+wN
	 ivwK2gRriObDhEFHwhfouloOS997qvVSkntufhDk07BAxe7iFeTxfEEA6uLatHUEnE
	 2qtjIK7pISKOA==
Received: by hoggar.fisica.ufpr.br (Postfix, from userid 577)
	id 4ED5E9A0B4A41; Mon, 25 Dec 2023 10:38:29 -0300 (-03)
Date: Mon, 25 Dec 2023 10:38:29 -0300
From: Carlos Carvalho <carlos@fisica.ufpr.br>
To: list Linux RAID <linux-raid@vger.kernel.org>
Subject: Re: parity raid and ext4 get stuck in writes
Message-ID: <ZYmF1fnC2P7M7tUu@fisica.ufpr.br>
References: <ZYX2AS8isUHtbMXe@fisica.ufpr.br>
 <ed52f171-646f-47ff-ad3b-be8bef48d813@gmail.com>
 <25993.22068.153385.970347@petal.ty.sabi.co.uk>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <25993.22068.153385.970347@petal.ty.sabi.co.uk>

Peter Grandi (pg@mdraid.list.sabi.co.UK) wrote on Mon, Dec 25, 2023 at 07:15:16AM -03:
> >> [...] a long standing problem. When lots of writes to many
> >> files are sent in a short time the kernel gets stuck and
> >> stops sending write requests to the disks. [...] A simple way
> >> to reproduce: expand a kernel source tree, like xzcat
> >> linux-6.5.tar.xz | tar x -f -
> 
> That is a well known (ideally...) consequence of misconfiguring
> both physical storage and the Linux flusher cache so there is a
> high chance of post-saturation congestion under load.
> 
> https://www.sabi.co.uk/blog/anno05-4th.html?051105#051105

No.

It's not a configuration problem, it's a kernel bug. Of course we can reduce
the number and size of dirty pages, as I mentioned myself in the post, but the
bug continues to exist. I even did it to keep a critical server alive. It is a
nuisance though because bursts of disk writes take much longer to complete.

Even restraining dirty pages after about 7-10 days that critical machine still
gets stuck and needs a reboot... As time goes by the machine becomes more
susceptible to the bug. Maybe because of memory fragmentation? This is only a
"wild guess", I have no idea if it makes sense and agrees with Ojaswin's
findings.
