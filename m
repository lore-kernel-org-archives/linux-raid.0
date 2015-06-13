From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re: seagate-"archive"-disks with raid6?
Date: Sat, 13 Jun 2015 22:11:23 +0200 (CEST)
Message-ID: <alpine.DEB.2.02.1506132207180.9487@uplift.swm.pp.se>
References: <557C5330.1090605@gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <557C5330.1090605@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: wiebittewas <wiebittewas@googlemail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sat, 13 Jun 2015, wiebittewas wrote:

> for a larger archive, we're thinking about buying six 8TB-Archive-Disks from Seagate to build a 4+2 Raid6-Array.
>
> now we've seen, that these disks are told not-recommended for raid, because they lack ERC/TLER (like many desktop-disks)

Not only that.

You might want to read:

http://www.spinics.net/lists/linux-ide/msg50641.html

These drives are different beasts than regular HDDs, and we seem to be 
seeing problems with them just the way SSDs were problematic in the 
beginning.

So you might want to reconsider using SMR drives for RAID use. I was 
considering them until I read up on them, and then I decided it was too 
early in the deployment cycle to use them for RAID use.

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
