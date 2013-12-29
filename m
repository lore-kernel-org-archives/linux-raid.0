From: NeilBrown <neilb@suse.de>
Subject: Re: Can raid1-resync cause a corruption?
Date: Mon, 30 Dec 2013 08:41:32 +1100
Message-ID: <20131230084132.6f8b033e@notabene.brown>
References: <CAGRgLy6qoYFW0BabE4qUT2kc61MEjpCS7x_PnxW+iCRUPzB6AA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/FLKCON8LbynwVOtPGU7esot"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAGRgLy6qoYFW0BabE4qUT2kc61MEjpCS7x_PnxW+iCRUPzB6AA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Alexander Lyakas <alex.bolshoy@gmail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>, yair@zadarastorage.com
List-Id: linux-raid.ids

--Sig_/FLKCON8LbynwVOtPGU7esot
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sun, 29 Dec 2013 13:27:35 +0200 Alexander Lyakas <alex.bolshoy@gmail.com>
wrote:

> Hi Neil,
> I see in the code, that read_balance is careful not to do
> read-balancing, if the area in question is under resync:
>     if (conf->mddev->recovery_cp < MaxSector &&
>         (this_sector + sectors >=3D conf->next_resync)) {
>         choose_first =3D 1;
>         start_disk =3D 0;
>     } else {
>         choose_first =3D 0;
>         start_disk =3D conf->last_used;
>     }
>=20
> However, I see that next_resync is updated in sync_request:
> conf->next_resync =3D sector_nr;
> before actually completing the resync of that area, before even
> submitting the read-bios. Is this correct? Should we perhaps update
> next_sync at the point where we update curr_resync_completed in
> md_do_sync?

Your analysis appears correct.  Thanks!
Can you send a patch?  If so, could you check if raid10 needs a similar fix?

Thanks,
NeilBrown



