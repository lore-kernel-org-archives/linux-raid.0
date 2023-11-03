Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0CF5CC4332F
	for <linux-raid@archiver.kernel.org>; Fri,  3 Nov 2023 22:44:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345991AbjKCWoh (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 3 Nov 2023 18:44:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345744AbjKCWog (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 3 Nov 2023 18:44:36 -0400
X-Greylist: delayed 369 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 03 Nov 2023 15:44:29 PDT
Received: from lists.tip.net.au (pasta.tip.net.au [203.10.76.2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 114D9D62
        for <linux-raid@vger.kernel.org>; Fri,  3 Nov 2023 15:44:28 -0700 (PDT)
Received: from lists.tip.net.au (pasta.tip.net.au [IPv6:2401:fc00:0:129::2])
        by mailhost.tip.net.au (Postfix) with ESMTP id 4SMbHW0LRPz9R87
        for <linux-raid@vger.kernel.org>; Sat,  4 Nov 2023 09:38:15 +1100 (AEDT)
Received: from [IPV6:2405:6e00:494:92f5:21b:21ff:fe3a:5672] (unknown [IPv6:2405:6e00:494:92f5:21b:21ff:fe3a:5672])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mailhost.tip.net.au (Postfix) with ESMTPSA id 4SMbHV4pyLz9QKk
        for <linux-raid@vger.kernel.org>; Sat,  4 Nov 2023 09:38:14 +1100 (AEDT)
Message-ID: <a7316cd9-af79-4a43-9433-4d62d5166df4@eyal.emu.id.au>
Date:   Sat, 4 Nov 2023 09:38:08 +1100
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
From:   eyal@eyal.emu.id.au
In-Reply-To: <CAAMCDec-=vwLJhpi4VfCXdgGactYWeidqmV=VPphGE6eEUxUQg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 04/11/2023 02.57, Roger Heflin wrote:
> On Fri, Nov 3, 2023 at 9:17 AM Carlos Carvalho <carlos@fisica.ufpr.br> wrote:
>>
>> Johannes Truschnigg (johannes@truschnigg.info) wrote on Thu, Nov 02, 2023 at 05:34:51AM -03:
>>> for the record, I do not think that any of the observations the OP made can be
>>> explained by non-pathological phenomena/patterns of behavior. Something is
>>> very clearly wrong with how this system behaves (the reported figures do not
>>> at all match the expected performance of even a degraded RAID6 array in my
>>> experience) and how data written to the filesystem apparently fails to make it
>>> into the backing devices in acceptable time.
>>>
>>> The whole affair reeks either of "subtle kernel bug", or maybe "subtle
>>> hardware failure", I think.
>>
>> Exactly. That's what I've been saying for months...
>>
>> I found a clear comparison: expanding the kernel tarball in the SAME MACHINE
>> with 6.1.61 and 6.5.10. The raid6 array is working normally in both cases. With
>> 6.1.61 the expansion works fine, finishes with ~100MB of dirty pages and these
>> are quickly sent to permanent storage. With 6.5.* it finishes with ~1.5GB of
>> dirty pages that are never sent to disk (I waited ~3h). The disks are idle, as
>> shown by sar, and the kworker/flushd runs with 100% cpu usage forever.
>>
>> Limiting the dirty*bytes in /proc/sys/vm the dirty pages stay low BUT tar is
>> blocked in D state and the tarball expansion proceeds so slowly that it'd take
>> days to complete (checked with quota).
>>
>> So 6.5 (and 6.4) are unusable in this case. In another machine, which does
>> hundreds of rsync downloads every day, the same problem exists and I also get
>> frequent random rsync timeouts.
>>
>> This is all with raid6 and ext4. One of the machines has a journal disk in the
>> raid and the filesystem is mounted with nobarriers. Both show the same
>> behavior. It'd be interesting to try a different filesystem but these are
>> production machines with many disks and I cannot create another big array to
>> transfer the contents.
> 
> My array is running 6.5 + xfs, and mine all seems to work normally
> (speed wise).  And in the perf top call he ran all of the busy
> kworkers were ext4* calls spending a lot of time doing various
> filesystem work.
> 
> I did find/debug a situation where dumping the cache caused ext4
> performance to be a disaster (large directories, lots of files).  It
> was tracked back to ext4 relies on the Buffers:  data space in
> /proc/meminfo for at least directory entry caching, and that if there
> were a lot of directories and/or files in directories that Buffer:
> getting dropped and/or getting pruned for any some reason caused the
> fragmented directory entries to have to get reloaded from a spinning
> disk and require the disk to be seeking for  *MINUTES* to reload it
> (there were in this case several million files in a couple of
> directories with the directory entries being allocated over time so
> very likely heavily fragmented).
> 
> I wonder if there was some change with how Buffers is
> used/sized/pruned in the recent kernels.   The same drop_cache on an
> XFS filesystem had no effect that I could identify and doing a ls -lR
> on a big xfs filesystem does not make Buffers grow, but doing the same
> ls -lR against an ext3/4 makes Buffers grow quite a bit (how much
> depends on how many files/directories are on the filesystem).
> 
> He may want to monitor buffers (cat /proc/meminfo | grep Buffers:) and
> see if the poor performance correlates with Buffers suddenly being
> smaller for some reason.

As much as I hate this, I started another small test.

$ uname -a
Linux e7.eyal.emu.id.au 6.5.8-200.fc38.x86_64 #1 SMP PREEMPT_DYNAMIC Fri Oct 20 15:53:48 UTC 2023 x86_64 GNU/Linux

$ df -h /data1
Filesystem      Size  Used Avail Use% Mounted on
/dev/md127       55T   45T  9.8T  83% /data1

$ sudo du -sm /data2/no-backup/old-backups/tapes/01
2519    /data2/no-backup/old-backups/tapes/01

$ sudo find /data2/no-backup/old-backups/tapes/01|wc -l
92059

$ sudo rsync -aHSK --stats --progress --checksum-choice=none --no-compress -W /data2/no-backup/old-backups/tapes/01 /data1/no-backup/old-backups/

It completed in about one minute and it was enough to trigger the problem.

     PID USER      PR  NI    VIRT    RES    SHR S  %CPU  %MEM     TIME+ COMMAND
2781097 root      20   0       0      0      0 R  98.3   0.0  36:04.35 kworker/u16:0+flush-9:127

iostat has nothing unusual, writes to md127 at 10-20KB/s and %util is in the low single digit for all members.

Here is what meminfo showed in the first 10 minutes (it is still going but the trend is clear):

                         Dirty   change   Buffers   change
2023-11-04 08:56:35        44     -580   1170536        8
2023-11-04 08:56:45        48        4   1170552       16
2023-11-04 08:56:55    812456   812408   1171008      456
2023-11-04 08:57:05    538436  -274020   1180820     9812
2023-11-04 08:57:15    698708   160272   1189368     8548
2023-11-04 08:57:25    874208   175500   1195620     6252
2023-11-04 08:57:35    742300  -131908   1202124     6504
2023-11-04 08:57:45    973528   231228   1209580     7456
2023-11-04 08:57:55   1269320   295792   1214900     5320
2023-11-04 08:58:05   1624428   355108   1219764     4864
2023-11-04 08:58:15   1629484     5056   1219816       52
2023-11-04 08:58:25   1629372     -112   1219832       16
2023-11-04 08:58:35   1629028     -344   1219856       24
2023-11-04 08:58:45   1628928     -100   1219880       24
2023-11-04 08:58:55   1628552     -376   1219908       28
2023-11-04 08:59:05   1629252      700   1220072      164
2023-11-04 08:59:15   1628696     -556   1220132       60
2023-11-04 08:59:25   1628304     -392   1220156       24
2023-11-04 08:59:35   1628264      -40   1220188       32
2023-11-04 08:59:45   1628184      -80   1220340      152
2023-11-04 08:59:55   1628144      -40   1220364       24
2023-11-04 09:00:05   1628124      -20   1219940     -424
2023-11-04 09:00:15   1627908     -216   1219976       36
2023-11-04 09:00:25   1627840      -68   1220000       24
2023-11-04 09:00:35   1624276    -3564   1220024       24
2023-11-04 09:00:45   1624100     -176   1220060       36
2023-11-04 09:00:55   1623912     -188   1220092       32
2023-11-04 09:01:05   1624076      164   1220112       20
2023-11-04 09:01:15   1623368     -708   1220160       48
2023-11-04 09:01:25   1623176     -192   1220196       36
2023-11-04 09:01:35   1621872    -1304   1220232       36
2023-11-04 09:01:45   1621732     -140   1220308       76
2023-11-04 09:01:55   1612304    -9428   1220392       84
2023-11-04 09:02:05   1612256      -48   1220420       28
2023-11-04 09:02:15   1612040     -216   1220444       24
2023-11-04 09:02:25   1611968      -72   1220476       32
2023-11-04 09:02:35   1611872      -96   1220492       16
2023-11-04 09:02:45   1609932    -1940   1220524       32
2023-11-04 09:02:55   1609828     -104   1220556       32
2023-11-04 09:03:05   1609916       88   1220572       16
2023-11-04 09:03:15   1609496     -420   1220608       36
2023-11-04 09:03:25   1609392     -104   1220632       24
2023-11-04 09:03:35   1609320      -72   1220648       16
2023-11-04 09:03:45   1609240      -80   1220672       24
2023-11-04 09:03:55   1609152      -88   1220688       16
2023-11-04 09:04:05   1609332      180   1220712       24
2023-11-04 09:04:15   1608892     -440   1220748       36
2023-11-04 09:04:25   1608848      -44   1220764       16
2023-11-04 09:04:35   1608744     -104   1220796       32
2023-11-04 09:04:45   1608436     -308   1220820       24
2023-11-04 09:04:55   1607916     -520   1220836       16
2023-11-04 09:05:05   1608624      708   1220876       40
2023-11-04 09:05:15   1606556    -2068   1220928       52
2023-11-04 09:05:25   1602692    -3864   1221016       88
2023-11-04 09:05:35   1602080     -612   1221052       36
2023-11-04 09:05:45   1602000      -80   1221080       28
2023-11-04 09:05:55   1601928      -72   1221096       16
2023-11-04 09:06:05   1602228      300   1221124       28
2023-11-04 09:06:15   1601848     -380   1221156       32
2023-11-04 09:06:25   1601656     -192   1221180       24
2023-11-04 09:06:35   1601532     -124   1221212       32
2023-11-04 09:06:45   1601476      -56   1221228       16
2023-11-04 09:06:55   1601364     -112   1221252       24

-- 
Eyal at Home (eyal@eyal.emu.id.au)

