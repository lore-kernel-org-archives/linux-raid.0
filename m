From: "Guy" <bugzilla@watkins-home.com>
Subject: RE: ext3 journal on software raid (was Re: PROBLEM: Kernel 2.6.10 crashing repeatedly and hard)
Date: Wed, 5 Jan 2005 12:32:00 -0500
Message-ID: <200501051732.j05HW6926345@www.watkins-home.com>
References: <Pine.LNX.3.96.1050105091502.9709A-100000@Maggie.Linux-Consulting.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.3.96.1050105091502.9709A-100000@Maggie.Linux-Consulting.com>
Sender: linux-raid-owner@vger.kernel.org
To: 'Alvin Oga' <aoga@ns.Linux-Consulting.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

You said this:
"	- as everybody has pointed out .. bad data ( disk errors )
	can occur for any number of gazillion reasons

have fun raiding
Alvin"

Bad data is not caused by disk errors.  This seemed like you were blaming
the hard disk.  I understand you now.  It seems we agree!

Guy

-----Original Message-----
From: Alvin Oga [mailto:aoga@ns.Linux-Consulting.com] 
Sent: Wednesday, January 05, 2005 12:22 PM
To: Guy
Cc: 'Alvin Oga'; linux-raid@vger.kernel.org
Subject: RE: ext3 journal on software raid (was Re: PROBLEM: Kernel 2.6.10
crashing repeatedly and hard)


hi ya guy

On Wed, 5 Jan 2005, Guy wrote:

> RAID does not cause bad data!

again .. that's not what i said ..

the point i've been tring to say .. one MUST figure out "exactly"
where the bad data or errors or crashes are coming from

	it will usually be bad ("cheap") parts or operator error
	or simple "slapped" together boxes

> Bad data can get on any disk, even if it is part of a RAID system.
> The bad data does not come from the hard disk, CRCs prevent that.
> 
> The problem is:  Where does the bad data come from?
> Bad memory?  No, everyone use ECC memory, right?

that's what i was saying... but you do a better job

even if one uses ecc... ecc can only fix certain errors,
and non-correctable errors are flagged and not fixed
( burst errors are hard to fix )

and people that use ecc memory ... usually have higher-end motherboards
and more memory in the system vs the $50 motherboard+cpu combo (disasters)
from fries ( a local pc store )

c ya
alvin


