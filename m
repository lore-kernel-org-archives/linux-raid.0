From: NeilBrown <neilb@suse.de>
Subject: Re: 3.7-rc4 hang with mdadm raid10 near layout, with 4 disks, and
 an internal bitmap
Date: Thu, 6 Dec 2012 10:11:38 +1100
Message-ID: <20121206101138.551a7dfa@notabene.brown>
References: <50A28D53.2080409@brockmann-consult.de>
	<20121127121914.77f6111e@notabene.brown>
	<50BFC9AD.4060006@brockmann-consult.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/ygpiorhOqoWipEB=M0_GTl/"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <50BFC9AD.4060006@brockmann-consult.de>
Sender: linux-raid-owner@vger.kernel.org
To: Peter Maloney <peter.maloney@brockmann-consult.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/ygpiorhOqoWipEB=M0_GTl/
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 05 Dec 2012 23:24:45 +0100 Peter Maloney
<peter.maloney@brockmann-consult.de> wrote:

> On 11/27/2012 02:19 AM, NeilBrown wrote:
> > On Tue, 13 Nov 2012 19:11:31 +0100 Peter Maloney
> > <peter.maloney@brockmann-consult.de> wrote:
> >
> >> I am using kernel 3.7-rc4. I have 2 LV on a 4 disk raid10 near layout
> >> mdadm device which I am trying to copy to another LV on the same VG
> >> using dd. The mdadm device has an internal bitmap. When I copy the fir=
st
> >> LV, it goes smoothly, but with the 2nd it hangs before it is done.
> >> [...]
> >> # uname -a
> >> Linux peter 3.7.0-rc4-1-default #7 SMP Sun Nov 4 23:11:57 CET 2012
> >> x86_64 x86_64 x86_64 GNU/Linux
> >>
> > ....
> >
> >
> > Thanks for the report.
> > Should be fixed by the following.
> >
> > NeilBrown
> >
> > Author: NeilBrown <neilb@suse.de>
> > Date:   Tue Nov 27 12:14:40 2012 +1100
> >
> >     md/raid1{,0}: fix deadlock in bitmap_unplug.
> >    =20
> >     If the raid1 or raid10 unplug function gets called
> >     from a make_request function (which is very possible) when
> >     there are bios on the current->bio_list list, then it will not
> >     be able to successfully call bitmap_unplug() and it could
> >     need to submit more bios and wait for them to complete.
> >     But they won't complete while current->bio_list is non-empty.
> >    =20
> >     So detect that case and handle the unplugging off to another thread
> >     just like we already do when called from within the scheduler.
> >    =20
> >     RAID1 version of bug was introduced in 3.6, so that part of fix is
> >     suitable for 3.6.y.  RAID10 part won't apply.
> >    =20
> >     Cc: stable@vger.kernel.org
> >     Reported-by: Torsten Kaiser <just.for.lkml@googlemail.com>
> >     Reported-by: Peter Maloney <peter.maloney@brockmann-consult.de>
> >     Signed-off-by: NeilBrown <neilb@suse.de>
> >
> > diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
> > index 636bae0..a0f7309 100644
> > --- a/drivers/md/raid1.c
> > +++ b/drivers/md/raid1.c
> > @@ -963,7 +963,7 @@ static void raid1_unplug(struct blk_plug_cb *cb, bo=
ol from_schedule)
> >  	struct r1conf *conf =3D mddev->private;
> >  	struct bio *bio;
> > =20
> > -	if (from_schedule) {
> > +	if (from_schedule || current->bio_list) {
> >  		spin_lock_irq(&conf->device_lock);
> >  		bio_list_merge(&conf->pending_bio_list, &plug->pending);
> >  		conf->pending_count +=3D plug->pending_cnt;
> > diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
> > index 0d5d0ff..c9acbd7 100644
> > --- a/drivers/md/raid10.c
> > +++ b/drivers/md/raid10.c
> > @@ -1069,7 +1069,7 @@ static void raid10_unplug(struct blk_plug_cb *cb,=
 bool from_schedule)
> >  	struct r10conf *conf =3D mddev->private;
> >  	struct bio *bio;
> > =20
> > -	if (from_schedule) {
> > +	if (from_schedule || current->bio_list) {
> >  		spin_lock_irq(&conf->device_lock);
> >  		bio_list_merge(&conf->pending_bio_list, &plug->pending);
> >  		conf->pending_count +=3D plug->pending_cnt;
>=20
>=20
> It works; copying my LV no longer hangs. Thanks. :)
>=20
> $ uname -a
> Linux peter 3.7.0-rc7-1-default+ #3 SMP Wed Dec 5 22:20:58 CET 2012
> x86_64 x86_64 x86_64 GNU/Linux
>=20

Great!  Thanks for the confirmation.

NeilBrown


--Sig_/ygpiorhOqoWipEB=M0_GTl/
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUL/Uqjnsnt1WYoG5AQLVZhAAiuF+0zHnWbtD5j66SiNanjm9vm1zp7o9
1LqZ9G5TzR71Bbk/MrtJyxZP2EQMzpTJS5IPdD4kegLEUyR61+Mwh0T/rcIE5DYc
jg6kxKfP56cIp0jgzgXUHfZpx5E1xO7RiJMJqKonZj3xzWC2Ok6Qzrwf/QiJ4tZM
VwcDNQ66LbT8UA5jRrNJ3JguSN7JVK20MQTfJEbirtp9BbKvK+o2FRItrwo1BZ/E
xt3jsKLuhLbeM5l69fcdufjekKK5lmJSslyFjuG9XHNeFA7ga5f3cb1pVaXA7YTm
x78su2Yq3FRteYEwH+T8l+ZTL7qzPd5MfqfApmC/GlVov4/dnKjo1G2DyQDxpwvC
A8JJR2yr32ISGSGWfvMrUTc9ps+95aJp9bvt0m4yYv4r0zUpKGzSJHGD52ult76b
3MVQdRT6cSgRzqRMPayn0/uMFpr3zvQgddPpHLFqLvnopmf0AQHFC4uFZ5JuRyZ9
ThckBytXWlgQp25tRbOT1SXFONV3g8FlLGt6xvVsabpg+guo/Khp1cTi0sYSCusq
G/hYI0hM7E93FgYaXaX4MYJEkkHe/rZedcoyDnVYcFHfhGNOIYIdymvT3ojWzpqk
VFyS8zLwpcakjanY7wZUPP6GC+c3mzOGPc7jSeGnNr+AvV1h1j9wb7Rgw8iJcri1
OwgukMMMo3U=
=nGEB
-----END PGP SIGNATURE-----

--Sig_/ygpiorhOqoWipEB=M0_GTl/--
