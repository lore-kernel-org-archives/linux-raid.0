From: Ron Leach <ronleach@tesco.net>
Subject: Re: Booting after Debian upgrade: /dev/md5 does not exist
Date: Tue, 22 Jul 2014 16:57:21 +0100
Message-ID: <53CE89E1.10109@tesco.net>
References: <53CE1C39.3070000@tesco.net> <53CE592B.6030706@turmel.org> <53CE654E.2000800@tesco.net> <53CE7E70.2000800@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <53CE7E70.2000800@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 22/07/2014 16:08, Phil Turmel wrote:
> I'm not sure why /dev/md126 didn't show up in blkid's report.  You mi=
ght
> still have a problem there.  Show the content of /proc/mdstat, please=
=2E
>

D5s2:/# cat /proc/mdstat
Personalities : [raid1]
md6 : active raid1 sda8[0] sdb8[1]
       1894420672 blocks [2/2] [UU]

md4 : active raid1 sda6[0] sdb6[1]
       976448 blocks [2/2] [UU]

md3 : active raid1 sda4[0] sdb4[1]
       4882688 blocks [2/2] [UU]

md2 : active raid1 sda3[0] sdb3[1]
       9765504 blocks [2/2] [UU]

md1 : active raid1 sda2[0] sdb2[1]
       2929600 blocks [2/2] [UU]

md0 : active raid1 sda1[0] sdb1[1]
       499904 blocks [2/2] [UU]

unused devices: <none>
D5s2:/#

No mention of sda7, sdb7, /dev/md126 or /dev/md5


> It might also help to document your system layout with "lsdrv" [1].
>

Thanks for that link.  I think lsdrv doesn't see sda7 or sdb7, either:

D5s2:/# ./lsdrv
**Warning** The following utility(ies) failed to execute:
   smartctl
   pvs
   lvs
Some information may be missing.

Controller platform [None]
=E2=94=94platform floppy.0
  =E2=94=94fd0 4.00k [2:0] Empty/Unknown
USB [usb-storage] Bus 001 Device 002: ID 13fd:0842 Initio Corporation=20
  {SATASLIM0000104729f}
=E2=94=94scsi 0:0:0:0 TSSTcorp CDDVDW SE-S084C
  =E2=94=94sr0 640.83m [11:0] Empty/Unknown
