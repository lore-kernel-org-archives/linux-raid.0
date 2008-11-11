From: Doug Ledford <dledford@redhat.com>
Subject: Re: Swapping a disk in a raid5 array
Date: Tue, 11 Nov 2008 16:21:30 -0500
Message-ID: <1226438490.4765.58.camel@firewall.xsintricity.com>
References: <994670.29528.qm@web30807.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-PdFn5lx/Fl72ELoh46p3"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <994670.29528.qm@web30807.mail.mud.yahoo.com>
Sender: linux-raid-owner@vger.kernel.org
To: Mike Myers <mikesm559@yahoo.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--=-PdFn5lx/Fl72ELoh46p3
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2008-11-11 at 10:33 -0800, Mike Myers wrote:
> Hi.  I have a 6 members raid5 set using software raid under linux.
> The array is comprised of 5 1 TB disks and a member that is a raid0
> array of 2 500 MB disks.  Use of the nested raid helped me do a
> transition of the system to this new array since I didn't have enough
> 1 TB drives.  It has been working very reliably, but performance seems
> a little lackluster, and I have 2 new 1 TB drives of the same make and
> model that I would like to substitute.
>=20
> I have always been taught that if you wanted to replace a disk in a
> raid5 array, you add the new disk as a member, and the fail the old
> disk and then remove it, which will cause the array to rebuild around
> the new disk. =20
>=20
> But since all of the members are healthy, I was wondering if there was
> a way to replace the disk so I would not be running without redundancy
> during the rebuild process.  That is, is there a way to swap the disk
> without failing the old member, but to basically have mdadm shadow the
> disk about to be replaced onto the new disk and then when it's in sync
> to remove the old disk.  This seems like a much safer way of doing a
> swap, and since it takes about 12 hrs to do a resync, it is not a
> small amount of time where bad things could happen.  I haven't seen
> anything that leads me to believe there is a way to do this, but
> thought I would ask here anyway before kicking off the process.

There are a couple paths you could take here depending on how the
current array is used.  The first is you could down the array and just
use dd to copy the contents of the two 500mb disks to the 1tb disk.
This implies you *can* down the array.  If that's not possible, then I
would suggest you run a check of the array first (echo "check"
> /sys/block/md<devnum>/md/sync_action).  This will scan all the drives
and pick out any bad sectors waiting to happen and then rewrite them
with good data.  This helps to prevent any bad things from happening
after you remove the good device and start the rebuild on the spare
device.  I don't know of a way to make the md stack start that rebuild
before you fail the old device though, so this is the best suggestion
I've got, and it's not 100% guaranteed as you could develop a bad sector
after the check pass completes (although chances of that are very slim).

> Also, since I have two new disks, I also want to grow the array by 1
> TB (1 disk swaps out the old 2 member raid0 member of the raid5 array,
> and the new disk would expand the array) if there is a way to do the
> raid5 set rebuild and the grow at the same time?  Since they both take
> a very long time to complete, and both are reading in the full
> contents of the all the members of the array, I was hoping to avoid
> this being done twice and save a lot of time.  :-)

Neil would need to answer that.  Honestly, I doubt it.  By the time you
include the check pass, I think you are going to need to do three passes
of the array to replace the raid set and grow it.  But, I could be
wrong.

--=20
Doug Ledford <dledford@redhat.com>
              GPG KeyID: CFBFF194
              http://people.redhat.com/dledford

Infiniband specific RPMs available at
              http://people.redhat.com/dledford/Infiniband


--=-PdFn5lx/Fl72ELoh46p3
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkkZ91oACgkQTzP9PM7pjw+BFwCeIzBgOspdcYCdZZzrEj1nSPtL
4LYAn3t92T9MyhCbWFawhQ4PmEu1D+V4
=05t4
-----END PGP SIGNATURE-----

--=-PdFn5lx/Fl72ELoh46p3--

