From: NeilBrown <neilb@suse.de>
Subject: Re: MDADM 3.3 broken?
Date: Tue, 19 Nov 2013 11:01:10 +1100
Message-ID: <20131119110110.396b2af3@notabene.brown>
References: <CAGRSmLviYJtCfNiARKW0FvrJ0BUDrvhPnQy2drzbkf95-Gfpag@mail.gmail.com>
	<528A7721.8080604@arcor.de>
	<CAGRSmLvRVQtrkYPLS8NfRS+DvyS0xZ72cwVdLygb0w5KbVrARA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/WnPsjiUu6JIqLe/ipLq/fEk"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAGRSmLvRVQtrkYPLS8NfRS+DvyS0xZ72cwVdLygb0w5KbVrARA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: "David F." <df7729@gmail.com>
Cc: Martin Wilck <mwilck@arcor.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/WnPsjiUu6JIqLe/ipLq/fEk
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 18 Nov 2013 15:13:58 -0800 "David F." <df7729@gmail.com> wrote:


> output of 'mdadm --assemble --scan --no-degraded -v' (mdadm 3.2.6):
...
> mdadm: no RAID superblock on /dev/sdc2



>=20
> output1 of 'mdadm --assemble --scan --no-degraded -v' (mdadm 3.3 -
> note using /dev/sdc2, not /dev/sdc):
.....
> mdadm: /dev/sdc2 is identified as a member of /dev/md/imsm0, slot -1.

So there is the problem.  mdadm 3.2.6 sees no RAID superblock on sdc2, while
mdadm 3.3 does (but should not).


However that code hasn't changed!

load_super_imsm() still starts with:


	if (test_partition(fd))
		/* IMSM not allowed on partitions */
		return 1;


and test_partition hasn't changed since it was written in April 2010 for
mdadm 3.1.3.

So I'm quite perplexed.

Is your mdadm-3.3 compiled from source or provided by a distro?

Can you run the "mdadm --assemble" under strace and post the result?

  strace -o /tmp/some-file mdadm --assemble --scan ......

Thanks,
NeilBrown

--Sig_/WnPsjiUu6JIqLe/ipLq/fEk
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUoqqRjnsnt1WYoG5AQLvsg//Z0itgPBm1i7z//NMsta9NwBA3ZDBhRn7
e7DA5QXvXtSrhC5Yin/HTI0VloC23OB6Vn/y+dzRjd4V0H2fX50YFMGzHWTz6cMI
Sya/6oXDrka3vg8lM5tRtoAVsCsulTbUHpGc9u+hClbqDA5d72Yk7c0iSMH8gP9R
sEy01VOPodti6ro2R2Moz6v11gAI7rniScoOVppSMANc2WMIVQHTSIIjJ3euczXe
A3+LksiF9P85k6EOnor5h7Rsk3suPxc4eeDdhSK59NxEAYDJ1GCvRea+sHzXBHwe
jBgSWNkmIYVnBKlApQInDKXRydyh5kWQA3duTaoKmafr9vDQLPzogFCugrjqGekp
1Lrlf29/GTlYvPzdy+KT5QWOOCABPy/XC5YDIeYTuZPvP+pUMUlWfI0LeZIF57a5
nZhEXB6hTGYDSRJZ6RoIcMs7iBgd3IayNrcF/zdmPs8Mzxx8s5McyDfmGg5ykoXC
NDXb+5r1Wapfg8kcaciNV+z1QL6UXunNTGAHnkd2OJQOOqA3uIee1atRdE9al1aK
4wqNLVWJdKlipQ8P4Bq64CUl4uATFfPB5SEHXHKffQprG9vGtsLCmEX5FYwX2CCp
ob1qa3f+j5kHdMrqgYtqCZTqQ2Lfw81bGvbVpo/KKmCltfDufZ8lVORcd8Xk8d1z
m8WtfWESWCU=
=tm6K
-----END PGP SIGNATURE-----

--Sig_/WnPsjiUu6JIqLe/ipLq/fEk--
