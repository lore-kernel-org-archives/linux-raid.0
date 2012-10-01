From: "=?ISO-8859-15?Q?Stefan_/*St0fF*/_H=FCbner?="
	<st0ff.npl@googlemail.com>
Subject: Re: MD RAID Bug 7/15/12
Date: Tue, 02 Oct 2012 00:27:56 +0200
Message-ID: <506A18EC.1040602@gmail.com>
References: <022FFCA9-5D0E-41DB-9617-202C6FAADD06@rightthisminute.com> <A65170A9-BE4D-4B22-B1CE-2FFE10928DDD@colorremedies.com> <5068B4BF.6000807@gmail.com> <B09EC2F5-55B5-48A8-B427-81277CF3D136@colorremedies.com>
Reply-To: st0ff@npl.de
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <B09EC2F5-55B5-48A8-B427-81277CF3D136@colorremedies.com>
Sender: linux-raid-owner@vger.kernel.org
To: Chris Murphy <lists@colorremedies.com>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Am 01.10.2012 00:16, schrieb Chris Murphy:
>=20
> On Sep 30, 2012, at 3:08 PM, Stefan /*St0fF*/ H=FCbner wrote:
>=20
>=20
>> Also off topic: 12 drives would be as "nearly unalignable" as 19 are=
=2E
>=20
> I'm not sure what you mean by unalignable. A separate question is if =
a 4K chunks size is a good idea, even with 24 disks, but I'm unsure of =
the usage and workload.
>=20
>=20
[...]
By that I mean that optimal alignment has to do with a reasonable chunk
size and an amount of data disks that is/should be a power of two.  If
you made a databases commit chunk size 64k, you'd create maybe a raid6
of 6 drives with a 16k chunk size.  That way you'd spare many many
read-modify-write operations, as on every commit it'd write all 6 disks
once and no rmw would happen.  You'd also have to take care of proper
partition placement.

That probably is what you know as alignment.  I just want to make it
more concious that not only the placement of a data partition goes into
alignment, also the size of a "normal" data packet relative to chunk
size and amount of disks used.

cheers,
stefan

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
