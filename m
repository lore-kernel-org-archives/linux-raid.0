From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re: Raid5 reshape stuck at 0% - SuSE leap 42.1
Date: Sun, 7 Aug 2016 20:05:35 +0200 (CEST)
Message-ID: <alpine.DEB.2.02.1608072002400.3593@uplift.swm.pp.se>
References: <57A69012.1010406@youngman.org.uk> <alpine.DEB.2.02.1608071154110.3593@uplift.swm.pp.se> <57A719CC.6080301@youngman.org.uk> <57A724ED.5070808@youngman.org.uk> <alpine.DEB.2.02.1608071630050.3593@uplift.swm.pp.se> <57A766DC.4000207@youngman.org.uk>
 <alpine.DEB.2.02.1608071923410.3593@uplift.swm.pp.se> <57A776AE.3050308@youngman.org.uk>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <57A776AE.3050308@youngman.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Wols Lists <antlists@youngman.org.uk>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Sun, 7 Aug 2016, Wols Lists wrote:

> I'm guessing it should be "mdadm --grow --raid-devices=3
> --backup-file=whatever", but I think I've already tried that, and that's
> what got me into this mess :-)

Try without backup file (it shouldn't be needed when growing under these 
circumstances). If it doesn't start rebuilding after issuing --grow, try 
--continue when the array is actually up and running (don't stop it when 
it's "frozen" and says rebuilding but doesn't actually show any rebuilding 
going on). That has worked for others.

Use latest git version of mdadm.

Please post output from all commands and dmesg if it still fails.

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
