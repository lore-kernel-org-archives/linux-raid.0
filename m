From: NeilBrown <neilb@suse.de>
Subject: Re: mdadm: use static major/minor numbers.
Date: Wed, 21 Nov 2012 08:16:22 +1100
Message-ID: <20121121081622.162d6f08@notabene.brown>
References: <50AB7964.60002@mpstor.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/3eRTanusNA+WQu_X9qGLfyn"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <50AB7964.60002@mpstor.com>
Sender: linux-raid-owner@vger.kernel.org
To: Benjamin ESTRABAUD <be@mpstor.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/3eRTanusNA+WQu_X9qGLfyn
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 20 Nov 2012 12:36:52 +0000 Benjamin ESTRABAUD <be@mpstor.com> wrote:

> Hi!
>=20
> I recently updated mdadm-2.6.9 to mdadm-3.2.6 on a system (own busybox=20
> based distro) that had its kernel version updated from 2.6.35 to 3.4.
>=20
> Everything works well apart from a feature I used that I seem to be=20
> unable to reactivate:
>=20
> In the past, to ensure knowing the number of possible RAID devices that=20
> could be created on the system, I used static major:minor mappings by=20
> building the /dev/md/dXX and /dev/md/dXXpXX entries (with major 254, and=
=20
> three minors for each device for 3 partitions), allowing me to be=20
> certain that 64 RAID devices could be created at all times.
>=20
> When creating an array, the /dev/md/dXX and dXXpXX devices "nodes" would=
=20
> be used (not recreated) and the major/minor number these devices point=20
> to would be used for the actual MD block device.
>=20
> This was a very handy feature. With the latest mdadm, I simply cannot do=
=20
> that, as creating a /dev/md/dXX will in fact remove that device file and=
=20
> symlink it to /dev/md_dXX. I then created /dev/md_dXX devices prior to=20
> creating an array, and got the following error message: "mdadm:=20
> /dev/md_d3 exists but looks wrong, please fix".
>=20
> Looking through the source I can see that mdadm basically verifies if=20
> the file's major/minor matches the one that it had planned for the=20
> device, which in this case doesn't.
>=20
> Is there any way to work around that? Or in fact, I don't actually=20
> *need* to use static major/minor numbers, but I need to know in advance=20
> how many RAIDs I'll be able to create provided I'll always use 2=20
> partitions for them and can provide the -amdp2 argument to mdadm to make=
=20
> sure that only 2 partitions devices nodes are created.
>=20
> Is there a way to know the maximum number of RAIDs that can be created,=20
> provided that nothing else uses major 9 and 254?
>=20
> Thank you very much in advance for your help!

I don't really understand what your problem is.

mdadm should create any devices it needs - unless it detects udev, in which
case it leaves the device creation to udev.

So simply don't create any md devices in /dev and let mdadm do whatever is
required.
Does that approach not suit your needs?  If not, why not?

NeilBrown

--Sig_/3eRTanusNA+WQu_X9qGLfyn
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUKvzJjnsnt1WYoG5AQK3ig/7BaKrqVmv/UNnDCeEdmzn8kREtpmcUQuT
Y370m5q04aeXs94nW9QBCmLD69UWlTyJwWBgv+4i0STH5bUu5MKQi5V6q4q0hvDK
WLBmVJxISpziZ6UM3ks4Fv/T4loep91lQWo8Rjn7KSbIJAArdVoAC2+KQ1piRrDd
4IqIAg/ZstSbIaru+mNgeTj/Z5x0vR6qa9l1rWn8C9ujTLffwHN79OVU2ByXRBKW
/bo/TOWhtwXTBJiHNhh9bMJU/3wVe+eocxBhcVvsw4zW0iXeCpk4fD8lqxIqZb6a
B0Y40rN4fqsSp4nnZRgplCPCI6y/BHCRfIpyCyk/BiiwKZ7qC4v5BobI7TTgVdQo
+vZVnIlbADsm2ov9J3BrxJBBLl/Vr2ILAF+aI8Gl3cv7EWGeq7YWr7UO/H35IvHx
xwabrtpMaMpyAj5JP5ITHr4vYPRmCfvYhHsaSAqCDy9XAI76biXkdgXq8RKjbT2A
hL79XVHw20DKZoV7jrcNI6MB5094AlqNa5amnqmcq7dCo+hjsG3vuE81qpMhqmlj
oQ4e0IBajO5vztfJsoPoI90YWEny/aHbNM6o8Jhuf7gJpH2g6aEcD+z71ECNnpY1
Fw+s2Ai6l/byy1pUxJBaPwm8c4NaFD9RUH+IXd37ViJfeVXxmSn3U+0gIUUp4Ps9
SyB4BUAVZOk=
=EUrw
-----END PGP SIGNATURE-----

--Sig_/3eRTanusNA+WQu_X9qGLfyn--
