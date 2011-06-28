From: Pavel Hofman <pavel.hofman@ivitera.com>
Subject: Re: Raid auto-assembly upon boot - device order
Date: Tue, 28 Jun 2011 14:01:25 +0200
Message-ID: <4E09C295.8040102@ivitera.com>
References: <4E089067.8010904@ivitera.com> <4E08980B.5080002@turmel.org> <4E09AA68.2050302@ivitera.com> <4E09B50B.20306@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4E09B50B.20306@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Phil,

Dne 28.6.2011 13:03, Phil Turmel napsal(a):
> Good morning, Pavel,
>=20
> On 06/28/2011 06:18 AM, Pavel Hofman wrote:
>>=20
>>=20
>> Hi Phil,
>>=20
>> This is my rather complex setup: Personalities : [raid1] [raid0]=20
>> md4 : active raid0 sdb1[0] sdd3[1] 2178180864 blocks 64k chunks
>>=20
>> md2 : active raid1 sdc2[0] sdd2[1] 8787456 blocks [2/2] [UU]
>>=20
>> md3 : active raid0 sda1[0] sdc3[1] 2178180864 blocks 64k chunks
>>=20
>> md7 : active raid1 md6[2] md5[1] 2178180592 blocks super 1.0 [2/1]
>> [_U] [=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D>.........]  recovery =3D 59.=
3%
>> (1293749868/2178180592) finish=3D164746.8min speed=3D87K/sec
>>=20
>> md6 : active raid1 md4[0] 2178180728 blocks super 1.0 [2/1] [U_]
>>=20
>> md5 : active raid1 md3[2] 2178180728 blocks super 1.0 [2/1] [U_]=20
>> bitmap: 9/9 pages [36KB], 131072KB chunk
>>=20
>> md1 : active raid1 sdc1[0] sdd1[3] 10739328 blocks [5/2] [U__U_]
>>=20
>>=20
>> You can see md7 recoverying, even though both md5 and md6 were
>> present.
>=20
> Yes, but md5 & md6 are themselves degraded.  Should not have started
> unless you are globally enabling it.

>=20
> ps.  "lsdrv" would be really useful here to understand your layering
> setup.
>=20
> http://github.com/pturmel/lsdrv

Thanks a lot for your quick reply. And for your wonderful tool too.

orfeus:/boot# lsdrv
PCI [AMD_IDE] 00:04.0 IDE interface: nVidia Corporation MCP55 IDE (rev =
a1)
 =E2=94=94=E2=94=80ide 2.0 HL-DT-ST RW/DVD GCC-H20N {[No Information Fo=
und]}
    =E2=94=94=E2=94=80hde: [33:0] Empty/Unknown 4.00g
PCI [sata_nv] 00:05.0 IDE interface: nVidia Corporation MCP55 SATA
Controller (rev a3)
 =E2=94=9C=E2=94=80scsi 0:0:0:0 ATA SAMSUNG HD753LJ {S13UJDWQ912345}
 =E2=94=82  =E2=94=94=E2=94=80sda: [8:0] MD raid10 (4) 698.64g inactive
{646f62e3:626d2cb3:05afacbb:371c5cc4}
 =E2=94=82     =E2=94=94=E2=94=80sda1: [8:1] MD raid0 (0/2) 698.64g md3=
 clean in_sync
{8c9c28dd:ac12a9ef:a6200310:fe6d9686}
 =E2=94=82        =E2=94=94=E2=94=80md3: [9:3] MD raid1 (0/2) 2.03t md5=
 active in_sync
'orfeus:5' {2f88c280:3d7af418:e8d459c5:782e3ed2}
 =E2=94=82           =E2=94=94=E2=94=80md5: [9:5] MD raid1 (1/2) 2.03t =
md7 active in_sync
'orfeus:7' {dde16cd5:2e17c743:fcc7926c:fcf5081e}
 =E2=94=82              =E2=94=94=E2=94=80md7: [9:7] (xfs) 2.03t 'backu=
p'
{d987301b-dfb1-4c99-8f72-f4b400ba46c9}
 =E2=94=82                 =E2=94=94=E2=94=80Mounted as /dev/md7 @ /mnt=
/raid
 =E2=94=94=E2=94=80scsi 1:0:0:0 ATA ST3750330AS {9QK0VFJ9}
    =E2=94=94=E2=94=80sdb: [8:16] Empty/Unknown 698.64g
       =E2=94=94=E2=94=80sdb1: [8:17] MD raid0 (0/2) 698.64g md4 clean =
in_sync
{ce213d01:e50809ed:a6200310:fe6d9686}
          =E2=94=94=E2=94=80md4: [9:4] MD raid1 (0/2) 2.03t md6 active =
in_sync
''orfeus':6' {1f83ea99:a9e4d498:a6543047:af0a3b38}
             =E2=94=94=E2=94=80md6: [9:6] MD raid1 (0/2) 2.03t md7 acti=
