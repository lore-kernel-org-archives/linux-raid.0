From: "Guy" <bugzilla@watkins-home.com>
Subject: RE: ext3 journal on software raid (was Re: PROBLEM: Kernel 2.6.10 crashing repeatedly and hard)
Date: Wed, 5 Jan 2005 12:07:41 -0500
Message-ID: <200501051707.j05H7m926213@www.watkins-home.com>
References: <Pine.LNX.3.96.1050105072829.9415A-100000@Maggie.Linux-Consulting.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.3.96.1050105072829.9415A-100000@Maggie.Linux-Consulting.com>
Sender: linux-raid-owner@vger.kernel.org
To: 'Alvin Oga' <aoga@ns.Linux-Consulting.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

RAID does not cause bad data!
Bad data can get on any disk, even if it is part of a RAID system.
The bad data does not come from the hard disk, CRCs prevent that.

The problem is:  Where does the bad data come from?
Bad memory?  No, everyone use ECC memory, right?

Guy

-----Original Message-----
From: Alvin Oga [mailto:aoga@ns.Linux-Consulting.com] 
Sent: Wednesday, January 05, 2005 10:34 AM
To: Guy
Cc: linux-raid@vger.kernel.org
Subject: RE: ext3 journal on software raid (was Re: PROBLEM: Kernel 2.6.10
crashing repeatedly and hard)



On Wed, 5 Jan 2005, Guy wrote:

> I agree, but for a different reason.  Your reason is new to me.
..
> Loosing the swap disk would kill the system.

if one is using swap space ... i'd add more memory .. before i'd use raid
	- swap is too slow and as you folks point out, it could die
	due to (unlikely) bad disk sectors in swap area

> I don't want a down system due to a single disk failure.

that's what raid's for :-)

> I mirror everything, or RAID5.  Normally, no downtime due to disk
failures.

the problem with mirror ( raid1 ).. or raid5 ...
	- if you have a bad diska ... all "bad data" will/could  also get
	copied to the good disk

	- "bad data" is hard to figure out in code ... to prevent it from
	getting copied ... how does it know with 100% certainty 

	- if you know why it's bad data,  it's lot easier to know which
	data is more correct than the bad one

	- as everybody has pointed out .. bad data ( disk errors )
	can occur for any number of gazillion reasons

have fun raiding
alvin


