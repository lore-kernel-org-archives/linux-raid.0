From: Thomas Jager <lists@jager.no>
Subject: Re: Raid-5 long write wait while reading
Date: Fri, 25 May 2007 00:23:22 +0200
Message-ID: <4656105A.7000303@jager.no>
References: <4653306B.4090500@jager.no>
	<Pine.LNX.4.64.0705230622320.14733@praktifix.dwd.de>
Mime-Version: 1.0
Content-Type: text/plain;
	charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0705230622320.14733@praktifix.dwd.de>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Holger Kiehl wrote:
> Hello
>
> On Tue, 22 May 2007, Thomas Jager wrote:
>
>> Hi list.
>>
>> I run a file server on MD raid-5.
>> If a client reads one big file and at the same time another client 
>> tries to write a file, the thread writing just sits in 
>> uninterruptible sleep until the reader has finished. Only very small 
>> amount of writes get trough while the reader is still working.
>>
> I assume from the vmstat numbers the reader does a lot of seeks 
> (iowait > 80%!).
I don't think so unless the file is really fragmented. But I doubt it.
>
>> I'm having some trouble pinpointing the problem.
>> It's not consistent either sometimes it works as expected both the 
>> reader and writer gets some transactions. On huge reads I've seen the 
>> writer blocked for 30-40 minutes without any significant writes 
>> happening (Maybe a few megabytes, of several gigs waiting). It 
>> happens with NFS, SMB and FTP, and local with dd. And seems to be 
>> connected to raid-5. This does not happen on block devices without 
>> raid-5. I'm also wondering if it can have anything to do with 
>> loop-aes? I use loop-aes on top of the md, but then again i have not 
>> observed this problem on loop-devices with disk backend. I do know 
>> that loop-aes degrades performance but i didn't think it would do 
>> something like this?
>>
> What IO scheduler are you using? Maybe try using a different scheduler
> (eg. deadline) if that does make any difference.
I was using deadline. I tried switching to CFQ but I'm still seeing the 
same strange problems.

