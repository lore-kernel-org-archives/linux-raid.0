From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re: Paranoid mode for RAID-1 ?
Date: Mon, 27 Apr 2015 09:35:43 +0200 (CEST)
Message-ID: <alpine.DEB.2.02.1504270925480.16871@uplift.swm.pp.se>
References: <972437107.22507366.1430116679975.JavaMail.zimbra@laposte.net> <553DDBB3.2010306@websitemanagers.com.au> <553DE20E.2020605@hesbynett.no>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <553DE20E.2020605@hesbynett.no>
Sender: linux-raid-owner@vger.kernel.org
To: David Brown <david.brown@hesbynett.no>
Cc: Adam Goryachev <mailinglists@websitemanagers.com.au>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, 27 Apr 2015, David Brown wrote:

> btrfs has data checksums like that.  Like Neil, I question the necessity 
> for harddisks, but such checksums are lower cost than reading the data 
> twice from two disks (as they are stored as part of the metadata that 
> you already read), and can offer some protection against serious 
> hardware problems.  (Checksums like this cannot easily be implemented in 
> a transparent block device such as md raid - it is more practical to 
> have them as part of the filesystem, as done with btrfs.)

Only way I can imagine this being done would be for instance to add a 4KiB 
block for every 128KiB chunk or something like that, and perhaps have a 
smaller checksum for each 4KiB block within that 128KiB chunk.

I doubt anyone would be interested in putting efforts into creating this 
though as it would have "interesting" performance drawbacks, and that work 
is probably better spent by making sure that btrfs and/or zfs gets more 
development/testing than it is to put that effort into md. I personally 
prefer md to be fairly "simple" so we have as few bugs as possible in it, 
I'd say that md generally works and the number of developers working 
heroically on its current incarnation is barely enough to make sure that 
the codebase works as well as it must considering the critical function it 
serves for a lot of us.

This has been discussed before and nobody has shown interest in actually 
developing code for it, so we're still at the feature request and 
"brainstorming about design" state, and without actual coder(s) willing to 
actually implement, it's not going to get further than this stage.

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
