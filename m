From: NeilBrown <neilb@suse.de>
Subject: Re: Raid5 hang in 3.14.19
Date: Tue, 14 Oct 2014 12:42:45 +1100
Message-ID: <20141014124245.69b143e2@notabene.brown>
References: <5425E9D6.1050102@sbcglobal.net>
	<20140929122533.3b91a543@notabene.brown>
	<5428D863.7090409@sbcglobal.net>
	<20140929140818.1086972e@notabene.brown>
	<5428DFE1.9080600@sbcglobal.net>
	<20140930075950.1d1e3865@notabene.brown>
	<542B1EDC.7060803@sbcglobal.net>
	<20141001085409.41399b13@notabene.brown>
	<54316C34.6090304@sbcglobal.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/XCWhzPt_itbay69xnkpy8QT"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <54316C34.6090304@sbcglobal.net>
Sender: linux-raid-owner@vger.kernel.org
To: BillStuff <billstuff2001@sbcglobal.net>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/XCWhzPt_itbay69xnkpy8QT
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sun, 05 Oct 2014 11:05:08 -0500 BillStuff <billstuff2001@sbcglobal.net>
wrote:

> On 09/30/2014 05:54 PM, NeilBrown wrote:
> > [removed alot of stuff about raid5 check hanging]
> > Thanks for the testing!  You have included enough information.
> > I didn't really like that 'sync_starting' variable when I wrote the pat=
ch,
> > but it seemed do the right thing.  It doesn't.
> >
> > If md_check_recovery() runs again immediately after scheduling the sync
> > thread to run, it will not have set sync_starting but will find ->sync_=
thread
> > is NULL and so will clear MD_RECOVERY_RUNNING.  The next time it runs, =
that
> > flag is still clear and ->sync_thread is not NULL so it will try to sto=
p the
> > thread, which deadlocks.
> >
> > This patch on top of what you have should fix it... but I might end up
> > redoing the logic a bit.
> >
> Neil,
>=20
> With the second patch, my test has been running well for close to 5 days=
=20
> now,

That is good news - thanks.

> but something odd happened yesterday.
>=20
> It's on a raid1 array (md1) with both ext3 and xfs on LVM, but I suspect=
=20
> it happened silently on my
> raid5 test also.
>=20
> md1 : active raid1 sdh3[0] sdg3[1]
>        76959296 blocks [2/2] [UU]
>        [=3D>...................]  check =3D  9.7% (7532800/76959296)=20
> finish=3D108.8min speed=3D10628K/sec
>        bitmap: 0/1 pages [0KB], 65536KB chunk
>=20
>=20
>=20
> Again this is running kernel builds, read / write loops, and remove/=20
> (re)add / check loops.
> At some point while removing a disk from the array, something bad=20
> happened, the errors below
> appeared in the log, and the ext3 filesystem remounted readonly. xfs=20
> plowed right on through.
> There's no evidence of any read or write errors to the member disks,=20
> either in logs or on the
> disks themselves, and the raid1 checks came back with zero mismatches.=20
> fsck for the ext3 fs
> complained a lot but the filesystem came back into a useable state and=20
> I've restarted my tests.
> Below, dm-3 is xfs, dm-1 is ext3. The interesting stuff happens around=20
> 12:27:04. This was
> immediately after (or during?) removing sdh3 from md1.
>=20
> Oct  4 12:26:01 xplane kernel: md: unbind<sdg3>
> Oct  4 12:26:01 xplane kernel: md: export_rdev(sdg3)
> Oct  4 12:26:11 xplane kernel: md: bind<sdg3>

Removed and re-added sdg3


> Oct  4 12:26:11 xplane kernel: RAID1 conf printout:
> Oct  4 12:26:11 xplane kernel:  --- wd:1 rd:2
> Oct  4 12:26:11 xplane kernel:  disk 0, wo:0, o:1, dev:sdh3
> Oct  4 12:26:11 xplane kernel:  disk 1, wo:1, o:1, dev:sdg3

->add_disk included sdg3 in the array not in-sync.

> Oct  4 12:26:12 xplane kernel: md: recovery of RAID array md1
> Oct  4 12:26:12 xplane kernel: md: minimum _guaranteed_  speed: 10000=20
> KB/sec/disk.
> Oct  4 12:26:12 xplane kernel: md: using maximum available idle IO=20
> bandwidth (but not more than 200000 KB/sec) for recovery.
> Oct  4 12:26:12 xplane kernel: md: using 128k window, over a total of=20
> 76959296k.

Recovery starts


> Oct  4 12:27:03 xplane kernel: md: md1: recovery done.

Recovery finishes after 51 seconds.

> Oct  4 12:27:03 xplane kernel: RAID1 conf printout:
> Oct  4 12:27:03 xplane kernel:  --- wd:2 rd:2
> Oct  4 12:27:03 xplane kernel:  disk 0, wo:0, o:1, dev:sdh3
> Oct  4 12:27:03 xplane kernel:  disk 1, wo:0, o:1, dev:sdg3

->spare_active() marks sdg3 at fully in-sync (not long "wo" - write only).

