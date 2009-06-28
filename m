From: John Robinson <john.robinson@anonymous.org.uk>
Subject: Re: Adding a smaller drive
Date: Sun, 28 Jun 2009 22:09:50 +0100
Message-ID: <4A47DC1E.7030907@anonymous.org.uk>
References: <20090628194705152.ITZI24524@cdptpa-omta02.mail.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20090628194705152.ITZI24524@cdptpa-omta02.mail.rr.com>
Sender: linux-raid-owner@vger.kernel.org
To: lrhorer@satx.rr.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 28/06/2009 20:47, Leslie Rhorer wrote:
>>> 	I have a few questions.  Some RAID implementations will simply
>>> refuse to create or grow an array if all the targets are not precisely
>> the
>>> same size.  Clearly this is not the case for mdadm.  Not all drives of a
>>> given "size" are actually precisely the same size, however, and I am
>> using
>>> unpartitioned drives for my RAID systems.  What happens if I add a drive
>>> whose apparent physical size is a bit smaller than the device size used
>> to
>>> create the array?
>> For RAID 4/5/6, I think it'll be refused.
> 
> 	Do you know if the refusal would include an error message clearly
> indicating why the growth is refused?

I don't know about current versions, but I just tried it with loop 
devices on CentOS 5 with mdadm 2.6.4, starting with a 3-member RAID-5 
and trying to add a slightly-too-small 4th, and it's not a helpful error 
message: "mdadm: add new device failed for /dev/loop4 as 3: Invalid 
argument"

> 	I may have to rethink my position on using raw drives.  If I
> partition the drives, I can make the partition a bit smaller than the whole
> drive, allowing for the addition of a future drive whose size is a bit off.
> I hate to waste space, but being stuck with an undersized or limping array
> is worse.

Yes it is. You can still use raw devices, just give the --size argument 
when creating your array, and it won't use the largest size possible. 
You'll want to work out how many KiB (i.e. 2^10 bytes) there are in a 
drive manufacturer's MB (10^6), GB (10^9) or TB (10^12) and use that as 
appropriate. For example, presumably all manufacturers' 500G drives will 
have at least 500*10^9 bytes of storage on them, and divided by 1024 
that's 488281250.

Cheers,

John.

