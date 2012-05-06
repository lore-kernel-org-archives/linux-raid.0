From: NeilBrown <neilb@suse.de>
Subject: Re: Yet another corrupt raid5
Date: Sun, 6 May 2012 16:00:44 +1000
Message-ID: <20120506160044.5b3a50c2@notabene.brown>
References: <4FA52031.2040608@philippwendler.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/NmuoL0GfnqpKhMByC5KENXI"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4FA52031.2040608@philippwendler.de>
Sender: linux-raid-owner@vger.kernel.org
To: Philipp Wendler <ml@philippwendler.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/NmuoL0GfnqpKhMByC5KENXI
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sat, 05 May 2012 14:42:25 +0200 Philipp Wendler <ml@philippwendler.de>
wrote:

> Hi,
>=20
> sorry, but here's yet another guy asking for some help on fixing his
> RAID5. I have read the other threads, but please help me to make sure
> that I am doing the correct things.
>=20
> I have a RAID5 with 3 devices and a write intent bitmap, created with
> Ubuntu 11.10 (Kernel 3.0, mdadm 3.1) and I upgraded to Ubuntu 12.04
> (Kernel 3.2, mdadm 3.2.3). No hardware failure happened.
>=20
> Since the first boot with the new system, all 3 devices are marked as
> spares and --assemble refuses to run the raid because of this:
>=20
> # mdadm --assemble -vv /dev/md0 /dev/sdb1 /dev/sdc1 /dev/sdd1
> mdadm: looking for devices for /dev/md0
> mdadm: /dev/sdb1 is identified as a member of /dev/md0, slot -1.
> mdadm: /dev/sdc1 is identified as a member of /dev/md0, slot -1.
> mdadm: /dev/sdd1 is identified as a member of /dev/md0, slot -1.
> mdadm: added /dev/sdc1 to /dev/md0 as -1
> mdadm: added /dev/sdd1 to /dev/md0 as -1
> mdadm: added /dev/sdb1 to /dev/md0 as -1
> mdadm: /dev/md0 assembled from 0 drives and 3 spares - not enough to
> start the array.
>=20
> # cat /proc/mdstat
> Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5]
> [raid4] [raid10]
> md0 : inactive sdc1[0](S) sdb1[1](S) sdd1[3](S)
>       5860537344 blocks super 1.2
>=20
> # --examine /dev/sdb1
>           Magic : a92b4efc
>         Version : 1.2
>     Feature Map : 0x0
>      Array UUID : c37dda6d:b10ef0c4:c304569f:1db0fd44
>            Name : server:0  (local to host server)
>   Creation Time : Thu Jun 30 12:15:27 2011
>      Raid Level : -unknown-
>    Raid Devices : 0
>=20
>  Avail Dev Size : 3907024896 (1863.01 GiB 2000.40 GB)
>     Data Offset : 2048 sectors
>    Super Offset : 8 sectors
>           State : active
>     Device UUID : 4635f495:15c062a3:33a2fe5c:2c4e0d6d
>=20
>     Update Time : Sat May  5 13:06:49 2012
>        Checksum : d8fe5afe - correct
>          Events : 1
>=20
>    Device Role : spare
>    Array State :  ('A' =3D=3D active, '.' =3D=3D missing)
>=20
>=20
> I did not write on the disks, and did not execute any other commands
> than --assemble, so from the other threads I guess that I can recreate
> my raid with the data?

Yes, you should be able to.  Patience is important though, don't rush thing=
s.

>=20
> My questions:
> Do I need to upgrade mdadm, for example to avoid the bitmap problem?

No.  The 'bitmap problem' only involves adding an internal bitmap to an
existing array.  You aren't doing that here.

