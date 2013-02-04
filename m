From: Phil Turmel <philip@turmel.org>
Subject: Re: Raid 5 to 6 migration
Date: Mon, 04 Feb 2013 13:39:26 -0500
Message-ID: <5110005E.103@turmel.org>
References: <BLU0-SMTP433B0BCF64D448CC81098D2C91C0@phx.gbl>,<510C0075.9010908@turmel.org> <COL114-W137DD8871889508BBF087BC91C0@phx.gbl> <510C07FA.4090405@turmel.org> <BLU0-SMTP45011D3540FEA010403D4ABC9010@phx.gbl>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <BLU0-SMTP45011D3540FEA010403D4ABC9010@phx.gbl>
Sender: linux-raid-owner@vger.kernel.org
To: Dominique <dcouot@hotmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 02/04/2013 07:51 AM, Dominique wrote:
> Back from weekend, and still with my problem. Output of lsdrv is as f=
ollow:

Yuck, mangled utf-8.  Does it look that way on your console?
[output w/ fixed tree characters pasted below]

=46irst item, greatest importance:  You are using Western Digital Green
drives.  These are *unsafe* to use in raid arrays of any kind "out of
the box".  They do *not* support SCTERC.  You *must* use a boot-up
script to set the linux driver timeouts to two minutes or more or you
*will* crash this array.

I recommend a three minute timeout.  Something like this:
> for x in /sys/block/sd[abcdef]/driver/timeout ; do
> 	echo 180 > $x
> done

in "rc.local" or wherever your distribution likes such things.  And
don't wait for your next reboot--execute it now.

If you don't have that in place, it suggests that your array is very ne=
w
or you are not running any regular "scrub".  It is important that you
not be vulnerable during the reshape, as the array will be heavily
exercised.  If you aren't regularly scrubbing, execute:
> echo "check" >/sys/block/md2/md/sync_action

then monitor /proc/mdstat until it completes.  (Several hours)  Then
look at the mismatch count:
> cat /sys/block/md2/md/mismatch_count

It should be zero.

Otherwise, your array is a simple ext4 filesystem without any apparent
system dependencies.  So you should be able to do everything needed in
your normal boot environment, just shutting down the services that are
using the data in "/srv".  Once the filesystem itself is resized
(possibly quite quickly if your array has a great deal of free space),
the remainder of the work can occur online (with /srv mounted again and
your services restarted).

Here's your recipe:

1) Stop all services using /srv, then unmount with:
> umount /srv

2) Make sure the filesystem is consistent:
> fsck /dev/md2

3) Determine resizing options:
> resize2fs -P /dev/md2

This will report the number of blocks needed for the current contents
(usually in 4k blocks).  I don't recommend resizing all the way to the
minimum, as it may take much longer.  Just make sure you can shrink to
~10 terabytes.

4) Resize:
> resize2fs /dev/md2 10240G

5) Verify Ok:
> fsck -n /dev/md2

6) Instruct md to temporarily use less than the future size of md2 (but
more than the filesystem):
> mdadm --grow /dev/md2 --array-size=3D10241G

7) Verify Again:
> fsck -n /dev/md2

8) Instruct md to reshape to raid6 and view its progress:
> mdadm --grow /dev/md2 --level=3Draid6 --raid-devices=3D6
> cat /proc/mdstat

 (The reshape will continue in the background.)

9) If you need the services as soon as possible, the filesystem can be
remounted at this point, and the services restarted.  If /srv is in you=
r
fstab, just use:
> mount /srv

10) Depending on the speed of your components, and how heavily you use
the array, the reshape can take several hours to days.  I would expect
yours to take at least 7 hours, best case.  Once complete, you can
resize once more to the maximum available (this can be done while
mounted and the services running):
> mdadm --grow /dev/md2 --array-size=3Dmax
> resize2fs /dev/md2

If you run into any problems (or questions), let us know.

Regards,

Phil

--

