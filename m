From: =?ISO-8859-1?Q?G=FCnther_J=2E?= Niederwimmer <gjn@gjn.priv.at>
Subject: Hello,Re: GPT Table broken on a Raid1
Date: Sun, 23 Sep 2012 08:47:01 +0200
Message-ID: <1822898.lj0EyHG9Nm@techz>
References: <4961154.0TR9MeFlIq@techz> <1718683.C0AtuyUDq1@techz> <FF5F85AF-C7AA-4EA0-9871-26A87A28690F@colorremedies.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <FF5F85AF-C7AA-4EA0-9871-26A87A28690F@colorremedies.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello,

Am Samstag, 22. September 2012, 12:30:28 schrieb Chris Murphy:
> On Sep 22, 2012, at 2:37 AM, G=FCnther J. Niederwimmer wrote:
> > But I mean I have read in the changelog from parted 3.1, it is a Ra=
id(1)
> > GPT Error Bug corrected ?
>=20
> I don't think this is related to parted, honestly. Did you partition =
sda and
> sdb before you created the RAID container? I think the problem is tha=
t the
> IMSM metadata has stepped on the GPT secondary partition at the end o=
f the
> sda and sdb, that's what you original post indicates.
>=20
> I could be wrong but it seems like the problem is that sda and sdb sh=
ouldn't
> even have a GPT in the first place, they should just be treated as ra=
w
> physical devices for Intel Raid to take over, and you'd only create a=
 GPT
> for the virtual device (the array) within. If correct, the way to get=
 rid
> of the kernel GPT error messages would be to remove the unnecessary G=
PT
> structures from sda and sdb, leaving only the IMSM metadata intact.

My steps to install a computer with dualboot, but I can also install Li=
nux=20
alone with the same result.=20

I create the Array's with the on board BIOS run indexing the I run a To=
ol most=20
"diskpart" (dualboot) to create a GPT Table.

Install method is EFI.

afterward I install win7 =20

The next step is to install a Linux (most openSUSE)

or=20

Install Linux on a BIOS created Array (Raid1 or Raid10) for a Server

create a GPT Table

the result are the same.

OK, the system is running but never start parted or a other tool and sa=
y to=20
anything yes, then you have a destroyed system :(.=20


--=20
mit freundlichen Gr=FC=DFen / best Regards.

  G=FCnther J. Niederwimmer
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