> Kernel that I am looking at is Ubuntu-Precise 3.2.0-29.46.
>=20
> Below is a sequence of event that lead us to this question.
>=20
> We have a 3-disk RADI1, with ext4 mounted on top and mysql running,
> whose files are on that ext4.
> # 3-disk RAID1 was recovering from an unclean shutdown (crash) of the
> machine, it started resync:
>=20
> Dec 26 08:05:42 vc kernel: [11576870.520393] md: md1 stopped.
> Dec 26 08:05:42 vc kernel: [11576870.526898] md: bind<dm-2>
> Dec 26 08:05:42 vc kernel: [11576870.534819] md: bind<dm-3>
> Dec 26 08:05:42 vc kernel: [11576870.535908] md: bind<dm-1>
> Dec 26 08:05:42 vc kernel: [11576870.580730] md/raid1:md1: not clean
> -- starting background reconstruction
> Dec 26 08:05:42 vc kernel: [11576870.580735] md/raid1:md1: active with
> 3 out of 3 mirrors
> Dec 26 08:05:42 vc kernel: [11576870.581399] created bitmap (1 pages)
> for device md1
> Dec 26 08:05:42 vc kernel: [11576870.582386] md1: bitmap initialized
> from disk: read 1/1 pages, set 5 of 5 bits
> Dec 26 08:05:42 vc kernel: [11576870.583335] md1: detected capacity
> change from 0 to 320773120
> Dec 26 08:05:42 vc kernel: [11576870.585593] md: resync of RAID array md1
> Dec 26 08:05:42 vc kernel: [11576870.585597] md: minimum _guaranteed_
> speed: 10000 KB/sec/disk.
> Dec 26 08:05:42 vc kernel: [11576870.585601] md: using maximum
> available idle IO bandwidth (but not more than 200000 KB/sec) for
> resync.
> Dec 26 08:05:42 vc kernel: [11576870.585617] md: using 128k window,
> over a total of 313255k.
> Dec 26 08:05:42 vc kernel: [11576870.687868]  md1: unknown partition table
>=20
> # meanwhile, ext4 was mounted on top of it (dm-4 is a devicemapper
> target on top of MD1, which collects some stats, but otherwise does
> not interfere with bios in any way). ext4 also realized the unclean
> shutdown:
> Dec 26 08:05:42 vc kernel: [11576870.936166] [14831]dm_iostat
> [dm_iostat_ctr] Successfully set up dm (252:4) iostats on top of
> /dev/md1 (9:1), flags=3D0x80
> Dec 26 08:05:43 vc kernel: [11576871.159955] [EXT4 FS bs=3D1024, gc=3D39,
> bpg=3D8192, ipg=3D2016, mo=3D9c02c818, mo2=3D0000]
> Dec 26 08:05:43 vc kernel: [11576871.160092] EXT4-fs (dm-4): recovery com=
plete
> Dec 26 08:05:43 vc kernel: [11576871.161099] EXT4-fs (dm-4): mounted
> filesystem with ordered data mode. Opts: debug,data_err=3Dabort
>=20
> # mysql was started on top of ext4, and also realized the unclean shutdow=
n:
> InnoDB: Log scan progressed past the checkpoint lsn 18148639
> 131226  8:05:44  InnoDB: Database was not shut down normally!
> InnoDB: Starting crash recovery.
> InnoDB: Reading tablespace information from the .ibd files...
> InnoDB: Restoring possible half-written data pages from the doublewrite
> InnoDB: buffer...
> InnoDB: Doing recovery: scanned up to log sequence number 18154016
> 131226  8:05:44  InnoDB: Starting an apply batch of log records to the
> database...
> InnoDB: Progress in percents: 11 12 13 14 15 16 17 18 19 20 21 22 23
> 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46
> 47 48 49 50 51 52 53 54 55 56 57 58 59 60 61 62 63 64 65 66 67 68 69
> 70 71 72 73 74 75 76 77 78 79 80 81 82 83 84 85 86 87 88 89 90 91 92
> 93 94 95 96 97 98 99
> InnoDB: Apply batch completed
> 131226  8:05:44  InnoDB: Waiting for the background threads to start
>=20
> 8 seconds later, raid1-resync completed:
> Dec 26 08:05:52 vc kernel: [11576880.161306] md: md1: resync done.
> Dec 26 08:05:52 vc kernel: [11576880.221701] RAID1 conf printout:
> Dec 26 08:05:52 vc kernel: [11576880.221705]  --- wd:3 rd:3
> Dec 26 08:05:52 vc kernel: [11576880.221709]  disk 0, wo:0, o:1, dev:dm-1
> Dec 26 08:05:52 vc kernel: [11576880.221712]  disk 1, wo:0, o:1, dev:dm-2
> Dec 26 08:05:52 vc kernel: [11576880.221714]  disk 2, wo:0, o:1, dev:dm-3
>=20
> # The system ran normally for about 5 minutes, and then was shutdown clea=
nly:
> # mysql was stopped cleanly
> 131226  8:11:28 [Note] /usr/sbin/mysqld: Normal shutdown
> 131226  8:11:28 [Note] Event Scheduler: Purging the queue. 0 events
> 131226  8:11:30 [Warning] /usr/sbin/mysqld: Forcing close of thread 68
>  user: 'change_vsa_user'
> 131226  8:11:30 [Warning] /usr/sbin/mysqld: Forcing close of thread 59
>  user: 'standbyVc0'
> 131226  8:11:30  InnoDB: Starting shutdown...
> 131226  8:11:31  InnoDB: Waiting for 3 pages to be flushed
> 131226  8:11:31  InnoDB: Shutdown completed; log sequence number 18626878
> 131226  8:11:31 [Note] /usr/sbin/mysqld: Shutdown complete
>=20
> # ext4 was cleanly unmounted (no print in the kernel for that)
> # md1 was stopped cleanly
> Dec 26 08:11:31 vc kernel: [11577219.716151] md1: detected capacity
> change from 320773120 to 0
> Dec 26 08:11:31 vc kernel: [11577219.716158] md: md1 stopped.
> Dec 26 08:11:31 vc kernel: [11577219.716167] md: unbind<dm-1>
> Dec 26 08:11:31 vc kernel: [11577219.740152] md: export_rdev(dm-1)
> Dec 26 08:11:31 vc kernel: [11577219.740174] md: unbind<dm-3>
> Dec 26 08:11:31 vc kernel: [11577219.772137] md: export_rdev(dm-3)
> Dec 26 08:11:31 vc kernel: [11577219.772158] md: unbind<dm-2>
> Dec 26 08:11:31 vc kernel: [11577219.810269] md: export_rdev(dm-2)
>=20
> # Then the system was brought up again
> # md1 was assembled with a clean bitmap
> Dec 26 08:11:40 vc kernel: [  337.918676] md: md1 stopped.
> Dec 26 08:11:40 vc kernel: [  337.923588] md: bind<dm-2>
> Dec 26 08:11:40 vc kernel: [  337.924085] md: bind<dm-3>
> Dec 26 08:11:40 vc kernel: [  337.924511] md: bind<dm-1>
> Dec 26 08:11:40 vc kernel: [  337.927127] md: raid1 personality
> registered for level 1
> Dec 26 08:11:40 vc kernel: [  337.927264] bio: create slab <bio-1> at 1
> Dec 26 08:11:40 vc kernel: [  337.927435] md/raid1:md1: active with 3
> out of 3 mirrors
> Dec 26 08:11:40 vc kernel: [  337.927826] created bitmap (1 pages) for
> device md1
> Dec 26 08:11:40 vc kernel: [  337.928341] md1: bitmap initialized from
> disk: read 1/1 pages, set 0 of 5 bits
> Dec 26 08:11:40 vc kernel: [  337.929316] md1: detected capacity
> change from 0 to 320773120
> Dec 26 08:11:40 vc kernel: [  337.934610]  md1: unknown partition table
>=20
> # ext4 was mounted cleanly
> Dec 26 08:11:40 vc kernel: [  338.036300] [6536]dm_iostat
> [dm_iostat_ctr] Successfully set up dm (252:4) iostats on top of
> /dev/md1 (9:1), flags=3D0x80
> Dec 26 08:11:40 vc kernel: [  338.063921] [EXT4 FS bs=3D1024, gc=3D39,
> bpg=3D8192, ipg=3D2016, mo=3D9c02c818, mo2=3D0000]
> Dec 26 08:11:40 vc kernel: [  338.064104] EXT4-fs (dm-4): mounted
> filesystem with ordered data mode. Opts: debug,data_err=3Dabort
>=20
> # but then mysql detected a corruption
> 131226 8:11:40 InnoDB: Error: space id and page n:o stored in the page
> InnoDB: read in are 543256175:543236195, should be 0:595!
> InnoDB: Database page corruption on disk or a failed
> InnoDB: file read of page 595.
> InnoDB: You may have to recover from a backup.
> 131226 8:11:40 InnoDB: Page dump in ascii and hex (16384 bytes):
>=20
> It happened only once, and we do a lot of testing of such unclean
> shutdowns.The only theory that we have is that raid1 resync somehow
> changed the underlying data of mysql/ext4.
>=20
> Thanks,
> Alex.


