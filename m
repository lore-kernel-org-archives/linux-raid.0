From: "Martin Bene" <martin.bene@icomedias.com>
Subject: AW: Raid 1 vs 5 ?
Date: Fri, 7 May 2004 08:14:16 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <FA095C015271B64E99B197937712FD02262E66@freedom.grz.icomedias.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-class: urn:content-classes:message
To: John Lange <john.lange@bighostbox.com>
Cc: LinuxRaid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

> First, why do we skip sdx3 and sdx4 on each disk and go 
> directly to sdx5
> for partition numbers?

Just habit I guess; usually I've got a couple of data partitions, so I
will have to have some extended partitions; to make things more similar
between systems I tend to put "special" stuff (boot, swap, possibly a
rescue system) on primary partitions and have / as the first extended
partition.

> Second, I'm very confused by the way you divided up the raid sets....
> I'm thinking you erred? I'm such a newb its possible I really don't
> understand whats going on so hopefully you can verify.
> 
> md0: did you mean sda1 sdb1 sdc1 sdd1 ?
> md1: did you mean sda2 sdb2 ?
> md2: did you mean sdc2 sdd2 ?
> md3: did you mean sda5 sdb5 sdc5 sdd5 ?

ARGH - never write to mailinglists without adequate amounts of coffee.
You're of course right, I messed up.

> And last, is it possible to build the system from the 
> beginning on RAID?

Yes :-)

> I'm using slackware. I see there is a section in the how-to for
> converting a red hat system after the fact but obviously it would be
> easier if I didn't have to do that.

Problem is, it depends on the installer / installation process. I know
that redhat installer supports setup of raid, I've often st up gentoo
using raid but it's too long since I installed slackware so I don't know
if/how to go about installing right onto raid.

Bye, Martin

