From: "David S. Miller" <davem@redhat.com>
Subject: Re: OOPS: ext3/sparc badness
Date: Fri, 30 Aug 2002 17:18:12 -0700 (PDT)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <17074.0768000998$1030753686@news.gmane.org>
References: <20020521083004.GB18501@monkey.beezly.org.uk>
	<20020521.011858.88884742.davem@redhat.com>
	<20020521083805.GC18501@monkey.beezly.org.uk>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20020521083805.GC18501@monkey.beezly.org.uk>
To: beezly@beezly.org.uk
Cc: hch@infradead.org, neilb@cse.unsw.edu.au, bcollins@debian.org, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

   From: Andrew Beresford <beezly@beezly.org.uk>
   Date: Tue, 21 May 2002 09:38:05 +0100

   On Tue, May 21, 2002 at 01:18:58AM -0700, David S. Miller wrote:
   > I don't think so... but please repost the link as I've deleted all of
   > your emails.
   
   The link is;
   
   http://marc.theaimsgroup.com/?l=linux-raid&m=101981888804890&w=2

To recap, the compiler used to build sparc64 kernels miscompiles
drivers/md/raid1.c:raid1_read_balance()

The following appears to be a good workaround for this
bug, Neil could you put this into your tree and would you
mind if I sent this to Marcelo for 2.4.20-preX?

--- drivers/md/raid1.c.~1~	Fri Aug 30 17:03:02 2002
+++ drivers/md/raid1.c	Fri Aug 30 17:17:46 2002
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
