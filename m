From: kernel@kamogawa.com.br
Subject: Promise S150 TX4 - Driver compiled, but Kernel Panic
Date: Mon, 26 Jul 2004 14:34:48 -0300 (BRT)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <1948.192.168.1.14.1090863288.squirrel@webmail01.centralserver.com.br>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello!

I found the source code for Promise FastTrack S150 TX4 6 Port SATA
RAID Controller. It was found at:

http://www.promise.com/support/download/download2_eng.asp?productId=108&category=All&os=4#

I am using Tao Linux, a RedHat Enterprise Linux clone, and it uses
kernel 2.4.21. Here is what I did:

1. Installed kernel-BOOT.2.4.21-15.TL2
2. Booted with kernel-BOOT
3. Installed the kernel source
4. Compiled the code with Independent Modules
5. Started an installation with driver disk
6. Loaded the ft3xx module
7. Kernel Panic

The system specs are:

Processor: Pentium 4 2GHz
Memory: 256 DIMM
Dist: Tao Linux (RHEL 3 Clone)
Kernel: 2.4.21-15.TL2BOOT
GCC: 3.23 20030502 (Red Hat Linux 3.2.3-34)
MotherBoard: Intel S875WP1-E ( LX ) with onboard Promise FastTrack
S150 TX4 SATA RAID Controller

When I loaded the module, the following error was shown:

---

Oops: 0000
CPU: 0
EIP: 0060:[<c0188577>] Not Tainted
EFLAGS: 00010246

EIP is at (2.4.21-15.TL2BOOT/i686)
eax: 00000000	ebx: c1a8cb60	ecx: 33190100	edx: 00000020
esi: 00000054	edi: 00000000	ebp: 00000002	esp: cfe27e80
ds: 0068	es: 0068	ss: 0068
Process Loader (pid: 16, stackpage=cfe27000)
Stack:  00000020 c018bd49 c134a110 00000020 00000001 cfdf92e4 00000066
080b9040
	010001ff 00000000 00000000 ffffffff 00000012 00000066 c1a11800 00000000
	080b9040 c018c4c8 c1a18000 00000001 c02fc592 00000066 00000066 cfe26000
Call Trace: [<c018bd49>] (0xcfe27e04)
[<c018c4c8>] (0xcfe27ec4)
[<c0180c3f>] (0xcfe27ee0)
[<c017f459>] (0xcfe27f4c)
[<c017d16b>] (0xcfe27f74)elements | <Space> selects | <F12> next screen
[<c0180a84>] (0xcfe27f78)
[<c0142170>] (0xcfe27f9c)

Code: 8b 04 81 85 c8 74 10 83 e2 3f 0f b7 04 50 3d ff 01 00 00 89

Kernel Panic: Fatal Exception

---

The driver disk and kernel error can be found at:

http://www.kamogawa.com.br/RAID

Can somebody help me?

Thanks and Best Regards,

Helio Rubens Kamogawa
kernel at kamogawa dot com dot br
+55 41 3241993
