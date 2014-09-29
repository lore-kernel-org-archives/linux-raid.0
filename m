From: NeilBrown <neilb@suse.de>
Subject: Re: Raid5 hang in 3.14.19
Date: Mon, 29 Sep 2014 14:43:56 +1000
Message-ID: <20140929144356.2c047db7@notabene.brown>
References: <5425E9D6.1050102@sbcglobal.net>
	<20140929122533.3b91a543@notabene.brown>
	<5428D863.7090409@sbcglobal.net>
	<20140929140818.1086972e@notabene.brown>
	<5428DFE1.9080600@sbcglobal.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/kGoiTNK8YMKDeoRK=CN3.Oo"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5428DFE1.9080600@sbcglobal.net>
Sender: linux-raid-owner@vger.kernel.org
To: BillStuff <billstuff2001@sbcglobal.net>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/kGoiTNK8YMKDeoRK=CN3.Oo
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sun, 28 Sep 2014 23:28:17 -0500 BillStuff <billstuff2001@sbcglobal.net>
wrote:

> On 09/28/2014 11:08 PM, NeilBrown wrote:
> > On Sun, 28 Sep 2014 22:56:19 -0500 BillStuff <billstuff2001@sbcglobal.n=
et>
> > wrote:
> >
> >> On 09/28/2014 09:25 PM, NeilBrown wrote:
> >>> On Fri, 26 Sep 2014 17:33:58 -0500 BillStuff <billstuff2001@sbcglobal=
.net>
> >>> wrote:
> >>>
> >>>> Hi Neil,
> >>>>
> >>>> I found something that looks similar to the problem described in
> >>>> "Re: seems like a deadlock in workqueue when md do a flush" from Sep=
t 14th.
> >>>>
> >>>> It's on 3.14.19 with 7 recent patches for fixing raid1 recovery hang=
s.
> >>>>
> >>>> on this array:
> >>>> md3 : active raid5 sdf1[5] sde1[4] sdd1[3] sdc1[2] sdb1[1] sda1[0]
> >>>>          104171200 blocks level 5, 64k chunk, algorithm 2 [6/6] [UUU=
UUU]
> >>>>          bitmap: 1/5 pages [4KB], 2048KB chunk
> >>>>
> >>>> I was running a test doing parallel kernel builds, read/write loops,=
 and
