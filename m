From: Paul Clements <paul.clements@steeleye.com>
Subject: Re: [PATCH] ANNOUNCE: mdadm 2.5.1 - A tool for managing Soft RAID
 under Linux
Date: Mon, 19 Jun 2006 11:09:14 -0400
Message-ID: <4496BE1A.8010502@steeleye.com>
References: <17554.895.666628.776527@cse.unsw.edu.au> <4492D26B.4070705@steeleye.com> <4492F066.7060709@tmr.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------030301080304010307060505"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4492F066.7060709@tmr.com>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This is a multi-part message in MIME format.
--------------030301080304010307060505
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Bill Davidsen wrote:
> Paul Clements wrote:
> 
>> Neil Brown wrote:
>>
>>>
>>> I am pleased to announce the availability of
>>>    mdadm version 2.5.1

and here's another patch for a compile error on ppc...

Since ppc is big endian, the compiler is complaining because it can't 
determine whether the isuper post-increment (++) is actually going to be 
evaluated (__le32_to_cpu is a macro). On x86 the macro is a no-op, so I 
guess the compiler is smart enough to figure out that the post-increment 
is actually happening?

Here's the warning (gcc 3.2.3):

$ make
gcc -Wall -Werror -Wstrict-prototypes -ggdb 
-DSendmail=\""/usr/sbin/sendmail -t"\" -DCONFFILE=\"/etc/mdadm.conf\" 
-DCONFFILE2=\"/etc/mdadm/mdadm.conf\"   -c -o super1.o super1.c
cc1: warnings being treated as errors
super1.c: In function `calc_sb_1_csum':
super1.c:128: warning: operation on `isuper' may be undefined
super1.c:128: warning: operation on `isuper' may be undefined
super1.c:128: warning: operation on `isuper' may be undefined
make: *** [super1.o] Error 1


Thanks,
Paul

--------------030301080304010307060505
Content-Type: text/plain;
 name="mdadm-2.5.1-super1-compile-error-ppc.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="mdadm-2.5.1-super1-compile-error-ppc.diff"

--- super1.c	2006-06-19 05:17:36.000000000 -0400
+++ /export/public/clemep/tmp/super1-ppc-compile-error.c	2006-06-19 00:40:26.000000000 -0400
@@ -124,8 +124,11 @@ static unsigned int calc_sb_1_csum(struc
 	disk_csum = sb->sb_csum;
 	sb->sb_csum = 0;
 	newcsum = 0;
-	for (i=0; size>=4; size -= 4 )
-		newcsum += __le32_to_cpu(*isuper++);
+	for (i=0; size>=4; size -= 4 ) {
+		unsigned int *x = isuper;
+		newcsum += __le32_to_cpu(*x);
+		x++;
+	}
 
 	if (size == 2)
 		newcsum += __le16_to_cpu(*(unsigned short*) isuper);

--------------030301080304010307060505--