> Oct  4 12:27:04 xplane kernel: md/raid1:md1: Disk failure on sdh3,=20
> disabling device.

sdh3 fails a second later.  Presumably this was requested by your testing
harness.


> Oct  4 12:27:04 xplane kernel: md/raid1:md1: Operation continuing on 1=20
> devices.

raid.c:error() confirms the device will not be ignored.


> Oct  4 12:27:05 xplane kernel: quiet_error: 912 callbacks suppressed
> Oct  4 12:27:05 xplane kernel: Buffer I/O error on device dm-3, logical=20
> block 6331468
> Oct  4 12:27:05 xplane kernel: lost page write due to I/O error on dm-3

Write errors start happening.

You should only get a write error if no writes successfully completed to
in_sync, non-faulty devices.
It is possible that the write to sdg3 completed before it was marked in-syn=
c,
and the write to sdh3 completed after it was marked as faulty.
How long after recovery completes do you fail the next device?
The logs suggest it is the next second, which could be anywhere from 1msec
to 1998 msecs.


NeilBrown



> Oct  4 12:27:05 xplane kernel: Buffer I/O error on device dm-3, logical=20
> block 6331469
> Oct  4 12:27:05 xplane kernel: lost page write due to I/O error on dm-3
> Oct  4 12:27:05 xplane kernel: Buffer I/O error on device dm-3, logical=20
> block 6331470
> Oct  4 12:27:05 xplane kernel: lost page write due to I/O error on dm-3
> Oct  4 12:27:05 xplane kernel: Buffer I/O error on device dm-3, logical=20
> block 6331471
> Oct  4 12:27:05 xplane kernel: lost page write due to I/O error on dm-3
> Oct  4 12:27:05 xplane kernel: Buffer I/O error on device dm-3, logical=20
> block 6331472
> Oct  4 12:27:05 xplane kernel: lost page write due to I/O error on dm-3
> Oct  4 12:27:05 xplane kernel: Buffer I/O error on device dm-3, logical=20
> block 6331473
> Oct  4 12:27:05 xplane kernel: lost page write due to I/O error on dm-3
> Oct  4 12:27:05 xplane kernel: Buffer I/O error on device dm-3, logical=20
> block 6331474
> Oct  4 12:27:05 xplane kernel: lost page write due to I/O error on dm-3
> Oct  4 12:27:05 xplane kernel: Buffer I/O error on device dm-3, logical=20
> block 6331475
> Oct  4 12:27:05 xplane kernel: lost page write due to I/O error on dm-3
> Oct  4 12:27:05 xplane kernel: Buffer I/O error on device dm-3, logical=20
> block 6331476
> Oct  4 12:27:05 xplane kernel: lost page write due to I/O error on dm-3
> Oct  4 12:27:05 xplane kernel: Buffer I/O error on device dm-3, logical=20
> block 6331477
> Oct  4 12:27:05 xplane kernel: lost page write due to I/O error on dm-3
> Oct  4 12:27:05 xplane kernel: Aborting journal on device dm-1.
> Oct  4 12:27:05 xplane kernel: EXT3-fs (dm-1): error in ext3_new_blocks:=
=20
> Journal has aborted
> Oct  4 12:27:05 xplane kernel: EXT3-fs (dm-1): error:=20
> ext3_journal_start_sb: Detected aborted journal
> Oct  4 12:27:05 xplane kernel: EXT3-fs (dm-1): error: remounting=20
> filesystem read-only
> Oct  4 12:27:05 xplane kernel: EXT3-fs (dm-1): error:=20
> ext3_journal_start_sb: Detected aborted journal
> Oct  4 12:27:05 xplane kernel: EXT3-fs (dm-1): error in=20
> ext3_writeback_write_end: IO failure
> Oct  4 12:27:05 xplane kernel: EXT3-fs (dm-1): error in ext3_new_inode:=20
> Journal has aborted
> Oct  4 12:27:05 xplane kernel: EXT3-fs (dm-1): error in ext3_new_inode:=20
> Journal has aborted
> Oct  4 12:27:05 xplane kernel: EXT3-fs (dm-1): error in ext3_orphan_add:=
=20
> Journal has aborted
> Oct  4 12:27:05 xplane kernel: EXT3-fs (dm-1): error in ext3_new_inode:=20
> Journal has aborted
> Oct  4 12:27:05 xplane kernel: EXT3-fs (dm-1): error in ext3_new_inode:=20
> Journal has aborted
> Oct  4 12:27:05 xplane kernel: EXT3-fs (dm-1): error in=20
> ext3_dirty_inode: IO failure
> Oct  4 12:27:05 xplane kernel: RAID1 conf printout:
> Oct  4 12:27:05 xplane kernel:  --- wd:1 rd:2
> Oct  4 12:27:05 xplane kernel:  disk 0, wo:1, o:0, dev:sdh3
> Oct  4 12:27:05 xplane kernel:  disk 1, wo:0, o:1, dev:sdg3

raid1_remove_disk is called to disconnect the device from the array.


