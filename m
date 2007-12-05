From: Leif Nixon <nixon@nsc.liu.se>
Subject: Re: raid6 check/repair
Date: Wed, 05 Dec 2007 10:00:33 +0100
Message-ID: <m3tzmx1pou.fsf@unna.nsc.liu.se>
References: <474431BF.30103@ph.tum.de>
	<18244.64972.172685.796502@notabene.brown>
	<4745B375.4030500@ph.tum.de>
	<18254.21949.441607.134763@notabene.brown>
	<474F4880.8080300@eyal.emu.id.au> <47502140.1080601@ph.tum.de>
	<1196650421.14411.10.camel@elara.tcw.local>
	<47546019.5030300@ph.tum.de>
	<18261.49547.588360.436369@base.ty.sabi.co.UK>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <18261.49547.588360.436369@base.ty.sabi.co.UK> (Peter Grandi's message of "Tue\, 4 Dec 2007 21\:07\:23 +0000")
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

pg_lxra@lxra.for.sabi.co.UK (Peter Grandi) writes:

> ms> I just want to give another suggestion. It may or may not be
> ms> possible to repair inconsistent arrays but in either way some
> ms> code there MUST at least warn the administrator that
> ms> something (may) went wrong.
>
> tn> Agreed.
>
> That sounds instead quite extraordinary to me because it is not
> clear how to define ''inconsistency'' in the general case never
> mind detect it reliably, and never mind knowing when it is found
> how to determine which are the good data bits and which are the
> bad.

I don't quite follow you. Having a basic consistency check utility for
a raid array is to me as obvious as having an fsck utility for a file
system.

> Now I am starting to think that this discussion is based on the
> curious assumption that storage subsystems should solve the so
> called ''byzantine generals'' problem, that is to operate reliably
> in the presence of unreliable communications and storage.

I don't think anyone is proposing to solve that problem. However, an
occasional slight nod in acknowledgment of the fact that real world
communications and storage *are* unreliable wouldn't be out of place.

-- 
Leif Nixon                       -            Systems expert
------------------------------------------------------------
National Supercomputer Centre    -      Linkoping University
------------------------------------------------------------
