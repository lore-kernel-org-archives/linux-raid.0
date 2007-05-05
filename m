From: Patrik Jonsson <patrik@ucolick.org>
Subject: Re: Linux SW RAID: HW Raid Controller/JBOD vs. Multiple PCI-e Cards?
Date: Sat, 05 May 2007 10:37:15 -0700
Message-ID: <463CC0CB.30508@ucolick.org>
References: <Pine.LNX.4.64.0705051228300.12744@p34.internal.lan>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigEE4C3B06D11CA57C93ACB83D"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0705051228300.12744@p34.internal.lan>
Sender: linux-raid-owner@vger.kernel.org
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigEE4C3B06D11CA57C93ACB83D
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Justin Piszcz wrote:
> However, if I want to upgrade to more than 12 disks, I am out of PCI-e
> slots, so I was wondering, does anyone on this list run a 16 port
> Areca or 3ware card and use it for JBOD?  What kind of performance do
> you see when using mdadm with such a card?  Or if anyone uses mdadm
> with less than a 16 port card, I'd like to hear what kind of
> experiences you have seen with that type of configuration.
I just recently got an ARC-1260 16-port card and tested md raid5 vs
Areca raid5 with 5x500gb WD RE2 drives. I didn't do anything exhaustive,
just ran bonnie++ on it, and I didn't play around with any parameters
either, but straight out of the box, the 1260 beat md in most of the
performance numbers by 10-50%. I think md did beat the 1260 slightly in
one characteristic, but I don't have the numbers in front of me right
now. If you are interested, I can probably dig them out.

I was disappointed to discover that the 1260 doesn't support SMART
passthrough. Even if you make the disks jbod, you can't use smartctl to
conduct self tests or read attributes. You can query the temperature and
smart health status (I think) through the areca cli interface, but
that's it.

In the end, I decided to save the cpu for numerical stuff and let the
Areca handle this array (also did an online conversion from raid5 to
raid6), so now I have a 10x500gb Areca raid6 and a 10x250gb md raid5,
all lvm'd together.

Another thing about the 1260 that you might want to watch out for: It
has compatibility problems with some consumer motherboards where you use
the 16x "graphics" slot for the raid card. If this is your plan, check
Areca's compatibility list first.

cheers,

/Patrik



--------------enigEE4C3B06D11CA57C93ACB83D
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (MingW32)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFGPMDRT+KvsdUW5p8RAkpWAKCXQFrZDs6gDqeOhNwwyRqyFMR7MACgkJZZ
P04YCh2g1c2Sa+NJpIlRJuI=
=uwqs
-----END PGP SIGNATURE-----

--------------enigEE4C3B06D11CA57C93ACB83D--
