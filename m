From: NeilBrown <neilb@suse.de>
Subject: Re: degraded raid 6 (1 bad drive) showing up inactive, only spares
Date: Thu, 21 Jun 2012 07:56:49 +1000
Message-ID: <20120621075649.06cd9631@notabene.brown>
References: <F137B54C-A982-4EBC-A04B-5C47CA07BE12@googlemail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/.BtGbfkU1O0_bGS=wgv5SJA"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <F137B54C-A982-4EBC-A04B-5C47CA07BE12@googlemail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Martin Ziler <martin.ziler@googlemail.com>
Cc: linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/.BtGbfkU1O0_bGS=wgv5SJA
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sun, 17 Jun 2012 17:52:07 +0200 Martin Ziler <martin.ziler@googlemail.co=
m>
wrote:

> Hello everybody,
>=20
> long time no seen. As I was unable to find a permutation that would resul=
t in an fsck-output that looks ok I generated the 360.000 permutations usin=
g Neil's shell script. I then composed a little script that would try a per=
mutation, do the fsck, stop the raid an go on with the new possibility and =
inserted the fsck-output into a text-file. The whole 360.000 permutations j=
ust recently finished - after some 6 days of building and fscking. I have n=
ot yet analyzed the output. I did however search for the term "clean" as a =
positive result would possibly contain that term.
>=20
> I got 711 different drive-combinations that will result in this: /dev/md0=
: clean, 204968/849158144 files, 3394436623/3396621312 blocks.
>=20
> If there really is only one working drive order, I guess I am pretty much=
 doomed. I do hope I'll be able to rule out a large portion of those result=
s before going into some more detail. I did get it correct, though, that th=
ere is only one possible order resulting in a working array? I gotta figure=
 out how to analyze the output file now. It's 125 MB. I guess I'll probably=
 split it and load it into my spreadsheet. In one go I'd stumble across the=
 1.000.000 row-limit.
>=20
> regards,
>=20
> Martin

Yes, there is only one correct order.

711 is very close to 720 which is 6!  I wonder if that is significant.

Maybe you need "fsck -n -f" to force it to do a more thorough check even
though the fs appears to be clean.

If you "echo check > /sys/block/mdXX/md/sync_action", wait 30 seconds or so,
then "echo idle > ......", then check "mismatch_cnt", the correct ordering
should have a significantly lower number - probably zero.
Other orders will have a high number.

NeilBrown


--Sig_/.BtGbfkU1O0_bGS=wgv5SJA
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT+JHITnsnt1WYoG5AQIHHA/+K13X5sbOSRqrKudBrK2SAejPC3DgW31w
UjHabXjpzIN/TI+5lKKqxE4/R7wwQ6rHtjF5N6ebtT1lz5bNIht4IZgRlRcS1H7y
dKE0BtPTJyWCNCwXZVg7icC+yhyW1sck1SbnZWrg6nON1bu9suo8KHcYtu3qc+OB
rNrgv9uR+JyvqqoT7AupqTCZN7bud9gGPJ0Mg/+t6mrbC+4R8x7cD5Cqrt57M9SR
aIaRJNjM681/+ukrz+5kitaZK5RQZrorq7YhpO/ozmubAZflPRc1wXKDHXb7TTWJ
phAiIUvYAocSYwpRCFxTGS5pzbaO87pMsuRdgzOzjWZw0Cdb0e+UqNE3RCdCd6f+
hQ273uPWdneU63OkFVLLYWnDbvehDfE7AgzY6bhxQ+PpX1w4/JNAldVVIXKJcHS1
VxL8YvbU2YCtadAJl5ShYc44Dbx72rcXBb+By5BYmJC/xmjACdtwzzUHCxiAobFC
ipFjWezfMo5cl9oPQQ5ae2+lGYZZ23AFODKIGRHIi2JqkO1USF/y0Ukc3R18smbz
XnEsrAl+UtbSbHOT0M/xLB4bX3oFZMZLPDTHhfgN5oK7RJhq78c4da/s6Le4pevg
v+gmkK1nQQUHefqPsL0T9JktePuOyMLRHbHwd0Ss/pqhtzIeCFInYBuX2KZkt4xI
eBP8CDC+t/4=
=A4K5
-----END PGP SIGNATURE-----

--Sig_/.BtGbfkU1O0_bGS=wgv5SJA--
