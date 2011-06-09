From: Phil Turmel <philip@turmel.org>
Subject: Re:
Date: Thu, 09 Jun 2011 09:39:19 -0400
Message-ID: <4DF0CD07.3040401@turmel.org>
References: <20110609121641.298530@gmx.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110609121641.298530@gmx.net>
Sender: linux-raid-owner@vger.kernel.org
To: Dragon <Sunghost@gmx.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 06/09/2011 08:16 AM, Dragon wrote:
> Yes if all things get back to normal i will change to raid6. that was=
 my idea for the future too.
> here the result of the script:
>=20
> ./lsdrv
> **Warning** The following utility(ies) failed to execute:
>   pvs
>   lvs
> Some information may be missing.
>=20
> PCI [pata_atiixp] 00:14.1 IDE interface: ATI Technologies Inc SB700/S=
B800 IDE Controller
>  =C3=A2=C3=A2scsi 0:0:0:0 ATA SAMSUNG HD154UI {S1XWJ1WZ401747}
>  =C3=A2  =C3=A2=C3=A2sda: [8:0] MD raid5 (none/13) 1.36t md0 inactive=
 spare {975d6eb2-285e-ed11-021d-f236c2d05073}
>  =C3=A2     =C3=A2=C3=A2md0: [9:0] Empty/Unknown 0.00k
>  =C3=A2=C3=A2scsi 0:0:1:0 ATA SAMSUNG HD154UI {S1XWJ1WZ405098}
>  =C3=A2  =C3=A2=C3=A2sdb: [8:16] MD raid5 (none/13) 1.36t md0 inactiv=
e spare {975d6eb2-285e-ed11-021d-f236c2d05073}
>  =C3=A2=C3=A2scsi 1:0:0:0 ATA SAMSUNG SV2044D {0244J1BN626842}
>     =C3=A2=C3=A2sdc: [8:32] Partitioned (dos) 19.01g
>        =C3=A2=C3=A2sdc1: [8:33] (ext3) 18.17g {6858fc38-9fee-4ab5-813=
5-029f305b9198}
>        =C3=A2  =C3=A2=C3=A2Mounted as /dev/disk/by-uuid/6858fc38-9fee=
-4ab5-8135-029f305b9198 @ /
>        =C3=A2=C3=A2sdc2: [8:34] Partitioned (dos) 1.00k
>        =C3=A2=C3=A2sdc5: [8:37] (swap) 854.99m {f67c7f23-e5ac-4c05-99=
2c-a9a494687026}
> PCI [sata_mv] 02:00.0 SCSI storage controller: Marvell Technology Gro=
up Ltd. 88SX7042 PCI-e 4-port SATA-II (rev 02)
>  =C3=A2=C3=A2scsi 2:0:0:0 ATA SAMSUNG HD154UI {S1XWJD2Z907626}
>  =C3=A2  =C3=A2=C3=A2sdd: [8:48] MD raid5 (none/13) 1.36t md0 inactiv=
e spare {975d6eb2-285e-ed11-021d-f236c2d05073}
>  =C3=A2=C3=A2scsi 4:0:0:0 ATA SAMSUNG HD154UI {S1XWJ90ZA03442}
>  =C3=A2  =C3=A2=C3=A2sde: [8:64] MD raid5 (none/13) 1.36t md0 inactiv=
e spare {975d6eb2-285e-ed11-021d-f236c2d05073}
>  =C3=A2=C3=A2scsi 6:0:0:0 ATA SAMSUNG HD154UI {S1XWJ9AB200390}
>  =C3=A2  =C3=A2=C3=A2sdf: [8:80] MD raid5 (none/13) 1.36t md0 inactiv=
e spare {975d6eb2-285e-ed11-021d-f236c2d05073}
>  =C3=A2=C3=A2scsi 8:0:0:0 ATA SAMSUNG HD154UI {61833B761A63RP}
>     =C3=A2=C3=A2sdg: [8:96] MD raid5 (none/13) 1.36t md0 inactive spa=
re {975d6eb2-285e-ed11-021d-f236c2d05073}
> PCI [sata_promise] 04:02.0 Mass storage controller: Promise Technolog=
y, Inc. PDC40718 (SATA 300 TX4) (rev 02)
>  =C3=A2=C3=A2scsi 3:0:0:0 ATA SAMSUNG HD154UI {S1XWJD5B201174}
>  =C3=A2  =C3=A2=C3=A2sdh: [8:112] MD raid5 (none/13) 1.36t md0 inacti=
ve spare {975d6eb2-285e-ed11-021d-f236c2d05073}
>  =C3=A2=C3=A2scsi 5:0:0:0 ATA SAMSUNG HD154UI {S1XWJ9CB201815}
>  =C3=A2  =C3=A2=C3=A2sdi: [8:128] MD raid5 (none/13) 1.36t md0 inacti=
ve spare {975d6eb2-285e-ed11-021d-f236c2d05073}
>  =C3=A2=C3=A2scsi 7:x:x:x [Empty]
>  =C3=A2=C3=A2scsi 9:0:0:0 ATA SAMSUNG HD154UI {A6311B761A3XPB}
>     =C3=A2=C3=A2sdj: [8:144] MD raid5 (none/13) 1.36t md0 inactive sp=
are {975d6eb2-285e-ed11-021d-f236c2d05073}
> PCI [ahci] 00:11.0 SATA controller: ATI Technologies Inc SB700/SB800 =
SATA Controller [IDE mode]
>  =C3=A2=C3=A2scsi 10:0:0:0 ATA SAMSUNG HD154UI {S1XWJ1KS915803}
>  =C3=A2  =C3=A2=C3=A2sdk: [8:160] MD raid5 (none/13) 1.36t md0 inacti=
ve spare {975d6eb2-285e-ed11-021d-f236c2d05073}
>  =C3=A2=C3=A2scsi 11:0:0:0 ATA SAMSUNG HD154UI {S1XWJ1KS915802}
>  =C3=A2  =C3=A2=C3=A2sdl: [8:176] MD raid5 (none/13) 1.36t md0 inacti=
ve spare {975d6eb2-285e-ed11-021d-f236c2d05073}
>  =C3=A2=C3=A2scsi 12:0:0:0 ATA SAMSUNG HD154UI {S1XWJ1KSC08024}
>  =C3=A2  =C3=A2=C3=A2sdm: [8:192] MD raid5 (none/13) 1.36t md0 inacti=
ve spare {975d6eb2-285e-ed11-021d-f236c2d05073}
>  =C3=A2=C3=A2scsi 13:0:0:0 ATA SAMSUNG HD154UI {S1XWJ1KS915804}
>     =C3=A2=C3=A2sdn: [8:208] MD raid5 (13) 1.36t inactive {975d6eb2-2=
85e-ed11-021d-f236c2d05073}
>=20

