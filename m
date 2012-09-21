From: =?ISO-8859-1?Q?G=FCnther_J=2E?= Niederwimmer <gjn@gjn.priv.at>
Subject: Re: GPT Table broken on a Raid1
Date: Fri, 21 Sep 2012 13:42:21 +0200
Message-ID: <1361158.MkTZ6QR6cp@techz>
References: <4961154.0TR9MeFlIq@techz> <2627519.Y2VdWh5VBI@techz> <1BDFB79A-E375-47F2-8EDF-8F51D8774651@colorremedies.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1BDFB79A-E375-47F2-8EDF-8F51D8774651@colorremedies.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello Chris,

Am Donnerstag, 20. September 2012, 11:34:12 schrieb Chris Murphy:
> On Sep 20, 2012, at 5:05 AM, G=FCnther J. Niederwimmer wrote:
> > this is "normal" I install "windows 7" first ;). but the problem wi=
th the
> > wrong GPT Table Message I have also on a Raid10 with "Intel Matrix
> > Storage"
> > and dmraid installation.
>=20
> OK you didn't answer my question about what mdadm metadata version yo=
ur md
> RAID is using. If it's 1.0 instead of 1.2 that could be the culprit.
> > The Question is, work parted correct with Raid GPT Table?

Thank you for the answer.

excuse ;).

OK.

I have=20
mdadm-3.2.5-3.7.1
parted 2.4.-24.2.2

on the computer.
=20
> Could be a bug in parted 2.3, which is old. Try using parted 3.0.

I will search ;)

> Another question is, do you really think it's a good idea to be mixin=
g
> different RAID implementations on the same physical devices, which al=
so
> appear to contain boot volumes?

My installing is, win7 on the Raid1 GPT EFI the Raid1 have Partitions, =
5 for=20
NTFS and one ext4 for the "/Home" Direktory

My Linux is on a SSD, SSD is also GPT EFI formated.

>=20
> I think one of your RAID implementations is stepping on the GPT secon=
dary
> header. I've seen this before in a BIOS "fakeraid" implementation. So=
 I
> would look at all of your RAID implementations, make sure they're usi=
ng the
> latest versions.

Yes, it is a Intel Matrix Storage System, the Board is a DX58SO2 with l=
ast=20
Bios & Firmware for the "fakeraid" ;)

my question is,  win can work with no Problem on the "Fakeraid" and a G=
PT=20
Table. Could it be, that the kernel or / and parted have a Problem with=
 the=20
GPT Table on a Raid1 or a Raid10 Fakeraid ?

I have this Problem on all my three Systems (Intel), also on my Small 1=
9"=20
Intel Server.

--=20
mit freundlichen Gr=FC=DFen / best Regards.

  G=FCnther J. Niederwimmer
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
