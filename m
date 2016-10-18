From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: Re: MD-RAID: Use seq_putc() in three status functions?
Date: Tue, 18 Oct 2016 20:20:25 +0200
Message-ID: <cc24736e-2227-2a49-e131-386775c942d9@users.sourceforge.net>
References: <566ABCD9.1060404@users.sourceforge.net>
 <1475771699.1914.10.camel@perches.com>
 <77fb6fdc-7480-8607-0af1-42f73c125b9d@users.sourceforge.net>
 <688764a4-072d-2faf-37ba-a222b190a5d9@suse.de>
 <59d71170-c48d-a084-c748-b6ab74a2bee4@users.sourceforge.net>
 <1e151094-e228-5307-ae2f-b376b31f5628@suse.de>
 <83e720c6-9037-a3c1-6e83-27505805f37f@users.sourceforge.net>
 <2cc42b2f-1f1a-e95c-91fa-54e1dd3b6d49@suse.de>
 <653e60ee-f862-8828-3e4f-498c7cc34bdc@users.sourceforge.net>
 <c2500336-5848-66c3-ecf0-1ade04decf75@suse.de>
 <a0f96e19-fa24-8507-2b77-344a342113aa@users.sourceforge.net>
 <1476703920.2520.105.camel@petrovitsch.priv.at>
 <97f31b70-e3ff-f194-c753-54da1fe3e664@users.sourceforge.net>
 <57299b72-8e6b-0b92-4374-1b7a0907e810@suse.de>
 <cb9beadc-3ea2-c09c-f621-a54cd73e3647@users.sourceforge.net>
 <05d0cade-7922-9d8a-a974-34b2cc9150fb@suse.de>
 <bf6c54f1-7af4-747c-a58b-be13ab74563e@users.sourceforge.net>
 <665cd40a-4562-a015-78c6-12976c12b626@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <665cd40a-4562-a015-78c6-12976c12b626@suse.de>
Sender: linux-raid-owner@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, linux-raid@vger.kernel.org
Cc: Bernd Petrovitsch <bernd@petrovitsch.priv.at>, Christoph Hellwig <hch@lst.de>, Guoqing Jiang <gqjiang@suse.com>, Jens Axboe <axboe@fb.com>, Joe Perches <coupons@perches.com>, Mike Christie <mchristi@redhat.com>, Neil Brown <neilb@suse.com>, Shaohua Li <shli@kernel.org>, Tomasz Majchrzak <tomasz.majchrzak@intel.com>, LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org, kbuild-all@01.org, ltp@lists.linux.it
List-Id: linux-raid.ids

> So back to the original task for you: Show me in the generated output where the benefits are.

I can offer a bit more information for this software development discussion.


The afffected source files can be compiled for the processor architecture "x86_64"
by a tool like "GCC 6.2.1+r239849-1.3" from the software distribution
"openSUSE Tumbleweed" with the following command examples.

git checkout next-20161014 && my_cc=/usr/bin/gcc-6 && make HOSTCC="${my_cc}" allmodconfig && make -j6 HOSTCC="${my_cc}" drivers/md/
git checkout next_usage_of_seq_putc_in_md_raid_1 && my_cc=/usr/bin/gcc-6 && make HOSTCC="${my_cc}" allmodconfig && make -j6 HOSTCC="${my_cc}" drivers/md/


The tool "objdump" from the software package "binutils 2.27-1.3" can be used
to get corresponding disassemblies for a file like "drivers/md/raid1.obj"
which can then be compared as follows.


--- ../disassembly-md-raid1-next-20161014-1.txt	2016-10-18 18:00:12.341222741 +0200
+++ ../disassembly-md-raid1-seq_putc-1.txt	2016-10-18 18:03:54.135887333 +0200
@@ -3349,7 +3349,7 @@
     37ad:	85 c0                	test   %eax,%eax
     37af:	74 0d                	je     37be <raid1_status+0x9e>
     37b1:	80 3d 00 00 00 00 00 	cmpb   $0x0,0x0(%rip)        # 37b8 <raid1_status+0x98>
-    37b8:	0f 84 1d 01 00 00    	je     38db <raid1_status+0x1bb>
+    37b8:	0f 84 1b 01 00 00    	je     38d9 <raid1_status+0x1b9>
     37be:	4c 89 ff             	mov    %r15,%rdi
     37c1:	31 db                	xor    %ebx,%ebx
     37c3:	e8 00 00 00 00       	callq  37c8 <raid1_status+0xa8>
@@ -3404,42 +3404,43 @@
     3891:	85 c0                	test   %eax,%eax
     3893:	74 09                	je     389e <raid1_status+0x17e>
     3895:	80 3d 00 00 00 00 00 	cmpb   $0x0,0x0(%rip)        # 389c <raid1_status+0x17c>
-    389c:	74 6e                	je     390c <raid1_status+0x1ec>
+    389c:	74 6c                	je     390a <raid1_status+0x1ea>
     389e:	48 c7 c2 00 00 00 00 	mov    $0x0,%rdx
     38a5:	be 01 00 00 00       	mov    $0x1,%esi
     38aa:	48 c7 c7 00 00 00 00 	mov    $0x0,%rdi
     38b1:	65 ff 0d 00 00 00 00 	decl   %gs:0x0(%rip)        # 38b8 <raid1_status+0x198>
     38b8:	e8 00 00 00 00       	callq  38bd <raid1_status+0x19d>
     38bd:	4c 89 f7             	mov    %r14,%rdi
