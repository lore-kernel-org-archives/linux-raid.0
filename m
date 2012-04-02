From: David Brown <david@westcontrol.com>
Subject: Re: RAID5 created by 8 disks works with xfs
Date: Mon, 02 Apr 2012 08:59:36 +0200
Message-ID: <jlbj87$8fr$1@dough.gmane.org>
References: <CACwgYDPQBNa7z7WcyUjV2Rx8Qf47r7eaRCowNKxjLBz+fYcfvQ@mail.gmail.com> <CADNH=7H_rgiY4fkB0SHo0yPhSBib7Gq-E_fu18yuJx=enn-eGg@mail.gmail.com> <4F776492.4070600@hardwarefreak.com> <CACwgYDOSrEYUps2VLpFSZ-irH7Mn_-BWrOYYDgXS=ULrmVuEPw@mail.gmail.com> <4F77D0B2.8000809@hardwarefreak.com> <CACwgYDMx6nQF-OwYj-BA+sZivUK=kmv2tPukgf5JGwA1vMTGrA@mail.gmail.com> <4F77EA55.6090004@hardwarefreak.com> <jl9ate$2me$1@dough.gmane.org> <4F784A06.1@anonymous.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4F784A06.1@anonymous.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 01/04/2012 14:28, John Robinson wrote:
> On 01/04/2012 11:33, David Brown wrote:
> [...]
>> For an application like this, it would probably make sense to put the
>> xfs log (and the mdraid bitmap file, if you are using one) on a separate
>> disk - perhaps a small SSD.
>
> Now that you've suggested that, it occurs to me that for an application
> like this, the OP might be better doing his multiple slow streams to a
> spool folder on SSD, and copying over to the big array of spinning rust
> when each stream completes. 200 streams of 500MB is 100GB of data, so a
> pair of slightly larger SSDs in RAID1 (or RAID10, to balance the reads
> coming off) would do nicely as a spool area.

If the OP wants to do that, he must be careful when looking at the rated 
write speeds for the SSDs.  SSDs need a bit of a break on occasion to 
get time to do their garbage collection - their long-term streamed write 
speed is therefore lower than their short-term write speeds (and that's 
the figure that will be given in the spec).  But if you take that into 
account, and short-partition the SSD's a little (i.e., leave 10% 
unpartitioned, and put the raid1 on the partition rather than the disk) 
so that there are always plenty of free blocks when they are needed, 
that could be a very good solution.

>
> This might also be a good application for bcache, FlashCache or whatever.
>
> Cheers,
>
> John.
>