Very interesting.  You've exposed a limitation of my script.  I'll have=
 to reconsider how I extract information from members of a partially st=
arted array.

Its also clear that you are using a fast-boot kernel with parallel prob=
ing of your scsi hosts.  That's why your device names sometimes change.

/dev/sdn is definitely the holdout, though.  Notice the "(13)" where th=
e others are "(none/13)".

Before continuing, I've made the assumption that "mdadm --grow -n 12" w=
as the last major operation attempted, and this is was put you in your =
current predicament?  If so, and you interrupted it, did you try to ass=
emble the array with the --backup-file option from the shrink operation=
?  If you didn't, please stop the array, and retry the assemble (with a=
ll 13 devices) and the --backup-file option.  Try twice, if needed, add=
ing "--force" the second time.

If that works, sit tight until the reshape is complete.

If that was already tried, or doesn't change the situation, here's what=
 I recommend:

Stop the array: "mdadm -S /dev/md0"

Recreate the array "mdadm -C /dev/md0 -l 5 -n 13 -e 0.90 -c 64 --assume=
-clean /dev/sd{k,d,l,m,a,b,e,n,f,g,h,i,j}"

The order in {} matters! The option "--assume-clean" is vital!

You will be warned that the members appear to be part of another array.=
  Continue.

Do *NOT* mount the array!

Try a non-destructive fsck: "fsck -n /dev/md0"

If that has a huge number of errors, stop the array, and recreate again=
, swapping /dev/sdd and /dev/sdn, then repeat the fsck:

"mdadm -C /dev/md0 -l 5 -n 13 -e 0.90 -c 64 --assume-clean /dev/sd{k,n,=
l,m,a,b,e,d,f,g,h,i,j}"

If you get a good, or mostly good fsck, you've found the right combinat=
ion, and you can try the shrink operations again.

Phil
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
