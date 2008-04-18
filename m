From: "David Lethe" <david@santools.com>
Subject: RE:  Re: Need some information and help on mdadm in order to support it on IBM z Systems
Date: Fri, 18 Apr 2008 08:45:13 -0500
Message-ID: <A20315AE59B5C34585629E258D76A97C087BA3@34093-C3-EVS3.exchange.rackspace.com>
References: <OF9FBFD1B1.E511C96F-ONC1257428.004472D1-C1257428.004493A0@de.ibm.com> <47FF7831.20707@tmr.com> <OF70B5DB7B.09FE2CC6-ONC125742B.0032A67D-C125742B.003CF42B@de.ibm.com> <4804F9FD.4070606@tmr.com> <OF759BAE37.32591658-ONC125742D.004F2D87-C125742D.00543FEE@de.ibm.com> <fu9qlp$iaj$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-class: urn:content-classes:message
In-Reply-To: <fu9qlp$iaj$1@ger.gmane.org>
Sender: linux-raid-owner@vger.kernel.org
To: Mario 'BitKoenig' Holbe <Mario.Holbe@TU-Ilmenau.DE>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Well, I can name many RAID controllers that will automatically add a
"faulty" drive back into an array.  This is a very good thing to have,
and is counter-intuitive to all but experienced RAID architects. 

Seeing how the OP works for IBM, then I'll use the IBM Profibre engine
as an example of an engine that will automatically insert a "known bad"
disk.  Infortrend engines actually have a menu item to force an array
with a "known bad" disk online.  Several LSI-family controllers have
this feature in their API, and as a backdoor diagnostic feature.  Some
of the Xyratex engines give this to you. 

I can go on by getting really specific and citing firmware revisions,
model numbers, and so on ... but what do I know ... I just write
diagnostic software, RAID configurators, failure/stress testing,
failover drivers, etc.

To be fair, there are correct ways to reinsert these bad disks, and the
architect needs to do a few things to minimize data integrity risks, and
repair them as part of the reinsertion process.  As this is a  public
forum I won't post them but will instead, speak in generalities to make
my point.  There are hundreds of published patents concerning data
recovery and availability in various failure scenarios, so anybody who
wants to learn more can simply search the USPTO.GOV database and read
them for themselves.  

A few real-world reasons you want this capability ...
* Your RAID system consists of 2 external units, with RAID controller(s)
and disks in unit A, and unit B is an expansion chassis, with
interconnecting cables.  You have a LUN that is spread between 2
enclosures.  Enclosure "B" goes offline, either because of a power
failure; a sysadmin who doesn't know you should power the RAID head down
first, then expansion; or he/she powers it up backwards .. bottom line
is that the drive "failed", but it only "failed" because it was
disconnected due to power issues.  Well architected firmware needs to be
able to recognize this scenario and put the disk back.   
* When a disk drive really does fail, then, depending on the type of
bus/loop structure in the enclosure, and quality of the backplane
architecture, other disks may be affected and may not be able to respond
to I/O for a second or so. If the RAID architecture aggressively fails
disks in this scenario then you would have cascade effects that knock
perfectly good arrays offline.
* You have a hot swap array where disks are not physically "locked" in
an enclosure, and the removal process starts by pushing the drive in..
Igor the klutz leans against the enclosure the wrong way and the drive
temporarily gets disconnected .. but he frantically pushes it back in.
You get the idea, it happens.

The RAID engine (or md software) needs to be more intelligent an be able
to recognize the difference between a drive failure and a drive getting
disconnected

Now to go back to the OP and solve his problem.  Use a special connecter
and extend a pair of wires outside the enclosure that breaks power. If
this is a fibre-channel backplane, then you should also have external
wires to short out loop A and/or loop B in order to inject other types
of errors. My RAID testing software (not trying to plug it, just telling
you some of the things you can do so you can write it yourself) sends a
CDB to tell the disk to perform a mediainit command, or commands a disk
to simply spin down.  Well-designed RAID software/firmware will handle
all of these problems differently.  While on subject, your RAID testing
software needs to be able to create ECC errors on any disk/block you
need to, so you can combine these "disk" failures with stripes that have
both good and bad parity.   (Yes, kinda sorta plugging myself as a hired
gun again, but.. ) if your testing scenario doesn't involve creating ECC
errors and running non-destructive data and parity testing in
combination with simulated hardware failures, then your testing, not
certifying.

To go back to Mario's argument that you *could* make things far worse ..
absolutely. The RAID architect needs to incorporate hot-adding md disks
back into the array, as long as it is done properly.  RAID recovery
logic is perhaps 75% of the source code for top-of-the-line RAID
controllers. Their firmware determines why a disk "failed", and does
what it can to bring it back online and fix the damage.  A $50 SATA RAID
controller has perhaps 10% of the logic dedicated to failover/failback.

The md driver is somewhere in the middle.  I'll end this post by
reminding the md architects to consider how many days it takes to
rebuild a RAID-5 set that uses 500GB or larger disk drives, and how
unnecessary this action can be under certain failure scenarios.

David @ SANtools ^ com

-----Original Message-----
From: linux-raid-owner@vger.kernel.org
[mailto:linux-raid-owner@vger.kernel.org] On Behalf Of Mario 'BitKoenig'
Holbe
Sent: Friday, April 18, 2008 4:46 AM
To: linux-raid@vger.kernel.org
Subject: Re: Need some information and help on mdadm in order to support
it on IBM z Systems

Jean-Baptiste Joret <JORET@de.ibm.com> wrote:
> the scenario actually involves simulating a hardware connection issue
for 
> a few seconds and bring it back online. But once the hardware comes
back 
> online it is still do not come back into the array an remains marked 
> "faulty spare". Moreover, if you then reboot, the mirror comes up and
you 
> can mount it but it is degraded and my "faulty spare" is now removed:

This is just the normal way md deals with faulty components. And even
more: I personally don't know any (soft or hard) RAID solution that
would automatically try to re-add faulty components back to an array.
I personally would also consider such an automatic re-add a really bad
idea. There was a reason for the component to fail, you don't want to
touch it again without user intervention - it could make things far more
worse (blocking busses, reading wrong data etc.). A user who knows
better can of course trigger the RAID to touch it again - for md it's
just the way you described already: remove the faulty component from the
array and re-add it.

Being more "intelligent" regarding such an automatic re-add would
require a far deeper failure analysis to decide whether it would be safe
to try re-adding it or better leave it untouched. I don't know any
software yet that would be capable to do so.

Afaik, since a little while md contains one such automatism regarding
sector read errors where it automatically tries to re-write this sector
to the failing disk to trigger disk's sector-reallocation. I personally
even consider this behaviour quite dangerous, since there is no
guarantee that this read-error really occured due to a (quite harmless)
single-sector failure and thus, IMHO even there is a chance to make
things more worse by touching the failing disk again per default.


regards
   Mario
-- 
Computer Science is no more about computers than astronomy is about
telescopes.                                       -- E. W. Dijkstra

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html


