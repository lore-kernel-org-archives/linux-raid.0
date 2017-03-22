From: NeilBrown <neilb@suse.com>
Subject: Re: proactive disk replacement
Date: Wed, 22 Mar 2017 15:16:16 +1100
Message-ID: <874lymaqun.fsf@notabene.neil.brown.name>
References: <3FA2E00F-B107-4F3C-A9D3-A10CA5F81EC0@allygray.2y.net> <11c21a22-4bbf-7b16-5e64-8932be768c68@websitemanagers.com.au> <CAPrpM6wtQe=h1AE-PbFr0-DyZ_wRN7gvibjfn86W0mQz77xnLg@mail.gmail.com> <f0916e66-8ea7-3363-3600-1d2cd68e85af@thelounge.net> <02316742-3887-b811-3c77-aad29cda4077@websitemanagers.com.au> <583576ca-a76c-3901-c196-6083791533ee@thelounge.net> <20170321113447.GA18665@metamorpher.de> <8b108a89-9d17-63f0-de1c-80b17be4411a@thelounge.net> <20170321124129.GA18865@metamorpher.de>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20170321124129.GA18865@metamorpher.de>
Sender: linux-raid-owner@vger.kernel.org
To: Andreas Klauer <Andreas.Klauer@metamorpher.de>, Reindl Harald <h.reindl@thelounge.net>
Cc: Adam Goryachev <mailinglists@websitemanagers.com.au>, Jeff Allison <jeff.allison@allygray.2y.net>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, Mar 21 2017, Andreas Klauer wrote:

> On Tue, Mar 21, 2017 at 01:03:22PM +0100, Reindl Harald wrote:
>> the IO of a RAID5/6 rebuild is hardly linear beause the informations=20
>> (data + parity) are spread all over the disks
>
> It's not "randomly" spread all over. The blocks are always where they bel=
ong.
>
> https://en.wikipedia.org/wiki/Standard_RAID_levels#/media/File:RAID_6.svg
>
> It's AAAA, BBBB, CCCC, DDDD. Not DBCA, BADC, ADBC, ...
>
> There is no random I/O involved here, at worst it will decide to not read=
=20
> a parity block because it's not needed but that does not cause huge/random
> jumps for the HDD read heads.

RAID5 resync (after an unclean shutdown) does read the parity.
It reads all devices in parallel and checks parity.  Normally all the
parity is correct so it doesn't write at all.
Occasionally there might be incorrect parity, in which case the head
will seek back and write the correct parity.

RAID5 recovery (when a device was removed and a new device is added)
reads all the *other* devices in parallel, calculates the missing block
(parity or data) and writes out to the replaced devices.  All reads and
writes are sequential.

NeilBrown


>
>> while in case of RAID1/10 it is really linear
>
> Actually RAID 10 has the most interesting layout choices...=20
> to this day mdadm is unable to grow/convert some of these.
>
> In a RAID 10 rebuild the HDD might have to jump from end to start.
>
> Of course if you consider metadata updates (progress has to be=20
> recorded somewhere?) then ALL rebuilds regardless of RAID level=20
> are random I/O in a way.
>
> But such is the fate of a HDD, it's their bread and butter.=20
> Any server that does anything other than "idle" does random I/O 24/7.
>
> If there was no other I/O (because the RAID is live during rebuild)=20
> and no metadata updates (or external metadata) you could totally do=20
> RAID0/1/5/6 rebuilds with tape drives. That's how random it is.
> RAID10 might need a rewind in between.
>
> Regards
> Andreas Klauer
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAljR+pEACgkQOeye3VZi
gbkEpxAAlN31imkHc+Nctvk4dha6OwaYXvjjwDxqnyDwEmo4QqzdO4JwCduNpEol
EY9moIwbSRsWkS50PYn34sLM4ANjzGZhNvQIxyV6h38i6p/PbpY1FmJeGTADPRQ8
KeoBVb0KGOW80NWh3sBX1sG52YiPNLlNkRbu9/JUrdqijr2+eNDZyMiBL7er68vC
tea4KxM0bzDZ9RML+Kzwl3eu1RFauRwbrqvqSHvZRG0FeNuemOdHv/Eo5YKnKqKg
O9pr7Ql9kQL5+NLPgWpk0O7WGuTGYvTXmjr/9dz80TsFZfrnr86tcuIukBJVBVUG
chelRQTVXCJVzUbNWzDfzmIFjAfeuvHoMYXuIZ9yC3kaDbvnwQTMQN8a4sv5AK2c
lUJMY9xrs6Z5RllR9jjwUQSY3iRtZ1keh3d8/eeQlUZPOe/BGEfWrHEBqtgUNwHA
OupCndUpB17cgiV0NJRfqKQCbZWu+iwPdcPmPRZJJ5Aq2xPP45uRT01ku3vXqjTU
wDyQZsm7dC8nMjdpVUCNXrPC/LFexhgR92QCnwBykVfA1fQ5cjWqe8KPofKaROGT
kZ82DXkcARRVW/cCOAolub5X0/lR9Z/GnV0OfaAvd57Im9Cil8VzZcYeuM4AAYym
xhIiPVepytiIN4nPtb6fLHyI3xtoCsutFmV6TfdxQgdK4ny39ro=
=tFwD
-----END PGP SIGNATURE-----
--=-=-=--
