From: Nick Maynard <nick.maynard@alumni.doc.ic.ac.uk>
Subject: Re: raidreconf
Date: Sun,  1 Aug 2004 13:28:56 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <1091363336.410ce208494b0@www.tastycake.net>
References: <1091196159.410a54ff91240@www.tastycake.net> <410CC5BF.4050600@wasp.net.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <410CC5BF.4050600@wasp.net.au>
To: Brad Campbell <brad@wasp.net.au>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> Things have slowed a little in that department at the moment as my main test
> hard disk underwent a
> rapid deceleration test from a table to a tiled floor and has somewhat ceased
> to function. (Don't
> try this one at home kids)
>
> Prior to that I had got as far as intermittently creating raid-6 volumes that
> worked (the rest of
> the time the blocks were all intact but in the wrong order!) and kludging it
> to work with raid-5
> volumes over 2TB. (I did manage to reconfigure a 1.6TB array to be a 2.1TB
> array with no data loss).
>
> I have a new set of test drives in my purchase queue, but have not quite got
> that far yet.
>
> The raidtools-1.00.3.tar.gz package is the one I have been working with and
> seems to be pretty
> stable on anything under 2TB. I certainly did not hit any major flaws while
> working with it as is.
>
> I'm currently thinking about how to do it while removing the dependency on
> raidtools and moving to a
> mdadm like setup, but have not got far down that path.
>
> If you want to use raidreconf and you created your arrays with mdadm then use
> lsraid to generate a
> suitable raidtab, edit that to create the new one and have at it.
> On <2TB I found it pretty solid.
So the current version of raidreconf is included with raidtools-1.00.3.tar.gz?

Looking at http://people.redhat.com/mingo/raidtools/, I find that archive is
dated 15 Jan 2003.  Is that the version you're using, or have you
improved/fixed/patched raidreconf since then?

Thanks,

--

Nick Maynard
nick.maynard@alumni.doc.ic.ac.uk
