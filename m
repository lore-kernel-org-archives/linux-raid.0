From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: speed_limit_min probs, thoughts
Date: Thu, 16 Oct 2003 13:53:09 +1000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <16270.5669.827066.80944@notabene.cse.unsw.edu.au>
References: <3F898E6B.4080109@mastre.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Duke Ionescu on Sunday October 12
To: Duke Ionescu <duke@mastre.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sunday October 12, duke@mastre.com wrote:
> I've been playing around with linux Software RAID it for a day or so and 
> have been testing all types of scenarios, like simulating disk failures, 
> rebuilds, etc.  And I've run into some problems.  On top of this, I have 
> some thoughts on the subject (imagine that! ;) that I will post here. 
> So, here we go:
> 
> The test system I am running this on is:
> Supermicro P4SCE-based server
> Pentium 4 2.4GHz 800MHz FSB
>   - HyperThreading Enabled
>   - RedHat Linux 9, stock 2.4.20-8smp kernel
> 1GB PC3200 ECC RAM (2x512)
> 2 x Maxtor 5A250J0 250GB 5400RPM HD
>   - connected to sep channels, in UDMA5 mode
>   - one is hda, the other hdd (CD-ROM is hdc)
> 
snip
> 
> Now, besides the fact that I _know_ the hardware is much faster than a 
> measly 12MB/s, when I monitor mdrecoveryd and raid1d via top, 
> mdrecoveryd occasionally goes over 2.0% to 3.1%, but usually lingers at 
> 1.9%.  raid1d stays at under 1% most of the time.  There is nothing else 
> actively running on the system (see ps ax and output at end).  So what 
> gives?  Why are my disks only mustering 12MB/s when they should instead 
> be maxing out the system to try to achieve my 100MB/s goal?  Does the 
> "124k window" have something to do with this?

100MB/sec might be the speed of the interface, but it certaintly isn't
the speed of the drive.  My 15000 RPM SCSI drives do around 30MB/sec,
so your 5400RPM drives are doing OK at 12MB/sec.


NeilBrown

