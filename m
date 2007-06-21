From: Mark Lord <lkml@rtr.ca>
Subject: Re: limits on raid
Date: Thu, 21 Jun 2007 13:00:35 -0400
Message-ID: <467AAEB3.9070804@rtr.ca>
References: <Pine.LNX.4.64.0706141957020.29630@asgard.lang.hm> <18034.479.256870.600360@notabene.brown> <Pine.LNX.4.64.0706142034400.29630@asgard.lang.hm> <18034.3676.477575.490448@notabene.brown> <467273AB.9010202@argo.co.il> <18035.3009.568832.785308@notabene.brown> <20070618045759.GD85884050@sgi.com> <18041.59628.370832.633244@notabene.brown> <20070621063936.GT85884050@sgi.com> <Pine.LNX.4.64.0706202341080.31603@asgard.lang.hm>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0706202341080.31603@asgard.lang.hm>
Sender: linux-raid-owner@vger.kernel.org
To: david@lang.hm
Cc: David Chinner <dgc@sgi.com>, Neil Brown <neilb@suse.de>, Avi Kivity <avi@argo.co.il>, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

david@lang.hm wrote:
> On Thu, 21 Jun 2007, David Chinner wrote:
> 
>> On Thu, Jun 21, 2007 at 12:56:44PM +1000, Neil Brown wrote:
>>
>>> I have that - apparently naive - idea that drives use strong checksum,
>>> and will never return bad data, only good data or an error.  If this
>>> isn't right, then it would really help to understand what the cause of
>>> other failures are before working out how to handle them....
>>
>> The drive is not the only source of errors, though.  You could
>> have a path problem that is corrupting random bits between the drive
>> and the filesystem. So the data on the disk might be fine, and
>> reading it via a redundant path might be all that is needed.
> 
> one of the 'killer features' of zfs is that it does checksums of every 
> file on disk. so many people don't consider the disk infallable.
> 
> several other filesystems also do checksums
> 
> both bitkeeper and git do checksums of files to detect disk corruption

No, all of those checksums are to detect *filesystem* corruption,
not device corruption (a mere side-effect).

> as david C points out there are many points in the path where the data 
> could get corrupted besides on the platter.

Yup, that too.

But drives either return good data, or an error.

Cheers
