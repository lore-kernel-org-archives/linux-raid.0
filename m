From: Doug Ledford <dledford@redhat.com>
Subject: Re: [mdadm git pull] imsm fixes and general external metadata
	updates
Date: Mon, 23 Feb 2009 14:53:52 -0500
Message-ID: <1235418832.751.385.camel@firewall.xsintricity.com>
References: <1232576408.2029.56.camel@dwillia2-linux.ch.intel.com>
	 <18822.13389.938876.964972@notabene.brown>
	 <1235404451.751.383.camel@firewall.xsintricity.com>
	 <e9c3a7c20902231058x4196e688xa9091c72e31b1c4@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-64bD7JUQsVyEFI0DGHNQ"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <e9c3a7c20902231058x4196e688xa9091c72e31b1c4@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: Neil Brown <neilb@suse.de>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


--=-64bD7JUQsVyEFI0DGHNQ
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2009-02-23 at 11:58 -0700, Dan Williams wrote:
> On Mon, Feb 23, 2009 at 8:54 AM, Doug Ledford <dledford@redhat.com> wrote=
:
> > On Mon, 2009-02-02 at 10:46 +1100, Neil Brown wrote:
> >> We really need a man page for mdmon don't we.  Then this sort of text
> >> could be placed there for safely.
> >
> > Yes, a man page is definitely needed.
>=20
> I have one brewing, I'll include it in an upcoming pull request.
>=20
> > I have no intention of putting
> > mdmon in the initramfs.  The only arrays that should be started during
> > initramfs operation are / and possibly /boot.  Both of those are starte=
d
> > readonly.  It isn't until later in the boot process (in rc.sysinit on
> > Fedora/RHEL) that we remount the / device rw.  It's my intention to
> > modify our rc.sysinit so that before the root device goes rw, we start
> > the necessary mdmon instances.  This should be sufficient to keep the
> > container metadata state consistent with reality and avoids having to
> > add mdmon to the initramfs.  However, that means I need to know how to
> > invoke mdmon when mdadm isn't starting it for me.
>=20
> Did you happen to catch the discussion on the initramfs mailing list
> [1]?  It would be nice to not need mdmon in the initramfs.  However, I
> have found it needs to be there because even read-only mounted
> filesystems require write access to the underlying block device to
> recover the journal.
>=20
> --
> Dan
>=20
> [1] http://thread.gmane.org/gmane.linux.kernel.initramfs/65/

Is XFS the only one that does the journal recovery on initial mount
read-only during the initfs step, or do other journaled fses do the same
thing?  I didn't think ext3 recovered the journal until you switch to a
read-write mount, but I guess I could be wrong.

--=20
Doug Ledford <dledford@redhat.com>
              GPG KeyID: CFBFF194
              http://people.redhat.com/dledford

Infiniband specific RPMs available at
              http://people.redhat.com/dledford/Infiniband


--=-64bD7JUQsVyEFI0DGHNQ
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkmi/tAACgkQTzP9PM7pjw9JOACfXiZ4LYgu8HAo5e9wQDSMUVTC
s1MAn2fC1kEYiPNnil1yx1uh104ugI4h
=/7BL
-----END PGP SIGNATURE-----

--=-64bD7JUQsVyEFI0DGHNQ--

