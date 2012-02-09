From: Dag Nygren <dag@newtech.fi>
Subject: Re: Hang in Raid-5 code (Old bug back?)
Date: Thu, 09 Feb 2012 04:55:11 +0200
Message-ID: <8881584.REWxvMC81A@eseries>
References: <1363014.L0fQ1kFyFY@eseries>
Reply-To: Dag Nygren <dag@newtech.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1363014.L0fQ1kFyFY@eseries>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

s=C3=B6ndag 05 februari 2012 18:55:58 skrev  Dag Nygren:
> Hi!
>=20
> Using lessfs on top of an XFS on top on a software RAID-5 and see thi=
s
> freeze happening about once a week. Usually during heavy load.

No comments on the stuff below? Nobody else?
Increased the stripe_cache_size to 4096 according to the workaround for=
 ths=20
old similiar bug. Is the bug back in the recent kernels?

Has not seen any freezes since that workaround but oth they weren't tha=
t=20
frequent earlier either.


> Feb 5 02:51:04 mythserv kernel: INFO: task lessfs:2687 blocked for mo=
re than
> 120 seconds.
> Feb 5 02:51:04 mythserv kernel: =E2=80=9Cecho 0 >
> /proc/sys/kernel/hung_task_timeout_secs=E2=80=9D disables this messag=
e.
> Feb 5 02:51:04 mythserv kernel: lessfs D ffff88006faf1998 0 2687 1
> 0=C3=9700000000 Feb 5 02:51:04 mythserv kernel: ffff880066579828
> 0000000000000086 ffff8800665797b8 ffffffff00000000
> Feb 5 02:51:04 mythserv kernel: ffff88006faf1620 0000000000013300
> ffff880066579fd8 ffff880066578010
> Feb 5 02:51:04 mythserv kernel: ffff880066579fd8 0000000000013300
> ffffffff81655020 ffff88006faf1620
> Feb 5 02:51:04 mythserv kernel: Call Trace:
> Feb 5 02:51:04 mythserv kernel: [] schedule+0x3f/0=C3=9760
> Feb 5 02:51:04 mythserv kernel: [] get_active_stripe+0x2ea/0=C3=97790=
 [raid456]
> Feb 5 02:51:04 mythserv kernel: [] ? try_to_wake_up+0x2b0/0x2b0
> Feb 5 02:51:04 mythserv kernel: [] make_request+0x1ae/0=C3=97460 [rai=
d456]
> Feb 5 02:51:04 mythserv kernel: [] ? wake_up_bit+0=C3=9740/0=C3=9740
> Feb 5 02:51:04 mythserv kernel: [] md_make_request+0xd5/0=C3=97200
> Feb 5 02:51:04 mythserv kernel: [] generic_make_request+0xbf/0xf0
> Feb 5 02:51:04 mythserv kernel: [] submit_bio+0=C3=9785/0=C3=97110
> Feb 5 02:51:04 mythserv kernel: [] ? __bio_add_page+0=C3=97110/0=C3=97=
250
> Feb 5 02:51:04 mythserv kernel: [] xfs_submit_ioend_bio+0=C3=9757/0=C3=
=9780 [xfs]
> Feb 5 02:51:04 mythserv kernel: [] xfs_submit_ioend+0xf6/0=C3=97110 [=
xfs]
> Feb 5 02:51:04 mythserv kernel: [] xfs_vm_writepage+0=C3=97230/0=C3=97=
500 [xfs]
> Feb 5 02:51:04 mythserv kernel: [] __writepage+0=C3=9717/0=C3=9740
> Feb 5 02:51:04 mythserv kernel: [] write_cache_pages+0=C3=97221/0x4a0
> Feb 5 02:51:04 mythserv kernel: [] ? tomoyo_init_request_info+0x3f/0=C3=
=9770
> Feb 5 02:51:04 mythserv kernel: [] ? set_page_dirty+0=C3=9770/0=C3=97=
70
> Feb 5 02:51:04 mythserv kernel: [] generic_writepages+0=C3=9751/0=C3=97=
80
> Feb 5 02:51:04 mythserv kernel: [] xfs_vm_writepages+0=C3=9753/0=C3=97=
70 [xfs]
> Feb 5 02:51:04 mythserv kernel: [] do_writepages+0=C3=9721/0=C3=9740
> Feb 5 02:51:04 mythserv kernel: [] __filemap_fdatawrite_range+0x5b/0=C3=
=9760
> Feb 5 02:51:04 mythserv kernel: [] filemap_write_and_wait_range+0x5a/=
0=C3=9780
> Feb 5 02:51:04 mythserv kernel: [] xfs_file_fsync+0=C3=9768/0x2d0 [xf=
s]
> Feb 5 02:51:04 mythserv kernel: [] vfs_fsync_range+0x2b/0=C3=9740
> Feb 5 02:51:04 mythserv kernel: [] vfs_fsync+0x1c/0=C3=9720
> Feb 5 02:51:04 mythserv kernel: [] do_fsync+0x3a/0=C3=9760
> Feb 5 02:51:04 mythserv kernel: [] sys_fsync+0=C3=9710/0=C3=9720
> Feb 5 02:51:04 mythserv kernel: [] system_call_fastpath+0=C3=9716/0x1=
b
>=20
> Any hints? Or any debugging I can do to help? I did find a similar ca=
s from
> 2008, but that is supposed to be fixed now.
> This also started after updating the kernel to the 3.x series. At the=
 moment
> using 3.2.2 and still seeing it.
--=20
Dag Nygren                               email: dag@newtech.fi
Oy Espoon NewTech Ab                     phone: +358 9 8024910
Tr=C3=A4sktorpet 3                              fax: +358 9 8024916
02360 ESBO                              Mobile: +358 400 426312
=46INLAND

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
