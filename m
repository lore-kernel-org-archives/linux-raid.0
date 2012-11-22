From: NeilBrown <neilb@suse.de>
Subject: Re: mdadm --wait returns while array under construction?
Date: Thu, 22 Nov 2012 17:09:01 +1100
Message-ID: <20121122170901.090fb0b0@notabene.brown>
References: <1353434141.27671.13.camel@corn.betterworld.us>
	<20121121084357.41f2f9d9@notabene.brown>
	<1353516182.5795.39.camel@corn.betterworld.us>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/0Q+UnV4.v1u9kp_HFICsnLK"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1353516182.5795.39.camel@corn.betterworld.us>
Sender: linux-raid-owner@vger.kernel.org
To: Ross Boylan <ross@biostat.ucsf.edu>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/0Q+UnV4.v1u9kp_HFICsnLK
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 21 Nov 2012 08:43:02 -0800 Ross Boylan <ross@biostat.ucsf.edu> wrot=
e:

> On Wed, 2012-11-21 at 08:43 +1100, NeilBrown wrote:
> > On Tue, 20 Nov 2012 09:55:41 -0800 Ross Boylan <ross@biostat.ucsf.edu> =
wrote:
> >=20
> > > While switching the disks a RAID 1 is based on I used the --wait comm=
and
> > > to wait for the rebuild to finish.  It returned immediately, but a
> > > subsequent query showed it had not been rebuilt.  Have I misunderstood
> > > something, or is this an error?
> > >=20
> > > While doing these commands a much larger rebuild was going on with a
> > > different array, involving some of the same physical disks but differ=
ent
> > > partitions.  The partitions being rebuilt are on different physical
> > > disks for the different arrays.
> > >=20
> > > Here are the logs, with version info at the end (Debian Lenny + more
> > > recent kernel):
> > ....
> >=20
> > > markov:~# uname -a
> > > Linux markov 2.6.32-5-amd64 #1 SMP Wed Jan 12 03:40:32 UTC 2011 x86_6=
4 GNU/Linux
> > > markov:~# mdadm --version
> > > mdadm - v2.6.7.2 - 14th November 2008
> > >=20
> > >=20
> > > I notice that in this case, unlike the other array, the message during
> > > the rebuild (the last detail report) does not include a line like
> > > Rebuild Status : 0% complete
> > >=20
> > > I just tried --wait again to see if there was some kind of race, but
> > > once again it returned immediately, though detail says the spare is
> > > rebuilding.
> >=20
> > Can you test this patch to see if it fixes the problem?
> >=20
> > diff --git a/Monitor.c b/Monitor.c
> > index c4d57c3..a5e7aaa 100644
> > --- a/Monitor.c
> > +++ b/Monitor.c
> > @@ -973,7 +973,7 @@ int Wait(char *dev)
> >  			if (e->devnum =3D=3D devnum)
> >  				break;
> > =20
> > -		if (!e || e->percent < 0) {
> > +		if (!e || e->percent =3D=3D RESYNC_NONE) {
> >  			if (e && e->metadata_version &&
> >  			    strncmp(e->metadata_version, "external:", 9) =3D=3D 0) {
> >  				if (is_subarray(&e->metadata_version[9]))
> >=20
> >=20
> > NeilBrown
> Thanks for the patch.  I take it the current behavior is expected, if
> undesirable?

Well, I didn't expect it until I looked in the code and saw the bug.  But n=
ow
I do ;-)
Yes, undesirable.

NeilBrown


>=20
> I'll try to apply it, but I'm in the middle of several system upgrades
> and I may have trouble getting the source for the current system, since
> it is out of date.
>=20
> I spent most of yesterday dealing with various RAID problems, which I
> will detail in a separate message.
> Thanks.
> Ross


--Sig_/0Q+UnV4.v1u9kp_HFICsnLK
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUK3BfTnsnt1WYoG5AQJ/yg//W1GW6y3RPp0JKF6TptbdJ8gbbgHAv3G7
BiSsxNZbsyUF6uHoQ3NowVYAcL8YXB5Y7ua9gEYMR8comfEhcFTd2XFwX6dG7P5P
e0zW3bNySjOj0yePe1SKyjTRaxMwTsBzCGaF6qZcuiDti4BKB0lTqb/OZJ6dWQvv
aozJtPCyV7vGhjnG6AjKdrsIa2XiSbqprQFoUceTK2p0EsmlC97j9fDVg78n1XTl
5s5XENF4DTcclhxrPm5oQuKUffJwDKbSWBvng3CdiHsWahBWMOpUMteDrmBDn8Rf
un2NWiw9a+HwHHvV2eywmwD+/AotY0eONA3LIgogBNWw+pfRhWN4rtH9CnMyy+nH
W1PJ//3jsh6E2vIe8sIrTW7+3IscIA3GkTE8N+M49VhSSx44fwRmmzKK162hMST+
lJiEPaQUGbE3oMea71/1qZ4hJoCDUdrOdNYbWXB8YmIes+RVsHMfrJYe83SJAqbY
8Lx1qaRz49YznJuO7V+bbb5lgC9Y94VZg5HqBmEoY7CtzfGrkI9VN/nW5DsMcycs
FABmml4R0/jSJjzYKow9fGqHoN0C7hyV8ZPbITp6DRL+ty4rhJI28GKaMsCEMpfZ
jwesi5sV/H0oxzHWrgyxa2mGXL234XdmAB85EOLkD35az5YTQGDEDuenHbl18R/c
4juPv5EIHu0=
=oQV8
-----END PGP SIGNATURE-----

--Sig_/0Q+UnV4.v1u9kp_HFICsnLK--
