From: Jon Nelson <jnelson-linux-raid@jamponi.net>
Subject: Re: very strange (maybe) raid1 testing results
Date: Wed, 30 May 2007 21:58:08 -0500 (CDT)
Message-ID: <Pine.LNX.4.64.0705302154050.4266@gheavc.wnzcbav.cig>
References: <Pine.LNX.4.64.0705292135200.4266@gheavc.wnzcbav.cig>
 <465E346B.7090701@sauce.co.nz>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <465E346B.7090701@sauce.co.nz>
Sender: linux-raid-owner@vger.kernel.org
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, 31 May 2007, Richard Scobie wrote:

> Jon Nelson wrote:
> 
> > I am getting 70-80MB/s read rates as reported via dstat, and 60-80MB/s as
> > reported by dd. What I don't understand is why just one disk is being used
> > here, instead of two or more. I tried different versions of metadata, and
> > using a bitmap makes no difference. I created the array with (allowing for
> > variations of bitmap and metadata version):
> 
> This is normal for md RAID1. What you should find is that for 
> concurrent reads, each read will be serviced by a different disk, 
> until no. of reads = no. of drives.

Alright. To clarify, let's assume some process (like a single-threaded 
webserver) using a raid1 to store content (who knows why, let's just say 
it is), and also assume that the I/O load is 100% reads. Given that the 
server does not fork (or create a thread) for each request, does that 
mean that every single web request is essentially serviced from one 
disk, always? What mechanism determines which disk actually services the 
request?

--
Jon Nelson <jnelson-linux-raid@jamponi.net>
