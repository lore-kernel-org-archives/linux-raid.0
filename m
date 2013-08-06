From: NeilBrown <neilb@suse.de>
Subject: Re: Bugreport ddf rebuild problems
Date: Tue, 6 Aug 2013 10:16:33 +1000
Message-ID: <20130806101633.4b8f2374@notabene.brown>
References: <51FAB74B.4030200@gmail.com>
	<51FAB282.6040303@arcor.de>
	<CAGkViCFT0+qm9YAnAJM7JGgVg0RTJi8=HAYDTMs-mfhXinqdcg@mail.gmail.com>
	<51FACF7C.50400@arcor.de>
	<51FADCA5.1080801@arcor.de>
	<51FAE319.6030604@arcor.de>
	<51FCD0BB.1040402@gmail.com>
	<51FE234A.4060808@gmail.com>
	<51FFD913.1090301@gmail.com>
	<5200180C.6060604@arcor.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/JDli=alBpJEGmoWfmdbxKV/"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5200180C.6060604@arcor.de>
Sender: linux-raid-owner@vger.kernel.org
To: Martin Wilck <mwilck@arcor.de>
Cc: Albert Pauw <albert.pauw@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/JDli=alBpJEGmoWfmdbxKV/
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 05 Aug 2013 23:24:28 +0200 Martin Wilck <mwilck@arcor.de> wrote:

> Hi Albert, Neil,
>=20
> I just submitted a new patch series; patch 3/5 integrates your 2nd case
> as a new unit test and 4/5 should fix it.
>=20
> However @Neil: I am not yet entirely happy with this solution. AFAICS
> there is a possible race condition here, if a disk fails and mdadm -CR
> is called to create a new array before the metadata reflecting the
> failure is written to disk. If a disk failure happens in one array,
> mdmon will call reconcile_failed() to propagate the failure to other
> already known arrays in the same container, by writing "faulty" to the
> sysfs state attribute. It can't do that for a new container though.
>=20
> I thought that process_update() may need to check the kernel state of
> array members against meta data state when a new VD configuration record
> is received, but that's impossible because we can't call open() on the
> respective sysfs files. It could be done in prepare_update(), but that
> would require major changes, I wanted to ask you first.
>=20
> Another option would be changing manage_new(). But we don't seem to have
> a suitable metadata handler method to pass the meta data state to the
> manager....
>=20
> Ideas?

Thanks for the patches - I applied them all.

Is there a race here?  When "mdadm -C" looks at the metadata the device will
either be an active member of another array, or it will be marked faulty.
Either way mdadm won't use it.

If the first array was created to use only (say) half of each device and the
second array was created with a size to fit in the other half of the device
then it might get interesting.
"mdadm -C" might see that everything looks good, create the array using the
second half of that drive that has just failed, and give that info to mdmon.

I suspect that ddf_open_new (which currently looks like it is just a stub)
needs to help out here.
When manage_new() gets told about a new array it will collect relevant info
from sysfs and call ->open_new() to make sure it matches the metadata.
ddf_open_new should check that all the devices in the array are recorded as
working in the metadata.  If any are failed, it can write 'faulty' to the
relevant state_fd.

Possibly the same thing can be done generically in manage_new() as you
suggested.  After the new array has been passed over to the monitor thread,
manage_new() could check if any devices should be failed much like
reconcile_failed() does and just fail them.

Does that make any sense?  Did I miss something?

Thanks,
NeilBrown

--Sig_/JDli=alBpJEGmoWfmdbxKV/
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUgBAYTnsnt1WYoG5AQIKHA//TTRHMtGJzmoF80cbZp6DSvVYRx91Ro9p
4dUTaaNHFA+o1JSiR/f40bvPLZER2aHUCtaVUscAeCWQIUPS5YsavAHyCpxfoZma
FVW0mEFmqX0dItCT7mj/42IHFbdNn20C80g23stcbiqMIP0GrBNHnP5771gn2Gpa
q64tGfFiOVhmydheB/BRsLDlpXM/tX+xfotQPSRVANk/aBsOKUx/wrqsmiHHN12m
1TQPw6gqS4TX5gopvlhND6K76hravi223bfOgwicW2cfNipxLBXA20tJSPjJXaPE
RY1maggysP3onL2kEEaZoVmxxQe2hYcVsvp0F2tA7w7YYROAikztvHstIwBbPuik
DO1Bq7azsQy3KBKuIxLrMKWtDOlsFtehHSpmyJ0o1hFemrQAc2tPHPyXrXRzO0Hh
2N3raQtRVkCOpHv1/Eid+G2S18Y8BuNhwhVyilZfJcWFXH7bGbjgzREI/86DzJ0L
bn0fYWBKyb6qsGx73RaC2Q2yO2M9dT3mv9q27DzMhjhyIoCzHBJ2l8iljrLHdYRp
rlUXJnwA7CD1pJC2hi6ocG5EeeBuyShxmPyQe+3CM5okEJKuVDP7Ydi+Lm5Sqdiu
ZrF057vyc8WcWYn2LafPs+rb0rCPuOEaFxAXGIvI5GGC4mXdLFTQMWsusMI/w5m9
UKFloBDHCeQ=
=y0gA
-----END PGP SIGNATURE-----

--Sig_/JDli=alBpJEGmoWfmdbxKV/--