> >>>> disk add / remove / check loops,
> >>>> on both this array and a raid1 array.
> >>>>
> >>>> I was trying to stress test your recent raid1 fixes, which went well,
> >>>> but then after 5 days,
> >>>> the raid5 array hung up with this in dmesg:
> >>> I think this is different to the workqueue problem you mentioned, tho=
ugh as I
> >>> don't know exactly what caused either I cannot be certain.
> >>>
> >>>    From the data you provided it looks like everything is waiting on
> >>> get_active_stripe(), or on a process that is waiting on that.
> >>> That seems pretty common whenever anything goes wrong in raid5 :-(
> >>>
> >>> The md3_raid5 task is listed as blocked, but not stack trace is given.
> >>> If the machine is still in the state, then
> >>>
> >>>    cat /proc/1698/stack
> >>>
> >>> might be useful.
> >>> (echo t > /proc/sysrq-trigger is always a good idea)
> >> Might this help? I believe the array was doing a "check" when things
> >> hung up.
> > It looks like it was trying to start doing a 'check'.
> > The 'resync' thread hadn't been started yet.
> > What is 'kthreadd' doing?
> > My guess is that it is in try_to_free_pages() waiting for writeout
> > for some xfs file page onto the md array ... which won't progress until
> > the thread gets started.
> >
> > That would suggest that we need an async way to start threads...
> >
> > Thanks,
> > NeilBrown
> >
>=20
> I suspect your guess is correct:

Yes, looks like it is - thanks.

I'll probably get a workqueue to start the thread, so the md thread doesn't
block on it.

thanks,
NeilBrown


>=20
> kthreadd        D c106ea4c     0     2      0 0x00000000
>   e9d6db58 00000046 e9d6db4c c106ea4c ce493c00 00000001 1e9bb7bd 0001721a
>   c17d6700 c17d6700 d3b6a880 e9d38510 f2cf4c00 00000000 f2e51c00 e9d6db60
>   f3cec0b6 e9d38510 f2e51d14 f2e51d00 f2e51c00 00043132 00000964 0000a4b0
> Call Trace:
>   [<c106ea4c>] ? update_blocked_averages+0x1ec/0x700
>   [<f3cec0b6>] ? xlog_cil_force_lsn+0xd6/0x1c0 [xfs]
>   [<f3cc077b>] ? xfs_bmbt_get_all+0x2b/0x40 [xfs]
>   [<c153e7f3>] schedule+0x23/0x60
>   [<f3ceaa71>] _xfs_log_force_lsn+0x141/0x270 [xfs]
>   [<c1069ca0>] ? wake_up_process+0x40/0x40
>   [<f3ceabd8>] xfs_log_force_lsn+0x38/0x90 [xfs]
>   [<f3cd7ee0>] __xfs_iunpin_wait+0x80/0x100 [xfs]
>   [<f3cdb02d>] ? xfs_iunpin_wait+0x1d/0x30 [xfs]
>   [<c10799d0>] ? autoremove_wake_function+0x40/0x40
>   [<f3cdb02d>] xfs_iunpin_wait+0x1d/0x30 [xfs]
>   [<f3c99938>] xfs_reclaim_inode+0x58/0x2f0 [xfs]
>   [<f3c99e04>] xfs_reclaim_inodes_ag+0x234/0x330 [xfs]
>   [<f3c9a6a1>] ? xfs_inode_set_reclaim_tag+0x91/0x150 [xfs]
>   [<c115cc41>] ? fsnotify_clear_marks_by_inode+0x21/0xe0
>   [<f3ca5ac5>] ? xfs_fs_destroy_inode+0xa5/0xd0 [xfs]
>   [<c113b061>] ? destroy_inode+0x31/0x50
>   [<c113b160>] ? evict+0xe0/0x160
>   [<f3c9a7ad>] xfs_reclaim_inodes_nr+0x2d/0x40 [xfs]
>   [<f3ca5103>] xfs_fs_free_cached_objects+0x13/0x20 [xfs]
>   [<c11278ce>] super_cache_scan+0x12e/0x140
>   [<c10f2bb5>] shrink_slab_node+0x125/0x280
>   [<c1101a1c>] ? compact_zone+0x2c/0x450
>   [<c10f3489>] shrink_slab+0xd9/0xf0
>   [<c10f557d>] try_to_free_pages+0x25d/0x4f0
>   [<c10eb96d>] __alloc_pages_nodemask+0x52d/0x820
>   [<c103c452>] copy_process.part.47+0xd2/0x14e0
>   [<c153e254>] ? __schedule+0x224/0x7a0
>   [<c105ad80>] ? kthread_create_on_node+0x110/0x110
>   [<c105ad80>] ? kthread_create_on_node+0x110/0x110
>   [<c103da01>] do_fork+0xc1/0x320
>   [<c105ad80>] ? kthread_create_on_node+0x110/0x110
>   [<c103dc8d>] kernel_thread+0x2d/0x40
>   [<c105b542>] kthreadd+0x122/0x170
>   [<c1541837>] ret_from_kernel_thread+0x1b/0x28
>   [<c105b420>] ? kthread_create_on_cpu+0x60/0x60
>=20
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


--Sig_/kGoiTNK8YMKDeoRK=CN3.Oo
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBVCjjjDnsnt1WYoG5AQJeJw/+MC/VhV3iNusB03jBWoY0nJ6vLnrvnkTZ
pOZV8H86I+G4o4GXEAppCACm+U1y7l670f60dYREh4uplqeymvImenuJQx3EerrX
J7/U5ht2BEhm2HP0fsk04oqn6sCYhJRzMAu80RMPbXnqAqUeBqCi0x+Rt1SsDT1H
HFKWh+SIhKqMcLoLPZCi/ecUT4MNbNRDakeTxBVP+KZdMrSPhLubcInK8l5ai8Ga
Zqdi+rBs0udRXs8ok2uUF56VM/ktI8bgHyTrxy3XAG5lhG8fDPdzkRv+oqRhdn/B
sw2G78SUtfA1izRhpkHDO8xoXAICh+SLKX+H63s9yTW1CpxlmQqsWF1PuoqIimBo
GkTb+cspl/OMLfD1ZJme19tdg4TLTX2ir0hWFekyYClZJyRWvw9S9aTRF4iJBUcL
Z+R/s3Kx0SHLfN0i/mVlpB2jEcbs1/oliLl2GbtKDl8Jk1BkOFFK4G/aIK7Mri4P
TpiK9//W6oGZYtc2LZuvFVpALv0Dix2BifbXCpA0+5DU+8AXQ+QHTeWSUSjAxFtp
mSwxo3vetkpMFqWw8LK3KODGmCKjXsMPMnCEEdTK1kxPdPCkggKPT2yLLs4NJPUE
gfg/pH5SJfU7hnDI3V0DUKqVmD4L3DDt95/mmoSB0QUBsXdxtBX7oWXWpJKHSVik
wafsCzRg6jA=
=tOhp
-----END PGP SIGNATURE-----

--Sig_/kGoiTNK8YMKDeoRK=CN3.Oo--
