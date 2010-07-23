From: Justin Bronder <jsbronder@gentoo.org>
Subject: Re: Raid10 device hangs during resync and heavy I/O.
Date: Fri, 23 Jul 2010 11:47:01 -0400
Message-ID: <20100723154701.GA2090@gmail.com>
References: <20100716184618.GA25890@gmail.com>
 <20100722184933.GA22647@gmail.com>
 <20100723131925.4b2bd54e@notabene>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="TB36FDmn/VVEgNH/"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20100723131925.4b2bd54e@notabene>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--TB36FDmn/VVEgNH/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 23/07/10 13:19 +1000, Neil Brown wrote:
> On Thu, 22 Jul 2010 14:49:33 -0400
> Justin Bronder <jsbronder@gentoo.org> wrote:
>=20
> > On 16/07/10 14:46 -0400, Justin Bronder wrote:
> >=20
> > I've done some more research that may potentially help. All of
> > the following was done with 2.6.34.1.
> >=20
> > Still produces the hang:
> >     - Using cp (may take a bit longer).
> >     - Using jfs as the filesystem.
> >     - Dropping RESYNC_DEPTH to 32
> >     - Using the offset layout.
> >=20
> > Does not produce the hang:
> >     - Using the near layout.
> >     - Using dd on the partition directly instead of on a
> >       filesystem via something like:
> >       dd if=3D/dev/${MD_DEV}p1 of=3D/dev/${MD_DEV}p1 seek=3D4001 bs=3D1M
> >=20
> >=20
> > As the barrier code is very similiar, I repeated a number of
> > these tests using raid1 instead of raid10.  In every case, I was
> > unable to cause the system to hang.  I focused on the barriers
> > due to the tracebacks in the previous email.  For the heck of it,
> > I added some tracing (patch below) where the reason for the hang
> > is fairly obvious.  Of course, how it happened isn't.
> >=20
> > The last bit of the trace before the hang.
>=20
> Thanks for doing this!
>=20
> See below...

<previous trace cut>

>=20
>=20
> So the 'dd' process successfully waited for the barrier to be gone at
> 189.021179, and thus set pending to '1'.  It then submitted the IO reques=
t.
> We should then see swapper (or possibly some other thread) calling
> allow_barrier when the request completes.  But we don't.
> A request could possibly take many milliseconds to complete, but it shoul=
dn't
> take seconds and certainly not minutes.
>=20
> It might be helpful if you could run this again, and in make_request(), a=
fter
> the call to "wait_barrier()" print out:
>   bio->bi_sector, bio->bi_size, bio->bi_rw
>=20
> I'm guessing that the last request that doesn't seem to complete will be
> different from the other in some important way.

Nothing stood out to me, but here's the tail end of a couple of different
traces.

           <...>-5047  [002]   207.023784: wait_barrier: in:  dd - w:0 p:11=
 b:0
           <...>-5047  [002]   207.023784: wait_barrier: out: dd - w:0 p:12=
 b:0
           <...>-5047  [002]   207.023785: make_request: dd - sector:747200=
1 sz:40960 rw:0
           <...>-4958  [002]   207.023872: raise_barrier: mid: md99_resync =
- w:0 p:12 b:1
           <...>-5047  [002]   207.024689: allow_barrier:     dd - w:0 p:11=
 b:1
           <...>-5047  [002]   207.024695: allow_barrier:     dd - w:0 p:10=
 b:1
           <...>-5047  [002]   207.024697: allow_barrier:     dd - w:0 p:9 =
b:1
           <...>-5047  [002]   207.024710: allow_barrier:     dd - w:0 p:8 =
b:1
           <...>-5047  [002]   207.024713: allow_barrier:     dd - w:0 p:7 =
b:1
           <...>-5047  [002]   207.026679: wait_barrier: in:  dd - w:0 p:7 =
b:1
          <idle>-0     [003]   207.043049: allow_barrier:     swapper - w:1=
 p:6 b:1
          <idle>-0     [003]   207.043058: allow_barrier:     swapper - w:1=
 p:5 b:1
          <idle>-0     [003]   207.043063: allow_barrier:     swapper - w:1=
 p:4 b:1
          <idle>-0     [003]   207.043070: allow_barrier:     swapper - w:1=
 p:3 b:1
          <idle>-0     [003]   207.043074: allow_barrier:     swapper - w:1=
 p:2 b:1
          <idle>-0     [003]   207.043079: allow_barrier:     swapper - w:1=
 p:1 b:1
          <idle>-0     [003]   207.043084: allow_barrier:     swapper - w:1=
 p:0 b:1
           <...>-4958  [003]   207.043108: raise_barrier: out: md99_resync =
- w:1 p:0 b:1
           <...>-4958  [003]   207.043150: raise_barrier: in:  md99_resync =
- w:1 p:0 b:1
           <...>-4957  [003]   207.051206: lower_barrier:     md99_raid10 -=
 w:1 p:0 b:0
           <...>-5047  [002]   207.051215: wait_barrier: out: dd - w:0 p:1 =
