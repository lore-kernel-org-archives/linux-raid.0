From: Doug Ledford <dledford@redhat.com>
Subject: Re: [mdadm git pull] imsm fixes and general external metadata
	updates
Date: Mon, 23 Feb 2009 10:54:11 -0500
Message-ID: <1235404451.751.383.camel@firewall.xsintricity.com>
References: <1232576408.2029.56.camel@dwillia2-linux.ch.intel.com>
	 <18822.13389.938876.964972@notabene.brown>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-Fk++DxK6KiltNVSWUVZp"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <18822.13389.938876.964972@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Dan Williams <dan.j.williams@intel.com>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


--=-Fk++DxK6KiltNVSWUVZp
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2009-02-02 at 10:46 +1100, Neil Brown wrote:
> On Wednesday January 21, dan.j.williams@intel.com wrote:

> > Beyond the straightforward fixes the more interesting bits are:
> >=20
> > mdmon: support scanning for containers
> > This is an attempt to make mdmon more manageable in the initramfs
> > environment.  Once mdadm has assembled the rootfs we need to switch the
> > currently running mdmon instance(s) over to the new mount point.  With
> > the current code it is awkward to do this in a generic way because a
> > script needs to know the names of all the active containers.  This tree
> > allows a script to do "mdmon /proc/mdstat /newroot" to batch convert al=
l
> > mdmon instances to /newroot.  This is probably a good time to start
> > interfacing with initramfs@vger.kernel.org to make sure these "initramf=
s
> > helper" changes are relevant, and to see what else is missing.
>=20
> We really need a man page for mdmon don't we.  Then this sort of text
> could be placed there for safely.

Yes, a man page is definitely needed.  I have no intention of putting
mdmon in the initramfs.  The only arrays that should be started during
initramfs operation are / and possibly /boot.  Both of those are started
readonly.  It isn't until later in the boot process (in rc.sysinit on
Fedora/RHEL) that we remount the / device rw.  It's my intention to
modify our rc.sysinit so that before the root device goes rw, we start
the necessary mdmon instances.  This should be sufficient to keep the
container metadata state consistent with reality and avoids having to
add mdmon to the initramfs.  However, that means I need to know how to
invoke mdmon when mdadm isn't starting it for me.

--=20
Doug Ledford <dledford@redhat.com>
              GPG KeyID: CFBFF194
              http://people.redhat.com/dledford

Infiniband specific RPMs available at
              http://people.redhat.com/dledford/Infiniband


--=-Fk++DxK6KiltNVSWUVZp
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkmixqMACgkQTzP9PM7pjw+CMQCfeV4N3SIm1VxO6oCBmXU+mIrQ
cAMAnjec1arj03xZBWjTzgHhKHLNNvyY
=f8K3
-----END PGP SIGNATURE-----

--=-Fk++DxK6KiltNVSWUVZp--

