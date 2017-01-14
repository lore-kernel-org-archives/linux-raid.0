From: NeilBrown <neilb@suse.com>
Subject: Re: linux raid wiki - kernel autoassembly
Date: Sat, 14 Jan 2017 18:09:34 +1100
Message-ID: <87k29yf781.fsf@notabene.neil.brown.name>
References: <587941F9.6060708@youngman.org.uk>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <587941F9.6060708@youngman.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Wols Lists <antlists@youngman.org.uk>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain

On Sat, Jan 14 2017, Wols Lists wrote:

> When was this deleted from the kernel? Somebody on the suse list thinks
> it is still there, and I can't find any references to the kernel where
> it was deleted. I'd like to put a bit more info on the wiki.

It wasn't.  It is still there (as you found).
It only supports 0.90 metadata though, so by encouraging the use of 1.x,
we make kernel-autoassembly unavailable without actually removing any
code.

NeilBrown

>
> I've looked at md.c, and found functions autorun_array and
> autorun_devices, but I'm guessing these are looking for an array that's
> already been assembled by udev/mdadm.
>
> Cheers,
> Wol
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAlh5zq8ACgkQOeye3VZi
gbltGQ//VLRER4Tgcr2OzRluWDes2IC1sV8CaTlGUGRik1SH8eEq0kz6R8sbibRR
DV20L2nzNeoHMKdek0vWlg7CSF68wAoHMURuwEpMNdkOa41QAYc6/zhVFBYSewDQ
BTb8X2+vpKpdX1I21s+1RjS8douAQ6YEXlAEwS1eeeJrkgXscev62cY01V355D/H
2IHfUQ2srG/2gkTJ/gMBkXm7SdKlLLzp8YlmI6qupX56Jiw3lHzQAyak6bfpJenf
BFM1/nGGh5T3mAPQePxvF/AHR9uRiL1kWjn/Uu9SlQKh9AUURkoLYQBltcEEVw9j
/ELapYZddnC3+gZ6RW+qrU+ysOP98J13QNYQDH0wbG6hUS9pJS9NZxOGYsn5eOSk
5Ir2p2R3aI5QlEoL+DMR+HpxC3ZFQtR7WwLWC3ths+yDOsWeSqu+/AEIsCEoLhhc
pZg3apySlwVPnfG0FMJef66t5RtqUeS/KhyX/08gLtEUQuawJjhSi/sd2vaH10zc
aI0bm1QUsqIV7vwA6MmkBkWGHd4MSy4dP4zlcOdjchG3TTa+15Feee8qPcshxwuu
jmkqNJIeI2w0KEgVI7j+8rvGq8kOdDKXbeYTYahJa/B7e5DImNabxKfxzfeC6G36
D3eXE9G3806CxrsldbdOMCH+TJoC9oPD6kCj48JAoQyR0n2KR8k=
=OigF
-----END PGP SIGNATURE-----
--=-=-=--
