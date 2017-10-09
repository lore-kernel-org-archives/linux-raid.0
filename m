From: NeilBrown <neilb@suse.com>
Subject: Re: [PATCH 0/4] RFC: attempt to remove md deadlocks with metadata without
Date: Mon, 09 Oct 2017 15:57:43 +1100
Message-ID: <87a810zznc.fsf@notabene.neil.brown.name>
References: <150518076229.32691.13542756562323866921.stgit@noble> <87o9qe9p3j.fsf@notabene.neil.brown.name> <446747392.10694917.1505364915884.JavaMail.zimbra@redhat.com> <871sn9alrh.fsf@notabene.neil.brown.name> <393232447.10845976.1505375841983.JavaMail.zimbra@redhat.com> <87vaju18dc.fsf@notabene.neil.brown.name> <c0e9b424-05d2-df6e-71ce-240a8141a2fd@redhat.com> <874lrc28x8.fsf@notabene.neil.brown.name> <1345780738.18087591.1507512089744.JavaMail.zimbra@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1345780738.18087591.1507512089744.JavaMail.zimbra@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Xiao Ni <xni@redhat.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sun, Oct 08 2017, Xiao Ni wrote:

> ----- Original Message -----
>> From: "NeilBrown" <neilb@suse.com>
>> To: "Xiao Ni" <xni@redhat.com>
>> Cc: linux-raid@vger.kernel.org
>> Sent: Friday, October 6, 2017 12:32:19 PM
>> Subject: Re: [PATCH 0/4] RFC: attempt to remove md deadlocks with metada=
ta without
>>=20
>> On Fri, Oct 06 2017, Xiao Ni wrote:
>>=20
>> > On 10/05/2017 01:17 PM, NeilBrown wrote:
>> >> On Thu, Sep 14 2017, Xiao Ni wrote:
>> >>
>> >>>> What do
>> >>>>   cat /proc/8987/stack
>> >>>>   cat /proc/8983/stack
>> >>>>   cat /proc/8966/stack
>> >>>>   cat /proc/8381/stack
>> >>>>
>> >>>> show??
>> >> ...
>> >>
>> >>> /usr/sbin/mdadm --grow --continue /dev/md0. Is it the reason to add
>> >>> lockdep_assert_held(&mddev->reconfig_mutex)?
>> >>> [root@dell-pr1700-02 ~]# cat /proc/8983/stack
>> >>> [<ffffffffa0a3464c>] mddev_suspend+0x12c/0x160 [md_mod]
>> >>> [<ffffffffa0a379ec>] suspend_lo_store+0x7c/0xe0 [md_mod]
>> >>> [<ffffffffa0a3b7d0>] md_attr_store+0x80/0xc0 [md_mod]
>> >>> [<ffffffff812ec8da>] sysfs_kf_write+0x3a/0x50
>> >>> [<ffffffff812ec39f>] kernfs_fop_write+0xff/0x180
>> >>> [<ffffffff81260457>] __vfs_write+0x37/0x170
>> >>> [<ffffffff812619e2>] vfs_write+0xb2/0x1b0
>> >>> [<ffffffff81263015>] SyS_write+0x55/0xc0
>> >>> [<ffffffff810037c7>] do_syscall_64+0x67/0x150
>> >>> [<ffffffff81777527>] entry_SYSCALL64_slow_path+0x25/0x25
>> >>> [<ffffffffffffffff>] 0xffffffffffffffff
>> >>>
>> >>> [jbd2/md0-8]
>> >>> [root@dell-pr1700-02 ~]# cat /proc/8966/stack
>> >>> [<ffffffffa0a39b20>] md_write_start+0xf0/0x220 [md_mod]
>> >>> [<ffffffffa0972b49>] raid5_make_request+0x89/0x8b0 [raid456]
>> >>> [<ffffffffa0a34175>] md_make_request+0xf5/0x260 [md_mod]
>> >>> [<ffffffff81376427>] generic_make_request+0x117/0x2f0
>> >>> [<ffffffff81376675>] submit_bio+0x75/0x150
>> >>> [<ffffffff8129e0b0>] submit_bh_wbc+0x140/0x170
>> >>> [<ffffffff8129e683>] submit_bh+0x13/0x20
>> >>> [<ffffffffa0957e29>] jbd2_write_superblock+0x109/0x230 [jbd2]
>> >>> [<ffffffffa0957f8b>] jbd2_journal_update_sb_log_tail+0x3b/0x80 [jbd2]
>> >>> [<ffffffffa09517ff>] jbd2_journal_commit_transaction+0x16ef/0x19e0 [=
jbd2]
>> >>> [<ffffffffa0955d02>] kjournald2+0xd2/0x260 [jbd2]
>> >>> [<ffffffff810c73f9>] kthread+0x109/0x140
>> >>> [<ffffffff817776c5>] ret_from_fork+0x25/0x30
>> >>> [<ffffffffffffffff>] 0xffffffffffffffff
>> >> Thanks for this (and sorry it took so long to get to it).
>> >> It looks like
>> >>
>> >> Commit: cc27b0c78c79 ("md: fix deadlock between mddev_suspend() and
>> >> md_write_start()")
>> >>
>> >> is badly broken.  I wonder how it ever passed testing.
>> >>
>> >> In write_start() is change the wait_event() call to
>> >>
>> >> 	wait_event(mddev->sb_wait,
>> >> 		   !test_bit(MD_SB_CHANGE_PENDING, &mddev->sb_flags) &&
>> >> 		   !mddev->suspended);
>> >>
>> >>
>> >> That should be
>> >>
>> >> 	wait_event(mddev->sb_wait,
>> >> 		   !test_bit(MD_SB_CHANGE_PENDING, &mddev->sb_flags) ||
>> >> 		   mddev->suspended);
>> > Hi Neil
>> >
>> > Do we want write bio can be handled when mddev->suspended is 1? After
>> > changing to this,
>> > write bio can be handled when mddev->suspended is 1.
>>=20
>> This is OK.
>> New write bios will not get past md_handle_request().
>> A write bios that did get past md_handle_request() is still allowed
>> through md_write_start().  The mddev_suspend() call won't complete until
>> that write bio has finished.
>
> Hi Neil
>
> Thanks for the explanation. I took some time to read the emails about the
> patch cc27b0c78 which introduced this. It's similar with this problem I=20
> countered. But there is a call of function mddev_suspend in level_store.=
=20
> So add the check of mddev->suspended in md_write_start can fix the problem
> "reshape raid5 -> raid6 atop bcache deadlocks at start on md_attr_store /=
=20
> raid5_make_request".=20
>
> In function suspend_lo_store it doesn't call mddev_suspend under mddev->r=
econfig_mutex.

It would if you had applied
   [PATCH 3/4] md: use mddev_suspend/resume instead of ->quiesce()

Did you apply all 4 patches?

> So there is still a race possibility as you said at first analysis.=20
>>=20
>> >
>> > When the stuck happens, mddev->suspended is 0 and MD_SB_CHANGE_PENDING
>> > is set. So
>> > the patch can't fix this problem. I tried the patch, the problem still
>> > exists.
>> >
>>=20
>>=20
>> I need to see all the stack traces.
>
> I've added the calltrace as a attachment.

Thanks.  I looks suspend_lo_store() is calling raid5_quiesce() directly
as you say - so a patch is missing.

>
>>=20
>>=20
>> > [ 7710.589274] mddev suspend : 0
>> > [ 7710.592228] mddev ro : 0
>> > [ 7710.594746] mddev insync : 0
>> > [ 7710.597620] mddev SB CHANGE PENDING is set
>> > [ 7710.601698] mddev SB CHANGE CLEAN is set
>> > [ 7710.605601] mddev->persistent : 1
>> > [ 7710.608905] mddev->external : 0
>> > [ 7710.612030] conf quiesce : 2
>> >
>> > raid5 is still spinning.
>> >
>> > Hmm, I have a question. Why can't call md_check_recovery when
>> > MD_SB_CHANGE_PENDING
>> > is set in raid5d?
>>=20
>> When MD_SB_CHANGE_PENDING is not set, there is no need to call
>> md_check_recovery().  I wouldn't hurt except that it would be a waste of
>> time.
>
> I'm confused. If we want to call md_check_recovery when MD_SB_CHANGE_PEND=
ING
> is set, it should be

Sorry, I described the condition wrongly.
If any bit is set in ->sb_flags (except MD_SB_CHANGE_PENDING), then
we need to call md_check_recovery().  If none of those other bits
are set, there is no need.

NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAlnbAccACgkQOeye3VZi
gbkkyg/+MdsLWGsxNK8SMtDNAf2SpHV6VnnGpLU3WenDigUIZve/5jcuEiP3B+gT
6ChufreRNk3N6pQuQwxGs7NgNy4+CtBGb+nn2askjPL/C/lHqC8Q/Einb8Q6cpAH
zzWxDLHE9Yef6Td3Ey2cHyEIfXr+w0BQyw8ojMBKFEBgXyAhhgxsLT7H/qZDq3eT
3vcRXLmNXKyIyXbW7AQjXsRBFKPJQPGsM2TTSfiJQ0q7aPf4y04P849XUcE9kYaU
oUqhtnmWKrD+v2VWlXcPBuP9jHU1uvPsazbHHDUNUhScYRPeV8vLg6v3n2G7rR0j
JE0WY8Bep4/O3AU/lo7zVzZSPYi0yu20hYKCi0PTpMG3repAQKUBcaZYH1Ev3ySR
3M6ZEaRMEVy51o3xKmy/hYc83i4tX+Fx5HXTBL3p024PJtIDAbZ8jNb646FjvRZK
fCzrzoEeM5gU1Yi2/WAp4EaAmXtYv2ctI+IrD2kONYoG76w4fJ0TFiR1XHLeyWUB
1ZsjY7d/jTlwJNj7GsjNssA9pyeHalzbPkhwV2K5Kil9WXNigTPkJxKfyjeXvimT
E40YxmGQ8WowLV4SHvXYiqvweW16a9ejo2jtWkohcOTf5vE7JagpVL780HUITTUs
urVkaiL6m874QISaWA4SACIEP7cqGrXVnqDk707N0YDjMBSQG2Q=
=QUkW
-----END PGP SIGNATURE-----
--=-=-=--
