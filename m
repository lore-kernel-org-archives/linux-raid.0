From: Ric Wheeler <ric@emc.com>
Subject: Re: md faster than h/w?
Date: Mon, 16 Jan 2006 08:30:11 -0500
Message-ID: <43CB9FE3.60803@emc.com>
References: <dq7jii$n1c$1@sea.gmane.org> <Pine.LNX.4.44.0601131720090.24299-100000@coffee.psychology.mcmaster.ca> <43CB3DBA.405@fastmail.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <43CB3DBA.405@fastmail.co.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Max Waterman <davidmaxwaterman+gmane@fastmail.co.uk>
Cc: linux-raid@vger.kernel.org, "Butler, Tim" <Butler_Tim@emc.com>
List-Id: linux-raid.ids

Max Waterman wrote:

> Mark Hahn wrote:
>
>> I've written a fairly
>> simple bandwidth-reporting tool:
>>     http://www.sharcnet.ca/~hahn/iorate.c
>>
>> it prints incremental bandwidth, which I find helpful because it shows
>> recording zones, like this slightly odd Samsung:
>>     http://www.sharcnet.ca/~hahn/sp0812c.png
>>
>
> Using iorate.c, I guess somewhat different numbers for the 2.6.15 
> kernel than
> for the 2.6.8 kernel - the 2.6.15 kernel starts off at 105MB/s and 
> head down
> to 94MB/s, while 2.6.8 starts at 140MB/s and heads town to 128MB/s.
>
> That seems like a significant difference to me?
>
> What to do?
>
> Max.
>
Keep in mind that disk performance is very dependent on exactly what 
your IO pattern looks like and which part of the disk you are reading.

For example, you should be able to consistently max out the bus if you 
write a relatively small (say 8MB) block of data to a disk and then 
(avoiding the buffer cache) do direct IO reads to read it back.  This 
test is useful for figuring out if we have introduced any IO performance 
bumps as all of the data read should come directly from the disk cache 
and not require any head movement, platter reads, etc.  You can repeat 
this test for each of the independent drives in your system.

It is also important to keep in mind that different parts of your disk 
platter have different maximum throughput rates.  For example, reading 
from the outer sectors on a platter will give you a significantly 
different profile than reading from the inner sectors on a platter.

We have some tests that we use to measure raw disk performance that try 
to get through these hurdles to measure performance in a consistent and 
reproducible way...

ric

