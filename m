From: NeilBrown <neilb@suse.com>
Subject: Re: Fwd: Re: mdadm I/O error with Ddf RAID
Date: Tue, 22 Nov 2016 10:54:40 +1100
Message-ID: <87polocrsv.fsf@notabene.neil.brown.name>
References: <CAPO=kN2QDLEMgo9p9pU3=MeLQ=J6R8eeDL1Pw9m2pHjbVsuFGg@mail.gmail.com> <874m3ak3ci.fsf@notabene.neil.brown.name> <CAPO=kN3psOzSYzbKZ5dAGK5uEk3JfTSf-Ec+S_UTL0iaD78Pdg@mail.gmail.com> <87oa1ehd06.fsf@notabene.neil.brown.name> <CAPO=kN2NwC1nZKzmWCEzkxN=OZrYOJFOq__pttqfiLWo-4fJSw@mail.gmail.com> <CAPO=kN3pSizni=e3N3zxktSjQWsRL7T_GwZJdUUyKzCjM-0MWw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAPO=kN3pSizni=e3N3zxktSjQWsRL7T_GwZJdUUyKzCjM-0MWw@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Arka Sharma <arka.sw1988@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain

On Tue, Nov 22 2016, Arka Sharma wrote:

> ---------- Forwarded message ----------
> From: "Arka Sharma" <arka.sw1988@gmail.com>
> Date: 21 Nov 2016 12:57 p.m.
> Subject: Re: mdadm I/O error with Ddf RAID
> To: "NeilBrown" <neilb@suse.com>
> Cc: <linux-raid@vger.kernel.org>
>
> I have run mdadm --examine on both the component devices as well as on
> the container. This shows that one of the component disk is marked as
> offline and status is failed. When I run mdadm --detail on the RAID
> device it shows the component disk 0 state as removed. Since I am very
> much new to md and linux in general I am not able to fully root cause
> this issue. I have made couple of observation though, that before the
> invalid sector 18446744073709551615 is sent, the sector 1000182866 is
> accessed after which mdraid reports as not clean starts background
> reconstruction. I read the LBA 1000182866 and this block contains FF.
> So is md expecting something in the metadata we are not populating ?
> Please find the attached md127.txt which is the output of the mdadm
> --examine <container>, blk-core_diff.txt which contains the printk's
> and dmesg.txt, also DDF_Header0.txt and DDF_Header1.txt are the dump
> of ddf headers for both the disks.

Thanks for providing more details.

Sector 1000182866 is 256 sectors into the config section.
It starts reading the config section at 1000182610 and gets 256 sectors,
so it reads the rest from 1000182866 and then starts the array.

My guess is that md is getting confused about resync and recovery.
It tries a resync, but as the array appears degraded, this code:
		if (test_bit(MD_RECOVERY_REQUESTED, &mddev->recovery))
			j = mddev->resync_min;
		else if (!mddev->bitmap)
			j = mddev->recovery_cp;

in md_do_sync() sets 'j' to MaxSector, which is effectively "-1".  It
then starts resync from there and goes crazy.  You could put a printk in
there to confirm.

I don't know why.  Something about the config makes mdadm think the
array is degraded.  I might try to find time to dig into it again later.

NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBCAAGBQJYM4lBAAoJEDnsnt1WYoG5z64QAMO38+x9wYiUCzcB8TKBx7vP
/NYOcx727qLcxolMe9M6LxVYdqomb3sM0iE0inDM+Wx9OJ2hEdVfLJv/FJIuz9yN
8XAEjhEGIl5XghzwFm07aWn10hWJUuCD3t5Ex7mIkpBwM0B4Rq8LV4R+caOmOzH0
UmEN94M7ev7pCpZlmcv6co/wbWUZn6pDW3BULrwm3XgmwrR1VJ7ziHjJyvUIcOWd
s+26qwYne7qbGneMmrRsxxst1fbN4q8LQ9HwmexzOEifFuN2yFBVwKq677T8jOsw
5ejndVtqpOKzAfc9o3PushlYYIAY/0ybv/BYW3T3DHE2jti1muFRmoX7AOh1GusC
uKeKUQkWf8TVlsvgAAUshBDOf3vTL1k3CliWib7Xxj2pa03sEBcRWWguD+9TDQQY
+kbs/ILzR/YlBbegswm/5Lq3Fm7kXYjJlZQuq/vPa1uztQi4yJhwf/q3KmFMqoqu
BGqdHDKqQ8ZUdmzb+sf2OE4KxBmzTd5aCsNTE3pCXw6qYK0Fwc9L3jWrKdXvBtTd
+NMdzI1bdofE6NNMoOvOfyo9qakQyBWaAsOhkDCqgqq15AtF/5hfIqbMhTCz+vfw
a3a+yKu/wV5xPXwo+RK76y6OwojVxtEdzqdE+HZW1r7YQXCmEgJHc0munSGv9T1Q
BYOJT79DJEHeY92Jvcyl
=HpHe
-----END PGP SIGNATURE-----
--=-=-=--
