From: NeilBrown <neilb@suse.com>
Subject: Re: Feature request, resumable raid check action
Date: Mon, 05 Dec 2016 11:00:39 +1100
Message-ID: <87twaj5jo8.fsf@notabene.neil.brown.name>
References: <CAEtPA0Aosn6q0pJxsh69EpHQehiSsyeyVfJf98cDhu6kORkE1g@mail.gmail.com> <8737i76idm.fsf@notabene.neil.brown.name> <CAEtPA0C=xH0gCaigs-THNZRspmwD6d4WCrecjL-30M3PP0vxHw@mail.gmail.com> <87y3zy6evp.fsf@notabene.neil.brown.name> <CAEtPA0CMi6PiU1VC+3h78Wnr=t-ufkT3fz=tAT0hW0jVrAp5tQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAEtPA0CMi6PiU1VC+3h78Wnr=t-ufkT3fz=tAT0hW0jVrAp5tQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Patrick Dung <mpatdung@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain


(linux-raid added back to cc:)

On Fri, Dec 02 2016, Patrick Dung wrote:

> I rebooted while it was running.
> For a new RAID, the initial sync or resync would resume after reboot.
> I thought check would have the same semantic.
>
> If I am correct, the mdcheck script is designed for a 7x24 system.
> Users can pause the 'check' action and resume later.
>
> The problem is that I could not leave my computer running on 7x24.
> A full check may take about 12 hours for a 6TB RAID1.
>
> Ok, I recheck the script and found 'sync_min'
> I can use it to manually perform resumable check action.

Correct.
You could possibly even modify mdcheck to catch SIGTERM and close down
the resync early, remembering where it is up.  This might work well with
reboots.

NeilBrown


> Reference: https://www.kernel.org/doc/Documentation/md.txt

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAlhEricACgkQOeye3VZi
gblQ/A//XZs27TP3b1PiLWSPBuPQmrsRveyilMuNUg6izwDleVNFRKbEC8507YhB
UcP8mmnFq+LIEHdJT6SW/98dg/z0zopS0vEOkrceXyCkzy7XK9kPJgHoft/7165p
Ib0RkTErumtYlw9OfyJmJAHK1T/++bggq/O1Js9ZTWTN7NiyKIXFlfK7isITZCcJ
XmpGopJX0iEUzirg64HtdIF02vR8NvjQWV6OKlc1HtPmdbCaNTx2Y6ZojZLVlA2i
fv8v36kjY26Jo9uq7un8kXLUo+E4wIOxm6o0iytqcTFC+i0AghUObkqXfZECJ2O0
LiugQtfMkoNUf6g45uox6qh8TqcBTG0Ev1+wCJB3ezg6LxZM+5d01+qsCJ4Lb0Uc
jHO6SobcWsIsUVwp2LscjuEO+IuSb2N0hgyMvs5rYJgDyOZK2YPYbBws0Bja/sdf
3T8cNHhAFEoD51gpYk6PqnnQhfR2U1HvtBMlPNjqfzP0boS9Sb3q55Gz8iV6Owqv
oNHpEcPuIFhh9RoypzV0K3ZxI8z/dQi6zIitCUse0aXVq1s2ljzL37FuwIGN+sMS
jDhRTRqXewhe6FCkR0FaJ8BK0NFw81reHsmVET1ewykCZ8U4SsCtBPHXxwO0IUK2
A2gXNb8kWhy6bA0UJZFbLm3D4UT3t7sXNIf/LNaSr4cWCUoG/XQ=
=dZNS
-----END PGP SIGNATURE-----
--=-=-=--
