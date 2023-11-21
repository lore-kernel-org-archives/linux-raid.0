Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="CuT5JbtR"
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C94A18C
	for <linux-raid@vger.kernel.org>; Tue, 21 Nov 2023 09:54:27 -0800 (PST)
Received: by mail-pl1-x636.google.com with SMTP id d9443c01a7336-1ce95f96edcso23792505ad.0
        for <linux-raid@vger.kernel.org>; Tue, 21 Nov 2023 09:54:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1700589267; x=1701194067; darn=vger.kernel.org;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=thdh2sfxNMBf43X895xu9+OZ5IErUemLPJj69gUCBiw=;
        b=CuT5JbtRGH9PZIY6xiXeANxhrMQRSHNR6p2+sYKBxQcafsMLBy8ATfWowKjr7GYlsM
         SwBfe613sARTW0xQmyzVwR059Ie/YF0mMcFjS5dQm5qtqYDktHx9xQLAWMId96x0ij2u
         aReswzYUfCh0HQwz1B5fVqGLMOXIIPWyuLKuRo7p8veXd+avYjKPc9tKOfSYcXcw+MLr
         Bom7t5lmdTZr2R4BVXu83yQusmsiBx18BHZWgDDC21Ojq3riyTOHMPcX8QdYFoCLXoGH
         EQpodw9xnNxyDXSLSmxezFZBpJ1SHOpUm6Dp5lAfzG9em532DoCQQ2gFq09Y1b0rjeBa
         5mMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1700589267; x=1701194067;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=thdh2sfxNMBf43X895xu9+OZ5IErUemLPJj69gUCBiw=;
        b=lC6v6r1HU0BbipuGIo1DvAZmxGJ2IhfdHAwgwA1ZW+rIQZSsNDWqRwcYkllUOXiUnm
         9YYHFrk/Wh2M2G4QhDxAzZVUfLjPs9d0R2/E24u52oCRpaQc0eUWo83rHr7MJra64U9m
         qgu9uTc8AyfQUWNWfrvHX2moNgAcCZt2WeqnQZcIV0ZBAHScYznoL3XRwKkTJWwYzLPn
         AmpXNfBtwzr4FErFMg5BMkqGV/i5egOQWLlIG0lNApDfQJ0gorG+ICG7CKBcJq254TNp
         w2rWEA9hJKAIfS6Q762tLGVEQ99mq29E3dF97q8HV9bVkasbULUYoRoyhBjtgR9rBT5N
         OWCg==
X-Gm-Message-State: AOJu0YygFFTzYtOCqSPv+gH1ikXtz1dCU8BaHhpE9w6mhrYcLYDF/kVq
	QztjMV5lniJsHk1WVj9KTkksVRdG+Ka1VpFxw6fRyajPQHyFbNM4vBc=
X-Google-Smtp-Source: AGHT+IHsVy3hlVh1utuAsBzIytLfcfqkdjA1bxEDpKpkiNZyzw7XlaOzq7mRbgmpknJtbOzJJYNiykvZpffWHHPpN3E=
X-Received: by 2002:a17:90b:1c87:b0:280:cd49:2548 with SMTP id
 oo7-20020a17090b1c8700b00280cd492548mr9381085pjb.6.1700589266369; Tue, 21 Nov
 2023 09:54:26 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Lakshmi Narasimhan Sundararajan <lsundararajan@purestorage.com>
Date: Tue, 21 Nov 2023 23:24:14 +0530
Message-ID: <CAFe+wq1-9Nn9+1QCnYJnqf-pTYfPJ5NhURKDv2eW0M334cnp5A@mail.gmail.com>
Subject: md array deadlock
To: linux-raid@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Good day team!

I observe a deadlock condition being hit rather consistently in the
following scenario.
I have tried my best to make it the email short, but its the best I
could get to without missing key details.

The storage layout is as below:
multiple disks (usually virtual) -> md array (raid 0) -> lvm pv part
of a vg -> hosting thin pool -> thin volumes - IOs active.

when 'md array' gets full or on need, the array is expanded by
temporarily putting the array into 'raid4' adding a spare drive to the
array and growing the array, then once reshape gets done, array is put
back to 'raid0'.
This is only to support capacity expansion. This is never a case of a
bad disk problem.

a/ array creation initially: mdadm -C /dev/mdX -f -n 1 -l0 -c 1024 /dev/sdc
// nothing special a raid0 array with provisioned drives.

b/ when capacity expansion is needed:

