Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75568C433FE
	for <linux-raid@archiver.kernel.org>; Mon, 20 Dec 2021 16:09:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236416AbhLTQJP (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 20 Dec 2021 11:09:15 -0500
Received: from mga18.intel.com ([134.134.136.126]:35949 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232628AbhLTQJO (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Mon, 20 Dec 2021 11:09:14 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10203"; a="227065931"
X-IronPort-AV: E=Sophos;i="5.88,220,1635231600"; 
   d="scan'208";a="227065931"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Dec 2021 08:08:16 -0800
X-IronPort-AV: E=Sophos;i="5.88,220,1635231600"; 
   d="scan'208";a="520867167"
Received: from mtkaczyk-mobl1.ger.corp.intel.com (HELO localhost) ([10.213.9.163])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Dec 2021 08:08:14 -0800
Date:   Mon, 20 Dec 2021 17:08:08 +0100
From:   Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To:     "David F." <df7729@gmail.com>
Cc:     Rudy Zijlstra <rudy@grumpydevil.homelinux.org>,
        Wol <antlists@youngman.org.uk>,
        "C.J. Collier" <cjac@colliertech.org>,
        Linux RAID <linux-raid@vger.kernel.org>
Subject: Re: Latest HP ProLiant DL380 G10 RAID1 support?
Message-ID: <20211220170808.0000055e@linux.intel.com>
In-Reply-To: <CAGRSmLvv-bipFyWCbnnU0t2=AK1PG-n7XP9H61eOWe2y+XYsjA@mail.gmail.com>
References: <CAGRSmLugFZo95qAOrGoKcfWN2wxe_h3Nyw8EVa+8sRVvPyu3_g@mail.gmail.com>
        <CAJj0OuvmhKP7TsamiA8X+qf38n=_94c8yR42NpUVoNp1jYqgUg@mail.gmail.com>
        <CAGRSmLvPWsYnCwkg61QJB4zjge4mu_-LOthicVzSFJo8+nj5sg@mail.gmail.com>
        <2726e0eb-90c1-b771-25c4-072caf5105be@youngman.org.uk>
        <02affda1-1f10-997a-616b-f9963a2ec995@grumpydevil.homelinux.org>
        <CAGRSmLvv-bipFyWCbnnU0t2=AK1PG-n7XP9H61eOWe2y+XYsjA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi David,

On Sun, 19 Dec 2021 19:05:45 -0800
"David F." <df7729@gmail.com> wrote:

> The report shows:
> 
> RAID bus controller [0104]: Intel Corporation C620 Series
> Chipset Family SSATA Controller [RAID mode] [8086:a1d6] (rev 09)
>     Subsystem: Hewlett Packard Enterprise Device [1590:00e6]
>     Kernel driver in use: ahci

It seems to be IMSM (Intel) raid, officially called "VROC". Could you
confirm it?

>> Output of blkid command:
>> /dev/sdc1: UUID="B6C669F7C669B7EF" TYPE="ntfs" PARTLABEL="'Recovery'"
>> PARTUUID="8713d776-d472-46ef-8023-cb599f2017bf"
>> /dev/sdc2: UUID="006A-0698" TYPE="vfat" PARTLABEL="'EFI system
>> partition'" PARTUUID="661cc486-d53a-412c-882e-140aeb126baf"
>> /dev/sdc3: UUID="4EBEAEE02F3D5ED1" TYPE="ntfs" PARTLABEL="'Microsoft
>> reserved partition'" PARTUUID="5ef03407-ebcd-4a72-86d1-fd1f5a047b8e"
>> /dev/sdc4: UUID="3D629FBB15FAC28A" TYPE="ntfs" PARTLABEL="'Basic data
>> partition'" PARTUUID="e5ef9438-fad4-4ee8-b7c0-c225ecba2173"
>> /dev/sdd1: UUID="B6C669F7C669B7EF" TYPE="ntfs" PARTLABEL="'Recovery'"
>> PARTUUID="8713d776-d472-46ef-8023-cb599f2017bf"
>> /dev/sdd2: UUID="006A-0698" TYPE="vfat" PARTLABEL="'EFI system
>> partition'" PARTUUID="661cc486-d53a-412c-882e-140aeb126baf"
>> /dev/sdd3: UUID="4EBEAEE02F3D5ED1" TYPE="ntfs" PARTLABEL="'Microsoft
>> reserved partition'" PARTUUID="5ef03407-ebcd-4a72-86d1-fd1f5a047b8e"
>> /dev/sdd4: UUID="3D629FBB15FAC28A" TYPE="ntfs" PARTLABEL="'Basic data
>> partition'" PARTUUID="e5ef9438-fad4-4ee8-b7c0-c225ecba2173"
>> /dev/sdf1: UUID="714C-EFFD" TYPE="vfat"
>> /dev/sdb: PTTYPE="PMBR"
>> /dev/sde: PTTYPE="PMBR"

If it is IMSM, blkid should report:
/dev/<disk>: TYPE="isw_raid_member"
for each member drive. Metadata seems to be destroyed but let confirm
first that we have IMSM here.

Thanks,
Mariusz
