Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35D00C197A0
	for <linux-raid@archiver.kernel.org>; Fri, 17 Nov 2023 01:05:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345608AbjKQBFb (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 16 Nov 2023 20:05:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbjKQBFa (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 16 Nov 2023 20:05:30 -0500
Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99B3C182
        for <linux-raid@vger.kernel.org>; Thu, 16 Nov 2023 17:05:26 -0800 (PST)
Received: from mail.maildlp.com (unknown [172.19.163.235])
        by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4SWdxD6kLNz4f3kkD
        for <linux-raid@vger.kernel.org>; Fri, 17 Nov 2023 09:05:20 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.112])
        by mail.maildlp.com (Postfix) with ESMTP id 7F92F1A0173
        for <linux-raid@vger.kernel.org>; Fri, 17 Nov 2023 09:05:23 +0800 (CST)
Received: from [10.174.176.73] (unknown [10.174.176.73])
        by APP1 (Coremail) with SMTP id cCh0CgDnNw5RvFZlnWeFBA--.9623S3;
        Fri, 17 Nov 2023 09:05:23 +0800 (CST)
Subject: Re: [REGRESSION] Data read from a degraded RAID 4/5/6 array could be
 silently corrupted.
To:     Song Liu <song@kernel.org>,
        Bhanu Victor DiCara <00bvd0+linux@gmail.com>,
        Xiao Ni <xni@redhat.com>,
        Mateusz Grzonka <mateusz.grzonka@intel.com>
Cc:     linux-raid@vger.kernel.org, regressions@lists.linux.dev,
        jiangguoqing@kylinos.cn, jgq516@gmail.com,
        "yukuai (C)" <yukuai3@huawei.com>
References: <5727380.DvuYhMxLoT@bvd0>
 <CAPhsuW4+Ktd7mzTQ6M4n9-=8vgyMDJUi8Xkcv50JXTf_2yqTFA@mail.gmail.com>
From:   Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <1956a189-107b-4445-9e53-336f1533c4b9@huaweicloud.com>
Date:   Fri, 17 Nov 2023 09:05:21 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <CAPhsuW4+Ktd7mzTQ6M4n9-=8vgyMDJUi8Xkcv50JXTf_2yqTFA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: cCh0CgDnNw5RvFZlnWeFBA--.9623S3
X-Coremail-Antispam: 1UD129KBjvJXoWxuryUJF4rGw4DXryUAr4Utwb_yoWrXF17pa
        y7AF1Y9rZ8JF45WryDC3W8W3WrKrZFvrWjgry8X34xAFn8Zr1avrZ7KrZ09F95Jr4fWw12
        va15Xr9rWFWqkFJanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUyEb4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k2
        6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
        vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7Cj
        xVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x
        0267AKxVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG
        6I80ewAv7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFV
        Cjc4AY6r1j6r4UM4x0Y48IcVAKI48JMxk0xIA0c2IEe2xFo4CEbIxvr21l42xK82IYc2Ij
        64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x
        8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r43MIIYrxkI7VAKI48JMIIF0xvE
        2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r1j6r4UMIIF0xvE42
        xK8VAvwI8IcIk0rVWrZr1j6s0DMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIE
        c7CjxVAFwI0_Jr0_GrUvcSsGvfC2KfnxnUUI43ZEXa7IU1zuWJUUUUU==
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi,

在 2023/11/17 0:24, Song Liu 写道:
> + more folks.
> 
> On Fri, Nov 10, 2023 at 7:00 PM Bhanu Victor DiCara
> <00bvd0+linux@gmail.com> wrote:
>>
>> A degraded RAID 4/5/6 array can sometimes read 0s instead of the actual data.
>>
>>
>> #regzbot introduced: 10764815ff4728d2c57da677cd5d3dd6f446cf5f
>> (The problem does not occur in the previous commit.)
>>
>> In commit 10764815ff4728d2c57da677cd5d3dd6f446cf5f, file drivers/md/raid5.c, line 5808, there is `md_account_bio(mddev, &bi);`. When this line (and the previous line) is removed, the problem does not occur.
> 
> The patch below should fix it. Please give it more thorough tests and
> let me know whether it fixes everything. I will send patch later with
> more details.
> 
> Thanks,
> Song
> 
> diff --git i/drivers/md/md.c w/drivers/md/md.c
> index 68f3bb6e89cb..d4fb1aa5c86f 100644
> --- i/drivers/md/md.c
> +++ w/drivers/md/md.c
> @@ -8674,7 +8674,8 @@ static void md_end_clone_io(struct bio *bio)
>          struct bio *orig_bio = md_io_clone->orig_bio;
>          struct mddev *mddev = md_io_clone->mddev;
> 
> -       orig_bio->bi_status = bio->bi_status;
> +       if (bio->bi_status)
> +               orig_bio->bi_status = bio->bi_status;

