From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 1/2] man mdadm: add information for MDADM_EXPERIMENTAL
 flag
Date: Wed, 23 Mar 2011 12:03:42 +1100
Message-ID: <20110323120342.682693dd@notabene.brown>
References: <20110322114634.30235.97064.stgit@gklab-128-013.igk.intel.com>
	<AANLkTi=dqmKeXeHH2wJUfv3wrXc5uLHVFaCnuNONvNFi@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTi=dqmKeXeHH2wJUfv3wrXc5uLHVFaCnuNONvNFi@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Mathias =?ISO-8859-1?B?QnVy6W4=?= <mathias.buren@gmail.com>
Cc: Adam Kwolek <adam.kwolek@intel.com>, linux-raid@vger.kernel.org, dan.j.williams@intel.com, ed.ciechanowski@intel.com, wojciech.neubauer@intel.com
List-Id: linux-raid.ids

On Tue, 22 Mar 2011 13:10:06 +0000 Mathias Bur=E9n <mathias.buren@gmail=
=2Ecom>
wrote:

> On 22 March 2011 11:46, Adam Kwolek <adam.kwolek@intel.com> wrote:
> > Update man for MDADM_EXPERIMENTAL flag.
> >
> > Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
> > ---
> >
> > =A0mdadm.8.in | =A0 12 ++++++++++++
> > =A01 files changed, 12 insertions(+), 0 deletions(-)
> >
> > diff --git a/mdadm.8.in b/mdadm.8.in
> > index 4b70e20..96945ae 100644
> > --- a/mdadm.8.in
> > +++ b/mdadm.8.in
> > @@ -2229,6 +2229,18 @@ in a container can be converted between leve=
ls where those levels are
> > =A0supported by the container, and the conversion is on of those li=
sted
> > =A0above.
> >
> > +Grow functionality (e.g. expand number of raid devices) for Intel'=
s
> > +IMSM container format has experimental status. It is guarded by
> > +.B MDADM_EXPERIMENTAL
> > +environment variable. This is due to the following reasons:
> > +
> > +1. Native Intel's IMSM check-pointing is not fully implemented yet=
=2E
> > +This causes IMSM incompatibility during grow process: grew array c=
annot
> > +be roamed between Windows(R) and Linux systems.
> > +
> > +2. Interrupting grow operation is not recommended, because
> > +for Intel's IMSM container format it is not fully tested yet.
> > +
> > =A0.SS SIZE CHANGES
> > =A0Normally when an array is built the "size" is taken from the sma=
llest
> > =A0of the drives. =A0If all the small drives in an arrays are, one =
at a
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-rai=
d" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at =A0http://vger.kernel.org/majordomo-info.htm=
l
> >
>=20
> My small modifications (spelling?), which might not be correct.
>=20
>  mdadm.8.in |   12 ++++++++++++
>  1 files changed, 12 insertions(+), 0 deletions(-)
>=20
> diff --git a/mdadm.8.in b/mdadm.8.in
> index 4b70e20..96945ae 100644
> --- a/mdadm.8.in
> +++ b/mdadm.8.in
> @@ -2229,6 +2229,18 @@ in a container can be converted between levels
> where those levels are
>  supported by the container, and the conversion is on of those listed
>  above.
>=20
> +Grow functionality (e.g. expand a number of raid devices) for Intel'=
s
> +IMSM container format has an experimental status. It is guarded by t=
he
> +.B MDADM_EXPERIMENTAL
> +environment variable. This is due to the following reasons:
> +
> +1. Native Intel's IMSM check-pointing is not fully implemented yet.
> +This causes IMSM incompatibility during the grow process: a grown ar=
ray cannot
> +roam between Windows(R) and Linux systems.
> +
> +2. Interrupting a grow operation is not recommended, because it
> +has not been fully tested for Intel's IMSM container format yet.
> +
>  .SS SIZE CHANGES
>  Normally when an array is built the "size" is taken from the smalles=
t
>  of the drives.  If all the small drives in an arrays are, one at a

Thanks. I included your revisions and made some more of my own :-)

See below.

NeilBrown


commit ca24ddb08da4c86b60f7e049f0b0a2c30b19c95a
Author: Adam Kwolek <adam.kwolek@intel.com>
Date:   Wed Mar 23 11:45:03 2011 +1100

    man mdadm: add information for MDADM_EXPERIMENTAL flag
   =20
    Update man for MDADM_EXPERIMENTAL flag.
   =20
    Minor revisions by Mathias Bur=E9n <mathias.buren@gmail.com> and Ne=
il Brown.
   =20
    Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
    Signed-off-by: NeilBrown <neilb@suse.de>

diff --git a/mdadm.8.in b/mdadm.8.in
index 4b70e20..9537304 100644
--- a/mdadm.8.in
+++ b/mdadm.8.in
@@ -2229,6 +2229,23 @@ in a container can be converted between levels w=
here those levels are
 supported by the container, and the conversion is on of those listed
 above.
=20
+Grow functionality (e.g. expand a number of raid devices) for Intel's
+IMSM container format has an experimental status. It is guarded by the
+.B MDADM_EXPERIMENTAL
+environment variable which must be set to '1' for a GROW command to
+succeed.
+This is for the following reasons:
+
+.IP 1.
+Intel's native IMSM check-pointing is not fully implemented yet.
+This causes IMSM incompatibility during the grow process: an array
+which is growing cannot roam between Microsoft Windows(R) and Linux
+systems.
+
+.IP 2.
+Interrupting a grow operation is not recommended, because it
+has not been fully tested for Intel's IMSM container format yet.
+
 .SS SIZE CHANGES
 Normally when an array is built the "size" is taken from the smallest
 of the drives.  If all the small drives in an arrays are, one at a
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
