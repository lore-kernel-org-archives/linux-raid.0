From: Daniel Kahn Gillmor <dkg@fifthhorseman.net>
Subject: Bug#624343: linux-image-2.6.38-2-amd64: frequent message "bio too big device md0 (248 > 240)" in kern.log
Date: Sun, 01 May 2011 20:42:52 -0400
Message-ID: <4DBDFE0C.3000304@fifthhorseman.net>
References: <20110427161901.27049.31001.reportbug@servo.factory.finestructure.net>	 <1304051980.3105.46.camel@localhost>	 <8739kyf53e.fsf@servo.factory.finestructure.net> <1304294457.2833.111.camel@localhost>
Reply-To: Daniel Kahn Gillmor <dkg@fifthhorseman.net>, 624343@bugs.debian.org
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="------------enigA79D39960901EC41C4C12DBC"
Return-path: <bounce-debian-bugs-dist=glddb-debian-bugs-dist=m.gmane.org@lists.debian.org>
Resent-To: debian-bugs-dist@lists.debian.org
Resent-Message-ID: <handler.624343.B624343.13042969889412@bugs.debian.org>
In-Reply-To: <1304294457.2833.111.camel@localhost>
List-Post: <mailto:debian-bugs-dist@lists.debian.org>
List-Help: <mailto:debian-bugs-dist-request@lists.debian.org?subject=help>
List-Subscribe: <mailto:debian-bugs-dist-request@lists.debian.org?subject=subscribe>
List-Unsubscribe: <mailto:debian-bugs-dist-request@lists.debian.org?subject=unsubscribe>
To: Ben Hutchings <ben@decadent.org.uk>, 624343@bugs.debian.org
Cc: Jameson Graef Rollins <jrollins@finestructure.net>, NeilBrown <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigA79D39960901EC41C4C12DBC
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 05/01/2011 08:00 PM, Ben Hutchings wrote:
> On Sun, 2011-05-01 at 15:06 -0700, Jameson Graef Rollins wrote:
>> Hi, Ben.  Can you explain why this is not expected to work?  Which par=
t
>> exactly is not expected to work and why?
>=20
> Adding another type of disk controller (USB storage versus whatever the=

> SSD interface is) to a RAID that is already in use.
>=20
 [...]
> The normal state of a RAID set is that all disks are online.  You have
> deliberately turned this on its head; the normal state of your RAID set=

> is that one disk is missing.  This is such a basic principle that most
> documentation won't mention it.

This is somewhat worrisome to me.  Consider a fileserver with
non-hotswap disks.  One disk fails in the morning, but the machine is in
production use, and the admin's goals are:

 * minimize downtime,
 * reboot only during off-hours, and
 * minimize the amount of time that the array is spent de-synced.

A responsible admin might reasonably expect to attach a disk via a
well-tested USB or ieee1394 adapter, bring the array back into sync,
announce to the rest of the organization that there will be a scheduled
reboot later in the evening.

Then, at the scheduled reboot, move the disk from the USB/ieee1394
adapter to the direct ATA interface on the machine.

If this sequence of operations is likely (or even possible) to cause
data loss, it should be spelled out in BIG RED LETTERS someplace.  I
don't think any of the above steps seem unreasonable, and the set of
goals the admin is attempting to meet are certainly commonplace goals.

> The error is that you changed the I/O capabilities of the RAID while it=

> was already in use.  But what I was describing as 'correct' was that an=

> error code was returned, rather than the error condition only being
> logged.  If the error condition is not properly propagated then it coul=
d
> lead to data loss.

How is an admin to know which I/O capabilities to check before adding a
device to a RAID array?  When is it acceptable to mix I/O capabilities?
 Can a RAID array which is not currently being used as a backing store
for a filesystem be assembled of unlike disks?  What if it is then
(later) used as a backing store for a filesystem?

One of the advantages people tout for in-kernel software raid (over many
H/W RAID implementations) is the ability to mix disks, so that you're
not reliant on a single vendor during a failure.  If this advantage
doesn't extend across certain classes of disk, it would be good to be
unambiguous about what can be mixed and what cannot.

Regards,

	--dkg


--------------enigA79D39960901EC41C4C12DBC
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iQJ8BAEBCgBmBQJNvf4MXxSAAAAAAC4AKGlzc3Vlci1mcHJAbm90YXRpb25zLm9w
ZW5wZ3AuZmlmdGhob3JzZW1hbi5uZXQwRUU1QkU5NzkyODJEODBCOUY3NTQwRjFD
Q0QyRUQ5NEQyMTczOUU5AAoJEMzS7ZTSFznp/SgP/0ZtFRPAV5FiAz5RZtIDHd/w
iac1SyLaHFD4udSdHpFCPGxaXlpD6w9ik9bDKqpWGOsi0cbG+4U+89bDE44UGbiY
wEmGRuCjlhEjrb6UoTvc6zfViQxgFvhOtuuzu4cIHUZK8+53ywQMdGS7xOxO0A1W
1x55+T+axuYVdT0dF0uSvjx0CiaRTlk/mYSSp+BZw4hZ4ZunOH6Qiz8cSLfX1P4A
yaLobnB7NVsglig/CmgOzYx3+iRraZZFgE/VBz7xoZ9Yy37awhXvR07X+/2GkBoB
8ur3lGjljsC2BGXiXv7LlvpnxaWLm9VzFzEwa/DgmsYiT4TbpEOS0uluPWnug1i/
lR73Yw+cBlLkCwjEK+TtacwIocP52azsFroUBE0p0/ewhgQLvUfblDj2Lh1zDskd
8KEiOTAgkePgBngcCTHSxwbuKDZfAdng/JQv7VusUF5515vfSEmZI5vliPpaV2F7
a/NNcZc6FmryAHH/qS849Bm399tnP84g2bWAf7nM4G72wcMpuU28pkDzLq/sjq8C
YaFzQ1rsjmT3HKwnXHO0qCmrmK4QGHWZ90ZsKo3Ff1Fne8WQO4Y0sxoI914+vOPK
Sjnv6MdTfSnyRuaOZ74N36Lo1vZzf90I3GJ2x+TChchIvkvjBWwaD3m/OaLV0HWk
O44ra7IsDLpYSncm70+9
=anQn
-----END PGP SIGNATURE-----

--------------enigA79D39960901EC41C4C12DBC--
