From: "Daniel Korstad" <dan@korstad.net>
Subject: RE:  XFS on x86_64 Linux Question
Date: Sat, 28 Apr 2007 09:53:59 -0500
Message-ID: <1487079138.1177772039666.JavaMail.root@gateway.korstad.net>
References: <H00000680010301f.1177756626.www.korstad.net@MHS>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <H00000680010301f.1177756626.www.korstad.net@MHS>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: jpiszcz@lucidpixels.com
List-Id: linux-raid.ids



Short answer, yep, I have done it.=20

=20

I don't know exactly what you are looking for, or what tools you need.=C2=
=A0
The follow is my very recent experience.=20

=20

I have a FC4=C2=A0 x86_64 that I have been using for awhile.=C2=A0 I ha=
ve a
raided OS (raid 1on using the two separate IDE controllers) and raided =
data
drives (9 in a RAID6 on SATA controllers)=20

=20

I had replace the original OS drives with larger ones.=C2=A0 I wanted t=
o take
the new larger drives=E2=80=99 capacity and put that in the ext3 fs on =
the raid 1.=20

=20

Last night I did this on the system;=20

mdadm --grow /dev/md0 --size=3Dmax=20

=20

But I had older resize2fs, it does not support ext resize on a live mou=
nt
filesystem, and since this partition was my / partition...=20

=20

I rebooted my system with knoppix and did;=20

=20

mdadm --assemble /dev/md0 /dev/hda1 /dev/hdc1=20

fsck.ext /dev/md0=20

resize2fs /dev/md0=20

=20

And reboot back to operational without any problems.=20

=20

My data raid6 is on a XFS.=C2=A0 It support live filesystem expansion
(xfs_growfs while mounted).=C2=A0=C2=A0 I have not done anything with m=
y xfs in
knoppix but I am sure some tools are in there too.=20

=20

This is not a thorough test of tools on knoppix on my 64bit system but =
from my
experience, I can boot into it and assemble my raid within it.=20

=20

Dan.


=20

----- Inline Message Follows -----=20

To: xfs@oss.sgi.com=20

Cc: linux-raid@vger.kernel.org=20

=46rom: Justin Piszcz=20

Subject: Re: XFS on x86_64 Linux Question=20

=20


With correct CC'd address.=20
=20
=20
On Sat, 28 Apr 2007, Justin Piszcz wrote:=20
=20
> Hello--=20
>=20
> Had a quick question, if I re-provision a host with an Intel Core Duo=
 CPU =20
> with x86_64 Linux; I create a software raid array and use the XFS =20
> filesystem-- all in 64bit space...=20
>=20
> If I boot a recovery image such as Knoppix, it will not be able to wo=
rk on =20
> the filesystem correct?=C2=A0=C2=A0I would need a 64bit live CD?=20
>=20
> Does the same apply to software raid?=C2=A0=C2=A0Can I mount a softwa=
re raid created in =20
> a 64bit environment in a 32bit environment?=20
>=20
> Justin.=20
>=20
-=20
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n=20
the body of a message to majordomo@vger.kernel.org=20
More majordomo info at=C2=A0=C2=A0http://vger.kernel.org/majordomo-info=
=2Ehtml=20
=20

-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
