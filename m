From: NeilBrown <neilb@suse.com>
Subject: Re: A sector-of-mismatch warning patch (was Re: Fault tolerance with badblocks)
Date: Mon, 22 May 2017 08:00:42 +1000
Message-ID: <87tw4dkgz9.fsf@notabene.neil.brown.name>
References: <5911A371.3030008@hesbynett.no> <878tm65kyx.fsf@esperi.org.uk> <5911AED4.9030007@hesbynett.no> <CAJCQCtSaLbp4T+j97Ds6xqPmhVwnncGU2UV2_9HEbEJyr6fy+Q@mail.gmail.com> <87bmr14u5f.fsf_-_@esperi.org.uk> <87efvpmqf6.fsf@notabene.neil.brown.name> <87bmqsmrre.fsf@notabene.neil.brown.name> <871sroscey.fsf@esperi.org.uk> <87h90hlac0.fsf@notabene.neil.brown.name> <8737c13zn8.fsf@esperi.org.uk> <20170519165517.257ny67pxkcbtpkq@kernel.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20170519165517.257ny67pxkcbtpkq@kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>, Nix <nix@esperi.org.uk>
Cc: Chris Murphy <lists@colorremedies.com>, David Brown <david.brown@hesbynett.no>, Anthony Youngman <antlists@youngman.org.uk>, Phil Turmel <philip@turmel.org>, "Ravi (Tom) Hale" <ravi@hale.ee>, Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, May 19 2017, Shaohua Li wrote:

> On Fri, May 19, 2017 at 11:32:43AM +0100, Nix wrote:
>> On 19 May 2017, NeilBrown said:
>>=20
>> > On Tue, May 16 2017, Nix wrote:
>> >
>> >> On 16 May 2017, NeilBrown spake thusly:
>> >>
>> >>> Actually, I have another caveat.  I don't think we want these messag=
es
>> >>> during initial resync, or any resync.  Only during a 'check' or
>> >>> 'repair'.
>> >>> So add a check for MD_RECOVERY_REQUESTED or maybe for
>> >>>   sh->sectors >=3D conf->mddev->recovery_cp
>> >>
>> >> I completely agree, but it's already inside MD_RECOVERY_CHECK:
>> >>
>> >> if (test_bit(MD_RECOVERY_CHECK, &conf->mddev->recovery)) {
>> >>         /* don't try to repair!! */
>> >>         set_bit(STRIPE_INSYNC, &sh->state);
>> >>         pr_warn_ratelimited("%s: mismatch sector in range "
>> >>                             "%llu-%llu\n", mdname(conf->mddev),
>> >>                             (unsigned long long) sh->sector,
>> >>                             (unsigned long long) sh->sector +
>> >>                             STRIPE_SECTORS);
>> >> } else {
>> >>
>> >> Doesn't that already mean that someone has explicitly triggered a che=
ck
>> >> action?
>> >
>> > Uhmm... yeah.  I lose track of which flags me what exactly.
>> > You log messages aren't generated when 'repair' is used, only when
>> > 'check' is.
>> > I can see why you might have chosen that, but I wonder if it is best.
>>=20
>> I'm not sure what the point is of being told when repair is used: hey,
>> there was an inconsistency here but there isn't any more! I suppose you
>> could still use it to see if the repair did the right thing. My problem
>> on that front was that I'm not sure what flag should be used to catch
>> repair but not resync etc: everywhere else in the code, repair is in an
>> unadorned else branch... is it the *lack* of MD_RECOVERY_CHECK and the
>> presence of, uh, something else?
> MD_RECOVERY_SYNC && MD_RECOVERY_REQUESTED && MD_RECOVERY_CHECK =3D=3D che=
ck
> MD_RECOVERY_SYNC && MD_RECOVERY_REQUESTED =3D=3D repair
> MD_RECOVERY_SYNC && !MD_RECOVERY_REQUESTED =3D=3D resync
>
> Don't see the poin to print the info for 'repair'. 'repair' already chang=
es the
> data, how could we use the info?

Surprising data is can be potentially valuable.
I don't think you should *ever* get an inconsistency in a RAID6 unless
you have faulty hardware.
If you do, then any information about the nature of the inconsistency
might be valuable in understanding the hardware fault.
I don't know in advance how I would interpret the data, but I do
know that if I didn't have the data, then I wouldn't be able to
interpret it.

However .... running "repair" when you don't know exactly what has
happened and why, is probably a bad idea.  So logging probably won't
provide value.
I wouldn't go out of my way to add extra logging for the 'repair' case,
but I certainly wouldn't go out of my way to avoid logging in that case.

It seems inconsistent to log for 'check' but not 'repair', but it isn't
a big deal for me.

NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAlkiDgoACgkQOeye3VZi
gbk4MA/9GMVCxRE7qxrE/MNu7A1E3b26Zb3STt3ufGlYmpn0TXAz/QvCrvBONhmH
l5FmAJeKFaDI5XJCE2FW6pW0gKkuX89AQBbKtAUKtmNUkUpVPsEZLI6flfQIMUYL
WWmSySKK0/HnxJRyP+16SSI4c1OZVzur0dn6sAep5oG4EjJ6xPJKuezwS7AYfNf8
y1K7fpcAza0lsSqn3qHgcXE6XqUTFqW1z3EIxOT2t60aYmZGVvNW/bFIuEISkobN
1IfA0Sp6Z70JIvt5u8s0UTSy/58e1bUb4s/ee9GAvBDTW8PcBVSN2ktPw8TqouvY
6OufjUWWbWbVJKKuGHHFxwVWhblEEmT5SYy9XoJD77fpR/+og+ZDruHyFxe75Lh2
uzDj/nd/x1rU8aPo82yXHzmSJjQvI0SUwv9MYIxiC3L7SZ1hbDiJ/3ifZCKEg06d
SxE+1sgU/IbQJTzkHIlyYphckXc/SpTHqvYS7CffB4jDhsUA0aAYtwvvGrNTGw2B
6YJeyIG7nFgFJimw8X84Xc4ZxnFmtxpfQJbgCDpgXcipuFarYP/gV+rA5a/kfP1/
xxYx0eQnaIFJ1UK3mkMOmCWq0ppCDxpR7W7hD+8XcN9P93N3pylaEi9ICvmUWWJO
/L2cUfdoWHIAdDaHQQAVblt5YAtneMRleitdAf4U1dp1GNePRLw=
=Hm+T
-----END PGP SIGNATURE-----
--=-=-=--
