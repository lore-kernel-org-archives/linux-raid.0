From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re: mdadm striped parity RAID with Advanced Format drives
Date: Thu, 21 Jul 2011 12:27:27 +0200 (CEST)
Message-ID: <alpine.DEB.2.00.1107211226540.20159@uplift.swm.pp.se>
References: <201107211011.40151.polhallen@fuckaround.org> <4E27FECE.8010201@hardwarefreak.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4E27FECE.8010201@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: Stan Hoeppner <stan@hardwarefreak.com>
Cc: Pol Hallen <polhallen@fuckaround.org>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Thu, 21 Jul 2011, Stan Hoeppner wrote:

> 1. Can one create a RAID5 from bare (partition-less) AF drives and avoid 
> the read-modify-write problem?

Yes, that's what I always do.

> 2. Or is one required to assemble the array from properly aligned 
> partitions created on each drive?

No.

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
