From: NeilBrown <neilb@suse.de>
Subject: Re: [RFC PATCH 1/3] md/isrt: base infrastructure and metadata
 loading
Date: Fri, 25 Apr 2014 09:44:54 +1000
Message-ID: <20140425094454.2004b0e6@notabene.brown>
References: <20140424061756.3187.2633.stgit@viggo.jf.intel.com>
	<20140424061849.3187.48229.stgit@viggo.jf.intel.com>
	<20140424172450.7ec9452b@notabene.brown>
	<CAA9_cmcfGvBVTbxbBKBsgsnkyAux_VyKcM3V6v+tY5quQTotkQ@mail.gmail.com>
	<20140424180252.490434c6@notabene.brown>
	<CAA9_cmfLyiDQp7naxJPxRsUe-KGwRYOZF9cLNuztmLhYno11qg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/Q9SFB.JsodIoT/8Y400lrLt"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAA9_cmfLyiDQp7naxJPxRsUe-KGwRYOZF9cLNuztmLhYno11qg@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-raid <linux-raid@vger.kernel.org>, jes.sorensen@redhat.com, Artur Paszkiewicz <artur.paszkiewicz@intel.com>, Dave Jiang <dave.jiang@intel.com>
List-Id: linux-raid.ids

--Sig_/Q9SFB.JsodIoT/8Y400lrLt
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 24 Apr 2014 10:33:31 -0700 Dan Williams <dan.j.williams@intel.com>
wrote:

> On Thu, Apr 24, 2014 at 1:02 AM, NeilBrown <neilb@suse.de> wrote:
> > On Thu, 24 Apr 2014 00:38:01 -0700 Dan Williams <dan.j.williams@intel.c=
om>
> > wrote:
> >
> >> On Thu, Apr 24, 2014 at 12:24 AM, NeilBrown <neilb@suse.de> wrote:
> >> > On Wed, 23 Apr 2014 23:18:49 -0700 Dan Williams <dan.j.williams@inte=
l.com>
> >> > wrote:
> >> >
> >> >> Initial md / block boilerplate for the Intel (R) Smart Response
> >> >> Technology compatibility driver.  Supports reading the packed  meta=
data
> >> >> and parsing it into a cache lookup tree.
> >> >>
> >> >> Cc: Dave Jiang <dave.jiang@intel.com>
> >> >> Cc: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
> >> >> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> >> >
> >> > It would really help in reviewing this to have a glossary.
> >> >
> >> > There are frames and segments and sectors and pages.
> >> >
> >> > I hope sectors are 512 bytes and pages are PAGE_SIZE, which may or m=
ay not be
> >> > 4096.
> >> >
> >> > And there are 16 sectors per frame, so I guess space is allocated in=
 the
> >> > cache in 8K aligned frames ??
> >> >
> >> > There are 64 segments per page so if pages did happen to be 4096 byt=
es, that
> >> > makes 64 bytes per segment.  What are they?
> >> >
> >> > There is a list somewhere of 32byte frame descriptors which is read =
into a
> >> > single vmalloced region (why? you keep page pointers, so why not rea=
d it into
> >> > separate pages?)
> >> > How is this organised?  I might be able to work that out from the co=
de, but
> >> > I'd rather not.
> >> >
> >> > Please don't make me guess, I'm not good at it.
> >> >
> >> > I guess it didn't help that diff out the header after the code.  I g=
ot bored
> >> > before I got there and didn't read all to words, so maybe some answe=
rs are in
> >> > there.  They don't really stand out though.
> >>
> >> No, they don't.  Let me throw together a proper cheat sheet.
> >
> > Thanks.
> >
> >
> >>
> >> > You've chosen '8' for the 'level' number.
> >>
> >> Hmm, ok.  I use -12 in the mdadm bits, I neglected to go back and fix
> >> up the kernel.
> >>
> >> > As this is an array which doesn't have redundancy, I'd rather a numb=
er <=3D 0.
> >> > I think there are places where I assume >=3D1 has redundancy and und=
erstands
> >> > spares etc.
> >> >
> >> > Should conf->count be a kref??? Just a thought, not a requirement.
> >>
> >> Doesn't kref =3D=3D 0 imply object destroyed?  It's a count of pending
> >> metadata events.
> >
> > kref means that in a kobject.  Elsewhere it means whatever you want.
> >
> > mpb_read_endio would kref_put(&conf->ref, release)
> >
> > where release would get the conf and wake_up(&conf->eventq);
> >
> > It probably isn't a big win..
>=20
> Yes, but I should train my brain that kref !=3D object lifetime, it's
> just a ref...
>=20
> ...or is it?
> static inline void kref_get(struct kref *kref)
> {
>         /* If refcount was 0 before incrementing then we have a race
>          * condition when this kref is freeing by some other thread right=
 now.
>          * In this case one should use kref_get_unless_zero()
>          */
>         WARN_ON_ONCE(atomic_inc_return(&kref->refcount) < 2);
> }
>=20
> Seems we would need kref_get_zero_ok(), right?

