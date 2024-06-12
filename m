Received: from mr3.vodafonemail.de (mr3.vodafonemail.de [145.253.228.163])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CCC61822CB
	for <linux-raid@vger.kernel.org>; Wed, 12 Jun 2024 17:25:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=145.253.228.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718213147; cv=none; b=Trr4bT/UikUhNPvHa5YDud2jbRnOilWRPLVHN17fA1jpakSL7zByqr6eX9W/bY/YUPwmmyA7QcsUip5MGzkLCCWEuTTK7ydflpogV+b3MujAxAWlETUtG0INy9BxP5v4gEHA878uGL6Y60g/RtZ109r1kv99R5KbUYyoxPgKQjI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718213147; c=relaxed/simple;
	bh=DbJ5RfhaUXcy/D8y7fI32SmVxokGxUrzzGh0ZUknqsQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=k0RSpid6c5X6wRvGQqZVrZDTv1w9RO2zwHDSTwDJ/9g0M/CY08iKkF6DiMWYNiWhN4yEaJ6j21ACCwDJ1Z4lXjFZVyPWKHsYjrDQyhV2nbiwwdqNsBg57t71VCToUt53t4GFkFAfbIPAf9GzT0n3dEmgpXaIGXEdQrYaQWveAG8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nexgo.de; spf=pass smtp.mailfrom=nexgo.de; dkim=pass (1024-bit key) header.d=nexgo.de header.i=@nexgo.de header.b=Nlu/VPYZ; arc=none smtp.client-ip=145.253.228.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nexgo.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nexgo.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=nexgo.de header.i=@nexgo.de header.b="Nlu/VPYZ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nexgo.de;
	s=vfde-mb-mr2-23sep; t=1718213140;
	bh=8NtTW8vVZUWBJuTTl3M6x2VlPcflAivSzUYu8/fNBfc=;
	h=Date:From:To:Subject:Message-ID:References:Content-Type:
	 In-Reply-To:From;
	b=Nlu/VPYZjSK1yQSlVpMjrb/6kLRSexvnEmkal3GhqNe4U6MNnh5pHDi7ZPbqqq0Ay
	 9HBla+Sr6eawg1BiPaLRcmJxSpbE2TWuJ9f3ih5TlfGJbIXbEL04H+pZum2UzkQXHj
	 LTkI9/MBSPWnRgru0Vb79+sPSaV+nG4xLJ6RUq2U=
Received: from smtp.vodafone.de (unknown [10.0.0.2])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits))
	(No client certificate requested)
	by mr3.vodafonemail.de (Postfix) with ESMTPS id 4VzsrN4T9Rz1yXC;
	Wed, 12 Jun 2024 17:25:40 +0000 (UTC)
Received: from lazy.lzy (p579d746a.dip0.t-ipconnect.de [87.157.116.106])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp.vodafone.de (Postfix) with ESMTPSA id 4Vzsr674CFz9sRC;
	Wed, 12 Jun 2024 17:25:23 +0000 (UTC)
Received: from lazy.lzy (localhost [127.0.0.1])
	by lazy.lzy (8.18.1/8.14.5) with ESMTPS id 45CHPMIr005360
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
	Wed, 12 Jun 2024 19:25:23 +0200
Received: (from red@localhost)
	by lazy.lzy (8.18.1/8.17.2/Submit) id 45CHPMYx005359;
	Wed, 12 Jun 2024 19:25:22 +0200
Date: Wed, 12 Jun 2024 19:25:22 +0200
From: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>
To: Paul E Luse <paul.e.luse@linux.intel.com>
Cc: Reindl Harald <h.reindl@thelounge.net>,
        Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>,
        linux-raid@vger.kernel.org
Subject: Re: RAID-10 near vs. RAID-1
Message-ID: <ZmnaAjLWxVnAHLXR@lazy.lzy>
References: <ZmiYHFiqK33Y-_91@lazy.lzy>
 <cd3ed227-1410-478b-b86b-973d76b587df@thelounge.net>
 <20240611171433.375d6e25@peluse-desk5>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240611171433.375d6e25@peluse-desk5>
X-purgate-type: clean
X-purgate: clean
X-purgate-size: 1759
X-purgate-ID: 155817::1718213136-027FAA47-B159E847/0/0

On Tue, Jun 11, 2024 at 05:14:33PM -0700, Paul E Luse wrote:
> On Wed, 12 Jun 2024 01:04:18 +0200
> Reindl Harald <h.reindl@thelounge.net> wrote:
> 
> > 
> > 
> > Am 11.06.24 um 20:31 schrieb Piergiorgio Sartor:
> > > I'm setting up a system with 2 SSD M.2 (NVME).
> > > 
> > > I was wondering if would it be better, performace
> > > wise, to have a RAID-10 near layout or a RAID-1.
> > > 
> > > Looking around I found only one benchmark:
> > > 
> > > https://strugglers.net/~andy/blog/2019/06/02/exploring-different-linux-raid-10-layouts-with-unbalanced-devices/
> > > 
> > > Which uses mixed SSD, NVME and SATA.
> > > 
> > > Does anybody have any suggestions, links, or
> > > ideas on the topic?
> > > 
> > > BTW, practically speaking, what's the difference,
> > > between the two RAIDs?
> > 
> > i wouldn't even consider a RAID10 with two disks, especially with SSD 
> > and practically you end with a unsupported RAID1 because there are no 
> > stripes with 2 disks
> > 
> > 
> I don't disagree but I would recommend you try each variation and
> measure the performance for yourself.  It's a great learning experience
> if you haven't done it before and there's nothing like trusting your
> own data over on your own system/config something that someone else has
> done when there are so many factors that can affect performance.
> 
> -Paul
> 

Hi, thanks to you as well.

About benchmarking, you're absolutely right, I did
in the past for other RAIDs (-5, -6 and -10).

I was just hoping to skip it, this time... :-)

I do not have really a performance problem to solve.
I'm just curious, given that the two RAIDs seem
identical, if someone already tested the two.

Thanks,

bye,

-- 

piergiorgio
