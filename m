From: =?UTF-8?B?RGF2w63DsA==?= Steinn Geirsson <david@dsg.is>
Subject: Re: Stuck array after reshape
Date: Tue, 20 May 2014 19:04:48 +0000
Message-ID: <20140520190448.467a25ca@dsg.is>
References: <20140520185617.00b48727@dsg.is>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/3+GZZL4YIxuBT8TEDroDr+p"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20140520185617.00b48727@dsg.is>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/3+GZZL4YIxuBT8TEDroDr+p
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Some more information:

The backup file did not get created.

Output of mdadm --examine on all array members:
/dev/sdb1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x4
     Array UUID : 0776e3ee:8eadc682:c8ff2ffd:d55da146
           Name : provider:5  (local to host provider)
  Creation Time : Fri Dec 14 19:30:10 2012
     Raid Level : raid6
   Raid Devices : 6

 Avail Dev Size : 5857157120 (2792.91 GiB 2998.86 GB)
     Array Size : 11714312192 (11171.64 GiB 11995.46 GB)
  Used Dev Size : 5857156096 (2792.91 GiB 2998.86 GB)
    Data Offset : 262144 sectors
   Super Offset : 8 sectors
          State : active
    Device UUID : aeefb8d7:6ccfae75:44060614:0bfb97d8

  Reshape pos'n : 8192 (8.00 MiB 8.39 MB)
  Delta Devices : 1 (5->6)
     New Layout : left-symmetric

    Update Time : Tue May 20 18:29:25 2014
       Checksum : dfd2dc2b - correct
         Events : 40365

         Layout : left-symmetric-6
     Chunk Size : 512K

   Device Role : Active device 1
   Array State : AAAAAA ('A' =3D=3D active, '.' =3D=3D missing)
/dev/sdc1:
          Magic : a92b4efc
        Version : 0.90.00
           UUID : f9d7a8cc:b8f830c4:b748a00c:d0712fef
  Creation Time : Mon May 18 20:35:08 2009
     Raid Level : raid1
  Used Dev Size : 979840 (957.04 MiB 1003.36 MB)
     Array Size : 979840 (957.04 MiB 1003.36 MB)
   Raid Devices : 2
  Total Devices : 2
Preferred Minor : 0

    Update Time : Tue May 20 18:04:34 2014
          State : clean
 Active Devices : 2
Working Devices : 2
 Failed Devices : 0
  Spare Devices : 0
       Checksum : 8151619e - correct
         Events : 2657


      Number   Major   Minor   RaidDevice State
this     0       8       33        0      active sync   /dev/sdc1

   0     0       8       33        0      active sync   /dev/sdc1
   1     1       8       81        1      active sync   /dev/sdf1
/dev/sdd1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x4
     Array UUID : 0776e3ee:8eadc682:c8ff2ffd:d55da146
           Name : provider:5  (local to host provider)
  Creation Time : Fri Dec 14 19:30:10 2012
     Raid Level : raid6
   Raid Devices : 6

 Avail Dev Size : 5857157120 (2792.91 GiB 2998.86 GB)
     Array Size : 11714312192 (11171.64 GiB 11995.46 GB)
  Used Dev Size : 5857156096 (2792.91 GiB 2998.86 GB)
    Data Offset : 262144 sectors
   Super Offset : 8 sectors
          State : active
    Device UUID : 4e00dec5:806115fc:f89d0c60:f000afc8

  Reshape pos'n : 8192 (8.00 MiB 8.39 MB)
  Delta Devices : 1 (5->6)
     New Layout : left-symmetric

    Update Time : Tue May 20 18:29:25 2014
       Checksum : 907c1c76 - correct
         Events : 40365

         Layout : left-symmetric-6
     Chunk Size : 512K

   Device Role : Active device 3
   Array State : AAAAAA ('A' =3D=3D active, '.' =3D=3D missing)
/dev/sde1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x4
     Array UUID : 0776e3ee:8eadc682:c8ff2ffd:d55da146
           Name : provider:5  (local to host provider)
  Creation Time : Fri Dec 14 19:30:10 2012
     Raid Level : raid6
   Raid Devices : 6

 Avail Dev Size : 5857157120 (2792.91 GiB 2998.86 GB)
     Array Size : 11714312192 (11171.64 GiB 11995.46 GB)
  Used Dev Size : 5857156096 (2792.91 GiB 2998.86 GB)
    Data Offset : 262144 sectors
   Super Offset : 8 sectors
          State : active
    Device UUID : a912e9ad:a9c802bb:26d296f2:7efe0ef6

  Reshape pos'n : 8192 (8.00 MiB 8.39 MB)
  Delta Devices : 1 (5->6)
     New Layout : left-symmetric

    Update Time : Tue May 20 18:29:25 2014
       Checksum : f75ec7b8 - correct
         Events : 40365

         Layout : left-symmetric-6
     Chunk Size : 512K

   Device Role : Active device 0
   Array State : AAAAAA ('A' =3D=3D active, '.' =3D=3D missing)
