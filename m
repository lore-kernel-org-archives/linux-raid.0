From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re: Recommendations needed for RAID5 recovery
Date: Mon, 27 Jun 2016 12:05:07 +0200 (CEST)
Message-ID: <alpine.DEB.2.02.1606271203090.28955@uplift.swm.pp.se>
References: <B1389BE8-B7B5-4AB4-BE12-1636D4B91BB5@seas.upenn.edu> <CAOS+5GGxVOWw1nEfEgpVcLY0+tHPVV3d48BzyRATjpApgvSkxg@mail.gmail.com> <22381.43040.31844.544728@quad.stoffel.home> <576E6E68.9070209@youngman.org.uk> <576EB5FD.1000309@turmel.org>
 <5770452F.8000109@youngman.org.uk> <5770549C.4060301@turmel.org> <20160627090645.GA3255@metamorpher.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20160627090645.GA3255@metamorpher.de>
Sender: linux-raid-owner@vger.kernel.org
To: Andreas Klauer <Andreas.Klauer@metamorpher.de>
Cc: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Mon, 27 Jun 2016, Andreas Klauer wrote:

> So you shouldn't use dd on bad disks...

There is no downside to using ddrescue that I can see. If everything works 
ok, then you get a 0 error copy, and you got the exact same result as with 
dd.

If you did have errors, then ddrescue will try to do the best of the 
situation and try to copy as much as possible from the drive You also get 
a list of the errored sectors that you can use for future reference.

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
