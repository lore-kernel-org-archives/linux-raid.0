From: TJ <systemloc@earthlink.net>
Subject: Re: Looking for the cause of poor I/O performance
Date: Sun, 5 Dec 2004 10:17:13 -0500
Message-ID: <200412051017.13228.systemloc@earthlink.net>
References: <Pine.LNX.4.44.0412041809530.21262-100000@coffee.psychology.mcmaster.ca>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.44.0412041809530.21262-100000@coffee.psychology.mcmaster.ca>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> for comparison, a fairly crappy SiS 735-based k7 system with
> 64b-wide PC2100 can deliver maybe 1.2 GB/s dram bandwidth.
> hdparm -T is about 500 MB/s, and would probably have trouble
> breaking 200 MB/s with raid0 even if it had enough buses.
>
> an older server of mine is e7500-based, dual xeon/2.4's, with
> 2xPC1600 ram.  it sustains about 1.6 GB/s on Stream, and about
> 500 MB/s hdparm -T, and can sustain 250 MB/s through it's 6-disk
> raid without any problem.

hmmm.. In these cases, how does the throughput exceed the PCI bandwidth? Do 
these boards have multiple busses? PCI-X?

TJ Harrell
