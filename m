From: Dan Russell <dpr@aol.com>
Subject: Re: Import/recover RAID6 created with SAS2108?
Date: Tue, 8 Mar 2016 22:20:17 -0500
Message-ID: <ECED3C91-8D12-469E-A9AB-1337292DA216@aol.com>
References: <2832CD22-EADC-4BC6-A250-FE8919A92E0A@aol.com> <20160307215026.GA8042@EIS>
Mime-Version: 1.0 (Mac OS X Mail 9.2 \(3112\))
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20160307215026.GA8042@EIS>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Thank you.  I=E2=80=99ve made some progress.  My hardware controller us=
es a DDF container, which I=E2=80=99m able to start and inspect with md=
adm.  Based on the mdadm release notes, I=E2=80=99ve updated from v3.2.=
5 to v3.4.

The data is not encrypted, and I believe I have the HDD order and chunk=
 sizes correct (in part because the DDF container matches my independen=
tly-gathered notes).

The HDD order is sdi, sdj, sdag, sdl - sdz, sdaa - sdaf  (when the arra=
y initially failed, I replaced the drive in slot 2 with a new drive and=
 started a rebuild.  The partially-rebuilt drive is sdk, the original =E2=
=80=9Cfailed=E2=80=9D drive is sdag).

When I did an Incremental on the container, I ended up with 3 inactive =
arrays (one 2-disk, one 20-disk, one 2-disk), which is comparable to wh=
at the hardware RAID controller told me about foreign configurations.  =
So I tried to create a new 24-disk array with the same parameters as th=
e old.

I am able to create an array and see the LVM label on md1.  However fdi=
sk and mdadm are reporting the array is 17.6TB in size, whereas it shou=
ld be 66TB (24 3TB HDDs RAID6).  This is the same whether I specify or =
leave off the =E2=80=94size option when creating the array.

The first mdadm =E2=80=94create to make the ddf container shows that th=
e ctime for sdag and sdp is Jan 17; this is the last time I booted this=
 server prior to the breakage.  I=E2=80=99m wondering if there=E2=80=99=
s some way I can use the container metadata from either of those drives=
 and ignore the rest?

Note that md0 is my root volume and is perfectly fine; it is only liste=
d because I didn=E2=80=99t want to edit any command output.

# uname -r
3.13.0-49-generic

# mdadm -V
mdadm - v3.4 - 28th January 2016

# cat /proc/mdstat=20
Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5] [r=
aid4] [raid10]=20
md0 : active raid1 sdh1[1] sdg1[0]
      124967808 blocks super 1.2 [2/2] [UU]
     =20
# mdadm --create /dev/md127 -e ddf -l container -n 24 /dev/mapper/sdi /=
dev/mapper/sdj /dev/mapper/sdag /dev/mapper/sdl /dev/mapper/sdm /dev/ma=
pper/sdn /dev/mapper/sdo /dev/mapper/sdp /dev/mapper/sdq /dev/mapper/sd=
r /dev/mapper/sds /dev/mapper/sdt /dev/mapper/sdu /dev/mapper/sdv /dev/=
mapper/sdw /dev/mapper/sdx /dev/mapper/sdy /dev/mapper/sdz /dev/mapper/=
sdaa /dev/mapper/sdab /dev/mapper/sdac /dev/mapper/sdad /dev/mapper/sda=
e /dev/mapper/sdaf
mdadm: /dev/mapper/sdj appears to be part of a raid array:
       level=3Dcontainer devices=3D198 ctime=3DFri Feb 26 13:38:07 2016
mdadm: /dev/mapper/sdag appears to be part of a raid array:
       level=3Dcontainer devices=3D212 ctime=3DSun Jan 17 17:03:35 2016
mdadm: /dev/mapper/sdl appears to be part of a raid array:
       level=3Dcontainer devices=3D198 ctime=3DFri Feb 26 13:38:07 2016
