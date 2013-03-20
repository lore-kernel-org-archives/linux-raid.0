From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re: Western Digital Green 3TB SATA3 experiences
Date: Wed, 20 Mar 2013 09:28:07 +0100 (CET)
Message-ID: <alpine.DEB.2.00.1303200926110.2309@uplift.swm.pp.se>
References: <1363766982.51496ec6ea41f@mail.inbox.lv>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1363766982.51496ec6ea41f@mail.inbox.lv>
Sender: linux-raid-owner@vger.kernel.org
To: Andris Berzins <pkix@inbox.lv>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, 20 Mar 2013, Andris Berzins wrote:

> I am running RAID5 array on 6x 3TB WD SATA disks.
> I have problems with all of these disks (including replaced one).
> Disks are being randomly kicked out from array and SMART shows
> pending sectors which usually can be fixed by read-write or write to that sector.

Drives with pending sectors should be RMAed.

> Has anyone experienced something similar with WD green series?
> Is this because of WD "green" series?
>
> Anyone running raid on 3TB SATA drives can suggest model disk that
> runs without problems?

WD RED series is designed for this kind of usage and should not be kicked 
out because the drive will return UNC in a timely fashion.

<http://en.wikipedia.org/wiki/Error_recovery_control>. The WD Green series 
is not designed for RAID usage and might get kicked out due to read 
timeouts.

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
