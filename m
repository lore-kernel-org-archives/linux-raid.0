From: NeilBrown <neilb@suse.de>
Subject: Re: [patch 2/2 v3]raid5: create multiple threads to handle stripes
Date: Tue, 12 Mar 2013 12:39:27 +1100
Message-ID: <20130312123927.16e49ea9@notabene.brown>
References: <20120809085808.GB30111@kernel.org>
	<20130307073123.GA5819@kernel.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/OWFyjB9M_3jGUhHv7_fhNmg"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20130307073123.GA5819@kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: linux-raid@vger.kernel.org, dan.j.williams@gmail.com
List-Id: linux-raid.ids

--Sig_/OWFyjB9M_3jGUhHv7_fhNmg
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 7 Mar 2013 15:31:23 +0800 Shaohua Li <shli@kernel.org> wrote:

> Hi Neil,
>=20
> I just noticed this one is missed. It used to be in your branch, but get
> dropped some time. Is anything I missed? I can resend it if you like.
>=20
> Thanks,
> Shaohua
>=20
> On Thu, Aug 09, 2012 at 04:58:08PM +0800, Shaohua Li wrote:
> > This is a new tempt to make raid5 handle stripes in multiple threads, as
> > suggested by Neil to have maxium flexibility and better numa binding. It
> > basically is a combination of my first and second generation patches. By
> > default, no multiple thread is enabled (all stripes are handled by raid=
5d).
> >=20
> > An example to enable multiple threads:
> > #echo 3 > /sys/block/md0/md/auxthread_number
> > This will create 3 auxiliary threads to handle stripes. The threads can=
 run
> > on any cpus and handle stripes produced by any cpus.
> >=20
> > #echo 1-3 > /sys/block/md0/md/auxth0/cpulist
> > This will bind auxiliary thread 0 to cpu 1-3, and this thread will only=
 handle
> > stripes produced by cpu 1-3. User tool can further change the thread's
> > affinity, but the thread can only handle stripes produced by cpu 1-3 ti=
ll the
> > sysfs entry is changed again.
> >=20
> > If stripes produced by a CPU aren't handled by any auxiliary thread, su=
ch
> > stripes will be handled by raid5d. Otherwise, raid5d doesn't handle any
> > stripes.


Hi Shaohua,
 I still have this sitting in my queue, but I haven't had a chance to look =
at
 is properly yet - I'm sorry about that.  I'll try to get to it soon.

NeilBrown

--Sig_/OWFyjB9M_3jGUhHv7_fhNmg
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUT6HTznsnt1WYoG5AQJzcQ//Uj6XMRSnIrOv2kIvpcjnKIpy3fLFxe/6
kfEBl2AaVv5+vWCRa4ncnOxpAsGaUv+rwVp+koiTGSpkBhnigDxlOVgfZo546Kux
qzwZPLyIHzXSV3W8DnLpD7Zqtfz5+xwIqWBc4EtuIzsSaM95E2LEeAguB8NFwQXO
7SnbvLYRghqkiX5WW2BazYS6ZfHtdMXsSpBAGFzKe3pvx2tfF/3isKW/9W0Yl4BE
FxmXYiO49nSSErOCNk58nBWLCf5kO4lA5pHriqrrjAtcmAZhXOFJlvqx7LltQwl/
XWzULbGGEo1a8t0yrgDbqqOc0EKqIkXZRY07Hb1RxLVTJIJyStaPX0p05lL1lL7U
AJmSPk578Fonr1qkKrFGGOCQ95u8b53XQqU504bQxANVCoYGlu7AzezwI2k37tgW
ryeg5RImoS2KklrIWq/EGYzrQEOFkPqIUPT+qTTTGZFYMreBV+L6IlMx0zBmk4Lu
Lb4WSzC04U40ZVJPTmRtwqSWefvLuiGPnPNkNanI39OVQWfA697oNR4PHsm9P6Vz
8uD58+fvGXJemjWNkmP5mePSsMMZ4RKwnZrW1ZTvlKz+30FOlhjKLao8AWDYmqki
Qsq36RFNs56I89f4jL9CF1iU7NxHtpTL++w96oSUNl337nm3GTD0c2H/4mfDuwn0
FvzF1fHd1mk=
=VSXz
-----END PGP SIGNATURE-----

--Sig_/OWFyjB9M_3jGUhHv7_fhNmg--
