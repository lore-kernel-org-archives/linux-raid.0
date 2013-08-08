From: NeilBrown <neilb@suse.de>
Subject: Re: DDF test fails if default udev rules are active
Date: Thu, 8 Aug 2013 11:10:41 +1000
Message-ID: <20130808111041.741d383e@notabene.brown>
References: <51535A25.1040501@arcor.de>
	<20130424161348.1f7e3abc@notabene.brown>
	<52016E45.8000108@arcor.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/MloDM8Dnhx8N3TRacz3PccZ"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <52016E45.8000108@arcor.de>
Sender: linux-raid-owner@vger.kernel.org
To: Martin Wilck <mwilck@arcor.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/MloDM8Dnhx8N3TRacz3PccZ
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 06 Aug 2013 23:44:37 +0200 Martin Wilck <mwilck@arcor.de> wrote:

> On 04/24/2013 08:13 AM, NeilBrown wrote:
> > On Wed, 27 Mar 2013 21:44:21 +0100 Martin Wilck <mwilck@arcor.de> wrote:
> >=20
> >> Hi Neil,
> >>
> >> with my latest patch set, the DDF test case (10-ddf-create) succeeds
> >> reliably for me, with one caveat: It works only if I disable the rule
> >> that runs "mdadm -I" on a newly discovered container. On my system
> >> (Centos 6.3) it is in /lib/udev/65-md-incremental.rules, and the rule =
is
> >>
> >> SUBSYSTEM=3D"block", ACTION=3D"add|change", KERNEL=3D"md*", \
> >>   ENV{MD_LEVEL}=3D=3D"container", RUN+=3D"/sbin/mdadm -I $env{DEVNAME}"
> >>
> >> The reason is that the DDF test case runs mdadm -Asc after writing the
> >> conf file defining the container and 3 arrays.
> >>
> >> mdadm -Asc will first create the container. When it starts tries to
> >> create the member arrays, these have already been started by the udev
> >> rule above, causing the assembly to fail with the error message "member
> >> /dev/md127/1 in /dev/md127 is already assembled".
> >>
> >> I have done my testing with the above udev rule commented out, and all
> >> goes fine. But I am not sure if "mdadm -Asc /var/tmp/mdadm.conf" faili=
ng
> >> indicates a problem with the DDF code, or if it's really just a problem
> >> with the test case. Personally, I'd rather have a test case that
> >> succeeds by default on a system with standard configuration (which mea=
ns
> >> the above udev rule should be active).
> >>
> >> What do you think?
> >> Martin
> >=20
> > Hi Martin,
> >  I think this is a real issue that has occasionally annoyed me a bit but
> >  never enough to make me seriously address it - so thanks for raising i=
t.
> >=20
> >  I generally would like the tests to run without any interference from =
udev,
> >  though I certainly see the value of testing in a "standard config" con=
text
> >  too.
> >=20
> >  Fortunately it appears to be easy to address.
> >    udevadm control --stop-exec-queue
> >  will pause udev, and
> >    udevadm control --start-exec-queue
> >  will cause udev to resume.
> >=20
> >  So I suggest that we change the 'test' script to run:
> >=20
> >     udevadm settle; udevadm control --stop-exec-queue
> >=20
> >  before running each test script, and
> >=20
> >     udevadm control --start-exec-queue
> >=20
> >  after the script.
> >  Then if a script wants to run in "standard" context, it could simply p=
ut
> >     udevadm control --start-exec-queue
> >  at the top.  The default would be to disable udev which is what most s=
cripts
> >  expect.
> >=20
> >  Can you try that?
>=20
> It took me a while. I just tried today. Unfortunately it doesn't work
> right, at least not on CentOS 6. With the exec 	queue stopped, the
> container devices /dev/md/xyz won't be created in the first place
> ("timeout waiting for /dev/md/ddf"). I also tried additionally
> MDADM_NO_UDEV=3D1, but that would cause even other problems. I didn't dig
> any deeper. Disabling that single rule works fine for me.

Yes of course, we need udev to create the names in /dev.  We just don't want
it to auto-start things.
No easy around that that I can think of.
Bother.

Thanks,
NeilBrown


--Sig_/MloDM8Dnhx8N3TRacz3PccZ
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUgLwETnsnt1WYoG5AQIpOA/9F9Ga8CR/wkoC+hK+EiPlMk6+TzoEXOf5
XcLoR2jlux0fLExD3ZjZOvzHV4r0c0DAl6ZjnlCHGU0Z8kHUIzHMkd+hQDpuxght
MClcnPGVpTigShjrVReqbHHQ2MC/dQxc1QjK34Mu0CnC0BKtH05WLgzTwQAx4KNa
rwBtgT0zoNfyQiTvBf3pASyTWfNW+ffNoWJn5VmTX9tAYQXXWzCjXX1Tp71oB5mZ
FZjCwlDJ7EeikHCV8S8QBBf4luGlhhRwejFT+Ra2o+O2H+bnoLKWiAu+uqD/9deO
XuV6+0znSxurhKccsOv0ugj29jfgDmo9FpiK/dtI2TAeFWg0s7pRVg8tyT6YzcsU
SzmrHYF6WN44HVLyjJxe2Q9bQ6SK04SPoF8uDdco95Fjb7jYC8urlYiAqjtm5ywP
wthMLVTzTybKQRdWukPCFyLnJ1NgKQj2ltz7X4gvrMl5VZkaULhRMclbTuqrtJ6Z
G+Wpt8AEbmvLWXyrRHEyArGYUKMUvT4wSLQAwQ5nfSmW4v5kZyBqXOrmbFjqhM1I
MKawdT5GUl8XiYQWl/ah2TIb/AZxPpP4DXOxWpOA0n0AZBd7NwI47hv6c+DPNDpn
6VHD8qHUCMj1T5/xd8d1zQRYdwH5D9YIj22kfFHTnOKKtppYGSMkLsKPalA0R64J
ggcqRqBRhAY=
=gzfB
-----END PGP SIGNATURE-----

--Sig_/MloDM8Dnhx8N3TRacz3PccZ--