PCI [ata_piix] 00:1f.2 IDE interface: Intel Corporation N10/ICH7=20
=46amily SATA IDE Controller (rev 01)
=E2=94=9Cscsi 1:0:1:0 ATA      ST32000542AS     {xxxxxxxx}
=E2=94=82=E2=94=94sda 1.82t [8:0] Empty/Unknown
=E2=94=82 =E2=94=9Csda1 488.28m [8:1] MD raid1 (0/2) (w/ sdb1) in_sync=20
{eb3b45e8:e1d73b1a:63042e90:fced6612}
=E2=94=82 =E2=94=82=E2=94=94md0 488.19m [9:0] MD v0.90 raid1 (2) clean=20
{eb3b45e8:e1d73b1a:63042e90:fced6612}
=E2=94=82 =E2=94=82 =E2=94=82                 ext2 'boot' {67c165a8-020=
a-4931-98d4-21b3dcb5d53c}
=E2=94=82 =E2=94=82 =E2=94=94Mounted as /dev/md0 @ /boot
=E2=94=82 =E2=94=9Csda2 2.79g [8:2] MD raid1 (0/2) (w/ sdb2) in_sync=20
{93a0b403:18aa4e20:f77b0142:25a55090}
=E2=94=82 =E2=94=82=E2=94=94md1 2.79g [9:1] MD v0.90 raid1 (2) clean=20
{93a0b403:18aa4e20:f77b0142:25a55090}
=E2=94=82 =E2=94=82 =E2=94=82               xfs 'slash' {6fa78f26-4ca9-=
4e41-909d-ac4c8877f317}
=E2=94=82 =E2=94=82 =E2=94=94Mounted as /dev/root @ /
=E2=94=82 =E2=94=9Csda3 9.31g [8:3] MD raid1 (0/2) (w/ sdb3) in_sync=20
{99104b71:9dd6cf88:e1a05948:57032dd7}
=E2=94=82 =E2=94=82=E2=94=94md2 9.31g [9:2] MD v0.90 raid1 (2) clean=20
{99104b71:9dd6cf88:e1a05948:57032dd7}
=E2=94=82 =E2=94=82 =E2=94=82               xfs 'usr' {9ba54810-c299-42=
4c-b312-e13325e00e4f}
=E2=94=82 =E2=94=82 =E2=94=94Mounted as /dev/md2 @ /usr
=E2=94=82 =E2=94=9Csda4 4.66g [8:4] MD raid1 (0/2) (w/ sdb4) in_sync=20
{5dbd5605:1d61cbaa:ac5c64ee:5356e8a9}
=E2=94=82 =E2=94=82=E2=94=94md3 4.66g [9:3] MD v0.90 raid1 (2) clean=20
{5dbd5605:1d61cbaa:ac5c64ee:5356e8a9}
=E2=94=82 =E2=94=82 =E2=94=82               xfs 'var' {7d4918f3-eb9e-49=
3a-a106-b9c21eff412c}
=E2=94=82 =E2=94=82 =E2=94=94Mounted as /dev/md3 @ /var
=E2=94=82 =E2=94=9Csda5 953.67m [8:5] swap
=E2=94=82 =E2=94=9Csda6 953.67m [8:6] MD raid1 (0/2) (w/ sdb6) in_sync=20
{725cfde4:114fef9a:4ed1ccad:18d72d44}
=E2=94=82 =E2=94=82=E2=94=94md4 953.56m [9:4] MD v0.90 raid1 (2) clean=20
{725cfde4:114fef9a:4ed1ccad:18d72d44}
=E2=94=82 =E2=94=82 =E2=94=82                 xfs 'tmp' {cf09135c-cc46-=
424f-9f0b-a737cfacf27b}
=E2=94=82 =E2=94=82 =E2=94=94Mounted as /dev/md4 @ /tmp
=E2=94=82 =E2=94=9Csda7 37.25g [8:7] MD raid1 (2) inactive=20
{5bad4c7c:780696f4:e201a2f5:7bba85d7}
=E2=94=82 =E2=94=94sda8 1.76t [8:8] MD raid1 (0/2) (w/ sdb8) in_sync=20
{94171c8e:c47d18a8:c073121c:f9f222fe}
=E2=94=82  =E2=94=94md6 1.76t [9:6] MD v0.90 raid1 (2) clean=20
{94171c8e:c47d18a8:c073121c:f9f222fe}
=E2=94=82   =E2=94=82               xfs 'Data97' {a2e22925-f763-4b70-95=
59-d959b1eb9329}
=E2=94=82   =E2=94=94Mounted as /dev/md6 @ /Data97
=E2=94=94scsi 2:0:0:0 ATA      ST2000DL003-9VT1 {xxxxxxxx}
  =E2=94=94sdb 1.82t [8:16] Empty/Unknown
   =E2=94=9Csdb1 488.28m [8:17] MD raid1 (1/2) (w/ sda1) in_sync=20
{eb3b45e8:e1d73b1a:63042e90:fced6612}
   =E2=94=82=E2=94=94md0 488.19m [9:0] MD v0.90 raid1 (2) clean=20
{eb3b45e8:e1d73b1a:63042e90:fced6612}
   =E2=94=82                   ext2 'boot' {67c165a8-020a-4931-98d4-21b=
3dcb5d53c}
   =E2=94=9Csdb2 2.79g [8:18] MD raid1 (1/2) (w/ sda2) in_sync=20
{93a0b403:18aa4e20:f77b0142:25a55090}
   =E2=94=82=E2=94=94md1 2.79g [9:1] MD v0.90 raid1 (2) clean=20
{93a0b403:18aa4e20:f77b0142:25a55090}
   =E2=94=82                 xfs 'slash' {6fa78f26-4ca9-4e41-909d-ac4c8=
877f317}
   =E2=94=9Csdb3 9.31g [8:19] MD raid1 (1/2) (w/ sda3) in_sync=20
{99104b71:9dd6cf88:e1a05948:57032dd7}
   =E2=94=82=E2=94=94md2 9.31g [9:2] MD v0.90 raid1 (2) clean=20
{99104b71:9dd6cf88:e1a05948:57032dd7}
   =E2=94=82                 xfs 'usr' {9ba54810-c299-424c-b312-e13325e=
00e4f}
   =E2=94=9Csdb4 4.66g [8:20] MD raid1 (1/2) (w/ sda4) in_sync=20
{5dbd5605:1d61cbaa:ac5c64ee:5356e8a9}
   =E2=94=82=E2=94=94md3 4.66g [9:3] MD v0.90 raid1 (2) clean=20
{5dbd5605:1d61cbaa:ac5c64ee:5356e8a9}
   =E2=94=82                 xfs 'var' {7d4918f3-eb9e-493a-a106-b9c21ef=
f412c}
   =E2=94=9Csdb5 953.67m [8:21] swap
   =E2=94=9Csdb6 953.67m [8:22] MD raid1 (1/2) (w/ sda6) in_sync=20
{725cfde4:114fef9a:4ed1ccad:18d72d44}
   =E2=94=82=E2=94=94md4 953.56m [9:4] MD v0.90 raid1 (2) clean=20
{725cfde4:114fef9a:4ed1ccad:18d72d44}
   =E2=94=82                   xfs 'tmp' {cf09135c-cc46-424f-9f0b-a737c=
facf27b}
   =E2=94=9Csdb7 37.25g [8:23] MD raid1 (2) inactive=20
{5bad4c7c:780696f4:e201a2f5:7bba85d7}
   =E2=94=94sdb8 1.76t [8:24] MD raid1 (1/2) (w/ sda8) in_sync=20
{94171c8e:c47d18a8:c073121c:f9f222fe}
    =E2=94=94md6 1.76t [9:6] MD v0.90 raid1 (2) clean=20
{94171c8e:c47d18a8:c073121c:f9f222fe}
                     xfs 'Data97' {a2e22925-f763-4b70-9559-d959b1eb9329=
}
Other Block Devices
=E2=94=9Cloop0 0.00k [7:0] Empty/Unknown
=E2=94=9Cloop1 0.00k [7:1] Empty/Unknown
=E2=94=9Cloop2 0.00k [7:2] Empty/Unknown
=E2=94=9Cloop3 0.00k [7:3] Empty/Unknown
=E2=94=9Cloop4 0.00k [7:4] Empty/Unknown
=E2=94=9Cloop5 0.00k [7:5] Empty/Unknown
=E2=94=9Cloop6 0.00k [7:6] Empty/Unknown
=E2=94=9Cloop7 0.00k [7:7] Empty/Unknown
=E2=94=9Cram0 8.00m [1:0] Empty/Unknown
=E2=94=9Cram1 8.00m [1:1] Empty/Unknown
=E2=94=9Cram2 8.00m [1:2] Empty/Unknown
=E2=94=9Cram3 8.00m [1:3] Empty/Unknown
=E2=94=9Cram4 8.00m [1:4] Empty/Unknown
=E2=94=9Cram5 8.00m [1:5] Empty/Unknown
=E2=94=9Cram6 8.00m [1:6] Empty/Unknown
=E2=94=9Cram7 8.00m [1:7] Empty/Unknown
=E2=94=9Cram8 8.00m [1:8] Empty/Unknown
=E2=94=9Cram9 8.00m [1:9] Empty/Unknown
=E2=94=9Cram10 8.00m [1:10] Empty/Unknown
=E2=94=9Cram11 8.00m [1:11] Empty/Unknown
=E2=94=9Cram12 8.00m [1:12] Empty/Unknown
=E2=94=9Cram13 8.00m [1:13] Empty/Unknown
=E2=94=9Cram14 8.00m [1:14] Empty/Unknown
=E2=94=94ram15 8.00m [1:15] Empty/Unknown
D5s2:/#