mdadm: /dev/mapper/sdm appears to be part of a raid array:
       level=3Dcontainer devices=3D198 ctime=3DFri Feb 26 13:38:07 2016
mdadm: /dev/mapper/sdn appears to be part of a raid array:
       level=3Dcontainer devices=3D198 ctime=3DFri Feb 26 13:38:07 2016
mdadm: /dev/mapper/sdo appears to be part of a raid array:
       level=3Dcontainer devices=3D199 ctime=3DFri Feb 26 13:38:07 2016
mdadm: /dev/mapper/sdp appears to be part of a raid array:
       level=3Dcontainer devices=3D212 ctime=3DSun Jan 17 17:03:35 2016
mdadm: /dev/mapper/sdq appears to be part of a raid array:
       level=3Dcontainer devices=3D198 ctime=3DFri Feb 26 13:38:07 2016
mdadm: /dev/mapper/sdr appears to be part of a raid array:
       level=3Dcontainer devices=3D198 ctime=3DFri Feb 26 13:38:07 2016
mdadm: /dev/mapper/sds appears to be part of a raid array:
       level=3Dcontainer devices=3D198 ctime=3DFri Feb 26 13:38:07 2016
mdadm: /dev/mapper/sdt appears to be part of a raid array:
       level=3Dcontainer devices=3D198 ctime=3DFri Feb 26 13:38:07 2016
mdadm: /dev/mapper/sdu appears to be part of a raid array:
       level=3Dcontainer devices=3D198 ctime=3DFri Feb 26 13:38:07 2016
mdadm: /dev/mapper/sdv appears to be part of a raid array:
       level=3Dcontainer devices=3D198 ctime=3DFri Feb 26 13:38:07 2016
mdadm: /dev/mapper/sdw appears to be part of a raid array:
       level=3Dcontainer devices=3D198 ctime=3DFri Feb 26 13:38:07 2016
mdadm: /dev/mapper/sdx appears to be part of a raid array:
       level=3Dcontainer devices=3D198 ctime=3DFri Feb 26 13:38:07 2016
mdadm: /dev/mapper/sdy appears to be part of a raid array:
       level=3Dcontainer devices=3D198 ctime=3DFri Feb 26 13:38:07 2016
mdadm: /dev/mapper/sdz appears to be part of a raid array:
       level=3Dcontainer devices=3D198 ctime=3DFri Feb 26 13:38:07 2016
mdadm: /dev/mapper/sdaa appears to be part of a raid array:
       level=3Dcontainer devices=3D198 ctime=3DFri Feb 26 13:38:07 2016
mdadm: /dev/mapper/sdab appears to be part of a raid array:
       level=3Dcontainer devices=3D198 ctime=3DFri Feb 26 13:38:07 2016
mdadm: /dev/mapper/sdac appears to be part of a raid array:
       level=3Dcontainer devices=3D198 ctime=3DFri Feb 26 13:38:07 2016
mdadm: /dev/mapper/sdad appears to be part of a raid array:
       level=3Dcontainer devices=3D198 ctime=3DFri Feb 26 13:38:07 2016
mdadm: /dev/mapper/sdae appears to be part of a raid array:
       level=3Dcontainer devices=3D198 ctime=3DFri Feb 26 13:38:07 2016
mdadm: /dev/mapper/sdaf appears to be part of a raid array:
       level=3Dcontainer devices=3D198 ctime=3DFri Feb 26 13:38:07 2016
Continue creating array? y
mdadm: container /dev/md127 prepared.

# cat /proc/mdstat=20
Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5] [r=
aid4] [raid10]=20
md127 : inactive dm-24[23](S) dm-23[22](S) dm-22[21](S) dm-21[20](S) dm=
-20[19](S) dm-19[18](S) dm-18[17](S) dm-17[16](S) dm-16[15](S) dm-15[14=
](S) dm-14[13](S) dm-13[12](S) dm-12[11](S) dm-11[10](S) dm-10[9](S) dm=
-9[8](S) dm-8[7](S) dm-7[6](S) dm-6[5](S) dm-5[4](S) dm-4[3](S) dm-25[2=
](S) dm-2[1](S) dm-1[0](S)
      786432 blocks super external:ddf
      =20
