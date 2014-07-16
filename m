From: Eivind Sarto <eivindsarto@gmail.com>
Subject: [patch 1/1] raid0: prevent unaligned discard requests
Date: Wed, 16 Jul 2014 12:04:01 -0700
Message-ID: <0B8EAC15-8427-45AC-A614-7A7B9D567923@gmail.com>
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.6\))
Content-Type: multipart/mixed; boundary="Apple-Mail=_817BFFF8-B21F-4045-9D38-4BBDC38703BC"
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org, NeilBrown <neilb@suse.de>
List-Id: linux-raid.ids


--Apple-Mail=_817BFFF8-B21F-4045-9D38-4BBDC38703BC
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

This is a simple patch that prevents blkdev_issue_discard() from issuing =
mis-aligned REQ_DISCARD to raid0.
Currently, raid0 only sets max_discard_sectors equal to chunk size.  But =
that will only break a larger discard request
into multiple chunk sized requests.  It will not align those requests.  =
If the original (big) request is not chunk-aligned,
blkdev_issue_discard() will issue mis-aligned chunk-sized discards to =
raid0, and raid0 will have to split them all.
The patch comment had example block traces that illustrates the problem.



--Apple-Mail=_817BFFF8-B21F-4045-9D38-4BBDC38703BC
Content-Disposition: attachment;
	filename=raid0_prevent_unaligned_discard_requests.patch
Content-Type: application/octet-stream;
	name="raid0_prevent_unaligned_discard_requests.patch"
Content-Transfer-Encoding: 7bit

Author: Eivind Sarto <esarto@fusionio.com>
Date: Tue Jun  3 14:07:29 2014

raid0: prevent unaligned discard requests

Raid0 sets max_discard_sectors equal to chunk_size.  However, that does
make blkdev_issue_discard() to issue chunk-aligned REQ_DISCARD to raid0.
If blkdev_issue_discard() is called with a non-chunk-aligned sector, it will
break the request into multiple chunk-sized bio requests, but all the bio
requests to raid0 will stay mis-aligned (and raid0 will need to split them all).

This patch sets the device queue discard granularity.
It will make blkdev_issue_discard() always break REQ_DISCARD requests into
aligned requests to raid0, after the first partial/mis-aligned request has been
issued.

Here is a trace of a discard request to a raid0 with a 32k chunk, before and 
after the patch.
Before: # blkdiscard -v -l 131072 -o 8192 /dev/md0
  9,0    0        1     0.000000000 16681  Q   D 16 + 64 [blkdiscard]
  9,0    0        2     0.000001780 16681  X   D 16 / 64 [blkdiscard]
  9,0    0        3     0.000040254 16681  Q   D 80 + 64 [blkdiscard]
  9,0    0        4     0.000040726 16681  X   D 80 / 128 [blkdiscard]
  9,0    0        5     0.000060695 16681  Q   D 144 + 64 [blkdiscard]
  9,0    0        6     0.000060971 16681  X   D 144 / 192 [blkdiscard]
  9,0    0        7     0.000072825 16681  Q   D 208 + 64 [blkdiscard]
  9,0    0        8     0.000073059 16681  X   D 208 / 256 [blkdiscard]
After: # blkdiscard -v -l 131072 -o 8192 /dev/md0
  9,0    0        1     3.681411377 13326  Q   D 16 + 48 [blkdiscard]
  9,0    0        2     3.681441401 13326  Q   D 64 + 64 [blkdiscard]
  9,0    0        3     3.681450093 13326  Q   D 128 + 64 [blkdiscard]
  9,0    0        4     3.681455989 13326  Q   D 192 + 64 [blkdiscard]
  9,0    0        5     3.681474018 13326  Q   D 256 + 16 [blkdiscard]

Signed-off-by: Eivind Sarto <esarto@fusionio.com>

--- a/drivers/md/raid0.c	2014-06-02 11:26:29.000000000 -0700
+++ b/drivers/md/raid0.c	2014-06-03 11:56:05.000000000 -0700
@@ -440,6 +440,8 @@ static int raid0_run(struct mddev *mddev
 	blk_queue_max_hw_sectors(mddev->queue, mddev->chunk_sectors);
 	blk_queue_max_write_same_sectors(mddev->queue, mddev->chunk_sectors);
 	blk_queue_max_discard_sectors(mddev->queue, mddev->chunk_sectors);
+	/* prevent unaligned discard requests */
+	mddev->queue->limits.discard_granularity = mddev->chunk_sectors << 9;
 
 	/* if private is not null, we are here after takeover */
 	if (mddev->private == NULL) {

--Apple-Mail=_817BFFF8-B21F-4045-9D38-4BBDC38703BC--
