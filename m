From: "David Lethe" <david@santools.com>
Subject: RE: Need some information and help on mdadm in order to support it on IBM z Systems
Date: Sun, 20 Apr 2008 11:24:34 -0500
Message-ID: <A20315AE59B5C34585629E258D76A97C087DEE@34093-C3-EVS3.exchange.rackspace.com>
References: <OF9FBFD1B1.E511C96F-ONC1257428.004472D1-C1257428.004493A0@de.ibm.com><47FF7831.20707@tmr.com><OF70B5DB7B.09FE2CC6-ONC125742B.0032A67D-C125742B.003CF42B@de.ibm.com><4804F9FD.4070606@tmr.com><OF759BAE37.32591658-ONC125742D.004F2D87-C125742D.00543FEE@de.ibm.com><fu9qlp$iaj$1@ger.gmane.org><A20315AE59B5C34585629E258D76A97C087BA3@34093-C3-EVS3.exchange.rackspace.com> <18443.18427.512815.652823@tree.ty.sabi.co.uk>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-class: urn:content-classes:message
In-Reply-To: <18443.18427.512815.652823@tree.ty.sabi.co.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Peter Grandi <pg_lxra@lxra.for.sabi.co.UK>, Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Well, I can't formerly speak for IBM, EMC, LSI, NetApp, and others when
I say you are wrong in just about everything you wrote. Their
architectures are "absolutely crazy", and their firmware doesn't meet
your personal criteria for being "well-architected".  Qlogic, Emulex and
LSI are also wrong since they have vanity firmware/drivers for specific
RAID subsystems to increase interoperability between all of the RAID
hardware/software layers.

Now contrast zfs with md+filesystemofyourchoice.  The performance,
reliability, security, data integrity, and self-healing capability of
zfs are as profoundly superior to md and your design philosophy, as the
current md architecture is to MS-DOS/FAT.

The empirical evidence speaks for itself.  The RAID hardware vendors and
the architects of zfs spend billions of dollars annually on R&D, have
superior products, and do it my way, not yours.  If you want to respond
with a flame, then take it to a zfs group. I see no need to respond
further.


-----Original Message-----
From: linux-raid-owner@vger.kernel.org
[mailto:linux-raid-owner@vger.kernel.org] On Behalf Of Peter Grandi
Sent: Sunday, April 20, 2008 8:41 AM
To: Linux RAID
Subject: Re: Need some information and help on mdadm in order to support
it on IBM z Systems

[ ... ]

> Well, I can name many RAID controllers that will automatically
> add a "faulty" drive back into an array.  This is a very good
> thing to have, and is counter-intuitive to all but experienced
> RAID architects.

It is not counter-intuitive, it is absolutely crazy in the
general case, and in particular cases it leads to loss of focus
and mingling of astractions layers that should remain separate.

[ ... ]

> There are hundreds of published patents concerning data
> recovery and availability in various failure scenarios, so
> anybody who wants to learn more can simply search the
> USPTO.GOV database and read them for themselves.

Sure, those are heuristics that are implemented on top of a RAID
subsystem, and that are part of a ''computer assisted storage
administration'' logic. Just like IBM developed many years ago
expert systems to automate or assist with recovery from various
faults (not just storage faults) on 370/390 class mainframes.

Such recovery tools have nothing to do with RAID as such, even
if they are often packaged with RAID products. They belong in a
totally different abastraction layer, as this example makes
starkly clear:

> A few real-world reasons you want this capability ...
> * Your RAID system consists of 2 external units, with RAID
>   controller(s) and disks in unit A, and unit B is an
>   expansion chassis, with interconnecting cables. You have a
>   LUN that is spread between 2 enclosures. Enclosure "B" goes
>   offline, either because of a power failure; a sysadmin who
>   doesn't know you should power the RAID head down first, then
>   expansion; or he/she powers it up backwards .. bottom line
>   is that the drive "failed", but it only "failed" because it
>   was disconnected due to power issues.
> [ ... ]

This relies on case-based expert-system like fault analysis and
recovery using knowledge of non-RAID aspects of the storage
subsystem.

Fine, but it has nothing to do with RAID -- as it requires a
kind of ''total system'' approach.

> Well architected firmware needs to be able to recognize this
> scenario and put the disk back.

Well architected *RAID* firmware should do nothing of the sort.

RAID has a (deceptively) simple operation model and yet getting
RAID firmware right is hard enough.

Well architected fault analysis and recovery daemons might well
recognize that scenario and put the disk back, but that's a
completely different story from RAID firmware doing that.

> To go back to Mario's argument that you *could* make things
> far worse ..  absolutely.

Sure, because fault analysis and recovery heuristics take
chances that can go spectacularly wrong, as well as being pretty
hard to code too.

While I am not however against optional fault analysis and
recovery layers on top of RAID, I really object to statements
like this:

> The RAID architect needs to incorporate hot-adding md disks
> back into the array, as long as it is done properly.

Becase the RAID architect should stay well clear of considering
such kind of issues, and of polluting the base RAID firmware
with additional complications; even the base RAID logic is
amazingly bug infested in various products I have had the
misfortune to suffer.

The role of the RAID achitect is to focus on the performance and
correctness of the basic RAID logic, and let the architects of
fault analysis and recovery daemons worry with other issues, and
perhaps to provide suitable hooks to them to make their life
easier.

> RAID recovery logic is perhaps 75% of the source code for
> top-of-the-line RAID controllers. Their firmware determines
> why a disk "failed", and does what it can to bring it back
> online and fix the damage.

There is a rationale for bundling a storage fault analysis and
recovery daemon into a RAID host adapter, but I don't like that,
because often there are two downside:

* Fault analysis and recovery usually are best done at the
  highest possible abstraction level, that is as software
  daemons running on the host, as they have more information
  than a daemon running inside the host adapter.

* Mingling fault analysis and recovery software with the base
  RAID logic (as the temptation then becomes hard to resist)
  tends to distract from the overridingly important task of
  getting the latter to perform reliably and to report errors
  clearly and usefully.

In previous discussions in this list there were crazy proposals
to make part of the Linux RAID logic some detection )not too
bad) and recovery (chancy horror) from (ambiguous) unreported
errors and the reason why I am objecting strenuously here is to
help quash calls for something insane like that.

Separation of concerns and of abstractions layers and keeping
fundamental firmware logic simple are rather important goals
in mission critical subsystems.

> A $50 SATA RAID controller

Except perhaps the IT8212 chips these don't exist :-).

> has perhaps 10% of the logic dedicated to failover/failback.

That 10% is 10% too many. It is already difficult to find
simple, reliable RAID host adapters, never mind get RAID host
adapters that try to be too clever.
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html


