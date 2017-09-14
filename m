From: Xiao Ni <xni@redhat.com>
Subject: Re: [PATCH 0/4] RFC: attempt to remove md deadlocks with metadata
 without
Date: Thu, 14 Sep 2017 03:57:21 -0400 (EDT)
Message-ID: <393232447.10845976.1505375841983.JavaMail.zimbra@redhat.com>
References: <150518076229.32691.13542756562323866921.stgit@noble> <1403889957.10216459.1505268710452.JavaMail.zimbra@redhat.com> <1025458651.10368123.1505315351335.JavaMail.zimbra@redhat.com> <87o9qe9p3j.fsf@notabene.neil.brown.name> <446747392.10694917.1505364915884.JavaMail.zimbra@redhat.com> <871sn9alrh.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <871sn9alrh.fsf@notabene.neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



----- Original Message -----
> From: "NeilBrown" <neilb@suse.com>
> To: "Xiao Ni" <xni@redhat.com>
> Cc: linux-raid@vger.kernel.org
> Sent: Thursday, September 14, 2017 1:32:02 PM
> Subject: Re: [PATCH 0/4] RFC: attempt to remove md deadlocks with metadata without
> 
> On Thu, Sep 14 2017, Xiao Ni wrote:
> 
> > ----- Original Message -----
> >> From: "NeilBrown" <neilb@suse.com>
> >> To: "Xiao Ni" <xni@redhat.com>
> >> Cc: linux-raid@vger.kernel.org
> >> Sent: Thursday, September 14, 2017 7:05:20 AM
> >> Subject: Re: [PATCH 0/4] RFC: attempt to remove md deadlocks with metadata
> >> without
> >> 
> >> On Wed, Sep 13 2017, Xiao Ni wrote:
> >> >
> >> > Hi Neil
> >> >
> >> > Sorry for the bad news. The test is still running and it's stuck again.
> >> 
> >> Any details?  Anything at all?  Just a little hint maybe?
> >> 
> >> Just saying "it's stuck again" is very nearly useless.
> >> 
> > Hi Neil
> >
> > It doesn't show any useful information in /var/log/messages
> >
> > echo file raid5.c +p > /sys/kernel/debug/dynamic_debug/control
> > There aren't any messages too.
> >
> > It looks like another problem.
> >
> > [root@dell-pr1700-02 ~]# ps auxf | grep D
> > USER       PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
> > root      8381  0.0  0.0      0     0 ?        D    Sep13   0:00  \_
> > [kworker/u8:1]
> > root      8966  0.0  0.0      0     0 ?        D    Sep13   0:00  \_
> > [jbd2/md0-8]
> > root       824  0.0  0.1 216856  8492 ?        Ss   Sep03   0:06
> > /usr/bin/abrt-watch-log -F BUG: WARNING: at WARNING: CPU: INFO: possible
> > recursive locking detected ernel BUG at list_del corruption list_add
> > corruption do_IRQ: stack overflow: ear stack overflow (cur: eneral
> > protection fault nable to handle kernel ouble fault: RTNL: assertion
> > failed eek! page_mapcount(page) went negative! adness at NETDEV WATCHDOG
> > ysctl table check failed : nobody cared IRQ handler type mismatch Machine
> > Check Exception: Machine check events logged divide error: bounds:
> > coprocessor segment overrun: invalid TSS: segment not present: invalid
> > opcode: alignment check: stack segment: fpu exception: simd exception:
> > iret exception: /var/log/messages -- /usr/bin/abrt-dump-oops -xtD
> > root       836  0.0  0.0 195052  3200 ?        Ssl  Sep03   0:00
> > /usr/sbin/gssproxy -D
> > root      1225  0.0  0.0 106008  7436 ?        Ss   Sep03   0:00
> > /usr/sbin/sshd -D
> > root     12411  0.0  0.0 112672  2264 pts/0    S+   00:50   0:00
> > \_ grep --color=auto D
> > root      8987  0.0  0.0 109000  2728 pts/2    D+   Sep13   0:04
> > \_ dd if=/dev/urandom of=/mnt/md_test/testfile bs=1M count=1000
> > root      8983  0.0  0.0   7116  2080 ?        Ds   Sep13   0:00
> > /usr/sbin/mdadm --grow --continue /dev/md0
> >
> > [root@dell-pr1700-02 ~]# cat /proc/mdstat
> > Personalities : [raid6] [raid5] [raid4]
> > md0 : active raid5 loop6[7] loop4[6] loop5[5](S) loop3[3] loop2[2] loop1[1]
> > loop0[0]
> >       2039808 blocks super 1.2 level 5, 512k chunk, algorithm 2 [6/6]
> >       [UUUUUU]
> >       [>....................]  reshape =  0.0% (1/509952) finish=1059.5min
> >       speed=7K/sec
> >       
> > unused devices: <none>
> >
> >
> > It looks like the reshape doesn't start. This time I didn't add the codes
> > to check
> > the information of mddev->suspended and active_stripes. I just added the
> > patches
> > to source codes. Do you have other suggestions to check more things?
> >
> > Best Regards
> > Xiao
> 
> What do
>  cat /proc/8987/stack
>  cat /proc/8983/stack
>  cat /proc/8966/stack
>  cat /proc/8381/stack
> 
> show??

dd if=/dev/urandom of=/mnt/md_test/testfile bs=1M count=1000

[root@dell-pr1700-02 ~]# cat /proc/8987/stack
[<ffffffff810d4ea6>] io_schedule+0x16/0x40
[<ffffffff811c66ae>] __lock_page+0x10e/0x160
[<ffffffffa09b4ef0>] mpage_prepare_extent_to_map+0x290/0x310 [ext4]
[<ffffffffa09ba007>] ext4_writepages+0x467/0xe80 [ext4]
[<ffffffff811d6bec>] do_writepages+0x1c/0x70
[<ffffffff811c7c66>] __filemap_fdatawrite_range+0xc6/0x100
[<ffffffff811c7d6c>] filemap_flush+0x1c/0x20
[<ffffffffa09b757c>] ext4_alloc_da_blocks+0x2c/0x70 [ext4]
[<ffffffffa09a89a9>] ext4_release_file+0x79/0xc0 [ext4]
[<ffffffff81263d67>] __fput+0xe7/0x210
[<ffffffff81263ece>] ____fput+0xe/0x10
[<ffffffff810c59c3>] task_work_run+0x83/0xb0
[<ffffffff81003d64>] exit_to_usermode_loop+0x6c/0xa8
[<ffffffff8100389a>] do_syscall_64+0x13a/0x150
[<ffffffff81777527>] entry_SYSCALL64_slow_path+0x25/0x25
[<ffffffffffffffff>] 0xffffffffffffffff

/usr/sbin/mdadm --grow --continue /dev/md0. Is it the reason to add lockdep_assert_held(&mddev->reconfig_mutex)?
[root@dell-pr1700-02 ~]# cat /proc/8983/stack
[<ffffffffa0a3464c>] mddev_suspend+0x12c/0x160 [md_mod]
[<ffffffffa0a379ec>] suspend_lo_store+0x7c/0xe0 [md_mod]
[<ffffffffa0a3b7d0>] md_attr_store+0x80/0xc0 [md_mod]
[<ffffffff812ec8da>] sysfs_kf_write+0x3a/0x50
[<ffffffff812ec39f>] kernfs_fop_write+0xff/0x180
[<ffffffff81260457>] __vfs_write+0x37/0x170
[<ffffffff812619e2>] vfs_write+0xb2/0x1b0
[<ffffffff81263015>] SyS_write+0x55/0xc0
[<ffffffff810037c7>] do_syscall_64+0x67/0x150
[<ffffffff81777527>] entry_SYSCALL64_slow_path+0x25/0x25
[<ffffffffffffffff>] 0xffffffffffffffff

[jbd2/md0-8]
[root@dell-pr1700-02 ~]# cat /proc/8966/stack
[<ffffffffa0a39b20>] md_write_start+0xf0/0x220 [md_mod]
[<ffffffffa0972b49>] raid5_make_request+0x89/0x8b0 [raid456]
[<ffffffffa0a34175>] md_make_request+0xf5/0x260 [md_mod]
[<ffffffff81376427>] generic_make_request+0x117/0x2f0
[<ffffffff81376675>] submit_bio+0x75/0x150
[<ffffffff8129e0b0>] submit_bh_wbc+0x140/0x170
[<ffffffff8129e683>] submit_bh+0x13/0x20
[<ffffffffa0957e29>] jbd2_write_superblock+0x109/0x230 [jbd2]
[<ffffffffa0957f8b>] jbd2_journal_update_sb_log_tail+0x3b/0x80 [jbd2]
[<ffffffffa09517ff>] jbd2_journal_commit_transaction+0x16ef/0x19e0 [jbd2]
[<ffffffffa0955d02>] kjournald2+0xd2/0x260 [jbd2]
[<ffffffff810c73f9>] kthread+0x109/0x140
[<ffffffff817776c5>] ret_from_fork+0x25/0x30
[<ffffffffffffffff>] 0xffffffffffffffff

[kworker/u8:1]
[root@dell-pr1700-02 ~]# cat /proc/8381/stack
[<ffffffffa0a34131>] md_make_request+0xb1/0x260 [md_mod]
[<ffffffff81376427>] generic_make_request+0x117/0x2f0
[<ffffffff81376675>] submit_bio+0x75/0x150
[<ffffffffa09d421c>] ext4_io_submit+0x4c/0x60 [ext4]
[<ffffffffa09d43f4>] ext4_bio_write_page+0x1a4/0x3b0 [ext4]
[<ffffffffa09b44f7>] mpage_submit_page+0x57/0x70 [ext4]
[<ffffffffa09b4778>] mpage_map_and_submit_buffers+0x168/0x290 [ext4]
[<ffffffffa09ba3f2>] ext4_writepages+0x852/0xe80 [ext4]
[<ffffffff811d6bec>] do_writepages+0x1c/0x70
[<ffffffff81293895>] __writeback_single_inode+0x45/0x320
[<ffffffff812940c0>] writeback_sb_inodes+0x280/0x570
[<ffffffff8129443c>] __writeback_inodes_wb+0x8c/0xc0
[<ffffffff812946e6>] wb_writeback+0x276/0x310
[<ffffffff81294f9c>] wb_workfn+0x19c/0x3b0
[<ffffffff810c0ff9>] process_one_work+0x149/0x360
[<ffffffff810c177d>] worker_thread+0x4d/0x3c0
[<ffffffff810c73f9>] kthread+0x109/0x140
[<ffffffff817776c5>] ret_from_fork+0x25/0x30
[<ffffffffffffffff>] 0xffffffffffffffff

If they can't give useful hints, I can try to print more information and do test again.

Best Regards
Xiao
> 
> NeilBrown
> 
