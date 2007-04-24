From: Neil Brown <neilb@suse.de>
Subject: Re: Partitioned arrays initially missing from /proc/partitions
Date: Tue, 24 Apr 2007 20:57:09 +1000
Message-ID: <17965.57989.120710.460711@notabene.brown>
References: <462CC91B.8030008@dgreaves.com>
	<16046.1177356707@mdt.dhcp.pit.laurelnetworks.com>
	<17965.18112.135843.417561@notabene.brown>
	<462DCC4E.2020108@dgreaves.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from David Greaves on Tuesday April 24
Sender: linux-raid-owner@vger.kernel.org
To: David Greaves <david@dgreaves.com>
Cc: Mike Accetta <maccetta@laurelnetworks.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tuesday April 24, david@dgreaves.com wrote:
> Neil Brown wrote:
> > This problem is very hard to solve inside the kernel.
> > The partitions will not be visible until the array is opened *after*
> > it has been created.  Making the partitions visible before that would
> > be possible, but would be very easy.
> > 
> > I think the best solution is Mike's solution which is to simply
> > open/close the array after it has been assembled.  I will make sure
> > this is in the next release of mdadm.
> > 
> > Note that you can still access the partitions even though they do not
> > appear in /proc/partitions. Any attempt to access and of them will
> > make them all appear in /proc/partitions.  But I understand there is
> > sometimes value in seeing them before accessing them.
> > 
> > NeilBrown
> 
> Um. Are you sure?

"Works for me".

What happens if you
  blockdev --rereadpt /dev/md_d0
?? It probably works then.
It sounds like someone is deliberately removing all the partition
info.

Can you try this patch and see if it reports anyone calling
'2' on md_d0 ??

diff .prev/block/ioctl.c ./block/ioctl.c
--- .prev/block/ioctl.c	2007-04-17 11:42:15.000000000 +1000
+++ ./block/ioctl.c	2007-04-24 20:55:41.000000000 +1000
@@ -17,6 +17,7 @@ static int blkpg_ioctl(struct block_devi
 	long long start, length;
 	int part;
 	int i;
+	char b[BDEVNAME_SIZE];
 
 	if (!capable(CAP_SYS_ADMIN))
 		return -EACCES;
@@ -30,6 +31,8 @@ static int blkpg_ioctl(struct block_devi
 	part = p.pno;
 	if (part <= 0 || part >= disk->minors)
 		return -EINVAL;
+	printk("blkpg_ioctl: %s called %d on %s\n",
+	       current->comm, a.op, bdevname(bdev, b));
 	switch (a.op) {
 		case BLKPG_ADD_PARTITION:
 			start = p.start >> 9;


