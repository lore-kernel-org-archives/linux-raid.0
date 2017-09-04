From: NeilBrown <neilb@suse.com>
Subject: Re: Stuck in md_write_start because MD_SB_CHANGE_PENDING can't be cleared
Date: Mon, 04 Sep 2017 15:34:57 +1000
Message-ID: <87y3pvc9ha.fsf@notabene.neil.brown.name>
References: <546311999.4473128.1504339295016.JavaMail.zimbra@redhat.com> <877exfdx7x.fsf@notabene.neil.brown.name> <22698eb3-35f7-04e5-96e8-26470d892655@redhat.com> <b5856cb8-0ea6-7bf2-10a0-76dd69d04698@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <b5856cb8-0ea6-7bf2-10a0-76dd69d04698@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Xiao Ni <xni@redhat.com>, linux-raid <linux-raid@vger.kernel.org>
Cc: shli@kernel.org
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 04 2017, Xiao Ni wrote:

> On 09/04/2017 10:45 AM, Xiao Ni wrote:
>>
>>
>> On 09/04/2017 10:16 AM, NeilBrown wrote:
>>> On Sat, Sep 02 2017, Xiao Ni wrote:
>>>
>>>> Hi Neil and Shaohua
>>>>
>>>> I'm trying to reproduce the problem the problem=20
>>>> "raid5_finish_reshape is stuck at revalidate_disk".
>>>> But there is a new stuck. I tried with 4.13.0-rc5 and latest mdadm.=20
>>>> The steps are:
>>>>
>>>> #!/bin/bash
>>>> num=3D0
>>>> while [ 1 ]
>>>> do
>>>>     echo "*************************$num"
>>>>     mdadm -Ss
>>>>     mdadm --create --run /dev/md0 --level 5 --metadata 1.2=20
>>>> --raid-devices 5 /dev/loop0 /dev/loop1 /dev/loop2 /dev/loop3=20
>>>> /dev/loop4 --spare-devices 1 /dev/loop5 --chunk 512
>>>>     mdadm --wait /dev/md0
>>>>     mkfs -t ext4 /dev/md0
>>>>     mount -t ext4 /dev/md0 /mnt/md_test
>>>>     dd if=3D/dev/urandom of=3D/mnt/md_test/testfile bs=3D1M count=3D100
>>>>     mdadm --add /dev/md0 /dev/loop6
>>>>     mdadm --grow --raid-devices 6 /dev/md0
>>>>     dd if=3D/dev/urandom of=3D/mnt/md_test/testfile bs=3D1M count=3D10=
00
>>>>     mdadm --wait /dev/md0
>>>>     ((num++))
>>>>     umount /dev/md0
>>>> done
>>>>
>>>> The calltrace messages are:
>>>> Sep  1 13:57:25 localhost kernel: INFO: task kworker/u8:4:21401=20
>>>> blocked for more than 120 seconds.
>>>> Sep  1 13:57:25 localhost kernel:      Tainted: G OE   4.13.0-rc5 #2
>>>> Sep  1 13:57:25 localhost kernel: "echo 0 >=20
>>>> /proc/sys/kernel/hung_task_timeout_secs" disables this message.
>>>> Sep  1 13:57:25 localhost kernel: kworker/u8:4    D    0 21401=20=20=
=20=20=20=20
>>>> 2 0x00000080
>>>> Sep  1 13:57:25 localhost kernel: Workqueue: writeback wb_workfn=20
>>>> (flush-9:0)
>>>> Sep  1 13:57:25 localhost kernel: Call Trace:
>>>> Sep  1 13:57:25 localhost kernel: __schedule+0x28d/0x890
>>>> Sep  1 13:57:25 localhost kernel: schedule+0x36/0x80
>>>> Sep  1 13:57:25 localhost kernel: md_write_start+0xf0/0x220 [md_mod]
>>>> Sep  1 13:57:25 localhost kernel: ? remove_wait_queue+0x60/0x60
>>>> Sep  1 13:57:25 localhost kernel: raid5_make_request+0x89/0x8b0=20
>>>> [raid456]
>>>> Sep  1 13:57:25 localhost kernel: ? bio_split+0x5d/0x90
>>>> Sep  1 13:57:25 localhost kernel: ? blk_queue_split+0xd2/0x630
>>>> Sep  1 13:57:25 localhost kernel: ? remove_wait_queue+0x60/0x60
>>>> Sep  1 13:57:25 localhost kernel: md_make_request+0xf5/0x260 [md_mod]
>>>> ....
>>>>
>>>> All the processes send bio to md are stuck at md_write_start.
>>>>          wait_event(mddev->sb_wait,
>>>>                     !test_bit(MD_SB_CHANGE_PENDING,=20
>>>> &mddev->sb_flags) && !mddev->suspended);
>>>>
>>>>
>>>> Sep  1 13:57:26 localhost kernel: INFO: task md0_reshape:23605=20
>>>> blocked for more than 120 seconds.
>>>> Sep  1 13:57:26 localhost kernel:      Tainted: G OE   4.13.0-rc5 #2
>>>> Sep  1 13:57:26 localhost kernel: "echo 0 >=20
>>>> /proc/sys/kernel/hung_task_timeout_secs" disables this message.
>>>> Sep  1 13:57:26 localhost kernel: md0_reshape     D    0 23605=20=20=
=20=20=20=20
>>>> 2 0x00000080
>>>> Sep  1 13:57:26 localhost kernel: Call Trace:
>>>> Sep  1 13:57:26 localhost kernel: __schedule+0x28d/0x890
>>>> Sep  1 13:57:26 localhost kernel: schedule+0x36/0x80
>>>> Sep  1 13:57:26 localhost kernel: raid5_sync_request+0x2cf/0x370=20
>>>> [raid456]
>>>> Sep  1 13:57:26 localhost kernel: ? remove_wait_queue+0x60/0x60
>>>> Sep  1 13:57:26 localhost kernel: md_do_sync+0xafe/0xee0 [md_mod]
>>>> Sep  1 13:57:26 localhost kernel: ? remove_wait_queue+0x60/0x60
>>>> Sep  1 13:57:26 localhost kernel: md_thread+0x132/0x180 [md_mod]
>>>> Sep  1 13:57:26 localhost kernel: kthread+0x109/0x140
>>>> Sep  1 13:57:26 localhost kernel: ? find_pers+0x70/0x70 [md_mod]
>>>> Sep  1 13:57:26 localhost kernel: ? kthread_park+0x60/0x60
>>>> Sep  1 13:57:26 localhost kernel: ? do_syscall_64+0x67/0x150
>>>> Sep  1 13:57:26 localhost kernel: ret_from_fork+0x25/0x30
>>>>
>>>> It stucks at:
>>>>          /* Allow raid5_quiesce to complete */
>>>>          wait_event(conf->wait_for_overlap, conf->quiesce !=3D 2);
>>>>
>>>> Sep  1 13:57:26 localhost kernel: INFO: task mdadm:23613 blocked for=20
>>>> more than 120 seconds.
>>>> Sep  1 13:57:26 localhost kernel:      Tainted: G OE   4.13.0-rc5 #2
>>>> Sep  1 13:57:26 localhost kernel: "echo 0 >=20
>>>> /proc/sys/kernel/hung_task_timeout_secs" disables this message.
>>>> Sep  1 13:57:26 localhost kernel: mdadm           D    0 23613=20=20=
=20=20=20=20
>>>> 1 0x00000080
>>>> Sep  1 13:57:26 localhost kernel: Call Trace:
>>>> Sep  1 13:57:26 localhost kernel: __schedule+0x28d/0x890
>>>> Sep  1 13:57:26 localhost kernel: schedule+0x36/0x80
>>>> Sep  1 13:57:26 localhost kernel: raid5_quiesce+0x274/0x2b0 [raid456]
>>>> Sep  1 13:57:26 localhost kernel: ? remove_wait_queue+0x60/0x60
>>>> Sep  1 13:57:26 localhost kernel: suspend_lo_store+0x82/0xe0 [md_mod]
>>>> Sep  1 13:57:26 localhost kernel: md_attr_store+0x80/0xc0 [md_mod]
>>>> Sep  1 13:57:26 localhost kernel: sysfs_kf_write+0x3a/0x50
>>>> Sep  1 13:57:26 localhost kernel: kernfs_fop_write+0xff/0x180
>>>> Sep  1 13:57:26 localhost kernel: __vfs_write+0x37/0x170
>>>> Sep  1 13:57:26 localhost kernel: ? selinux_file_permission+0xe5/0x120
>>>> Sep  1 13:57:26 localhost kernel: ? security_file_permission+0x3b/0xc0
>>>> Sep  1 13:57:26 localhost kernel: vfs_write+0xb2/0x1b0
>>>> Sep  1 13:57:26 localhost kernel: ? syscall_trace_enter+0x1d0/0x2b0
>>>> Sep  1 13:57:26 localhost kernel: SyS_write+0x55/0xc0
>>>> Sep  1 13:57:26 localhost kernel: do_syscall_64+0x67/0x150
>>>>
>>>> It's stuck at:
>>>> conf->quiesce =3D 2;
>>>> wait_event_cmd(conf->wait_for_quiescent,
>>>>     atomic_read(&conf->active_stripes) =3D=3D 0 &&
>>>>     atomic_read(&conf->active_aligned_reads) =3D=3D 0,
>>>>     unlock_all_device_hash_locks_irq(conf),
>>>>     lock_all_device_hash_locks_irq(conf));
>>>> conf->quiesce =3D 1;
>>>>
>>>> [root@dell-pr1700-02 ~]# cat /proc/mdstat
>>>> Personalities : [raid6] [raid5] [raid4]
>>>> md0 : active raid5 loop6[7] loop4[6] loop5[5](S) loop3[3] loop2[2]=20
>>>> loop1[1] loop0[0]
>>>>        2039808 blocks super 1.2 level 5, 512k chunk, algorithm 2=20
>>>> [6/6] [UUUUUU]
>>>>        [>....................]  reshape =3D  0.5% (2560/509952)=20
>>>> finish=3D162985.0min speed=3D0K/sec
>>>>        unused devices: <none>
>>>>
>>>>
>>>> I can reproduce this. So I add some logs by printk to check=20
>>>> MD_SB_CHANGE_PENDING of mddev->flags
>>>> and mddev->suspended.
>>>> mddev->suspend : 0
>>>> mddev->flags   : SP CHANGE PENDING is set
>>>> conf->quiesce  : 2
>>>>
>>>> The I echo active > /sys/block/md0/md/array_state, reshape can start=20
>>>> and finish successfully.
>>>>
>>>> I notice there are some fixes for raid5 stuck problem. Not sure=20
>>>> whether it's introduced by those
>>>> patches.
>>>>
>>>> Best Regards
>>>> Xiao
>>> Thanks for the detailed report.
>>> All the processes that you have mentioned are waiting for
>>> raid5_quiesce() to complete.
>>> raid5_quiesce() must be waiting for either active_stripes or
>>> active_aligned_reads to reach zero.  Most likely active_stripes.
>>>
>>> That suggests that either there is a stripe that is active and isn't
>>> being handled for some reason, or the accounting of active stripes has
>>> problems.
>>>
>>> The fact that setting the array to 'active' removes the hang is
>>> interesting.  That would cause the threads blocked in md_write_start to
>>> continue, but I cannot see how that would affect active_stripes as
>>> threads waiting for md_write_start() never hold a stripe.  Doing that
>>> could cause a stripe to be used, then released, which might trigger a
>>> wakeup that had been lost.
>> At first I doubt there are some active strips that haven't been=20
>> handled yet.
>> But the process raid5d doesn't appear in calltrace. It wasn't stuck.
>>>
>>> It would be useful to see if ->active_stripes is 0 when the deadlock
>>> happens.
>>> One way to do that is to add a printk into raid5_status().  Then
>>> whenever you "cat /proc/mdstat" the printk will trigger and tell you the
>>> value of ->active_stripes.
>>>
>>> I haven't managed to reproduce this yet, or I would track it down my
>>> self.
>>
>> Sure the testing is running again. I'll give the information later.
>
> Hi Neil
>
> I have reproduced this.
>
> [root@dell-pr1700-02 ~]# cat /proc/mdstat
> Personalities : [raid6] [raid5] [raid4]
> md0 : active raid5 loop6[7] loop4[6] loop5[5](S) loop3[3] loop2[2]=20
> loop1[1] loop0[0]
>        2039808 blocks super 1.2 level 5, 512k chunk, algorithm 2 [6/6]=20
> [UUUUUU]
>        [>....................]  reshape =3D  0.5% (2560/509952)=20
> finish=3D2498.2min speed=3D3K/sec
>
> unused devices: <none>
> [root@dell-pr1700-02 ~]# dmesg
> [ 3072.826251] suspend : 0
> [ 3072.828683] SP CHANGE PENDING is set
> [ 3072.832243] conf quiesce 2
> [ 3072.834932] active stripes : 251
> [ 3072.838139] active aligned reads : 0
>
> [root@dell-pr1700-02 ~]# ps auxf | grep md
> ...
> root      1682  0.0  0.0      0     0 ?        S<   23:02   0:00 \_ [md]
> root      3103 97.2  0.0      0     0 ?        R    23:34  14:06  \_=20
> [md0_raid5]
> root      3123  0.0  0.0      0     0 ?        D    23:34   0:00  \_=20
> [jbd2/md0-8]
> root      3134  0.0  0.0      0     0 ?        D    23:34   0:00  \_=20
> [md0_reshape]
> ....
> root      3142  0.5  0.0 108996  2728 pts/1    D+   23:34   0:04=20
> |           \_ dd if=3D/dev/urandom of=3D/mnt/md_test/testfile bs=3D1M co=
unt=3D1000
> root      3223  0.0  0.0 112672  2300 pts/0    S+   23:48 0:00=20=20=20=
=20=20=20=20=20=20=20
> \_ grep --color=3Dauto md
> root      3141  0.0  0.0  10132  5288 ?        DLs  23:34   0:00=20
> /usr/sbin/mdadm --grow --continue /dev/md0
>
> It's strange, raid5d is running but it don't handle active stripes.
> Do you need more information?

