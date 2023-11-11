Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3BA21C4332F
	for <linux-raid@archiver.kernel.org>; Sat, 11 Nov 2023 00:00:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229929AbjKKAAL (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 10 Nov 2023 19:00:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229713AbjKKAAK (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 10 Nov 2023 19:00:10 -0500
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4189E3C39
        for <linux-raid@vger.kernel.org>; Fri, 10 Nov 2023 16:00:05 -0800 (PST)
Received: by mail-pf1-x443.google.com with SMTP id d2e1a72fcca58-6c115026985so2671301b3a.1
        for <linux-raid@vger.kernel.org>; Fri, 10 Nov 2023 16:00:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1699660805; x=1700265605; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:sender:from:to:cc:subject:date:message-id:reply-to;
        bh=o7kaP8T4h9GxAv1rdpZ3a0uPOemoQbn+rBlYSoxOFnU=;
        b=R3SX/jLOzBsPBj54lPZG/jNGDbnd/1I8u8M3h0Y39dpBX/FGpDI7DqqPBjQfYKpd2y
         9volWt+ZNuCADkE0lp2Y9RBRRtOfAgXSrBHScBMlFTwt47851039+0FN/C9UbmnqYXsX
         //TOfI+28N2RbJzadcYSm5JZ5K6ikcvK3gksZHmf+fBbpuymDPtGRKSvUMciYANRcKcB
         IBcjj5qFvfuiWJHdawICCYR+SSp12TVg7KLi9Jl7a7dUVOpvYutpCZ9iDQYMzx/HRbdp
         W9Hdqhmp0CaoVZuM2oAUKEccbaRkNNq173YaToZ7AM7ZjdgaL1i0nrZooRNVVshxF8X3
         ia0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699660805; x=1700265605;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:sender:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=o7kaP8T4h9GxAv1rdpZ3a0uPOemoQbn+rBlYSoxOFnU=;
        b=dp+8jjaLVAUvsqi3VDVt66VH752aWkj8tx/n78G/QseX9fEwv97koIOc44Ddii4jwt
         cA81hLVmyYPEXj60sj0u05JfooMEezbPuXXs97Xaw8Hs9WxuNL9cWi+eD9p+eLRz2Qsv
         B0Xo6L93ammN/oL+EBia0PKl+X5uQpPtP/tE8K2N6JmNICh8eAT0ZZ25nvc2ZCQWv6rB
         4w8nUeDXoQEGdv81a7dKeMzaInvZpxQUd+ZHB/cI1uJBW5oIOBh4ewA/8YMvvB9V5MYS
         LKT0wpYiGRRgLvUfOm3LG7UnFSbBU8aDPQmMITS6DXQrQd+HCG4U1pxct7oUpBfBnW2f
         D/uA==
X-Gm-Message-State: AOJu0YwuhTPkME6dah+rczReuXhj5x3Y2oCbZjRKtpH43RZ6tjbPth/H
        f238x8W8caSq1ND/XtxLJ1mxoFQg70V6ZEM8
X-Google-Smtp-Source: AGHT+IHTNf6aZkFIAKZmSoN2cQ0u+j/7iPyq9j1l9V5ExsYYUwjQeVzARU4kSOmI2y50Ss8N84omMQ==
X-Received: by 2002:a05:6a20:1593:b0:17b:426f:829 with SMTP id h19-20020a056a20159300b0017b426f0829mr793932pzj.37.1699660804262;
        Fri, 10 Nov 2023 16:00:04 -0800 (PST)
Received: from bvd0 ([240b:252:381:6800:d42:63f5:5b67:37bd])
        by smtp.gmail.com with ESMTPSA id x66-20020a626345000000b006933f85bc29sm284620pfb.111.2023.11.10.16.00.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Nov 2023 16:00:03 -0800 (PST)
Sender: Bhanu Victor DiCara <00bvd0@gmail.com>
From:   Bhanu Victor DiCara <00bvd0+linux@gmail.com>
To:     linux-raid@vger.kernel.org
Cc:     regressions@lists.linux.dev, song@kernel.org,
        jiangguoqing@kylinos.cn, jgq516@gmail.com
Subject: [REGRESSION] Data read from a degraded RAID 4/5/6 array could be silently
 corrupted.
Date:   Sat, 11 Nov 2023 09:00:00 +0900
Message-ID: <5727380.DvuYhMxLoT@bvd0>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

A degraded RAID 4/5/6 array can sometimes read 0s instead of the actual data.


#regzbot introduced: 10764815ff4728d2c57da677cd5d3dd6f446cf5f
(The problem does not occur in the previous commit.)

In commit 10764815ff4728d2c57da677cd5d3dd6f446cf5f, file drivers/md/raid5.c, line 5808, there is `md_account_bio(mddev, &bi);`. When this line (and the previous line) is removed, the problem does not occur.

Similarly, in commit ffc253263a1375a65fa6c9f62a893e9767fbebfa (v6.6), file drivers/md/raid5.c, when line 6200 is removed, the problem does not occur.


Steps to reproduce the problem (using bash or similar):
1. Create a degraded RAID 4/5/6 array:
fallocate -l 2056M test_array_part_1.img
fallocate -l 2056M test_array_part_2.img
lo1=$(losetup --sector-size 4096 --find --nooverlap --direct-io --show  test_array_part_1.img)
lo2=$(losetup --sector-size 4096 --find --nooverlap --direct-io --show  test_array_part_2.img)
# The RAID level must be 4 or 5 or 6 with at least 1 missing drive in any order. The following configuration seems to be the most effective:
mdadm --create /dev/md/tmp_test_array --level=4 --raid-devices=3 --chunk=1M --size=2G  $lo1 missing $lo2

2. Create the test file system and clone it to the degraded array:
fallocate -l 4G test_fs.img
mke2fs -t ext4 -b 4096 -i 65536 -m 0 -E stride=256,stripe_width=512 -L test_fs  test_fs.img
lo3=$(losetup --sector-size 4096 --find --nooverlap --direct-io --show  test_fs.img)
mount $lo3 /mnt/1
python3 create_test_fs.py /mnt/1
umount /mnt/1
cat test_fs.img > /dev/md/tmp_test_array
cmp -l test_fs.img /dev/md/tmp_test_array  # Optionally verify the clone
mount --read-only $lo3 /mnt/1

3. Mount the degraded array:
mount --read-only /dev/md/tmp_test_array /mnt/2

4. Compare the files:
diff -q /mnt/1 /mnt/2

If no files are detected as different, do `umount /mnt/2` and `echo 2 > /proc/sys/vm/drop_caches`, and then go to step 3.
(Doing `echo 3 > /proc/sys/vm/drop_caches` and then going to step 4 is less effective.)
(Only doing `umount /mnt/2` and/or `echo 1 > /proc/sys/vm/drop_caches` is much less effective and the effectiveness wears off.)


create_test_fs.py:
import errno
import itertools
import os
import random
import sys


def main(test_fs_path):
	rng = random.Random(0)
	try:
		for i in itertools.count():
			size = int(2**rng.uniform(12, 24))
			with open(os.path.join(test_fs_path, str(i).zfill(4) + '.bin'), 'xb') as f:
				f.write(b'\xff' * size)
			print(f'Created file {f.name!r} with size {size}')
	except OSError as e:
		if e.errno != errno.ENOSPC:
			raise
		print(f'Done: {e.strerror} (partially created file {f.name!r})')


if __name__ == '__main__':
	main(sys.argv[1])



