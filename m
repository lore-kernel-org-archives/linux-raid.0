From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH] MD: Fix typos in MD documentation
Date: Mon, 11 Mar 2013 11:30:03 +1100
Message-ID: <20130311113003.012b93c8@notabene.brown>
References: <1362694766.28152.1.camel@f16>
	<1362733923.7193.30.camel@mattotaupa>
	<AE55049E-63BD-4A47-96EB-04B113319571@redhat.com>
	<CAOzFzEjA31yo7whp70D4fMiucsaoDJearRUBK5nQ8Ey+rqxZXA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/.qlROUodwhqtIk1Yt39mQlP"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAOzFzEjA31yo7whp70D4fMiucsaoDJearRUBK5nQ8Ey+rqxZXA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Joseph Glanville <joseph.glanville@orionvm.com.au>
Cc: Brassow Jonathan <jbrassow@redhat.com>, Paul Menzel <pm.debian@googlemail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/.qlROUodwhqtIk1Yt39mQlP
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sat, 9 Mar 2013 04:35:16 +1100 Joseph Glanville
<joseph.glanville@orionvm.com.au> wrote:

> On 9 March 2013 00:28, Brassow Jonathan <jbrassow@redhat.com> wrote:
> >
> > On Mar 8, 2013, at 3:12 AM, Paul Menzel wrote:
> >
> >> Am Donnerstag, den 07.03.2013, 16:19 -0600 schrieb Jonathan Brassow:
> >>> MD:  Fix some typos/grammer in MD documentation
> >>>
> >>> Signed-off-by: Jonathan Brassow <jbrassow@redhat.com>
> >>>
> >>> Index: linux-upstream/Documentation/md.txt
> >>> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> >>
> >> Did you use `git format-patch`? If not, hopefully this patch can be
> >> easily applied with `git am`.
> >
> > No.  I generally use 'quilt' and insert the patches into my email clien=
t.  If it's better to do something else, let me know and I will do that.
> >
> >  brassow
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20
> Take a look at git-format-patch and git-send-email. :)
>=20
> Generally this is preferred as the patches can be applied
> automatically via git-am
>=20

I had no difficulty applying the patch with "git am".

Jon:  feel free to use quilt if that works for you.  If it ever causes
problems, I'll let you know.

Patch applied -thanks,
NeilBrown

--Sig_/.qlROUodwhqtIk1Yt39mQlP
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUT0liznsnt1WYoG5AQKVPw/8CucW3dFgbhzyFeYdjadtZ9Rg74N9WX9d
SWlS6Lv8mN1+dW7n5ylDNoAvXohbt5ltwCYSDHiMHXg3tdjeAHPfJdbdWkDsXfqO
4SS3gYnRZhurZeC7rbrIeXryl/65Yt5msAIZgWrWSfYbHOpEAYmG17sPRNMFLgA4
+nuEMbN6AXi0rVPR1ZEZQhOvTuP1XdElRLzEsBaclwFEw8YrN5tabJlm/Qq5uXZ7
eysQXlaYtj0OI6yVgMqC1YKc5R3Z8fpCUSWKxN5qp1UoNGxnj9ucMZsO6GsyFaF5
VdUUfSQSRHVxH4GxZnLqyG1K8SQms8hGcMOSec+FaiQAwXXtgFnGPOOxUzmUew6+
QbNRdM2uZoHvKwHvjog4ArB/UhdCEM01hSBfdc9hjWRl/X3hXndnaReMOJXHAL0y
Zg7wbBF4K8g2RdoYW1Zr3JmRTxTJOr8x577+OuE+YoVFjU4BHmiqXfKrkDpsJCF9
F337u6KbQvmbD4NMlECbloYKwDeA+fO27euw63qbuJxLuPKGN+iyJAcSOSUyTzz0
DdMOkIYzjvVlenljf8zRm+cJVRq+5uCCgNvmQJnCA9duI8sZi8srDHquzgwbXx7P
Kilc6J+ddydQADkGNe2+tsqvwORc1AGCSdI+/5KkcL06RSb80PuCRC7smtp4j5Fe
BJQuTglIiPs=
=TIVy
-----END PGP SIGNATURE-----

--Sig_/.qlROUodwhqtIk1Yt39mQlP--
