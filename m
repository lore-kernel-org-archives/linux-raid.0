From: Mathias Mueller <raidfail@gmx.de>
Subject: Re: broken raid level 5 array caused by user error
Date: Tue, 10 Nov 2015 15:55:21 +0100
Message-ID: <3d688dcd7860c1d06f7128ca4f03d89f@pingofdeath.de>
References: <15194c2e14b9a7c3431853dea9dc8b5e@pingofdeath.de>
 <alpine.DEB.2.02.1511091254290.24520@uplift.swm.pp.se>
 <5640A4B1.4050207@turmel.org>
 <07de4cd96f39ecb6154794d072ca12e7@pingofdeath.de>
 <5640B8AD.3030800@turmel.org>
 <ed5f0f3cde3f017eae97bab65c792983@pingofdeath.de>
 <d764bf541381927fa4183c9266fb3f5a@pingofdeath.de>
 <5640C38B.4060503@turmel.org>
 <a3a91665c4b7cdd70dacc7d8815cc365@pingofdeath.de>
 <56410C67.2090202@turmel.org>
 <420c63e0400e6d3f50b794e64f6a8d96@pingofdeath.de>
 <5641F749.2070804@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5641F749.2070804@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Phil,

> 'screen' is your friend for long-running server tasks.  It's installed
> in many distros by default.

> I should have put "|head -n 50" on the end of that. :-)

I already restarted the process via screen, I just did not expect, that 
it will take so much time :)


> This ^^ is encouraging: Sun, 08 Nov 2015 20:06:00 GMT
> It's in the right spot for data offset == 2048 if this
> is the first device.

yes, this is about the last time I mounted the array


> These ^^ look like backup ext4 superblocks, written Thu, 07 May 2015
> 13:41:16 GMT.  If you had uptime from May all the way to November, this
> is believable.  And there's more of them scattered below.

nope, I moved the array to another box last evening sunday

> Another candidate for a first disk, with offset 2048.  Also written
> Sun, 08 Nov 2015 20:06:00 GMT.  Either sdc or sde is your first disk.
> The other is parity, which is the last disk on the first stripe, with
> zeros in the matching offsets of the other two disks.


> So, we now know your data offset == 2048, with pretty high confidence.
> We know the possible order combinations:
>   sdc1 sdb1 sdd1 sde1
>   sdc1 sdd1 sdb1 sde1
>   sde1 sdb1 sdd1 sdc1
>   sde1 sdd1 sdb1 sdc1
> 
> We don't know the chunk size for sure.  I don't remember when the 
> default
> changed from 64 to 512.  I'd try 64 first.
> 
> It's possible you could map the standard locations of ext4 superblocks
> versus the locations noted above, and work out the order and chunk
> size.  I'll leave that as an exercise for you, if you don't want to
> just try the various combinations.  :-)
> 
> Remember, "fsck -n" after each --create --assume-clean to see if it
> works well.

You are great, I'll give it a try and try the combinations, thx a lot!

Mathias

