Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CBF1BC4332F
	for <linux-raid@archiver.kernel.org>; Sat,  4 Nov 2023 00:54:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231293AbjKDAye (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 3 Nov 2023 20:54:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229864AbjKDAye (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 3 Nov 2023 20:54:34 -0400
X-Greylist: delayed 357 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 03 Nov 2023 17:54:29 PDT
Received: from lists.tip.net.au (pasta.tip.net.au [IPv6:2401:fc00:0:129::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60596DE
        for <linux-raid@vger.kernel.org>; Fri,  3 Nov 2023 17:54:29 -0700 (PDT)
Received: from lists.tip.net.au (pasta.tip.net.au [IPv6:2401:fc00:0:129::2])
        by mailhost.tip.net.au (Postfix) with ESMTP id 4SMf9m0CHTz9R4J
        for <linux-raid@vger.kernel.org>; Sat,  4 Nov 2023 11:48:28 +1100 (AEDT)
Received: from [IPV6:2405:6e00:494:92f5:21b:21ff:fe3a:5672] (unknown [IPv6:2405:6e00:494:92f5:21b:21ff:fe3a:5672])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mailhost.tip.net.au (Postfix) with ESMTPSA id 4SMf9l3FNVz8swQ
        for <linux-raid@vger.kernel.org>; Sat,  4 Nov 2023 11:48:27 +1100 (AEDT)
Message-ID: <9338d518-b3e6-4c95-bdfb-4815985ea840@eyal.emu.id.au>
Date:   Sat, 4 Nov 2023 11:48:23 +1100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: problem with recovered array
Content-Language: en-US
To:     linux-raid@vger.kernel.org
References: <87273fc6-9531-4072-ae6c-06306e9a269d@eyal.emu.id.au>
 <CAAMCDecjCJz3qPve-54wpd_eX3dTgLYrMVupX6i3JNfBq2mNPw@mail.gmail.com>
 <ZUByq7Wg-KFcXctW@fisica.ufpr.br>
 <577244fc-f43a-4e1f-bf34-d1c194fd90b4@eyal.emu.id.au>
 <CAAMCDedPoNcdacRHNykOtG0yw4mDV3WFpowU1WtoQJgdNAKjDg@mail.gmail.com>
 <0dc5a117-97be-4ed1-9976-1f754a6abf91@eyal.emu.id.au>
 <CAAMCDecobWVOxGOxFt47Y4ZC2JCNVH1T2oQ8X=6BHOz9PemNEQ@mail.gmail.com>
 <37b6265a-b925-4910-b092-59177b639ca9@eyal.emu.id.au>
 <CAAMCDefUcuz2Nzh7AvP9m50uq86ZBK3AhEAEynVG_mmmY_f0jQ@mail.gmail.com>
 <ZUNfK1jqBNsm97Q-@vault.lan> <ZUUA2U88VsGqGDmj@fisica.ufpr.br>
 <CAAMCDec-=vwLJhpi4VfCXdgGactYWeidqmV=VPphGE6eEUxUQg@mail.gmail.com>
 <a7316cd9-af79-4a43-9433-4d62d5166df4@eyal.emu.id.au>
From:   eyal@eyal.emu.id.au
In-Reply-To: <a7316cd9-af79-4a43-9433-4d62d5166df4@eyal.emu.id.au>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 04/11/2023 09.38, eyal@eyal.emu.id.au wrote:
> On 04/11/2023 02.57, Roger Heflin wrote:
>> On Fri, Nov 3, 2023 at 9:17 AM Carlos Carvalho <carlos@fisica.ufpr.br> wrote:
>>>
>>> Johannes Truschnigg (johannes@truschnigg.info) wrote on Thu, Nov 02, 2023 at 05:34:51AM -03:
>>>> for the record, I do not think that any of the observations the OP made can be
>>>> explained by non-pathological phenomena/patterns of behavior. Something is
>>>> very clearly wrong with how this system behaves (the reported figures do not
>>>> at all match the expected performance of even a degraded RAID6 array in my
>>>> experience) and how data written to the filesystem apparently fails to make it
>>>> into the backing devices in acceptable time.
>>>>
>>>> The whole affair reeks either of "subtle kernel bug", or maybe "subtle
>>>> hardware failure", I think.
>>>
>>> Exactly. That's what I've been saying for months...
>>>
>>> I found a clear comparison: expanding the kernel tarball in the SAME MACHINE
>>> with 6.1.61 and 6.5.10. The raid6 array is working normally in both cases. With
>>> 6.1.61 the expansion works fine, finishes with ~100MB of dirty pages and these
>>> are quickly sent to permanent storage. With 6.5.* it finishes with ~1.5GB of
>>> dirty pages that are never sent to disk (I waited ~3h). The disks are idle, as
>>> shown by sar, and the kworker/flushd runs with 100% cpu usage forever.
>>>
>>> Limiting the dirty*bytes in /proc/sys/vm the dirty pages stay low BUT tar is
>>> blocked in D state and the tarball expansion proceeds so slowly that it'd take
>>> days to complete (checked with quota).
>>>
>>> So 6.5 (and 6.4) are unusable in this case. In another machine, which does
>>> hundreds of rsync downloads every day, the same problem exists and I also get
>>> frequent random rsync timeouts.
>>>
>>> This is all with raid6 and ext4. One of the machines has a journal disk in the
>>> raid and the filesystem is mounted with nobarriers. Both show the same
>>> behavior. It'd be interesting to try a different filesystem but these are
>>> production machines with many disks and I cannot create another big array to
>>> transfer the contents.
>>
>> My array is running 6.5 + xfs, and mine all seems to work normally
>> (speed wise).  And in the perf top call he ran all of the busy
>> kworkers were ext4* calls spending a lot of time doing various
>> filesystem work.
>>
>> I did find/debug a situation where dumping the cache caused ext4
>> performance to be a disaster (large directories, lots of files).  It
>> was tracked back to ext4 relies on the Buffers:  data space in
>> /proc/meminfo for at least directory entry caching, and that if there
>> were a lot of directories and/or files in directories that Buffer:
>> getting dropped and/or getting pruned for any some reason caused the
>> fragmented directory entries to have to get reloaded from a spinning
>> disk and require the disk to be seeking for  *MINUTES* to reload it
>> (there were in this case several million files in a couple of
>> directories with the directory entries being allocated over time so
>> very likely heavily fragmented).
>>
>> I wonder if there was some change with how Buffers is
>> used/sized/pruned in the recent kernels.   The same drop_cache on an
>> XFS filesystem had no effect that I could identify and doing a ls -lR
>> on a big xfs filesystem does not make Buffers grow, but doing the same
>> ls -lR against an ext3/4 makes Buffers grow quite a bit (how much
>> depends on how many files/directories are on the filesystem).
>>
>> He may want to monitor buffers (cat /proc/meminfo | grep Buffers:) and
>> see if the poor performance correlates with Buffers suddenly being
>> smaller for some reason.
> 
> As much as I hate this, I started another small test.
> 
> $ uname -a
> Linux e7.eyal.emu.id.au 6.5.8-200.fc38.x86_64 #1 SMP PREEMPT_DYNAMIC Fri Oct 20 15:53:48 UTC 2023 x86_64 GNU/Linux
> 
> $ df -h /data1
> Filesystem      Size  Used Avail Use% Mounted on
> /dev/md127       55T   45T  9.8T  83% /data1
> 
> $ sudo du -sm /data2/no-backup/old-backups/tapes/01
> 2519    /data2/no-backup/old-backups/tapes/01
> 
> $ sudo find /data2/no-backup/old-backups/tapes/01|wc -l
> 92059
> 
> $ sudo rsync -aHSK --stats --progress --checksum-choice=none --no-compress -W /data2/no-backup/old-backups/tapes/01 /data1/no-backup/old-backups/
> 
> It completed in about one minute and it was enough to trigger the problem.
> 
>      PID USER      PR  NI    VIRT    RES    SHR S  %CPU  %MEM     TIME+ COMMAND
> 2781097 root      20   0       0      0      0 R  98.3   0.0  36:04.35 kworker/u16:0+flush-9:127
> 
> iostat has nothing unusual, writes to md127 at 10-20KB/s and %util is in the low single digit for all members.
> 
> Here is what meminfo showed in the first 10 minutes (it is still going but the trend is clear):
> 
>                          Dirty   change   Buffers   change
> 2023-11-04 08:56:35        44     -580   1170536        8
> 2023-11-04 08:56:45        48        4   1170552       16
> 2023-11-04 08:56:55    812456   812408   1171008      456
> 2023-11-04 08:57:05    538436  -274020   1180820     9812
> 2023-11-04 08:57:15    698708   160272   1189368     8548
> 2023-11-04 08:57:25    874208   175500   1195620     6252
> 2023-11-04 08:57:35    742300  -131908   1202124     6504
> 2023-11-04 08:57:45    973528   231228   1209580     7456
> 2023-11-04 08:57:55   1269320   295792   1214900     5320
> 2023-11-04 08:58:05   1624428   355108   1219764     4864
> 2023-11-04 08:58:15   1629484     5056   1219816       52
> 2023-11-04 08:58:25   1629372     -112   1219832       16
> 2023-11-04 08:58:35   1629028     -344   1219856       24
> 2023-11-04 08:58:45   1628928     -100   1219880       24
> 2023-11-04 08:58:55   1628552     -376   1219908       28
> 2023-11-04 08:59:05   1629252      700   1220072      164
> 2023-11-04 08:59:15   1628696     -556   1220132       60
> 2023-11-04 08:59:25   1628304     -392   1220156       24
> 2023-11-04 08:59:35   1628264      -40   1220188       32
> 2023-11-04 08:59:45   1628184      -80   1220340      152
> 2023-11-04 08:59:55   1628144      -40   1220364       24
> 2023-11-04 09:00:05   1628124      -20   1219940     -424
> 2023-11-04 09:00:15   1627908     -216   1219976       36
> 2023-11-04 09:00:25   1627840      -68   1220000       24
> 2023-11-04 09:00:35   1624276    -3564   1220024       24
> 2023-11-04 09:00:45   1624100     -176   1220060       36
> 2023-11-04 09:00:55   1623912     -188   1220092       32
> 2023-11-04 09:01:05   1624076      164   1220112       20
> 2023-11-04 09:01:15   1623368     -708   1220160       48
> 2023-11-04 09:01:25   1623176     -192   1220196       36
> 2023-11-04 09:01:35   1621872    -1304   1220232       36
> 2023-11-04 09:01:45   1621732     -140   1220308       76
> 2023-11-04 09:01:55   1612304    -9428   1220392       84
> 2023-11-04 09:02:05   1612256      -48   1220420       28
> 2023-11-04 09:02:15   1612040     -216   1220444       24
> 2023-11-04 09:02:25   1611968      -72   1220476       32
> 2023-11-04 09:02:35   1611872      -96   1220492       16
> 2023-11-04 09:02:45   1609932    -1940   1220524       32
> 2023-11-04 09:02:55   1609828     -104   1220556       32
> 2023-11-04 09:03:05   1609916       88   1220572       16
> 2023-11-04 09:03:15   1609496     -420   1220608       36
> 2023-11-04 09:03:25   1609392     -104   1220632       24
> 2023-11-04 09:03:35   1609320      -72   1220648       16
> 2023-11-04 09:03:45   1609240      -80   1220672       24
> 2023-11-04 09:03:55   1609152      -88   1220688       16
> 2023-11-04 09:04:05   1609332      180   1220712       24
> 2023-11-04 09:04:15   1608892     -440   1220748       36
> 2023-11-04 09:04:25   1608848      -44   1220764       16
> 2023-11-04 09:04:35   1608744     -104   1220796       32
> 2023-11-04 09:04:45   1608436     -308   1220820       24
> 2023-11-04 09:04:55   1607916     -520   1220836       16
> 2023-11-04 09:05:05   1608624      708   1220876       40
> 2023-11-04 09:05:15   1606556    -2068   1220928       52
> 2023-11-04 09:05:25   1602692    -3864   1221016       88
> 2023-11-04 09:05:35   1602080     -612   1221052       36
> 2023-11-04 09:05:45   1602000      -80   1221080       28
> 2023-11-04 09:05:55   1601928      -72   1221096       16
> 2023-11-04 09:06:05   1602228      300   1221124       28
> 2023-11-04 09:06:15   1601848     -380   1221156       32
> 2023-11-04 09:06:25   1601656     -192   1221180       24
> 2023-11-04 09:06:35   1601532     -124   1221212       32
> 2023-11-04 09:06:45   1601476      -56   1221228       16
> 2023-11-04 09:06:55   1601364     -112   1221252       24

Another view of interest, is the fact that w_await, which I understand is the total time to service a write request,
is high, at 1-2s from this point onward. The components are significantly quicker at the low teens.

          Device            r/s     rkB/s   rrqm/s  %rrqm r_await rareq-sz     w/s     wkB/s   wrqm/s  %wrqm w_await wareq-sz     d/s     dkB/s   drqm/s  %drqm d_await dareq-sz     f/s f_await  aqu-sz  %util
09:00:00 md127            0.02      0.07     0.00   0.00   18.00     4.00    2.33     13.27     0.00   0.00 1268.36     5.69    0.00      0.00     0.00   0.00    0.00     0.00    0.00    0.00    2.96   1.12
09:00:00 sdb              0.10      3.80     0.85  89.47    2.50    38.00    0.85      1.57     0.00   0.00    3.00     1.84    0.00      0.00     0.00   0.00    0.00     0.00    0.83    2.82    0.01   0.35
09:00:00 sdc              0.13      3.93     0.85  86.44    6.00    29.50    1.00      4.17     0.50  33.33    4.38     4.17    0.00      0.00     0.00   0.00    0.00     0.00    0.83    4.72    0.01   0.53
09:00:00 sdd              0.13      3.93     0.85  86.44    7.12    29.50    1.05      3.70     0.33  24.10   13.78     3.52    0.00      0.00     0.00   0.00    0.00     0.00    0.83    2.90    0.02   1.54
09:00:00 sde              0.12      3.87     0.85  87.93    2.29    33.14    0.83      1.50     0.00   0.00   14.02     1.80    0.00      0.00     0.00   0.00    0.00     0.00    0.83    0.42    0.01   1.27
09:00:00 sdf              0.03      0.13     0.00   0.00   12.50     4.00    1.37     14.63     2.75  66.80   13.83    10.71    0.00      0.00     0.00   0.00    0.00     0.00    0.83    4.88    0.02   1.84
09:00:00 sdg              0.02      0.07     0.00   0.00   21.00     4.00    1.40     14.77     2.75  66.27   13.45    10.55    0.00      0.00     0.00   0.00    0.00     0.00    0.83    4.96    0.02   1.77
09:01:00 md127            0.05      0.20     0.00   0.00   26.00     4.00    7.85     83.00     0.00   0.00 2388.76    10.57    0.00      0.00     0.00   0.00    0.00     0.00    0.00    0.00   18.75   1.74
09:01:00 sdb              0.23     15.73     3.70  94.07   20.36    67.43    0.98     29.12     6.68  87.17    5.75    29.62    0.00      0.00     0.00   0.00    0.00     0.00    0.67    7.75    0.02   0.73
09:01:00 sdc              0.20     10.33     2.38  92.26   12.08    51.67    0.77      9.93     2.10  73.26    3.20    12.95    0.00      0.00     0.00   0.00    0.00     0.00    0.67    3.33    0.01   0.36
09:01:00 sdd              0.23     18.60     4.42  94.98   23.07    79.71    1.03     22.38     4.93  82.68   11.61    21.66    0.00      0.00     0.00   0.00    0.00     0.00    0.67    3.62    0.02   1.31
09:01:00 sde              0.22     18.20     4.33  95.24   19.62    84.00    0.98     26.18     5.93  85.78   11.61    26.63    0.00      0.00     0.00   0.00    0.00     0.00    0.67    3.40    0.02   1.35
09:01:00 sdf              0.18     18.67     4.48  96.07   42.64   101.82    1.47     49.72    11.33  88.54   12.03    33.90    0.00      0.00     0.00   0.00    0.00     0.00    0.67    7.67    0.03   1.62
09:01:00 sdg              0.18     19.27     4.63  96.19   39.00   105.09    1.48     46.98    10.63  87.76   12.37    31.67    0.00      0.00     0.00   0.00    0.00     0.00    0.67    7.35    0.03   1.68
09:02:00 md127            0.32      1.27     0.00   0.00   26.95     4.00   14.12    214.93     0.00   0.00  639.34    15.23    0.00      0.00     0.00   0.00    0.00     0.00    0.00    0.00    9.03   2.80
09:02:00 sdb              0.48     51.47    12.38  96.24   18.03   106.48    1.20     63.79    15.13  92.65    3.72    53.16    0.00      0.00     0.00   0.00    0.00     0.00    0.78    3.79    0.02   0.79
09:02:00 sdc              0.53     58.07    13.98  96.33   16.16   108.88    1.30     71.99    17.08  92.93    4.95    55.38    0.00      0.00     0.00   0.00    0.00     0.00    0.78    7.15    0.02   1.08
09:02:00 sdd              0.52     69.13    16.77  97.01   14.13   133.81    1.52     92.27    21.95  93.54   10.38    60.84    0.00      0.00     0.00   0.00    0.00     0.00    0.78    3.60    0.03   1.78
09:02:00 sde              0.50     64.60    15.65  96.90   16.83   129.20    1.87     96.40    22.63  92.38   11.50    51.64    0.00      0.00     0.00   0.00    0.00     0.00    0.78    6.96    0.04   2.20
09:02:00 sdf              0.57     74.80    18.13  96.97   15.65   132.00    1.77     77.60    18.03  91.08   11.51    43.92    0.00      0.00     0.00   0.00    0.00     0.00    0.78    7.23    0.03   2.25
09:02:00 sdg              0.68     64.13    15.35  95.74    9.49    93.85    1.72     68.73    15.87  90.24   11.74    40.04    0.00      0.00     0.00   0.00    0.00     0.00    0.78    7.43    0.03   2.26
09:03:00 md127            0.00      0.00     0.00   0.00    0.00     0.00    6.97     51.00     0.00   0.00 7200.34     7.32    0.00      0.00     0.00   0.00    0.00     0.00    0.00    0.00   50.16   1.38
09:03:00 sdb              0.15      6.53     1.48  90.82   11.78    43.56    0.78      9.87     2.08  72.67    4.40    12.60    0.00      0.00     0.00   0.00    0.00     0.00    0.73    3.09    0.01   0.36
09:03:00 sdc              0.15      6.53     1.48  90.82    9.44    43.56    0.80      9.93     2.08  72.25    4.90    12.42    0.00      0.00     0.00   0.00    0.00     0.00    0.73    3.27    0.01   0.36
09:03:00 sdd              0.23     12.87     2.98  92.75    3.57    55.14    1.02     22.80     5.08  83.33   12.15    22.43    0.00      0.00     0.00   0.00    0.00     0.00    0.73    2.18    0.01   1.17
09:03:00 sde              0.45     17.73     3.98  89.85    1.52    39.41    1.37     29.27     6.35  82.29   13.65    21.41    0.00      0.00     0.00   0.00    0.00     0.00    0.73    5.34    0.02   1.60
09:03:00 sdf              0.37     11.40     2.48  87.13    5.59    31.09    1.13     16.33     3.35  74.72   13.82    14.41    0.00      0.00     0.00   0.00    0.00     0.00    0.73    3.98    0.02   1.60
09:03:00 sdg              0.47     21.67     4.95  91.38    3.11    46.43    1.17     16.60     3.38  74.36   14.50    14.23    0.00      0.00     0.00   0.00    0.00     0.00    0.73    5.23    0.02   1.58
09:04:00 md127            0.00      0.00     0.00   0.00    0.00     0.00    1.88     11.93     0.00   0.00 1439.04     6.34    0.00      0.00     0.00   0.00    0.00     0.00    0.00    0.00    2.71   0.92
09:04:00 sdb              0.38      8.73     1.80  82.44    2.00    22.78    0.90      4.70     0.72  44.33    3.94     5.22    0.00      0.00     0.00   0.00    0.00     0.00    0.82    4.02    0.01   0.48
09:04:00 sdc              0.38      8.73     1.80  82.44    1.74    22.78    0.82      1.50     0.00   0.00    2.69     1.84    0.00      0.00     0.00   0.00    0.00     0.00    0.82    2.47    0.00   0.34
09:04:00 sdd              0.30      3.47     0.57  65.38    0.39    11.56    0.98      9.97     1.95  66.48   13.14    10.14    0.00      0.00     0.00   0.00    0.00     0.00    0.82    2.14    0.01   1.40
09:04:00 sde              0.00      0.00     0.00   0.00    0.00     0.00    1.28     13.43     2.52  66.23   13.51    10.47    0.00      0.00     0.00   0.00    0.00     0.00    0.82    4.53    0.02   1.73
09:04:00 sdf              0.08      5.27     1.23  93.67    3.40    63.20    1.12      4.97     0.57  33.66   14.93     4.45    0.00      0.00     0.00   0.00    0.00     0.00    0.82    3.55    0.02   1.74
09:04:00 sdg              0.00      0.00     0.00   0.00    0.00     0.00    0.82      1.50     0.00   0.00   12.96     1.84    0.00      0.00     0.00   0.00    0.00     0.00    0.82    0.37    0.01   1.12
09:05:00 md127            0.00      0.00     0.00   0.00    0.00     0.00    2.27     19.27     0.00   0.00 1670.65     8.50    0.00      0.00     0.00   0.00    0.00     0.00    0.00    0.00    3.79   1.40
09:05:00 sdb              0.32      4.27     0.75  70.31    0.42    13.47    0.85      8.00     1.55  64.58    3.61     9.41    0.00      0.00     0.00   0.00    0.00     0.00    0.70    3.98    0.01   0.40
09:05:00 sdc              0.42     13.33     2.92  87.50    4.12    32.00    0.87     14.27     3.10  78.15    3.88    16.46    0.00      0.00     0.00   0.00    0.00     0.00    0.70    4.33    0.01   0.52
09:05:00 sdd              0.35      5.67     1.07  75.29    0.76    16.19    0.87     11.73     2.47  74.00   12.62    13.54    0.00      0.00     0.00   0.00    0.00     0.00    0.70    2.86    0.01   1.19
09:05:00 sde              0.00      0.00     0.00   0.00    0.00     0.00    1.23     17.47     3.53  74.13   12.08    14.16    0.00      0.00     0.00   0.00    0.00     0.00    0.70    6.19    0.02   1.51
09:05:00 sdf              0.08      5.53     1.30  93.98   11.40    66.40    1.15     13.47     2.62  69.47   13.26    11.71    0.00      0.00     0.00   0.00    0.00     0.00    0.70    4.21    0.02   1.55
09:05:00 sdg              0.08      5.53     1.30  93.98   12.00    66.40    0.80      9.07     1.87  70.00   12.04    11.33    0.00      0.00     0.00   0.00    0.00     0.00    0.70    1.24    0.01   1.03
09:06:00 md127            0.20      0.80     0.00   0.00   23.17     4.00    3.03    113.80     0.00   0.00 1063.22    37.52    0.00      0.00     0.00   0.00    0.00     0.00    0.00    0.00    3.23   2.60
09:06:00 sdb              0.30     32.80     7.90  96.34   10.56   109.33    1.22     36.85     8.37  87.30    4.70    30.29    0.00      0.00     0.00   0.00    0.00     0.00    0.72    6.56    0.01   0.76
09:06:00 sdc              0.30     37.40     9.05  96.79    8.83   124.67    1.13     42.32     9.82  89.65    4.34    37.34    0.00      0.00     0.00   0.00    0.00     0.00    0.72    4.42    0.01   0.63
09:06:00 sdd              0.58     62.60    15.07  96.27   16.83   107.31    1.43     57.72    13.37  90.32   11.91    40.27    0.00      0.00     0.00   0.00    0.00     0.00    0.72    6.74    0.03   1.79
09:06:00 sde              0.47     64.73    15.72  97.12   10.14   138.71    1.48     45.18    10.18  87.29   11.97    30.46    0.00      0.00     0.00   0.00    0.00     0.00    0.72    7.09    0.03   1.78
09:06:00 sdf              0.35     42.53    10.28  96.71   15.48   121.52    1.48     46.72    10.57  87.69   14.58    31.49    0.00      0.00     0.00   0.00    0.00     0.00    0.72    7.40    0.03   1.97
09:06:00 sdg              0.27     31.93     7.72  96.66   16.38   119.75    1.18     52.58    12.33  91.25   11.63    44.44    0.00      0.00     0.00   0.00    0.00     0.00    0.72    3.70    0.02   1.40
09:07:00 md127            0.00      0.00     0.00   0.00    0.00     0.00    2.10     13.93     0.00   0.00 1405.96     6.63    0.00      0.00     0.00   0.00    0.00     0.00    0.00    0.00    2.95   1.00
09:07:00 sdb              0.00      0.00     0.00   0.00    0.00     0.00    0.97      3.36     0.32  24.68    3.19     3.47    0.00      0.00     0.00   0.00    0.00     0.00    0.80    3.54    0.01   0.39
09:07:00 sdc              0.15      7.47     1.72  91.96    0.44    49.78    1.17     13.43     2.63  69.30    4.29    11.51    0.00      0.00     0.00   0.00    0.00     0.00    0.80    4.31    0.01   0.48
09:07:00 sdd              0.15      7.47     1.72  91.96    0.44    49.78    1.00     11.43     2.30  69.70   11.55    11.43    0.00      0.00     0.00   0.00    0.00     0.00    0.80    1.00    0.01   1.23
09:07:00 sde              0.15      7.47     1.72  91.96    9.44    49.78    1.28     12.83     2.37  64.84   14.22     9.99    0.00      0.00     0.00   0.00    0.00     0.00    0.80    4.27    0.02   1.69
09:07:00 sdf              0.05      2.53     0.58  92.11    4.67    50.67    1.18      7.89     1.23  51.03   13.87     6.67    0.00      0.00     0.00   0.00    0.00     0.00    0.80    4.29    0.02   1.63
09:07:00 sdg              0.00      0.00     0.00   0.00    0.00     0.00    0.80      1.43     0.00   0.00   13.48     1.78    0.00      0.00     0.00   0.00    0.00     0.00    0.80    1.08    0.01   1.14

-- 
Eyal at Home (eyal@eyal.emu.id.au)

