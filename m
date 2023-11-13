Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59B61C4332F
	for <linux-raid@archiver.kernel.org>; Mon, 13 Nov 2023 00:53:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232657AbjKMAxd (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sun, 12 Nov 2023 19:53:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231316AbjKMAxc (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sun, 12 Nov 2023 19:53:32 -0500
Received: from lists.tip.net.au (pasta.tip.net.au [203.10.76.2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E14D1BC0
        for <linux-raid@vger.kernel.org>; Sun, 12 Nov 2023 16:53:28 -0800 (PST)
Received: from lists.tip.net.au (pasta.tip.net.au [IPv6:2401:fc00:0:129::2])
        by mailhost.tip.net.au (Postfix) with ESMTP id 4ST9sJ672Cz9Qyr
        for <linux-raid@vger.kernel.org>; Mon, 13 Nov 2023 11:53:24 +1100 (AEDT)
Received: from [192.168.2.7] (unknown [101.115.9.238])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mailhost.tip.net.au (Postfix) with ESMTPSA id 4ST9sJ5WXMz9Qyn
        for <linux-raid@vger.kernel.org>; Mon, 13 Nov 2023 11:53:24 +1100 (AEDT)
Message-ID: <1d0fb40a-1908-4b5e-9856-a5b79eafdc9c@eyal.emu.id.au>
Date:   Mon, 13 Nov 2023 11:53:21 +1100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: extremely slow writes to array [now not degraded]
Content-Language: en-US
To:     linux-raid@vger.kernel.org
References: <eb9a7323-f955-4b1c-b1c4-7f0723078c42@eyal.emu.id.au>
 <e25d99ef-89e2-4cba-92ae-4bbe1506a1e4@eyal.emu.id.au>
 <CAAMCDedC-Rgrd_7R8kpzA5CV1nA_mZaibUL7wGVGJS3tVbyK=w@mail.gmail.com>
From:   eyal@eyal.emu.id.au
In-Reply-To: <CAAMCDedC-Rgrd_7R8kpzA5CV1nA_mZaibUL7wGVGJS3tVbyK=w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Are there any devs, experts in this area, that can chime in?
I can provide more information (see the start of array details).

Was the array assembled badly? This is the only change from when it worked well.
FYI:
	About a week ago, when the array was degraded, the machine crashed.
	The array was revived (--assemble --force) and looked good (clean fsck).
	Later the missing disk was added. No errors.

On 10/11/2023 00.16, Roger Heflin wrote:
> The issue he is asking about is why does the md127 device have a
> w_await time of 1473.96ms when the highest response time on the
> underlying device is 15.94ms.  %util of all devices is low.
> 
> Something has to be going on inside the kernel to cause there to be
> that sort of a difference.
> 
> He is also doing about 3 io/second which is significantly under the
> capacity of a spinning disk.
> 
> If a disk was having issues with bad sectors/failed sectors/silent
> retries then the %util/awaits should show that.
> 
> So between when the write gets to the md  device and when the io gets
> to the physical device there are 1000+ ms (on average).
> 
> And this is a typical sample that is being seen when the array is not
> functioning fast, and this issue clears (all by itself) some minutes
> or hours later and continues as if nothing happened.

I think that this is the crux of the problem. I keep a log of iostat and meminfo
and I see this happening all the time.

I understand that writing a tree full of many, very small files is an issue for ext4 but at the level of
the cache we are past this, we simply have a list of blocks that need to be written out.

The cache is supposed to offer an opportunity to coalesce small writes, and since the whole tree is
small I expect it to end up with a reasonably small number of blocks.

Q1 >>>>> Do I have a wrong setting for some queuing? Maybe some rate limiting?

One caveat: the whole fs was copied from a 20TB array to a new 60TB array 5 years ago, and now has 10TB free,
so there was activity all the time (mostly large mythtv recordings) and free space is now probably somewhat fragmented.

Below is one example run.

Q2 >>>>> Does it look like a problem with the: cache? md? disks?

Q3 >>>>> Look at the meminfo log. The last 12MB (very end of this posting) were written out in 1 second.
	 So the system CAN do this when it wants to. WHAT GIVES??

The source
==========
$ sudo find /data2/no-backup/old-backups/tapes/12/file.4.data |wc -l
19533
$ sudo du -sm /data2/no-backup/old-backups/tapes/12/file.4.data
321     /data2/no-backup/old-backups/tapes/12/file.4.data

The target
==========
$ sudo find /data1/no-backup/old-backups/tapes/12/file.4.data |wc -l
19533
$ sudo du -sm /data1/no-backup/old-backups/tapes/12/file.4.data
245     /data1/no-backup/old-backups/tapes/12/file.4.data

The copy
========
$ sudo rsync -aHSK --stats --progress --checksum-choice=none --no-compress -W /data2/no-backup/old-backups/tapes/12/file.4.data /data1/no-backup/old-backups/tapes-again/12/
	## I expect some options are probably not required
Number of files: 23,208 (reg: 21,586, dir: 1,617, link: 5)
Number of created files: 23,208 (reg: 21,586, dir: 1,617, link: 5)
Number of deleted files: 0
Number of regular files transferred: 21,453
Total file size: 284,010,162 bytes
Total transferred file size: 283,755,872 bytes
Literal data: 283,755,872 bytes
Matched data: 0 bytes
File list size: 131,067
File list generation time: 0.001 seconds
File list transfer time: 0.000 seconds
Total bytes sent: 284,848,197
Total bytes received: 430,683
sent 284,848,197 bytes  received 430,683 bytes  38,037,184.00 bytes/sec
total size is 284,010,162  speedup is 1.00
	## The copy took only a few of seconds.

Draining the dirty blocks. It took just under 3 hours!
Zooming into the data:

2023-11-13 11:16:11 Dirty:     12012 kB  Buffers:    178292 kB  MemFree:    756872 kB
2023-11-13 11:16:12 Dirty:     12008 kB  Buffers:    178292 kB  MemFree:    760332 kB
2023-11-13 11:16:13 Dirty:        12 kB  Buffers:    178300 kB  MemFree:    756152 kB


meminfo
=======
2023-11-13 08:27:15 Dirty:        32 kB  Buffers:   1029000 kB  MemFree:    870192 kB
2023-11-13 08:27:25 Dirty:    140448 kB  Buffers:   1039564 kB  MemFree:    674356 kB
2023-11-13 08:27:35 Dirty:    327736 kB  Buffers:   1049404 kB  MemFree:    613680 kB
2023-11-13 08:27:45 Dirty:    325024 kB  Buffers:   1049436 kB  MemFree:    643332 kB
2023-11-13 08:27:55 Dirty:    324972 kB  Buffers:   1049460 kB  MemFree:    655180 kB
...
2023-11-13 11:15:49 Dirty:     12916 kB  Buffers:    178196 kB  MemFree:    725476 kB
2023-11-13 11:15:59 Dirty:     12824 kB  Buffers:    178240 kB  MemFree:    725776 kB
2023-11-13 11:16:09 Dirty:     12016 kB  Buffers:    178292 kB  MemFree:    758076 kB
2023-11-13 11:16:19 Dirty:       116 kB  Buffers:    178316 kB  MemFree:    752152 kB

Since the start of the copy, a kworker flush thread is running:

     PID USER      PR  NI    VIRT    RES    SHR S  %CPU  %MEM     TIME+ COMMAND
2351470 root      20   0       0      0      0 R 100.0   0.0  73:28.06 kworker/u16:1+flush-9:127

disks activity
==============

Activity on the array, low wkB/s, high w_await
On a clear day the array tops 600MB/s

          Device            r/s     rkB/s   rrqm/s  %rrqm r_await rareq-sz     w/s     wkB/s   wrqm/s  %wrqm w_await wareq-sz     d/s     dkB/s   drqm/s  %drqm d_await dareq-sz     f/s f_await  aqu-sz  %util
08:32:49 md127            0.10      0.40     0.00   0.00   18.00     4.00    1.70      9.60     0.00   0.00 1316.47     5.65    0.00      0.00     0.00   0.00    0.00     0.00    0.00    0.00    2.24   6.62
08:32:59 md127            0.00      0.00     0.00   0.00    0.00     0.00    3.00     63.60     0.00   0.00 1280.20    21.20    0.00      0.00     0.00   0.00    0.00     0.00    0.00    0.00    3.84   5.32
08:33:09 md127            0.00      0.00     0.00   0.00    0.00     0.00    0.60      2.40     0.00   0.00   17.33     4.00    0.00      0.00     0.00   0.00    0.00     0.00    0.00    0.00    0.01  11.60
08:33:19 md127            0.00      0.00     0.00   0.00    0.00     0.00    3.40     35.20     0.00   0.00 5774.44    10.35    0.00      0.00     0.00   0.00    0.00     0.00    0.00    0.00   19.63  10.00
08:33:29 md127            0.20      0.80     0.00   0.00   15.00     4.00   25.30    320.40     0.00   0.00 3751.42    12.66    0.00      0.00     0.00   0.00    0.00     0.00    0.00    0.00   94.91   6.70
08:33:39 md127            0.00      0.00     0.00   0.00    0.00     0.00    2.70     10.80     0.00   0.00  803.52     4.00    0.00      0.00     0.00   0.00    0.00     0.00    0.00    0.00    2.17   4.49
08:33:49 md127            0.00      0.00     0.00   0.00    0.00     0.00    2.70     10.80     0.00   0.00 1415.26     4.00    0.00      0.00     0.00   0.00    0.00     0.00    0.00    0.00    3.82  10.47
08:33:59 md127            0.40      1.60     0.00   0.00    9.75     4.00    3.30     70.80     0.00   0.00 1156.67    21.45    0.00      0.00     0.00   0.00    0.00     0.00    0.00    0.00    3.82   9.92
08:34:09 md127            0.00      0.00     0.00   0.00    0.00     0.00    3.80     97.20     0.00   0.00 1175.97    25.58    0.00      0.00     0.00   0.00    0.00     0.00    0.00    0.00    4.47   8.48

Activity on a member (all 7 are similar), low wkB/s, low w_await
On a clear day each member tops 200MB/s

          Device            r/s     rkB/s   rrqm/s  %rrqm r_await rareq-sz     w/s     wkB/s   wrqm/s  %wrqm w_await wareq-sz     d/s     dkB/s   drqm/s  %drqm d_await dareq-sz     f/s f_await  aqu-sz  %util
08:32:49 sdb              0.00      0.00     0.00   0.00    0.00     0.00    1.00      2.20     0.00   0.00    2.20     2.20    0.00      0.00     0.00   0.00    0.00     0.00    1.00    1.90    0.00   0.32
08:32:59 sdb              0.40     42.40    10.20  96.23    4.00   106.00    1.90     46.20    10.20  84.30    4.47    24.32    0.00      0.00     0.00   0.00    0.00     0.00    1.40    4.29    0.02   0.75
08:33:09 sdb              0.00      0.00     0.00   0.00    0.00     0.00    0.20      0.40     0.00   0.00    0.50     2.00    0.00      0.00     0.00   0.00    0.00     0.00    0.20    0.00    0.00   0.03
08:33:19 sdb              0.10     30.80     7.60  98.70   19.00   308.00    0.80     32.10     7.60  90.48    6.62    40.12    0.00      0.00     0.00   0.00    0.00     0.00    0.70    7.29    0.01   0.60
08:33:29 sdb              0.10      3.20     0.70  87.50    0.00    32.00    2.20     85.00    19.60  89.91    3.05    38.64    0.00      0.00     0.00   0.00    0.00     0.00    1.40    2.86    0.01   0.69
08:33:39 sdb              0.00      0.00     0.00   0.00    0.00     0.00    0.70      1.70     0.00   0.00    1.00     2.43    0.00      0.00     0.00   0.00    0.00     0.00    0.70    0.86    0.00   0.12
08:33:49 sdb              0.00      0.00     0.00   0.00    0.00     0.00    1.40      3.40     0.00   0.00    2.79     2.43    0.00      0.00     0.00   0.00    0.00     0.00    1.30    2.54    0.01   0.47
08:33:59 sdb              0.30     58.80    14.40  97.96   11.67   196.00    1.30     61.30    14.40  91.72    3.15    47.15    0.00      0.00     0.00   0.00    0.00     0.00    1.00    2.10    0.01   0.51
08:34:09 sdb              0.10      7.20     1.70  94.44    4.00    72.00    1.50      4.20     0.10   6.25    5.13     2.80    0.00      0.00     0.00   0.00    0.00     0.00    1.40    5.07    0.02   0.89

Here is the iostat -x covering the last second. A good burp!

          Device            r/s     rkB/s   rrqm/s  %rrqm r_await rareq-sz     w/s     wkB/s   wrqm/s  %wrqm w_await wareq-sz     d/s     dkB/s   drqm/s  %drqm d_await dareq-sz     f/s f_await  aqu-sz  %util
11:16:20 md127            0.00      0.00     0.00   0.00    0.00     0.00  300.90   1258.00     0.00   0.00  515.35     4.18    0.00      0.00     0.00   0.00    0.00     0.00    0.00    0.00  155.07  11.13
11:16:20 sdb              8.40    298.40    66.20  88.74  131.21    35.52   15.80    435.35    93.50  85.54   32.25    27.55    0.00      0.00     0.00   0.00    0.00     0.00    1.30    7.38    1.62   2.92
11:16:20 sdc              9.80    338.80    74.90  88.43  126.00    34.57   19.70    598.55   130.40  86.88   50.57    30.38    0.00      0.00     0.00   0.00    0.00     0.00    1.30   15.92    2.25   4.05
11:16:20 sdd             12.60    425.60    93.80  88.16  249.92    33.78   19.90    640.95   140.80  87.62   56.86    32.21    0.00      0.00     0.00   0.00    0.00     0.00    1.30   24.15    4.31   5.44
11:16:20 sde             12.60    368.80    79.60  86.33  211.07    29.27   17.80    475.35   101.50  85.08   99.42    26.71    0.00      0.00     0.00   0.00    0.00     0.00    1.30   24.38    4.46   6.38
11:16:20 sdf              8.30    303.60    67.60  89.06  129.25    36.58   10.90    329.35    71.90  86.84   36.05    30.22    0.00      0.00     0.00   0.00    0.00     0.00    1.30   18.38    1.49   6.32
11:16:20 sdg              9.50    256.80    54.70  85.20  108.25    27.03   13.60    300.95    62.10  82.03   13.79    22.13    0.00      0.00     0.00   0.00    0.00     0.00    1.30    8.00    1.23   4.73
11:16:20 sdh              9.20    232.40    48.90  84.17  241.24    25.26   16.80    247.35    45.50  73.03   65.06    14.72    0.00      0.00     0.00   0.00    0.00     0.00    1.30   18.38    3.34   5.86

TIA

-- 
Eyal at Home (eyal@eyal.emu.id.au)

