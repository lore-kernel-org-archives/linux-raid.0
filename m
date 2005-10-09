From: Mark Hahn <hahn@physics.mcmaster.ca>
Subject: Re: Checking the sanity of SATA disks
Date: Sun, 9 Oct 2005 11:21:27 -0400 (EDT)
Message-ID: <Pine.LNX.4.44.0510091019050.28615-100000@coffee.psychology.mcmaster.ca>
References: <20051004142913.GK6594@strugglers.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20051004142913.GK6594@strugglers.net>
Sender: linux-raid-owner@vger.kernel.org
To: Andy Smith <andy@lug.org.uk>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

>         dd if=/dev/sd[abcd] of=/dev/null

the only thing really wrong with that is that you're using 512 byte IOs,
which is ridiculously inefficient.  disks these days don't do IO in 512B
chunks, so there's no justification for this.  (the last time I did a scan
of a sick disk, IIRC the minimum data size was actually 8K - that was an 
old deathstar that someone had flopping around loose inside a case...)

using, say, 128KB chunks will consume less overhead.  using O_DIRECT will
also treat the rest your system a bit nicer.

