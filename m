From: NeilBrown <neilb@suse.de>
Subject: Re: Add BBL to existing array
Date: Wed, 27 Aug 2014 21:07:00 +1000
Message-ID: <20140827210700.5a9b3e60@notabene.brown>
References: <20140827090707.GA15857@dolores.internal.speartail.com>
	<20140827192721.57c57c3b@notabene.brown>
	<20140827103213.GE15857@dolores.internal.speartail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/R_R11Lh0dxCxDDyoFjD0Om1"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20140827103213.GE15857@dolores.internal.speartail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Peter Hoeg <peter@hoeg.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/R_R11Lh0dxCxDDyoFjD0Om1
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 27 Aug 2014 18:32:13 +0800 Peter Hoeg <peter@hoeg.com> wrote:

> Hi,
>=20
> this isn't so much a question as it trying to document the situation
> with BBL's on Debian jessie, although if I've overlooked something,
> please let me know.
>=20
> Purpose: Add BBL to a RAID created by an earlier version of mdadm
> without BBL support.
>=20
> # mdadm --version
>=20
> mdadm - v3.3 - 3rd September 2013
>=20
>=20
> # uname -a
>=20
> Linux edith 3.14-2-amd64 #1 SMP Debian 3.14.15-2 (2014-08-09) x86_64 GNU/=
Linux
>=20

They should be new enough to handle bbls.

>=20
> # cat /proc/mdstat
>=20
> Personalities : [raid6] [raid5] [raid4]
> md0 : active raid6 sda2[0] sdd2[4] sdc2[3] sdb2[1]
>       5859439616 blocks super 1.2 level 6, 512k chunk, algorithm 2 [4/4] =
[UUUU]
>       bitmap: 1/2 pages [4KB], 1048576KB chunk
>=20
> unused devices: <none>
>=20
>=20
> As the system boots from the RAID, I thought I could be clever and
> simply edit /usr/share/initramfs-tools/scripts/local-top/mdadm and
> change the "--assemble" statements to add "--update=3Dbbl" which should
> take care of things after a reboot.
>=20
> It basically runs:
> # mdadm --assemble --scan --run --auto=3Dyes
>=20
> so it would become:
> # mdadm --assemble --update=3Dbbl --scan --run --auto=3Dyes

Sorry, --update and --scan are incompatible.

>=20
>=20
> That didn't work. I ended up in the initramfs and had to manually bring
> up the RAID as well as LVM to get the machine booted.

That would have been a good time to wield the --update=3Dbbl seeing you were
assembling the array anyway.


>=20
> Now, according to the manual with the version of mdadm on the machine,
> '--update=3Dbbl' is supported, however when asking mdadm directly, it
> doesn't seem to be the case:
>=20
> # mdadm --assemble --update=3D?
>=20
> mdadm: Valid --update options are:
>      'sparc2.2', 'super-minor', 'uuid', 'name', 'resync',
>      'summaries', 'homehost', 'byteorder', 'devicesize',
>      'no-bitmap', 'metadata', 'revert-reshape'

Oops.  I forgot to update that list when I added 'bbl' and 'no-bbl'.

Will be fixed in 3.3.3.


Thanks for the report,

NeilBrown


>=20
> So in all likelyhood, this is a Debian packaging issue.
>=20
> If anyone answers, please CC me as I am not subscribed to the list, thank=
s.
>=20
> --
> Regards,
> Peter
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


--Sig_/R_R11Lh0dxCxDDyoFjD0Om1
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBU/271Tnsnt1WYoG5AQIUhw//VUxF7lzIjPBPOZN5PPa7NWqRX3/FJcS3
lgzLybDuSemfv4C86dPmY1YBIo4nJxUdhpWFP7Wot2sUTIpRT8FWKR1/SG4GBUzD
tqnZYyUDQ5M5uUlJvI7UEcHnm8usrrOaT6eDQ6brtJ7UBp2a6rPxCW7ogWG6tAHZ
gidei4SLtrQS1tqWineE6+Rr6YtHfjxInIh0P2S7K2DIyAX6wh6UUdOAIZVg2HAp
C9lJ3+70KgZc+gb7V96U/T0nhRr7e+iZxm9D0V0gGJqt+pT8zUJukiWA7GBenIfE
ZhTh2u1yJ8OTolw3ff1hp451Z0/jZ3v7Y4FIBaEi0FhLaMA6L2KJriXsbt5fxTqm
074CEdHVf1SBeVhsP2lNXt88OMxl3LRkEvLPPJHVQ/10YfpTxnvQCWCT7ufFC93y
izk3yaPfTDZisP7MLiIBbcIkX00JD9mZcgtmJ7A1G7jQBoeqYfC97fPIxo20KA1g
1BRBfWEoqcYwDKDY05Sh40OKBMCy9ZOqL2kqQq8vaGg0ljYMJj/uUObrP5JyEJpW
Bgo9462UWAMHemKSAriLsSw6zJGaLEY7SHDJeSR/0jHYuxcPpGN1dYC03d3rR8NN
IV5+ydcbgKc7r/LuuCmS8nZL7j5Qt9Nv7elqCpH33maX3JkZgepZDQplanHuRLKV
S0cfnjwFtjk=
=2QVb
-----END PGP SIGNATURE-----

--Sig_/R_R11Lh0dxCxDDyoFjD0Om1--