md0 : active raid1 sdh1[1] sdg1[0]
      124967808 blocks super 1.2 [2/2] [UU]

# mdadm --create /dev/md1 --assume-clean --level=3D6 --raid-devices=3D2=
4 --chunk=3D64 --size=3D2929686528 /dev/mapper/sdi /dev/mapper/sdj /dev=
/mapper/sdag /dev/mapper/sdl /dev/mapper/sdm /dev/mapper/sdn /dev/mappe=
r/sdo /dev/mapper/sdp /dev/mapper/sdq /dev/mapper/sdr /dev/mapper/sds /=
dev/mapper/sdt /dev/mapper/sdu /dev/mapper/sdv /dev/mapper/sdw /dev/map=
per/sdx /dev/mapper/sdy /dev/mapper/sdz /dev/mapper/sdaa /dev/mapper/sd=
ab /dev/mapper/sdac /dev/mapper/sdad /dev/mapper/sdae /dev/mapper/sdaf
mdadm: /dev/mapper/sdi appears to be part of a raid array:
       level=3Dcontainer devices=3D24 ctime=3DTue Mar  8 21:18:40 2016
mdadm: /dev/mapper/sdj appears to be part of a raid array:
       level=3Dcontainer devices=3D24 ctime=3DTue Mar  8 21:18:40 2016
mdadm: /dev/mapper/sdag appears to be part of a raid array:
       level=3Dcontainer devices=3D24 ctime=3DTue Mar  8 21:18:40 2016
mdadm: /dev/mapper/sdl appears to be part of a raid array:
       level=3Dcontainer devices=3D24 ctime=3DTue Mar  8 21:18:40 2016
mdadm: /dev/mapper/sdm appears to be part of a raid array:
       level=3Dcontainer devices=3D24 ctime=3DTue Mar  8 21:18:40 2016
mdadm: /dev/mapper/sdn appears to be part of a raid array:
       level=3Dcontainer devices=3D24 ctime=3DTue Mar  8 21:18:40 2016
mdadm: /dev/mapper/sdo appears to be part of a raid array:
       level=3Dcontainer devices=3D24 ctime=3DTue Mar  8 21:18:40 2016
mdadm: /dev/mapper/sdp appears to be part of a raid array:
       level=3Dcontainer devices=3D24 ctime=3DTue Mar  8 21:18:40 2016
mdadm: /dev/mapper/sdq appears to be part of a raid array:
       level=3Dcontainer devices=3D24 ctime=3DTue Mar  8 21:18:40 2016
mdadm: /dev/mapper/sdr appears to be part of a raid array:
       level=3Dcontainer devices=3D24 ctime=3DTue Mar  8 21:18:40 2016
mdadm: /dev/mapper/sds appears to be part of a raid array:
       level=3Dcontainer devices=3D24 ctime=3DTue Mar  8 21:18:40 2016
mdadm: /dev/mapper/sdt appears to be part of a raid array:
       level=3Dcontainer devices=3D24 ctime=3DTue Mar  8 21:18:40 2016
mdadm: /dev/mapper/sdu appears to be part of a raid array:
       level=3Dcontainer devices=3D24 ctime=3DTue Mar  8 21:18:40 2016
mdadm: /dev/mapper/sdv appears to be part of a raid array:
       level=3Dcontainer devices=3D24 ctime=3DTue Mar  8 21:18:40 2016
mdadm: /dev/mapper/sdw appears to be part of a raid array:
       level=3Dcontainer devices=3D24 ctime=3DTue Mar  8 21:18:40 2016