ve spare
''orfeus':7' {dde16cd5:2e17c743:fcc7926c:fcf5081e}
PCI [sata_nv] 00:05.1 IDE interface: nVidia Corporation MCP55 SATA
Controller (rev a3)
 =E2=94=9C=E2=94=80scsi 2:0:0:0 ATA ST31500341AS {9VS15Y1L}
 =E2=94=82  =E2=94=94=E2=94=80sdc: [8:32] Empty/Unknown 1.36t
 =E2=94=82     =E2=94=9C=E2=94=80sdc1: [8:33] MD raid1 (0/5) 10.24g md1=
 clean in_sync
{588cbbfd:4835b4da:0d7a0b1c:7bf552bb}
 =E2=94=82     =E2=94=82  =E2=94=94=E2=94=80md1: [9:1] (ext3) 10.24g {f=
620df1e-6dd6-43ab-b4e6-8e1fd4a447f7}
 =E2=94=82     =E2=94=82     =E2=94=94=E2=94=80Mounted as /dev/md1 @ /
 =E2=94=82     =E2=94=9C=E2=94=80sdc2: [8:34] MD raid1 (0/2) 8.38g md2 =
clean in_sync
{28714b52:55b123f5:a6200310:fe6d9686}
 =E2=94=82     =E2=94=82  =E2=94=94=E2=94=80md2: [9:2] (swap) 8.38g {18=
04bbc6-a61b-44ea-9cc9-ac3ce6f17305}
 =E2=94=82     =E2=94=94=E2=94=80sdc3: [8:35] MD raid0 (1/2) 1.35t md3 =
clean in_sync
{8c9c28dd:ac12a9ef:a6200310:fe6d9686}
 =E2=94=94=E2=94=80scsi 3:0:0:0 ATA ST31500341AS {9VS13H4N}
    =E2=94=94=E2=94=80sdd: [8:48] Empty/Unknown 1.36t
       =E2=94=9C=E2=94=80sdd1: [8:49] MD raid1 (3/5) 10.24g md1 clean i=
n_sync
{588cbbfd:4835b4da:0d7a0b1c:7bf552bb}
       =E2=94=9C=E2=94=80sdd2: [8:50] MD raid1 (1/2) 8.38g md2 clean in=
_sync
{28714b52:55b123f5:a6200310:fe6d9686}
       =E2=94=94=E2=94=80sdd3: [8:51] MD raid0 (1/2) 1.35t md4 clean in=
_sync
{ce213d01:e50809ed:a6200310:fe6d9686}

Still you got the setup at the first look fine without the visualisatio=
n :)

>=20
>=20
> I suspect it is merely timing.  You are using degraded arrays
> deliberately as part of your backup scheme, which means you must be
> using "start_dirty_degraded" as a kernel parameter.  That enables
> md7, which you don't want degraded, to start degraded when md6 is a
> hundred or so milliseconds late to the party.

Running rgrep on /etc and /boot reveals no such kernel parameter on thi=
s
system. I have never had problems with the arrays not starting, perhaps
it is hard-compiled in debian kernel (lenny)? Config for the current
kernel in /boot does not list any such parameter either.

Woould using this parameter just change the timing?

>=20
> I think you have a couple options:
>=20
> 1) Don't run degraded arrays.  Use other backup tools.

It took me several years to find a reasonably fast way to offline-backu=
p
that partition with tens of millions of backuppc hardlinks :)

> 2) Remove md7
> from your mdadm.conf in your initramfs.  Don't let early userspace
> assemble it.  The extra time should then allow your initscripts on
> your real root fs to assemble it with both members.  This only works
> if md7 does not contain your real root fs.

=46antastic, I will do so. Just have to find a way to keep different
mdadm.conf in /etc and in initramfs while preserving the useful
update-initramfs functionality :)
>=20
>> Plus how can can a background reconstruction be started on md6, if
>> it is degraded and the other mirroring part is not even present?
>=20
> Don't know.  Maybe one of your existing drives is occupying a
> major/minor combination that your esata drive occupied on your last
> backup.  I'm pretty sure the message is harmless.  I noticed that md5
> has a bitmap, but md6 does not.  I wonder if adding a bitmap to md6
> would change the timing enough to help you.

Wow, there is bitmap missing on md6 indeed. I swear it was there, in th=
e
past :) It cuts down significantly the synchronization time for offline
copies. I have two offline drive sets - each rotating every two weeks.
One offline set plugs into md5, the other one into md6. This way I can
have two bitmaps, one for each set. Apparently, not now :-)

>=20
> Relying on timing variations for successful boot doesn't sound great
> to me.

You are right. Hopefully the significantly delayed assembly will work O=
K.

I very appreciate your help, thanks a lot,

Pavel.
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
