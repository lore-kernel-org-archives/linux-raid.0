From: Tim Hockin <thockin@sun.com>
Subject: raid1.c BUG()
Date: Wed, 23 Oct 2002 17:54:25 -0700
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <3DB744C1.3010604@sun.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

kernel 2.5.41
Adaptec aic7899 U160 SCSI
RAID1 on sda1 and sdb3


------------[ cut here ]------------
kernel BUG at drivers/md/raid1.c:667!
invalid operand: 0000
eepro100 mii binfmt_misc nfs lockd sunrpc nls_iso8859-1 nls_cp437 vfat 
fat usbcore
CPU:    0
EIP:    0060:[<c025cbbc>]    Not tainted
EFLAGS: 00010283
EIP is at close_sync+0xdc/0x100
eax: dfcb1314   ebx: 00000000   ecx: dfce1ea4   edx: 00000000
esi: dfcb1200   edi: dfce1e00   ebp: 001f2100   esp: dfc7bea8
ds: 0068   es: 0068   ss: 0068
Process md_resync (pid: 19, threadinfo=dfc7a000 task=dfc7e140)
Stack: c0116540 deb91f30 c0359800 dfc7e560 c02fdd00 dfc7e140 c03604a0 
dfb4d70c
        dfcb1200 00000002 dfce1e00 c025d4a3 dfcb1200 c043b6d7 001f2100 
dfc7a000
        00000002 dfce1e00 dfce1e00 c0267083 dfce1e00 001f2100 00000001 
dfc7a000
Call Trace:
  [<c0116540>] __wake_up_common+0x40/0x60
  [<c025d4a3>] sync_request+0x43/0x1d0
  [<c0267083>] md_do_sync+0x513/0x560
  [<c01164c0>] default_wake_function+0x0/0x40
  [<c02660c9>] md_thread+0x169/0x1d0
  [<c01164c0>] default_wake_function+0x0/0x40
  [<c0265f60>] md_thread+0x0/0x1d0
  [<c01070a9>] kernel_thread_helper+0x5/0xc

Code: 0f 0b 9b 02 a4 25 2d c0 8b 8e 20 01 00 00 51 e8 f0 0b ee ff

-- 
Tim Hockin
Systems Software Engineer
Sun Microsystems, Linux Kernel Engineering
thockin@sun.com

