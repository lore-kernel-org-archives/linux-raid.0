From: Alvin Oga <aoga@ns.Linux-Consulting.com>
Subject: Re: ext3 journal on software raid (was Re: PROBLEM: Kernel 2.6.10 crashing repeatedly and hard)
Date: Wed, 5 Jan 2005 03:39:41 -0800 (PST)
Message-ID: <Pine.LNX.3.96.1050105033448.27450A-100000@Maggie.Linux-Consulting.com>
References: <41DBC7DE.509@wasp.net.au>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <41DBC7DE.509@wasp.net.au>
Sender: linux-raid-owner@vger.kernel.org
To: Brad Campbell <brad@wasp.net.au>
Cc: Andy Smith <andy@strugglers.net>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids



hi ya brad

On Wed, 5 Jan 2005, Brad Campbell wrote:

> Alvin Oga wrote:
> > 
> > 	for swap ... i personally don't see any reason to mirror
> > 	swap partitions ...
> > 		- once the system dies, ( power off ), all temp
> > 		data is useless unless one continues from a coredump 
> > 		( from the same state as when it went down initially )
> 
> I beg to differ on this one. Having spend several weeks tracking down random processes dying on a 
> machine that turned out to be a bad sector in the swap partition, I have had great results by 
> running swap on a RAID-1. If you develop a bad sector in a non-mirrored swap, bad things happen 
> indeterminately and can be a royal PITA to chase down. It's just a little extra piece of mind.

okay .... if the parts of disks is bad that is used for swap, 
mirroring might help ... 

but, i wonder, how/why the system used that portion of swap in the first
place
	- even for raid, if sector-10 in swap is bad, why would raid keep
	trying to write there instead of to sector-1000
	( the systems should be writing data, and read it back to verify
	( what it wrote to disk, not the disk cache, is the same as what
	( it just read back, before it says, "data is written"

and i spent days trackign down a bad memory ... that killed the raid ...

- various backups  the only reasonable way to make sure
  [supposedly good] data is not lost where backups does NOT overwrite
  previous[ly good] backups

c ya
alvin
 

