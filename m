From: Joe Landman <joe.landman@gmail.com>
Subject: Re: 3TB drives failure rate
Date: Sun, 28 Oct 2012 13:05:19 -0400
Message-ID: <508D65CF.1080904@gmail.com>
References: <11510711257.20121028131527@oudeis.org> <508D61A1.7020106@wildgooses.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <508D61A1.7020106@wildgooses.com>
Sender: linux-raid-owner@vger.kernel.org
To: Ed W <lists@wildgooses.com>
Cc: =?ISO-8859-1?Q?Rainer_F=FCgenstein?= <rfu@oudeis.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 10/28/2012 12:47 PM, Ed W wrote:

> - Green consumer drives likely are satisfactorarily reliable for most
> uses, caveat that you accept they will fail catastrophically eventually
> (just like your enterprise drive will).  We can debate the relative life
> of each, but it's almost certainly just a linear factor...

Our experience is that they aren't acceptable for RAIDs in most cases, 
unless you turn on TLER, and turn off the green functions at minimum. 
In which case, what advantage do they have other than price?

Part of the issue is them falling out of RAIDs.  Part of the the issue 
are the occasional hiccups on coming out of sleep mode, which for most 
desktops isn't a problem, but DEFINITELY an issue for RAIDs.

Another (sometimes significant) issue is that we've been noticing 
partial coverage (e.g. missing functions) in some of the pages available 
to sdparm with the desktop/consumer drives.  This is very annoying, 
especially if you are building a RAID.  Most egregious on SSDs, but 
we've seen one spinning rust device that did the same.

There's not a huge difference in pricing between the two types, and your 
time is valuable.  I'd argue for the lower time cost as part of a longer 
term lower TCO.  We've built systems with both types of drives, but 
based upon the experiences with desktop/consumer drives, we'd have to 
advise avoiding this route if possible.  The upfront money you might 
save will be spent more than likely on your time/efforts to repair 
hiccups in the system later.



-- 
Joseph Landman, Ph.D
Founder and CEO
Scalable Informatics Inc.
email: landman@scalableinformatics.com
web  : http://scalableinformatics.com
        http://scalableinformatics.com/sicluster
phone: +1 734 786 8423 x121
fax  : +1 866 888 3112
cell : +1 734 612 4615

