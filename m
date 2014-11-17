From: Chris Murphy <lists@colorremedies.com>
Subject: Re: Raid 6 Fail Event
Date: Mon, 17 Nov 2014 10:19:26 -0700
Message-ID: <AB2BF2A1-8D2D-4AC0-920F-1D182875A31B@colorremedies.com>
References: <em90cf29a7-2a88-4bcc-a6fa-eca2cd446449@littlez>
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.6\))
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <em90cf29a7-2a88-4bcc-a6fa-eca2cd446449@littlez>
Sender: linux-raid-owner@vger.kernel.org
To: Justin Stephenson <justin@evensteveninc.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


On Nov 16, 2014, at 6:34 PM, Justin Stephenson <justin@evensteveninc.co=
m> wrote:

> Thank-you, Chris. I appreciate your help with this.
>=20
> Backup are good. I'm a regular disk to disk to LTO guy. Here is what =
I have turned up:
>=20
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D
> # smartctl -x /dev/sdh
>=20
> big long list of stuff.

Please post it.



> I found the serial.
>=20
> I also tried smartctl -H /dev/sdh and received
>=20
> Overall-health self-assesment test restul: PASSED
>=20
> 184 End-to-End_Error {flag value worst thresh} Old_age FAILING_NOW_6

Cute, it=92s failing but it=92s overall health is passing. This is a gr=
eat example of why the health self-assess is useless.


>=20
> I did not find anything for the serial in results from dmesg
>=20
> # smartctl -l scterc /dev/sdh
>=20
> Warning: device does not support SCT Commands

Interesting it supports a SMART IV attribut but doesn=92t support SCT c=
ommands.


>=20
> # cat /sys/block/sdh/device/state
>=20
> Running
>=20
> # cat /sys/block/sdh/device/timeout
>=20
> 30

Since the drives you have don=92t support SCT commands, you need to set=
 the command timer to something much more than the default of 30, other=
wise your array will not function correctly when it encounters bad sect=
ors. In many cases the linux scsi command timer will reach 30 seconds a=
nd reset the interface, before the typical consumer drive recovers (eit=
her returns data successfully or an error). This could be quite long, m=
aybe 2 minutes. Future drives you buy should have configurable SCT ERC =
so the drive can be set to return a read error after something like 7 s=
econds, i.e. you want the drive to give up sooner, and by informing md =
of the problem sector range, the data is rebuilt from parity and writte=
n back to the bad sectors on the drive where the problem gets fixed.




>=20
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D
>=20
> Should I replace the drive or re add and resync?

Well I don=92t know anything about attribute 184 End-to-End error, but =
based on the description in wikipedia it sounds disqualifying to me.

I personally would get the drive replaced no matter what: either under =
warranty, or if no warranty I=92d get a new drive and test/play with th=
is one offline and if it proves its worth then maybe it can be a spare =
down the road.

But you could also smartctl -x all the other drives and see what value =
they have for this attribute.

>=20
> I also went through and reseated all the SATA and power connections a=
s I understand these can cause issues as well.




Chris Murphy--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
