From: NeilBrown <neilb@suse.com>
Subject: Re: 3-way mirror to RAID-6
Date: Tue, 26 Dec 2017 08:53:27 +1100
Message-ID: <87incu79uw.fsf@notabene.neil.brown.name>
References: <CAJH6TXg=uCQMmzSQPHC885naZj3cFOZx2oyx462mCBof9NeU+w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAJH6TXg=uCQMmzSQPHC885naZj3cFOZx2oyx462mCBof9NeU+w@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Gandalf Corvotempesta <gandalf.corvotempesta@gmail.com>, Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain

On Mon, Dec 25 2017, Gandalf Corvotempesta wrote:

> Hi to all
> I have a server with a 3way mirror.
> As I have to increase the total available space, one solution would be to
> replace all disks with bigger ones, but this is expensive.
>
> Another solution would be to add just one disk and then reshape from
> RAID-1 to RAID-6
>
> Do you have any guide on how to do this reshape on a running array ?
> Thank you.

I suggest you add the new device with "mdadm --add", then try the
reshape with "mdadm --grow /dev/mdXXX --level=6 --raid-devices-4".

It might not work quite that easily - I think you need to first convert
the raid1 to a 2-way mirror, but that is easy enough

 mdadm --grow /dev/mdxxx --raid-devices=2

NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAlpBc1cACgkQOeye3VZi
gbly1w//WvNWJ3sKpEoF1AasY1kjbB6KmL1h8KlJp+jCY10D1NRfAdtgBVkhG/9t
JuMuEC6I7fzLjMG/1Lk22dEc5+mN4tefXYhVu08cQD1nlpYQngrfp2H/7mWU/co8
YKpOTUvuwJddvSBO45vYmyC26bXbIF7F3lC6E0jiMijLaOappLeS6+oTAsAWdOso
7ElVKsy/Aq4Y+DIPOqGFp2z13xqvF7KSpCs/Yfn63Q36OaAXST03AFxyFawrLACt
0Wrk+1xigwEmOTBL+9q5DKcg3ly4sMY1BggG02y8MPrtuhUGDpO6SCMBlRcjAmEN
BwjBJg/eyweFw2C/Smxs0N+q+KSk8XR+LjJPrZDdn6pt6odJP9sKZ9MJrtL9Mtkf
/IUzphOXaPTX3bmLC7XJlhpCGv7BvFLsezdrjbNI0mtHonqTAUA6QdjslpqPCfCC
2cLS9uNfDz8F3puxk/tB4OtltwmBglxR3wwm3GoNYkr76VV1EMqwRc1lYQWHxao7
dlppqYh6JWPJ4AD2eWrSb27Bm9jJN7Voxhdntjg3ON2O5DCB+03yEerXEqar9w6L
itV2Iuptu8aWVgymSIxSVWZmXn0Bw0UAY88y4n5CuJRnJS2K/uW83EMyAO+VuUYR
/qUUW5bkyARnj4AruWovgw4BxB/bXZeGSn7gsLywpydo5TVP2Aw=
=gD5G
-----END PGP SIGNATURE-----
--=-=-=--
