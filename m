Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A8B8C433F5
	for <linux-raid@archiver.kernel.org>; Fri, 24 Sep 2021 15:34:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D42F561212
	for <linux-raid@archiver.kernel.org>; Fri, 24 Sep 2021 15:34:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347127AbhIXPf5 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 24 Sep 2021 11:35:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347105AbhIXPf4 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 24 Sep 2021 11:35:56 -0400
Received: from mout-p-101.mailbox.org (mout-p-101.mailbox.org [IPv6:2001:67c:2050::465:101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A64FC061571;
        Fri, 24 Sep 2021 08:34:21 -0700 (PDT)
Received: from smtp1.mailbox.org (smtp1.mailbox.org [80.241.60.240])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mout-p-101.mailbox.org (Postfix) with ESMTPS id 4HGGKj3jvmzQjv5;
        Fri, 24 Sep 2021 17:34:17 +0200 (CEST)
X-Virus-Scanned: amavisd-new at heinlein-support.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=chianterastutte.eu;
        s=MBO0001; t=1632497655;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=wfWagMPk1x7o5qHgvk7iojdPBkH3vg5ME/V2igYnNnQ=;
        b=gm7l1gJhxXQH1IjiLC9UMNuN0i4tUBvnUVXGxzqIcO7F1yaX2VdUqsRxasobaCyUnoERJN
        HWmvIT2ekDQvTJ7RcB4uhk+fQ9XgoCVskK/rdIRhjD7kzh/TrHDHYhzHUPVENc43d91IZQ
        F4yU/V5SzQKkTOs87B5ChSYaqb6XCNX4xqcDnai5Z51ul4fsTPh+okNFlKlz+DXKSx2iK4
        cddj5a9MJKCiRm+nLlofRPQNViEvLYEReFaEGEJV5RFKLC1Rpet28GgYyZ9H4V9Et43c6l
        AXaj+B49W90DnFxVXZZSYzNM3WzLm2nGbIkND/8NgXrFWuldPlIRMk9AGT6Rjg==
Subject: Re: [PATCH] raid1: ensure bio doesn't have more than BIO_MAX_VECS
 sectors
To:     Ming Lei <ming.lei@redhat.com>,
        Christoph Hellwig <hch@infradead.org>
Cc:     Guoqing Jiang <guoqing.jiang@linux.dev>, song@kernel.org,
        linux-raid@vger.kernel.org, linux-block@vger.kernel.org
References: <20210813060510.3545109-1-guoqing.jiang@linux.dev>
 <YRYj8A+mDfAQBo/E@infradead.org>
 <0eac4589-ffd2-fb1a-43cc-87722731438a@linux.dev>
 <YRd26VGAnBiYeHrH@infradead.org> <YReFYrjtWr9MvfBr@T590>
 <YRox8gMjl/Y5Yt/k@infradead.org> <YRpOwFewTw4imskn@T590>
 <YRtDxEw7Zp2H7mxp@infradead.org> <YRusakafZq0NMqLe@T590>
From:   "Jens Stutte (Archiv)" <jens@chianterastutte.eu>
Message-ID: <cc91ef81-bf25-cee6-018f-2f79c7a183ae@chianterastutte.eu>
Date:   Fri, 24 Sep 2021 17:34:11 +0200
MIME-Version: 1.0
In-Reply-To: <YRusakafZq0NMqLe@T590>
Content-Type: multipart/mixed;
 boundary="------------9787683D99516DF32025A395"
Content-Language: en-US
X-Rspamd-Queue-Id: 4534F188C
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

This is a multi-part message in MIME format.
--------------9787683D99516DF32025A395
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit

Hi all,

I just had the occasion to test the new patch as landed in arch linux 
5.14.7. Unfortunately it does not work for me. Attached you can find a 
modification that works for me, though I am not really sure why 
write_behind seems not to be set to true on my configuration. If there 
is any more data I can provide to help you to investigate, please let me 
know.

Thanks for any clues,

Jens

My configuration:

[root@vdr jens]# mdadm --detail -v /dev/md0
/dev/md0:
            Version : 1.2
      Creation Time : Fri Dec 26 09:50:53 2014
         Raid Level : raid1
         Array Size : 1953381440 (1862.89 GiB 2000.26 GB)
      Used Dev Size : 1953381440 (1862.89 GiB 2000.26 GB)
       Raid Devices : 2
      Total Devices : 2
        Persistence : Superblock is persistent

      Intent Bitmap : Internal

        Update Time : Fri Sep 24 17:30:51 2021
              State : active
     Active Devices : 2
    Working Devices : 2
     Failed Devices : 0
      Spare Devices : 0

Consistency Policy : bitmap

               Name : vdr:0  (local to host vdr)
               UUID : 5532ffda:ccbc790f:b50c4959:8f0fd43f
             Events : 32805

     Number   Major   Minor   RaidDevice State
        2       8       33        0      active sync   /dev/sdc1
        3       8       17        1      active sync   /dev/sdb1

[root@vdr jens]# mdadm -X /dev/sdb1
         Filename : /dev/sdb1
            Magic : 6d746962
          Version : 4
             UUID : 5532ffda:ccbc790f:b50c4959:8f0fd43f
           Events : 32804
   Events Cleared : 32804
            State : OK
        Chunksize : 64 MB
           Daemon : 5s flush period
       Write Mode : Allow write behind, max 4096
        Sync Size : 1953381440 (1862.89 GiB 2000.26 GB)
           Bitmap : 29807 bits (chunks), 3 dirty (0.0%)

[root@vdr jens]# mdadm -X /dev/sdc1
         Filename : /dev/sdc1
            Magic : 6d746962
          Version : 4
             UUID : 5532ffda:ccbc790f:b50c4959:8f0fd43f
           Events : 32804
   Events Cleared : 32804
            State : OK
        Chunksize : 64 MB
           Daemon : 5s flush period
       Write Mode : Allow write behind, max 4096
        Sync Size : 1953381440 (1862.89 GiB 2000.26 GB)
           Bitmap : 29807 bits (chunks), 3 dirty (0.0%)

Am 17.08.21 um 14:32 schrieb Ming Lei:
> On Tue, Aug 17, 2021 at 06:06:12AM +0100, Christoph Hellwig wrote:
>> On Mon, Aug 16, 2021 at 07:40:48PM +0800, Ming Lei wrote:
>>>>> 0 ~ 254: each bvec's length is 512
>>>>> 255: bvec's length is 8192
>>>>>
>>>>> the total length is just 512*255 + 8192 = 138752 bytes = 271 sectors, but it
>>>>> still may need 257 bvecs, which can't be allocated via bio_alloc_bioset().
>>>> Yes, we still need the rounding magic that alloc_behind_master_bio uses
>>>> here.
>>> But it is wrong to use max sectors to limit number of bvecs(segments), isn't it?
>> The raid1 write behind code cares about the size ofa bio it can reach by
>> adding order 0 pages to it.  The bvecs are part of that and I think the
>> calculation in the patch documents that a well.
> Thinking of further, your and Guoqing's patch are correct & enough since
> bio_copy_data() just copies bytes(sectors) stream from fs bio to the
> write behind bio.
>
>
> Thanks,
> Ming
>

--------------9787683D99516DF32025A395
Content-Type: text/x-patch; charset=UTF-8;
 name="raid1.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="raid1.patch"

diff --unified --recursive --text archlinux-linux/drivers/md/raid1.c archlinux-linux-diff/drivers/md/raid1.c
--- archlinux-linux/drivers/md/raid1.c	2021-09-24 14:37:15.347771866 +0200
+++ archlinux-linux-diff/drivers/md/raid1.c	2021-09-24 14:40:02.443978319 +0200
@@ -1501,7 +1501,7 @@
 			 * Not if there are too many, or cannot
 			 * allocate memory, or a reader on WriteMostly
 			 * is waiting for behind writes to flush */
-			if (bitmap &&
+			if (bitmap && write_behind &&
 			    (atomic_read(&bitmap->behind_writes)
 			     < mddev->bitmap_info.max_write_behind) &&
 			    !waitqueue_active(&bitmap->behind_wait)) {
diff --unified --recursive --text archlinux-linux/drivers/md/raid1.c archlinux-linux-changed/drivers/md/raid1.c
--- archlinux-linux/drivers/md/raid1.c	2021-09-24 15:43:22.842680119 +0200
+++ archlinux-linux-changed/drivers/md/raid1.c	2021-09-24 15:43:59.426142955 +0200
@@ -1329,7 +1329,6 @@
 	struct raid1_plug_cb *plug = NULL;
 	int first_clone;
 	int max_sectors;
-	bool write_behind = false;
 
 	if (mddev_is_clustered(mddev) &&
 	     md_cluster_ops->area_resyncing(mddev, WRITE,
@@ -1383,14 +1382,6 @@
 	for (i = 0;  i < disks; i++) {
 		struct md_rdev *rdev = rcu_dereference(conf->mirrors[i].rdev);
 
-		/*
-		 * The write-behind io is only attempted on drives marked as
-		 * write-mostly, which means we could allocate write behind
-		 * bio later.
-		 */
-		if (rdev && test_bit(WriteMostly, &rdev->flags))
-			write_behind = true;
-
 		if (rdev && unlikely(test_bit(Blocked, &rdev->flags))) {
 			atomic_inc(&rdev->nr_pending);
 			blocked_rdev = rdev;
@@ -1470,7 +1461,7 @@
 	 * at a time and thus needs a new bio that can fit the whole payload
 	 * this bio in page sized chunks.
 	 */
-	if (write_behind && bitmap)
+	if (bitmap)
 		max_sectors = min_t(int, max_sectors,
 				    BIO_MAX_VECS * (PAGE_SIZE >> 9));
 	if (max_sectors < bio_sectors(bio)) {
@@ -1501,7 +1492,7 @@
 			 * Not if there are too many, or cannot
 			 * allocate memory, or a reader on WriteMostly
 			 * is waiting for behind writes to flush */
-			if (bitmap &&
+			if (bitmap && 
 			    (atomic_read(&bitmap->behind_writes)
 			     < mddev->bitmap_info.max_write_behind) &&
 			    !waitqueue_active(&bitmap->behind_wait)) {

--------------9787683D99516DF32025A395--
