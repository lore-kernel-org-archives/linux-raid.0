Received: from mr5.vodafonemail.de (mr5.vodafonemail.de [145.253.228.165])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7889C2BE7BE
	for <linux-raid@vger.kernel.org>; Sun, 24 May 2026 10:35:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=145.253.228.165
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779618911; cv=none; b=NQNg+rVBEeoz9Oy2Pq5emCa/XvGzai8WroI8M/vtZDKcdWlDaECrRbC/6z2E2nVq+Tt00YY42pspd7UMnVqNUARfkhXCqHKH8lYG0myafOPk05YarHNLm7JoEMVyZGjT2IVrPZhARq+yRpeQ8ttMl8noauqNfHN/ucwpQ+9W+Fg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779618911; c=relaxed/simple;
	bh=XTsdlfnOu0UOWMm83mO1JZsns0lbb4TEMld9nAhhe1c=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=ZYQJ0D+hfasLkRKfa9KOvntdT2dmpivd8JABnBb5R6+QufRDrB+YBqG7VmNzkXU/d11R5BK9TO4k3o7zmt3udY0MWS/l+D4Syxf7mPB1I0GGbBUUNipSVGaZsmGnvsBtbAOejJLZlcEO23ePK0j4KNBKU81CCYj0oUhwmpXfy5s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nexgo.de; spf=pass smtp.mailfrom=nexgo.de; dkim=pass (1024-bit key) header.d=nexgo.de header.i=@nexgo.de header.b=L+JMdZSH; arc=none smtp.client-ip=145.253.228.165
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nexgo.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nexgo.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=nexgo.de header.i=@nexgo.de header.b="L+JMdZSH"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nexgo.de;
	s=vfde-mb-mr2-23sep; t=1779618451;
	bh=19aAJ3ej2Wa8Rd/4Vm+Mu/DaHHVHBvGWC6AgiQu+x9o=;
	h=Date:From:To:Subject:Message-ID:Content-Type:From;
	b=L+JMdZSHmrD+ie+DHUutgoaFRhAzF/meol887JzwYFefXhReuDZFkaBcMcyCvlazU
	 +cL2F/Ioxp+Xa4hjfDmHGqQvn6IITCNwjDGx/3Y3Wk5cA2t8O+F+xBi3qWbZ4rKNpk
	 BUVLeS1fEQRCSHhyGvS2D6ZSxZ79q8AGKWPj+lOU=
Received: from smtp.vodafone.de (unknown [10.0.0.2])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits))
	(No client certificate requested)
	by mr5.vodafonemail.de (Postfix) with ESMTPS id 4gNZvl59y7z3sVG9
	for <linux-raid@vger.kernel.org>; Sun, 24 May 2026 10:27:31 +0000 (UTC)
Received: from lazy.lzy (p579d7386.dip0.t-ipconnect.de [87.157.115.134])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp.vodafone.de (Postfix) with ESMTPSA id 4gNZvl38pwz9047
	for <linux-raid@vger.kernel.org>; Sun, 24 May 2026 10:27:28 +0000 (UTC)
Received: from lazy.lzy (localhost [127.0.0.1])
	by lazy.lzy (8.18.2/8.14.5) with ESMTP id 64OARR4b007849
	for <linux-raid@vger.kernel.org>; Sun, 24 May 2026 12:27:27 +0200
Received: (from red@localhost)
	by lazy.lzy (8.18.2/8.18.1/Submit) id 64OARR8w007848
	for linux-raid@vger.kernel.org; Sun, 24 May 2026 12:27:27 +0200
Date: Sun, 24 May 2026 12:27:27 +0200
From: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>
To: linux-raid@vger.kernel.org
Subject: LBS setup
Message-ID: <ahLSj1Ua5WJ0GTgY@lazy.lzy>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-purgate-server: smtpa03
X-purgate-type: clean
X-purgate: clean
X-purgate-size: 963
X-purgate-ID: 155817::1779618451-5B44D64C-C116A9E1/0/0

Hi all,

I've some questions about some recent
report from kernel.
I assume from 7.x.y, from what I understood.
Not sure about the <= 6.18 reported.

In the boot log there is:

md0: echo current LBS to md/logical_block_size to prevent data loss issues from LBS changes.
      Note: After setting, array will not be assembled in old kernels (<= 6.18)

I found the docs stating:

logical_block_size
	... Write the value before starting array. ...

Now, should we really copy the value from:

/sys/class/block/md0/queue/logical_block_size

to:

/sys/class/block/md0/md/logical_block_size

???

Note, the first in my system is 512, the
second is 0.

Second, the docs says "before starting array".
In case this is due (copy the value), how to do
for a system array?
I mean, the array where the whole OS lies.

If needed, is there any way to do this automatically?
Using mdadm or something?

Thanks,

bye,

-- 

piergiorgio
