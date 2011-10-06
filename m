From: NeilBrown <neilb@suse.de>
Subject: Re: Clarification behind md 1.0 superblock resync_offset and
 recovery_offset?
Date: Fri, 7 Oct 2011 09:17:30 +1100
Message-ID: <20111007091730.2a0ed0ac@notabene.brown>
References: <CANz0V+7gGjK8BfatVdLXJdJ-6Okcmx6P_32jjzxgihmV_JqsoQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/Wp3L0BepwXJF.bOvb0vD2ok"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CANz0V+7gGjK8BfatVdLXJdJ-6Okcmx6P_32jjzxgihmV_JqsoQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Andrei E. Warkentin" <andrey.warkentin@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/Wp3L0BepwXJF.bOvb0vD2ok
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 6 Oct 2011 14:48:28 -0400 "Andrei E. Warkentin"
<andrey.warkentin@gmail.com> wrote:

> Hi group,
>=20
> This is my first time posting on this mailing list. I've tried looking
> in the archives, but didn't find what I was looking for. I am trying
> to understand how the synchronization code in MD driver works, and I
> am unsure about the exact relation between resync_offset
> and recovery_offset for the 1.X SB format.
>=20
> sb->resync_offset sets mddev->recovery_cp, which is the last sector
> synchronized/recovered when md_do_sync exits, and isn't
> used for recovery if a bitmap is used.
>=20
> sb->recovery_offset sets rdev->recovery_offset, which seemingly is a
> per-member-device recovery_cp, but updated at a finer granularity,
> right?
>=20
> I think my confusion might be stemming from a misunderstandig behind
> what RECOVERY and SYNC implies. I thought that RECOVERY
> means metadata cleanup, while RESYNC is actual syncing of data to
> spares (or re-added previously faulty disks), but then why is there a
> recovery offset? Why isn't a resync offset sufficient?

Yes - that would be the source of your confusion.  You have it exactly
backwards.
"SYNC" means making sure all the devices in the array synchronised - i.e.
ensuring they all reflect the same set of data.  This is only needed after
and unclean shutdown.  For RAID5, this means checking and  if necessary
correcting all the parity blocks.  A RAID5 or RAID6 that is not synchronised
by is degraded could have data corruption.

"RECOVERY" happens when you lose a device and need to replace it with a
spare.  The data that was (or should have been) on the missing device is
recovered from other sources (e.g. from Parity and Data calculations) and is
written to the spare.

There isn't any point checkpointing a SYNC at regular intervals.  If the
shutdown is clean, the SYNC offset can be recorded at that time so that on
restart the sync can continue at the same offset.  If the shutdown is
unclean, you need to start again at the beginning anyway.
Well.... to be fair there might be value in checkpointing a SYNC while the
array is not being written to (and so is marked clean), but that is a fairly
uninteresting corner case.

There is value in checkpointing recovery, but it only works for 1.x metadat=
a.
The 0.90 metadata didn't not allow a device to be a full member of the array
until it was completely recovered.  A partly-recovered device is still a
spare as far as the metadata is concerned.
1.x metadata converts the spare into an array member immediately but records
that only part of it (at first only 0%) is actually recovered.  As recovery
progresses we periodically update the recovery offset (every 6.25% I think).
Now if there is an unclean shutdown the part of that was recovered is certa=
in
to be safe - we just resync that - then continue recovery of the rest:which
could have a small corruption, but at least we have improved the situation.



>=20
> I'd be willing to submit a few documentation patches just to others
> have an easier time of reading MD code :-).

That would be very much appreciated.

>=20
> Thank you,


NeilBrown

--Sig_/Wp3L0BepwXJF.bOvb0vD2ok
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBTo4o+jnsnt1WYoG5AQKOCw//c9wrIgriKXj3IxXo19g9/9qyVJjDw/1C
xQrhpMn76lnu+s5rYrQe26WJyv4Dt6vEgUTR4K3bX8T/PdFQpQjs/tImpSaaau7u
N2KGNKz61Awz5WLoyqG5zIrvz/lMeuiWAvzXXnYnsDvzdj8SpP3SfCPd+qnYMgd1
z6I3Sup8BzwcRHTxb0LXeayXiJSj8lXYqlgJNzrDGgyzaSNF5sbiKf9ThoSS1r0k
PlNi6FX7RolqcUeWK1zPjrGBASdRTJB16ysWmhBz4N+RwxDQ9mceNfZvQW3NU5Ox
9zsLRXpJFj4FcRJdLTCcT6UkbA9DJrAtBO0y+3MVTw+HezdWhhqwCWY6olBgxiVH
Bsd/TAX943sfo3CZLNmdYTxns7dkiFG70Mn/gsvlBq+JlMuZErCfSESxFlrS5Yax
3BrfeZ5BR1qJwIQVkM8yZD/GcUu9wAeVZ5U0h7BrYMjKxKgBBiDO5GN1fdYQUwUw
oI2VfaGoqFjfMQyL4bepeO0bDTJHCgzaDRavCtclVDCFX4nTqtzDizP86c5KjxBU
bAT75Mwz7npKBMoFt8wr2Rl9Kl5f1G+66Q717erO2hNvVansE+Nf9xpItA1+JEST
dXMB4Dn3eAXAxcQwZcnSZEeu4V+nEpLv2GHTFTiawg3Hpu5PpjkrN1n/lt2ZMQwJ
SfZaqmHMX6k=
=4pze
-----END PGP SIGNATURE-----

--Sig_/Wp3L0BepwXJF.bOvb0vD2ok--