/dev/sdf1:
          Magic : a92b4efc
        Version : 0.90.00
           UUID : f9d7a8cc:b8f830c4:b748a00c:d0712fef
  Creation Time : Mon May 18 20:35:08 2009
     Raid Level : raid1
  Used Dev Size : 979840 (957.04 MiB 1003.36 MB)
     Array Size : 979840 (957.04 MiB 1003.36 MB)
   Raid Devices : 2
  Total Devices : 2
Preferred Minor : 0

    Update Time : Tue May 20 18:04:34 2014
          State : clean
 Active Devices : 2
Working Devices : 2
 Failed Devices : 0
  Spare Devices : 0
       Checksum : 815161d0 - correct
         Events : 2657


      Number   Major   Minor   RaidDevice State
this     1       8       81        1      active sync   /dev/sdf1

   0     0       8       33        0      active sync   /dev/sdc1
   1     1       8       81        1      active sync   /dev/sdf1
/dev/sdg1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x6
     Array UUID : 0776e3ee:8eadc682:c8ff2ffd:d55da146
           Name : provider:5  (local to host provider)
  Creation Time : Fri Dec 14 19:30:10 2012
     Raid Level : raid6
   Raid Devices : 6

 Avail Dev Size : 5857157120 (2792.91 GiB 2998.86 GB)
     Array Size : 11714312192 (11171.64 GiB 11995.46 GB)
  Used Dev Size : 5857156096 (2792.91 GiB 2998.86 GB)
    Data Offset : 262144 sectors
   Super Offset : 8 sectors
Recovery Offset : 4096 sectors
          State : active
    Device UUID : 4f8b8fa9:7b1fa78d:f949e727:e49b5647

  Reshape pos'n : 8192 (8.00 MiB 8.39 MB)
  Delta Devices : 1 (5->6)
     New Layout : left-symmetric

    Update Time : Tue May 20 18:29:25 2014
       Checksum : 4c41bc6d - correct
         Events : 40365

         Layout : left-symmetric-6
     Chunk Size : 512K

   Device Role : Active device 4
   Array State : AAAAAA ('A' =3D=3D active, '.' =3D=3D missing)
/dev/sdh1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x4
     Array UUID : 0776e3ee:8eadc682:c8ff2ffd:d55da146
           Name : provider:5  (local to host provider)
  Creation Time : Fri Dec 14 19:30:10 2012
     Raid Level : raid6
   Raid Devices : 6

 Avail Dev Size : 5857157120 (2792.91 GiB 2998.86 GB)
     Array Size : 11714312192 (11171.64 GiB 11995.46 GB)
  Used Dev Size : 5857156096 (2792.91 GiB 2998.86 GB)
    Data Offset : 262144 sectors
   Super Offset : 8 sectors
          State : active
    Device UUID : 40d5699d:911a2a3f:d91abf18:49ba8467

  Reshape pos'n : 8192 (8.00 MiB 8.39 MB)
  Delta Devices : 1 (5->6)
     New Layout : left-symmetric

    Update Time : Tue May 20 18:29:25 2014
       Checksum : 2a4e0b6 - correct
         Events : 40365

         Layout : left-symmetric-6
     Chunk Size : 512K

   Device Role : Active device 5
   Array State : AAAAAA ('A' =3D=3D active, '.' =3D=3D missing)




On Tue, 20 May 2014 18:56:17 +0000
Dav=C3=AD=C3=B0 Steinn Geirsson <david@dsg.is> wrote:

