From: Mark Hahn <hahn@physics.mcmaster.ca>
Subject: Re: sata controllers status=0x51 { DriveReady SeekComplete Error }
 error=0x84 { DriveStatusError BadCRC }
Date: Sat, 1 Apr 2006 13:25:32 -0500 (EST)
Message-ID: <Pine.LNX.4.44.0604011323380.11853-100000@coffee.psychology.mcmaster.ca>
References: <442E698D.8000100@dgreaves.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <442E698D.8000100@dgreaves.com>
Sender: linux-raid-owner@vger.kernel.org
To: David Greaves <david@dgreaves.com>
Cc: Mitchell Laks <mlaks@verizon.net>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> >Mar 29 23:33:26 A1 kernel: ata6: status=0x51 { DriveReady SeekComplete Error }
> >Mar 29 23:33:26 A1 kernel: ata6: error=0x84 { DriveStatusError BadCRC }

BadCRC is unambiguous: the packet was corrupted.  that could happen several
ways, the most common of which is bogus cables (remember, PATA is 18",
not longer, with the ends plugged in.)  but things like flakey power,
overclocking, or controllers programmed with wrong timing could also 
cause such errors.