mdadm -G -l4 /dev/mdX
mdadm -G -n () -a <new disk> <<< this phase gets stuck.
wait for reshape to complete and put array back to 'raid0'.
mdadm -G -l0 /dev/mdX
resize pv: lvm pvresize /dev/mdX
resize thin pool on the vg.

<dmesg snip begin - a dynamic drive sdf is added to the vm for
capacity expansion>
[Mon Nov 20 11:41:33 2023] vmw_pvscsi: msg type: 0x0 - MSG RING: 5/4 (5)
[Mon Nov 20 11:41:33 2023] vmw_pvscsi: msg: device added at scsi0:5:0
[Mon Nov 20 11:41:33 2023] scsi 0:0:5:0: Direct-Access     VMware
Virtual disk     2.0  PQ: 0 ANSI: 6
[Mon Nov 20 11:41:33 2023] sd 0:0:5:0: Attached scsi generic sg5 type 0
[Mon Nov 20 11:41:33 2023] sd 0:0:5:0: [sdf] 419430400 512-byte
logical blocks: (215 GB/200 GiB)
[Mon Nov 20 11:41:33 2023] sd 0:0:5:0: [sdf] Write Protect is off
[Mon Nov 20 11:41:33 2023] sd 0:0:5:0: [sdf] Mode Sense: 3b 00 00 00
[Mon Nov 20 11:41:33 2023] sd 0:0:5:0: [sdf] Write cache: disabled,
read cache: disabled, doesn't support DPO or FUA
[Mon Nov 20 11:41:33 2023] sd 0:0:5:0: [sdf] Attached SCSI disk
[Mon Nov 20 11:41:39 2023] md/raid:md127: device sdc operational as raid disk 0
[Mon Nov 20 11:41:39 2023] md/raid:md127: raid level 4 active with 1
out of 2 devices, algorithm 5
<snip end>

There are 2 sets of tracebacks seen.

1. the mdadm cli that issued the grow command to the array is stuck as below.
mdadm -G -l4 /dev/md127
mdadm -G /dev/md127 -n 3 -a /dev/sdf <<< stuck

[Mon Nov 20 11:44:21 2023] INFO: task mdadm:65108 blocked for more
than 122 seconds.
[Mon Nov 20 11:44:21 2023]       Tainted: G           OE    --------
---  5.14.0-284.36.1.el9_2.x86_64 #1
[Mon Nov 20 11:44:21 2023] "echo 0 >
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
[Mon Nov 20 11:44:21 2023] task:mdadm           state:D stack:    0
pid:65108 ppid: 50296 flags:0x00004002
[Mon Nov 20 11:44:21 2023] Call Trace:
[Mon Nov 20 11:44:21 2023]  <TASK>
[Mon Nov 20 11:44:21 2023]  __schedule+0x248/0x620
[Mon Nov 20 11:44:21 2023]  ? kmem_cache_alloc+0x17d/0x300
[Mon Nov 20 11:44:21 2023]  schedule+0x2d/0x60
[Mon Nov 20 11:44:21 2023]  resize_stripes+0x623/0x710 [raid456]
[Mon Nov 20 11:44:21 2023]  ? cpuacct_percpu_seq_show+0x10/0x10
[Mon Nov 20 11:44:21 2023]  update_raid_disks+0xd4/0x140
[Mon Nov 20 11:44:21 2023]  raid_disks_store+0x5c/0x130
[Mon Nov 20 11:44:21 2023]  md_attr_store+0x80/0xf0
[Mon Nov 20 11:44:21 2023]  kernfs_fop_write_iter+0x121/0x1b0
[Mon Nov 20 11:44:21 2023]  new_sync_write+0xfc/0x190
[Mon Nov 20 11:44:21 2023]  vfs_write+0x1ef/0x280
[Mon Nov 20 11:44:21 2023]  ksys_write+0x5f/0xe0
[Mon Nov 20 11:44:21 2023]  do_syscall_64+0x59/0x90
[Mon Nov 20 11:44:21 2023]  ? exit_to_user_mode_prepare+0xb6/0x100
[Mon Nov 20 11:44:21 2023]  ? syscall_exit_to_user_mode+0x12/0x30
[Mon Nov 20 11:44:21 2023]  ? do_syscall_64+0x69/0x90
[Mon Nov 20 11:44:21 2023]  ? do_syscall_64+0x69/0x90
[Mon Nov 20 11:44:21 2023]  entry_SYSCALL_64_after_hwframe+0x63/0xcd
[Mon Nov 20 11:44:21 2023] RIP: 0033:0x7fb0ce53e917
[Mon Nov 20 11:44:21 2023] RSP: 002b:00007ffc0f551a18 EFLAGS: 00000246
ORIG_RAX: 0000000000000001
[Mon Nov 20 11:44:21 2023] RAX: ffffffffffffffda RBX: 00007ffc0f552430
RCX: 00007fb0ce53e917
[Mon Nov 20 11:44:21 2023] RDX: 0000000000000001 RSI: 00007ffc0f551b20
RDI: 0000000000000004
[Mon Nov 20 11:44:21 2023] RBP: 0000000000000004 R08: 0000000000000000
R09: 00007ffc0f5518a0
[Mon Nov 20 11:44:21 2023] R10: 0000000000000000 R11: 0000000000000246
R12: 00007ffc0f551b20
[Mon Nov 20 11:44:21 2023] R13: 00007ffc0f551b20 R14: 00005604131f4228
R15: 00007ffc0f551bf0
[Mon Nov 20 11:44:21 2023]  </TASK>


