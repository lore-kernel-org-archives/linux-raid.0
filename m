From: pg_lxra@lxra.for.sabi.co.UK (Peter Grandi)
Subject: Re: raid6 check/repair
Date: Tue, 4 Dec 2007 21:07:23 +0000
Message-ID: <18261.49547.588360.436369@base.ty.sabi.co.UK>
References: <474431BF.30103@ph.tum.de>
	<18244.64972.172685.796502@notabene.brown>
	<4745B375.4030500@ph.tum.de>
	<18254.21949.441607.134763@notabene.brown>
	<474F4880.8080300@eyal.emu.id.au>
	<47502140.1080601@ph.tum.de>
	<1196650421.14411.10.camel@elara.tcw.local>
	<47546019.5030300@ph.tum.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <47546019.5030300@ph.tum.de>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

[ ... on RAID1, ... RAID6 error recovery ... ]

tn> The use case for the proposed 'repair' would be occasional,
tn> low-frequency corruption, for which many sources can be
tn> imagined:

tn> Any piece of hardware has a certain failure rate, which may
tn> depend on things like age, temperature, stability of
tn> operating voltage, cosmic rays, etc. but also on variations
tn> in the production process.  Therefore, hardware may suffer
tn> from infrequent glitches, which are seldom enough, to be
tn> impossible to trace back to a particular piece of equipment.
tn> It would be nice to recover gracefully from that.

What has this got to do with RAID6 or RAID in general? I have
been following this discussion with a sense of bewilderment as I
have started to suspect that parts of it are based on a very
large misunderstanding.

tn> Kernel bugs or just plain administrator mistakes are another
tn> thing.

The biggest administrator mistakes are lack of end-to-end checking
and backups. Those that don't have them wish their storage systems
could detect and recover from arbitrary and otherwise undetected
errors (but see below for bad news on silent corruptions).

tn> But also the case of power-loss during writing that you have
tn> mentioned could profit from that 'repair': With heterogeneous
tn> hardware, blocks may be written in unpredictable order, so
tn> that in more cases graceful recovery would be possible with
tn> 'repair' compared to just recalculating parity.

Redundant RAID levels are designed to recover only from _reported_
errors that identify precisely where the error is. Recovering from
random block writing is something that seems to me to be quite
outside the scope of a low level virtual storage device layer.

ms> I just want to give another suggestion. It may or may not be
ms> possible to repair inconsistent arrays but in either way some
ms> code there MUST at least warn the administrator that
ms> something (may) went wrong.

tn> Agreed.

That sounds instead quite extraordinary to me because it is not
clear how to define ''inconsistency'' in the general case never
mind detect it reliably, and never mind knowing when it is found
how to determine which are the good data bits and which are the
bad.

Now I am starting to think that this discussion is based on the
curious assumption that storage subsystems should solve the so
called ''byzantine generals'' problem, that is to operate reliably
in the presence of unreliable communications and storage.

ms> I had an issue once where the chipset / mainboard was broken
ms> so on one raid1 array I have diferent data was written to the
ms> disks occasionally [ ... ]

Indeed. Some links from a web search:

  http://en.Wikipedia.org/wiki/Byzantine_Fault_Tolerance
  http://pages.CS.Wisc.edu/~sschang/OS-Qual/reliability/byzantine.htm
  http://research.Microsoft.com/users/lamport/pubs/byz.pdf

ms> and linux-raid / mdadm did not complain or do anything.

The mystic version of Linux-RAID is in psi-test right now :-).


To me RAID does not seem the right abstraction level to deal with
this problem; and perhaps the file system level is not either,
even if ZFS tries to address some of the problem.

However there are ominous signs that the storage version of the
Byzantine generals problem is happening in particularly nasty
forms. For example as reported in this very very scary paper:

  https://InDiCo.DESY.DE/contributionDisplay.py?contribId=65&sessionId=42&confId=257

where some of the causes have been apparently identified recently,
see slides 11, 12 and 13:

  http://InDiCo.FNAL.gov/contributionDisplay.py?contribId=44&amp;sessionId=15&amp;confId=805

So I guess that end-to-end verification will have to become more
common, but which form it will take is not clear (I always use a
checksummed container format for important long term data).
