From: Alvin Oga <aoga@ns.Linux-Consulting.com>
Subject: RE: ext3 journal on software raid (was Re: PROBLEM: Kernel 2.6.10 crashing repeatedly and hard)
Date: Wed, 5 Jan 2005 09:21:53 -0800 (PST)
Message-ID: <Pine.LNX.3.96.1050105091502.9709A-100000@Maggie.Linux-Consulting.com>
References: <200501051707.j05H7m926213@www.watkins-home.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200501051707.j05H7m926213@www.watkins-home.com>
Sender: linux-raid-owner@vger.kernel.org
To: Guy <bugzilla@watkins-home.com>
Cc: 'Alvin Oga' <aoga@ns.Linux-Consulting.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids


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