> Oct  4 12:27:05 xplane kernel: RAID1 conf printout:
> Oct  4 12:27:05 xplane kernel:  --- wd:1 rd:2
> Oct  4 12:27:05 xplane kernel:  disk 1, wo:0, o:1, dev:sdg3

which it has now done.

> Oct  4 12:27:14 xplane kernel: md: unbind<sdh3>
> Oct  4 12:27:14 xplane kernel: md: export_rdev(sdh3)
> Oct  4 12:27:24 xplane kernel: md: bind<sdh3>
> Oct  4 12:27:24 xplane kernel: RAID1 conf printout:
> Oct  4 12:27:24 xplane kernel:  --- wd:1 rd:2
> Oct  4 12:27:24 xplane kernel:  disk 0, wo:1, o:1, dev:sdh3
> Oct  4 12:27:24 xplane kernel:  disk 1, wo:0, o:1, dev:sdg3
> Oct  4 12:27:24 xplane kernel: md: recovery of RAID array md1
> Oct  4 12:27:24 xplane kernel: md: minimum _guaranteed_  speed: 10000=20
> KB/sec/disk.
> Oct  4 12:27:24 xplane kernel: md: using maximum available idle IO=20
> bandwidth (but not more than 200000 KB/sec) for recovery.
> Oct  4 12:27:24 xplane kernel: md: using 128k window, over a total of=20
> 76959296k.
> Oct  4 12:27:33 xplane kernel: md: md1: recovery done.
> Oct  4 12:27:33 xplane kernel: RAID1 conf printout:
> Oct  4 12:27:33 xplane kernel:  --- wd:2 rd:2
> Oct  4 12:27:33 xplane kernel:  disk 0, wo:0, o:1, dev:sdh3
> Oct  4 12:27:33 xplane kernel:  disk 1, wo:0, o:1, dev:sdg3
> Oct  4 12:27:35 xplane kernel: md: data-check of RAID array md1
> Oct  4 12:27:35 xplane kernel: md: minimum _guaranteed_  speed: 10000=20
> KB/sec/disk.
> Oct  4 12:27:35 xplane kernel: md: using maximum available idle IO=20
> bandwidth (but not more than 200000 KB/sec) for data-check.
> Oct  4 12:27:35 xplane kernel: md: using 128k window, over a total of=20
> 76959296k.
> Oct  4 12:29:59 xplane kernel: __journal_remove_journal_head: freeing=20
> b_committed_data
>=20
> It seems like something got out of sync as the disk was being removed,=20
> but before the remove completed.
>=20
> Again, this is 3.14.19 with these 8 patches:
>        md/raid1: intialise start_next_window for READ case to avoid hang
>        md/raid1:  be more cautious where we read-balance during resync.
>        md/raid1: clean up request counts properly in close_sync()
>        md/raid1: make sure resync waits for conflicting writes to complet=
e.
>        md/raid1: Don't use next_resync to determine how far resync has=20
> progressed
>        md/raid1: update next_resync under resync_lock.
>        md/raid1: count resync requests in nr_pending.
>        md/raid1: fix_read_error should act on all non-faulty devices.
>=20
>        and the two patches for the check start hang.
>=20
> Any ideas on what happened here?
>=20
> Thanks,
> Bill
>=20
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


--Sig_/XCWhzPt_itbay69xnkpy8QT
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBVDx/lTnsnt1WYoG5AQJa1xAAopq6Pu0ll/1I8Pj2r2Xh6xmR+RwfWfm/
cWrLa0V31N4w0GRmnPUsUScJEL65mFlt1HrfeBKnro0I8J68M6NYj05y8lFJaT0E
61AYAStbVtDAlIJfN+T5kbX5V1ih2TpwZFGNUAayh5zTKxNQ0qHzMYPEOa3UuC0X
KPrQLs/FL8ct1p9IHRuCiAFawnByRKzD8OXq07bBwl1m2B/eKAKevSrBrb7GpTeY
D3HxiN8dPKbxanLAITN7yMUCgVkSKk8PUnxYNl4EIQwp89BZ2c2/ReAz+Lh/0n5j
aZQMXUrhKJoDMfru+2Bf9/nI8XP1+Vm6O+uPcqeYWKzxJIyo3gi3LeX1UiRYnrFN
cZPNrQlZNaHH+s39llkUxwIU/qiUfmNqmJN38uG+2Uq7yhMS8fc9Z5niU2drFlGU
/HbHArBkXadpOdmT8Rc2ocAHeRe3eWSE76obnqlSNpjlq/am6ETqnGhGHfj+skdy
eWViNNPj4JaQmQ88qQ2DQ6XvGAeVvVUWFmdcVDOdylO/vltvjCSNRN1FWUDqHBaA
epXyCQ/Rcgx9KXt6b6mWBoK7rffUbK8xSvSFZDNBH+96mQ8YLdkb9+4haPY/K/Ls
rim5v+FwyRc8imebEnlCV11uaNDfXu7/gbqGn6T9dgJNamLlFYPGOO8mLI01/Pr6
SW3RLjVPaA0=
=BcuK
-----END PGP SIGNATURE-----

--Sig_/XCWhzPt_itbay69xnkpy8QT--