2. multiple apps that are performing IO on the lvm lvols and
subsequently that end up in md array gets stuck as below.
submit_bio->md_handle_request->raid5_make_request->make_stripe_request->raid5_get_active_stripe*

Any new operation that issues an IO to the md volume gets stuck (ex.
blkid) with the same signature as below.

[Mon Nov 20 11:44:21 2023] Call Trace:
[Mon Nov 20 11:44:21 2023]  <TASK>
[Mon Nov 20 11:44:21 2023]  __schedule+0x248/0x620
[Mon Nov 20 11:44:21 2023]  schedule+0x2d/0x60
[Mon Nov 20 11:44:21 2023]  raid5_get_active_stripe+0x25a/0x2f0 [raid456]
[Mon Nov 20 11:44:21 2023]  ? cpuacct_percpu_seq_show+0x10/0x10
[Mon Nov 20 11:44:21 2023]  make_stripe_request+0x9b/0x490 [raid456]
[Mon Nov 20 11:44:21 2023]  ? bdev_start_io_acct+0x47/0x100
[Mon Nov 20 11:44:21 2023]  raid5_make_request+0x16f/0x3e0 [raid456]
[Mon Nov 20 11:44:21 2023]  ? sched_show_numa+0xf0/0xf0
[Mon Nov 20 11:44:21 2023]  md_handle_request+0x132/0x1e0
[Mon Nov 20 11:44:21 2023]  ? bio_split_to_limits+0x51/0x90
[Mon Nov 20 11:44:21 2023]  __submit_bio+0x86/0x130
[Mon Nov 20 11:44:21 2023]  __submit_bio_noacct+0x81/0x1f0
[Mon Nov 20 11:44:21 2023]  submit_bio_wait+0x54/0xb0
[Mon Nov 20 11:44:21 2023]  __blkdev_direct_IO_simple+0x105/0x200
[Mon Nov 20 11:44:21 2023]  ? xlog_wait_on_iclog+0x176/0x180 [xfs]
[Mon Nov 20 11:44:21 2023]  ? wake_up_q+0x90/0x90
[Mon Nov 20 11:44:21 2023]  ? submit_bio_wait+0xb0/0xb0
[Mon Nov 20 11:44:21 2023]  generic_file_direct_write+0x99/0x1e0
[Mon Nov 20 11:44:21 2023]  __generic_file_write_iter+0x9e/0x1a0
[Mon Nov 20 11:44:21 2023]  blkdev_write_iter+0xe4/0x160
[Mon Nov 20 11:44:21 2023]  do_iter_readv_writev+0x124/0x190
[Mon Nov 20 11:44:21 2023]  do_iter_write+0x81/0x150
[Mon Nov 20 11:44:21 2023]  vfs_writev+0xae/0x170
[Mon Nov 20 11:44:21 2023]  ? syscall_exit_work+0x11a/0x150
[Mon Nov 20 11:44:21 2023]  ? syscall_exit_to_user_mode+0x12/0x30
[Mon Nov 20 11:44:21 2023]  ? do_syscall_64+0x69/0x90
[Mon Nov 20 11:44:21 2023]  __x64_sys_pwritev+0xb1/0x100
[Mon Nov 20 11:44:21 2023]  do_syscall_64+0x59/0x90
[Mon Nov 20 11:44:21 2023]  ? syscall_exit_to_user_mode+0x12/0x30
[Mon Nov 20 11:44:21 2023]  ? do_syscall_64+0x69/0x90
[Mon Nov 20 11:44:21 2023]  ? exit_to_user_mode_prepare+0xec/0x100
[Mon Nov 20 11:44:21 2023]  ? syscall_exit_to_user_mode+0x12/0x30
[Mon Nov 20 11:44:21 2023]  ? do_syscall_64+0x69/0x90
[Mon Nov 20 11:44:21 2023]  ? sysvec_apic_timer_interrupt+0x3c/0x90
[Mon Nov 20 11:44:21 2023]  entry_SYSCALL_64_after_hwframe+0x63/0xcd
[Mon Nov 20 11:44:21 2023] RIP: 0033:0x7fc906522638
[Mon Nov 20 11:44:21 2023] RSP: 002b:00007fc8d37fd560 EFLAGS: 00000246
ORIG_RAX: 0000000000000128
[Mon Nov 20 11:44:21 2023] RAX: ffffffffffffffda RBX: 0000000608252000
RCX: 00007fc906522638
[Mon Nov 20 11:44:21 2023] RDX: 0000000000000005 RSI: 00007fc8c84008d0
RDI: 0000000000000096
[Mon Nov 20 11:44:21 2023] RBP: 00007fc8d37fd640 R08: 0000000000000000
R09: 0000000000000000
[Mon Nov 20 11:44:21 2023] R10: 0000000608252000 R11: 0000000000000246
R12: 0000000000000096
[Mon Nov 20 11:44:21 2023] R13: 00007fc8c84008d0 R14: 00007fc800000005
R15: 0000000000000000
[Mon Nov 20 11:44:21 2023]  </TASK>


