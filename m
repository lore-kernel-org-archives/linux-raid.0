From: Robin Hill <robin@robinhill.me.uk>
Subject: Re: A few remaining questions about installing to RAID-10
Date: Fri, 2 Oct 2009 16:15:04 +0100
Message-ID: <20091002151504.GA22207@cthulhu.home.robinhill.me.uk>
References: <babafd2f0910012046i46f77e82lc1a75bbee3b1a6d8@mail.gmail.com>
 <887103.5263.qm@web38801.mail.mud.yahoo.com>
 <babafd2f0910020754i4818043aw3d4a15e91eec9eb8@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="M9NhX3UHpAaciwkO"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <babafd2f0910020754i4818043aw3d4a15e91eec9eb8@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--M9NhX3UHpAaciwkO
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri Oct 02, 2009 at 07:54:04AM -0700, Ben DJ wrote:

> Hi everybody,
>=20
> 2009/10/2 Keld J=F8rn Simonsen <keld@dkuug.dk>:=20
> > You can boot from a raid-10,n2 with the superblock last, standard
> > raid10,n2 will do. But the normal thing is to boot from raid-1
> >
> > There is a description of a setup at
> > http://linux-raid.osdl.org/index.php/Preventing_against_a_failing_disk
>
> Thanks for the URL.  Is there a reason that raid-1 is the "normal
> thing"? Just popularity or something technical?

The main reason is that RAID-1 works across any number of disks (as
they're all identical) whereas RAID-10,nX working is an artifact of how
that layout works for X drives (they end up being identical to RAID-1).

> On Fri, Oct 2, 2009 at 12:54 AM, Robin Hill <robin@robinhill.me.uk> wrote:
> > With OpenSUSE you can just switch to the second console at that point of
>=20
> I didn't know about the console switching option, thanks.  I'll look
> for docs on how to switch; I guess a F-key does the trick.  As far as
> you know, even though the graphical installers don't offer RAID-10
> config as an option, are they RAID-10 aware enough to correctly
> recognize/identify the array as RAID-10 after manual setup then
> rescan?
>=20
> SystemRescueCD approach still seems straightforward too, and can be
> doc'd as doable across any OS install.
>=20
Yes, Alt-F2 will get you to the second console, Alt-F3 for the third (or
Ctrl-Alt-F2 from within X).  The installer uses some of the consoles for
progress/debugging output, but at least one of them is just a basic
shell so you can run any normal commands from there.

The installer is sufficiently RAID-10 aware to pick up the arrays (if
not, the SystemRescueCD approach wouldn't work either).

> On Fri, Oct 2, 2009 at 5:30 AM, adfas asd <chimera_god@yahoo.com> wrote:
> > I am booting just fine from a RAID10-o2 array, although I'm told I'm
> > not supposed to.
>=20
> Why "not supposed to"?  Is it the RAID 10? or the 'o2' that's the problem?
>=20
It's the combination - RAID10,o2 for 2 drives results in one drive
having all data in normal order (so bootable) and the other having every
pair of chunks flipped.  I'm surprised that the bootloader even
recognises the filesystem, let alone manages to boot from it.

Cheers,
    Robin

P.S. The Wikipedia entry for Non-standard RAID levels has diagrams for a
number of the Linux RAID-10 layouts which may help to understand why
some layouts boot and others don't.
--=20
     ___       =20
    ( ' }     |       Robin Hill        <robin@robinhill.me.uk> |
   / / )      | Little Jim says ....                            |
  // !!       |      "He fallen in de water !!"                 |

--M9NhX3UHpAaciwkO
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.11 (GNU/Linux)

iEYEARECAAYFAkrGGPgACgkQShxCyD40xBIjOgCfedTcwvOXaXvn7KjtzCMt9CQv
ykcAniuEBHcMIHoZWILQpIyGMRYhBDck
=+k/Q
-----END PGP SIGNATURE-----

--M9NhX3UHpAaciwkO--
