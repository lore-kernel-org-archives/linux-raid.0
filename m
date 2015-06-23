From: Jared Mauch <jared@puck.nether.net>
Subject: Re: (R) in mdstat output, clean && degraded
Date: Tue, 23 Jun 2015 17:21:48 -0400
Message-ID: <F30009F6-7BF5-4786-A3A6-04C5C49B8E0C@puck.nether.net>
References: <51364598-D6AA-43E7-B9A1-C3C09255D3D4@puck.nether.net> <5589BDCA.5050801@turmel.org>
Mime-Version: 1.0 (Mac OS X Mail 8.2 \(2102\))
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5589BDCA.5050801@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>
Cc: linux-raid@vger.kernel.org, NeilBrown <neilb@suse.de>
List-Id: linux-raid.ids


> On Jun 23, 2015, at 4:12 PM, Phil Turmel <philip@turmel.org> wrote:
>=20
> Hi Jared,
>=20
> On 06/23/2015 02:56 PM, Jared Mauch wrote:
>> I=E2=80=99ve been searching high and low the past few days and have =
been unable to diagnose what this (R) is in my raid1 mdstat output indi=
cates.
>=20
> Replacement device.

Yeah, I inferred that from the device role below, but I also wanted=20
something that google would index well for others to confirm.

>> It seems something is =E2=80=98stuck=E2=80=99 somehow as I=E2=80=99m=
 not sure how the array is both clean and degraded at the same time.
>=20
> Role '0', currently sdd1, is being replaced with sdg1.  Both appear t=
o
> be working as expected and are therefore individually 'clean'.  Role =
'1'
> is missing, and therefore the array as a whole is degraded.
>=20
> Looks to me like you lost a device and should have used --add to put =
a
> new device into service, but you used --replace instead.  --replace i=
s
> for use when a functioning device shows signs of failing and is to be
> replaced 'on-the-fly=E2=80=99.

I=E2=80=99ve tried doing a few things including repair to see what it w=
ill do
but when it completes it=E2=80=99s in the same end-state.


> [trim /]
>=20
>>   Device Role : Replacement device 0
>>   Array State : R. ('A' =3D=3D active, '.' =3D=3D missing, 'R' =3D=3D=
 replacing)
>=20
> However, the array doesn't seem to be making progress on the replacem=
ent
> (didn't even start ?), so this pathological situation might have
> triggered a bug in the resync code.

Let me know what debugging/details might be interesting to collect. =20

Based on the Events# being in-sync, I am going to assume that the drive=
s
may be operating in a protected-type mode even if the output doesn=E2=80=
=99t
concur.

I can say this state seems to survive reboots.

- Jared--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
