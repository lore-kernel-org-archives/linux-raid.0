From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re: Suggestion needed for fixing RAID6
Date: Thu, 22 Apr 2010 17:18:50 +0200 (CEST)
Message-ID: <alpine.DEB.1.10.1004221713420.6768@uplift.swm.pp.se>
References: <626601cae203$dae35030$0400a8c0@dcccs> <alpine.DEB.1.10.1004221658040.6768@uplift.swm.pp.se> <64bd01cae22e$456461e0$0400a8c0@dcccs>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <64bd01cae22e$456461e0$0400a8c0@dcccs>
Sender: linux-raid-owner@vger.kernel.org
To: Janos Haar <janos.haar@netcenter.hu>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, 22 Apr 2010, Janos Haar wrote:

> I am just tested one of the badblock-hdds, and the bad blocks comes 
> periodicaly, like a little and short scratch, and the drive can't correct 
> these by write.

Oh, if you get write errors on the drive then you're in bigger trouble.

> Maybe this is why the kernel kicsk it out...

Yes, a write error to the drive is a kick:able offence. What does smartctl 
say about the drives?

> But anyway, the problem is still here, i want to rebuild the missing disk 
> (prior to replace the badblocked drives one by one), but the kernel kicks out 
> more 2 drive during the rebuild.

I don't have a good idea that assures your data, unfortunately. One way 
would be to dd the defective drives to working ones, but that will most 
likely cause you to have data loss on the defective sectors (since md has 
no idea that these sectors should be re-created from parity).

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
