From: Juri Haberland <list-linux.raid@spoiled.org>
Subject: Re: RAID1: Disks alternating on reads
Date: Wed, 24 Sep 2003 12:15:25 +0000 (UTC)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <news2mail-bks1st$n4k$2@cartman.spoiled.org>
References: <014b01c38053$0358ad90$0180a8c0@what> <news2mail-bkmfvp$a7u$1@cartman.spoiled.org> <01ca01c38125$cab15c20$0180a8c0@what>
Reply-To: Juri Haberland <juri@koschikode.com>
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

"Andrew Herdman" <andrew@whine.com> wrote:
> From: "Juri Haberland" <list-linux.raid@spoiled.org>

>> This way one disk can seek for a file while the other one is transfering
>> one. A single read won't be faster but concurrent access to the same
>> filesystem will be much faster than on a non-RAID filesystem.
> 
> Does this mean that the md driver is filesystem aware?  Or is it just
> because i'm using EXT3?  How does md know how many file accesses i'm doing?

No, AFAIK it's not filesystem aware and it shouldn't be. For a better
explanation please look at the mail from Scott Bailey. He obviously
looked at the code which I didn't...

Cheers,
Juri

-- 
Juri Haberland  <juri@koschikode.com> 

