From: Gordon Henderson <gordon@drogon.net>
Subject: Re: Huge mdadm resync problem.
Date: Thu, 17 Feb 2005 14:40:34 +0000 (GMT)
Message-ID: <Pine.LNX.4.56.0502171435420.819@lion.drogon.net>
References: <20050217145217.327494214a19146cf7@mail.kip.uni-heidelberg.de>
 <cv29q2$l2l$1@sea.gmane.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
In-Reply-To: <cv29q2$l2l$1@sea.gmane.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, 17 Feb 2005, Phantazm wrote:

> I use master slave. Problem is that i cant break raid set couse if i do i
> will loose over 1TB of data :/
>
> Goin to see if i can get more controller cards though.

Do it. Use 4 2-port cards for your 8 drives and only one drive per cable.
It is possible, and I've had it happen to me, that a hardware failure on a
failing drive can cause loss of access to the 2nd drive on the same cable.
Fortunately when it happened to me, the disks weren't in a RAID set and I
didn't lose any data on the other drive, but if the disks were in a RAID
set, then you'd have a 2-disk failure on your hands, and unless it was
RAID-6, then you'd be shafted!

I was about to suggest running with noapic, but you've already tried
that... You might also want to see if the motherboard has a way to turn
the APIC off too. I had that on one Athlon mobo, and running it all in PIC
mode kept it going much better.

Also experiment with PCI slot locations, although with 4 PCI cards, you
might not have much luck, depending on your motherboard. Try to get each
card on its own interrupt if at all possible. Some BIOSes can help fix
this for you, some can't....

Gordon
