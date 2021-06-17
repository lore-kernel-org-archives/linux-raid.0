Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E3EDC2B9F4
	for <linux-raid@archiver.kernel.org>; Thu, 17 Jun 2021 17:42:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 50137613CA
	for <linux-raid@archiver.kernel.org>; Thu, 17 Jun 2021 17:42:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231249AbhFQRot (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 17 Jun 2021 13:44:49 -0400
Received: from mout.perfora.net ([74.208.4.196]:44745 "EHLO mout.perfora.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230288AbhFQRot (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Thu, 17 Jun 2021 13:44:49 -0400
Received: from [192.168.1.23] ([72.94.51.172]) by mrelay.perfora.net
 (mreueus004 [74.208.5.2]) with ESMTPSA (Nemesis) id 1MWB3m-1lmtjJ0OTK-00Xdvd
 for <linux-raid@vger.kernel.org>; Thu, 17 Jun 2021 19:37:35 +0200
Subject: Re: Recovering RAID-1
Cc:     Linux RAID Mailing List <linux-raid@vger.kernel.org>
References: <e6940ac5-9c2a-35bb-04fe-c80fe2a95405@meddatainc.com>
 <b7f88b0e-9941-19c5-bd94-8a79896906f2@youngman.org.uk>
 <ae2589bb-43e9-863d-32f4-86d949f530bd@meddatainc.com>
 <YMo8sEn3BltAfzQM@lazy.lzy>
From:   H <agents@meddatainc.com>
Message-ID: <cce5ebf1-6ab5-b448-4312-0ae07d335ac9@meddatainc.com>
Date:   Thu, 17 Jun 2021 13:37:34 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <YMo8sEn3BltAfzQM@lazy.lzy>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Provags-ID: V03:K1:O1Oe4rMJ/OygeRd+hLl2W/D8fzECUW1j24kwS+I0s59ARsjyWZs
 39v5EHvuGRkaop9P5Kl2HgKOPZkEp+MrifxTiKoC87GCpbJV3mY1kwslryxZt84CVIuw5tU
 UGOabkIXqA0coY46gaL1x0igresczjQCNCTjRuWNEyykcP1YnvVo2KM/pgHng5SdgP3km44
 5DDSBrTHwiAV5TWXIFUXQ==
X-UI-Out-Filterresults: notjunk:1;V03:K0:p1Z7OMA8BHo=:rU1RSpuO3ZvxMU5aa2BEPs
 XTWNq7JQDCIoZ95OgGJuhfXo0PW3IWIsisnjkFzcY3WTIqo9W+2+W25ac+O0gPc8PtNIMUvHA
 Q7fwyfp9etTx8LT6/1GsP7dV3I4JwrVjgJ1crXOMl0T4ytRC0cJS+jg3IDCRpd6cG6GdYoxUL
 eB7s1o6iZrx4Qla+N0lKCGn6fjI5xUWIRKebzypYVtwuMyqujQYJ2CSBwEBg1bNYpFG0RpHHn
 wsPskydmNqDQCGU3Iq2zYiRTzzT8Y2N19/VgVWa/xApUjKJnIGFLW1MWgjdM4pzAAkvMXrUSf
 B8n6wADDnYk5nmt9SaDKz2+jPgg/Kyf9IHf+t2dpRJcoZ83SL2yBrUMkp8XsoA/+KQRJD1agd
 tu9JVgJVW8dZaKkv+t1wfxfWVRpzKCoRvohdzL0Cq3xNPqdCgIoY7v8T6vRQGhJsLN3Z+IFNT
 U8C0Tsw7SFWNQ44WjFqdyzvkmeuoY/9T4upaFiz5tudZF4IGVYYi+U2ZShD/CtNScREElH41v
 l1rdFUx9tfMltEwSuGwJws=
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 06/16/2021 02:02 PM, Piergiorgio Sartor wrote:
> On Mon, Jun 14, 2021 at 01:35:06PM -0400, H wrote:
>> On 06/14/2021 04:17 AM, antlists wrote:
>>> On 13/06/2021 23:51, H wrote:
>>>> I would very much appreciate if anyone can suggest how to check the last items? Once this has been verified the next step would be to get mdadm RAID-1 going again.
>>> An obvious first step is to run lsdrv. https://raid.wiki.kernel.org/index.php/Asking_for_help
>>>
>>> That will hopefully find anything there.
>>>
>>> But before you do anything BACKUP BACKUP BACKUP. It's only 250GB from what I can see - getting your hands on a 500GB or 1TB drive shouldn't be hard, and a quick stream of the partition shouldn't take long (although a "cp -a" might be safer, given that LUKS is involved ...).
>>>
>>> Cheers,
>>> Wol
>> Thank you for the link, here is the output from the various packages listed on that page:
>>
>> uname -a
>>
>> Linux tsp520c 3.10.0-1160.2.2.el7.x86_64 #1 SMP Tue Oct 20 16:53:08 UTC 2020 x86_64 x86_64 x86_64 GNU/Linux
>>
>> mdadm --version
>>
>> mdadm - v4.1 - 2018-10-01
>>
>> smartctl --xall /dev...
>>
>> I skipped this since the output is lengthy and not sure which parts we might need.
>>
>> mdadm --examine /dev/sdb (and /dev/sdc as well as individual partitions)
>>
>> [root@tsp520c ~]# mdadm --examine /dev/sdb
>> /dev/sdb:
>>    MBR Magic : aa55
>> Partition[0] :    500118191 sectors at            1 (type ee)
>> [root@tsp520c ~]# mdadm --examine /dev/sdb1
>> /dev/sdb1:
>>    MBR Magic : aa55
>> Partition[0] :   1701978223 sectors at   1948285285 (type 6e)
>> Partition[3] :          441 sectors at     28049408 (type 00)
>> [root@tsp520c ~]# mdadm --examine /dev/sdb2
>> mdadm: No md superblock detected on /dev/sdb2.
>> [root@tsp520c ~]# mdadm --examine /dev/sdb3
>> mdadm: No md superblock detected on /dev/sdb3.
>> [root@tsp520c ~]#
>>
>> [root@tsp520c ~]# mdadm --examine /dev/sdc
>> /dev/sdc:
>>    MBR Magic : aa55
>> Partition[0] :    500118191 sectors at            1 (type ee)
>> [root@tsp520c ~]# mdadm --examine /dev/sdc1
>> /dev/sdc1:
>>    MBR Magic : aa55
>> Partition[0] :   1701978223 sectors at   1948285285 (type 6e)
>> Partition[3] :          441 sectors at     28049408 (type 00)
>> [root@tsp520c ~]# mdadm --examine /dev/sdc2
>> mdadm: No md superblock detected on /dev/sdc2.
>> [root@tsp520c ~]# mdadm --examine /dev/sdc3
>> mdadm: No md superblock detected on /dev/sdc3.
> It does not seem there is any Linux RAID around.
>
> Maybe it was the "fake RAID" or whatever, which
> was handled by the motherboard.
>
> If the data is accessible, just copy everything
> somewhere else and reconfigure the storage.
>
> bye,
>
> pg
>
>> cat /proc/mdstat
>>
>> Personalities :
>> unused devices: <none>
>>
>> mdadm --detail /dev/mdx
>>
>> There are no /dev/md devices
>>
>> lsdrv
>>
>> **Warning** The following utility(ies) failed to execute:
>>   sginfo
>> Some information may be missing.
>>
>> USB [uas] Bus 002 Device 002: ID 0bc2:231a Seagate RSS LLC Expansion Portable {NAADA87P}
>> └scsi 0:0:0:0 Seagate  Expansion      
>>  └sda 3.64t [8:0] crypto_LUKS {f573965d-f469-4fc2-abf6-8155f7f422c4}
>>   └dm-4 3.64t [253:4] ext4 {3a94f5a0-058a-4002-9067-27ed211e99f0}
>>    └Mounted as /dev/mapper/luks-f573965d-f469-4fc2-abf6-8155f7f422c4 @ /run/media/hakan/3a94f5a0-058a-4002-9067-27ed211e99f0
>> PCI [ahci] 00:17.0 SATA controller: Intel Corporation 200 Series PCH SATA controller [AHCI mode]
>> ├scsi 1:0:0:0 ATA      SAMSUNG MZ7LH256 {S4VSNE0MA03154}
>> │└sdb 238.47g [8:16] Partitioned (gpt)
>> │ ├sdb1 260.00m [8:17] vfat 'SYSTEM' {A850-134B}
>> │ ├sdb2 1.00g [8:18] xfs {2d8a56bf-f1e3-4f02-9ae7-3a20c987586d}
>> │ └sdb3 237.22g [8:19] crypto_LUKS {8fb015aa-50d8-49b5-9001-964e3247fc87}
>> │  └dm-0 237.21g [253:0] PV LVM2_member <237.21g used, 4.00m free {K082KU-HZAr-i6Np-9TwL-av7Z-Nytm-4I4jHe}
>> │   └VG centos_tsp520c 237.21g 4.00m free {Y4mpA3-tMd8-L5Pg-xYQF-lcQY-7wgk-Ox2iSi}
>> │    ├dm-3 179.52g [253:3] LV home xfs {1d7fabc3-c6f5-4e43-b609-ea86d33012c1}
>> │    │└Mounted as /dev/mapper/centos_tsp520c-home @ /home
>> │    ├dm-1 50.00g [253:1] LV root xfs {f4f1de82-b53d-4d6d-81f0-621103dddec5}
>> │    │└Mounted as /dev/mapper/centos_tsp520c-root @ /
>> │    └dm-2 7.69g [253:2] LV swap swap {7fbb4125-6394-4fe8-83a1-8ff0e079ae98}
>> ├scsi 2:0:0:0 ATA      SAMSUNG MZ7LH256 {S4VSNE0MA03145}
>> │└sdc 238.47g [8:32] Partitioned (gpt)
>> │ ├sdc1 260.00m [8:33] vfat 'SYSTEM' {A850-134B}
>> │ │└Mounted as /dev/sdc1 @ /boot/efi
>> │ ├sdc2 1.00g [8:34] xfs {2d8a56bf-f1e3-4f02-9ae7-3a20c987586d}
>> │ │└Mounted as /dev/sdc2 @ /boot
>> │ └sdc3 237.22g [8:35] crypto_LUKS {8fb015aa-50d8-49b5-9001-964e3247fc87}
>> └scsi 7:0:0:0 ATA      Samsung SSD 860  {S597NE0MA20991N}
>>  └sdd 1.82t [8:48] Partitioned (gpt)
>>   ├sdd1 1.82t [8:49] zfs_member 'zfspool' {3888980096123243448}
>>   └sdd9 8.00m [8:57] Empty/Unknown
>> Other Block Devices
>> └loop0 0.00k [7:0] Empty/Unknown
>>
>> Note that there are two other disks in the system which are not relevant (sda and sdd). The two identical SSDs, SAMSUNG MZ7LH256, are the ones that should be configured RAID-1 (sdb and sdc).
>>
>> Thank you.
>>
>>
I see. I do recollect that at one time I had /dev/md127 and /dev/md128 show up in gparted. Could they have been created by the Intel fake RAID?

If there are no signs of a remaining mdadm RAID installation and I have to install fresh, I do have a couple of questions. Naturally I need to make backups of the partitions before doing anything but:

- Since the system seems to be booting from sdc1 and sdc2 while using sdb3 for the data partition, I would think that any restoration should be from backups of sdc1, sdc2 and sdb3, correct?

- Is there anyway to do a dry-run of a fresh mdadm installation to see if it might install on the disks as currently partitioned and not disturb sdc1, sdc2 and sdb3? I do have this minimal partition of ca 4 MiB at the end of both disks which, if I understand correctly, might be used by a mdadm 0.90 scheme?

