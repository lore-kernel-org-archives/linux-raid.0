From: NeilBrown <neilb@suse.de>
Subject: Re: --grow RAID6 gives: md: md_do_sync() got signal ... exiting +
 hang
Date: Tue, 7 May 2013 21:54:36 +1000
Message-ID: <20130507215436.46fb6857@notabene.brown>
References: <CANU9nTmqXjPFqU=p0vex2SgXjyv9L2NO5mafHoWqfH7n1kkhcw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/QK9NxCqSW0lKfqFU06dbm9v"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CANU9nTmqXjPFqU=p0vex2SgXjyv9L2NO5mafHoWqfH7n1kkhcw@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Ole Tange <tange@binf.ku.dk>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/QK9NxCqSW0lKfqFU06dbm9v
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 7 May 2013 13:36:56 +0200 Ole Tange <tange@binf.ku.dk> wrote:

> I am expanding my 9 harddisk RAID6 to 10 harddisk RAID6:
>=20
> md1 : active raid6 sdg[0] sdi[12](S) sdt[15](S) sdy[17](S) sdx[16](S)
> sdh[8] sdw[13] sdo[14] sdk[5] sdd[11] sdc[3] sdv[9] sdn[10]
>       27349121408 blocks super 1.2 level 6, 128k chunk, algorithm 2
> [9/9] [UUUUUUUUU]
>       bitmap: 2/2 pages [8KB], 1048576KB chunk
>=20
> It is, however, hanging the system.
>=20
> # remove the bitmap
> mdadm -v --grow /dev/md1 -b none
>=20
> # Do the reshape
> mdadm -v --grow /dev/md1 --raid-devices=3D10
> --backup-file=3D/root/back-md1
> mdadm: Need to backup 7168K of critical section..
>=20
> cat /proc/mdstat
> <<hangs>>
>=20
> dmesg says:
>=20
> [4328128.021614] md: reshape of RAID array md1
> [4328128.021618] md: minimum _guaranteed_  speed: 10000 KB/sec/disk.
> [4328128.021621] md: using maximum available idle IO bandwidth (but
> not more than 30000 KB/sec) for reshape.
> [4328128.021783] md: using 128k window, over a total of 3907017344k.
> [4328128.312637] md: md_do_sync() got signal ... exiting
>=20
> Disk I/O is blocked to the RAID.
>=20
> What to do?

What does
  grep . /sys/block/md1/md/*
show? Or does it hang?
What about "mdadm --examine /dev/sd*"

Did the "mdadm --grow" appear to complete, and return to the shell prompt?

What kernel version?  What mdadm version?

A hanging /proc/mdstat is definitely not a good sign.  The "got signal ...
exiting" isn't good either.  I would expect more messages with that.
You didn't just "grep md" in dmesg did you?  That is a complete dmesg output
for the entire time period that could possibly be relevant?

NeilBrown

--Sig_/QK9NxCqSW0lKfqFU06dbm9v
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUYjrfDnsnt1WYoG5AQIypA/9FXzTi7KgPqe/H+CFDNOH/qmqS+pm7Nrj
sPDBWuMNgcmFzQNnXY8OfAbIBPJllH5UFddJtdoUem8ol8OGmQ/7lI8dTb4o2Rsb
wNlVWTEBw4DnxjXjsF2O+KbQ6KQ1JKeLiGICd9EzvU+F55DTYlAyqhb2g33ENL6Y
V91D0qJinGoTuEdcEiOK12tQjzREfXiRiL4Mx/13vPf8XjYPHq7pVPLml1RtfAMG
TP+Zdg5HqhAyTM4Gk03Q48GOQ8NYrgb+qhttwbA3uecSOpuZQNFCd167HAp1ZK4a
QRhAzTFVR+XeoSKo7BTxlt2+r6kTNlmIsIXMQz4wU3f4AUcid3wG/MRvT5G4WEcf
Uh6ISXCrT9Loo9pqZliW5W+c89ZGkqPc9dO7FeUqmPjohtWX91RDJyvT4rht5H02
0WwHBH2DTv/lUNt1aWszPYqETVz2MiGTRmptG+2XXALm+VxfF1LMpMubTRGEuU3t
0TCUhfgeS+yKi62YVkUzJtFp2I5lSbfpPK61Uw5R291Dbsyz8LlkWElR6kgbHTSf
xxtsfEa9K0GcI2RjQaco4wwrtFzPjINDCrRZvlBiKs3mGY1Z+4bACGiebE9zdM1+
8Xp6BJHzWpLc6eqVj/qadEYM5T9cm+yM+zGZNuhbes/sIN9q9UfIPOES4FFyizBg
cZVElOA6QLA=
=wC5o
-----END PGP SIGNATURE-----

--Sig_/QK9NxCqSW0lKfqFU06dbm9v--
