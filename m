From: Mark Hahn <hahn@physics.mcmaster.ca>
Subject: Re: Recommendations for supported 4-port SATA PCI card ?
Date: Fri, 31 Mar 2006 10:05:53 -0500 (EST)
Message-ID: <Pine.LNX.4.44.0603310953470.4777-100000@coffee.psychology.mcmaster.ca>
References: <442CE371.90900@stams.strath.ac.uk>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <442CE371.90900@stams.strath.ac.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Ian Thurlbeck <ian@stams.strath.ac.uk>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> http://linuxmafia.com/faq/Hardware/sata.html
> A little bit outdated though.  (Amazing how many "RAID" cards are "fakeraid")

well, the page is useful in that it discusses particular products,
but the "fakeraid" stuff is just silly name-calling.  there are either
real (hardware) raid cards, and there are multiport cards.  "fakeraid"
just means that there is code in the bios to do software raid 0/1 - 
not a bad thing in any possible sense, though also of zero value to many
people.

the prevalence of "fakeraid" simply shows that to be worth doing,
hw raid requires a pretty hefty piece of hardware, like the 3ware 9550.
older boards that had, for instance, a single pc100 dimm on them were 
the kiss of death, since just seeing that you knew that they couldn't 
move more than 10-20 MB/s, much less than a single disk's worth.

