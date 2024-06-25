Received: from vps.thesusis.net (vps.thesusis.net [34.202.238.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96618132804
	for <linux-raid@vger.kernel.org>; Tue, 25 Jun 2024 19:00:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=34.202.238.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719342042; cv=none; b=P8dOfKbRpkP625DCdXgTXbw5HdkNiDJTAh1u0RilZqdiZzL712wWGKfBxg+H5aO7M9nQFlBAq09taLS+ha4B6W1YQwd/ICNdFK+yzmv73RByzabZ6QW7rNQzBDLKVGOeg9yJFqpm2vUWgXql4juhCkW9R7SLBtHm3Wds3CCuaGI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719342042; c=relaxed/simple;
	bh=n4JtvSqiQt0AHR2yMYUAewvDm9jELWTaiqvOoBG042c=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=Kk4mpKZFHsfRkYBF1jYBsY2GHt5zj5KFLJGiuxYBHzon4kbGvjofD2yIOZhI2ufqyRhWQQN/AydVJOhU7LyAp5DxiCwU8QpAh6wzFqiav75xp7lCzgOFfEKt/dvd9K+Jm3i8u56qG5WyIbLTumS6SzPZu4LOVVoucMg7YXMkoSE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=thesusis.net; spf=pass smtp.mailfrom=thesusis.net; arc=none smtp.client-ip=34.202.238.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=thesusis.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=thesusis.net
Received: by vps.thesusis.net (Postfix, from userid 1000)
	id B0AC43C447; Tue, 25 Jun 2024 15:00:39 -0400 (EDT)
From: Phillip Susi <phill@thesusis.net>
To: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>, Reindl Harald
 <h.reindl@thelounge.net>
Cc: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>,
 linux-raid@vger.kernel.org
Subject: Re: RAID-10 near vs. RAID-1
In-Reply-To: <ZmnZYgerX5g8S9Cp@lazy.lzy>
References: <ZmiYHFiqK33Y-_91@lazy.lzy>
 <cd3ed227-1410-478b-b86b-973d76b587df@thelounge.net>
 <ZmnZYgerX5g8S9Cp@lazy.lzy>
Date: Tue, 25 Jun 2024 15:00:39 -0400
Message-ID: <87ikxw6e5k.fsf@vps.thesusis.net>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Piergiorgio Sartor <piergiorgio.sartor@nexgo.de> writes:

> As far as I know, but please correct me if
> I'm wrong, a Linux md RAID-10 *near* layout,
> with 2 devices, has identical data distribution
> as a RAID-1 with 2 devices.
> Meaning the 2 devices are a mirror.

That's correct.

> The difference, if I understood it correctly,
> is that the RAID-10 has chunks, and hence stripes,
> while the RAID-1 does not have stripes.
> Furthermore, the read operation on RAID-10 are
> interleaved, delivering (for SSDs) double
> sequential read speed (for 2 devices), while
> the RAID-1 can handle two independent (one per
> device) read stream, each with single device
> reading speed.

No, since the layout is exactly the same as raid1, large sequential
reads can not be sent to both drives at the same time.

Now a two disk raid-10 in the offset or far layout however, does
interleave the data across the drives so they can both be read at the
same time to increase throughput.

