From: Alvin Oga <aoga@ns.Linux-Consulting.com>
Subject: Re: ext3 journal on software raid (was Re: PROBLEM: Kernel 2.6.10 crashing repeatedly and hard)
Date: Wed, 5 Jan 2005 02:44:44 -0800 (PST)
Message-ID: <Pine.LNX.3.96.1050105023623.27288A-100000@Maggie.Linux-Consulting.com>
References: <20050105095658.GX99565@caffreys.strugglers.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20050105095658.GX99565@caffreys.strugglers.net>
Sender: linux-raid-owner@vger.kernel.org
To: Andy Smith <andy@strugglers.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


hi ya andy

good summary ... thanx..

one more item :-)

On Wed, 5 Jan 2005, Andy Smith wrote:

..

> From what I can understand of the thread so far, Peter is saying the
> following:
> 
>         RAID mirrors are susceptible to increasing undetectable
>         inconsistencies because, as we all know, filesystems sustain
>         corruption over time.
>         
>         On a filesystem that runs from one disk, corruption serious
>         enough to affect the stability of the file system will do so
>         and so will be detected.  As more disks are added to the
>         mirror, the probability of that corruption never being seen
>         naturally goes up.
> 
>         Peter personally does not put the journal inside the mirror
>         because if he ever came to need to use the journal and found
>         that it was corrupted, it could risk his whole filesystem.
>         Peter prefers to put the journal on a separate device that
>         is not mirrored.
> 
> I am not trying to put words into your mouth Peter, just trying to
> summarise what your points are.  If I haven't represented your views
> correctly then by all means correct me but please try to do so
> succinctly and informatively.
> 
> Now, others are saying in response to this, things like:
> 
>         Spontaneous corruption is rare compared to outright or
>         catastrophic device failure, and although it is more
>         likely to go unnoticed with RAID mirrors, while it IS
>         unnoticed, this presumably correct data is also being rewritten
>         back to the filesystem.
>         
>         Mirrors help protect against the more common complete device
>         failure and so a journal should surely be on a mirror since
>         if you lose the journal then the machine needs to go down
>         anyway.  It is unavailability of the server we're trying to
>         avoid; consistency of the data can be protected with regular
>         backups and possibly measured with other methods like
>         md5sum.

some other issues ...

	how one can detect failures, errors would be completely
	up to the tools they use ... various tools does specific
	functions and cannot tell you anything about any other
	causes of the problems

	for swap ... i personally don't see any reason to mirror
	swap partitions ...
		- once the system dies, ( power off ), all temp
		data is useless unless one continues from a coredump 
		( from the same state as when it went down initially )

	if a disk did fail, die, error, hiccup, then whatever cause the
	problem can also affect the data and the metadata and the parity 
	and the "mirror"
		- which set of "bytes" on the disk "raid" trust to
		restore from is up to the code and its predefined
		set of assumptions of various failure modes

		- partially written data is very bad thing to have

	unless you know "exactly why and how if failed/eerrored,
	there is no sane way to bet the house on which data is more
	correct than the other 
		- i'm excluding bad memory, bad cpu, bad power supply
		from the lsit of possible problems

		and yes, bad (generic) memory has corrupted my systems
		once in 10 yrs...

have fun
alvin

