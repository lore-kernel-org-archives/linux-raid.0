From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re: mdadm striped parity RAID with Advanced Format drives
Date: Thu, 21 Jul 2011 13:23:21 +0200 (CEST)
Message-ID: <alpine.DEB.2.00.1107211322160.20159@uplift.swm.pp.se>
References: <201107211011.40151.polhallen@fuckaround.org> <4E27FECE.8010201@hardwarefreak.com> <alpine.DEB.2.00.1107211226540.20159@uplift.swm.pp.se> <4E280AEF.4020801@hardwarefreak.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4E280AEF.4020801@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: Stan Hoeppner <stan@hardwarefreak.com>
Cc: Pol Hallen <polhallen@fuckaround.org>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Thu, 21 Jul 2011, Stan Hoeppner wrote:

> Ok. Pol, keep in mind that all drives must be identical size when 
> creating an array on raw disks.  You said you're now working with 6 
> identical WD drives so this shouldn't be an issue.

They don't have to be identical size. It'll use the smallest component 
size and use that much data on all drives.

I recommend to use superblock v1.2, which is default in later versions of 
mdadm.

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
