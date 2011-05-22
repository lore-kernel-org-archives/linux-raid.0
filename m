From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: HBA Adaptor advice
Date: Sun, 22 May 2011 03:13:09 -0500
Message-ID: <4DD8C595.6070307@hardwarefreak.com>
References: <4DD50C89.8060006@wildgooses.com> <20110520020853.GC4759@bitfolk.com> <4DD61948.8050302@wildgooses.com> <4DD65C18.5090804@gmail.com> <20110520200100.GF4759@bitfolk.com> <BANLkTimP_5HHAq3Fq2sAkasZKH85gJFtYw@mail.gmail.com> <4DD6D5DC.4010209@hardwarefreak.com> <4DD7A100.2010807@wildgooses.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4DD7A100.2010807@wildgooses.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 5/21/2011 6:24 AM, Ed W wrote:
> On 20/05/2011 21:58, Stan Hoeppner wrote:
> 
>> As always, a good data persistence strategy starts with a good UPS.
> 
> I'm sure you are going to tell me that my APCs aren't good UPSs, but I

In my experience APC are good UPS.  Interestingly, I have an APC
SU1400RMNET manufactured in *1997*, powering my home office rack.  I've
replaced the batteries 4 times, but the UPS itself is like the Energizer
Bunny.  14 years and still going strong.

> have something like 5 APCs and 4 have failed in odd ways due to the
> battery dying, inside of around 2 years from new.  Sure you replace the

Then I'd guess you're not performing proper UPS maintenance.  Once
yearly you need to perform a deep cycle self test which can notify you
of marginal batteries at a much earlier stage.  Your APC manual has
instructions for performing this test, or you can download the manual
from there site if it's been lost.

All APCs inform you when the battery needs to be replaced, via front
panel LED and via software or network notification (Email/SNMP).  But
you don't want to wait for that.  Do the deep self test.

> battery, but failure modes each time caused a sudden power failure.  In
> nearly all cases the UPS failed before I would have had a sudden power
> loss for other reasons...

Yep.  Lack of proper UPS maintenance and monitoring.

> So, I'm not convinced that UPSs dramatically raise the uptime, and where

Without a UPS in Missouri USA, your servers will go down from power loss
at *minimum* 50-100 times per year due to electrical storms, high winds,
power line maintenance, brown outs and sags caused by all manner of
things, truck hitting power pole, etc, etc.

> they do it's in well designed, racked, datacenter environments where
> "accidents" don't dominate the downtime risk?

Doesn't matter if it's a corporate datacenter, your rack in the
basement, or an office pedestal server.  What counts is proper design
and installation.  It's is trivially simple in an office environment to
route all cables in a manner that they won't be tripped over.  I'm truly
shocked that cable tripping could be an issue for anyone in 2011, let
alone 1999.  Get a rack cabinet and stick it in a corner.  Here, get this:

http://cgi.ebay.co.uk/COMPAQ-42U-SERVER-RACK-CABINET-ENCLOSURE-/150608001643?pt=UK_Computing_Networking_SM&hash=item2310efba6b

and 2 or 3 of these, since all your servers are non-rack boxes:

http://cgi.ebay.co.uk/StarTech-Adjustable-Depth-Fixed-Server-Rack-Cabinet-She-/320618338412?pt=UK_Computing_ComputerComponents_Monitors&hash=item4aa657986c

Problem solved.

-- 
Stan
