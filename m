From: Phil Turmel <philip@turmel.org>
Subject: Re: Raid auto-assembly upon boot - device order
Date: Tue, 28 Jun 2011 11:39:17 -0400
Message-ID: <4E09F5A5.3020903@turmel.org>
References: <4E089067.8010904@ivitera.com> <4E08980B.5080002@turmel.org> <4E09AA68.2050302@ivitera.com> <4E09B50B.20306@turmel.org> <4E09C295.8040102@ivitera.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4E09C295.8040102@ivitera.com>
Sender: linux-raid-owner@vger.kernel.org
To: Pavel Hofman <pavel.hofman@ivitera.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 06/28/2011 08:01 AM, Pavel Hofman wrote:
> Hi Phil,

[...]

> Thanks a lot for your quick reply. And for your wonderful tool too.

You're welcome.

> orfeus:/boot# lsdrv
> PCI [AMD_IDE] 00:04.0 IDE interface: nVidia Corporation MCP55 IDE (re=
v a1)
>  =E2=94=94=E2=94=80ide 2.0 HL-DT-ST RW/DVD GCC-H20N {[No Information =
=46ound]}
>     =E2=94=94=E2=94=80hde: [33:0] Empty/Unknown 4.00g
> PCI [sata_nv] 00:05.0 IDE interface: nVidia Corporation MCP55 SATA
> Controller (rev a3)
>  =E2=94=9C=E2=94=80scsi 0:0:0:0 ATA SAMSUNG HD753LJ {S13UJDWQ912345}
>  =E2=94=82  =E2=94=94=E2=94=80sda: [8:0] MD raid10 (4) 698.64g inacti=
ve
> {646f62e3:626d2cb3:05afacbb:371c5cc4}
>  =E2=94=82     =E2=94=94=E2=94=80sda1: [8:1] MD raid0 (0/2) 698.64g m=
d3 clean in_sync
> {8c9c28dd:ac12a9ef:a6200310:fe6d9686}
>  =E2=94=82        =E2=94=94=E2=94=80md3: [9:3] MD raid1 (0/2) 2.03t m=
d5 active in_sync
> 'orfeus:5' {2f88c280:3d7af418:e8d459c5:782e3ed2}
>  =E2=94=82           =E2=94=94=E2=94=80md5: [9:5] MD raid1 (1/2) 2.03=
t md7 active in_sync
> 'orfeus:7' {dde16cd5:2e17c743:fcc7926c:fcf5081e}
>  =E2=94=82              =E2=94=94=E2=94=80md7: [9:7] (xfs) 2.03t 'bac=
kup'
> {d987301b-dfb1-4c99-8f72-f4b400ba46c9}
>  =E2=94=82                 =E2=94=94=E2=94=80Mounted as /dev/md7 @ /m=
nt/raid
>  =E2=94=94=E2=94=80scsi 1:0:0:0 ATA ST3750330AS {9QK0VFJ9}
>     =E2=94=94=E2=94=80sdb: [8:16] Empty/Unknown 698.64g
>        =E2=94=94=E2=94=80sdb1: [8:17] MD raid0 (0/2) 698.64g md4 clea=
n in_sync
> {ce213d01:e50809ed:a6200310:fe6d9686}
>           =E2=94=94=E2=94=80md4: [9:4] MD raid1 (0/2) 2.03t md6 activ=
e in_sync
> ''orfeus':6' {1f83ea99:a9e4d498:a6543047:af0a3b38}
>              =E2=94=94=E2=94=80md6: [9:6] MD raid1 (0/2) 2.03t md7 ac=
tive spare
> ''orfeus':7' {dde16cd5:2e17c743:fcc7926c:fcf5081e}
> PCI [sata_nv] 00:05.1 IDE interface: nVidia Corporation MCP55 SATA
> Controller (rev a3)
>  =E2=94=9C=E2=94=80scsi 2:0:0:0 ATA ST31500341AS {9VS15Y1L}
>  =E2=94=82  =E2=94=94=E2=94=80sdc: [8:32] Empty/Unknown 1.36t
>  =E2=94=82     =E2=94=9C=E2=94=80sdc1: [8:33] MD raid1 (0/5) 10.24g m=
d1 clean in_sync
> {588cbbfd:4835b4da:0d7a0b1c:7bf552bb}
>  =E2=94=82     =E2=94=82  =E2=94=94=E2=94=80md1: [9:1] (ext3) 10.24g =
{f620df1e-6dd6-43ab-b4e6-8e1fd4a447f7}
>  =E2=94=82     =E2=94=82     =E2=94=94=E2=94=80Mounted as /dev/md1 @ =
/
>  =E2=94=82     =E2=94=9C=E2=94=80sdc2: [8:34] MD raid1 (0/2) 8.38g md=
2 clean in_sync
> {28714b52:55b123f5:a6200310:fe6d9686}
>  =E2=94=82     =E2=94=82  =E2=94=94=E2=94=80md2: [9:2] (swap) 8.38g {=
1804bbc6-a61b-44ea-9cc9-ac3ce6f17305}
>  =E2=94=82     =E2=94=94=E2=94=80sdc3: [8:35] MD raid0 (1/2) 1.35t md=
3 clean in_sync
> {8c9c28dd:ac12a9ef:a6200310:fe6d9686}
>  =E2=94=94=E2=94=80scsi 3:0:0:0 ATA ST31500341AS {9VS13H4N}
>     =E2=94=94=E2=94=80sdd: [8:48] Empty/Unknown 1.36t
>        =E2=94=9C=E2=94=80sdd1: [8:49] MD raid1 (3/5) 10.24g md1 clean=
 in_sync
