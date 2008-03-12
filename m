From: Tomasz Chmielewski <mangoo@wpkg.org>
Subject: sysfs Kernel BUG when RAID bitmap file has IO errors
Date: Wed, 12 Mar 2008 10:40:18 +0100
Message-ID: <47D7A502.6020701@wpkg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linux-Raid <linux-raid@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
List-Id: linux-raid.ids

I have a RAID-5 bitmap file on external media:

# cat /proc/mdstat
Personalities : [raid6] [raid5] [raid4]
md0 : active raid5 sdb1[0] sdf1[4] sde1[3] sdd1[2] sdc1[1]
       1562834944 blocks level 5, 64k chunk, algorithm 2 [5/5] [UUUUU]
       bitmap: 0/373 pages [0KB], 512KB chunk, file: /root/raid/bitmap

unused devices: <none>


Unfortunately, that external media is flash which slowly dies:

# md5sum /root/raid/bitmap
md5sum: /root/raid/bitmap: Input/output error


Let's access "/sys/block/md0/md/dev-sdd1/super":

# cat /sys/block/md0/md/dev-sdd1/super

# dmesg -c
------------[ cut here ]------------
Kernel BUG at 78178626 [verbose debug info unavailable]
invalid opcode: 0000 [#8]
Modules linked in: iscsi_scst crc32c libcrc32c scst_vdisk scst 
iptable_filter ip_tables x_tables as_iosched deadline_iosched nfs nfsd 
lockd nfs_acl auth_rpcgss sunrpc exportfs dm_snapshot dm_mirror bonding 
e1000 sata_mv

Pid: 4901, comm: cat Tainted: G      D (2.6.24.2-1 #1)
EIP: 0060:[<78178626>] EFLAGS: 00010212 CPU: 0
EIP is at sysfs_read_file+0x88/0xd4
EAX: 00000001 EBX: 91611780 ECX: 00000000 EDX: 976fecc0
ESI: 00001000 EDI: 976fed20 EBP: 9745b344 ESP: 8353df54
  DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 0068
Process cat (pid: 4901, ti=8353c000 task=7d4caa40 task.ti=8353c000)
Stack: 93511080 0804b4d8 00001000 0804e000 91611794 783515f0 847e3380 
0804e000
        7817859e 00001000 7814ad7c 8353dfa0 00001000 847e3380 fffffff7 
0804e000
        8353c000 7814b0aa 8353dfa0 00000000 00000000 00000000 00000003 
0804e000
Call Trace:
  [<7817859e>] sysfs_read_file+0x0/0xd4
  [<7814ad7c>] vfs_read+0x88/0x10a
  [<7814b0aa>] sys_read+0x41/0x67
  [<78103bca>] syscall_call+0x7/0xb
  =======================
Code: c0 74 61 8b 47 18 8b 4b 0c 8b 40 04 89 43 24 89 e8 8b 74 24 14 8b 
57 14 ff 16 89 c6 89 f8 e8 18 0b 00 00 81 fe ff 0f 00 00 7e 04 <0f> 0b 
eb fe 85 f6 78 31 c7 43 20 00 00 00 00 89 33 eb 07 be f4
EIP: [<78178626>] sysfs_read_file+0x88/0xd4 SS:ESP 0068:8353df54
---[ end trace 7e6d8636f39e737a ]---



-- 
Tomasz Chmielewski
http://wpkg.org
