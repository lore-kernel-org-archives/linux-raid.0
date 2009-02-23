From: Matt Garman <matthew.garman@gmail.com>
Subject: Re: bonnie++ on md device causes reboot on new motherboard
Date: Mon, 23 Feb 2009 08:45:36 -0600
Message-ID: <20090223144536.GB30091@sewage.raw-sewage.fake>
References: <20090203041450.GA2107@sewage.raw-sewage.fake>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20090203041450.GA2107@sewage.raw-sewage.fake>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


A few weeks ago I posted a problem I was having with my machine
rebooting whenever I wrote to an md array (details below).

The problem turned out to be using the SiI 3132 2-port SATA card in
the PCIe x16 slot of the ga-ma74gm-s2 motherboard.  I contacted
Gigabyte and they said that the x16 slot is designed for *video
only*.

So just a heads-up if you plan to use this board for a low-power
file server.

-Matt

On Mon, Feb 02, 2009 at 10:14:50PM -0600, Matt Garman wrote:
> 
> I have two four disk raid5 arrays on Ubuntu Linux 8.04 (AMD64).
> Both are using XFS for the filesystem.
> 
> $ uname -a
> Linux septictank 2.6.24-19-generic #1 SMP Wed Aug 20 17:53:40 UTC
> 2008 x86_64 GNU/Linux
> 
> I recently replaced the motherboard and processor: switched from an
> Intel Q35 motherboard + E5200 CPU to a Gigabyte GA-MA74GM-S2
> motherboard (AMD 740G/SB700) with an 4850e CPU.
> 
> I ran a ton of benchmarks under the old configuration, and intend to
> do the same with the new hardware.  (See my previous posts regarding
> SATA/southbridge performance.)
> 
> Anyway, four times now, when I run bonnie++ (with my current working
> directory on one of the md arrays), the computer immediately
> reboots.
> 
> I saw this happen twice while I logged in remotely; I did it again
> from the console to see if there are any useful error messages.
> 
> It flashed too quickly, but the reboot looked like it happened
> immediately after bonnie++ started "Writing intelligently...".
> 
> There are no useful indications in the system logs.
> 
> Every time this reboot happens, it forces a rebuild of the md array.
> I have only tried it on the one array (which is empty, so I can
> afford to have the rebuild fail).  I'm afraid to try it on the other
> one until I figure this out.
> 
> For what it's worth the md device in question is four Western
> Digital 7500AAKS 750 GB 7200 rpm SATA drives.  The controller is not
> the onboard SATA, but actually two 2-port PCIe SATA cards.
> 
> Anyone seen anything like this or have any ideas where I can start
> looking for more information?
> 
> Thanks!
> Matt
> 
