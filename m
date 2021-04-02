Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 500CCC433B4
	for <linux-raid@archiver.kernel.org>; Fri,  2 Apr 2021 09:09:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 180A960FF3
	for <linux-raid@archiver.kernel.org>; Fri,  2 Apr 2021 09:09:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234834AbhDBJJ4 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 2 Apr 2021 05:09:56 -0400
Received: from mx3.molgen.mpg.de ([141.14.17.11]:48489 "EHLO mx1.molgen.mpg.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234600AbhDBJJ4 (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Fri, 2 Apr 2021 05:09:56 -0400
Received: from [192.168.0.2] (ip5f5aef94.dynamic.kabel-deutschland.de [95.90.239.148])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: pmenzel)
        by mx.molgen.mpg.de (Postfix) with ESMTPSA id DD334206473D6;
        Fri,  2 Apr 2021 11:09:53 +0200 (CEST)
Subject: Re: OT: Processor recommendation for RAID6
From:   Paul Menzel <pmenzel@molgen.mpg.de>
To:     linux-raid@vger.kernel.org
References: <16ceff73-1257-fc3d-aade-43656c7216e7@molgen.mpg.de>
 <12e8f7f1-6655-9f0b-72b1-0908f229dcac@molgen.mpg.de>
Cc:     LKML <linux-kernel@vger.kernel.org>
Message-ID: <b5eb567d-9866-8f0f-ea61-83ae97d4d21f@molgen.mpg.de>
Date:   Fri, 2 Apr 2021 11:09:53 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.0
MIME-Version: 1.0
In-Reply-To: <12e8f7f1-6655-9f0b-72b1-0908f229dcac@molgen.mpg.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Dear Linux folks,


Am 08.04.19 um 18:34 schrieb Paul Menzel:

> On 04/08/19 12:33, Paul Menzel wrote:
> 
>> Can you share your experiences, which processors you choose for
>> your RAID6 systems? I am particularly interested in Intel
>> alternatives? Are AMD EPYC processors good alternatives for file
>> servers? What about ARM and POWER?
>>
>> We currently use the HBA  Adaptec Smart Storage PQI 12G SAS/PCIe 3
>> (rev 01), Dell systems and rotating disks.
>>
>> For example, Dell PowerEdge R730 with 40x E5-2687W v3 @ 3.10GHz,
>> 192 GB of memory, Linux 4.14.87 and XFS file system. (The processor
>> looks too powerful for the system. At least the processor usage
>> is at most at one or two thread.)
>>
>> ```
>> [    0.394710] raid6: sse2x1   gen() 11441 MB/s
>> [    0.416710] raid6: sse2x1   xor()  8099 MB/s
>> [    0.438713] raid6: sse2x2   gen() 13359 MB/s
>> [    0.460710] raid6: sse2x2   xor()  8910 MB/s
>> [    0.482712] raid6: sse2x4   gen() 16128 MB/s
>> [    0.504710] raid6: sse2x4   xor() 10009 MB/s
>> [    0.526710] raid6: avx2x1   gen() 22242 MB/s
>> [    0.548709] raid6: avx2x1   xor() 15406 MB/s
>> [    0.570710] raid6: avx2x2   gen() 25699 MB/s
>> [    0.592710] raid6: avx2x2   xor() 16521 MB/s
>> [    0.614709] raid6: avx2x4   gen() 29847 MB/s
>> [    0.636710] raid6: avx2x4   xor() 18617 MB/s
>> [    0.642001] raid6: using algorithm avx2x4 gen() 29847 MB/s
>> [    0.648000] raid6: .... xor() 18617 MB/s, rmw enabled
>> [    0.654001] raid6: using avx2x2 recovery algorithm
>> ```

[…]

