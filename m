From: NeilBrown <neilb@suse.com>
Subject: Re: A sector-of-mismatch warning patch (was Re: Fault tolerance with badblocks)
Date: Fri, 19 May 2017 14:53:18 +1000
Message-ID: <87efvlla69.fsf@notabene.neil.brown.name>
References: <c5307694-034c-b610-8a27-3bf272cac380@youngman.org.uk> <87inla73vz.fsf@esperi.org.uk> <5911A371.3030008@hesbynett.no> <878tm65kyx.fsf@esperi.org.uk> <5911AED4.9030007@hesbynett.no> <CAJCQCtSaLbp4T+j97Ds6xqPmhVwnncGU2UV2_9HEbEJyr6fy+Q@mail.gmail.com> <87bmr14u5f.fsf_-_@esperi.org.uk> <87efvpmqf6.fsf@notabene.neil.brown.name> <87bmqsmrre.fsf@notabene.neil.brown.name> <871sroscey.fsf@esperi.org.uk> <20170518000624.xmvttuyio6llu25r@kernel.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20170518000624.xmvttuyio6llu25r@kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>, Nix <nix@esperi.org.uk>
Cc: Chris Murphy <lists@colorremedies.com>, David Brown <david.brown@hesbynett.no>, Anthony Youngman <antlists@youngman.org.uk>, Phil Turmel <philip@turmel.org>, "Ravi (Tom) Hale" <ravi@hale.ee>, Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, May 17 2017, Shaohua Li wrote:

> On Tue, May 16, 2017 at 10:46:13PM +0100, Nix wrote:
>> On 16 May 2017, NeilBrown spake thusly:
>>=20
>> > Actually, I have another caveat.  I don't think we want these messages
>> > during initial resync, or any resync.  Only during a 'check' or
>> > 'repair'.
>> > So add a check for MD_RECOVERY_REQUESTED or maybe for
>> >   sh->sectors >=3D conf->mddev->recovery_cp
>>=20
>> I completely agree, but it's already inside MD_RECOVERY_CHECK:
>>=20
>> if (test_bit(MD_RECOVERY_CHECK, &conf->mddev->recovery)) {
>>         /* don't try to repair!! */
>>         set_bit(STRIPE_INSYNC, &sh->state);
>>         pr_warn_ratelimited("%s: mismatch sector in range "
>>                             "%llu-%llu\n", mdname(conf->mddev),
>>                             (unsigned long long) sh->sector,
>>                             (unsigned long long) sh->sector +
>>                             STRIPE_SECTORS);
>> } else {
>>=20
>> Doesn't that already mean that someone has explicitly triggered a check
>> action?
>
>
> Hi,
> So the idea is: run 'check' and report mismatch, userspace (raid6check for
> example) uses the reported info to fix the mismatch. The pr_warn_ratelimi=
ted
> isn't a good way to communicate the info to userspace. I'm wondering why =
we
> don't just run raid6check solely, it can do the job like what kernel does=
 and
> we avoid the crappy pr_warn_ratelimited.
>

raid6check is *much* slower than doing it in the kernel, as the
interlocking to avoid checking a stripe that is being written are
clumsy.... and async IO is harder in user space.

I think the warnings are useful as warnings quite apart from the
possibility of raid6check using them.
If we really wanted a seamless "fix the raid6 thing" (which I don't
think we do), we'd probably make the list of inconsistencies appear in a
sysfs file.  That would be less 'crappy'.  But as I say, I don't think
we really want to do that.

NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAlkeej8ACgkQOeye3VZi
gbl06BAAnosAqh6frPcd8J19yY9T+4kI4bZBkhq52+SZLjy0L0pipNh1i4YOGP/7
EVLJ0sMRV6/wKAkp3ivZSQQAqmX0aGRBh/blh4t1m52IKPSf6VY26m83WZB9I1pk
yAU4Kt5V1b3T6I83GL7MDCDsYBEPrICGgLLFo73ynawrkcPPErFdQDFyU7B3sxVV
33bDkIfVwlCDVknLFnP8VdjY87DaJMlE9HtVygwXGRRLbbcamHhDZHvyWmOCUfZO
eCjW4Tsp0dm/sml3uczPH8wqbuL5t0P90jlY8spRljenftXUfaGg3Ha8lodrZzTm
x1DNNW9fhc01+TLsk+JB8sUL11ua/Ng19pcb4NyKXSkvlor5jUUZbnXVw7KxGdLF
VjTONEmj6a+tvYjFtJ5YTB+KGOr2wl+4xhpzbK5jYtMTjvbaJxOypXqV3vg/gVmO
HAp+yUibTfM5Bpw0P/CeOBTuUyrwCr9+k4/VhEUYlkZ3O43Z33l4W0dlwHy5NmXK
h8NeBZVE8DkXzGW5zPVjGdGMajMz/I2hSrme0xLkjTpkztE4jgKYNadLkqN1Tyuy
OZ67Swzfmeb+MJrqjS9K9sgsDyJICKVzVeDHk0LE98gTDGDNrG9vi9XVDK7t7Zat
6h9HfToSJJX4MdBhLwsKSiBFucwuLKomxuXaf1vLIbJhWbCxhvg=
=sFsd
-----END PGP SIGNATURE-----
--=-=-=--
