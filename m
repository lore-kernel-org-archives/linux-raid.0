From: Mark Hahn <hahn@physics.mcmaster.ca>
Subject: Re: Looking for the cause of poor I/O performance
Date: Mon, 6 Dec 2004 16:34:45 -0500 (EST)
Message-ID: <Pine.LNX.4.44.0412061631250.4484-100000@coffee.psychology.mcmaster.ca>
References: <200412051017.13228.systemloc@earthlink.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200412051017.13228.systemloc@earthlink.net>
Sender: linux-raid-owner@vger.kernel.org
To: TJ <systemloc@earthlink.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> > for comparison, a fairly crappy SiS 735-based k7 system with
> > 64b-wide PC2100 can deliver maybe 1.2 GB/s dram bandwidth.
> > hdparm -T is about 500 MB/s, and would probably have trouble
> > breaking 200 MB/s with raid0 even if it had enough buses.
> >
> > an older server of mine is e7500-based, dual xeon/2.4's, with
> > 2xPC1600 ram.  it sustains about 1.6 GB/s on Stream, and about
> > 500 MB/s hdparm -T, and can sustain 250 MB/s through it's 6-disk
> > raid without any problem.
> 
> hmmm.. In these cases, how does the throughput exceed the PCI bandwidth? Do 
> these boards have multiple busses? PCI-X?

I didn't say they exceeded bus bandwidth ("if it had enough").
the latter does actually have multiple buses, some of which are pcix;
that's pretty common among server boards.

interestingly, even non-server desktop parts can exceed PCI bandwidth - 
I did a disk server a few years ago that used two chipset ATA ports
and an add-in 4-port card to hit about 150 MB/s total (sustained).