--Sig_/FLKCON8LbynwVOtPGU7esot
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBUsCXDTnsnt1WYoG5AQId2RAAuFNCFw9sV6eh9u+EaBJxSTEcg+V67EeM
9mYhwCbSLXLfQHcNOO6wmEMEGSIYfLmn3SWNweVUAf3S5nVWACqFrtJqY5ZO7RoE
8/qnDhE5fHxZ6pMXQPjdKXBlYA0RrTM0FOOCifP1JE3h71e+U6NfujWyrL0oHuuK
hAT8jtspQmU+88TyT65kiR/2BzUWWksSTaylClBggBQX5HJ9jqVzly3h4n+k9cc7
3b2qC7sovojj9LfP9VHIaGnFWevE3vCCn2a8iqYEKfPfkmRyoUFMXu4QCI2dJEMs
X55j3ZzzseaC1s6zNIYRdSsjwgip5JpXlumxDUWNtUDg36Aar6XL3hef5cu9DSAY
MMtk99RebGwUWnvCl1aAeBTQJ5GcB6cntXIso/ha5eDXNNkF8tLaW8ReWWAkEnlY
zwoAZtHzyoy3s2CJjGpXcDQPmHMAVNjvmrLKmxhFB37DnKS+eGg/VE9ERBlUw7Y+
lehLTCvoL+b5cAfM332Hzsopn7+F9ojNd4od20XrJ8cVQ1nKv0nCgMs0xJumsUtB
4Ov6/IvtY8QRVKpMxdQIIjJHJyDhmpFKWsFT3c1cYUeQzW/WhZOX7UNM/XDraOXr
XdAkaIn2oTe9KCzxbGluDR8ap3QeXsnkUWSgtfpKNJg64cVuaCHeJXKiLQ1fN/ho
GbsJHscYKm0=
=y/N9
-----END PGP SIGNATURE-----

--Sig_/FLKCON8LbynwVOtPGU7esot--
