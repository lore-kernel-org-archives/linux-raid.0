From: NeilBrown <neilb@suse.de>
Subject: Re: Stop IMSM verify?
Date: Thu, 13 Sep 2012 11:22:46 +1000
Message-ID: <20120913112246.77b3041e@notabene.brown>
References: <CA+ZgY1E2T6C+Db1eb8_GFnXm7nzo4ecgGbMiPPf18C9-p5X5WQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/QkBm6xt5tc+uv8voNmVkOF4"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CA+ZgY1E2T6C+Db1eb8_GFnXm7nzo4ecgGbMiPPf18C9-p5X5WQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Daniel Frey <djqfrey@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/QkBm6xt5tc+uv8voNmVkOF4
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 12 Sep 2012 18:00:21 -0700 Daniel Frey <djqfrey@gmail.com> wrote:

> Is there any way to stop the verify of an IMSM raid through mdadm?

No.

>=20
> I found https://raid.wiki.kernel.org/index.php/RAID_Administration,
> but the imsm raid does not seem to have sync_action anywhere in the
> /sys/block tree.

It certainly should be there.
  find /sys/block -name sync_action
??

>=20
> I've been having issues with suspend which I'm trying to troubleshoot,
> and I know I can stop it if I boot into Windows. Just wondering if
> that functionality is in mdadm.

I suspect your problem is that mdmon is being killed at an awkward time
during shutdown.
What distro?  Is 'systemd' being used?

NeilBrown

--Sig_/QkBm6xt5tc+uv8voNmVkOF4
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBUFE1Zjnsnt1WYoG5AQJHIg//dOt1NtNEnTffGjdvhxGp6rGsSMYPZa+w
D3RHbIohoAr/gTvqtE2UI6qGgFh6UyeWRbUJNmvODLmZ/v41gV7Nvk9q8IKSigk0
oFOlEFSd8zVWsQBb3vwASScOyg8ACAdn7aud0yHEy3Ic5rrP3rNspp+1TYK9orKF
jHNsVMMjSHEwInZDV2VF0VxqMHPUOw905+SJTsBNpbdPgnGpUxM/4KprG+h5GfRv
55GUp7rG9Y1Fu4bV2qArTqm77gtRQXZPdcOlcaf/+Ef5rr7rpSGx6WHIW4uJ/3Jt
KIlToo7ywG+PLBDhHI1OTeoUFoa8TmykU9eq8sXPTCQW4qH0ATzpvTuuDK7WUuWS
EuvJyRBded1MwCbI1CUcmdqyVxwTBSlmlfXC9Q/vQJ9NSAZvoBsT7ckVxwLbXdpi
gnXN/ormhRCc7IVm0o+E6yKbn5LpFykxsfEkrLWR1maZY8j62j4MCQt+M+47qeLz
Dt+ibry173Kn0bDSMscLJDywGx+pmfn8HAE1c5IJMWqsEWPnV2BNCwrKqwGSZi8Z
9qgsiyC9R4bNEew/4oL3ftQYVYdY06psrSQ2N2Jf5PW5/FG44gX+B50B9fmSnmnU
3q5ffBvk9JjfeF2d/B0SkmPl5iq2Bur8S3iqqlQB0QGS5zI+OULBGhh8FYMKvwLe
JM6Zktms05c=
=d1DN
-----END PGP SIGNATURE-----

--Sig_/QkBm6xt5tc+uv8voNmVkOF4--
