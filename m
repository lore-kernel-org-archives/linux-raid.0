From: David Brown <david.brown@hesbynett.no>
Subject: Re: RAID5 created by 8 disks works with xfs
Date: Sun, 01 Apr 2012 12:33:18 +0200
Message-ID: <jl9ate$2me$1@dough.gmane.org>
References: <CACwgYDPQBNa7z7WcyUjV2Rx8Qf47r7eaRCowNKxjLBz+fYcfvQ@mail.gmail.com> <CADNH=7H_rgiY4fkB0SHo0yPhSBib7Gq-E_fu18yuJx=enn-eGg@mail.gmail.com> <4F776492.4070600@hardwarefreak.com> <CACwgYDOSrEYUps2VLpFSZ-irH7Mn_-BWrOYYDgXS=ULrmVuEPw@mail.gmail.com> <4F77D0B2.8000809@hardwarefreak.com> <CACwgYDMx6nQF-OwYj-BA+sZivUK=kmv2tPukgf5JGwA1vMTGrA@mail.gmail.com> <4F77EA55.6090004@hardwarefreak.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4F77EA55.6090004@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 01/04/12 07:40, Stan Hoeppner wrote:
> On 4/1/2012 12:12 AM, daobang wang wrote:
>> Thank you very much!
>> I got it, so we can remove the Volume Group and Logical Volume to save resource.
>> And i will try RAID5 with 16 disks to write 96 total streams again.
>
> Why do you keep insisting on RAID5?!?!  It is not suitable for your
> workload.  It sucks Monday through Saturday and twice on Sunday for this
> workload.
>

My thoughts on this setup are that RAID5 (or RAID6) is a poor choice - 
it can quickly cause a mess for streaming writes.  Even if the streams 
themselves can mostly end up as full stripe writes, odd writes such as 
the end of a file, metadata writes, log data writes, etc., will mean 
read-modify-write operations that will cripple the write performance for 
the rest of the operations.

And if a disk fails so that you are running degraded, it will be hopeless.

Either drop the redundancy requirement entirely (maybe by making sure 
other backups are in order), or double the spindles and use RAID1 / RAID10.


For an application like this, it would probably make sense to put the 
xfs log (and the mdraid bitmap file, if you are using one) on a separate 
disk - perhaps a small SSD.