It would help a lot to know waht md0_raid5 is doing.  It appears to be
spinning and that is presumably the cause of the problem.

You could try

  echo file raid5.c +p > /sys/kernel/debug/dynamic_debug/control

or see if /proc/3103/stack contains anything useful.

Maybe perf could be used to see where it is spending its time.

NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAlms5gYACgkQOeye3VZi
gbnyBBAAp0A8ERTrytPg9yQKgy++Vdp77GlflXmoGFxiEYwrfckcCdWrZxK+5UI1
hynHf0kYov8imuJai2WQgnUymdqlvZi2opaTeZVaqsmXrJx8nGfJT/suftzDdowK
sdEekur7xfKiK3carO1ItwI4sF3IGlQQrZASDv4dfRM5ZkVCyENJlhLXBOsfSNLt
rMnpjSzUlH9oOI119y1tqcfN1pm+5EeX7vQ/NT/mdSM56UZJ8L6fClSjgtMSkMRS
jcLfL7GnT1rH9zpFZGrNKx9cWqlDSuV+2ehIN+8wytbOORYXav5qAK4LsKZgO1xw
z4VYPdzR27HroD22/vqZA6dt/wFfn2dtbXD5KS4bRC2KIF4Qhm4sLQnD6tHBmyAX
+9I0Edb5npDwu2ivdU4JS3rRJ6r7pf1r1fbV9EdNeio8ARQ0tyA/8RVYHOjmcstT
0FXtNiSRgv2GM1bfx9na9+8gTShUTLny7/NEV3XI06kH+4H5ZuBU6EV+IyGsgDcw
Rg3zB5RUsyU8TF6IpDOH7dqZmuWpVZZNs7f7Bun4ZmMQajgGCNXwdUoFlQD5f/WU
pSl8QV4Ru+rKxnFxygblrXSUUSYa4JDKNP2GbY3NkCLXZpQH5amlUJKjhG1bfXfB
WTuFl1UBo87OhcglekKPb/YoGgZEDw/MYtNkX0yWQoNChb86EDY=
=aK7n
-----END PGP SIGNATURE-----
--=-=-=--