mdadm: /dev/mapper/sdx appears to be part of a raid array:
       level=3Dcontainer devices=3D24 ctime=3DTue Mar  8 21:18:40 2016
mdadm: /dev/mapper/sdy appears to be part of a raid array:
       level=3Dcontainer devices=3D24 ctime=3DTue Mar  8 21:18:40 2016
mdadm: /dev/mapper/sdz appears to be part of a raid array:
       level=3Dcontainer devices=3D24 ctime=3DTue Mar  8 21:18:40 2016
mdadm: /dev/mapper/sdaa appears to be part of a raid array:
       level=3Dcontainer devices=3D24 ctime=3DTue Mar  8 21:18:40 2016
mdadm: /dev/mapper/sdab appears to be part of a raid array:
       level=3Dcontainer devices=3D24 ctime=3DTue Mar  8 21:18:40 2016
mdadm: /dev/mapper/sdac appears to be part of a raid array:
       level=3Dcontainer devices=3D24 ctime=3DTue Mar  8 21:18:40 2016
mdadm: /dev/mapper/sdad appears to be part of a raid array:
       level=3Dcontainer devices=3D24 ctime=3DTue Mar  8 21:18:40 2016
mdadm: /dev/mapper/sdae appears to be part of a raid array:
       level=3Dcontainer devices=3D24 ctime=3DTue Mar  8 21:18:40 2016
mdadm: /dev/mapper/sdaf appears to be part of a raid array:
       level=3Dcontainer devices=3D24 ctime=3DTue Mar  8 21:18:40 2016
Continue creating array? y
mdadm: Creating array inside ddf container md127
mdadm: array /dev/md1 started.

# cat /proc/mdstat=20
Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5] [r=
aid4] [raid10]=20
md1 : active (auto-read-only) raid6 dm-24[23] dm-23[22] dm-22[21] dm-21=
[20] dm-20[19] dm-19[18] dm-18[17] dm-17[16] dm-16[15] dm-15[14] dm-14[=
13] dm-13[12] dm-12[11] dm-11[10] dm-10[9] dm-9[8] dm-8[7] dm-7[6] dm-6=
[5] dm-5[4] dm-4[3] dm-25[2] dm-2[1] dm-1[0]
      17208463360 blocks super external:/md127/0 level 6, 64k chunk, al=
gorithm 10 [24/24] [UUUUUUUUUUUUUUUUUUUUUUUU]
     =20
md127 : inactive dm-24[23](S) dm-23[22](S) dm-22[21](S) dm-21[20](S) dm=
-20[19](S) dm-19[18](S) dm-18[17](S) dm-17[16](S) dm-16[15](S) dm-15[14=
](S) dm-14[13](S) dm-13[12](S) dm-12[11](S) dm-11[10](S) dm-10[9](S) dm=
-9[8](S) dm-8[7](S) dm-7[6](S) dm-6[5](S) dm-5[4](S) dm-4[3](S) dm-25[2=
](S) dm-2[1](S) dm-1[0](S)
      786432 blocks super external:ddf
      =20
md0 : active raid1 sdh1[1] sdg1[0]
      124967808 blocks super 1.2 [2/2] [UU]
     =20
unused devices: <none>

# mdadm -E /dev/md127
/dev/md127:
          Magic : de11de11
        Version : 01.02.00
Controller GUID : 4C696E75:782D4D44:2064616D:2D73746F:72616765:2D6E3031
                  (Linux-MD dam-storage-n01)
 Container GUID : 4C696E75:782D4D44:DEADBEEF:00000000:4410E200:C7DA314C
                  (Linux-MD 03/08/16 21:18:40)
            Seq : 00000003
  Redundant hdr : yes
  Virtual Disks : 1

      VD GUID[0] : 4C696E75:782D4D44:DEADBEEF:00000000:4410E257:2EF3154=
