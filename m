From: David Brown <david@westcontrol.com>
Subject: Re: RAID5 created by 8 disks works with xfs
Date: Mon, 02 Apr 2012 09:04:10 +0200
Message-ID: <4F794F6A.1010808@westcontrol.com>
References: <CACwgYDPQBNa7z7WcyUjV2Rx8Qf47r7eaRCowNKxjLBz+fYcfvQ@mail.gmail.com> <CADNH=7H_rgiY4fkB0SHo0yPhSBib7Gq-E_fu18yuJx=enn-eGg@mail.gmail.com> <4F776492.4070600@hardwarefreak.com> <CACwgYDOSrEYUps2VLpFSZ-irH7Mn_-BWrOYYDgXS=ULrmVuEPw@mail.gmail.com> <4F77D0B2.8000809@hardwarefreak.com> <CACwgYDMx6nQF-OwYj-BA+sZivUK=kmv2tPukgf5JGwA1vMTGrA@mail.gmail.com> <4F77EA55.6090004@hardwarefreak.com> <jl9ate$2me$1@dough.gmane.org> <4F793C6E.1080000@hardwarefreak.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4F793C6E.1080000@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: stan@hardwarefreak.com
Cc: David Brown <david.brown@hesbynett.no>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 02/04/2012 07:43, Stan Hoeppner wrote:
> On 4/1/2012 5:33 AM, David Brown wrote:
>
>> For an application like this, it would probably make sense to put the
>> xfs log (and the mdraid bitmap file, if you are using one) on a separate
>> disk - perhaps a small SSD.
>
> XFS only journals metadata changes.  Thus an external journal is not
> needed here as there is no metadata in the workload.
>

Won't there still be metadata changes as each file is closed and a new 
one started, or as more space is allocated to the files being written (I 
know xfs has delayed allocation and other tricks to minimise this, but 
it can't be eliminated entirely).  Each time the metadata or log needs 
written, you'll get a big discontinuity in the writing as the disks 
heads need to jump around (especially for RAID5!).

It would make sense to have a separate disk (again, SSD is logical) for 
the OS and other files anyway, keeping the big array for the data. 
Putting the xfs log there too would surely be a small but helpful step?