in this particular case, md array is as below

md127 : active raid4 sdf[2](S) sdc[0]
      209583104 blocks super 1.2 level 4, 1024k chunk, algorithm 0 [2/1] [U_]

root# cd /sys/block/md127/
root# cd md/
[root md]# cat degraded
1
[root md]# cat fail_last_dev
0
[root md]# cat raid_disks
2
[root md]# cat max_read_errors
20
[root md]# cat level
raid4
[root md]# cat layout
0
[root md]# cat stripe_cache_active
1025
[root md]# cat stripe_cache_size
1025
[root md]# cat sync_action
frozen
[root md]# ps -ef | grep mdadm
root       65108   34728  0 11:41 ?        00:00:00 mdadm -G
/dev/md127 --assume-clean -n 3 --add /dev/sdf
root      590277  486946  0 16:21 pts/2    00:00:00 grep --color=auto mdadm
[root md]#


[root md]# mdadm -D /dev/md127
/dev/md127:
           Version : 1.2
     Creation Time : Mon Nov 20 11:29:34 2023
        Raid Level : raid4
        Array Size : 209583104 (199.87 GiB 214.61 GB)
     Used Dev Size : 209583104 (199.87 GiB 214.61 GB)
      Raid Devices : 2
     Total Devices : 2
       Persistence : Superblock is persistent

       Update Time : Mon Nov 20 11:41:43 2023
             State : active, degraded
    Active Devices : 1
   Working Devices : 2
    Failed Devices : 0
     Spare Devices : 1

        Chunk Size : 1024K

Consistency Policy : resync

              Name : any:pwx0
              UUID : 0cde4499:2772c2e2:707cfb4b:f88f9a5d
            Events : 16

    Number   Major   Minor   RaidDevice State
       0       8       32        0      active sync   /dev/sdc
       -       0        0        1      removed

       2       8       80        -      spare   /dev/sdf
[root md]#
[root md]# mdadm -E /dev/sdf
/dev/sdf:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : 0cde4499:2772c2e2:707cfb4b:f88f9a5d
           Name : any:pwx0
  Creation Time : Mon Nov 20 11:29:34 2023
     Raid Level : raid4
   Raid Devices : 2

 Avail Dev Size : 419166208 sectors (199.87 GiB 214.61 GB)
     Array Size : 209583104 KiB (199.87 GiB 214.61 GB)
    Data Offset : 264192 sectors
   Super Offset : 8 sectors
   Unused Space : before=264040 sectors, after=0 sectors
          State : active
    Device UUID : cbe1abb1:0e9f0b05:6b1af8d2:98e202c5

    Update Time : Mon Nov 20 11:41:43 2023
  Bad Block Log : 512 entries available at offset 136 sectors
       Checksum : 8526998e - correct
         Events : 16

     Chunk Size : 1024K

   Device Role : spare
   Array State : A. ('A' == active, '.' == missing, 'R' == replacing)
[root md]#