2
                  (Linux-MD 03/08/16 21:20:07)
         unit[0] : 1
        state[0] : Optimal, Consistent
   init state[0] : Fully Initialised
       access[0] : Read/Write
         Name[0] : 1
 Raid Devices[0] : 24 (0@0K 1@0K 2@0K 3@0K 4@0K 5@0K 6@0K 7@0K 8@0K 9@0=
K 10@0K 11@0K 12@0K 13@0K 14@0K 15@0K 16@0K 17@0K 18@0K 19@0K 20@0K 21@=
0K 22@0K 23@0K)
   Chunk Size[0] : 128 sectors
   Raid Level[0] : RAID6
  Device Size[0] : 782202880
   Array Size[0] : 17208463360

 Physical Disks : 1023
      Number    RefNo      Size       Device      Type/State
         0    1bfc5b4f  2930233816K /dev/dm-1       active/Online
         1    44f3f4b1  2930233816K /dev/dm-2       active/Online
         2    22f1c2e4  2930233816K /dev/dm-25      active/Online
         3    ef32ccff  2930233816K /dev/dm-4       active/Online
         4    c7e6f1fe  2930233816K /dev/dm-5       active/Online
         5    00272b4d  2930233816K /dev/dm-6       active/Online
         6    f961cba2  2930233816K /dev/dm-7       active/Online
         7    40f01419  2930233816K /dev/dm-8       active/Online
         8    75858e24  2930233816K /dev/dm-9       active/Online
         9    ac398181  2930233816K /dev/dm-10      active/Online
        10    b39d9cbb  2930233816K /dev/dm-11      active/Online
        11    a71a4095  2930233816K /dev/dm-12      active/Online
        12    f1bf38e9  2930233816K /dev/dm-13      active/Online
        13    1a8973b2  2930233816K /dev/dm-14      active/Online
        14    c107b1b5  2930233816K /dev/dm-15      active/Online
        15    26b44a36  2930233816K /dev/dm-16      active/Online
        16    7f376a5f  2930233816K /dev/dm-17      active/Online
        17    22944f44  2930233816K /dev/dm-18      active/Online
        18    8e356094  2930233816K /dev/dm-19      active/Online
        19    0b454914  2930233816K /dev/dm-20      active/Online
        20    71df5ccc  2930233816K /dev/dm-21      active/Online
        21    763d65a1  2930233816K /dev/dm-22      active/Online
        22    aacda00d  2930233816K /dev/dm-23      active/Online
        23    9837ac03  2930233816K /dev/dm-24      active/Online


(picking a device at random)
# mdadm -E /dev/mapper/sdp
/dev/mapper/sdp:
          Magic : de11de11
        Version : 01.02.00
Controller GUID : 4C696E75:782D4D44:2064616D:2D73746F:72616765:2D6E3031
                  (Linux-MD dam-storage-n01)
 Container GUID : 4C696E75:782D4D44:DEADBEEF:00000000:4410E200:C7DA314C
                  (Linux-MD 03/08/16 21:18:40)
            Seq : 00000003
  Redundant hdr : yes
  Virtual Disks : 1

      VD GUID[0] : 4C696E75:782D4D44:DEADBEEF:00000000:4410E257:2EF3154=
