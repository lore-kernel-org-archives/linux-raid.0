From: joystick <joystick@shiftmail.org>
Subject: Re: 3TB drives failure rate
Date: Sun, 28 Oct 2012 23:12:19 +0100
Message-ID: <508DADC3.4080104@shiftmail.org>
References: <11510711257.20121028131527@oudeis.org> <508D61A1.7020106@wildgooses.com> <508D65CF.1080904@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <508D65CF.1080904@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Joe Landman <joe.landman@gmail.com>
Cc: Ed W <lists@wildgooses.com>, =?ISO-8859-1?Q?Rainer_F=FCgenstein?= <rfu@oudeis.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 10/28/12 18:05, Joe Landman wrote:
> On 10/28/2012 12:47 PM, Ed W wrote:
>
>> - Green consumer drives likely are satisfactorarily reliable for most
>> uses, caveat that you accept they will fail catastrophically eventually
>> (just like your enterprise drive will).  We can debate the relative life
>> of each, but it's almost certainly just a linear factor...
>
> Our experience is that they aren't acceptable for RAIDs in most cases, 
> unless you turn on TLER, and turn off the green functions at minimum. 
> In which case, what advantage do they have other than price?

Do you have a magic way to turn on TLER on green drives and would like 
to share it with us?
I can give you money
smartctl scterc did not work there, last time I checked

> Part of the issue is them falling out of RAIDs.  Part of the the issue 
> are the occasional hiccups on coming out of sleep mode, which for most 
> desktops isn't a problem, but DEFINITELY an issue for RAIDs.

This thing of "drives falling out of RAID" I have heard many times, but 
really don't know what people are talking about.
How could a drive fall out of a RAID? A RAID is nothing special, it's 
just read/write commands given to a drive by a process called MD.
If the drive drops out of RAID it means it would have dropped out of a 
normal computer doing normal I/O
Please explain

>
> Another (sometimes significant) issue is that we've been noticing 
> partial coverage (e.g. missing functions) in some of the pages 
> available to sdparm with the desktop/consumer drives.  This is very 
> annoying, especially if you are building a RAID.  Most egregious on 
> SSDs, but we've seen one spinning rust device that did the same.

These sdparm missing feature also would interest me,
but actually less than a response to the other 2 topics above

