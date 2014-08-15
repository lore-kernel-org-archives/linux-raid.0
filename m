From: NeilBrown <neilb@suse.de>
Subject: Re: Unable to re-add a disk  after a reboot.
Date: Fri, 15 Aug 2014 10:19:24 +1000
Message-ID: <20140815101924.1d09363d@notabene.brown>
References: <53ED416E.8010504@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/Zun_LRhyNvnAP4ZxFgO8NIr"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <53ED416E.8010504@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Ram Ramesh <rramesh2400@gmail.com>
Cc: Linux Raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/Zun_LRhyNvnAP4ZxFgO8NIr
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 14 Aug 2014 18:08:30 -0500 Ram Ramesh <rramesh2400@gmail.com> wrote:

> Hi,
>=20
>    I just finished converting a 3-disk raid5 to 4-disk raid6. After a=20
> reboot to start clean, I noticed that one of the disk (the new one I=20
> just added) was missing in /proc/partitions. This was disk 4 in my=20
> /dev/md0. Assuming some cable issue, I powered off, wiggled the cables=20
> and restarted and the device was found by kernel. However, md0 shows=20
> device missing and array degraded
>=20
>     lata [rramesh] 280 > cat /proc/mdstat
>     Personalities : [raid6] [raid5] [raid4]
>     md0 : active raid6 sdb1[0] sdd1[3] sdc1[1]
>            3906763776 blocks super 1.2 level 6, 512k chunk, algorithm 2
>     [4/3] [UUU_]
>=20
>     unused devices: <none>
>=20
> However my attempt to --re-add does not work.
>=20
>     lata [rramesh] 277 > sudo mdadm /dev/md0 --verbose --re-add /dev/sde1
>     mdadm: --re-add for /dev/sde1 to /dev/md0 is not possible

"re-add" only makes sense when you have a write-indent bitmap which you don=
't
have.
So you need to "--add" which marks the device as a spare and then starts a
complete rebuild.


> I checked the SMART and it shows a lot of reallocated_sector_ct errors=20
> also. So, the disk is dying, but I am not able understand why mdadm=20
> would not add.

It will "add".  It just wont "re-add".

NeilBrown


>=20
>     SMART Attributes Data Structure revision number: 16
>     Vendor Specific SMART Attributes with Thresholds:
>     ID# ATTRIBUTE_NAME          FLAG     VALUE WORST THRESH TYPE    =20
>     UPDATED  WHEN_FAILED RAW_VALUE
>        1 Raw_Read_Error_Rate     0x000b   091   091   016 Pre-fail=20
>     Always       -       53
>        2 Throughput_Performance  0x0005   100   100   054 Pre-fail=20
>     Offline      -       0
>        3 Spin_Up_Time            0x0007   135   135   024 Pre-fail=20
>     Always       -       426 (Average 425)
>        4 Start_Stop_Count        0x0012   100   100   000 Old_age =20
>     Always       -       59
>     *5 Reallocated_Sector_Ct   0x0033   001   001   005 Pre-fail=20
>     Always   FAILING_NOW 330*
>        7 Seek_Error_Rate         0x000b   098   098   067 Pre-fail=20
>     Always       -       2
>        8 Seek_Time_Performance   0x0005   100   100   020 Pre-fail=20
>     Offline      -       0
>        9 Power_On_Hours          0x0012   100   100   000 Old_age =20
>     Always       -       3445
>       10 Spin_Retry_Count        0x0013   100   100   060 Pre-fail=20
>     Always       -       0
>       12 Power_Cycle_Count       0x0032   100   100   000 Old_age =20
>     Always       -       59
>     192 Power-Off_Retract_Count 0x0032   100   100   000 Old_age =20
>     Always       -       548
>     193 Load_Cycle_Count        0x0012   100   100   000 Old_age =20
>     Always       -       548
>     194 Temperature_Celsius     0x0002   153   153   000 Old_age =20
>     Always       -       39 (Min/Max 21/43)
>     196 Reallocated_Event_Count 0x0032   001   001   000 Old_age =20
>     Always       -       17604
>     197 Current_Pending_Sector  0x0022   001   001   000 Old_age =20
>     Always       -       13256
>     198 Offline_Uncorrectable   0x0008   100   100   000 Old_age =20
>     Offline      -       0
>     199 UDMA_CRC_Error_Count    0x000a   200   200   000 Old_age =20
>     Always       -       0
>=20
> Any recommendations while I am waiting to get a replacement.
>=20
> Ramesh
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


--Sig_/Zun_LRhyNvnAP4ZxFgO8NIr
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBU+1SDDnsnt1WYoG5AQLztQ/9EhIfwyThVMiyL4QmKDHvjT26LxfwPWnj
89BV8E/N4gLX1kZ5Z8OsArkV2T5QJegUqpwU9oo+mYwL0PD0eTvJSTie9F1fWwbk
tGPmOqQxIeyQ79qGclGebffUJ/dlKxrFSAz3aXiKhx28BC6lBROxq0U+iOGv3aRW
sMvJvAwtPMTtKjGRRaRRp8HjvIUTuoSKKiVVN58/oFUabEZPd35Hq/dC8F06X72G
nBI+Os7Ya9UYeIS7MwgeraRA5fC9Cqc0+l2A2B/jLGgbpn3ig2OoQHYUKKynm9g9
fnw5RjnXpI/rEAUTPXrM597PROYBGmw5hXYCGXeUTcVfnut78rypUXWq6bp1m0U+
gcs1tQfbxqTA/itJ5Tod5X+mHM2ROlyu3vm5fHtetFh9hJrkUe0ImDonXvssBCYa
VhfTsn58KK8XAQWO7UmDRHeGFC0v20OMamispw/iaYAKOdKiOcNgelWTFKH/6GrD
bzj6NwJgdgk6VgWi8oJeXEEiQgFlVpQkgqIcoXZDGhRqKwsA3KrZ3cxsg8THF2Xr
5EiWwFqeWvpPknLdOMDf4EEJTLE+m2aChja9c9x9b4ww0QpVO9CGnl+aNV+dcHXo
mQFXP59O6syiaqky/9eHKkEo00xnROkSzSsPCk/PcoJNh5+sDLpVM9JD2nDATNIF
80U0PYTAfoM=
=35uk
-----END PGP SIGNATURE-----

--Sig_/Zun_LRhyNvnAP4ZxFgO8NIr--
