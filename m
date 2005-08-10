From: Shaun Jackman <sjackman@gmail.com>
Subject: Re: Migrating from non-RAID to RAID-1
Date: Wed, 10 Aug 2005 16:39:55 -0700
Message-ID: <7f45d9390508101639635ab965@mail.gmail.com>
References: <7f45d93905080916414e291a87@mail.gmail.com>
	 <42F97A14.4080300@nighthawkrad.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <42F97A14.4080300@nighthawkrad.net>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Christopher Smith <csmith@nighthawkrad.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

2005/8/9, Christopher Smith <csmith@nighthawkrad.net>:
> Shaun Jackman wrote:
> > I have a single non-RAID SATA drive with Debian (Sarge) installed and
> > data on it. I also have a duplicate blank drive. I would like to
> > migrate from my non-RAID system to a RAID-1 (mirrored) system for
> > redundancy, with each disk being an exact duplicate of the other. Is
> > it possible to do this without having to wipe the first drive clean?
> > I'd appreciate a pointer to a HOWTO or recipe if it answers this
> > specific question.
> 
> This should get you started:
> 
> http://xtronics.com/reference/SATA-RAID-debian-for-2.6.html

Amazing! Thanks for the tip, Christopher. The document [1] you
mentioned is an absolute must-read for anyone migrating from a
non-RAID to RAID-1 storage system. The document's title suggests it's
Debian specific, but the vast majority of it is distribution agnostic.
It's up to date, using the modern mdadm tool; many documents I read
still referred to raidtools. The migration process went quite
flawlessly!

Thanks to all those that helped. Cheers,
Shaun

[1] Installing Debian with SATA based RAID
http://xtronics.com/reference/SATA-RAID-debian-for-2.6.html
