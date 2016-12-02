From: NeilBrown <neilb@suse.com>
Subject: Re: Feature request, resumable raid check action
Date: Fri, 02 Dec 2016 15:54:13 +1100
Message-ID: <8737i76idm.fsf@notabene.neil.brown.name>
References: <CAEtPA0Aosn6q0pJxsh69EpHQehiSsyeyVfJf98cDhu6kORkE1g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAEtPA0Aosn6q0pJxsh69EpHQehiSsyeyVfJf98cDhu6kORkE1g@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Patrick Dung <mpatdung@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain

On Wed, Nov 30 2016, Patrick Dung wrote:

> Hello,
>
> As I know if MD raid is using the newer metadata version, it support
> resumable raid rebuild/sync. (that is, if a server is rebooted during
> rebuild, it would resume from last position after reboot, instead of
> starting from beginning).
>
> In my recently testing (a few months ago):
> I sometimes use the mdadm 'check' action for doing the disk scrubbing
> of a MD raid.
> After I rebooted the server, the 'check' operation is forgotten and is
> not resumable.
>
> I think resumable 'check' operation is useful as the array size would
> become bigger in the future.

"check" is resumable.  md doesn't record where it is up to though, you
need to do that yourself.
The "misc/mdcheck" script in the mdadm package makes use of this to
support time-limited checking, and to resume from where it left off.
You could use the script, or read it and see how it works.

NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAlhA/nUACgkQOeye3VZi
gbn2LRAAumwua14iv+kso2IemO5TayKrp2TTigDJmD8nmtYK9RA5xMjtKPKGQoyb
Lw9Pt02IKDS663U5gqPJzd9LvpS2XDYpyM8VYdJVngOfT7fPRpXCN/3XMYdlOYUm
5Ap6tFfxC2Lm5lyOVFQCgzRA8NHutGvKe9EXKOracjndZQmGkyBh6OsKarTHeZOn
sT5bbgRI8LWEUb6qlRWjvftbtLINJPk3BS1sM/A82ae9T81it5/H0AezLskbR60i
XWDt+WjUKXDR3vkVOts/0qXF0b88KPB07Dd74/X8MP/i8w8NRr+REwQZ5VBeWTdm
BdT6PuiHXNwZHqGIqTQOZ9CQIEPU93czZ+3gZg1GQgYCIBMEYNhNb6N1sTx/4f+k
wxJNZgfXdxev7yEID198GW7MnaY9WhR2KXENAEbjIV9w3vJwsabLaufZgwAqAftG
YvRnhNPAXY7O/w9b3Oh86/ibor0vsPTamPv8mIcgQ20Kc5MhOL5li/Lc3cg5VTbV
YwuJ0ip2TpsLSPD9VyUEoUlCA0Emin7cVJEpxMuBwPTpY+yijtd3mg5Q6B9zu5hZ
aXBlu5i16jBT/LUbiqUVKerPklAqdbDg/KWD8YG3COMUFsuFbejyDY2RgLOHQuY5
xBCTqNQCN1OYE3LoAKWdA7Cc2Pxw+0dRCIxo/UB83Wntp6CDGFU=
=/Nux
-----END PGP SIGNATURE-----
--=-=-=--
