From: NeilBrown <neilb@suse.de>
Subject: Re: Stuck array after reshape
Date: Wed, 21 May 2014 09:33:06 +1000
Message-ID: <20140521093306.7032d8d1@notabene.brown>
References: <20140520185617.00b48727@dsg.is>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/2s/nHTzozkyZcbBn/TL6tEW"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20140520185617.00b48727@dsg.is>
Sender: linux-raid-owner@vger.kernel.org
To: =?UTF-8?B?RGF2w63DsA==?= Steinn Geirsson <david@dsg.is>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/2s/nHTzozkyZcbBn/TL6tEW
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Tue, 20 May 2014 18:56:17 +0000 Dav=C3=AD=C3=B0 Steinn Geirsson <david@d=
sg.is> wrote:

> Hi all,
>=20
> I tried to reshape an MD RAID array, going from a 4-disk RAID5 to a
> 6-disk RAID6. This seems to have failed and now I'm afraid to turn the
> machine off.
>=20
> What I did:
> mdadm --add /dev/md5 /dev/sdh1
> mdadm --add /dev/md5 /dev/sdg1
> mdadm --grow /dev/md5 --backup-file /root/vg_3T_reshape_201405_mdbackup
> --level=3D6 --raid-devices=3D6
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

This line is strange.  Something killed the kernel thread which is performi=
ng
the reshape.  I cannot imagine what would have done that, but it does seem =
to
explain why things aren't working.

When you are increasing the size of the array - as you are in this case - y=
ou
don't really need a backup file, and even if you give one it will ony be
used for the first few stripes.  So that fact that it no longer exists is
expected.

Based on the --examine output that you subsequently post, the reshape has
started, but didn't get very far.  If you stop and restart the array it
should continue.

Don't remove the new devices as you suggest below.  Just a clean reboot or=
=20
  mdadm -S /dev/md5
  mdadm -A /dev/md5 /dev/sd[abdegh]1

should do the trick.

You data should be completely safe.

NeilBrown



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
> [ 1681.128303]  [<ffffffff813488c9>] ? out_of_line_wait_on_bit+0x6f/0x78
> [ 1681.128310]  [<ffffffff8111bda1>] ? wait_on_buffer+0x28/0x28
> [ 1681.128319]  [<ffffffff8105f575>] ?
> autoremove_wake_function+0x2a/0x2a
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
> everything "just work"... but I don't want to try that just yet, in case
> it prevents future data recovery work.
>=20
> Any thoughts? Or more debug info I could provide to diagnose this?
>=20
> Best regards,
> Dav=C3=AD=C3=B0


--Sig_/2s/nHTzozkyZcbBn/TL6tEW
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBU3vmMjnsnt1WYoG5AQIazQ//cQzt8wQ48yaJpo/9pbmvfYs/+mgx8zeR
6YRYDiTtBR8nMvLV0oQgmKFLqCyVTOutRT+FlLAZDpeaj0b9WpAwmLfAa0PVJ164
nkiVggEvP+R+AZBI6HiQhEPAiGoZjStFFX9Pv7cgHzcviWUQ+yPlbCT3hBuhiWaj
6bS1C0BvXVQ/t6VS6w95FyJ8Q1kKYP/XteUk0r1HyMU8HzRmuca3fBLeidqw22ws
+SMQ0U0mbDbR5Fc+tY6WcPcoaGMChxI7MRpW5OnguM/b2ndOn2uPUgKXjbhGq0CS
wBEJGM39CkrWo4xQxr5Q8pPxWwcx1lBac6VxvnBZHynp4JKhQ7ud6K4H2JYODWFf
9MBOqtPd+0SXlZaJvITslitakFi7Jp1JvvYsefyVOD/Pb/pi9ku+/3hHD5EzDlPh
5L6Bhs3/beZ/P1N3W5cBvhjsdni5baOyJPengWCxlFxSUHI8A+rLjjQjekaJneV7
iN77g+MyFg//9eEpHVwzH2bdOKbx/59HsmIzQ1hZTF1PDyeyLTijfYTSAeqyzcrA
ET0gC7KJtQBHXedhn3vo/Sd3pHSCbF5SJzt+dLQYw1hP7xMQGZzzm/bww5YkXSG7
4Fpu9+FHlHJv02ZlxSxC1oOuXqhKmEagkdenbk6bWuuvgyQ1xNy6pcHqDyBXd3VK
SHaGbxelD0Q=
=DJCg
-----END PGP SIGNATURE-----

--Sig_/2s/nHTzozkyZcbBn/TL6tEW--
