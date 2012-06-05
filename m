From: Joe Landman <joe.landman@gmail.com>
Subject: Re: Software RAID checksum performance on 24 disks not even close
 to kernel reported
Date: Mon, 04 Jun 2012 21:26:05 -0400
Message-ID: <4FCD602D.9080005@gmail.com>
References: <CA+4vN7wPd0Av_sbtA0JD5y=fGcsuq20SOQVHWnE8BUFpDxOEXQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CA+4vN7wPd0Av_sbtA0JD5y=fGcsuq20SOQVHWnE8BUFpDxOEXQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Ole Tange <ole@tange.dk>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 06/04/2012 07:14 PM, Ole Tange wrote:

> But I cannot explain why even the best performance (4600 MB/11s = 420
> MB/s) is not even close to the checksum performance reported by the
> kernel at boot (6196 MB/s):
>
>      Mar 13 16:02:42 server kernel: [   35.120035] raid6: using
> algorithm sse2x4 (6196 MB/s)
>
> Can you explain why I only get 420 MB/s of real world checksumming
> instead of 6196 MB/s?

In the best possible case, you would get 22x 1-disk bandwidth, which 
would be ~120MB/s (assuming RAID6, and "infinite" speed of checksum 
computation).  This is your "theoretical" upper bound on performance.

Your pragmatic upper bound on performance is reduced from the 
theoretical by many issues, including various hardware issues 
(controller, PCIe lanes, memory, disk, ...), as well as software (IO 
stack traversal, elevators, buffers/cache fills, ... etc.).

Aside from this, it is very rare that you will have a single application 
reading and writing at full stripe width all the time, which would be 
the optimal case for you.  There are some, and we've play with a number 
for our customers.  But they are the exception and not the rule.

Your real world IO performance for 24 disks is 420MB/s.  So this 
particular setup is, from your numbers, operating at about 16% peak 
efficiency per disk +/- some.  This is not uncommon for people's 
self-built systems.  The checksumming isn't your rate limiting feature. 
  Other things are.

Joe

>
>
> /Ole

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

