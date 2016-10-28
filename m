From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: Re: MD-RAID: Use seq_putc() in three status functions?
Date: Fri, 28 Oct 2016 22:04:33 +0200
Message-ID: <69acd529-fc75-bd74-17ae-bedd8796e706@users.sourceforge.net>
References: <566ABCD9.1060404@users.sourceforge.net>
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
 <cc24736e-2227-2a49-e131-386775c942d9@users.sourceforge.net>
 <e264883f-d1b9-4bf3-aa9f-45fce5dab18e@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <kernel-janitors-owner@vger.kernel.org>
In-Reply-To: <e264883f-d1b9-4bf3-aa9f-45fce5dab18e@users.sourceforge.net>
Sender: kernel-janitors-owner@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, linux-raid@vger.kernel.org
Cc: Bernd Petrovitsch <bernd@petrovitsch.priv.at>, Christoph Hellwig <hch@lst.de>, Guoqing Jiang <gqjiang@suse.com>, Jens Axboe <axboe@fb.com>, Joe Perches <coupons@perches.com>, Mike Christie <mchristi@redhat.com>, Neil Brown <neilb@suse.com>, Shaohua Li <shli@kernel.org>, Tomasz Majchrzak <tomasz.majchrzak@intel.com>, LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org, kbuild-all@01.org, ltp@lists.linux.it
List-Id: linux-raid.ids

>>> So back to the original task for you: Show me in the generated output where the benefits are.

I can offer another bit of information for this software development discussion.

The following build settings were active in my "Makefile" for this Linux test case.

…
HOSTCFLAGS   = -Wall -Wmissing-prototypes -Wstrict-prototypes -O0 -fomit-frame-pointer -std=gnu89
…


The afffected source files can be compiled for the processor architecture "x86_64"
by a tool like "GCC 6.2.1+r239849-1.5" from the software distribution
"openSUSE Tumbleweed" with the following command example.

my_original=${my_build_dir}unchanged/test/ \
&& my_fixing=${my_build_dir}patched/test/ \
&& mkdir -p ${my_original} ${my_fixing} \
&& my_cc=/usr/bin/gcc-6 \
&& my_module=drivers/md/raid1.s \
&& git checkout next-20161014 \
&& make -j6 O="${my_original}" CC="${my_cc}" HOSTCC="${my_cc}" allmodconfig "${my_module}" \
&& git checkout next_usage_of_seq_putc_in_md_raid_1 \
&& make -j6 O="${my_fixing}" CC="${my_cc}" HOSTCC="${my_cc}" allmodconfig "${my_module}" \
&& diff -u "${my_original}${my_module}" "${my_fixing}${my_module}" > "${my_build_dir}assembler_code_comparison_$(date -I)_3.diff"


The generated file got the size "25.4 KiB" this time. I guess that only
the following two diff hunks are interesting then to show desired effects
for the suggested software refactoring around data output of a single character
(instead of a similar string).


…
@@ -4402,10 +4402,6 @@
 .LC19:
 	.string	"%s"
 	.zero	61
-	.align 32
-.LC20:
-	.string	"]"
-	.zero	62
 	.text
 	.p2align 4,,15
 	.type	raid1_status, @function
@@ -4564,8 +4560,8 @@
 	movq	$rcu_lock_map, %rdi	#,
 	call	lock_release	#
 	movq	%r14, %rdi	# seq,
-	movq	$.LC20, %rsi	#,
-	call	seq_printf	#
+	movl	$93, %esi	#,
+	call	seq_putc	#
 	addq	$16, %rsp	#,
 	popq	%rbx	#
 	popq	%r12	#
…


* Is this kind of assembler code comparison useful to clarify relevant
  differences further?

* Are any software development concerns left over for such a transformation?

Regards,
Markus

