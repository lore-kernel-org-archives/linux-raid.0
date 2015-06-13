From: Wols Lists <antlists@youngman.org.uk>
Subject: Re: seagate-"archive"-disks with raid6?
Date: Sat, 13 Jun 2015 21:47:57 +0100
Message-ID: <557C96FD.60004@youngman.org.uk>
References: <557C5330.1090605@gmail.com> <alpine.DEB.2.02.1506132207180.9487@uplift.swm.pp.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.02.1506132207180.9487@uplift.swm.pp.se>
Sender: linux-raid-owner@vger.kernel.org
To: Mikael Abrahamsson <swmike@swm.pp.se>, wiebittewas <wiebittewas@googlemail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 13/06/15 21:11, Mikael Abrahamsson wrote:
> On Sat, 13 Jun 2015, wiebittewas wrote:
> 
>> for a larger archive, we're thinking about buying six
>> 8TB-Archive-Disks from Seagate to build a 4+2 Raid6-Array.
>>
>> now we've seen, that these disks are told not-recommended for raid,
>> because they lack ERC/TLER (like many desktop-disks)
> 
> Not only that.
> 
> You might want to read:
> 
> http://www.spinics.net/lists/linux-ide/msg50641.html
> 
> These drives are different beasts than regular HDDs, and we seem to be
> seeing problems with them just the way SSDs were problematic in the
> beginning.
> 
> So you might want to reconsider using SMR drives for RAID use. I was
> considering them until I read up on them, and then I decided it was too
> early in the deployment cycle to use them for RAID use.
> 
I didn't know these were shingled drives ... does the OP know what a
shingled drive is?

Basically, to get decent performance out of these drives, you have to
stream data at them - they're more like a tape-drive than a
random-access disk. So. They're great for backups, much less so for
normal use.

Cheers,
Wol
