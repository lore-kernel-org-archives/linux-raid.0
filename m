From: NeilBrown <neilb@suse.de>
Subject: Re: Recovering from two raid superblocks on the same disks
Date: Mon, 28 May 2012 21:40:03 +1000
Message-ID: <20120528214003.6269b535@notabene.brown>
References: <4FC325EF.4020103@aeoncomputing.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/=KyVGveTxpef2eDmuwms_cL"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4FC325EF.4020103@aeoncomputing.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jeff Johnson <jeff.johnson@aeoncomputing.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/=KyVGveTxpef2eDmuwms_cL
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 28 May 2012 00:14:55 -0700 Jeff Johnson
<jeff.johnson@aeoncomputing.com> wrote:

> Greetings,
>=20
> I am looking at a very unique situation and trying to successfully 1TB=20
> of very critical data.
>=20
> The md raid in question is a 12-drive RAID-10 sitting between two=20
> identical nodes via a shared SAS link. Originally the 12 drives were=20
> configured as two six drive RAID-10 volumes using the entire disk device=
=20
> (no partitions on member drives). That configuration was later scrapped=20
> in favor of a single 12-drive RAID-10 but in this configuration a single=
=20
> partition was created and the partition was used as the RAID member=20
> device instead of the entire disk (sdb1 vs sdb).
>=20
> One of the systems had the old two six-drive RAID-10 mdadm.conf file=20
> left in /etc. Due to a power outage both systems went down and then=20
> rebooted. When one system, the one with the old mdadm.conf file, came up=
=20
> md referenced the file, saw the intact old superblocks at the beginning=20
> of the drive and started an assemble and resync of those two six-drive=20
> RAID-10 volumes. The resync process got to 40% before it was stopped.
>=20
> The other system managed to enumerate the drives and see the partition=20
> maps prior to the other node assembling the old superblock config. I can=
=20
> still see the newer md superblocks that start on the partition boundary=20
> rather than the beginning of the physical drive.
>=20
> It appears that md overwrite protection was in a way circumvented by the=
=20
> old superblocks matching the old mdadm.conf file and not seeing=20
> conflicting superblocks at the beginning of the partition boundaries.
>=20
> Both versions, old and new, were RAID-10. It appears that the errant=20
> resync of the old configuration didn't corrupt the newer RAID config=20
> since the drives were allocated in the same order and the same drives=20
> were paired (mirrors) in both old and new configs. I am guessing that=20
> since the striping method was RAID-0 the absence of stripe parity to=20
> check kept the data on the drives from being corrupted. This is=20
> conjecture on my part.
>=20
> Old config:
> RAID-10, /dev/md0, /dev/sd[bcdefg]
> RAID-10, /dev/md1, /dev/sd[hijklm]
>=20
> New config:
> RAID-10, /dev/md0, /dev/sd[bcdefghijklm]1
>=20
> It appears that the old superblock remained in that ~17KB gap between=20
> physical start of disk and the start boundary of partition 1 where the=20
> new superblock was written.
>=20
> I was able to still see the partitions on the other node. I was able to=20
> read the new config superblocks from 11 of the 12 drives. UUIDs, state,=20
> all seem to be correct.
>=20
> Three questions:
>=20
> 1) Has anyone seen a situation like this before?

I haven't.

> 2) Is it possible that since the mirrored pairs were allocated in the=20
> same order that the data was not overwritten?

Certainly possible.

> 3) What is the best way to assemble and run a 12-drive RAID-10 with=20
> member drive 0 (sdb1) seemingly blank (no superblock)?

It would be good to work out exactly why sdb1 is blank as knowing that might
provide a useful insight into the overall situation.  However it probably
isn't critical.

The --assemble command you list below should be perfectly safe and allow
read access without risking any corruption.
If you
   echo 1 >  /sys/module/md_mod/parameters/start_ro

then it will be even safer (if that is possible).  It will certainly not wr=
ite
anything until you write to the array yourself.
You can then 'fsck -n', 'mount -o ro' and copy any super-critical files bef=
ore
proceeding.
I would then probably
   echo check > /sys/block/md0/md/sync_action

just to see if everything is ok (low mismatch count expected).

I also recommend removing the old superblocks.
 mdadm --zero /dev/sdc --metadata=3D0.90

will look for a 0.90 superblock on sdc and if it finds one, it will erase i=
t.
You should first double check with
   mdadm --examine --metadata=3D0.90 /dev/sda
