From: Daniel Kahn Gillmor <dkg@fifthhorseman.net>
Subject: Re: Bug#624343: linux-image-2.6.38-2-amd64: frequent message "bio
 too big device md0 (248 > 240)" in kern.log
Date: Mon, 02 May 2011 01:07:20 -0400
Message-ID: <4DBE3C08.1060705@fifthhorseman.net>
References: <20110427161901.27049.31001.reportbug@servo.factory.finestructure.net>	<1304051980.3105.46.camel@localhost>	<8739kyf53e.fsf@servo.factory.finestructure.net>	<1304294457.2833.111.camel@localhost> <20110502102224.7787d6bd@notabene.brown>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="------------enig9EC48162400E64D1EF41724D"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110502102224.7787d6bd@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>, 624343@bugs.debian.org
Cc: Ben Hutchings <ben@decadent.org.uk>, Jameson Graef Rollins <jrollins@finestructure.net>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig9EC48162400E64D1EF41724D
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 05/01/2011 08:22 PM, NeilBrown wrote:
> However if there is another layer in between md and the filesystem - su=
ch as
> dm - then there can be problem.
> There is no mechanism in the kernl for md to tell dm that things have
> changed, so dm never changes its configuration to match any change in t=
he
> config of the md device.
>=20
> A filesystem always queries the config of the device as it prepares the=

> request.  As this is not an 'active' query (i.e. it just looks at
> variables, it doesn't call a function) there is no opportunity for dm t=
o then
> query md.

Thanks for this followup, Neil.

Just to clarify, it sounds like any one of the following situations on
its own is *not* problematic from the kernel's perspective:

 0) having a RAID array that is more often in a de-synced state than in
an online state.

 1) mixing various types of disk in a single RAID array (e.g. SSD and
spinning metal)

 2) mixing various disk access channels within a single RAID array (e.g.
USB and SATA)

 3) putting other block device layers (e.g. loopback, dm-crypt, dm (via
lvm or otherwise) above md and below a filesystem

 4) hot-adding a device to an active RAID array from which filesystems
are mounted.


However, having any layers between md and the filesystem becomes
problematic if the array is re-synced while the filesystem is online,
because the intermediate layer can't communicate $SOMETHING (what
specifically?) from md to the kernel's filesystem code.

As a workaround, would the following sequence of actions (perhaps
impossible for any given machine's operational state) allow a RAID
re-sync without the errors jrollins reports or requiring a reboot?

 a) unmount all filesystems which ultimately derive from the RAID array
 b) hot-add the device with mdadm
 c) re-mount the filesystems

or would something else need to be done with lvm (or cryptsetup, or the
loopback device) between steps b and c?


Coming at it from another angle: is there a way that an admin can ensure
that the RAID array can be re-synced without unmounting the filesystems
other than limiting themselves to exactly the same models of hardware
for all components in the storage chain?

Alternately, Is there a way to manually inform a given mounted
filesystem that it should change $SOMETHING (what?), so that an aware
admin could keep filesystems online by issuing this instruction before a
raid re-sync?


=46rom a modular-kernel perspective: Is this specifically a problem with
md itself, or would it also be the case with other block-device layering
in the kernel?  For example, suppose an admin has (without md) lvm over
a bare disk, and a filesystem mounted from an LV.  The admin then adds a
second bare disk as a PV to the VG, and uses pvmove to transfer the
physical extents of the active filesystem to the new disk, while
mounted.  Assuming that the new disk doesn't have the same
characteristics (which characteristics?), does the fact that LVM sits
between the underlying disk and the filesystem cause the same problem?
What if dm-crypt sits between the disk and lvm?  Between lvm and the
filesystem?

What if the layering is disk-dm-md-fs instead of disk-md-dm-fs ?




Sorry for all the questions without having much concrete to contribute
at the moment.  If these limitations are actually well-documented
somewhere, I would be grateful for a pointer.  As a systems
administrator, i would be unhappy to be caught out by some
as-yet-unknown constraints during a hardware failure.  I'd like to at
least know my constraints beforehand.


Regards,

	--dkg


--------------enig9EC48162400E64D1EF41724D
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iQJ8BAEBCgBmBQJNvjwIXxSAAAAAAC4AKGlzc3Vlci1mcHJAbm90YXRpb25zLm9w
ZW5wZ3AuZmlmdGhob3JzZW1hbi5uZXQwRUU1QkU5NzkyODJEODBCOUY3NTQwRjFD
Q0QyRUQ5NEQyMTczOUU5AAoJEMzS7ZTSFznp0vQP/0pLcmwKLUHYStUW5idFl6Aq
N1A4piEcIgWZvzs0ddLE+2UGrcwlNZKFahhMONbS3ZoKFJD+GtcBRre38C+LDqVY
aOI2bMO/q6s7e7XJMl14tbNOiKvNN2/lJMZ3uh5pv4Ri13Iar9EHC0cYYCQ+moAS
aEeVC18uL2AUMdEDw5RkwRrkxiChh84kMm74PpC2FwXkTtO2JIMQLdhJoBxTrzxP
qBX4iCb1xaNFKL51tpAntAuUdQ8aL8T0MQ/358udILUu3jNmkiku2EogrO/8oulZ
rBmu3bWBvzZYFdPtd7UmjYSzcm/3BzHjtQA7MLpKsBVbjMuzKznYZF7kmq9HMJ8Q
9xtSiDNh+6rTRmz+bJHmNf3xWQm/KuuJDGGG04MCxhHW5jAATLrJM+QC5K3Y8gT+
mlBMdQA5w9OwzCR49/FxfMGwYIzBwZraMmS0mjUfRmMCBne9v2Qri4afWtD0LBFd
tduenIHQogUoH3FaWVCYHRf1GqYGAdO90W/4Bu0pNYI4jCKV+cNqfRFkTUVqor/G
OVG3Wf1lWtAru7YL+bYKT9Mp9WhhtQFzY0q+MzRquMaIftds5L0eVFENf5WSSDI+
eoAD33IxS6kCvmyllBfJDlxS3yByA5PI0d3xjZqsdCxhnv/uXuC6CjqRTzE0YQku
CqWFnknXjs8p/SFuLJ6L
=i41O
-----END PGP SIGNATURE-----

--------------enig9EC48162400E64D1EF41724D--
