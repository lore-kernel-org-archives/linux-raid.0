From: NeilBrown <neilb@suse.com>
Subject: Re: [PATCH 0/4] RFC: attempt to remove md deadlocks with metadata without
Date: Thu, 05 Oct 2017 16:17:19 +1100
Message-ID: <87vaju18dc.fsf@notabene.neil.brown.name>
References: <150518076229.32691.13542756562323866921.stgit@noble> <1403889957.10216459.1505268710452.JavaMail.zimbra@redhat.com> <1025458651.10368123.1505315351335.JavaMail.zimbra@redhat.com> <87o9qe9p3j.fsf@notabene.neil.brown.name> <446747392.10694917.1505364915884.JavaMail.zimbra@redhat.com> <871sn9alrh.fsf@notabene.neil.brown.name> <393232447.10845976.1505375841983.JavaMail.zimbra@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <393232447.10845976.1505375841983.JavaMail.zimbra@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Xiao Ni <xni@redhat.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, Sep 14 2017, Xiao Ni wrote:

>>=20
>> What do
>>  cat /proc/8987/stack
>>  cat /proc/8983/stack
>>  cat /proc/8966/stack
>>  cat /proc/8381/stack
>>=20
>> show??
>
...

>
> /usr/sbin/mdadm --grow --continue /dev/md0. Is it the reason to add lockd=
ep_assert_held(&mddev->reconfig_mutex)?
> [root@dell-pr1700-02 ~]# cat /proc/8983/stack
> [<ffffffffa0a3464c>] mddev_suspend+0x12c/0x160 [md_mod]
> [<ffffffffa0a379ec>] suspend_lo_store+0x7c/0xe0 [md_mod]
> [<ffffffffa0a3b7d0>] md_attr_store+0x80/0xc0 [md_mod]
> [<ffffffff812ec8da>] sysfs_kf_write+0x3a/0x50
> [<ffffffff812ec39f>] kernfs_fop_write+0xff/0x180
> [<ffffffff81260457>] __vfs_write+0x37/0x170
> [<ffffffff812619e2>] vfs_write+0xb2/0x1b0
> [<ffffffff81263015>] SyS_write+0x55/0xc0
> [<ffffffff810037c7>] do_syscall_64+0x67/0x150
> [<ffffffff81777527>] entry_SYSCALL64_slow_path+0x25/0x25
> [<ffffffffffffffff>] 0xffffffffffffffff
>
> [jbd2/md0-8]
> [root@dell-pr1700-02 ~]# cat /proc/8966/stack
> [<ffffffffa0a39b20>] md_write_start+0xf0/0x220 [md_mod]
> [<ffffffffa0972b49>] raid5_make_request+0x89/0x8b0 [raid456]
> [<ffffffffa0a34175>] md_make_request+0xf5/0x260 [md_mod]
> [<ffffffff81376427>] generic_make_request+0x117/0x2f0
> [<ffffffff81376675>] submit_bio+0x75/0x150
> [<ffffffff8129e0b0>] submit_bh_wbc+0x140/0x170
> [<ffffffff8129e683>] submit_bh+0x13/0x20
> [<ffffffffa0957e29>] jbd2_write_superblock+0x109/0x230 [jbd2]
> [<ffffffffa0957f8b>] jbd2_journal_update_sb_log_tail+0x3b/0x80 [jbd2]
> [<ffffffffa09517ff>] jbd2_journal_commit_transaction+0x16ef/0x19e0 [jbd2]
> [<ffffffffa0955d02>] kjournald2+0xd2/0x260 [jbd2]
> [<ffffffff810c73f9>] kthread+0x109/0x140
> [<ffffffff817776c5>] ret_from_fork+0x25/0x30
> [<ffffffffffffffff>] 0xffffffffffffffff

Thanks for this (and sorry it took so long to get to it).
It looks like

Commit: cc27b0c78c79 ("md: fix deadlock between mddev_suspend() and md_writ=
e_start()")

is badly broken.  I wonder how it ever passed testing.

In write_start() is change the wait_event() call to

	wait_event(mddev->sb_wait,
		   !test_bit(MD_SB_CHANGE_PENDING, &mddev->sb_flags) && !mddev->suspended=
);


That should be

	wait_event(mddev->sb_wait,
		   !test_bit(MD_SB_CHANGE_PENDING, &mddev->sb_flags) || mddev->suspended);

i.e. it was (!A && !B), it should be (!A || B) !!!!!

Could you please make that change and try again.

Thanks,
NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAlnVwF8ACgkQOeye3VZi
gbmoXQ//RbDuFslVJnusw++EmtDWiSxRLnaBsp/oD9u4uKMeLoerhOmiXu6/AyHO
PtbvfJtuW9W5Hl9S5UYgYfJIxu6ouePW5cgq/ADrogvf5xOCqamtfSd5PfxwUSqX
e8zy53HPh/JokGbw+8454A0t+cirSUawQxYfKDd4dZau6X49ReHPEIHplRwXP4ZY
cOse9EypKbsgUM5/kDbwX3OTxwWRrtl+P2e1mfgtStYTrKGzBenJi4Pm/V2XeUto
7DPw7POt+a/S0jvBqdS48b/zqLR10LOICLxjidDAY/WZY5i6eQrYFrfL3NpStuaN
JXZY22D95j3i5njuheMDmtMYLOSx9OIUtdbFzBCF1GtZfxNsC4c0RRRcU6pWVQ0f
MlXiH2ddyqlWGzC0Sywf0Fah+ziq470TiRTqZvKZoaCf1mCD6/7DYnN49JhCEriW
2ElIXlpZciAIcf3QnpSdoqeyaN4Ee3iuMMFxhMeBRJYtoySEjq6PVEVkJLBh859z
lX+0ae2D6Gwn3E3LZKrGERSKr8xoiGRz64B7aWGC/8/PH1KKjq2eeMmyRv0gBFDo
/F+ry1i0r9vmL9Tb6/lRTm4PrPbDM3IW//5V6Jr3D+dwMBxajVjKKXYq1R67bvXa
nQrhAugybnvtxIRorOPr8FjAKxqdHJL3Y/m9N2/96wL6eRoZqEM=
=qaGd
-----END PGP SIGNATURE-----
--=-=-=--
