From: NeilBrown <neilb@suse.com>
Subject: Re: RAID 6 "Failed to restore critical section for reshape, sorry." - recovery advice?
Date: Wed, 23 Dec 2015 13:18:05 +1100
Message-ID: <871tad3o2q.fsf@notabene.neil.brown.name>
References: <CAF-Kpgb57-LoNy=-jy76ZcE=YPABmARzfsHNitJNZyw3v2AShw@mail.gmail.com> <alpine.DEB.2.02.1512100918520.20919@uplift.swm.pp.se> <CAF-KpgaLr-qA_RJiDYstFv-=EoHH-Ea3o1q3G3tXC4nX=Wt2XA@mail.gmail.com> <CAF-KpgYe9Vxgcy2E5T1_9HdEM0YMfATMzN7WcjHra_EE+sOOTg@mail.gmail.com> <87d1u060sv.fsf@notabene.neil.brown.name> <CAF-Kpga8toqetF+g6wYbUVHKngkRB8QMTyRy39Jnxn0P6w8ouQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAF-Kpga8toqetF+g6wYbUVHKngkRB8QMTyRy39Jnxn0P6w8ouQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: George Rapp <george.rapp@gmail.com>
Cc: Mikael Abrahamsson <swmike@swm.pp.se>, Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain

On Wed, Dec 23 2015, George Rapp wrote:

>
>> The current state of the array is (I think) that it looks like a reshape
>> to reduce the number of devices in the array has very nearly completed.
>> Only the first stripe needs to be completed.  Whether that first stripe
>> is still in the old "N+1" device layout or the new "N" device layout is
>> unknown to the kernel - this information is only in the backup file
>> (which doesn't exist).
>
> Hmmm. Maybe you're thinking of a different case. This is mine:
> http://marc.info/?l=linux-raid&m=143880359028232&w=2
>
> My problem was that I was *increasing* the number of devices from 5 to
> 6. Also, I don't believe the reshape actually got anywhere, per
> /proc/mdstat, which I was watching at the time, because the kernel was
> denied write access to my backup file by SELinux.

Yes, but then you did "--assemble --update=revert-reshape" didn't you?
So now it looks like it is being reduced in size.

> I was able to dump the metadata from the six component devices of the
> RAID 6 array with:
>
> # mdadm --dump=/home/gwr/c/dev-md4-mdadm-dump /dev/sdj1
> /dev/sdj1 saved as /home/gwr/c/dev-md4-mdadm-dump/sdj1.
> /dev/sdj1 also saved as
> /home/gwr/c/dev-md4-mdadm-dump/wwn-0x5000cca222d7b996-part1.
> /dev/sdj1 also saved as
> /home/gwr/c/dev-md4-mdadm-dump/wwn-0x13372914453769768960x-part1.
> /dev/sdj1 also saved as
> /home/gwr/c/dev-md4-mdadm-dump/ata-Hitachi_HUA722020ALA331_B9HP5Y2F-part1.

Oh, that's right - you give component device names to --dump, not the
array.  Sorry.

>
> but after doing that, I have a whole bunch of huge (presumabily
> sparse) files in my output directory:
>
> [root@backend3 dev-md4-mdadm-dump]# ll
> total 192
> -rw-r--r-- 4 root root 1964963324416 Dec 22 20:42
> ata-Hitachi_HUA722020ALA331_B8HGR23Z-part1
...
> -rw-r--r-- 4 root root 1964963324416 Dec 22 20:42
> wwn-0x6368721060505866240x-part1
> -rw-r--r-- 4 root root 1964968599552 Dec 22 20:42
> wwn-0x7703416737422790657x-part4
>
> and "tar -c -v -z -f dev-md4-mdadm-dump.tar.gz dev-md4-mdadm-dump/"
> didn't produce a tiny file, but a huge one (15MB and growing in just
> 10 minutes), so I killed it.
>
> Any further thoughts about how to proceed? Thanks for your help.

Maybe add "-S" option to tar.
I don't do this often enough to remember the details.  I though tar
auto-detected sparse files, but apparently not.

NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJWegRdAAoJEDnsnt1WYoG59QsQAKXAzEvYL9zEr3ZaEjkUtELP
k6YznQO1GdiBEyXemPOmzcacBs+CLIToG8QD6K0qGabov8BDe8brSpeVtAufrU7+
bBSGCPgwMwnzUT/BGms5XmbFJx9nSB8B2kAtbWFGYsF/gzltCDK5PfCpHT4Xx/8J
DQZ/IppMoV480Gn9ZHE+sEPq2GgaVCo/mlFfTVDsHXyQmfj0M0wypGYY+wYUyCfB
PxFOkHmg12FLEjJ+Kpv15HRujJYFwiyUjnI5WU/WKGUg4aFvANni6bfLu8Y6rmwZ
KkS8w3YEAokRptiACz13up5md08CYoBmJ5Wr5Ut0b7I6QrwubkLXBu95YW4mhq47
ypNa1DXpXlpmmacMgA7DgT+jRpYXpQ7e0N2EQp2Cw112d4AeLrsE4kCiP75qeDcd
XEFDEXycKgxwaGuv9Q3Xl+yXSBiufyIGS7rv8cfMdPYrFQxUdnwyp3Xi0I7Gq4p+
FnDckQ/M8neb2y6a9lbL3QblqxMv8+q0XqLVKgjy5rBM7xaG5UH3jN0L5U9NgNjx
4a2sFzFQG0ATz1CVBfSZJmNBmCdNllqeJA+lGBi0/A1XuwYI0yIO7jGlCPocYZZu
aIxFg3hVsqnIYneaTocCyUE6/qpirKyWon4jtGxCKKyEng5kXWCrsKb21yFKeIsN
rq6zUoQ4Et0BkX6b4j/7
=kG6Y
-----END PGP SIGNATURE-----
--=-=-=--
