From: Sonu a <p10sonu@gmail.com>
Subject: md disk fault communication code
Date: Fri, 18 Apr 2014 13:38:58 +0800
Message-ID: <CAAcCrhQEW4Yzz2YQri3hzNExQVWqquvN8dzzxZN+5DBZbAtcRw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

when disk is removed with out mdadm as I see from the stack below the
communication reaching the md driver.

dump_stack+0x49/0x5e
md_error+0x50/0x110 [md_mod]
state_store+0x43/0x300 [md_mod]
rdev_attr_store+0xad/0xd0 [md_mod]
? sysfs_write_file+0x62/0x1c0
sysfs_write_file+0x138/0x1c0
vfs_write+0xc0/0x1e0
SyS_write+0x5a/0xa0
? __audit_syscall_exit+0x246/0x2f0
system_call_fastpath+0x16/0x1b

could someone point me to the code which is monitoring scsi disks
status and thus calling md driver sysfs interface accordingly ?

Thx.