I'm confused, do you mean that orig_bio can have error while bio
doesn't? If this is the case, can you explain more how this is
possible?

Thanks,
Kuai

> 
>          if (md_io_clone->start_time)
>                  bio_end_io_acct(orig_bio, md_io_clone->start_time);
> 
> 
>>
>> Similarly, in commit ffc253263a1375a65fa6c9f62a893e9767fbebfa (v6.6), file drivers/md/raid5.c, when line 6200 is removed, the problem does not occur.
>>
>>
>> Steps to reproduce the problem (using bash or similar):
>> 1. Create a degraded RAID 4/5/6 array:
>> fallocate -l 2056M test_array_part_1.img
>> fallocate -l 2056M test_array_part_2.img
>> lo1=$(losetup --sector-size 4096 --find --nooverlap --direct-io --show  test_array_part_1.img)
>> lo2=$(losetup --sector-size 4096 --find --nooverlap --direct-io --show  test_array_part_2.img)
>> # The RAID level must be 4 or 5 or 6 with at least 1 missing drive in any order. The following configuration seems to be the most effective:
>> mdadm --create /dev/md/tmp_test_array --level=4 --raid-devices=3 --chunk=1M --size=2G  $lo1 missing $lo2
>>
>> 2. Create the test file system and clone it to the degraded array:
>> fallocate -l 4G test_fs.img
>> mke2fs -t ext4 -b 4096 -i 65536 -m 0 -E stride=256,stripe_width=512 -L test_fs  test_fs.img
>> lo3=$(losetup --sector-size 4096 --find --nooverlap --direct-io --show  test_fs.img)
>> mount $lo3 /mnt/1
>> python3 create_test_fs.py /mnt/1
>> umount /mnt/1
>> cat test_fs.img > /dev/md/tmp_test_array
>> cmp -l test_fs.img /dev/md/tmp_test_array  # Optionally verify the clone
>> mount --read-only $lo3 /mnt/1
>>
>> 3. Mount the degraded array:
>> mount --read-only /dev/md/tmp_test_array /mnt/2
>>
>> 4. Compare the files:
>> diff -q /mnt/1 /mnt/2
>>
>> If no files are detected as different, do `umount /mnt/2` and `echo 2 > /proc/sys/vm/drop_caches`, and then go to step 3.
>> (Doing `echo 3 > /proc/sys/vm/drop_caches` and then going to step 4 is less effective.)
>> (Only doing `umount /mnt/2` and/or `echo 1 > /proc/sys/vm/drop_caches` is much less effective and the effectiveness wears off.)
>>
>>
>> create_test_fs.py:
>> import errno
>> import itertools
>> import os
>> import random
>> import sys
>>
>>
>> def main(test_fs_path):
>>          rng = random.Random(0)
>>          try:
>>                  for i in itertools.count():
>>                          size = int(2**rng.uniform(12, 24))
>>                          with open(os.path.join(test_fs_path, str(i).zfill(4) + '.bin'), 'xb') as f:
>>                                  f.write(b'\xff' * size)
>>                          print(f'Created file {f.name!r} with size {size}')
>>          except OSError as e:
>>                  if e.errno != errno.ENOSPC:
>>                          raise
>>                  print(f'Done: {e.strerror} (partially created file {f.name!r})')
>>
>>
>> if __name__ == '__main__':
>>          main(sys.argv[1])
>>
>>
>>
> .
> 