That doesn't sound like a good idea, the only value in using kref would be =
if
it made the code more obvious.  That wouldn't :-(

So I looked more closely at the code, and now wonder why 'count' is in 'con=
f'
at all.
You don't really need a global count of requests at all.
There two places where it is used.

One is in isrt_mpb_read() where a single bio is submitted and waited for.
That could use submit_bio_wait() (not 'should', just 'could').

The other is in isrt_read_packed_md() where multiple bios are submitted and
then waited for.

In both cases the counter (and wait queue) could be on the stack (like the
completion is in submit_bio_wait().

struct multi_complete { atomic_t count; wait_queue_head_t wait; unsigned lo=
ng
state; };

static void multi_read_endio(struct bio *bio, int error)
{
   struct multi_complete *mc =3D bio->private;
   if (error || !test_bit(BIO_UPTODATE(&bio->bi_flags)))
      set_bit(ISRT_ERROR, &mc->state);
   if (atomic_dec_and_test(&mc->count))
      wake_up(&mc->wait);
   bio_put(bio);
}

isrt_read_packed_md(struct mddev *mdev)
{
   ...
   struct multi_complete mc =3D { ATOMIC_INIT(0),
           __WAIT_QUEUE_HEAD_INITIALIZER(mc.wait), 0};
   ....
      atomic_inc(&mc,count);
      bio->bi_private =3D &mc;
      submit_bio(READ, bio);
   .....

   wait_event(&mc.wait, atomic_read(&mc.count)=3D=3D0);

   ....
}

It isn't really a big improvement, so maybe it isn't worth it.
But it does make it obvious that we are only waiting for the reads that we
just submitted.  With the current code I see conf->count and wonder what el=
se
we could be waiting for.

Up to you - maybe just leave it as it is.
(But please use 'READ', not '0' as the first arg to submit_bio).

NeilBrown

--Sig_/Q9SFB.JsodIoT/8Y400lrLt
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBU1mh9jnsnt1WYoG5AQLMmhAAi0Z7UGBTFUfBYm/LydMfEMIPcpSqoxTK
Fp/j/sukz7BugSHfQ9gPNFCCq4JTWefRXac9OLwYtKJkHMQKBjHwVzS2HhPTu6+4
+P/dehaANDMEwSv0C3kGAi+hplzZM4DMYWObgQDYJOtmhDK+UBbXVXz0JAkw75gU
h2uNNDTlove5Z/5AIjYpS/dahuTZx4XlMPZYxHSkgIgc+aZHAPq75RbRFXBIY82U
QHYwvqXteENeQpdoqBp1HoMNiaFnND9+9m+iV41Ud76AYOUx8a/xUQb0Zab1Dh4O
IoD5Oi8wJ8Vkrv0xmQqhrJG6ShdDuxCB6g8NTyKhg+jafUBmIDU5BgVhWYv+0ySA
A7v0p5RLqv80ECjYinicPHiu/kWtEGZea4zyFZY/N2kSCUwFTPvAj7gUO5okynU0
fUBi8d3Ar0sz/LovkqZa2Rlu3tsd3R+qnF7kK3IoyD0/XIYsVdUTFioocafrvJKP
Yz+7xHGdN2K4E5Coz3D1JIcorhmCa0yGyoUTd2xiblGQK7Cv6lCF/EehGpqxGzwE
Ci2QvPw0LwRV56RvBgm8XqXw6z0QHZFzdNEqN9mZIWI27tyyH5J8MfO5XZuYVVLB
kdQMO7Sz1TLcxniKPWb2Exz8z2Y0HPTPQ4PCq2Qh125WhYb4eC6Ps+GWr4BzUeM/
3A2F1GNqkY8=
=2EQ3
-----END PGP SIGNATURE-----

--Sig_/Q9SFB.JsodIoT/8Y400lrLt--
