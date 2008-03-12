From: Tomasz Chmielewski <mangoo@wpkg.org>
Subject: Re: sysfs Kernel BUG when RAID bitmap file has IO errors
Date: Wed, 12 Mar 2008 10:51:38 +0100
Message-ID: <47D7A7AA.8000302@wpkg.org>
References: <47D7A502.6020701@wpkg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <47D7A502.6020701@wpkg.org>
Sender: linux-raid-owner@vger.kernel.org
Cc: Linux-Raid <linux-raid@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
List-Id: linux-raid.ids

Tomasz Chmielewski schrieb:

(...)

> Let's access "/sys/block/md0/md/dev-sdd1/super":
> 
> # cat /sys/block/md0/md/dev-sdd1/super
> 
> # dmesg -c
> ------------[ cut here ]------------
> Kernel BUG at 78178626 [verbose debug info unavailable]

It turns out a broken RAID bitmap file has nothing to do with it - the 
same happens on a different machine without a bitmap file:

------------[ cut here ]------------
Kernel BUG at 7817736a [verbose debug info unavailable]
invalid opcode: 0000 [#1]
Modules linked in: as_iosched nfs lockd nfs_acl sunrpc bonding dm_mirror 
dm_snapshot e1000 sata_mv

Pid: 2494, comm: cat Not tainted (2.6.24.3-1 #1)
EIP: 0060:[<7817736a>] EFLAGS: 00010212 CPU: 0
EIP is at sysfs_read_file+0x88/0xd4
EAX: 00000001 EBX: 961b5880 ECX: 00000000 EDX: 964ef360
ESI: 00001000 EDI: 964ef3c0 EBP: 9705bd04 ESP: 971f1f54
  DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 0068
Process cat (pid: 2494, ti=971f0000 task=970ad9a0 task.ti=971f0000)
Stack: 96443080 0804b4d8 00001000 0804e000 961b5894 7835f6f0 96193400 
0804e000
        781772e2 00001000 78149bd5 971f1fa0 00001000 96193400 fffffff7 
0804e000
        971f0000 78149f03 971f1fa0 00000000 00000000 00000000 00000003 
0804e000
Call Trace:
  [<781772e2>] sysfs_read_file+0x0/0xd4
  [<78149bd5>] vfs_read+0x88/0x10a
  [<78149f03>] sys_read+0x41/0x67
  [<78103bba>] syscall_call+0x7/0xb
  =======================
Code: c0 74 61 8b 47 18 8b 4b 0c 8b 40 04 89 43 24 89 e8 8b 74 24 14 8b 
57 14 ff 16 89 c6 89 f8 e8 18 0b 00 00 81 fe ff 0f 00 00 7e 04 <0f> 0b 
eb fe 85 f6 78 31 c7 43 20 00 00 00 00 89 33 eb 07 be f4
EIP: [<7817736a>] sysfs_read_file+0x88/0xd4 SS:ESP 0068:971f1f54
---[ end trace e39b88900c26a529 ]---


Certainly, it doesn't happen with 2.6.18 kernels.



-- 
Tomasz Chmielewski
http://wpkg.org