> {588cbbfd:4835b4da:0d7a0b1c:7bf552bb}
>        =E2=94=9C=E2=94=80sdd2: [8:50] MD raid1 (1/2) 8.38g md2 clean =
in_sync
> {28714b52:55b123f5:a6200310:fe6d9686}
>        =E2=94=94=E2=94=80sdd3: [8:51] MD raid0 (1/2) 1.35t md4 clean =
in_sync
> {ce213d01:e50809ed:a6200310:fe6d9686}

Pretty deep layering.  I think I'm going to reduce the amount of indent=
ation per layer.

> Still you got the setup at the first look fine without the visualisat=
ion :)
>=20
>>
>>
>> I suspect it is merely timing.  You are using degraded arrays
>> deliberately as part of your backup scheme, which means you must be
>> using "start_dirty_degraded" as a kernel parameter.  That enables
>> md7, which you don't want degraded, to start degraded when md6 is a
>> hundred or so milliseconds late to the party.
>=20
> Running rgrep on /etc and /boot reveals no such kernel parameter on t=
his
> system. I have never had problems with the arrays not starting, perha=
ps
> it is hard-compiled in debian kernel (lenny)? Config for the current
> kernel in /boot does not list any such parameter either.
>=20
> Woould using this parameter just change the timing?

No.  Degraded arrays are supposed to not assemble without it.  Maybe it=
 only applies to kernel autoassembly, which I no longer use.

>> I think you have a couple options:
>>
>> 1) Don't run degraded arrays.  Use other backup tools.
>=20
> It took me several years to find a reasonably fast way to offline-bac=
kup
> that partition with tens of millions of backuppc hardlinks :)

I've heard of hardlink horrors with backuppc.  I don't use it myself.  =
I prefer to use LVM on top of MD, then take compressed backups of LVM s=
napshots.

>> 2) Remove md7
>> from your mdadm.conf in your initramfs.  Don't let early userspace
>> assemble it.  The extra time should then allow your initscripts on
>> your real root fs to assemble it with both members.  This only works
>> if md7 does not contain your real root fs.
>=20
> Fantastic, I will do so. Just have to find a way to keep different
> mdadm.conf in /etc and in initramfs while preserving the useful
> update-initramfs functionality :)

I haven't dug that deep.  I use dracut, myself.

>>> Plus how can can a background reconstruction be started on md6, if
>>> it is degraded and the other mirroring part is not even present?
>>
>> Don't know.  Maybe one of your existing drives is occupying a
>> major/minor combination that your esata drive occupied on your last
>> backup.  I'm pretty sure the message is harmless.  I noticed that md=
5
>> has a bitmap, but md6 does not.  I wonder if adding a bitmap to md6
>> would change the timing enough to help you.
>=20
> Wow, there is bitmap missing on md6 indeed. I swear it was there, in =
the
> past :) It cuts down significantly the synchronization time for offli=
ne
> copies. I have two offline drive sets - each rotating every two weeks=
=2E
> One offline set plugs into md5, the other one into md6. This way I ca=
n
> have two bitmaps, one for each set. Apparently, not now :-)

Mirror w/ bitmap would make 1:1 backups faster.  I understand why you a=
re doing this, but I'd be worried about filesystem integrity at the poi=
nt in time you disconnect the backup drive.  Have you performed any tes=
ts to be sure you can recover usable data from the offline copy?  If I =
recall correctly, an LVM snapshot operation incorporates a filesystem m=
etadata sync.

>> Relying on timing variations for successful boot doesn't sound great
>> to me.
>=20
> You are right. Hopefully the significantly delayed assembly will work=
 OK.
>=20
> I very appreciate your help, thanks a lot,
>=20
> Pavel.

Phil
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
