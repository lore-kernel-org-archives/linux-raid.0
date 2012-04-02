From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: RAID5 created by 8 disks works with xfs
Date: Mon, 02 Apr 2012 15:21:51 -0500
Message-ID: <4F7A0A5F.8030107@hardwarefreak.com>
References: <CACwgYDPQBNa7z7WcyUjV2Rx8Qf47r7eaRCowNKxjLBz+fYcfvQ@mail.gmail.com> <CADNH=7H_rgiY4fkB0SHo0yPhSBib7Gq-E_fu18yuJx=enn-eGg@mail.gmail.com> <4F776492.4070600@hardwarefreak.com> <CACwgYDOSrEYUps2VLpFSZ-irH7Mn_-BWrOYYDgXS=ULrmVuEPw@mail.gmail.com> <4F77D0B2.8000809@hardwarefreak.com> <CACwgYDMx6nQF-OwYj-BA+sZivUK=kmv2tPukgf5JGwA1vMTGrA@mail.gmail.com> <4F77EA55.6090004@hardwarefreak.com> <jl9ate$2me$1@dough.gmane.org> <4F793C6E.1080000@hardwarefreak.com> <4F794F6A.1010808@westcontrol.com>
Reply-To: stan@hardwarefreak.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4F794F6A.1010808@westcontrol.com>
Sender: linux-raid-owner@vger.kernel.org
To: David Brown <david@westcontrol.com>
Cc: David Brown <david.brown@hesbynett.no>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 4/2/2012 2:04 AM, David Brown wrote:
> On 02/04/2012 07:43, Stan Hoeppner wrote:
>> On 4/1/2012 5:33 AM, David Brown wrote:
>>
>>> For an application like this, it would probably make sense to put the
>>> xfs log (and the mdraid bitmap file, if you are using one) on a separate
>>> disk - perhaps a small SSD.
>>
>> XFS only journals metadata changes.  Thus an external journal is not
>> needed here as there is no metadata in the workload.
>>
> 
> Won't there still be metadata changes as each file is closed and a new
> one started, 

Yes, creating one file requires one journal operation consisting of a
few dozen to a few hundred bytes of journal data.  With delaylog this
will very likely be consolidated into a single IO to the journal, or a
handful of IOs.  With the workload in question the number of journal IOs
is trivial.

> or as more space is allocated to the files being written (I

Allocation occurs once when the file is created.

> know xfs has delayed allocation and other tricks to minimise this, but
> it can't be eliminated entirely).  Each time the metadata or log needs
> written, you'll get a big discontinuity in the writing as the disks
> heads need to jump around (especially for RAID5!).

The ratio of file IOs to metadata IOs in this workload is well north of
millions to one.  Again, the metadata IOPS in this workload are trivial.
 RAID level has no bearing on metadata IOPS here.  Though it does for
the actual workload, as I already discussed in detail.

> It would make sense to have a separate disk (again, SSD is logical) for
> the OS and other files anyway, keeping the big array for the data.
> Putting the xfs log there too would surely be a small but helpful step?

No it doesn't make sense.  See above.  Additionally, an external journal
can only be used if the journal device is behind battery backed RAID
cache.  Due to a design issue, XFS cannot perform barrier operations on
an external journal device, only to an internal journal.  Without
barriers or BBWC you have the opportunity for constant filesystem
corruption.  The OP doesn't have a BBWC RAID controller, nor any RAID
controller at all.  So an external journal isn't an option here anyway.

-- 
Stan
