From: NeilBrown <neilb@suse.de>
Subject: Re: 1.X metadata: Resuming an interrupted incremental recovery for
 RAID1.
Date: Wed, 12 Oct 2011 14:05:17 +1100
Message-ID: <20111012140517.595f60f8@notabene.brown>
References: <CANz0V+567wM8dfW0-3mQbWhJjNHf_j4qxH0Da9Agi9xYggAJmA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/964kEBjEg8k9CR=v7yLplyk"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CANz0V+567wM8dfW0-3mQbWhJjNHf_j4qxH0Da9Agi9xYggAJmA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Andrei E. Warkentin" <andrey.warkentin@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/964kEBjEg8k9CR=v7yLplyk
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 11 Oct 2011 20:45:25 -0400 "Andrei E. Warkentin"
<andrey.warkentin@gmail.com> wrote:

> Hi group, Neil,
>=20
> I've seen the following behavior -
> 1) Create a RAID1 array with two devices with an internal bitmap.
> 2) Degrade the array.
> 3) Write data in the array.
> 4) Re-add the removed member - this start an incremental recovery.
> 5) Interrrupt the recovery (cause I/O failure in the just re-added
> disk) - array degraded again.
> 6) Re-add the removed member - this starts a full recovery.

Yeh, it probably shouldn't do that.


>=20
> If I understand, the choice behind incremental/full is based on the
> In_Sync bit, which for the two
> possibilities of an interrupted recovery, namely, an "active but
> recovering" disk (with a role) and "a spare prior
> to role assignment" (i.e. before remove_and_add_spares is run, I
> think), the In_Sync bit is never set.

Something like that ... though of course there are lots more horrible detai=
ls.


>=20
> It seems like it should be safe enough to resume an incremental
> recovery from where it left off, after all,
> the intent bitmap will still reflect the unsynchornized data, right?

Yes, it should.

>=20
> How about something like the following?
>=20
> 1) Add another SB feature - MD_FEATURE_IN_RECOVERY.
> 2) MD_FEATURE_IN_RECOVERY is set in in super_1_sync if
> rdev->saved_raid_disk !=3D -1 and mddev->bitmap.
> 3) MD_FEATURE_IN_RECOVERY is unset in super_1_sync otherwise.
> 4) If MD_FEATURE_IN_RECOVERY is for the 'default' case in
> super_1_validate, set the In_Sync bit, causing an
>     incremental recovery to happen.

We probably do need another flag somewhere, as we have two different states
over-lapping.
The first time you re-added a device, it's recovery_offset was MAX and it's
event_count was old, but not older than the bitmap.
So we could do a bitmap-based recovery.

When it was re-added we would have updated the metadata to have a newer eve=
nt
count, but a lower recovery_offset.  So it is no longer clear from the
metadata that a bitmap-based recovery is allowed.
We could leave the old metadata, but then the bitmap-based resync would
restart from the beginning.
You want the bitmap-based-resync to restart from recovery_offset which is a
new state.  So maybe we do need a new flag.

>=20
> The above handles 99% (as far as I tested).

That's not bad.

>=20
> The only case left is dealing with the 'spare' transition - in which
> case I also need to remember rdev->saved_raid_disk someplace
> in the superblock (and restore raid_disk and the In_Sync bit in
> super_1_validate as well).  If I understand correctly,
> sb->resync_offset is a
> safe place, since it's disregarded for a bitmapped rdev.

You've lost me ... and I was coping so well too!

What "spare transition".  I cannot see a point in the process where the
metadata would get marked as being a spare...


>=20
> What do you think? Am I missing something or is there a better way of
> achieving what I am trying to do? I am basically
> trying to ensure that if an rdev went away during incremental
> recovery, then incremental recovery will resume if it is re-added.
> This
> will not affect adding a 'clean' spare (it will cause a full recovery).
>=20

<thinks....>

I think that if a spare being bitmap-recovered fails and then gets re-added,
then we have to start the bitmap-recovery from the beginning.  i.e. we cann=
ot
use the recovery_offset.  This is because it is entirely possible that while
the device was missing the second time, a write went to an address before
recovery_offset and so there is a new bit, which the recovery has to handle.

So the correct thing to do is to *not* update the metadata on the recovering
device until recovery completes.  Then if it fails and is re-added, it will
look just the same as when it was re-added the first time, and will do a
bitmap-based recovery.
Only when the bitmap-based recovery finishes should the metadata be updated
with a new event count, and then the bitmap can start forgetting those old
bits.

Credible?
</thinks>

NeilBrown


--Sig_/964kEBjEg8k9CR=v7yLplyk
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBTpUD+Tnsnt1WYoG5AQJgZA/8Cdg23gS2C15Hnp3IwtwlIyYOEfDcdBi3
VM/lMKPHUkygWLTk0iMXxI+5pLnGzI8eQS/lji6tRZt89xmXkGzrZRFfK/9sGJ1q
WtINbD1IiYaqq7pegBvseGKUxSvhutub2w/ut4QRzCoq4u2XEdGF3002Du6AjMCb
TAi1CkvQuwcefgolP4C5SY/PZS21UuLt8rLvKJBRRY3O9Tb8iOVNMzei9amacCUp
DDI1WZg5wTEozdwCIU2IZ/l97iAhhLvC8LAeiye8JA3/MBcNfMWp0mIAoB7nFreS
rR9g2Br+mK4HShgYgsyd8Ox5ZBDhYrQPCPrpI/fWWJsbbP14PkcrCDH+rbTU6+VP
w417Pl5Z9teGVsNog7L9GpohWNAMWo21IPNI6lb91lDUW93s2Lm/wCVsJjPCIubl
NLmXIYIlkdZvnJle9N84YU43wZYMgIg12Bnth5DH0LNjxyxgA7UtpHYdpSdFHH8M
fJhFp170meazTXQItVyK2gHEnoJkXbN/EfvYYHLbWSIG179YkgJ9bIQDdInMdysN
7mvXxmiHuHw5fFtB03ID71hHmUTNaltllstOA4GmoA0/u3lUeTIi2c4vxljVOT8r
zpbJiUuR9qo/Y3jVh5AfLKmz2SEzM9Ax4YqNXAsesiU61+hcBv4gO9QtTQQ0eegj
cGykah0ickQ=
=W7EH
-----END PGP SIGNATURE-----

--Sig_/964kEBjEg8k9CR=v7yLplyk--
