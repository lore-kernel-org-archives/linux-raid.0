From: NeilBrown <neilb@suse.com>
Subject: Re: Auto replace disk
Date: Tue, 14 Mar 2017 08:36:54 +1100
Message-ID: <87r320eu4p.fsf@notabene.neil.brown.name>
References: <CAJH6TXgyOEE5A8TZVZy-db+tPD1QeHtnXXO3B-1vmKe4cAt6xA@mail.gmail.com> <58C04AC9.9070801@youngman.org.uk> <CAJH6TXjjjnQ3_OJ87Gv8Spsd=7BZ7RGrfCJ0kqeRXTQN_1Q3KQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAJH6TXjjjnQ3_OJ87Gv8Spsd=7BZ7RGrfCJ0kqeRXTQN_1Q3KQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Gandalf Corvotempesta <gandalf.corvotempesta@gmail.com>, Wols Lists <antlists@youngman.org.uk>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain

On Wed, Mar 08 2017, Gandalf Corvotempesta wrote:

> 2017-03-08 19:17 GMT+01:00 Wols Lists <antlists@youngman.org.uk>:
>> Do you mean you remove an old disk, and put a new blank disk in?
>
> Yes
>
>> If that's what you mean, then no, it's not possible. mdadm doesn't have
>> a clue about disks, what it sees is "block devices".
>
> Ok but mdadm.conf man page seems to say the opposite:
> https://linux.die.net/man/5/mdadm.conf
>
> "POLICY
> This is used to specify what automatic behavior is allowed on devices
> newly appearing in the system and provides a way of marking spares
> that can be moved to other arrays as well as the migration domains.
>
> action=include, re-add, spare, spare-same-slot, or force-spare
> auto= yes, no, or homehost.
>
> The action item determines the automatic behavior allowed for devices
> matching the path and type in the same line. If a device matches
> several lines with different actions then the most permissive will
> apply. The ordering of policy lines is irrelevant to the end result.
>
> includeallows adding a disk to an array if metadata on that disk
> matches that arrayre-addwill include the device in the array if it
> appears to be a current member or a member that was recently
> removedspareas above and additionally: if the device is bare it can
> become a spare if there is any array that it is a candidate for based
> on domains and metadata.spare-same-slotas above and additionally if
> given slot was used by an array that went degraded recently and the
> device plugged in has no metadata then it will be automatically added
> to that array (or it's container)force-spareas above and the disk will
> become a spare in remaining cases
> "

Clearly you have read the documentation - excellent!
What exactly are you asking?
Presumably you have tried something and it didn't work.  What (exactly)
did you try?

NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAljHEPYACgkQOeye3VZi
gbmlng//cTzDKGSFwE96YwWmUYjZAPBQkK+Li0U8+F8FZ3d2e5yaURe5DNP93CgL
kja3c3lqqxwQiVrNUW/ZkbriCaDAF/rq1H+hwvS54Iw9/NCTdXLnLVOJ7D7M0ZiF
nrNpLaOWWziVi2YrnCgj3pMutMRmWPU+A3Rx6brGNHb2Hh9qQwfRw68pZK3Og6KA
AtUtZYQ+/GecEirE8sE+lOQcS95m2qUSlxw5/EttygDxQ7Mq88PgnJEDWMHf2K4d
rWwlP2vvgu/Hy3awdVMZ5O8+I51KZPllTxz7jpsE9odJO2RSG0lD8tYbwYoLpsXR
7RYgLWrVHOk1pLc+J57eJRfcJg86RarCwm42DppYRJUGbnjTvNZ0Pa6s6pufollh
NLiP1hMS+PSmfg6Xoc80PLp5TJFQlEoyGUewIeoP+dTsElqxDxFUoMOuuZ3C2Chj
pFPPSA61A5ISD2UHYHrD8UNDl4f5oJwqT42hVs1A9IKLfBfZ1PhC+/UQ8qye8xZL
5TO0XWPV7dTu9Imdb465Apr7BBn3ynTdPrS+Ntn+Yx+jwqqfZ+xOsZ5SLmJSI4AA
gDmRbC3WHZGbFWCW91BOpLY4iElLrX/vnNgl+jIJBZkNyuDiJGd1LS5H6NpHZzbf
W184JqBMHGowQrXEaJ+xCgKInqcX62UtKb5O59xh3XEacpkImmA=
=Zw4S
-----END PGP SIGNATURE-----
--=-=-=--