2
                  (Linux-MD 03/08/16 21:20:07)
         unit[0] : 1
        state[0] : Optimal, Consistent
   init state[0] : Fully Initialised
       access[0] : Read/Write
         Name[0] : 1
 Raid Devices[0] : 24 (0@0K 1@0K 2@0K 3@0K 4@0K 5@0K 6@0K 7@0K 8@0K 9@0=
K 10@0K 11@0K 12@0K 13@0K 14@0K 15@0K 16@0K 17@0K 18@0K 19@0K 20@0K 21@=
0K 22@0K 23@0K)
   Chunk Size[0] : 128 sectors
   Raid Level[0] : RAID6
  Device Size[0] : 782202880
   Array Size[0] : 17208463360

 Physical Disks : 1023
      Number    RefNo      Size       Device      Type/State
         0    1bfc5b4f  2930233816K                 active/Online
         1    44f3f4b1  2930233816K                 active/Online
         2    22f1c2e4  2930233816K                 active/Online
         3    ef32ccff  2930233816K                 active/Online
         4    c7e6f1fe  2930233816K                 active/Online
         5    00272b4d  2930233816K                 active/Online
         6    f961cba2  2930233816K                 active/Online
         7    40f01419  2930233816K /dev/dm-8       active/Online
         8    75858e24  2930233816K                 active/Online
         9    ac398181  2930233816K                 active/Online
        10    b39d9cbb  2930233816K                 active/Online
        11    a71a4095  2930233816K                 active/Online
        12    f1bf38e9  2930233816K                 active/Online
        13    1a8973b2  2930233816K                 active/Online
        14    c107b1b5  2930233816K                 active/Online
        15    26b44a36  2930233816K                 active/Online
        16    7f376a5f  2930233816K                 active/Online
        17    22944f44  2930233816K                 active/Online
        18    8e356094  2930233816K                 active/Online
        19    0b454914  2930233816K                 active/Online
        20    71df5ccc  2930233816K                 active/Online
        21    763d65a1  2930233816K                 active/Online
        22    aacda00d  2930233816K                 active/Online
        23    9837ac03  2930233816K                 active/Online

# fdisk -l /dev/md1

Disk /dev/md1: 17621.5 GB, 17621466480640 bytes
2 heads, 4 sectors/track, -1 cylinders, total 34416926720 sectors
Units =3D sectors of 1 * 512 =3D 512 bytes
Sector size (logical/physical): 512 bytes / 4096 bytes
I/O size (minimum/optimal): 65536 bytes / 1441792 bytes
Disk identifier: 0x00000000

Disk /dev/md1 doesn't contain a valid partition table


# file -s /dev/md1
/dev/md1: LVM2 PV (Linux Logical Volume Manager), UUID: 1lz3cZ-j4Sj-ZTc=
H-GiEm-eXGi-qMSr-lIzwyS, size: 65999978102784

=46or reference an array of the same size, attached to the HW RAID cont=
roller
# fdisk -l /dev/sda

Disk /dev/sda: 66000.0 GB, 65999989637120 bytes
255 heads, 63 sectors/track, 8024041 cylinders, total 128906229760 sect=
ors
Units =3D sectors of 1 * 512 =3D 512 bytes
Sector size (logical/physical): 512 bytes / 4096 bytes
I/O size (minimum/optimal): 4096 bytes / 4096 bytes
Disk identifier: 0x00000000

Disk /dev/sda doesn't contain a valid partition table


> On Mar 7, 2016, at 4:50 PM, Andreas Klauer <Andreas.Klauer@metamorphe=
r.de> wrote:
>=20
> On Sun, Mar 06, 2016 at 04:37:42PM -0500, Dan Russell wrote:
>> can md read a RAID6 created by the 2108, or would I be wasting my ti=
me?
>=20
> It might be possible.
>=20
> I don't use HW-RAID anywhere but if I was forced to, this would be=20
> one of the first things to determine, how to read it with software=20
> in case the card fails.
>=20
>> I can paste or gist the output of madam -E (304 lines) if it would h=
elp.
>=20
> I don't know if it would help, but paste everything you have anyhow.
>=20
> Is the data encrypted? If not - search for known file type headers=20
> (like a large jpeg or tar.gz, something larger than disks * chunksize=
),=20
> then look at the data on the other disks at the same offsets=20
> (grab a few megs of each disks), then try to deduce the layout=20
> and structure from that.
>=20
> Basically use known data to reverse-engineer the layout if you=20
> currently know nothing about disk orders, chunk sizes, etc.
>=20
> Regards
> Andreas Klauer

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
