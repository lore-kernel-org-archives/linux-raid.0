From: Juri Haberland <list-linux.raid@spoiled.org>
Subject: Re: RAID1: Disks alternating on reads
Date: Wed, 24 Sep 2003 12:06:28 +0000 (UTC)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <news2mail-bks1c4$n4k$1@cartman.spoiled.org>
References: <014b01c38053$0358ad90$0180a8c0@what> <news2mail-bkmfvp$a7u$1@cartman.spoiled.org> <20030923110928.GK8670@marowsky-bree.de>
Reply-To: Juri Haberland <juri@koschikode.com>
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Lars Marowsky-Bree <lmb@suse.de> wrote:
> On 2003-09-22T09:39:05,
>    Juri Haberland <list-linux.raid@spoiled.org> said:
> 
>> As far as I could observe, the RAID1 code reads one file from one disk
>> and never changes disks during this read - so you get the performance
>> of one disk.
>> *But* the code distributes different writes to different disks.
> 
> Reads of course, not writes ;-)

Yes, of course :)

Thanks,
Juri

-- 
Juri Haberland  <juri@koschikode.com> 

