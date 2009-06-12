From: "Leslie Rhorer" <lrhorer@satx.rr.com>
Subject: RE: Software RAID5 write issues
Date: Fri, 12 Jun 2009 00:24:40 -0500
Message-ID: <20090612052434749.TJHN26718@cdptpa-omta01.mail.rr.com>
References: <1244667422.21347.210.camel@firewall.xsintricity.com>
Reply-To: <lrhorer@satx.rr.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1244667422.21347.210.camel@firewall.xsintricity.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> You have 4 motherboard SATA ports, and 4 SATA ports on a PCI card.
> Right now you have your two OS drives on motherboard SATA ports, two of
> the five raid5 drives on motherboard SATA ports, and the three remaining
> raid5 drives on the PCI card SATA ports.  You need to get as many of the
> raid5 SATA disks on motherboard ports as possible.

'Or at least off the PCI card.  Depending on the motherboard, the
performance of the embedded ports may not be all that terrific, either.  I
have one Asus motherboard which is otherwise great, but whose on-board SATA
performance is anything but stellar.  If he can, I might suggest a different
SATA controller, either PCI Express or PCI-X.  There are a number of fairly
inexpensive PCI Express and PCI-X SATA controllers that provide very decent
performance - certainly better than he is seeing.  I have a couple of SiI
3124 based SATA controllers coupled with port multipliers and a couple of
Highpoint multilane SAS controllers that can all deliver in excess of
100MBps reads and in excess of 65 MBps writes on RAID5 and RAID6 arrays
across a 1G network.

> I would decide if
> you are more concerned about the raid5 array performing well (common, as
> it's usually the data you access most often) or the base OS array
> performing well (not so common, as it gets loaded largely into cache and
> doesn't get hit nearly so often as the data drive).  If you can deal
> with slowing down the OS drives, then I would move one of the OS drives
> to the PCI card and move one of the raid5 drives to the motherboard SATA
> port (and whichever drive you just moved over to the PCI card, I would
> mark it's raid1 arrays as write-mostly so that you don't read from it
> normally).

I think I would recommend replacing the controller and maybe going to a port
multiplier solution before I would shuffling the drives around using the
same old PCI card.  The PM is likely not going to be as fast or efficient as
a multilane solution, but a PCI Express or PCI-X card combined with a PM is
still probably going to be much faster than a PCI card.  It also allows for
more economic future expansion.

> Your big problem is that with 3 out of 5 raid5 drives on that PCI card,
> and sharing bandwidth, your total theoretical raid speed is abysmal.

I agree, or at least it's probably a big part of the problem.  He could of
course always have other problems, as well.

> When the three drives are sharing bandwidth on the card, they tend to
> split it up fairly evenly.  That means each drive gets roughly 1/3 of
> the PCI card's total available bandwidth over the PCI bus, which is
> generally poor in the first place.  Understand that a slow drive drags
> down *all* the drives in a raid5 array.  The faster drives just end up
> idling while waiting on the slower drive to finish its work (the faster
> drives will run ahead up to a point, then they eventually just get so
> far ahead that there isn't anything else for them to do until the
> slowest drive finishes up its stuff so old block requests can be
> completed, etc).  On the other hand, if you get 4 of the 5 drives on the
> motherboard ports, then that 5th drive on the PCI card won't be
> splitting bandwidth up and the overall array performance will shoot up
> (assuming the OS drives aren't also heavily loaded).

Yeah. I'm not even using SATA drives for my OS partitions.  I've got a bunch
of PATA drives lying around, good for little else, so rather than spend
money on new SATA drives or fiddle with booting from the arrays, I just put
a PATA drive on each system and use it for booting and OS.  While PATA ports
are getting somewhat rarer, most of even the most modern motherboards have
at least one IDE chain.  An ordinary old IDE drive with a capacity in the 80
- 160G range makes a perfectly good boot drive.  If he has a couple of old
unused IDE drives laying around, he might consider using  them.

> If you move one OS drive to the PCI card, then that leaves two raid5
> drives on the card.  In that case, I would seriously consider dropping
> back to a 4 drive array if you can handle the space reduction.  I would
> also seriously consider using raid4 instead of raid5 depending on your
> normal usage pattern.  If the data on the raid5 array is written once
> and then read over and over again, a raid4 can be beneficial in that you
> can stick the parity drive off on the PCI card and it won't be read from
> unless there is a drive failure or one the rare occasions when you write
> new data.

He's complaining more about write performance than read performance, so I
expect he would not be fond of this solution.


