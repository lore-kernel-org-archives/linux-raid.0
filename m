From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: Raid1 and Sun Ultra5
Date: Wed, 13 Nov 2002 23:07:05 +1100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <15826.16489.812197.778756@notabene.cse.unsw.edu.au>
References: <5.1.1.6.0.20021113111822.00a4aec0@bsing.ing.unibs.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Francesco Gringoli on Wednesday November 13
To: Francesco Gringoli <francesco.gringoli@ing.unibs.it>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wednesday November 13, francesco.gringoli@ing.unibs.it wrote:
> Hi all,
> 
> I have just installed Debian Woody on a Ultra5 box:
> I spanned a Raid1 volume across two ide disks:
...
> AND...
> 
> when the construction of the volume finishes I can't do
> ANYTHING on the volume. e.g. if I try to mount it I get:
> 
> data_access_exception: SFSR[0000000000801009] SFAR[fffff80338e39efc], going.
>                \|/ ____ \|/
>                "@'/ .. \`@"
>                /_| \__/ |_\
>                   \__U_/

Known compiler problem.  Fixed in 2.4.20-rc1.  Relevant diff is below.

NeilBrown

--- stable-19r/drivers/md/raid1.c	2002-08-13 14:05:04.000000000 +1000
+++ stable-20rc1/drivers/md/raid1.c	2002-11-05 11:45:49.000000000 +1100
@@ -23,6 +23,7 @@
  */
 
 #include <linux/module.h>
+#include <linux/config.h>
 #include <linux/slab.h>
 #include <linux/raid/raid1.h>
 #include <asm/atomic.h>
@@ -522,6 +523,10 @@
 	if (conf->sect_count >= conf->mirrors[new_disk].sect_limit) {
 		conf->sect_count = 0;
 
+#if defined(CONFIG_SPARC64) && (__GNUC__ == 2) && (__GNUC_MINOR__ == 92)
+		/* Work around a compiler bug in egcs-2.92.11 19980921 */
+		new_disk = *(volatile int *)&new_disk;
+#endif
 		do {
 			if (new_disk<=0)
 				new_disk = conf->raid_disks;