I found several tickets recently that sounded similar to this path.
1/ md array reconfiguration with active IOs causing deadlocks.
https://www.spinics.net/lists/kernel/msg4786173.html

2/ stripe cache sizing issue? in the case I observed that the stripe
cache is utilized full. Can't find the reference to this discussion. I
did try on updating with a new stripe_cache_size, but the write to the
sysfs file got stuck and setting did not change.


<snip begin>
[root@pwx-ocp-152-245-m2dnx-worker-0-mb9gb md]# cat stripe_cache_active
1025
[root@pwx-ocp-152-245-m2dnx-worker-0-mb9gb md]# cat stripe_cache_size
1025
[root@pwx-ocp-152-245-m2dnx-worker-0-mb9gb md]# echo 2048 > stripe_cache_size
^C
[root@pwx-ocp-152-245-m2dnx-worker-0-mb9gb md]# cat stripe_cache_size
1025

<snip end>

My setup is an OCP environment as below. I would appreciate if any
pointers/suggestions on understanding this further.


## setup/environment details.

root# uname -a
Linux pwx-ocp-152-245-m2dnx-worker-0-mb9gb
5.14.0-284.36.1.el9_2.x86_64 #1 SMP PREEMPT_DYNAMIC Thu Oct 5 08:11:31
EDT 2023 x86_64 x86_64 x86_64 GNU/Linux
root# cat /etc/os-release
NAME="Red Hat Enterprise Linux CoreOS"
ID="rhcos"
ID_LIKE="rhel fedora"
VERSION="413.92.202310210500-0"
VERSION_ID="4.13"
VARIANT="CoreOS"
VARIANT_ID=coreos
PLATFORM_ID="platform:el9"
PRETTY_NAME="Red Hat Enterprise Linux CoreOS 413.92.202310210500-0 (Plow)"
ANSI_COLOR="0;31"
CPE_NAME="cpe:/o:redhat:enterprise_linux:9::coreos"
HOME_URL="https://www.redhat.com/"
DOCUMENTATION_URL="https://docs.openshift.com/container-platform/4.13/"
BUG_REPORT_URL="https://bugzilla.redhat.com/"
REDHAT_BUGZILLA_PRODUCT="OpenShift Container Platform"
REDHAT_BUGZILLA_PRODUCT_VERSION="4.13"
REDHAT_SUPPORT_PRODUCT="OpenShift Container Platform"
REDHAT_SUPPORT_PRODUCT_VERSION="4.13"
OPENSHIFT_VERSION="4.13"
RHEL_VERSION="9.2"
OSTREE_VERSION="413.92.202310210500-0"
root#
root# mdadm --version
mdadm - v4.2 - 2021-12-30 - 8
root# lvm version
  LVM version:     2.03.17(2) (2022-11-10)
  Library version: 1.02.187 (2022-11-10)
  Driver version:  4.47.0
  Configuration:   ./configure --build=x86_64-redhat-linux-gnu
--host=x86_64-redhat-linux-gnu --program-prefix=
--disable-dependency-tracking --prefix=/usr --exec-prefix=/usr
--bindir=/usr/bin --sbindir=/usr/sbin --sysconfdir=/etc
--datadir=/usr/share --includedir=/usr/include --libdir=/usr/lib64
--libexecdir=/usr/libexec --localstatedir=/var
--sharedstatedir=/var/lib --mandir=/usr/share/man
--infodir=/usr/share/info --with-default-dm-run-dir=/run
--with-default-run-dir=/run/lvm --with-default-pid-dir=/run
--with-default-locking-dir=/run/lock/lvm --with-usrlibdir=/usr/lib64
--enable-fsadm --enable-write_install --with-user= --with-group=
--with-device-uid=0 --with-device-gid=6 --with-device-mode=0660
--enable-pkgconfig --enable-cmdlib --enable-dmeventd
--enable-blkid_wiping --with-cluster=internal
--with-udevdir=/usr/lib/udev/rules.d --enable-udev_sync
--with-thin=internal --with-cache=internal --enable-lvmpolld
--enable-lvmlockd-dlm --enable-lvmlockd-dlmcontrol
--enable-lvmlockd-sanlock --enable-dbus-service --enable-notify-dbus
--enable-dmfilemapd --with-writecache=internal --with-vdo=internal
--with-vdo-format=/usr/bin/vdoformat --with-integrity=internal
--with-default-use-devices-file=1 --disable-silent-rules
--enable-app-machineid --enable-editline --disable-readline
root#

Best regards
LN