to ensure that is the one you want to remove
(without the --metadata=3D0.90 it will look for other metadata, and you mig=
ht
not want it to do that without you checking first).

Good luck,
NeilBrown


>=20
> The current state of the 12-drive volume is:  (note: sdb1 has no=20
> superblock but the drive is physically fine)
>=20
> /dev/sdc1:
>            Magic : a92b4efc
>          Version : 0.90.00
>             UUID : 852267e0:095a343c:f4f590ad:3333cb43
>    Creation Time : Tue Feb 14 18:56:08 2012
>       Raid Level : raid10
>    Used Dev Size : 586059136 (558.91 GiB 600.12 GB)
>       Array Size : 3516354816 (3353.46 GiB 3600.75 GB)
>     Raid Devices : 12
>    Total Devices : 12
> Preferred Minor : 0
>=20
>      Update Time : Sat May 26 12:05:11 2012
>            State : clean
>   Active Devices : 12
> Working Devices : 12
>   Failed Devices : 0
>    Spare Devices : 0
>         Checksum : 21bca4ce - correct
>           Events : 26
>=20
>           Layout : near=3D2
>       Chunk Size : 32K
>=20
>        Number   Major   Minor   RaidDevice State
> this     1       8       33        1      active sync   /dev/sdc1
>=20
>     0     0       8       17        0      active sync
>     1     1       8       33        1      active sync   /dev/sdc1
>     2     2       8       49        2      active sync   /dev/sdd1
>     3     3       8       65        3      active sync   /dev/sde1
>     4     4       8       81        4      active sync   /dev/sdf1
>     5     5       8       97        5      active sync   /dev/sdg1
>     6     6       8      113        6      active sync   /dev/sdh1
>     7     7       8      129        7      active sync   /dev/sdi1
>     8     8       8      145        8      active sync   /dev/sdj1
>     9     9       8      161        9      active sync   /dev/sdk1
>    10    10       8      177       10      active sync   /dev/sdl1
>    11    11       8      193       11      active sync   /dev/sdm1
>=20
> I could just run 'mdadm -A --uuid=3D852267e0095a343cf4f590ad3333cb43=20
> /dev/sd[bcdefghijklm]1 --run' but I feel better seeking advice and=20
> consensus before doing anything.
>=20
> I have never seen a situation like this before. It seems like there=20
> might be one correct way to get the data back and many ways of losing=20
> the data for good. Any advice or feedback is greatly appreciated!
>=20
> --Jeff
>=20


--Sig_/=KyVGveTxpef2eDmuwms_cL
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT8NkGTnsnt1WYoG5AQKB5A//Slp3itNlNmBAj2Qse5Lux8pY4/xBmM48
heqiJjiNi6aTm2nVOEAWT+8ma+qnyoMGIf58QHQygd2HVLG35zsZWa5T0eY1WuKb
Anjnu5c6/Bq69N3fnvQHvvMyrywCJz4rN9msPMExfsE/u65kHEdsUgUWxvFeDZJB
zXuL5+G9pgUbu6NW/vT2jXNC1xFuqM5t9mbPGrgPMUb96VotnP1VeLha8SKuwHaK
KmM1rLaVXRxjJM1gY2InZt24BoUqxLpOCqlO8Op4juVQ1txMNuUcU7PSOjb4QiKg
bYzOhFJLyQjzQ6ljip/hI5L8wsPABc/b+/gPiOR4olA3fRbOilZgzUwaCP+ax4g1
T+03DUiKvbv1v0Vpp29ANN2bfjOUaY219D/xIlG5MoUPS3iBslnGqAPgCBeefthN
gtvMXLirO2+5DdWrGUDBlcfXw3I1WgRLA4E+Vv4j8ACQLurpWvwVGd1KrLDeoUDq
p5SOhXrg6wu7vKsk2E3epPzPTODNjwKl3vSBYl+AWCTBaY/8SSOpLuj+Ggbn8xcF
rvjtNgwD28syW8ePvWPsaEBUmx8gLKUUMaqhRIx06OQ+cKQ+CPLO81vO1UibWnCY
ie5xcI7KKFpLcT3SCrkiTB/bfnCpdSsn4v5ZYIlrfXUUMwgXDg2CzkbxW7tCDR+S
74Ii06Wx8O0=
=tGKB
-----END PGP SIGNATURE-----

--Sig_/=KyVGveTxpef2eDmuwms_cL--
