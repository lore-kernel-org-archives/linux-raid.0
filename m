From: NeilBrown <neilb@suse.de>
Subject: Re: Managing mdam
Date: Wed, 11 Sep 2013 18:37:20 +1000
Message-ID: <20130911183720.22cba566@notabene.brown>
References: <CAPoh-nY8wwu-2yYRbKycPX2gEUofQu6y29TOYhOm83C2au6ZQQ@mail.gmail.com>
	<20130910153347.5fafb58b@notabene.brown>
	<CAPoh-nYLbSL81V4zmLQ579+XMa2rsNFG-Drf6mVQQuCh6SYOKg@mail.gmail.com>
	<6693fa95e533a6027b7346f1b9b8af7e@alyseo.com>
	<20130911094848.00289146@notabene.brown>
	<026e01ceaec2$2ced7110$86c85330$@alyseo.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/=Bp1flhq3.rUA2Y0PQ86+lq"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <026e01ceaec2$2ced7110$86c85330$@alyseo.com>
Sender: linux-raid-owner@vger.kernel.org
To: Francois Billard <francois.billard@alyseo.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/=Bp1flhq3.rUA2Y0PQ86+lq
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Wed, 11 Sep 2013 09:40:23 +0200 "Francois Billard"
<francois.billard@alyseo.com> wrote:

> We want to embed raid management in our application. But we want a better
> solution if it exists rather than parsing the output of mdadm which is er=
ror
> prone.
> Is there a solution or should i write kilometer of regexp ? :)

The --export option of --detail and --examine should provide a lot of the
important data in usable format.  If there is something missing that you
need I will certainly consider adding it.

Depending on what exactly you want, you might be able to fish it out of=20
  /sys/block/mdXX/md/*

NeilBrown

>=20
> -----Message d'origine-----
> De=C2=A0: linux-raid-owner@vger.kernel.org
> [mailto:linux-raid-owner@vger.kernel.org] De la part de NeilBrown
> Envoy=C3=A9=C2=A0: mercredi 11 septembre 2013 01:49
> =C3=80=C2=A0: Francois Billard
> Cc=C2=A0: linux-raid@vger.kernel.org
> Objet=C2=A0: Re: Managing mdam
>=20
> On Tue, 10 Sep 2013 10:03:23 +0200 Francois Billard
> <francois.billard@alyseo.com> wrote:
>=20
> > Hi,
> >=20
> > Is it possible to manage mdadm from an external point of view ? with a=
=20
> > library with bindings in some language (Python) for example ?
> > Thanks in advance
> >=20
> > Regards,
> > Francois
>=20
> Only by running mdadm in a separate process and passing appropriate
> arguments.
>=20
> Is there something particular that you wanted to do?
>=20
> NeilBrown


--Sig_/=Bp1flhq3.rUA2Y0PQ86+lq
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUjArwDnsnt1WYoG5AQKsjBAAp7gxYATWFIecc7HQ2mpmxGa0Rt2HfzAj
hEVKMaMGY5wAJaTvd8qoQq3WjFxBGp7TB5ZMILcayHBzpS3uk1dDlEEre2DS7vk/
FZPJa5/fOegTdC6bl0sEbOEKLONabX4LFBJnZBU8Pdsr3zRu7D+hKuVek3+nEzna
Y1oVqk9+Upuar0poX6mcHlo7PAA8yrf/XabK00H9f4eDko0/g9Z9SXib/jTASbBH
pDoFpbQSvrVR/9vy7l39pxQXqTG0z1wqEw917s0m+Ki2CLrit0+vKfPY0KP9z2WU
QvzPQVNLXCalU9R7ZgJA3MqU6cLu6UDHLCZxLMIWv94ex2fD1uybo0B7xgCQ1TUH
fMUOX6i4fjmdnB6HHzF6bUCqMgYb0+nqVj8PoojjG9fC4zA7IoUHMpUT1qIqvBh4
wjbGniIsZO0FrVkdFI5XcTWJikFq92W9b2HrW/OWOUOhHRsr4xb1Ovbm5Ys09+OA
ld125Pj8U7LUexdBg/JjnxF8V/S/XnSH1f4WzBVdc5oHcVnbby3Ks3vqiduNWTUs
4tS8RrNRzmEK9fzXjiZCP5yeSFMQ4OyUDq0mNwdtsNndgfl1GlrOsInupAV5IJFe
toFIOSmbZBZuHnF1tlW9vGVRQFhPYTofEiw5yfEJFKem1Iy1I3sVN00q9orEWKS8
PFRRjKKv3lU=
=4+aV
-----END PGP SIGNATURE-----

--Sig_/=Bp1flhq3.rUA2Y0PQ86+lq--
