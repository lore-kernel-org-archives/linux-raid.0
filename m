From: Gordon Henderson <gordon@drogon.net>
Subject: Re: raid6 rebuild
Date: Thu, 5 Apr 2007 09:15:38 +0100 (BST)
Message-ID: <Pine.LNX.4.64.0704050910140.20368@lion.drogon.net>
References: <20070404194638.GB3712@xi.wantstofly.org>
 <Pine.LNX.4.64.0704050701310.20368@lion.drogon.net> <20070405062114.GB6978@xi.wantstofly.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20070405062114.GB6978@xi.wantstofly.org>
Sender: linux-raid-owner@vger.kernel.org
To: Lennert Buytenhek <buytenh@wantstofly.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, 5 Apr 2007, Lennert Buytenhek wrote:

>>> [*] probably an entirely defective batch of 14 Samsung Spinpoint
>>> 500G disks
>>
>> Lets hope not... Keep checking those SMART values...
>
> Failed disk #2 still reports a SMART status of "PASSED"..

Hmmm.. I'd be tempted to double check your hardware + kernel versions then 
- I did have an older SCSI array on an older server (dual 500Mhz Xeons!) 
give me the occasional sector read error, but when going back and using 
badblocks (read only) on the disk, it checked out just fine... I never got 
to the bottom of it, but it only started happening when I went from a 2.4 
kernel where it was configures as 2 x 4-disk RAID-5 arrays to a 2.6 one 
where it was configures as a single 8 drive RAID-6 array with the new 
Adaptec SCSI driver... (My suspicions were that of old hardware combined 
with new drivers and a slight motherboard timing issue, as the R6 code 
might well drive the underlying hardware "harder" than when it was in dual 
R5 mode, but it was retired before it became a serious issue)

Gordon
