From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: Data integrity and RAID
Date: Tue, 9 Dec 2008 18:33:04 -0500 (EST)
Message-ID: <alpine.DEB.1.10.0812091832450.28450@p34.internal.lan>
References: <20841008.post@talk.nabble.com>  <alpine.DEB.1.10.0812090905290.29505@p34.internal.lan>  <7d86ddb90812090630p7f916751s821e50f7b1e3138@mail.gmail.com>  <alpine.DEB.1.10.0812091128090.29505@p34.internal.lan>
 <7d86ddb90812091527q7afecaci12e5ba08db3d18d6@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <7d86ddb90812091527q7afecaci12e5ba08db3d18d6@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Ryan Wagoner <rswagoner@gmail.com>
Cc: "peter.stevens" <Peter.Stevens@gtech.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

What kind of disks? Does it go away after a 'repair'?
Show smartctl -a of both disks in the raid?

On Tue, 9 Dec 2008, Ryan Wagoner wrote:

> My swap is on a different RAID 1, but my other RAID 1 with the root
> partition was showing inconsistencies as well. It does it on both my
> servers.
>
> Ryan
>
> On Tue, Dec 9, 2008 at 11:28 AM, Justin Piszcz <jpiszcz@lucidpixels.com> wrote:
>>
>>
>> On Tue, 9 Dec 2008, Ryan Wagoner wrote:
>>
>>> The issue I've had with RAID 1 using mdadm is the disk's aren't
>>> consistent. I've noticed that unlike RAID 5 when a write is aborted
>>> mdadm doesn't completely write the data.
>>>
>>> When I run a check on the RAID 1 I always have inconsistencies where I
>>> have never had one on a RAID 5. The issue here is you never know if
>>> the inconsistencies can be ignored or are signs of a failing disk,
>>> etc.
>>>
>>> I sent an email to the list previously on this with no response.
>>>
>>> http://marc.info/?l=linux-raid&m=122572326107399&w=2
>>
>> I have asked about this before as well, do you have your swap on raid1? I
>> recall someone replying that it was normal if that is the case.
>>
>> Justin.
>>
>>
>