b:0
           <...>-5047  [002]   207.051216: make_request: dd - sector:747208=
1 sz:20480 rw:0
           <...>-4958  [003]   207.051218: raise_barrier: mid: md99_resync =
- w:0 p:1 b:1
           <...>-5047  [002]   207.051227: wait_barrier: in:  dd - w:0 p:1 =
b:1
          <idle>-0     [002]   207.058929: allow_barrier:     swapper - w:1=
 p:0 b:1
           <...>-4958  [003]   207.058938: raise_barrier: out: md99_resync =
- w:1 p:0 b:1
           <...>-4958  [003]   207.059044: raise_barrier: in:  md99_resync =
- w:1 p:0 b:1
           <...>-4957  [003]   207.067171: lower_barrier:     md99_raid10 -=
 w:1 p:0 b:0
           <...>-5047  [002]   207.067179: wait_barrier: out: dd - w:0 p:1 =
b:0
           <...>-5047  [002]   207.067180: make_request: dd - sector:747212=
1 sz:3584 rw:0
           <...>-4958  [003]   207.067182: raise_barrier: mid: md99_resync =
- w:0 p:1 b:1
           <...>-5047  [002]   207.067184: wait_barrier: in:  dd - w:0 p:1 =
b:1



          <idle>-0     [000]   463.231730: allow_barrier:     swapper - w:2=
 p:4 b:1
          <idle>-0     [000]   463.231739: allow_barrier:     swapper - w:2=
 p:3 b:1
          <idle>-0     [000]   463.231746: allow_barrier:     swapper - w:2=
 p:2 b:1
          <idle>-0     [000]   463.231765: allow_barrier:     swapper - w:2=
 p:1 b:1
          <idle>-0     [000]   463.231774: allow_barrier:     swapper - w:2=
 p:0 b:1
           <...>-5004  [000]   463.231792: raise_barrier: out: md99_resync =
- w:2 p:0 b:1
           <...>-5004  [000]   463.232005: raise_barrier: in:  md99_resync =
- w:2 p:0 b:1
           <...>-5003  [001]   463.232453: lower_barrier:     md99_raid10 -=
 w:2 p:0 b:0
           <...>-5009  [000]   463.232463: wait_barrier: out: flush-9:99 - =
w:1 p:1 b:0
           <...>-5009  [000]   463.232464: make_request: flush-9:99 - secto=
r:13931137 sz:61440 rw:1
           <...>-5105  [001]   463.232466: wait_barrier: out: dd - w:0 p:2 =
b:0
           <...>-5105  [001]   463.232467: make_request: dd - sector:720439=
3 sz:40960 rw:0
           <...>-5009  [000]   463.232476: wait_barrier: in:  flush-9:99 - =
w:0 p:2 b:0
           <...>-5009  [000]   463.232477: wait_barrier: out: flush-9:99 - =
w:0 p:3 b:0
           <...>-5009  [000]   463.232477: make_request: flush-9:99 - secto=
r:13931257 sz:3584 rw:1
           <...>-5009  [000]   463.232481: wait_barrier: in:  flush-9:99 - =
w:0 p:3 b:0
           <...>-5009  [000]   463.232482: wait_barrier: out: flush-9:99 - =
w:0 p:4 b:0
           <...>-5009  [000]   463.232483: make_request: flush-9:99 - secto=
r:13931264 sz:512 rw:1
           <...>-5105  [001]   463.232492: wait_barrier: in:  dd - w:0 p:4 =
b:0
           <...>-5105  [001]   463.232493: wait_barrier: out: dd - w:0 p:5 =
b:0
           <...>-5105  [001]   463.232494: make_request: dd - sector:720447=
3 sz:3584 rw:0
           <...>-5004  [000]   463.232495: raise_barrier: mid: md99_resync =
- w:0 p:5 b:1
           <...>-5105  [001]   463.232496: wait_barrier: in:  dd - w:0 p:5 =
b:1
           <...>-5009  [000]   463.232522: wait_barrier: in:  flush-9:99 - =
w:1 p:5 b:1
          <idle>-0     [000]   463.232726: allow_barrier:     swapper - w:2=
 p:4 b:1
          <idle>-0     [001]   463.240520: allow_barrier:     swapper - w:2=
 p:3 b:1
          <idle>-0     [000]   463.240946: allow_barrier:     swapper - w:2=
 p:2 b:1
          <idle>-0     [000]   463.240955: allow_barrier:     swapper - w:2=
 p:1 b:1

Thanks,

--=20
Justin Bronder

--TB36FDmn/VVEgNH/
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.15 (GNU/Linux)

iEYEARECAAYFAkxJuXUACgkQ4MrvBE1wQ8klZwCfW3T543rQ09IAQPX1buTmCrlp
nvcAnRpwFeWOeoFxTjZONOvSWeKA7I3R
=Fc37
-----END PGP SIGNATURE-----

--TB36FDmn/VVEgNH/--
