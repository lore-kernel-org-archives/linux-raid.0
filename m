From: Brad Campbell <brad@wasp.net.au>
Subject: Re: raidreconf
Date: Sun, 01 Aug 2004 14:28:15 +0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <410CC5BF.4050600@wasp.net.au>
References: <1091196159.410a54ff91240@www.tastycake.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1091196159.410a54ff91240@www.tastycake.net>
To: Nick Maynard <nick.maynard@alumni.doc.ic.ac.uk>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Nick Maynard wrote:
> Hello,
> 
> I'm trying to track down a recent version of raidreconf, but all my Google
> searches have come up blank - the latest I can find is 2001 sometime.
> 
> Now, I know someone on the list (Brad I think) has been working on raidreconf
> quite recently - has anyone got any info on where I can get a more recent
> version?

Things have slowed a little in that department at the moment as my main test hard disk underwent a 
rapid deceleration test from a table to a tiled floor and has somewhat ceased to function. (Don't 
try this one at home kids)

Prior to that I had got as far as intermittently creating raid-6 volumes that worked (the rest of 
the time the blocks were all intact but in the wrong order!) and kludging it to work with raid-5 
volumes over 2TB. (I did manage to reconfigure a 1.6TB array to be a 2.1TB array with no data loss).

I have a new set of test drives in my purchase queue, but have not quite got that far yet.

The raidtools-1.00.3.tar.gz package is the one I have been working with and seems to be pretty 
stable on anything under 2TB. I certainly did not hit any major flaws while working with it as is.

I'm currently thinking about how to do it while removing the dependency on raidtools and moving to a 
mdadm like setup, but have not got far down that path.

If you want to use raidreconf and you created your arrays with mdadm then use lsraid to generate a 
suitable raidtab, edit that to create the new one and have at it.
On <2TB I found it pretty solid.

Regards,
Brad