PCI [ahci] 00:1f.2 SATA controller: Intel Corporation 6 Series/C200
Series Chipset Family SATA AHCI Controller (rev 05)
=E2=94=9Cscsi 0:0:0:0 ATA      WDC WD30EZRX-00M {WD-WCAWZ1618149}
=E2=94=82=E2=94=94sda 2.73t [8:0] Partitioned (gpt)
=E2=94=82 =E2=94=9Csda1 95.37m [8:1] vfat {89EF-00F4}
=E2=94=82 =E2=94=82=E2=94=94Mounted as /dev/sda1 @ /boot/efi
=E2=94=82 =E2=94=9Csda2 29.80g [8:2] MD raid1 (0/6) (w/ sdd2,sde2,sdc2,=
sdb2,sdf2)
in_sync 'solipym:0' {d2e6885b-2d25-6c5a-5f3d-e9a9a5daa736}
=E2=94=82 =E2=94=82=E2=94=94md0 29.80g [9:0] MD v1.2 raid1 (6) clean
{d2e6885b:2d256c5a:5f3de9a9:a5daa736}
=E2=94=82 =E2=94=82                  swap {8e565dfc-c5fa-4c76-abe9-f3a5=
a6e8fcff}
=E2=94=82 =E2=94=9Csda3 186.26g [8:3] MD raid1 (0/6) (w/ sdf3,sdd3,sde3=
,sdc3,sdb3)
in_sync 'solipym:1' {89d69c6f-2ea2-23f5-aec8-b67c403488ad}
=E2=94=82 =E2=94=82=E2=94=94md1 186.26g [9:1] MD v1.2 raid1 (6) clean
{89d69c6f:2ea223f5:aec8b67c:403488ad}
=E2=94=82 =E2=94=82 =E2=94=82                 ext4 {ca4bff22-40d8-4b31-=
859e-bba063f01df1}
=E2=94=82 =E2=94=82 =E2=94=9CMounted as /dev/disk/by-uuid/ca4bff22-40d8=
-4b31-859e-bba063f01df1 @ /
=E2=94=82 =E2=94=82 =E2=94=94Mounted as /dev/disk/by-uuid/ca4bff22-40d8=
-4b31-859e-bba063f01df1 @
/var/spool/hylafax/etc
=E2=94=82 =E2=94=94sda4 2.52t [8:4] MD raid5 (0/6) (w/ sdd4,sdb4,sde4,s=
dc4,sdf4) in_sync
'solipym:2' {84672b4c-8fae-7f38-bb4c-c911aa9d7444}
=E2=94=82  =E2=94=94md2 12.59t [9:2] MD v1.2 raid5 (6) clean, 512k Chun=
k
{84672b4c:8fae7f38:bb4cc911:aa9d7444}
=E2=94=82   =E2=94=82                ext4 {a9cfe95c-1e62-4cf6-b2aa-65ab=
bd0c77e4}
=E2=94=82   =E2=94=94Mounted as /dev/md2 @ /srv
=E2=94=9Cscsi 1:0:0:0 ATA      WDC WD30EZRX-00M {WD-WCAWZ1382990}
=E2=94=82=E2=94=94sdb 2.73t [8:16] Partitioned (gpt)
=E2=94=82 =E2=94=9Csdb1 95.37m [8:17] vfat {6EFD-1659}
=E2=94=82 =E2=94=9Csdb2 29.80g [8:18] MD raid1 (1/6) (w/ sda2,sdd2,sde2=
,sdc2,sdf2)
in_sync 'solipym:0' {d2e6885b-2d25-6c5a-5f3d-e9a9a5daa736}
=E2=94=82 =E2=94=82=E2=94=94md0 29.80g [9:0] MD v1.2 raid1 (6) clean
{d2e6885b:2d256c5a:5f3de9a9:a5daa736}
=E2=94=82 =E2=94=82                  swap {8e565dfc-c5fa-4c76-abe9-f3a5=
a6e8fcff}
=E2=94=82 =E2=94=9Csdb3 186.26g [8:19] MD raid1 (1/6) (w/ sdf3,sdd3,sde=
3,sda3,sdc3)
in_sync 'solipym:1' {89d69c6f-2ea2-23f5-aec8-b67c403488ad}
=E2=94=82 =E2=94=82=E2=94=94md1 186.26g [9:1] MD v1.2 raid1 (6) clean
{89d69c6f:2ea223f5:aec8b67c:403488ad}
=E2=94=82 =E2=94=82                   ext4 {ca4bff22-40d8-4b31-859e-bba=
063f01df1}
=E2=94=82 =E2=94=94sdb4 2.52t [8:20] MD raid5 (1/6) (w/ sdd4,sda4,sde4,=
sdc4,sdf4)
in_sync 'solipym:2' {84672b4c-8fae-7f38-bb4c-c911aa9d7444}
=E2=94=82  =E2=94=94md2 12.59t [9:2] MD v1.2 raid5 (6) clean, 512k Chun=
k
{84672b4c:8fae7f38:bb4cc911:aa9d7444}
=E2=94=82                    ext4 {a9cfe95c-1e62-4cf6-b2aa-65abbd0c77e4=
}
=E2=94=9Cscsi 2:0:0:0 ATA      WDC WD30EZRX-00M {WD-WCAWZ0995502}
=E2=94=82=E2=94=94sdc 2.73t [8:32] Partitioned (gpt)
=E2=94=82 =E2=94=9Csdc1 95.37m [8:33] vfat {16BF-AABE}
=E2=94=82 =E2=94=9Csdc2 29.80g [8:34] MD raid1 (2/6) (w/ sda2,sdd2,sde2=
,sdb2,sdf2)
in_sync 'solipym:0' {d2e6885b-2d25-6c5a-5f3d-e9a9a5daa736}
=E2=94=82 =E2=94=82=E2=94=94md0 29.80g [9:0] MD v1.2 raid1 (6) clean
{d2e6885b:2d256c5a:5f3de9a9:a5daa736}
=E2=94=82 =E2=94=82                  swap {8e565dfc-c5fa-4c76-abe9-f3a5=
a6e8fcff}
=E2=94=82 =E2=94=9Csdc3 186.26g [8:35] MD raid1 (2/6) (w/ sdf3,sdd3,sde=
3,sda3,sdb3)
in_sync 'solipym:1' {89d69c6f-2ea2-23f5-aec8-b67c403488ad}
=E2=94=82 =E2=94=82=E2=94=94md1 186.26g [9:1] MD v1.2 raid1 (6) clean
{89d69c6f:2ea223f5:aec8b67c:403488ad}
=E2=94=82 =E2=94=82                   ext4 {ca4bff22-40d8-4b31-859e-bba=
063f01df1}
=E2=94=82 =E2=94=94sdc4 2.52t [8:36] MD raid5 (2/6) (w/ sdd4,sda4,sdb4,=
sde4,sdf4)
in_sync 'solipym:2' {84672b4c-8fae-7f38-bb4c-c911aa9d7444}
=E2=94=82  =E2=94=94md2 12.59t [9:2] MD v1.2 raid5 (6) clean, 512k Chun=
k
{84672b4c:8fae7f38:bb4cc911:aa9d7444}
=E2=94=82                    ext4 {a9cfe95c-1e62-4cf6-b2aa-65abbd0c77e4=
}
=E2=94=9Cscsi 3:0:0:0 ATA      WDC WD30EZRX-00M {WD-WCAWZ1118226}
=E2=94=82=E2=94=94sdd 2.73t [8:48] Partitioned (gpt)
=E2=94=82 =E2=94=9Csdd1 95.37m [8:49] vfat {978F-21B2}
=E2=94=82 =E2=94=9Csdd2 29.80g [8:50] MD raid1 (3/6) (w/ sda2,sde2,sdc2=
,sdb2,sdf2)
in_sync 'solipym:0' {d2e6885b-2d25-6c5a-5f3d-e9a9a5daa736}
=E2=94=82 =E2=94=82=E2=94=94md0 29.80g [9:0] MD v1.2 raid1 (6) clean
{d2e6885b:2d256c5a:5f3de9a9:a5daa736}
=E2=94=82 =E2=94=82                  swap {8e565dfc-c5fa-4c76-abe9-f3a5=
a6e8fcff}
=E2=94=82 =E2=94=9Csdd3 186.26g [8:51] MD raid1 (3/6) (w/ sdf3,sde3,sda=
3,sdc3,sdb3)
in_sync 'solipym:1' {89d69c6f-2ea2-23f5-aec8-b67c403488ad}
=E2=94=82 =E2=94=82=E2=94=94md1 186.26g [9:1] MD v1.2 raid1 (6) clean
{89d69c6f:2ea223f5:aec8b67c:403488ad}
=E2=94=82 =E2=94=82                   ext4 {ca4bff22-40d8-4b31-859e-bba=
063f01df1}
=E2=94=82 =E2=94=94sdd4 2.52t [8:52] MD raid5 (3/6) (w/ sda4,sdb4,sde4,=
sdc4,sdf4)
in_sync 'solipym:2' {84672b4c-8fae-7f38-bb4c-c911aa9d7444}
=E2=94=82  =E2=94=94md2 12.59t [9:2] MD v1.2 raid5 (6) clean, 512k Chun=
k
{84672b4c:8fae7f38:bb4cc911:aa9d7444}
=E2=94=82                    ext4 {a9cfe95c-1e62-4cf6-b2aa-65abbd0c77e4=
}
=E2=94=9Cscsi 4:0:0:0 ATA      WDC WD30EZRX-00M {WD-WCAWZ1649385}
=E2=94=82=E2=94=94sde 2.73t [8:64] Partitioned (gpt)
=E2=94=82 =E2=94=9Csde1 95.37m [8:65] vfat {8875-2D50}
=E2=94=82 =E2=94=9Csde2 29.80g [8:66] MD raid1 (4/6) (w/ sda2,sdd2,sdc2=
,sdb2,sdf2)
in_sync 'solipym:0' {d2e6885b-2d25-6c5a-5f3d-e9a9a5daa736}
=E2=94=82 =E2=94=82=E2=94=94md0 29.80g [9:0] MD v1.2 raid1 (6) clean
{d2e6885b:2d256c5a:5f3de9a9:a5daa736}
=E2=94=82 =E2=94=82                  swap {8e565dfc-c5fa-4c76-abe9-f3a5=
a6e8fcff}
=E2=94=82 =E2=94=9Csde3 186.26g [8:67] MD raid1 (4/6) (w/ sdf3,sdd3,sda=
3,sdc3,sdb3)
in_sync 'solipym:1' {89d69c6f-2ea2-23f5-aec8-b67c403488ad}
=E2=94=82 =E2=94=82=E2=94=94md1 186.26g [9:1] MD v1.2 raid1 (6) clean
{89d69c6f:2ea223f5:aec8b67c:403488ad}
=E2=94=82 =E2=94=82                   ext4 {ca4bff22-40d8-4b31-859e-bba=
063f01df1}
=E2=94=82 =E2=94=94sde4 2.52t [8:68] MD raid5 (4/6) (w/ sdd4,sda4,sdb4,=
sdc4,sdf4)
in_sync 'solipym:2' {84672b4c-8fae-7f38-bb4c-c911aa9d7444}
=E2=94=82  =E2=94=94md2 12.59t [9:2] MD v1.2 raid5 (6) clean, 512k Chun=
k
{84672b4c:8fae7f38:bb4cc911:aa9d7444}
=E2=94=82                    ext4 {a9cfe95c-1e62-4cf6-b2aa-65abbd0c77e4=
}
=E2=94=94scsi 5:0:0:0 ATA      WDC WD30EZRX-00M {WD-WCAWZ1383151}
 =E2=94=94sdf 2.73t [8:80] Partitioned (gpt)
  =E2=94=9Csdf1 95.37m [8:81] vfat {A89B-DC05}
  =E2=94=9Csdf2 29.80g [8:82] MD raid1 (5/6) (w/ sda2,sdd2,sde2,sdc2,sd=
b2)
in_sync 'solipym:0' {d2e6885b-2d25-6c5a-5f3d-e9a9a5daa736}
  =E2=94=82=E2=94=94md0 29.80g [9:0] MD v1.2 raid1 (6) clean
{d2e6885b:2d256c5a:5f3de9a9:a5daa736}
  =E2=94=82                  swap {8e565dfc-c5fa-4c76-abe9-f3a5a6e8fcff=
}
  =E2=94=9Csdf3 186.26g [8:83] MD raid1 (5/6) (w/ sdd3,sde3,sda3,sdc3,s=
db3)
in_sync 'solipym:1' {89d69c6f-2ea2-23f5-aec8-b67c403488ad}
  =E2=94=82=E2=94=94md1 186.26g [9:1] MD v1.2 raid1 (6) clean
{89d69c6f:2ea223f5:aec8b67c:403488ad}
  =E2=94=82                   ext4 {ca4bff22-40d8-4b31-859e-bba063f01df=
1}
  =E2=94=94sdf4 2.52t [8:84] MD raid5 (5/6) (w/ sdd4,sda4,sdb4,sde4,sdc=
4)
in_sync 'solipym:2' {84672b4c-8fae-7f38-bb4c-c911aa9d7444}
   =E2=94=94md2 12.59t [9:2] MD v1.2 raid5 (6) clean, 512k Chunk
{84672b4c:8fae7f38:bb4cc911:aa9d7444}
                     ext4 {a9cfe95c-1e62-4cf6-b2aa-65abbd0c77e4}