> Maybe some more data. AVX512 from Intel processors really seems to
> make a difference in the Linux tests. But also
> 
> ### Intel Xeon W-2145 (3.7 GHz) with Linux 4.19.19
> 
> ```
> $ dmesg | grep -e raid6 -e smpboot
> [    0.118880] smpboot: Allowing 16 CPUs, 0 hotplug CPUs
> [    0.379291] smpboot: CPU0: Intel(R) Xeon(R) W-2145 CPU @ 3.70GHz (family: 0x6, model: 0x55, stepping: 0x4)
> [    0.398245] smpboot: Max logical packages: 1
> [    0.398618] smpboot: Total of 16 processors activated (118400.00 BogoMIPS)
> [    0.426597] raid6: sse2x1   gen() 13144 MB/s
> [    0.443601] raid6: sse2x1   xor()  9962 MB/s
> [    0.460602] raid6: sse2x2   gen() 16863 MB/s
> [    0.477606] raid6: sse2x2   xor() 11425 MB/s
> [    0.494609] raid6: sse2x4   gen() 19089 MB/s
> [    0.511613] raid6: sse2x4   xor() 11988 MB/s
> [    0.528614] raid6: avx2x1   gen() 26285 MB/s
> [    0.545617] raid6: avx2x1   xor() 19335 MB/s
> [    0.562620] raid6: avx2x2   gen() 33953 MB/s
> [    0.579624] raid6: avx2x2   xor() 21255 MB/s
> [    0.596627] raid6: avx2x4   gen() 38492 MB/s
> [    0.613629] raid6: avx2x4   xor() 19722 MB/s
> [    0.630633] raid6: avx512x1 gen() 37621 MB/s
> [    0.647636] raid6: avx512x1 xor() 21017 MB/s
> [    0.664639] raid6: avx512x2 gen() 46859 MB/s
> [    0.681642] raid6: avx512x2 xor() 26173 MB/s
> [    0.698645] raid6: avx512x4 gen() 54210 MB/s
> [    0.715648] raid6: avx512x4 xor() 28041 MB/s
> [    0.716019] raid6: using algorithm avx512x4 gen() 54210 MB/s
> [    0.716244] raid6: .... xor() 28041 MB/s, rmw enabled
> [    0.716648] raid6: using avx512x2 recovery algorithm
> ```
> 
> ### AMD EPYC Linux 4.19.19 (up to 2.6 GHz according to `lscpu`)
> 
> ```
> $ dmesg | grep -e raid6 -e smpboot
> [    0.000000] smpboot: Allowing 128 CPUs, 0 hotplug CPUs
> [    0.122478] smpboot: CPU0: AMD EPYC 7601 32-Core Processor (family: 0x17, model: 0x1, stepping: 0x2)
> [    0.364480] smpboot: Max logical packages: 2
> [    0.366489] smpboot: Total of 128 processors activated (561529.72 BogoMIPS)
> [    0.503630] raid6: sse2x1   gen()  6136 MB/s
> [    0.524630] raid6: sse2x1   xor()  5931 MB/s
> [    0.545627] raid6: sse2x2   gen() 12941 MB/s
> [    0.566628] raid6: sse2x2   xor()  8173 MB/s
> [    0.587629] raid6: sse2x4   gen() 13089 MB/s
> [    0.608627] raid6: sse2x4   xor()  7318 MB/s
> [    0.629627] raid6: avx2x1   gen() 15164 MB/s
> [    0.650626] raid6: avx2x1   xor() 10990 MB/s
> [    0.671627] raid6: avx2x2   gen() 20316 MB/s
> [    0.692625] raid6: avx2x2   xor() 11886 MB/s
> [    0.713625] raid6: avx2x4   gen() 20726 MB/s
> [    0.734628] raid6: avx2x4   xor() 10095 MB/s
> [    0.739479] raid6: using algorithm avx2x4 gen() 20726 MB/s
> [    0.745479] raid6: .... xor() 10095 MB/s, rmw enabled
> [    0.750479] raid6: using avx2x2 recovery algorithm
> ```
> 
> Are these values a good benchmark for comparing processors?

After two years, yes they are. I created 16 10 GB files in `/dev/shm`, 
set them up as loop devices, and created a RAID6. For resync speed it 
makes difference.

2 x AMD EPYC 7601 32-Core Processor:    34671K/sec
2 x Intel Xeon Gold 6248 CPU @ 2.50GHz: 87533K/sec

So, the current state of affairs seems to be, that AVX512 instructions 
do help for software RAIDs, if you want fast rebuild/resync times. 
Getting, for example, a four core/eight thread Intel Xeon Gold 5222 
might be useful.

Now, the question remains, if AMD processors could make it up with 
higher performance, or better optimized code, or if AVX512 instructions 
are a must,

[…]


Kind regards,

Paul


PS: Here are the commands on the AMD EPYC system:

```
$ for i in $(seq 1 16); do truncate -s 10G /dev/shm/vdisk$i.img; done
$ for i in /dev/shm/v*.img; do sudo losetup --find --show $i; done
/dev/loop0
/dev/loop1
/dev/loop2
/dev/loop3
/dev/loop4
/dev/loop5
/dev/loop6
/dev/loop7
/dev/loop8
/dev/loop9
/dev/loop10
/dev/loop11
/dev/loop12
/dev/loop13
/dev/loop14
/dev/loop15
$ sudo mdadm --create /dev/md1 --level=6 --raid-devices=16 
/dev/loop{0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15}
mdadm: Defaulting to version 1.2 metadata
mdadm: array /dev/md1 started.
$ more /proc/mdstat
Personalities : [linear] [raid0] [raid1] [raid6] [raid5] [raid4] 
[multipath]
md1 : active raid6 loop15[15] loop14[14] loop13[13] loop12[12] 
loop11[11] loop10[10] loop9[9] loop8[8] loop7[7] loop6[6] loop5[5] 
loop4[4] loop3[3] lo
op2[2] loop1[1] loop0[0]
       146671616 blocks super 1.2 level 6, 512k chunk, algorithm 2 
[16/16] [UUUUUUUUUUUUUUUU]
       [>....................]  resync =  3.9% (416880/10476544) 
finish=5.6min speed=29777K/sec

unused devices: <none>
$ more /proc/mdstat
Personalities : [linear] [raid0] [raid1] [raid6] [raid5] [raid4] 
[multipath]
md1 : active raid6 loop15[15] loop14[14] loop13[13] loop12[12] 
loop11[11] loop10[10] loop9[9] loop8[8] loop7[7] loop6[6] loop5[5] 
loop4[4] loop3[3] lo
op2[2] loop1[1] loop0[0]
       146671616 blocks super 1.2 level 6, 512k chunk, algorithm 2 
[16/16] [UUUUUUUUUUUUUUUU]
       [>....................]  resync =  4.1% (439872/10476544) 
finish=5.3min speed=31419K/sec
$ sudo mdadm -S /dev/md1
mdadm: stopped /dev/md1
$ sudo losetup -D
$ sudo rm /dev/shm/vdisk*.img
```
