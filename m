Received: from ns13.servermx.com (ns13.servermx.com [135.125.234.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3919813C90B
	for <linux-raid@vger.kernel.org>; Thu, 13 Jun 2024 07:35:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=135.125.234.2
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718264116; cv=none; b=cZoJzr5z7J+FoDYJ/Kc29PnCzOfnN1pM4Ca8Pfpg8jvqUgrDPufHZGv5xQB3QUknJgo2L9gUwPIkoe+Gbj1OfpoU40guR6fycRZMdFfRewCFlN9iP9Aujbkxag8dRTdhV3K7aaq6KnrZdCEnzE/diRt8GfOJUnAm3ahnraiT3hc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718264116; c=relaxed/simple;
	bh=BsZNbCrrSeaGncR3p0DlqWipC3VE4KM4o+825LNzxp0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kqeU/LrsRoSzh3/YNaLjL/VIrAKNU7zNJOMcm7ybY/gwBwW0ovekJVol3Ea5DLul9y0TKbOgSWTJwjDsgvS84+9ztuwK+oiRSz4TGm6yyNKrs6t2iFs7iMAvUoEzf7NVAgkq7nNqOWskY0F0f5R12zty4XpslhItewLIW5sRufs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=robinhill.me.uk; spf=none smtp.mailfrom=robinhill.me.uk; dkim=pass (1024-bit key) header.d=servermx.com header.i=@servermx.com header.b=jdGhVMI/; dkim=pass (1024-bit key) header.d=servermx.com header.i=@servermx.com header.b=jdGhVMI/; arc=none smtp.client-ip=135.125.234.2
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=robinhill.me.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=robinhill.me.uk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=servermx.com header.i=@servermx.com header.b="jdGhVMI/";
	dkim=pass (1024-bit key) header.d=servermx.com header.i=@servermx.com header.b="jdGhVMI/"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=servermx.com; s=servermx; h=In-Reply-To:Content-Transfer-Encoding:
	Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
	Sender:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
	Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
	List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=YoWAfPAQppnowZa9J5tdlvKTlK9sfxwvUyo9NQhaP4g=; b=jdGhVMI/BfWozyRRY2/lRcNz7I
	gDMVcklksGhN8Mo7a+KO0MRaxe7E0uP6sAv9mIK6XgqQS61iKp7BCN0VJDsxbIOLFSTi2LfvROxkK
	gaY2OIrAB69AmteSPBmVwHVwboFCQldvZGuHM6B02zXl5/p15at3zQG0sE6BcSxTE8nQ=;
Received: by exim4;
	Thu, 13 Jun 2024 09:30:49 +0200
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=servermx.com; s=servermx; h=In-Reply-To:Content-Transfer-Encoding:
	Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
	Sender:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
	Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
	List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=YoWAfPAQppnowZa9J5tdlvKTlK9sfxwvUyo9NQhaP4g=; b=jdGhVMI/BfWozyRRY2/lRcNz7I
	gDMVcklksGhN8Mo7a+KO0MRaxe7E0uP6sAv9mIK6XgqQS61iKp7BCN0VJDsxbIOLFSTi2LfvROxkK
	gaY2OIrAB69AmteSPBmVwHVwboFCQldvZGuHM6B02zXl5/p15at3zQG0sE6BcSxTE8nQ=;
Received: by exim4;
	Thu, 13 Jun 2024 09:30:40 +0200
Received: from usr01 (usr01.home.robinhill.me.uk [IPv6:2001:470:1f1d:269::50])
	by cthulhu.home.robinhill.me.uk (Postfix) with SMTP id E48E76A0099;
	Thu, 13 Jun 2024 08:30:25 +0100 (BST)
Received: by usr01 (sSMTP sendmail emulation); Thu, 13 Jun 2024 08:30:25 +0100
Date: Thu, 13 Jun 2024 08:30:25 +0100
From: Robin Hill <robin@robinhill.me.uk>
To: Reindl Harald <h.reindl@thelounge.net>
Cc: Dragan =?utf-8?Q?Milivojevi=C4=87?= <galileo@pkm-inc.com>,
	Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>,
	linux-raid@vger.kernel.org
Subject: Re: RAID-10 near vs. RAID-1
Message-ID: <20240613073025.GA4133@usr01.home.robinhill.me.uk>
Mail-Followup-To: Reindl Harald <h.reindl@thelounge.net>,
	Dragan =?utf-8?Q?Milivojevi=C4=87?= <galileo@pkm-inc.com>,
	Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>,
	linux-raid@vger.kernel.org
References: <ZmiYHFiqK33Y-_91@lazy.lzy>
 <cd3ed227-1410-478b-b86b-973d76b587df@thelounge.net>
 <ZmnZYgerX5g8S9Cp@lazy.lzy>
 <8eea69b5-4abb-46b6-8c7b-05c7ea0bf591@thelounge.net>
 <CALtW_ai69FCuHCMRDMzTxiEb6Yg22yd9vr+2d5_Ya1GSPbacRA@mail.gmail.com>
 <393c09c3-605b-475a-a61c-8e0306c7e9e6@thelounge.net>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <393c09c3-605b-475a-a61c-8e0306c7e9e6@thelounge.net>
Feedback-ID:outgoingmessage:robin@robinhill.me.uk:ns12.servermx.com:servermx.com

On Thu Jun 13, 2024 at 07:38:34AM +0200, Reindl Harald wrote:

> 
> 
> Am 13.06.24 um 01:46 schrieb Dragan Milivojević:
> >> stripes are "half of the file on disk 1, the other half on disk 2"
> >> that's not possible with only 2 drives
> > 
> > https://en.wikipedia.org/wiki/Non-standard_RAID_levels#Linux_MD_RAID_10
> 
Far mode would give you striping, but not near mode.

> 
> "The two-drive example is equivalent to RAID 1"
> 
> what else - when you have only two drives
> dunno what magic you expect performance wise
> 
> the only advantage is that you later can add 2 drives and make a real 
> RAID10 out of it
> 

You'll have to rebuild though, as RAID10 does not support changing the
number of devices in an array.

Cheers,
    Robin
-- 
     ___        
    ( ' }     |       Robin Hill        <robin@robinhill.me.uk> |
   / / )      | Little Jim says ....                            |
  // !!       |      "He fallen in de water !!"                 |
