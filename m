Received: from vps.thesusis.net (vps.thesusis.net [34.202.238.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99150176FA1
	for <linux-raid@vger.kernel.org>; Tue, 28 May 2024 19:04:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=34.202.238.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716923073; cv=none; b=OjtUtOxhUQLDsMndQTcnpC/rdg8NswcoE5My6eGoa5Uqud/4VatP1J3enSP5FofA4CZPlJUznE1RQZUS+VHpKAbeI8XpNxn4bX49udSUOuzTsWMUOVQSeoOb/Tb/iARkIJY/J+xQuT9sUWL9icvG+kJOCG/jCJnXgxpMIh3hCLI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716923073; c=relaxed/simple;
	bh=fQpC6vbL+7hHiqJoGTJPokxnf9/ay2CbNn3PwsQCwCw=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=brCf0BoJ+Cb/lzyK95N9Q6OIVPKZ9m7B+op6qIF3r8D9nKQfdBot+NDSZlavl9vKQZiR8rB2iaWPHayE11GgHT3FMHLmjpu6iMmlp3kxOFZdWUIkAHZeykqhPw6il1V4fz9tWwFkd3DAXMpcqcrZvl/yzHnCNYszcLmM9agGKyk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=thesusis.net; spf=pass smtp.mailfrom=thesusis.net; arc=none smtp.client-ip=34.202.238.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=thesusis.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=thesusis.net
Received: by vps.thesusis.net (Postfix, from userid 1000)
	id 2149237C06; Tue, 28 May 2024 15:04:24 -0400 (EDT)
From: Phillip Susi <phill@thesusis.net>
To: Roger Heflin <rogerheflin@gmail.com>, Richard <richard@radoeka.nl>
Cc: linux-raid@vger.kernel.org
Subject: Re: RAID-1 not accessible after disk replacement
In-Reply-To: <CAAMCDeewS11GguARHTvUB9455vJHARRRP=+0wrZLXWjWb-i=6g@mail.gmail.com>
References: <1910147.LkxdtWsSYb@selene> <87y180qyyk.fsf@vps.thesusis.net>
 <4705980.vXUDI8C0e8@selene> <26411775.1r3eYUQgxm@selene>
 <CAAMCDeewS11GguARHTvUB9455vJHARRRP=+0wrZLXWjWb-i=6g@mail.gmail.com>
Date: Tue, 28 May 2024 15:04:24 -0400
Message-ID: <87sey1oj0n.fsf@vps.thesusis.net>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Roger Heflin <rogerheflin@gmail.com> writes:

> Going bigger works once you resize the fs (that requires a separate
> command specific to your fs).
>
> Going smaller typically requires the FS to be umounted, maybe fscked,
> and resized smaller (assuming the FS even supports that, xfs does not)
> before the array is made smaller.  Resizing the array or LV smaller
> before and/or without the fs being resized only ends when the resize
> smaller is undone (like you did).  When going smaller I also tend to
> make the fs a decent amount smaller than I need to, then make the
> array smaller and then resize the fs up using no options (so it uses
> the current larger device  size).

Just going to mention that btrfs can be shrunk while it is mounted.
It's a pretty neat thing to see gparted shrink the partition of a
mounted btrfs volume.
