From: Christopher Smith <csmith@nighthawkrad.net>
Subject: Re: Problems with multiple Promise SATA150 TX4 cards
Date: Tue, 24 Jan 2006 17:58:50 +1100
Message-ID: <43D5D02A.4020909@nighthawkrad.net>
References: <Pine.LNX.4.44.0601240132560.32305-100000@coffee.psychology.mcmaster.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.44.0601240132560.32305-100000@coffee.psychology.mcmaster.ca>
Sender: linux-raid-owner@vger.kernel.org
To: Mark Hahn <hahn@physics.mcmaster.ca>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Mark Hahn wrote:
>> I have shuffled the cards,cables and physical drives around to determine 
>> that this is not a problem with any of them individually - no matter the 
>> combination, it only ever happens to drives that are at sd[abcd] (ie: if 
>> I rejig the hardware so the drive at /dev/sdh, which was working fine, 
>> is on a different cable and controller, but appears at /dev/sdb, it will 
>> produce the errors).
> 
> did you test the case where all disks had power, but only 8 were plugged 
> into controllers? 
> 
>> no individual card, cable or drive was responsible.  The errors _only_ 
>> occur with three cards in the system, _only_ with whichever drives are 
>> attached to the "first" controller (ie: sd[abcd]) and _regardless_ of 
>> other system activity.
> 
> the "first" card would correspond to position on the PCI bus (slot),
> so perhaps that card is getting iffy power.  but did you actually move
> around which power cables are supplying which disks?

Power supply was also one of my suspicions, so I tried powering up half 
a dozen of the drives off another ATX power supply I had and the 
remainder off the system PSU.  The same problems occurred, which I think 
rules out the possibility of insufficient power (I did try with all 
drives powered, but only two cards installed and that worked fine - but 
I haven't moved around the power plugs of individual drives).

I'll try again tonight with all the drives powered off their own PSU, 
just to be sure.

CS
