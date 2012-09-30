From: "=?ISO-8859-15?Q?Stefan_/*St0fF*/_H=FCbner?="
	<st0ff.npl@googlemail.com>
Subject: Re: MD RAID Bug 7/15/12
Date: Sun, 30 Sep 2012 23:08:15 +0200
Message-ID: <5068B4BF.6000807@gmail.com>
References: <022FFCA9-5D0E-41DB-9617-202C6FAADD06@rightthisminute.com> <A65170A9-BE4D-4B22-B1CE-2FFE10928DDD@colorremedies.com>
Reply-To: st0ff@npl.de
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <A65170A9-BE4D-4B22-B1CE-2FFE10928DDD@colorremedies.com>
Sender: linux-raid-owner@vger.kernel.org
To: Chris Murphy <lists@colorremedies.com>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Am 30.09.2012 04:47, schrieb Chris Murphy:
> 
> On Sep 29, 2012, at 6:12 PM, Mark Munoz wrote:
> 
>>
>> Configuration:
>> md0 is a RAID 6 volume with 24 devices and 1 spare.  It is working fine and was unaffected.
>> md1 is a RAID 6 volume with 19 devices and 1 spare.  It was affected.  All the drives show as unknown raid level and 0 devices.  With the exception of device 5.  It has all the information.
>>
>>         Layout : left-symmetric
>>     Chunk Size : 4K
> 
> Off topic response: I'm kindof new at all of this. But 24 and 19 devices? Is this really ideal? Why not cap RAID6 to a max of 12 disks, and either use LVM or md raid linear to aggregate?
> 
Also off topic: 12 drives would be as "nearly unalignable" as 19 are.
But still this setup is kind of sporty.  I wouldn't put too expensive
data on there.  My rule of thumb: each 4 drives need one drive of
redundancy.  So a ten drive raid6 is good.  Next alignment step (powers
of two amount of data drives) would be 18 - I'd add spare to it.

But 45 drives?  I'd give it a RAID60 of 4x10 drives, then think about it
again, what to do with those other 5 drives... or 2x18+1x6 and 3 spares ...

Well, whatever.  This is not an ideal setup anyhow.  God bless
Supermicro SC847E16JBOD ;)

St0fF