USB [usb-storage] Bus 002 Device 004: ID 059f:1010 LaCie, Ltd Desktop
Hard Drive {ST3500830A            9QG6RC54}
=E2=94=94scsi 6:0:0:0 ST350083 0AS
 =E2=94=94sdg 465.76g [8:96] Partitioned (dos)
  =E2=94=94sdg1 465.76g [8:97] ext4 {4c2f6b92-829d-4e53-b553-c07e0f571e=
02}
   =E2=94=94Mounted as /dev/sdg1 @ /mnt
Other Block Devices
=E2=94=9Cloop0 0.00k [7:0] Empty/Unknown
=E2=94=9Cloop1 0.00k [7:1] Empty/Unknown
=E2=94=9Cloop2 0.00k [7:2] Empty/Unknown
=E2=94=9Cloop3 0.00k [7:3] Empty/Unknown
=E2=94=9Cloop4 0.00k [7:4] Empty/Unknown
=E2=94=9Cloop5 0.00k [7:5] Empty/Unknown
=E2=94=9Cloop6 0.00k [7:6] Empty/Unknown
=E2=94=9Cloop7 0.00k [7:7] Empty/Unknown
=E2=94=9Cram0 64.00m [1:0] Empty/Unknown
=E2=94=9Cram1 64.00m [1:1] Empty/Unknown
=E2=94=9Cram2 64.00m [1:2] Empty/Unknown
=E2=94=9Cram3 64.00m [1:3] Empty/Unknown
=E2=94=9Cram4 64.00m [1:4] Empty/Unknown
=E2=94=9Cram5 64.00m [1:5] Empty/Unknown
=E2=94=9Cram6 64.00m [1:6] Empty/Unknown
=E2=94=9Cram7 64.00m [1:7] Empty/Unknown
=E2=94=9Cram8 64.00m [1:8] Empty/Unknown
=E2=94=9Cram9 64.00m [1:9] Empty/Unknown
=E2=94=9Cram10 64.00m [1:10] Empty/Unknown
=E2=94=9Cram11 64.00m [1:11] Empty/Unknown
=E2=94=9Cram12 64.00m [1:12] Empty/Unknown
=E2=94=9Cram13 64.00m [1:13] Empty/Unknown
=E2=94=9Cram14 64.00m [1:14] Empty/Unknown
=E2=94=94ram15 64.00m [1:15] Empty/Unknown
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