>=20
> How I can I backup the superblocks before?
> (I'm not sure where they are on disk).

You can't easily.  The output of "mdadm --examine" is probably the best
backup for now.


>=20
> Is the following command right:
> mdadm -C -e 1.2 -5 -n 3 --assume-clean \
>   -b /boot/md0_write_intent_map \
>   /dev/sdb1 /dev/sdc1 /dev/sdd1

If you had an external write-intent bitmap and 3 drives is a RAID5 which
were, in order , sdb1, sdc1, sdd1, then it is close.
You want "-l 5" rather than "-5"
You also want "/dev/md0" after the "-C".

>=20
> Do I need to specify the chunk-size?

It is best to, else it will use the default which might not be correct.

> If so, how can I find it out?

You cannot directly.  If you don't know it then you might need to try
different chunk sizes until you get an array the presents your data correct=
ly.
I would try the chunksize that you think is probably correct, then "fsck -n"
the filesystem (Assuming you are using extX).  If that works, mount read-on=
ly
and have a look at some files.
If it doesn't work, stop the array and try with a different chunk size.

> I think I might have used a custom chunk size back then.
> -X on my bitmap says Chunksize is 2MB, is this the right chunk size?

No.  The bitmap chunk size (should be called a 'region size' I now think) is
quite different from the RAID5 chunk size.

However the bitmap will record the total size of the array.  The chunksize
must divide that evenly.  As you have 2 data disks, 2*chunksize must divide
the total size evenly.  That will put an upper bound on the chunk size.

The "mdadm -E" claims the array to be 3907024896 sectors which is 195351244=
8K.
That is 2^10K * 3 * 635909
So that chunk size is at most 2^9K - 512K, which is currently the default.
It might be less.

>=20
> Is it a problem that there is a write intent map?

Not particularly.

> -X says there are 1375 dirty chunks.
> Will mdadm be able to use this information, or are the dirty chunks just
> lost?

No mdadm cannot use this information, but that is unlikely to be a problem.
"dirty" doesn't mean that the parity is inconsistent with the data, it means
that the parity might be inconsistent with the data.  It most cases it isn'=
t.
And as your array is not degraded, it doesn't matter anyway.

Once you have you array back together again you should
   echo repair > /sys/block/md0/md/sync_action
to check all the parity blocks and repair any that are found to be wrong.


>=20
> Is the order of the devices on the --create command line important?
> I am not 100% sure about the original order.

Yes, it is very import.
Every time md starts the array it will print a "RAID conf printout" which
lists the devices in order.  If you can find a recent one of those in kernel
logs it will confirm the correct order.  Unfortunately it doesn't list the
chunk size.


>=20
> Am I correct that, if I have backuped the three superblocks, execute the
> command above and do not write on the created array, I am not in danger
> of risking anything?

Correct.

> I could always just reset the superblocks and then I am exactly in the
> situation that I am now, so I have multiple tries, for example if chunk
> size or order are wrong?

Correct

> Or will mdadm do something else do my raid in the process?

It should all be fine.
It is important that the metadata version is the same (1.2) otherwise you
could corrupt data.
You should also check that the "data offset" of the newly created array is
the same as before (2048 sectors).

>=20
> Should I take any other precautions except stopping my raid before
> shutting down?

None that I can think of.

>=20
> Thank you very much in advance for your help.

Good luck, and please accept my apologies for the bug that resulted in this
unfortunate situation.

NeilBrown


--Sig_/NmuoL0GfnqpKhMByC5KENXI
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT6YTjDnsnt1WYoG5AQJc/w/7BD3KEBaxDWagY85LU13/6r8SFbNjsu+J
4DuACK2Ql9sVOCZXps+T9tf4DgMTqBEZMpflmveG+nljSVf4ONwN90Xn6eQzQclf
M0fpQ5R6irdw8ID0uADR3WCWDNm5YrzInYh2Qn1S5XAdKgPZungt6+ojPuzX+Vsf
IQuarvWBtpmdjdv3+b87O8i2h/R9oUs0V3lt7ArDxnoNJ2464TG91MxZAZoS+6jj
0KGVrxHj/Xp10nKULwo7zhTKF8PzeEBSKUiJ75XJQmfVWUBwN4MvLEzUQn6ZMqOs
VS2qqKfUP5uQwm8HrJF13akCuEUwJwJhjXcnMb1cOIWD7zmrAxRR+Aqjjg5oqnAc
xnK2t5fu3hHTV12QnB0r/nC3mdPE85uctLE5rWusWKmmo5OvseF24b85AdNogCzH
58IxCLlQevjKke+k9KvJMF7FuR5YK7CKa0i2//ePaDDnazVH4jrPoiXZLOfwQ2el
4gjEpjkDxXYeeYVSqn9dOJtryczB2qpcPA+5Ly+KFJaYuK2gOrJqE9iuTS2+kgRF
S4wLeU2t07sHsKNfBwiTvUNEW5VoFZwpEabM3UgnCFnBxD4X4kPg+3UalcyB5+sy
pSb5MD67ewlP5QOgJM2nVh11MDT2mbETpZjjCHOPLYvOyoG2/d/37XuO34Ni3jkB
r2E7yqd7dTg=
=catF
-----END PGP SIGNATURE-----

--Sig_/NmuoL0GfnqpKhMByC5KENXI--