No sign of sda7/sdb7, the partitions that underlie /dev/md126.  I ran=20
gdisk on sda (sdb is identical - I had used gdisk to replicate the=20
partition structure when I did that RAID 1 repair a few days ago):

D5s2:/# gdisk
GPT fdisk (gdisk) version 0.8.1

Type device filename, or press <Enter> to exit: /dev/sda
Partition table scan:
   MBR: protective
   BSD: not present
   APM: not present
   GPT: present

=46ound valid GPT with protective MBR; using GPT.

Command (? for help): ?
b       back up GPT data to a file
c       change a partition's name
d       delete a partition
i       show detailed information on a partition
l       list known partition types
n       add a new partition
o       create a new empty GUID partition table (GPT)
p       print the partition table
q       quit without saving changes
r       recovery and transformation options (experts only)
s       sort partitions
t       change a partition's type code
v       verify disk
w       write table to disk and exit
x       extra functionality (experts only)
?       print this menu

Command (? for help): i
Partition number (1-8): 7
Partition GUID code: A19D880F-05FC-4D3B-A006-743F0F84911E (Linux RAID)
Partition unique GUID: 34925916-6AB9-4461-8F2D-32DA766C2116
=46irst sector: 40062540 (at 19.1 GiB)
Last sector: 118187540 (at 56.4 GiB)
Partition size: 78125001 sectors (37.3 GiB)
Attribute flags: 0000000000000000
Partition name: ''

Command (? for help):

Note: That partition name is two, separate, apostrophes.  So the=20
partition name is blank, and so are the names of most of the=20
partitions.  So sda7 exists (and it has /home on it, if we could but=20
see it).

Phil, thanks very much for the time you've spent on this.  I'm going=20
to carefully make the changes to mdadm.conf, fstab, and initramfs now,=20
and reboot; It seems as though it might boot again ok.

regards, Ron
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
