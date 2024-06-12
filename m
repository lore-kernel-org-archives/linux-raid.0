Received: from mr4.vodafonemail.de (mr4.vodafonemail.de [145.253.228.164])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC35329CE5
	for <linux-raid@vger.kernel.org>; Wed, 12 Jun 2024 17:30:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=145.253.228.164
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718213411; cv=none; b=CvN5xj5ihHUQ8Kchm+AYVVCW7mkrKVTbZ+6q22et9vRSZG54ZRq2HHOT7IEiVkEHw2sWrfIqoEqWM5Bg9qc4DaoXMu++/l6LQvy9ldEiZJ1oRtYwtCWq0Ye/kN8dTtsxO2dihsKKSRiaK+KFXMjOz4xZC2GLpPUv+lCaTSHIF1s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718213411; c=relaxed/simple;
	bh=xMc2i+UsiHIE4fABWDUQbTIkaMBIsbSVtsDUcEsuUFs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LDoYNqC4pi3Y6EH1/U8RUXfYcc9N+p38ELjEPugFC3L1sqVDrCKEPyuClIZ/aQsDVUpG0CE1462u75PA3Zfs7QDNq3Le8M3x7coykzs24WrsWMcPvLXYUxBaAzfw9VlDWsdqu2eHh/3exSRSBpF9VkJLaA6C50X8vgeyrx6yrnQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nexgo.de; spf=pass smtp.mailfrom=nexgo.de; dkim=pass (1024-bit key) header.d=nexgo.de header.i=@nexgo.de header.b=PMlkbcB+; arc=none smtp.client-ip=145.253.228.164
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nexgo.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nexgo.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=nexgo.de header.i=@nexgo.de header.b="PMlkbcB+"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nexgo.de;
	s=vfde-mb-mr2-23sep; t=1718212976;
	bh=b3sQkTXGjigQQ+octqlbSxeWcI8yoA/DhT9YKY01Wrw=;
	h=Date:From:To:Subject:Message-ID:References:Content-Type:
	 In-Reply-To:From;
	b=PMlkbcB+mRXTAHmnCPmG/CaIxM5bwgNenwkMJn3sNkkgZGRDNwvg7VAoqpAFedZ/A
	 5HeRDCPvAURq6ZsGdXxKQw7HIn6N6YGsSE0csMsKVOXC3tbRxwWskd0H78j2f6fTGu
	 3k1U5imODEBlTJ87Sfj18IgWBVrDxRyMlphKlJwA=
Received: from smtp.vodafone.de (unknown [10.0.0.2])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits))
	(No client certificate requested)
	by mr4.vodafonemail.de (Postfix) with ESMTPS id 4VzsnD3Dqgz1yGd;
	Wed, 12 Jun 2024 17:22:56 +0000 (UTC)
Received: from lazy.lzy (p579d746a.dip0.t-ipconnect.de [87.157.116.106])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp.vodafone.de (Postfix) with ESMTPSA id 4Vzsn21ssRzHngB;
	Wed, 12 Jun 2024 17:22:43 +0000 (UTC)
Received: from lazy.lzy (localhost [127.0.0.1])
	by lazy.lzy (8.18.1/8.14.5) with ESMTPS id 45CHMgIN005337
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
	Wed, 12 Jun 2024 19:22:42 +0200
Received: (from red@localhost)
	by lazy.lzy (8.18.1/8.17.2/Submit) id 45CHMgjc005336;
	Wed, 12 Jun 2024 19:22:42 +0200
Date: Wed, 12 Jun 2024 19:22:42 +0200
From: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>
To: Reindl Harald <h.reindl@thelounge.net>
Cc: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>,
        linux-raid@vger.kernel.org
Subject: Re: RAID-10 near vs. RAID-1
Message-ID: <ZmnZYgerX5g8S9Cp@lazy.lzy>
References: <ZmiYHFiqK33Y-_91@lazy.lzy>
 <cd3ed227-1410-478b-b86b-973d76b587df@thelounge.net>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cd3ed227-1410-478b-b86b-973d76b587df@thelounge.net>
X-purgate-type: clean
X-purgate: clean
X-purgate-size: 1852
X-purgate-ID: 155817::1718212972-627B2BC3-64C003DA/0/0

On Wed, Jun 12, 2024 at 01:04:18AM +0200, Reindl Harald wrote:
> 
> 
> Am 11.06.24 um 20:31 schrieb Piergiorgio Sartor:
> > I'm setting up a system with 2 SSD M.2 (NVME).
> > 
> > I was wondering if would it be better, performace
> > wise, to have a RAID-10 near layout or a RAID-1.
> > 
> > Looking around I found only one benchmark:
> > 
> > https://strugglers.net/~andy/blog/2019/06/02/exploring-different-linux-raid-10-layouts-with-unbalanced-devices/
> > 
> > Which uses mixed SSD, NVME and SATA.
> > 
> > Does anybody have any suggestions, links, or
> > ideas on the topic?
> > 
> > BTW, practically speaking, what's the difference,
> > between the two RAIDs?
> 
> i wouldn't even consider a RAID10 with two disks, especially with SSD and
> practically you end with a unsupported RAID1 because there are no stripes
> with 2 disks
> 

Hi, thanks for the answer.

I'm a bit confused here. What do you mean
with "unsupported RAID1"?

As far as I know, but please correct me if
I'm wrong, a Linux md RAID-10 *near* layout,
with 2 devices, has identical data distribution
as a RAID-1 with 2 devices.
Meaning the 2 devices are a mirror.

The difference, if I understood it correctly,
is that the RAID-10 has chunks, and hence stripes,
while the RAID-1 does not have stripes.
Furthermore, the read operation on RAID-10 are
interleaved, delivering (for SSDs) double
sequential read speed (for 2 devices), while
the RAID-1 can handle two independent (one per
device) read stream, each with single device
reading speed.

Of course, depending on the requirements,
assuming what I wrote is correct, performances
might be different.

I was just wondering if anybody has some hints,
some experience, some references, or, as you
suggested, not to care at all.

Thanks again,

bye,

-- 

piergiorgio
