From: Alvin Oga <aoga@ns.Linux-Consulting.com>
Subject: RE: ext3 journal on software raid (was Re: PROBLEM: Kernel 2.6.10 crashing repeatedly and hard)
Date: Wed, 5 Jan 2005 07:33:55 -0800 (PST)
Message-ID: <Pine.LNX.3.96.1050105072829.9415A-100000@Maggie.Linux-Consulting.com>
References: <200501051517.j05FHv925754@www.watkins-home.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200501051517.j05FHv925754@www.watkins-home.com>
Sender: linux-raid-owner@vger.kernel.org
To: Guy <bugzilla@watkins-home.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



On Wed, 5 Jan 2005, Guy wrote:

> I agree, but for a different reason.  Your reason is new to me.
..
> Loosing the swap disk would kill the system.

if one is using swap space ... i'd add more memory .. before i'd use raid
	- swap is too slow and as you folks point out, it could die
	due to (unlikely) bad disk sectors in swap area

> I don't want a down system due to a single disk failure.

that's what raid's for :-)

> I mirror everything, or RAID5.  Normally, no downtime due to disk failures.

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


