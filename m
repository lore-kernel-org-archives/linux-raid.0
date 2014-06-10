From: NeilBrown <neilb@suse.de>
Subject: Re: RAID-10 explicitly defined drive pairs?
Date: Tue, 10 Jun 2014 10:11:22 +1000
Message-ID: <20140610101122.53d16123@notabene.brown>
References: <20111212115459.GC20730@fi.muni.cz>
	<4EE61EAE.20101@anonymous.org.uk>
	<20120106150823.GX25976@fi.muni.cz>
	<20120107075526.59ed433c@notabene.brown>
	<CAGRgLy4Q5FhHMAeU3egqEfFKR_h1HneReg0sD_+hCmsF3WDzQw@mail.gmail.com>
	<20120322213114.61fd4e44@notabene.brown>
	<CAGRgLy7N7m4zFY-EKe8ApUGSR3ZCUpOTZcRvLVLd5WAN2f+k9g@mail.gmail.com>
	<CAGRgLy7BaVTjacaqMVD1JNYgtTn6MAk9bN-GzDC8B0CypJWJmw@mail.gmail.com>
	<CAGRgLy5tauPMAoy=3QkErvtQPjz3FrNYTxQ-2rxTP6nO5tRXXQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/TShRXui4t/iEzje=oQ02XR5"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAGRgLy5tauPMAoy=3QkErvtQPjz3FrNYTxQ-2rxTP6nO5tRXXQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Alexander Lyakas <alex.bolshoy@gmail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/TShRXui4t/iEzje=oQ02XR5
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 9 Jun 2014 17:26:38 +0300 Alexander Lyakas <alex.bolshoy@gmail.com>
wrote:

> > Why do you refuse to freeze the array if it's not "idle"? What will
> > happen is that current recover/resync will abort, drives will be
> > added, and on unfreezing, array will resume (restart?) recovery with
> > all drives. If array was resyncing, however, it will start recovering
> > the newly added drives, because kernel prefers recovery over resync
> > (as we discussed earlier).
> Indeed, since dea3786ae2cf74ecb0087d1bea1aa04e9091ad5c, I see that you
> agree to freeze the array also in case it is recovering.

I guess I did..... though I don't remember seeing the email that you have
quoted.  I can see it in my inbox, but it seems that I never replied.  Maybe
I was too busy that day :-(

If there other outstanding issues, feel free to resend.
(If I don't reply it is more likely to be careless than deliberate, so in
general you should feel free to resend if I don't respond in a week or so).

NeilBrown

--Sig_/TShRXui4t/iEzje=oQ02XR5
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBU5ZNKjnsnt1WYoG5AQKhkw//clHVSx1dsm7KkkXD+kma1b40VKCzfi1C
hKq5T7WrT93Z5ybjRbcW+EfmgiZ9am2fJaa66nbdXMIArjkjt5CdDPk3eIVCOjaH
LZjOZiftYLVmPMczmNpJmcU1BM/SQi3Rizav5uIzOr7A8yWEwj5p9Kz6P+7+lo22
xNlxnAU8BfX2Vt2xAFout13K+4NrhlDxurOxXuInrPCD9JpBg7l2b7lpd0EF+ksN
BACPefVNOenT/C1uMUo7mgrXtIVbAsBSzR6lh4DWEOiTXg6zg7S2LT0SQZPJMKlq
Lkm/DXCItOcUHaZmDHrTM7m+M5QQElYpzpTcZEHyr+QVE4KJaV/VQkXUpTp+nuvG
E36EBeOZGkg8oDB9qE8La0Fj90PHOdj9CgPvjhTQ1wtKyg7+eV+vg2DUJamlgG2e
QJg67etsuxiXgAJn1QZI5pH5qN1Oi788AyABoyogQqu3xS6YhArxaK1TuF2OiWnj
hK7cItSgJ3du6YUAnneUF9RAkXK62C3e/LiKwZDh1bHOIK71AoZZlhb6lZ3S1CNt
wvB/W2A+O+2CV/5rgyG/+ADZPEWkJTV1ZXsoLiAdPVhHyqvbidIMgdSjkr+hIpIf
uWS6Ih02BJUjjmwPIu6UUJf4ybvPCI5WL2q2KItW6udZhkxZcNHVXB3i72i+nJse
mohtBGWzTIA=
=vYpX
-----END PGP SIGNATURE-----

--Sig_/TShRXui4t/iEzje=oQ02XR5--