> Hi all,
>=20
> I tried to reshape an MD RAID array, going from a 4-disk RAID5 to a
> 6-disk RAID6. This seems to have failed and now I'm afraid to turn the
> machine off.
>=20
> What I did:
> mdadm --add /dev/md5 /dev/sdh1
> mdadm --add /dev/md5 /dev/sdg1
> mdadm --grow /dev/md5
> --backup-file /root/vg_3T_reshape_201405_mdbackup --level=3D6
> --raid-devices=3D6
>=20
> The last command returned with no error, the way it usually does.
> However, now everything that tries to access the array hangs:
> mdadm -D /dev/md5 # hangs
> cat /proc/mdstat # hangs
> Trying to read mounted filesystems also hangs.
>=20
> The two new drives are on a brand new IBM M1015 (crossflashed to LSI
> 9211). I have not used this controller previously, but before I tried
> the reshape I did write a GPT partition table and successfully read it
> back from the two drives.
>=20
> From dmesg around this time:
> [ 1340.951731] md: bind<sdh1>
> [ 1346.150654] scsi_verify_blk_ioctl: 38 callbacks suppressed
> [ 1346.150662] mdadm: sending ioctl 1261 to a partition!
> [ 1346.150669] mdadm: sending ioctl 1261 to a partition!
> [ 1346.155219] mdadm: sending ioctl 1261 to a partition!
> [ 1346.155228] mdadm: sending ioctl 1261 to a partition!
> [ 1346.160528] mdadm: sending ioctl 1261 to a partition!
> [ 1346.160535] mdadm: sending ioctl 1261 to a partition!
> [ 1346.160688] mdadm: sending ioctl 1261 to a partition!
> [ 1346.160694] mdadm: sending ioctl 1261 to a partition!
> [ 1346.160913] mdadm: sending ioctl 1261 to a partition!
> [ 1346.160918] mdadm: sending ioctl 1261 to a partition!
> [ 1346.185864] md: bind<sdg1>
> [ 1370.267086] scsi_verify_blk_ioctl: 38 callbacks suppressed
> [ 1370.267095] mdadm: sending ioctl 1261 to a partition!
> [ 1370.267103] mdadm: sending ioctl 1261 to a partition!
> [ 1461.662068] mdadm: sending ioctl 1261 to a partition!
> [ 1461.662078] mdadm: sending ioctl 1261 to a partition!
> [ 1521.675927] md/raid:md5: device sde1 operational as raid disk 0
> [ 1521.675937] md/raid:md5: device sdd1 operational as raid disk 3
> [ 1521.675943] md/raid:md5: device sda1 operational as raid disk 2
> [ 1521.675949] md/raid:md5: device sdb1 operational as raid disk 1
> [ 1521.677471] md/raid:md5: allocated 5332kB
> [ 1521.692766] md/raid:md5: raid level 6 active with 4 out of 5
> devices, algorithm 18
> [ 1521.692849] RAID conf printout:
> [ 1521.692853]  --- level:6 rd:5 wd:4
> [ 1521.692859]  disk 0, o:1, dev:sde1
> [ 1521.692864]  disk 1, o:1, dev:sdb1
> [ 1521.692869]  disk 2, o:1, dev:sda1
> [ 1521.692873]  disk 3, o:1, dev:sdd1
> [ 1522.801181] RAID conf printout:
> [ 1522.801190]  --- level:6 rd:6 wd:5
> [ 1522.801196]  disk 0, o:1, dev:sde1
> [ 1522.801201]  disk 1, o:1, dev:sdb1
> [ 1522.801205]  disk 2, o:1, dev:sda1
> [ 1522.801210]  disk 3, o:1, dev:sdd1
> [ 1522.801215]  disk 4, o:1, dev:sdg1
> [ 1522.801230] RAID conf printout:
> [ 1522.801234]  --- level:6 rd:6 wd:5
> [ 1522.801239]  disk 0, o:1, dev:sde1
> [ 1522.801243]  disk 1, o:1, dev:sdb1
> [ 1522.801248]  disk 2, o:1, dev:sda1
> [ 1522.801252]  disk 3, o:1, dev:sdd1
> [ 1522.801256]  disk 4, o:1, dev:sdg1
> [ 1522.801261]  disk 5, o:1, dev:sdh1
> [ 1522.801374] md: reshape of RAID array md5
> [ 1522.801379] md: minimum _guaranteed_  speed: 1000 KB/sec/disk.
> [ 1522.801384] md: using maximum available idle IO bandwidth (but not
> more than 200000 KB/sec) for reshape.
> [ 1522.801396] md: using 128k window, over a total of 2928578048k.
> [ 1522.802248] mdadm: sending ioctl 1261 to a partition!
> [ 1522.802256] mdadm: sending ioctl 1261 to a partition!
> [ 1522.883851] mdadm: sending ioctl 1261 to a partition!
> [ 1522.883860] mdadm: sending ioctl 1261 to a partition!
> [ 1525.134837] md: md_do_sync() got signal ... exiting
> [ 1681.128046] INFO: task jbd2/dm-3-8:1494 blocked for more than 120
> seconds.
> [ 1681.128129] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
> disables this message.
> [ 1681.128206] jbd2/dm-3-8     D ffff88007fc13540     0  1494      2
> 0x00000000
> [ 1681.128217]  ffff88007beab0a0 0000000000000046 ffff88005d0b1470
> ffff88007a3208b0
> [ 1681.128227]  0000000000013540 ffff88007c0dffd8 ffff88007c0dffd8
> ffff88007beab0a0
> [ 1681.128236]  059f7b5300000000 ffffffff81065a2f ffff88007bbe4d70
> ffff88007fc13d90
> [ 1681.128245] Call Trace:
> [ 1681.128263]  [<ffffffff81065a2f>] ? timekeeping_get_ns+0xd/0x2a
> [ 1681.128273]  [<ffffffff8111bda1>] ? wait_on_buffer+0x28/0x28
> [ 1681.128283]  [<ffffffff813483e4>] ? io_schedule+0x59/0x71
> [ 1681.128289]  [<ffffffff8111bda7>] ? sleep_on_buffer+0x6/0xa
> [ 1681.128296]  [<ffffffff81348827>] ? __wait_on_bit+0x3e/0x71
> [ 1681.128303]  [<ffffffff813488c9>] ?
> out_of_line_wait_on_bit+0x6f/0x78 [ 1681.128310]
> [<ffffffff8111bda1>] ? wait_on_buffer+0x28/0x28 [ 1681.128319]
> [<ffffffff8105f575>] ? autoremove_wake_function+0x2a/0x2a
> [ 1681.128354]  [<ffffffffa018d9c0>] ?
> jbd2_journal_commit_transaction+0xb9b/0x1057 [jbd2]
> [ 1681.128366]  [<ffffffff8100d02f>] ? load_TLS+0x7/0xa
> [ 1681.128373]  [<ffffffff8100d6a3>] ? __switch_to+0x133/0x258
> [ 1681.128389]  [<ffffffffa01910ae>] ? kjournald2+0xc0/0x20a [jbd2]
> [ 1681.128397]  [<ffffffff8105f54b>] ? add_wait_queue+0x3c/0x3c
> [ 1681.128412]  [<ffffffffa0190fee>] ? commit_timeout+0x5/0x5 [jbd2]
> [ 1681.128420]  [<ffffffff8105ef05>] ? kthread+0x76/0x7e
> [ 1681.128430]  [<ffffffff813505b4>] ? kernel_thread_helper+0x4/0x10
> [ 1681.128438]  [<ffffffff8105ee8f>] ? kthread_worker_fn+0x139/0x139
> [ 1681.128446]  [<ffffffff813505b0>] ? gs_change+0x13/0x13
> [... more hung task warnings from other processes follow ...]
>=20
>=20
> This machine is running debian wheezy. mdadm version is 3.2.5-1 from
> debian wheezy. Kernel is 3.2.18-1 from wheezy (3.2.0-2-amd64).
>=20
> Any help would be much appreciated! Especially if the data is
> recoverable. It's possible that the reshape process never actually got
> started and rebooting the machine without the new disks will make
> everything "just work"... but I don't want to try that just yet, in
> case it prevents future data recovery work.
>=20
> Any thoughts? Or more debug info I could provide to diagnose this?
>=20
> Best regards,
> Dav=C3=AD=C3=B0


