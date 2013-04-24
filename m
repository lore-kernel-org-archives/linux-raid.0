From: NeilBrown <neilb@suse.de>
Subject: Re: DDF test fails if default udev rules are active
Date: Wed, 24 Apr 2013 16:13:48 +1000
Message-ID: <20130424161348.1f7e3abc@notabene.brown>
References: <51535A25.1040501@arcor.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/wJX9WdhRrTgoQ037/su6n64"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <51535A25.1040501@arcor.de>
Sender: linux-raid-owner@vger.kernel.org
To: Martin Wilck <mwilck@arcor.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/wJX9WdhRrTgoQ037/su6n64
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 27 Mar 2013 21:44:21 +0100 Martin Wilck <mwilck@arcor.de> wrote:

> Hi Neil,
>=20
> with my latest patch set, the DDF test case (10-ddf-create) succeeds
> reliably for me, with one caveat: It works only if I disable the rule
> that runs "mdadm -I" on a newly discovered container. On my system
> (Centos 6.3) it is in /lib/udev/65-md-incremental.rules, and the rule is
>=20
> SUBSYSTEM=3D"block", ACTION=3D"add|change", KERNEL=3D"md*", \
>   ENV{MD_LEVEL}=3D=3D"container", RUN+=3D"/sbin/mdadm -I $env{DEVNAME}"
>=20
> The reason is that the DDF test case runs mdadm -Asc after writing the
> conf file defining the container and 3 arrays.
>=20
> mdadm -Asc will first create the container. When it starts tries to
> create the member arrays, these have already been started by the udev
> rule above, causing the assembly to fail with the error message "member
> /dev/md127/1 in /dev/md127 is already assembled".
>=20
> I have done my testing with the above udev rule commented out, and all
> goes fine. But I am not sure if "mdadm -Asc /var/tmp/mdadm.conf" failing
> indicates a problem with the DDF code, or if it's really just a problem
> with the test case. Personally, I'd rather have a test case that
> succeeds by default on a system with standard configuration (which means
> the above udev rule should be active).
>=20
> What do you think?
> Martin

Hi Martin,
 I think this is a real issue that has occasionally annoyed me a bit but
 never enough to make me seriously address it - so thanks for raising it.

 I generally would like the tests to run without any interference from udev,
 though I certainly see the value of testing in a "standard config" context
 too.

 Fortunately it appears to be easy to address.
   udevadm control --stop-exec-queue
 will pause udev, and
   udevadm control --start-exec-queue
 will cause udev to resume.

 So I suggest that we change the 'test' script to run:

    udevadm settle; udevadm control --stop-exec-queue

 before running each test script, and

    udevadm control --start-exec-queue

 after the script.
 Then if a script wants to run in "standard" context, it could simply put
    udevadm control --start-exec-queue
 at the top.  The default would be to disable udev which is what most scrip=
ts
 expect.

 Can you try that?

Thanks,
NeilBrown


--Sig_/wJX9WdhRrTgoQ037/su6n64
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUXd4HDnsnt1WYoG5AQJamxAAwIbEKHa/RfUJvRDLg/qs5ta+LvOz31hn
/fUVredaWkUWQbcoweTG+Z4hOx9np0rqyK82ywqm+vK/UqzpWKvySgNUR4uiE+yl
cWOTHAEteZPBAAooqLVUlHtwjC42Y2un8OhcP+DuU6Mn6CdGUpzEDBQkDj/IUDLW
Q1ho3MdGfdIgr7KxGuExd9l//qpXBUit8b2fvC0pZoM7G+nOANiwNLDfrHS7z536
N1/5qH5rGt5hmWxdlviw0NVVr5PhoZFnHFAThUFVUgHqLvDQSkfMhYK76g8TTIjl
6NioA8T6vWeI1HQJpFOlC0KRSIc7pReALknah0y00wxOGime5BE3IQiGb1t0Gk47
F85mcyhYUzZyfZ6HSzHHUAvf50oqgSQKwMu4QGH3TV0o7bc+kUNLgoepfDPDkJfn
WHGlKZnXZIjrkmcTo4xLtzbOGr2sOHQi/7nxgniMKtJiOgNdbWB+cLprggZXrEXW
NENkP9L/+yEyegFPLJ1Lk2KXJ4aGWcF9nkl5zD/CVcYM7189DZV4qIhWcmxo2m2k
r1MW3lyI7M3iV4yI9UAIBXC+WxlqjnXLsbnnoNF64Tmt1o71s36VmXu33SQVl9qX
jYn8PRaJRMemEO0ngoxjAvjf8HyNnsNSSCkMT6Atm+Gz3zGX6BoXpaj811su1Tqp
4kufl1CaEZU=
=estx
-----END PGP SIGNATURE-----

--Sig_/wJX9WdhRrTgoQ037/su6n64--
