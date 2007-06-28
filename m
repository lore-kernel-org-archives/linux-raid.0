From: Simon <simon.xhz@gmail.com>
Subject: Re: spare not becoming active
Date: Thu, 28 Jun 2007 12:06:09 -0400
Message-ID: <4683DC71.3050200@gmail.com>
References: <4682C9ED.9040503@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-reply-to: <4682C9ED.9040503@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

>     Number   Major   Minor   RaidDevice State
>        0       0        0        0      removed
>        1       8       34        1      active sync   /dev/sdc2
>        2       0        0        2      removed
> 
>        3       8       82        -      spare   /dev/sdf2
>        4       8       66        -      spare   /dev/sde2
>        5       8       50        -      faulty spare
>        6       8       18        -      faulty spare

I was trying a couple things, but never got to change this status.
At one point I stopped the array and restarted it, and it didn't work. (I did it 
before, so i don't see why...)

# /sbin/mdadm -R /dev/md0
mdadm: failed to run array /dev/md0: Invalid argument

I'm starting to think the documentation i read was very outdated, or only 
touched the subject in surface, can you guys recommend a good reading, like a 
companion to the man page?

Thanks,
   Simon



