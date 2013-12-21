From: NeilBrown <neilb@suse.de>
Subject: Re: mdadm, spin down never happens, do spare work the same?
Date: Sat, 21 Dec 2013 11:10:01 +1100
Message-ID: <20131221111001.1fed992a@notabene.brown>
References: <BLU0-SMTP164EF98C4A2354CB5CE42AD98C40@phx.gbl>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/46yHNbf/O3ALhPCqz0P9p9M"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <BLU0-SMTP164EF98C4A2354CB5CE42AD98C40@phx.gbl>
Sender: linux-raid-owner@vger.kernel.org
To: Wilson Jonathan <piercing_male@hotmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/46yHNbf/O3ALhPCqz0P9p9M
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 20 Dec 2013 23:56:14 +0000 Wilson Jonathan
<piercing_male@hotmail.com> wrote:

> I've noticed that with an active mdadm raid that there seems to be a
> periodic polling of the devices in the array which prevents the drives
> ever going into various slumber modes... and it also doesnt seem to make
> a difference if the file system on the array is mounted or not (slightly
> subjective as its more an observation than an in-depth testing).
>=20
> I'm guessing its to make sure the array is "ok" and is also used to
> update things such as /proc/mdstat and maybe other things related, so
> every now and then it goes "hi, are you there disks, whats your current
> state" for want of a better idea of the process.
>=20
> What I'm wondering is how mdadm treats the "spare" drives, does it also
> poll them periodically to the same time constraints as the active drives
> or does it just check at re-boot and maybe some other periodic time
> scales...
>=20
> The reason for enquiring is if a "spare" drive is kept alive to the same
> extent as a "live/active" drive then it means that a spare could have
> been powered up and accessed for the exact same time as a running
> "active" set of drives... which means that even though its never been
> used it could have had the same amount of time "live/spinning" as the
> existing arrays drives which would mean it is just as likely to fail due
> to [running] age as any other drive within the array, if however its
> only polled very sporadically (boot, maybe once a month, some other
> amount) then its "active life" is drastically shortened, which would
> mean its (to some degree) less likely to fail when its updated as a
> "live disk" when another member has failed... obviously baring spin up
> counts and other "power up=3Dold=3Dpre-fail" issues.
>=20
> Thanks in advance.
>=20
> Jon
>=20
>

Nope.  md doesn't 'poll' devices at all.
if you ask to read from the array, it reads from devices.
If you ask to write to the array, it writes to devices (and maybe reads)
if you ask it to 'check' the array, it does.
IF it notices a spare and a missing device, it performs recovery.
If there is nothing to do, it does nothing.

What evidence do you have which led you to suspect some polling activity.

NeilBrown

--Sig_/46yHNbf/O3ALhPCqz0P9p9M
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBUrTcXznsnt1WYoG5AQJQLw/+K2L8848sSOhdgirBzoNvf3THL4umb/7s
lUdDUt1aUgwz4Z8znUcys3NmZnNv1U78iGATbppsywIQMLd8178NCSKsbUsb3HlQ
809p0nG+2SrJTlh6+Y9VcXOqwaMFpeeaKOAXhjPPmys0wsCPDNPoL4zhI2AHfwV1
esqGhKxGOaudJKTQlsobcpUox5ueYbAZmSU04f8qExvRxK8kjawxYh3A1Nzg0Rde
X8fTB+6wHppGq5tKJmyIcx4BKSU6HDUZWrxg0qUZvafs5uSnBrU2naPjqgh6lnsV
AEYOMz3tQ0+o9W3CNbF0B8JN2Utmdbs1AbCO98BOhMcVDfGSTsRXsZqXfE638DLW
f0A4exRONqkzHw181hBfC4/NTzmjBdX8yzEpZ0ca6KujXd154VBXHUnY2mrbJHnB
HDXTEqRBl+oiAlIAaauVwGz0cLsERx0ICTAMNWp9L/fzrntDBva1mirH02pLpZz4
otexj57h+LuAzRTsjCaH3y+SWbTgAP7RtOoDpTaINJnLM+6/mwpvteHzjzCyZAn3
52eHpOp3TwbiyONIAssPhzRvt/spy2/Q2pRmwkhJfHkuYQGcCRFjXq1P32F/HQhR
ispj3QSGMi2L61WMVtVR1JLrMqK7Ecgwq4rB8z8MD2oiH2BhD8he/A05lVDVxbgU
WWlRabWPgVI=
=GRLD
-----END PGP SIGNATURE-----

--Sig_/46yHNbf/O3ALhPCqz0P9p9M--
