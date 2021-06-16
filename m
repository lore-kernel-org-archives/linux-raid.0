Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F01A5C48BE5
	for <linux-raid@archiver.kernel.org>; Wed, 16 Jun 2021 18:09:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D3207610A3
	for <linux-raid@archiver.kernel.org>; Wed, 16 Jun 2021 18:09:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231617AbhFPSLG (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 16 Jun 2021 14:11:06 -0400
Received: from smtpout2.vodafonemail.de ([145.253.239.133]:56564 "EHLO
        smtpout2.vodafonemail.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230152AbhFPSLF (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 16 Jun 2021 14:11:05 -0400
X-Greylist: delayed 392 seconds by postgrey-1.27 at vger.kernel.org; Wed, 16 Jun 2021 14:11:05 EDT
Received: from smtp.vodafone.de (smtpa07.fra-mediabeam.com [10.2.0.38])
        by smtpout2.vodafonemail.de (Postfix) with ESMTP id 1692E122230;
        Wed, 16 Jun 2021 20:02:26 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nexgo.de;
        s=vfde-smtpout-mb-15sep; t=1623866546;
        bh=1TBaiMZ7Ys682jjKPQmSb4zNxV1q/c94ePLuKPyggKc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To;
        b=OuKhjPFiEGPsYOToQtFW8zhfwsdagRSVuI5lySpbpz1+KnkIJ8m2gOfgy0ASXBBEM
         VZSO3Ift/N3CfD+GxbPKVxNl0g3h8YFSxXbHo32CDfH9pG6WPvGycuyIBNnVNqbA/+
         5iWU6wn81tlsSCFyy9d8S7GIVQDG8tb4YnvsJ3eM=
Received: from lazy.lzy (p579d74fe.dip0.t-ipconnect.de [87.157.116.254])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp.vodafone.de (Postfix) with ESMTPSA id BB4EA140194;
        Wed, 16 Jun 2021 18:02:25 +0000 (UTC)
Received: from lazy.lzy (localhost [127.0.0.1])
        by lazy.lzy (8.16.1/8.14.5) with ESMTPS id 15GI2PHI008857
        (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
        Wed, 16 Jun 2021 20:02:25 +0200
Received: (from red@localhost)
        by lazy.lzy (8.16.1/8.16.1/Submit) id 15GI2ORk008856;
        Wed, 16 Jun 2021 20:02:24 +0200
Date:   Wed, 16 Jun 2021 20:02:24 +0200
From:   Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>
To:     H <agents@meddatainc.com>
Cc:     Linux RAID Mailing List <linux-raid@vger.kernel.org>
Subject: Re: Recovering RAID-1
Message-ID: <YMo8sEn3BltAfzQM@lazy.lzy>
References: <e6940ac5-9c2a-35bb-04fe-c80fe2a95405@meddatainc.com>
 <b7f88b0e-9941-19c5-bd94-8a79896906f2@youngman.org.uk>
 <ae2589bb-43e9-863d-32f4-86d949f530bd@meddatainc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ae2589bb-43e9-863d-32f4-86d949f530bd@meddatainc.com>
X-purgate-type: clean
X-purgate-Ad: Categorized by eleven eXpurgate (R) http://www.eleven.de
X-purgate: This mail is considered clean (visit http://www.eleven.de for further information)
X-purgate: clean
X-purgate-size: 5367
X-purgate-ID: 155817::1623866545-0000067D-5C3130EE/0/0
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Mon, Jun 14, 2021 at 01:35:06PM -0400, H wrote:
> On 06/14/2021 04:17 AM, antlists wrote:
> > On 13/06/2021 23:51, H wrote:
> >> I would very much appreciate if anyone can suggest how to check the last items? Once this has been verified the next step would be to get mdadm RAID-1 going again.
> >
> > An obvious first step is to run lsdrv. https://raid.wiki.kernel.org/index.php/Asking_for_help
> >
> > That will hopefully find anything there.
> >
> > But before you do anything BACKUP BACKUP BACKUP. It's only 250GB from what I can see - getting your hands on a 500GB or 1TB drive shouldn't be hard, and a quick stream of the partition shouldn't take long (although a "cp -a" might be safer, given that LUKS is involved ...).
> >
> > Cheers,
> > Wol
> 
> Thank you for the link, here is the output from the various packages listed on that page:
> 
> uname -a
> 
> Linux tsp520c 3.10.0-1160.2.2.el7.x86_64 #1 SMP Tue Oct 20 16:53:08 UTC 2020 x86_64 x86_64 x86_64 GNU/Linux
> 
> mdadm --version
> 
> mdadm - v4.1 - 2018-10-01
> 
> smartctl --xall /dev...
> 
> I skipped this since the output is lengthy and not sure which parts we might need.
> 
> mdadm --examine /dev/sdb (and /dev/sdc as well as individual partitions)
> 
> [root@tsp520c ~]# mdadm --examine /dev/sdb
> /dev/sdb:
>    MBR Magic : aa55
> Partition[0] :    500118191 sectors at            1 (type ee)
> [root@tsp520c ~]# mdadm --examine /dev/sdb1
> /dev/sdb1:
>    MBR Magic : aa55
> Partition[0] :   1701978223 sectors at   1948285285 (type 6e)
> Partition[3] :          441 sectors at     28049408 (type 00)
> [root@tsp520c ~]# mdadm --examine /dev/sdb2
> mdadm: No md superblock detected on /dev/sdb2.
> [root@tsp520c ~]# mdadm --examine /dev/sdb3
> mdadm: No md superblock detected on /dev/sdb3.
> [root@tsp520c ~]#
> 
> [root@tsp520c ~]# mdadm --examine /dev/sdc
> /dev/sdc:
>    MBR Magic : aa55
> Partition[0] :    500118191 sectors at            1 (type ee)
> [root@tsp520c ~]# mdadm --examine /dev/sdc1
> /dev/sdc1:
>    MBR Magic : aa55
> Partition[0] :   1701978223 sectors at   1948285285 (type 6e)
> Partition[3] :          441 sectors at     28049408 (type 00)
> [root@tsp520c ~]# mdadm --examine /dev/sdc2
> mdadm: No md superblock detected on /dev/sdc2.
> [root@tsp520c ~]# mdadm --examine /dev/sdc3
> mdadm: No md superblock detected on /dev/sdc3.

It does not seem there is any Linux RAID around.

Maybe it was the "fake RAID" or whatever, which
was handled by the motherboard.

If the data is accessible, just copy everything
somewhere else and reconfigure the storage.

bye,

pg

> 
> cat /proc/mdstat
> 
> Personalities :
> unused devices: <none>
> 
> mdadm --detail /dev/mdx
> 
> There are no /dev/md devices
> 
> lsdrv
> 
> **Warning** The following utility(ies) failed to execute:
>   sginfo
> Some information may be missing.
> 
> USB [uas] Bus 002 Device 002: ID 0bc2:231a Seagate RSS LLC Expansion Portable {NAADA87P}
> └scsi 0:0:0:0 Seagate  Expansion      
>  └sda 3.64t [8:0] crypto_LUKS {f573965d-f469-4fc2-abf6-8155f7f422c4}
>   └dm-4 3.64t [253:4] ext4 {3a94f5a0-058a-4002-9067-27ed211e99f0}
>    └Mounted as /dev/mapper/luks-f573965d-f469-4fc2-abf6-8155f7f422c4 @ /run/media/hakan/3a94f5a0-058a-4002-9067-27ed211e99f0
> PCI [ahci] 00:17.0 SATA controller: Intel Corporation 200 Series PCH SATA controller [AHCI mode]
> ├scsi 1:0:0:0 ATA      SAMSUNG MZ7LH256 {S4VSNE0MA03154}
> │└sdb 238.47g [8:16] Partitioned (gpt)
> │ ├sdb1 260.00m [8:17] vfat 'SYSTEM' {A850-134B}
> │ ├sdb2 1.00g [8:18] xfs {2d8a56bf-f1e3-4f02-9ae7-3a20c987586d}
> │ └sdb3 237.22g [8:19] crypto_LUKS {8fb015aa-50d8-49b5-9001-964e3247fc87}
> │  └dm-0 237.21g [253:0] PV LVM2_member <237.21g used, 4.00m free {K082KU-HZAr-i6Np-9TwL-av7Z-Nytm-4I4jHe}
> │   └VG centos_tsp520c 237.21g 4.00m free {Y4mpA3-tMd8-L5Pg-xYQF-lcQY-7wgk-Ox2iSi}
> │    ├dm-3 179.52g [253:3] LV home xfs {1d7fabc3-c6f5-4e43-b609-ea86d33012c1}
> │    │└Mounted as /dev/mapper/centos_tsp520c-home @ /home
> │    ├dm-1 50.00g [253:1] LV root xfs {f4f1de82-b53d-4d6d-81f0-621103dddec5}
> │    │└Mounted as /dev/mapper/centos_tsp520c-root @ /
> │    └dm-2 7.69g [253:2] LV swap swap {7fbb4125-6394-4fe8-83a1-8ff0e079ae98}
> ├scsi 2:0:0:0 ATA      SAMSUNG MZ7LH256 {S4VSNE0MA03145}
> │└sdc 238.47g [8:32] Partitioned (gpt)
> │ ├sdc1 260.00m [8:33] vfat 'SYSTEM' {A850-134B}
> │ │└Mounted as /dev/sdc1 @ /boot/efi
> │ ├sdc2 1.00g [8:34] xfs {2d8a56bf-f1e3-4f02-9ae7-3a20c987586d}
> │ │└Mounted as /dev/sdc2 @ /boot
> │ └sdc3 237.22g [8:35] crypto_LUKS {8fb015aa-50d8-49b5-9001-964e3247fc87}
> └scsi 7:0:0:0 ATA      Samsung SSD 860  {S597NE0MA20991N}
>  └sdd 1.82t [8:48] Partitioned (gpt)
>   ├sdd1 1.82t [8:49] zfs_member 'zfspool' {3888980096123243448}
>   └sdd9 8.00m [8:57] Empty/Unknown
> Other Block Devices
> └loop0 0.00k [7:0] Empty/Unknown
> 
> Note that there are two other disks in the system which are not relevant (sda and sdd). The two identical SSDs, SAMSUNG MZ7LH256, are the ones that should be configured RAID-1 (sdb and sdc).
> 
> Thank you.
> 
> 

-- 

piergiorgio
