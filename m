From: Thomas Backlund <tmb@mandriva.org>
Subject: Re: md raid10 regression in 2.6.27.4 (possibly earlier) BISECTED
Date: Thu, 06 Nov 2008 01:30:16 +0200
Message-ID: <49122C88.5000102@mandriva.org>
References: <490D8EBF.8050400@rabbit.us> <490DE55F.6080600@mandriva.org> <490E3CF9.20208@mandriva.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <490E3CF9.20208@mandriva.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Thomas Backlund skrev:
> Thomas Backlund skrev:
>> Peter Rabbitson skrev:
>>> Hi,
>>>
>>> Some weeks ago I upgraded from 2.6.23 to 2.6.27.4. After a failed hard
>>> drive I realized that re-adding drives to a degraded raid10 no longer
>>> works (it adds the drive as a spare and never starts a resync). Booting
>>> back into the old .23 kernel allowed me to complete and resync the array
>>> as usual. Attached find a test case reliably failing on vanilla 2.6.27.4
>>> with no patches.
>>>
>>
>> I've just been hit with the same problem...
>>
>> I have a brand new server setup with 2.6.27.4 x86_64 kernel and a mix of
>> raid0, raid1, raid5 & raid10 partitions like this:
> 
> And an extra datapoint.
> 
> Booting into 2.6.26.5 triggers an instant resync of the spare disks, so 
> it means we have a regression between 2.6.26.5 and 2.6.27.4
> 
> If no-one have a good suggestion to try, I'll start bisecting tomorrow...

Ok,
so it was a pita to bisect as the testkernels oopsed from time to time
triggering a full rebuild of my 2.5 TiB raid5 wich takes ~4-5 hours to
complete... and since I wanted to wait for all raids to be fully up and 
synced between reboots, I hat to wait a lot...

But anyway...

This is the commit that breaks the raid10 rebuild/resync:

--- cut ---
6c2fce2ef6b4821c21b5c42c7207cb9cf8c87eda is first bad commit
commit 6c2fce2ef6b4821c21b5c42c7207cb9cf8c87eda
Author: Neil Brown <neilb@notabene.brown>
Date:   Sat Jun 28 08:31:31 2008 +1000

     Support adding a spare to a live md array with external metadata.

     i.e. extend the 'md/dev-XXX/slot' attribute so that you can
     tell a device to fill an vacant slot in an and md array.

     Signed-off-by: Neil Brown <neilb@suse.de>
--- cut ---

I have verified that adding this patch to a working 2.6.26 kernel breaks
the rebuild/resync

I have not verified if reverting it on a 2.6.27 kernel restores the 
rebuild/resync as it does not revert cleanly...

So...

Any suggestions of what to try next ?

--
Thomas


