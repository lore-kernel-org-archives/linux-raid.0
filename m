From: Lars =?UTF-8?B?VMOkdWJlcg==?= <taeuber@bbaw.de>
Subject: Re: How to grow RAID1 mirror on top of LVM?
Date: Tue, 29 Apr 2008 09:55:45 +0200
Message-ID: <20080429095545.305b2dfd.taeuber@bbaw.de>
References: <25F8EF57-9606-4217-B2D4-2DD3D8E064C4@cam.ac.uk>
	<18408.36712.100712.499844@notabene.brown>
	<20080428162556.00ee0d72.taeuber@bbaw.de>
	<A20315AE59B5C34585629E258D76A97C2C79A0@34093-C3-EVS3.exchange.rackspace.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <A20315AE59B5C34585629E258D76A97C2C79A0@34093-C3-EVS3.exchange.rackspace.com>
Sender: linux-raid-owner@vger.kernel.org
To: David Lethe <david@santools.com>
Cc: Neil Brown <neilb@suse.de>, Anton Altaparmakov <aia21@cam.ac.uk>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hallo David!

"David Lethe" <david@santools.com> schrieb:
> Lars:
> Even if you *could* do this, then your design would still be an awful=
 idea.  You'd effectively have a random I/O filesystem.  Any write on a=
 RAID1 disk would generate writes on all of the other disks.  Even with=
 a small number of RAID1 targets and default journaling, I wouldn't be =
surprised if a single application write translated into at least a doze=
n physical disk writes. =20
>=20
> What if (when) both the RAID1 & RAID6 became corrupted?  How would yo=
u proceed?  How would you propose the md engine deal with this?   What =
if you lose a disk on the RAID6 while expanding the LVM and have a bad =
sector on remaining disks, or fsck shows filesytem corruption while you=
 are expanding a md volume.=20
>=20
> Maybe you are starting to get the point.

No, sorry. I really don't understand. But maybe because I didn't tell d=
etailed enough what our systems looks like.

We have here two huge RAID6 systems, that are connected through a 10G E=
thernet switch. They are equally in size.
On these RAID6 we create LVs euqally in size and want them to be parts =
of a RAID1:

 RAID6    RAID6
monosan  duosan
  LV       LV             (multiple of)
    \     /     10GE
     RAID1
       |        10GE
      aoe
       |        1GE
     server               (multiple of)

>  What is preventing the md layer from doing what you want is that a h=
eck of a lot of code would have to be written,

But could you tell me what in the current =C2=BBdesign=C2=AB prevents u=
s to resize the LVs and the RAID1 on top?
When I understand it correctly the RAID information are written at the =
end of each accessible partition/LV.
What is different on an extended LV from a partition that is replaced w=
ith a bigger one?

[...]
Thanks
Lars

--=20
                            Informationstechnologie
Berlin-Brandenburgische Akademie der Wissenschaften
J=C3=A4gerstrasse 22-23                     10117 Berlin
Tel.: +49 30 20370-352           http://www.bbaw.de
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
