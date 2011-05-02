From: Ben Hutchings <ben@decadent.org.uk>
Subject: Re: Bug#624343: linux-image-2.6.38-2-amd64: frequent message "bio
 too big device md0 (248 > 240)" in kern.log
Date: Mon, 02 May 2011 02:04:18 +0100
Message-ID: <1304298258.2833.125.camel@localhost>
References: <20110427161901.27049.31001.reportbug@servo.factory.finestructure.net>
	 <1304051980.3105.46.camel@localhost>
	 <8739kyf53e.fsf@servo.factory.finestructure.net>
	 <1304294457.2833.111.camel@localhost>  <4DBDFE0C.3000304@fifthhorseman.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha512"; protocol="application/pgp-signature"; boundary="=-3SaXzk4AdGrlfyejgzFU"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4DBDFE0C.3000304@fifthhorseman.net>
Sender: linux-raid-owner@vger.kernel.org
To: Daniel Kahn Gillmor <dkg@fifthhorseman.net>
Cc: 624343@bugs.debian.org, Jameson Graef Rollins <jrollins@finestructure.net>, NeilBrown <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--=-3SaXzk4AdGrlfyejgzFU
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, 2011-05-01 at 20:42 -0400, Daniel Kahn Gillmor wrote:
> On 05/01/2011 08:00 PM, Ben Hutchings wrote:
> > On Sun, 2011-05-01 at 15:06 -0700, Jameson Graef Rollins wrote:
> >> Hi, Ben.  Can you explain why this is not expected to work?  Which par=
t
> >> exactly is not expected to work and why?
> >=20
> > Adding another type of disk controller (USB storage versus whatever the
> > SSD interface is) to a RAID that is already in use.
> >=20
>  [...]
> > The normal state of a RAID set is that all disks are online.  You have
> > deliberately turned this on its head; the normal state of your RAID set
> > is that one disk is missing.  This is such a basic principle that most
> > documentation won't mention it.
>=20
> This is somewhat worrisome to me.  Consider a fileserver with
> non-hotswap disks.  One disk fails in the morning, but the machine is in
> production use, and the admin's goals are:
>=20
>  * minimize downtime,
>  * reboot only during off-hours, and
>  * minimize the amount of time that the array is spent de-synced.
>=20
> A responsible admin might reasonably expect to attach a disk via a
> well-tested USB or ieee1394 adapter, bring the array back into sync,
> announce to the rest of the organization that there will be a scheduled
> reboot later in the evening.
>=20
> Then, at the scheduled reboot, move the disk from the USB/ieee1394
> adapter to the direct ATA interface on the machine.
>=20
> If this sequence of operations is likely (or even possible) to cause
> data loss, it should be spelled out in BIG RED LETTERS someplace.

So far as I'm aware, the RAID may stop working, but without loss of data
that's already on disk.

> I don't think any of the above steps seem unreasonable, and the set of
> goals the admin is attempting to meet are certainly commonplace goals.
>=20
> > The error is that you changed the I/O capabilities of the RAID while it
> > was already in use.  But what I was describing as 'correct' was that an
> > error code was returned, rather than the error condition only being
> > logged.  If the error condition is not properly propagated then it coul=
d
> > lead to data loss.
>=20
> How is an admin to know which I/O capabilities to check before adding a
> device to a RAID array?  When is it acceptable to mix I/O capabilities?
>  Can a RAID array which is not currently being used as a backing store
> for a filesystem be assembled of unlike disks?  What if it is then
> (later) used as a backing store for a filesystem?
[...]

I think the answers are:
- Not easily
- When the RAID does not have another device on top
- Yes
- Yes
but Neil can correct me on this.

Ben.

--=20
Ben Hutchings
Once a job is fouled up, anything done to improve it makes it worse.

--=-3SaXzk4AdGrlfyejgzFU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIVAwUATb4C/ue/yOyVhhEJAQpxdg//TwR5SE0cJde2Rk5NV7Fw8vEeo0K3zRbW
TzXS97A3S52X5Ay6dUI2WiAtI6N48/xEjRjOmhIqx30yiD8pBcODF3hNjVuIhl8Y
RnmJeHfv3F/5GHSwI1NGHa5NisviUSAAPNaZM05MkCaJE2vPucoGrxLiVrXG0pzy
m1klLJpPcsWEf6iGOV+ydmiTH2/mr8E9N0cUIWwNpJ5CTTZlY4/oxVrrUPWUS8sA
3lNDbyJrqLzB5JmOIHG+fb7fXeOoEPycICpj824OHFMCwjD+uWnz9Nma7PXXv/qC
/XoXM//M6V82krmVLUyBxRJQMXRgtaC4mxFXaVvSzXptjvm6+MKeEDYynKa7IwW9
5IJpT403Ixa3qNt58vmOvrF0U3Wtm3mNXSiGTetdTH0OKVaY7zWUOtwhASdtx66j
CsXiSDAWNam3KqXt4a4MILA5ZvKnuBWNzE8fc97ZTX8DGc5jbJzGtcfKfrqtLG2Y
wITuvZZCEGigjvmjHfnPRB4Lp6rnVEbgHEIXcFUgaXPyBaOewrZO9LXxzhyE5cUy
XB5u+Ixh67VDLW7/WufGF0RcNREsL6RiKDmNIjWL57fpwrptKZGAhAdrtFMOSgp1
0BgN/TGiWEyxZATQGyGfnX7jc0sh9ftptbB3eRrrWbUpfipc3IJCSFcXale0Sv79
/YG01UMA3tc=
=6GU5
-----END PGP SIGNATURE-----

--=-3SaXzk4AdGrlfyejgzFU--