--Sig_/3+GZZL4YIxuBT8TEDroDr+p
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTe6dQAAoJEI9CLKE3JSPgpcsP/iRDvDiazVmrSYHi0oX7e+bG
IB9cuTu0rp17ZGLUHJW7juM/nFj9YEIHG1yX6gJQMyDmDNxLYWrxhl5bQrKQP4At
C7izNKYhucSTlTDNyFCLEC5d6yR/2H2rdije4d/lKx5e04FqVA6+Gfg1NjPexLEC
jYgA3M057ShCSG8Fci6hBXK2HV5IJtjXUZeRvSsHmgVZJNCGgya/gQ2HfdVGmK/R
Vyom5blGy1YeJ86msnTFsHvVoEYwz7cy6BcD4uXaXcU2C3k11Ux7YxiGS5iRJ2Be
TZnGeJEAXmlgnG0COCeovBfycpWrm2QcE9/MKIPOjTB3N0Bd3H5pPMBcbK6dyfga
9HSRanowDiMoY4Tr17GyFsBOx1N2qxLXNyCBsSbnVdCiWv1+EogjUBHq+/yZ6uXg
6I6hFaITVnz0a5R+QuJmmPsB4okKgiuPlK1ODApUWKK3D4F9bEO8tVXxGdb1I+4P
QCtoZXFxmX7llqlermlTk018Sdlaz12/pwyToONSotj2A0hYzJbj0ukqYTgiEoJM
J7exSWA9OduvLEsS5GDWVfe+GsCbePOhsmi64lFf9NnfHmQOQfWScGK9CBTSPO3+
zXYt2YKhwV0MuDyDMTsjn0t251bIrYfCyriBqhIjJg0kvQShi7oUn5t940hXz0VJ
SGR7xz8LYA+s8ONq426T
=50hg
-----END PGP SIGNATURE-----

--Sig_/3+GZZL4YIxuBT8TEDroDr+p--