-    38c0:	48 c7 c6 00 00 00 00 	mov    $0x0,%rsi
-    38c7:	e8 00 00 00 00       	callq  38cc <raid1_status+0x1ac>
-    38cc:	48 83 c4 10          	add    $0x10,%rsp
-    38d0:	5b                   	pop    %rbx
-    38d1:	41 5c                	pop    %r12
-    38d3:	41 5d                	pop    %r13
-    38d5:	41 5e                	pop    %r14
-    38d7:	41 5f                	pop    %r15
-    38d9:	5d                   	pop    %rbp
-    38da:	c3                   	retq   
-    38db:	e8 00 00 00 00       	callq  38e0 <raid1_status+0x1c0>
-    38e0:	84 c0                	test   %al,%al
-    38e2:	0f 85 d6 fe ff ff    	jne    37be <raid1_status+0x9e>
-    38e8:	48 c7 c2 00 00 00 00 	mov    $0x0,%rdx
-    38ef:	be 69 03 00 00       	mov    $0x369,%esi
-    38f4:	48 c7 c7 00 00 00 00 	mov    $0x0,%rdi
-    38fb:	c6 05 00 00 00 00 01 	movb   $0x1,0x0(%rip)        # 3902 <raid1_status+0x1e2>
-    3902:	e8 00 00 00 00       	callq  3907 <raid1_status+0x1e7>
-    3907:	e9 b2 fe ff ff       	jmpq   37be <raid1_status+0x9e>
-    390c:	e8 00 00 00 00       	callq  3911 <raid1_status+0x1f1>
-    3911:	84 c0                	test   %al,%al
-    3913:	75 89                	jne    389e <raid1_status+0x17e>
-    3915:	48 c7 c2 00 00 00 00 	mov    $0x0,%rdx
-    391c:	be 9c 03 00 00       	mov    $0x39c,%esi
-    3921:	48 c7 c7 00 00 00 00 	mov    $0x0,%rdi
-    3928:	c6 05 00 00 00 00 01 	movb   $0x1,0x0(%rip)        # 392f <raid1_status+0x20f>
-    392f:	e8 00 00 00 00       	callq  3934 <raid1_status+0x214>
-    3934:	e9 65 ff ff ff       	jmpq   389e <raid1_status+0x17e>
-    3939:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)
+    38c0:	be 5d 00 00 00       	mov    $0x5d,%esi
+    38c5:	e8 00 00 00 00       	callq  38ca <raid1_status+0x1aa>
+    38ca:	48 83 c4 10          	add    $0x10,%rsp
+    38ce:	5b                   	pop    %rbx
+    38cf:	41 5c                	pop    %r12
+    38d1:	41 5d                	pop    %r13
+    38d3:	41 5e                	pop    %r14
+    38d5:	41 5f                	pop    %r15
+    38d7:	5d                   	pop    %rbp
+    38d8:	c3                   	retq   
+    38d9:	e8 00 00 00 00       	callq  38de <raid1_status+0x1be>
+    38de:	84 c0                	test   %al,%al
+    38e0:	0f 85 d8 fe ff ff    	jne    37be <raid1_status+0x9e>
+    38e6:	48 c7 c2 00 00 00 00 	mov    $0x0,%rdx
+    38ed:	be 69 03 00 00       	mov    $0x369,%esi
+    38f2:	48 c7 c7 00 00 00 00 	mov    $0x0,%rdi
+    38f9:	c6 05 00 00 00 00 01 	movb   $0x1,0x0(%rip)        # 3900 <raid1_status+0x1e0>
+    3900:	e8 00 00 00 00       	callq  3905 <raid1_status+0x1e5>
+    3905:	e9 b4 fe ff ff       	jmpq   37be <raid1_status+0x9e>
+    390a:	e8 00 00 00 00       	callq  390f <raid1_status+0x1ef>
+    390f:	84 c0                	test   %al,%al
+    3911:	75 8b                	jne    389e <raid1_status+0x17e>
+    3913:	48 c7 c2 00 00 00 00 	mov    $0x0,%rdx
+    391a:	be 9c 03 00 00       	mov    $0x39c,%esi
+    391f:	48 c7 c7 00 00 00 00 	mov    $0x0,%rdi
+    3926:	c6 05 00 00 00 00 01 	movb   $0x1,0x0(%rip)        # 392d <raid1_status+0x20d>
+    392d:	e8 00 00 00 00       	callq  3932 <raid1_status+0x212>
+    3932:	e9 67 ff ff ff       	jmpq   389e <raid1_status+0x17e>
+    3937:	66 0f 1f 84 00 00 00 	nopw   0x0(%rax,%rax,1)
+    393e:	00 00 
 
 0000000000003940 <print_conf>:
     3940:	e8 00 00 00 00       	callq  3945 <print_conf+0x5>
@@ -11134,7 +11135,7 @@
 
 0000000000000000 <_GLOBAL__sub_D_65535_0_raid1.c>:
    0:	55                   	push   %rbp
-   1:	be 35 00 00 00       	mov    $0x35,%esi
+   1:	be 34 00 00 00       	mov    $0x34,%esi
    6:	48 c7 c7 00 00 00 00 	mov    $0x0,%rdi
    d:	48 89 e5             	mov    %rsp,%rbp
   10:	e8 00 00 00 00       	callq  15 <_GLOBAL__sub_D_65535_0_raid1.c+0x15>
@@ -11145,7 +11146,7 @@
 
 0000000000000000 <_GLOBAL__sub_I_65535_1_raid1.c>:
    0:	55                   	push   %rbp
-   1:	be 35 00 00 00       	mov    $0x35,%esi
+   1:	be 34 00 00 00       	mov    $0x34,%esi
    6:	48 c7 c7 00 00 00 00 	mov    $0x0,%rdi
    d:	48 89 e5             	mov    %rsp,%rbp
   10:	e8 00 00 00 00       	callq  15 <_GLOBAL__sub_I_65535_1_raid1.c+0x15>


Does this kind of data display contain differences which are worth for further considerations?

Regards,
Markus
